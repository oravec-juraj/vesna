import pygal
from django.conf import settings
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.management import call_command
from django.db.models import Avg, CharField, Value
from django.db.models.functions import Concat, Cast, ExtractYear, TruncDate, ExtractMonth, ExtractDay, ExtractHour
from django.shortcuts import render, redirect
from django.utils.translation import gettext as _
from django.views import View

from iot_api_client import Configuration, ApiException
from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session
import iot_api_client as iot

from web.models import Device
from web.models import DeviceProperty

from web.models import Measurement


class ListDevices(View):
    def get(self, request):
        devices = Device.objects.all()

        return render(request, 'devices/list_devices.html', context={
            'devices': devices
        })


class DeviceDetail(View):
    def get(self, request):
        device_properties = DeviceProperty.objects.filter(is_measurement=True)
        charts = []

        for device_property in device_properties:
            # measurements = Measurement.objects.filter(
            #     device_property=device_property
            # ).values('happened_at__date').order_by('happened_at__date').annotate(
            #     data_avg=Avg('value')
            # )

            measurements = Measurement.objects.filter(
                device_property=device_property
            ).annotate(
                date_hour=Concat(
                    Cast(ExtractYear(TruncDate('happened_at')), CharField()),
                    Value('-'),
                    Cast(ExtractMonth(TruncDate('happened_at')), CharField()),
                    Value('-'),
                    Cast(ExtractDay(TruncDate('happened_at')), CharField()),
                    Value('-'),
                    Cast(ExtractHour('happened_at'), CharField()),
                )
            ).values('date_hour').order_by('date_hour').annotate(
                data_avg=Avg('value')
            )
            chart = pygal.Line(show_legend=False, human_readable=True)
            # chart.x_labels = list(map(lambda item: str(item['happened_at__date'].strftime('%d.%m')), measurements))
            chart.x_labels = list(map(lambda item: item['date_hour'], measurements))
            chart.add(_('Measurements'), list(map(lambda item: item['data_avg'], measurements)))
            charts.append({
                'data': chart.render_data_uri(),
                'title': device_property.name,
                'widget': device_property.widget,
                'id': device_property.id,
                'value': device_property.measurements.latest('happened_at').value
            })

        return render(request, 'devices/detail.html', context={
            'charts': charts
        })


class DevicePropertyUpdate(View, LoginRequiredMixin):
    def post(self, request):
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

        properties_api = iot.PropertiesV2Api(client)
        device_property = DeviceProperty.objects.get(pk=request.POST.get('id'))

        properties_api.properties_v2_publish(
            str(device_property.device.id),
            str(device_property.id),
            {
                'device_id': device_property.widget['device_id'],
                'value': request.POST.get('value')
            }
        )

        call_command('download_measurements')

        return redirect('device-detail')
