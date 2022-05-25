import uuid

from django.db import models


class Device(models.Model):
    class Meta:
        db_table = 'devices'
        default_permissions = ()
        app_label = 'web'

    id = models.UUIDField(primary_key=True)
    name = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)


class DeviceProperty(models.Model):
    class Meta:
        db_table = 'properties'
        default_permissions = ()
        app_label = 'web'

    id = models.UUIDField(primary_key=True)
    device = models.ForeignKey(Device, on_delete=models.CASCADE, related_name='device_properties')
    name = models.CharField(max_length=255)
    is_measurement = models.BooleanField(default=False)
    widget = models.JSONField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.device.name} - {self.name} ({self.id})"


class Measurement(models.Model):
    class Meta:
        db_table = 'measurements'
        default_permissions = ()
        app_label = 'web'

    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    device_property = models.ForeignKey(DeviceProperty, on_delete=models.CASCADE, related_name='measurements')
    value = models.DecimalField(max_digits=6, decimal_places=0)
    happened_at = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)