void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 15:
  int sensorValue = analogRead(15);

  // print out the value you read:
  Serial.println(sensorValue);
  delay(1000);
  }
