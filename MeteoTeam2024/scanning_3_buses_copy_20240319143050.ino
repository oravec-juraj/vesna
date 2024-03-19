#include <Wire.h>

void setup() 
{
  Serial.begin(115200);

  Wire.begin();             // default: 21, 22
  Wire1.begin( 19, 20);     // I don't know the default pins !
  Wire1.begin(12, 13);      // Second additional I2C bus on GPIO 18 (SDA), GPIO 19 (SCL), adjust pins as needed


  Serial.println("---------- Scanning Wire -------------");
  I2C_ScannerWire();

  Serial.println("---------- Scanning Wire1 ------------");
  I2C_ScannerWire1();

   Serial.println("---------- Scanning Wire2 ------------");
  I2C_ScannerWire2(); // Scan for devices on the second additional I2C bus
}

void loop() { delay(10); }

void I2C_ScannerWire()
{
  byte error, address;
  int nDevices;

  Serial.println("Scanning...");

  nDevices = 0;
  for(address = 1; address < 127; address++ )
  {
    Wire.beginTransmission(address);
    error = Wire.endTransmission();

    if (error == 0)
    {
      Serial.print("I2C device found at address 0x");
      if (address<16)
        Serial.print("0");
      Serial.print(address,HEX);
      Serial.println("  !");

      nDevices++;
    }
    else if (error==4)
    {
      Serial.print("Unknown error at address 0x");
      if (address<16)
        Serial.print("0");
      Serial.println(address,HEX);
    }    
  }
  if (nDevices == 0)
    Serial.println("No I2C devices found\n");
  else
    Serial.println("done\n");
}

void I2C_ScannerWire1()
{
  byte error, address;
  int nDevices;

  Serial.println("Scanning...");

  nDevices = 0;
  for(address = 1; address < 127; address++ )
  {
    Wire1.beginTransmission(address);
    error = Wire1.endTransmission();

    if (error == 0)
    {
      Serial.print("I2C(2) device found at address 0x");
      if (address<16)
        Serial.print("0");
      Serial.print(address,HEX);
      Serial.println("  !");

      nDevices++;
    }
    else if (error==4)
    {
      Serial.print("Unknown error at address 0x");
      if (address<16)
        Serial.print("0");
      Serial.println(address,HEX);
    }    
  }
  if (nDevices == 0)
    Serial.println("No I2C (2) devices found\n");
  else
    Serial.println("done\n");
}






void I2C_ScannerWire2() {
  byte error, address;
  int nDevices;

  Serial.println("Scanning ...");

  nDevices = 0;
  for(address = 1; address < 127; address++ ) {
    Wire1.beginTransmission(address);
    error = Wire1.endTransmission();

    if (error == 0) {
      Serial.print("I2C(3) device found at address 0x");
      if (address<16) Serial.print("0");
      Serial.print(address, HEX);
      Serial.println("  !");

      nDevices++;
    }
    else if (error==4) {
      Serial.print("Unknown error at address 0x");
      if (address<16) Serial.print("0");
      Serial.println(address, HEX);
    }
  }
  if (nDevices == 0)
    Serial.println("No I2C (3) devices found\n");
  else
    Serial.println("done\n");
}

