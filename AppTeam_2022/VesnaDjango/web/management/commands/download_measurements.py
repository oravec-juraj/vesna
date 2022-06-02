from django.conf import settings
from django.core.management import BaseCommand

from iot_api_client import Configuration, ApiException
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session
import iot_api_client as iot

from web.models import Device
from web.models import DeviceProperty
from web.models import Measurement


class Command(BaseCommand):
    help = 'Download measurements from aruduino IoT Cloud'

    def handle(self, *args, **options):
        oauth_client = BackendApplicationClient(client_id=settings.ARDUINO_CLIENT_ID)
        token_url = "https://api2.arduino.cc/iot/v1/clients/token"

        oauth = OAuth2Session(client=oauth_client)
        token = oauth.fetch_token(
            token_url=token_url,
            client_id=settings.ARDUINO_CLIENT_ID,
            client_secret=settings.ARDUINO_CLIENT_SECRET,
            include_client_id=True,
            audience="https://api2.arduino.cc/iot",
        )

        client_config = Configuration(host="https://api2.arduino.cc/iot")
        client_config.access_token = token['access_token']
        client = iot.ApiClient(client_config)

        things_api = iot.ThingsV2Api(client)
        properties_api = iot.PropertiesV2Api(client)

        try:
            things = things_api.things_v2_list()
        except ApiException as e:
            self.stderr.write(e)
            things = []

        for thing in things:
            try:
                device = Device.objects.get(pk=thing.id)
            except Device.DoesNotExist:
                device = Device(
                    id=thing.id
                )
            device.name = thing.name
            device.save()

            properties = properties_api.properties_v2_list(thing.id)

            for item in properties:
                if item.last_value == 'N/A':
                    continue

                try:
                    device_property = DeviceProperty.objects.get(pk=item.id)
                except DeviceProperty.DoesNotExist:
                    device_property = DeviceProperty(
                        pk=item.id
                    )

                device_property.name = item.name
                device_property.device = device

                if item.permission == 'READ_WRITE':
                    if item.type in ['INT', 'FLOAT']:
                        if item.min_value is not None:
                            device_property.widget = {
                                'type': 'range',
                                'step': item.update_parameter,
                                'min': item.min_value,
                                'max': item.max_value,
                                'device_id': thing.device_id
                            }
                        else:
                            device_property.widget = {
                                'type': 'range',
                                'step': item.update_parameter,
                                'min': 0,
                                'max': 255,
                                'device_id': thing.device_id
                            }

                device_property.save()

                if Measurement.objects.filter(
                        happened_at__gte=item.value_updated_at,
                        device_property=device_property
                ).exists():
                    continue

                measurement = Measurement.objects.create(
                    device_property=device_property,
                    value=item.last_value,
                    happened_at=item.value_updated_at
                )

                self.stdout.write(f"Creating measurement {measurement.id} with value: {measurement.value}")
