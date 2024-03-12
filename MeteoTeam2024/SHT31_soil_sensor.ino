#include "Adafruit_SHT31.h" //https://github.com/adafruit/Adafruit_SHT31/archive/master.zip
Adafruit_SHT31 sht30 = Adafruit_SHT31();

#include <Wire.h>

void setup() {
      Serial.begin(9600);
      delay(10);
      Serial.println("SHT30 test");
      if (! sht30.begin(0x44)) {   // Set to 0x45 for alternate i2c addr
      Serial.println("Couldn't find SHT30");
      while (1) delay(1);
      }


  }


void loop() {
  
    float t = sht30.readTemperature();
    float h = sht30.readHumidity();
    
    if (! isnan(t)) {  // check if 'is not a number'
    Serial.print("Temp *C = "); Serial.println(t);
    }
    else {    
    t=0.0;
    Serial.println("Failed to read temperature");
    }
    
    if (! isnan(h)) {  // check if 'is not a number'
    Serial.print("Hum. % = "); Serial.println(h);
    }
    else { 
    h=0.0;
    Serial.println("Failed to read humidity");    
    }
    Serial.println();
    delay(500);

}
