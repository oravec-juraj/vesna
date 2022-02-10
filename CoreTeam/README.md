# Technical Documentation
## Core Team
---
**Version 1.0.0**

## Table of contents
* [General info](#general-info)
* [Code](#Code-with-tasks-descriptions)
* [Setup](#setup)

## General info
The Core Team breathes life into the smart eco greenhouse device. The main goal of the Core Team is to implement data processing on the embedded hardware. Implemented communication enables effective data exchange between embedded hardware (microcontroller, sensors, actuators), server for autonomous control (via Bluetooth), and cloud (via WiFi). The Core Team mainly operates in development environments for embedded platforms (C/C++) and cloud communication technologies.
	
## tools
Project is created with:
* Arduino IDE version: 1.8.19
* C (programming language)

## Code with tasks descriptions

# ESP32 Sennzors #1
Completed Tasks in this section of code:
<li>data processing of temperature</li>
<li>data processing of humidity moisture</li>
<li>data processing of luminosity</li>
<li>data export (including logging) to cloud via WiFi</li>
<li>data import (control settings) from the cloud via WiFi</li>
<li>data processing of air moisture</li>
<li>data processing of air quality</li>

#### Code

<li>Define esp as a sender</li>

```
  HardwareSerial Sender(2);
  
  #define Sender_Txd_pin 17
  #define Sender_Rxd_pin 16
```

<li>Importation of required libraries</li>

```
  #include <ArduinoJson.h>
  #include <OneWire.h>
  #include <DallasTemperature.h>
  #include <Wire.h>
  #include <Adafruit_Sensor.h>
  #include "Adafruit_BME680.h"
  #include "DHT.h"
  #include <WiFi.h>
  #include <HTTPClient.h>
  #include "ThingSpeak.h"
```

<li>Defining constants</li>

```
  const char* ssid = "WIAM GUEST";
  const char* password = "yK64!8VGTYiF";
  //const char* serverName = "http://localhost/get-sensor";
  unsigned long lastTime = 0;
  unsigned long timerDelay = 5000;
  //const char* myWriteAPIKey = "Z9FTQ3977X6U4BA0"; //ThingSpeak write API Key
  //const char* myReadAPIKey = "SIZ4L7C4N68KY1F7"; //ThingSpeak read API Key
  //unsigned long myChannelNumber = 1548631; //ThingSpeak channel number
  const char* myWriteAPIKey = "73IPXY88S5YZF2F1"; //ThingSpeak write API Key
  const char* myReadAPIKey = "24X1XL0W6VDHEXV7"; //ThingSpeak read API Key
  unsigned long myChannelNumber = 16328591; //ThingSpeak channel number
  WiFiClient client;
  String myStatus;
  float reading;
  bool JsonFlag = true;
  bool WifiFlag = true;
```

<li>Defining senzors and pins</li>

```
  #define  TempUp 4
  #define  TempDown 18
  #define LIGHTSENSORPIN 32
  #define SEALEVELPRESSURE_HPA (1013.25)
  #define DHTPIN 33 
  #define DHTTYPE DHT21
```

<li>Timer</li>

```bash
  hw_timer_t * timer0 = NULL;
  hw_timer_t * timer1 = NULL;

  portMUX_TYPE timerMux0 = portMUX_INITIALIZER_UNLOCKED;
  portMUX_TYPE timerMux1 = portMUX_INITIALIZER_UNLOCKED;
```

<li>???</li>

```
  OneWire TempUpOneWire(TempUp);
  OneWire TempDownOneWire(TempDown);
  DHT dht(DHTPIN, DHTTYPE);
  DallasTemperature TempUpSensor(&TempUpOneWire);
  DallasTemperature TempDownSensor(&TempDownOneWire);
  Adafruit_BME680 bme; // I2C
```

## Loops

<li>Timer 0 and 1 loop</li>

```
void IRAM_ATTR onTimer0(){
  // Critical Code here
portENTER_CRITICAL_ISR(&timerMux0);
JsonFlag = true;
portEXIT_CRITICAL_ISR(&timerMux0);
}

void IRAM_ATTR onTimer1(){
  // Critical Code here
    portENTER_CRITICAL_ISR(&timerMux1);
    WifiFlag = true;
    portEXIT_CRITICAL_ISR(&timerMux1);
}
```
<li>Setup loop</li>
Start serial communication with baud rates 115200

```
void setup(void)
{
  // Start serial communication for debugging purposes
  Serial.begin(115200);    
  WiFi.begin(ssid, password);
  ThingSpeak.begin(client); 
  Sender.begin(115200, SERIAL_8N1, Sender_Txd_pin, Sender_Rxd_pin); 
      
  TempUpSensor.begin();
  TempDownSensor.begin();
  dht.begin();
  
  while (!Serial);
  Serial.println(F("BME680 async test"));

  if (!bme.begin()) {
    Serial.println(F("Could not find a valid BME680 sensor, check wiring!"));
    while (1);
  }
  bme.setTemperatureOversampling(BME680_OS_8X);
  bme.setHumidityOversampling(BME680_OS_2X);
  bme.setPressureOversampling(BME680_OS_4X);
  bme.setIIRFilterSize(BME680_FILTER_SIZE_3);
  bme.setGasHeater(320, 150); // 320*C for 150 ms

  timer0 = timerBegin(0, 80, true);  // timer 0, MWDT clock period = 12.5 ns * TIMGn_Tx_WDT_CLK_PRESCALE -> 12.5 ns * 80 -> 1000 ns = 1 us, countUp
  timerAttachInterrupt(timer0, &onTimer0, true); // edge (not level) triggered 
  timerAlarmWrite(timer0, 5000000, true); // 2000000 * 1 us = 2 s, autoreload true
  timerAlarmEnable(timer0); // enable
    
  timer1 = timerBegin(1, 80, true);  // timer 1, MWDT clock period = 12.5 ns * TIMGn_Tx_WDT_CLK_PRESCALE -> 12.5 ns * 80 -> 1000 ns = 1 us, countUp
  timerAttachInterrupt(timer1, &onTimer1, true); // edge (not level) triggered 
  timerAlarmWrite(timer1, 30000000, true); //  * 1 us =  ms, autoreload true
  timerAlarmEnable(timer1); // enable
}
```

<li>Main loop</li>
Data collection from sensors and ESP32, sending data to thingspeak and receiving and sending action interventions

```
void loop(void){ 
    // Tell BME680 to begin measurement.
  unsigned long endTime = bme.beginReading();
  if (endTime == 0) {
    Serial.println(F("Failed to begin reading :("));
    return;
  }
  if (!bme.endReading()) {
    Serial.println(F("Failed to complete reading :("));
    return;
  }
    //TEMPERATURE
    //sensors.requestTemperatures();
    TempUpSensor.requestTemperatures();
    TempDownSensor.requestTemperatures();
    // LIGHT SENZOR
    float volts = analogRead(LIGHTSENSORPIN) * 3.3 / 4096.0;
    float amps = volts / 10000.0; // across 10,000 Ohms
    float microamps = amps * 1000000;
    float lux = microamps * 2.0;
    
    if(JsonFlag == true){
    DynamicJsonDocument doc(1024);
    JsonObject root = doc.to<JsonObject>();
    root["TemperatureTop_DS1bb20"] = float(TempUpSensor.getTempCByIndex(0));
    root["TemperatureBottom_DS1bb20"] = float(TempDownSensor.getTempCByIndex(0));
    root["TemperatureRight_BME680"] = float(bme.temperature);
    root["TemperatureLeft_DHT21"] = float(dht.readTemperature());
    root["Light_TEMP6000"] = float(lux);
    root["Preasure_BME680"] = float(bme.pressure/1000.0);
    root["HumidityRight_BME680"] = float(bme.humidity);
    root["HumidityLeft_DHT21"] = float(dht.readHumidity());
    Serial.println();
    serializeJson(doc, Serial);
    JsonFlag = false;
      if(WifiFlag == true){
      float a = root["TemperatureTop_DS1bb20"];
      float b = root["TemperatureBottom_DS1bb20"];
      float c = root["TemperatureRight_BME680"];
      float d = root["TemperatureLeft_DHT21"];
      float AverageTemperature = (a+b+c+d)/4;
      float Light = root["Light_TEMP6000"];
      float Pressure = root["Preasure_BME680"];
      float e = root["HumidityRight_BME680"];
      float f = root["HumidityLeft_DHT21"];
      float AverageHumidity = (e+f)/2;
      // fields in ThingSpeak
         ThingSpeak.setField(1, AverageTemperature);
         ThingSpeak.setField(2, Light);
         ThingSpeak.setField(3, Pressure);
         ThingSpeak.setField(4, AverageHumidity);

         // write to the ThingSpeak channel
         int x = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
         WifiFlag = false;
      }
    }    
    if (Serial.available() > 1) {
    String matlab_u = Serial.readString();                               
    Sender.print(matlab_u);
    }                               
}
```

# ESP32 Actuators #2
Completed Tasks in this section of code:
<li>data processing of airflow</li>
<li>data processing of humidity moisturedata processing of air moisturedata processing of luminosity</li>
<li>data export (including logging) to cloud via WiFi</li>
<li>data import (control settings) from the cloud via WiFi</li>
<li>data processing of air moisture</li>
<li>data processing of air quality</li>

#### Code

<li>Define esp as a sender</li>

```
  HardwareSerial Receiver(2);
  
  #define Receiver_Txd_pin 17
  #define Receiver_Rxd_pin 16
```

<li>Importation of required libraries</li>

```
  #include <ArduinoJson.h>
```

<li>Defining constants</li>

```
String received_matlab_u;

const int ledPin = 4;  // led right
const int ledPin2 = 5; // led left
const int fanPin = 26;  // fan right
const int fanPin2 = 32; // fa =n left
const int heaterPin = 25; // heater
const int pumpPin = ;
// setting PWM properties
const int freq = 5000;
const int ledChannel = 0;
const int fanChannel = 1;
const int heaterChannel = 2;
const int heaterChannel = 3;
const int resolution = 8;
```

## Loops
<li>Setup loop for init actutors</li>

```
void setup() {
    // configure LED PWM functionalitites
  ledcSetup(ledChannel, freq, resolution);
  ledcSetup(fanChannel, freq, resolution);
  ledcSetup(heaterPin, freq, resolution);
  ledcSetup(pumpPin, freq, resolution);
  // attach the channel to the GPIO to be controlled
  ledcAttachPin(ledPin, ledChannel);
  ledcAttachPin(ledPin2, ledChannel);
  ledcAttachPin(fanPin, fanChannel);
  ledcAttachPin(fanPin2, fanChannel);
  ledcAttachPin(heaterPin, heaterChannel);
  //ledcAttachPin(pumpPin, heaterChannel);
  Serial.begin(115200);                                                   // Define and start serial monitor
  Receiver.begin(115200, SERIAL_8N1, Receiver_Txd_pin, Receiver_Rxd_pin); // Define and start Receiver serial port
}
```

<li>Main loop for controlling acutators</li>

```
void loop() {
 while (Receiver.available()) {                         
    String input = Receiver.readString(); 
    Serial.println(input);   
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, input);
    JsonObject obj = doc.as<JsonObject>();
    float temp = doc["Temperature_DS1bb20_UP"];
    Serial.println(temp);
    float a = doc["LED"];
    float b = doc["FAN"];
    float c = doc["HEATER"];
    float d = doc["PUMP"];
    
    Serial.println(a);
    int dutyCycle = round(a*255.0/100.0);
    Serial.println(dutyCycle);
    ledcWrite(ledChannel, dutyCycle);
    
    Serial.println(b);
    int dutyCyclefan = round(b*255.0/100.0);
    Serial.println(dutyCyclefan);
    ledcWrite(fanChannel, dutyCyclefan);
    
    Serial.println(c);
    int dutyCycleheater = round(c*255.0/100.0);
    Serial.println(dutyCycleheater);
    //ledcWrite(heaterPin, dutyCycleheater);
    ledcWrite(heaterChannel, dutyCycleheater);
    delay(10);

    Serial.println(d);
    int dutyCyclepump = round(d*255.0/100.0);
    Serial.println(dutyCyclepump);
    ledcWrite(pumpChannel, dutyCyclepump);
    delay(1000)
    ledcWrite(pumpChannel, dutyCyclepump);
  };
}
```

## Setup
To run this project, install:
* Arduino IDE

---
## Licence & copyright
© Michal Krištof, The Faculty of Chemical and Food Technology in Bratislava, Department of Information Engineering and Process Control (DIEPC)<br>
© Jakub Puk, The Faculty of Chemical and Food Technology in Bratislava, Department of Information Engineering and Process Control (DIEPC)<br>
© Michaela Vogl, The Faculty of Chemical and Food Technology in Bratislava, Department of Information Engineering and Process Control (DIEPC)<br>
