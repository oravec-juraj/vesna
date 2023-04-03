int max_voltage = 12.7;     // volts
const int voltage = 32;      // analgovy pin 32

void setup() {
  Serial.begin(115200);
}

void loop() {
  // Reading potentiometer value
  int volt_value = analogRead(voltage);
  float u = 0.78730383 + 0.004172825*volt_value;
  Serial.println(u,4);
  //delay(500);
  // map(value, fromLow, fromHigh, toLow, toHigh)
  //int vv= map(u,0,4095,0.834623667,2327.566);
  //int batt = 100 - (max_voltage - vv)/2.2*100;
  //Serial.println(batt);
  delay(800);
}
