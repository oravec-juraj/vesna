# Generated by Django 4.0.3 on 2022-05-24 19:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('web', '0002_deviceproperty_is_measurement'),
    ]

    operations = [
        migrations.AddField(
            model_name='deviceproperty',
            name='widget',
            field=models.JSONField(null=True),
        ),
    ]