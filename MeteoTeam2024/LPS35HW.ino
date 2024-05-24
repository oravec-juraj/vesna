#include <Adafruit_LPS35HW.h>

Adafruit_LPS35HW lps35hw = Adafruit_LPS35HW();

#include <Wire.h>

void setup() {
      Serial.begin(9600);
      delay(10);
      Serial.println("SHT30 test");
      if (! lps35hw.begin(0x5d)) {   // Set to 0x45 for alternate i2c addr
      Serial.println("Couldn't find SHT30");
      while (1) delay(1);
      }
  }


void loop() {
  
    float t = lps35hw.readTemperature();
    float h = lps35hw.readHumidity();
    
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