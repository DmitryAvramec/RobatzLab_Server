/**
 * BasicHTTPClient.ino
 *
 *  Created on: 24.05.2015
 *
 */

#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

#include <ESP8266HTTPClient.h>

#define USE_SERIAL Serial
#define URL "http://192.168.100.47:3000/action" //set url to server endpoint here

#define SSID "" //wifi id here
#define SSID_PASS "" // wifi pass here
ESP8266WiFiMulti WiFiMulti;
String DEVICE_ID = "1"; //Set here id of device
String EMAIL = "your@email.com"; //Set your email here
String MESSAGE = "{\"device_id\":\"" + DEVICE_ID + "\", \"email\": \"" + EMAIL + "\"";

void setup() {
    USE_SERIAL.begin(115200);
    USE_SERIAL.setDebugOutput(true);
    USE_SERIAL.println();
    USE_SERIAL.println();
    USE_SERIAL.println();

    for(int t = 3; t >= 0; t--) {
        USE_SERIAL.printf("[SETUP] WAIT %d...\n", t);
        USE_SERIAL.flush();
        delay(1000);
    }
    WiFiMulti.addAP(SSID, SSID_PASS);

}

void loop() {
    // wait for WiFi connection
    if((WiFiMulti.run() == WL_CONNECTED)) {
        HTTPClient http;
        USE_SERIAL.print("[HTTP] begin...\n");
        USE_SERIAL.print("[HTTP] POST...\n");
        // start connection and send HTTP header
        http.begin(URL);
        http.addHeader("Content-Type", "application/json");
        String message_body = "Some good news";
        String post_message = MESSAGE + ",\"message\":\"" + message_body + "\"}";
        int httpCode = http.POST(post_message);
        if(httpCode == HTTP_CODE_OK) {
            String payload = http.getString();
                USE_SERIAL.println(payload);
        }
        else {
            USE_SERIAL.printf("[HTTP] POST... failed, error: %s\n", http.errorToString(httpCode).c_str());
        }
        http.end();
    }
    delay(60000);
}
