
## If I decide to build a custom light show drone, what components are required?

1. A [Flight controller](#what-flight-controller-can-i-use-with-skybrush-firmware) running Ardupilot 
2. A [WiFi module](#what-wifi-module-do-i-need-on-the-drone) to connect to the ground station running Live
3. A GPS receiver - [RTK GPS](#should-i-use-rtk-capable-gnss-receivers-for-outdoor-drone-shows) is highly recommended
4. An [RC Receiver](#what-is-an-rc-receiver-and-why-do-i-need-one-on-each-drone)
5. A [light fixture](#what-kinds-of-light-fixtures-does-skybrush-firmware-support)
6. An optional [SiK Radio](#what-is-a-sik-radio-and-what-does-it-do)

## What Flight Controller can I use with Skybrush firmware?

You will need a flight controller capable of running Ardupilot firmware that includes a micro SD card slot. The SD card has a file system where Skybrush stores the show trajectory. Ardupilot also stores it's log files on the SD card. Its best to have 2MB of flash memory to accommodate the Skybrush firmware and its requirement to address your LEDs.  

## What WiFi module do I need on the drone?

You will need a WiFi module on your drone (in station mode) to connect to the Wifi router on your ground station. WiFi is used to upload flight plans (trajectories) to the drone before a show, and to monitor the fleet via MAVLink telemetry. Most users run mavesp8266 firmware on their WiFi modules. If you require dual-band Wifi, an ESP32 based module may be used.

## Should I use RTK capable GNSS receivers for outdoor drone shows?

RTK capability is not strictly required for drone shows, but it is highly recommended. The 2-3 m positioning accuracy of regular GNSS receivers can drop down to 1-10 cm using RTK corrections, which increases the accuracy and quality of the show, reduces the required minimal distance between drones and - in case of stable GNSS+RTK reception - increases the overall safety of the system.

## What is an RC Receiver and why do I need one on each drone?

An RC (Remote Control) controller is generally used by RC hobbyists to fly RC models such as fixed-wing aircraft and jets, helicopters, and drones. The system uses a controller (held by the pilot who uses sticks and switches to fly the model) connected by radio to a receiver on the model. The Ardupilot documentation describes it [here](https://ardupilot.org/copter/docs/common-rc-systems.html).

For show drones, RC control is required for three things:

1. To test fly and tune a new or reconfigured drone,
2. An RC controller is the Skybrush recommended way to start a drone show, and
3. As a secondary or tertiary way to control the drones during emergencies.

One of the challenges of light show drones, is to bind a single RC controller to multiple receivers on the drones.

## What kinds of light fixtures does Skybrush firmware support?

Drone show drones typically use multiple RGB or RGBW LEDs. They are driven by the firmware via PWM or [I2C outputs](#is-it-possible-to-use-the-i2c-bus-of-the-flight-controller-to-control-the-leds-on-my-drone).

## What is a SiK Radio, and what does it do?

The Ardupilot documentation has a great introduction to SiK Telemetry Radios [here](https://ardupilot.org/copter/docs/common-sik-telemetry-radio.html#:~:text=Overview,patch%20antenna%20on%20the%20ground). 

Skybrush uses SiK radios as a secondary or tertiary control link to send emergency commands. It sends commands one-way from the control station to the drone(s) and does not receive telemetry.  [Sidekick](https://skybrush.io/modules/sidekick/) software is required (available with a Skybrush licence).

**NOTE:**
SiK radios aren't really designed for broadcasting; they want to "pair" with each other. Skybrush uses a trick where the duty cycle of each drone radio is pulled down to zero so they are not allowed to transmit. the GCS radio then _thinks_ that it's all alone (as it hears no traffic from the other radios) and starts sending data into the void. The drone radio listens to the traffic from the GCS radio and aligns its own transmit / receive cycle to the GCS radio but it will never transmit anything.

## Is it possible to use the I2C bus of the flight controller to control the LEDs on my drone?

Yes, with our ArduPilot-based firmware fork it is possible. You need to set the `SHOW_LED0_TYPE` parameter to 7 (I2C RGB) or 11 (I2C RGBW) depending on whether you have RGB or RGBW LEDs, and the `SHOW_LED0_CHAN` parameter to the I2C address that you want to use. Then, use an Arduino Nano or similar to present your LEDs as an I2C device towards the flight controller. You can use an Arduino sketch similar to the code snippet below to drive your LEDs; adjust the pin indices, the number of LEDs and the I2C address accordingly.

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
