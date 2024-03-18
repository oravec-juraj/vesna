#include <Wire.h>
#include "Adafruit_SHT31.h"
#include <Adafruit_LPS35HW.h>
#include "Adafruit_SHT4x.h"

Adafruit_SHT31 sht30 = Adafruit_SHT31();//sht30
Adafruit_LPS35HW lps35hw = Adafruit_LPS35HW();
Adafruit_SHT4x sht4 = Adafruit_SHT4x();
Adafruit_SHT31 sht31 = Adafruit_SHT31();//shtxx


void setup() {
    Serial.begin(9600);
    delay(10);



    if (!lps35hw.begin_I2C()) {
        Serial.println("Couldn't find LPSHW35");
        while (1) delay(1);
    }

    if (!sht4.begin()) {
        Serial.println("Couldn't find SHT4x");
        while (1) delay(1);
    }

     if (! sht31.begin(0x45)) {   // Set to 0x45 for alternate i2c addr
      Serial.println("Couldn't find SHT31");
      while (1) delay(1);
      }
    if (!sht30.begin(0x44)) {
            Serial.println("Couldn't find SHT30");
            while (1) delay(1);
        }

    Serial.print("Serial number 0x");
    Serial.println(sht4.readSerial(), HEX);
    sht4.setPrecision(SHT4X_HIGH_PRECISION);
    sht4.setHeater(SHT4X_NO_HEATER);
}

void loop() {
    float t30 = sht30.readTemperature();
    float h30 = sht30.readHumidity();

    float tLPS35hw = lps35hw.readTemperature();
    float pressureLPS35hw = lps35hw.readPressure();

    float tfs400 = sht31.readTemperature();
    float hfs400 = sht31.readHumidity();

    sensors_event_t hlps45, tlps45; // Used for both temp and humidity
    tlps45.temperature = 0.0; // Initialize the temperature variable

    uint32_t timestamp = millis();
    sht4.getEvent(&hlps45, &tlps45); // Only temp is needed here, humidity could be read with another call or nullptr if unused
    timestamp = millis() - timestamp;

    if (!isnan(t30)) {
        Serial.print("SHT30 Temperature: ");
        Serial.print(t30);
        Serial.println(" *C");
    } else {
        Serial.println("Failed to read temperature from SHT30");
    }

    if (!isnan(tLPS35hw)) {
        Serial.print("LPS35HW Temperature: ");
        Serial.print(tLPS35hw);
        Serial.println(" *C");
    } else {
        Serial.println("Failed to read temperature from LPS35HW");
    }

    if (!isnan(h30)) {
        Serial.print("SHT30 Humidity: ");
        Serial.print(h30);
        Serial.println(" %");
    } else {
        Serial.println("Failed to read humidity from SHT30");
    }

    if (!isnan(pressureLPS35hw)) {
        Serial.print("LPS35HW Pressure: ");
        Serial.print(pressureLPS35hw);
        Serial.println(" hPa");
    } else {
        Serial.println("Failed to read pressure from LPS35HW");
    }

    if (!isnan(tlps45.temperature)) {
        Serial.print("SHT45 Temperature: ");
        Serial.print(tlps45.temperature);
        Serial.println(" *C");
    } else {
        Serial.println("Failed to read temperature from SHT45");
    }

    if (!isnan(hlps45.relative_humidity)) {
        Serial.print("SHT45 Humidity: ");
        Serial.print(hlps45.relative_humidity);
        Serial.println(" %");
    } else {
        Serial.println("Failed to read humidity from SHT45");
    }

    if (! isnan(tfs400)) {  // check if 'is not a number'
    Serial.print("Temp *C = "); Serial.println(tfs400);
    }
    else {    
    tfs400=0.0;
    Serial.println("Failed to read temperature");
    }
    
    if (! isnan(hfs400)) {  // check if 'is not a number'
    Serial.print("Hum. % = "); Serial.println(hfs400);
    }
    else { 
    hfs400=0.0;
    Serial.println("Failed to read humidity");    
    }


    Serial.println();
    delay(500);
}
