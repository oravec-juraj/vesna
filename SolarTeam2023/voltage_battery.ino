#define voltage 32
int max_voltage = 13.16;     // volts
double k[4] = {-0.000000000130258, 0.000000681140636, 0.002928834749319, 1.008338133871746}; 
unsigned long Sum;
unsigned long Average;
float batt;
int volt_value;
void setup() {
  Serial.begin(115200);
  pinMode(voltage, INPUT);
}

void loop() {
  // Reading potentiometer value
  Sum = 0;        //Initialize/reset
  //Take 1000 readings, find average.  This loop takes about 100ms.
  for (int i = 0; i < 100; i++)
  {
    Sum += analogRead(voltage); 
    delay(4);       
  }
  volt_value = Sum/100;
  
  //int volt_value = analogRead(voltage);
  float u = float(volt_value)*float(volt_value)*float(volt_value)*k[0] + float(volt_value)*float(volt_value)*k[1] + float(volt_value)*k[2]+k[3];
  Serial.print("voltage: ");
  Serial.println(u);
  //delay(500);
  //int batt = 100 - (max_voltage - Average)/1.82*100;
  if(u > 2)
  {
    batt = constrain(u, 11.34, 12.5);
    batt = map(batt, 11.34 ,12.5 ,0.0 ,100.0);
    Serial.print("batt: ");
    Serial.println(batt);
  }
  else
  {
    Serial.println("Battery not connected!");
  }
  delay(200);
}
