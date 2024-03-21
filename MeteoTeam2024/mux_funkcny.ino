#include <Wire.h>
#include "Adafruit_SHT31.h"
#include <Adafruit_LPS35HW.h>
#include "Adafruit_SHT4x.h"


Adafruit_SHT31 sht30 = Adafruit_SHT31(); //soil //1
Adafruit_LPS35HW lps35hw = Adafruit_LPS35HW(); //2
Adafruit_SHT4x sht4 = Adafruit_SHT4x();//sht45//3
Adafruit_SHT31 sht31 = Adafruit_SHT31();//fs400//4

const byte muxAddress = 0x70;

// Select I2C BUS
void TCA9548A(uint8_t bus){
  Wire.beginTransmission(0x70);  // TCA9548A address
  Wire.write(1 << bus);          // send byte to select bus
  Wire.endTransmission();
}

void printValues1(Adafruit_SHT31 sht30, int bus){
  TCA9548A (bus);
  float t30 = sht30.readTemperature();
  float h30 = sht30.readHumidity();
  
    if (!isnan(t30)) {
        Serial.print("SHT30 Temperature: ");
        Serial.print(t30);
        Serial.println(" *C");
    } else {
        Serial.println("Failed to read temperature from SHT30");
    }

    if (!isnan(h30)) {
        Serial.print("SHT30 Humidity: ");
        Serial.print(h30);
        Serial.println(" %");
    } else {
        Serial.println("Failed to read humidity from SHT30");
    }

}

void printValues2(Adafruit_LPS35HW lps35hw, int bus){
  TCA9548A (bus);
  float tLPS35hw = lps35hw.readTemperature();
  float pressureLPS35hw = lps35hw.readPressure();

  
   if (!isnan(tLPS35hw)) {
        Serial.print("LPS35HW Temperature: ");
        Serial.print(tLPS35hw);
        Serial.println(" *C");
    } else {
        Serial.println("Failed to read temperature from LPS35HW");
    }

    if (!isnan(pressureLPS35hw)) {
        Serial.print("LPS35HW Pressure: ");
        Serial.print(pressureLPS35hw);
        Serial.println(" hPa");
    } else {
        Serial.println("Failed to read pressure from LPS35HW");
    }

}

void printValues3(Adafruit_SHT4x sht4, int bus){
  TCA9548A (bus);
  sensors_event_t hlps45, tlps45; // Used for both temp and humidity
  tlps45.temperature = 0.0; // Initialize the temperature variable

  uint32_t timestamp = millis();
  sht4.getEvent(&hlps45, &tlps45); // Only temp is needed here, humidity could be read with another call or nullptr if unused
  timestamp = millis() - timestamp;
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


}


void printValues4(Adafruit_SHT31 sht31, int bus){
  TCA9548A (bus);
  float tfs400 = sht31.readTemperature();
  float hfs400 = sht31.readHumidity();

   if (!isnan(tfs400)) {
        Serial.print("LPS35HW Temperature: ");
        Serial.print(tfs400);
        Serial.println(" *C");
    } else {
        Serial.println("Failed to read temperature from sht31");
    }

    if (!isnan(hfs400)) {
        Serial.print("sht31 Humidity: ");
        Serial.print(hfs400);
        Serial.println(" %");
    } else {
        Serial.println("Failed to read Humidity from sht31");
    }

}

void setup() 
{
  Serial.begin(115200);
  delay(10);
  Wire.begin(); 

    //Serial.println(sht4.readSerial(), HEX);
    //sht4.setPrecision(SHT4X_HIGH_PRECISION);
    //sht4.setHeater(SHT4X_NO_HEATER);

  //1
  TCA9548A(0);
  if (!sht30.begin(0x44)) {
    Serial.println("Could not find a valid sht30 sensor on bus 1, check wiring!");
    while (1);
  }
  Serial.println(); 
  delay(30);
 //2
   TCA9548A(1);
  if (!lps35hw.begin_I2C(0x5d)) {
    Serial.println("Could not find a valid lps35hw sensor on bus 2, check wiring!");
    while (1);
  }
  Serial.println(); 
  delay(30);

  //3
    TCA9548A(2);
  if (!sht4.begin()) {
    Serial.println("Could not find a valid sht4 sensor on bus 3, check wiring!");
    while (1);
  }
  Serial.println(); 
  delay(30);
  //4
    TCA9548A(3);
  if (!sht31.begin(0x44)) {
    Serial.println("Could not find a valid sht31 sensor on bus 4, check wiring!");
    while (1);
  }
  Serial.println(); 
  delay(30);
}

void loop() {
  //fotorezistor
  int sensorValue = analogRead(15);
  // print out the value you read:
  Serial.println(sensorValue);

  printValues1(sht30, 0);
  delay(30);
  printValues2(lps35hw, 1);
  delay(30);
  printValues3(sht4, 2);
  delay(30);
  printValues4(sht31, 3);

  delay(2000);
}