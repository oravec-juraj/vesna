/*********
  VESNA
*********/
HardwareSerial Sender(2);



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

const char* ssid = "WIAM GUEST";
const char* password = "yK64!8VGTYiF";
//const char* serverName = "http://localhost/get-sensor";
unsigned long lastTime = 0;
unsigned long timerDelay = 5000;
const char* myWriteAPIKey = "73IPXY88S5YZF2F1"; //ThingSpeak write API Key
const char* myReadAPIKey = "24X1XL0W6VDHEXV7"; //ThingSpeak read API Key
unsigned long myChannelNumber = 1632859; //ThingSpeak channel number
WiFiClient client;

#define  TempUp 18
#define  TempDown 4
#define LIGHTSENSORPIN 32
#define SEALEVELPRESSURE_HPA (1013.25)
#define DHTPIN 33 
#define DHTTYPE DHT21
#define Sender_Txd_pin 17
#define Sender_Rxd_pin 16
String myStatus;
float reading;
bool JsonFlag = true;
bool WifiFlag = true;

hw_timer_t * timer0 = NULL;
hw_timer_t * timer1 = NULL;

portMUX_TYPE timerMux0 = portMUX_INITIALIZER_UNLOCKED;
portMUX_TYPE timerMux1 = portMUX_INITIALIZER_UNLOCKED;


OneWire TempUpOneWire(TempUp);
OneWire TempDownOneWire(TempDown);
DHT dht(DHTPIN, DHTTYPE);
DallasTemperature TempUpSensor(&TempUpOneWire);
DallasTemperature TempDownSensor(&TempDownOneWire);
Adafruit_BME680 bme; // I2C



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

void loop(void){ 
    // Tell BME680 to begin measurement.
  unsigned long endTime = bme.beginReading();
  if (endTime == 0) {
    //Serial.println(F("Failed to begin reading :("));
    return;
  }
  if (!bme.endReading()) {
    //Serial.println(F("Failed to complete reading :("));
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

       //if(x == 200){
//       Serial.println("Channel updated successfuly.");
//       }
//       else{
//       Serial.println("Problem updating channel. HTTP error code " + String(x));
//       }

    
    if (Serial.available() > 1) {
    String matlab_u = Serial.readString();                               
    Sender.print(matlab_u);
    }                        


}
