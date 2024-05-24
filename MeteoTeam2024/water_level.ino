#define LIQUID_LEVEL_PIN 5 // Define the GPIO pin number connected to the sensor
//#SEN0205 DRFBOT

void setup() {
  Serial.begin(115200); // Start the serial communication
  pinMode(LIQUID_LEVEL_PIN, INPUT); // Set the liquid level pin as input
}

void loop() {
  int liquidLevel = digitalRead(LIQUID_LEVEL_PIN); // Read the liquid level: HIGH when liquid is detected, LOW otherwise
  if (liquidLevel == HIGH) {
    Serial.println("Liquid detected!");
  } else {
    Serial.println("No liquid detected.");
  }
  delay(1000); // Wait for a second before the next reading
}
