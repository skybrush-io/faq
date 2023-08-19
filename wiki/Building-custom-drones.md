
## If I decide to build a custom light show drone, what components are required?

1. Flight controller running Ardupilot (FC Requirements)
2. WiFi module (to connect to the ground station running Live)
3. RTK GPS (see RTK)
4. RC Receiver (Why do I need RC?)
5. A light fixture (Tell me more about light fixtures)
6. SiK Radio (What is SiK Radio?)

## Skybrush Flight Controller requirements

You will need a flight controller capable of running Ardupilot firmware that includes a micro SD card slot. The SD card has a file system where Skybrush stores the show trajectory. Ardupilot also stores log files on the SD card. Its best to have 2MB of flash memory to accomodate the Skybrush firmware.  


## Should I use RTK capable GNSS receivers for outdoor drone shows?

RTK capability is not strictly required for drone shows, but it is highly recommended. The 2-3 m positioning accuracy of regular GNSS receivers can drop down to 1-10 cm using RTK corrections, which increases the accuracy and quality of the show, reduces the required minimal distance between drones and - in case of stable GNSS+RTK reception - increases the overall safety of the system.


## Is it possible to use the I2C bus of the flight controller to control the LEDs on my drone?

Yes, with our ArduPilot-based firmware fork it is possible. You need to set the `SHOW_LED0_TYPE` parameter to 7 (I2C RGB) or 11 (I2C RGBW) depending on whether you have RGB or RGBW LEDs, and the `SHOW_LED0_CHAN` parameter to the I2C address that you want to use. Then, use an Arduino Nano or similar to present your LEDs as an I2C device towards the flight controller. You can use an Arduino sketch similar to the code snippet below to drive your LEDs; adjust the pin indices, the number of LEDs and the I2C address accordingily.

```c
#include <FastLED.h>
#include <Wire.h>

/** GPIO pin used to control the LEDs */
#define LED_CONTROL_PIN 3

/** Number of LEDs controlled by the sketch */
#define LED_COUNT 50

/** Address of the LED controller on the I2C bus */
#define I2C_ADDRESS 42

/** Array storing the current colors of the LEDs */
CRGB colors[LED_COUNT];

void setup() {
  // Change this line depending on the type of LEDs you wish to drive
  // with this sketch. See the FastLED documentation for more details.
  FastLED.addLeds<NEOPIXEL, LED_CONTROL_PIN>(colors, LED_COUNT);

  Wire.begin(I2C_ADDRESS);
  Wire.onReceive(receiveEvent);
}

void loop() {
  delay(100);
}

void receiveEvent(int howMany) {
  int i = 0;
  CRGB color;

  while (Wire.available()) {
    uint8_t incomingByte = Wire.read();
    if (i < 3) {
      color[i++] = incomingByte;
    }
  }

  fill_solid(colors, LED_COUNT, color);
  FastLED.show();
}
```

Note that you will need the FastLED library for the sketch above; you can
install it from the **Tools** / **Manage Libraries...** menu in the Arduino
IDE.
