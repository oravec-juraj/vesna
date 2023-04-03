#include <OneWire.h>
#include <DallasTemperature.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include "secrets.h"
#include <ArduinoJson.h>

// Data wire is connected to GPIO 4
#define ONE_WIRE_BUS 4
#define AWS_IOT_PUBLISH_TOPIC   "ESP32_DS18/pub"
#define AWS_IOT_SUBSCRIBE_TOPIC "ESP32_DS18/sub"

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature.
DallasTemperature sensors(&oneWire);

// Initialize WiFi client and MQTT client
WiFiClientSecure wifiClient;
PubSubClient mqttClient(AWS_IOT_ENDPOINT, 8883, wifiClient);

void callback(char* ESP32_DS18, byte* payload, unsigned int length) {
  Serial.print("Received message on topic: ");
  Serial.println(ESP32_DS18);
  Serial.print("Message: ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

void setup() {
  // Start serial communication
  Serial.begin(115200);

  // Start WiFi connection
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  // Set up the client certificate and private key
  wifiClient.setCertificate(AWS_CERT_CRT);
  wifiClient.setPrivateKey(AWS_CERT_PRIVATE);
  wifiClient.setCACert(AWS_CERT_CA);
 //wifiClient.allowSelfSignedCerts();

  // Set up MQTT client
  mqttClient.setServer(AWS_IOT_ENDPOINT, 8883);
  mqttClient.setCallback(callback);

   // Connect to the AWS IoT MQTT broker and subscribe to the topic
  while (!mqttClient.connected()) {
    Serial.print("Connecting to AWS IoT broker...");
    if (mqttClient.connect(THINGNAME)) {
      Serial.println("Connected to AWS IoT MQTT broker");
      mqttClient.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
      Serial.println("Subscribed to AWS MQTT topic");
    } else {
      delay(1000);
    }
  }

  // Start DS18B20 sensor
  sensors.begin();
}


void loop() {


   mqttClient.loop();
  // Request temperature from DS18B20 sensor
  
  //mqttClient.publish(AWS_IOT_PUBLISH_TOPIC, payload.c_str());
  
   if (mqttClient.connected()) {
  sensors.requestTemperatures();

  // Get temperature value in Celsius
  float temperature = sensors.getTempCByIndex(0);

  // Create a JSON object and set its values
    StaticJsonDocument<64> jsonDoc;
    jsonDoc["temperature"] = temperature;
    jsonDoc["sensor"] = "DS18B20";
    

// Convert the JSON object to a string
  String payload;
   serializeJson(jsonDoc, payload);
  
  // Publish the JSON payload to the MQTT broker
    mqttClient.publish(AWS_IOT_PUBLISH_TOPIC, payload.c_str());

  
  // Print temperature value to serial console
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.println(" °C");


    
    
  delay(5000);
   }
  

  // Wait for some time before repeating the loop
  
}


