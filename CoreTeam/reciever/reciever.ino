// Sending/Receiving example

HardwareSerial Receiver(2); // Define a Serial port instance called 'Receiver' using serial port 2
#include <WiFi.h>
#include <HTTPClient.h>
#include "ThingSpeak.h"
#include <ArduinoJson.h>
#define Receiver_Txd_pin 17
#define Receiver_Rxd_pin 16
String received_matlab_u;

const char* ssid = "WIAM GUEST";
const char* password = "yK64!8VGTYiF";
const char* myWriteAPIKey = "32KH2SWBZ1VTDNTG"; //ThingSpeak write API Key
//const char* myReadAPIKey = ""; //ThingSpeak read API Key
unsigned long myChannelNumber = 1635834; //ThingSpeak channel number
WiFiClient client;
bool WifiFlag = true;

const int ledPin = 4;  // led right
const int ledPin2 = 5; // led left
const int fanPin = 26;  // fan right
const int fanPin2 = 32; // fan left
const int heaterPin = 25; // heater
const int pumpPin = 19;

// setting PWM properties
const int freq = 5000;

const int ledChannel = 0;
const int fanChannel = 1;
const int heaterChannel = 2;
const int pumpChannel = 3;

const int resolution = 8;

hw_timer_t * timer1 = NULL;
portMUX_TYPE timerMux1 = portMUX_INITIALIZER_UNLOCKED;

void IRAM_ATTR onTimer1(){
  // Critical Code here
    portENTER_CRITICAL_ISR(&timerMux1);
    WifiFlag = true;
    portEXIT_CRITICAL_ISR(&timerMux1);
}

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
  ledcAttachPin(pumpPin, pumpChannel);
  
  Serial.begin(115200);                                                   // Define and start serial monitor
  WiFi.begin(ssid, password);
  ThingSpeak.begin(client); 
  Receiver.begin(115200, SERIAL_8N1, Receiver_Txd_pin, Receiver_Rxd_pin); // Define and start Receiver serial port

  timer1 = timerBegin(1, 80, true);  // timer 1, MWDT clock period = 12.5 ns * TIMGn_Tx_WDT_CLK_PRESCALE -> 12.5 ns * 80 -> 1000 ns = 1 us, countUp
  timerAttachInterrupt(timer1, &onTimer1, true); // edge (not level) triggered 
  timerAlarmWrite(timer1, 30000000, true); //  * 1 us =  ms, autoreload true
  timerAlarmEnable(timer1); // enable

}
 
void loop() {
 while (Receiver.available()) {                         
    String input = Receiver.readString(); 
    Serial.println(input);   
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, input);
    JsonObject obj = doc.as<JsonObject>();
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
    ledcWrite(heaterChannel, dutyCycleheater);    

    Serial.println(d);
    int dutyCyclepump = round(d*255.0/100.0);
    Serial.println(dutyCyclepump);
    ledcWrite(pumpChannel, dutyCyclepump);
    delay(2000);
    ledcWrite(pumpChannel, 0);
    
        if(WifiFlag == true){
    // fields in ThingSpeak
       ThingSpeak.setField(1, a);
       ThingSpeak.setField(2, b);
       ThingSpeak.setField(3, c);
       ThingSpeak.setField(4, d);
       
       // write to the ThingSpeak channel
       int x = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
       WifiFlag = false;
    }

  };
}
