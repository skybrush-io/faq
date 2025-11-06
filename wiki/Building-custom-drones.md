## What sort of outdoor drones is Skybrush compatible with?

For outdoor shows, **Skybrush** works with practically any drone that is able to run the open-source [ArduCopter](https://ardupilot.org) firmware. We use a modified version of ArduCopter and we publish the source code of the modified firmware [on Github](https://github.com/skybrush-io/ardupilot). You need to compile and install our modified version on your own drone in order to ensure full compatibility. We publish pre-compiled versions of the firmware for the most common autopilots, so if your drone uses one of these autopilots, you can simply use our pre-compiled version instead of compiling on your own.

> **Important**
> When working with our firmware fork, make sure to check out one of the `CMCopter-...` branches with the appropriate upstream ArduPilot version number as the `master` branch simply tracks ArduPilot's `master` branch.


## What sort of indoor drones is Skybrush compatible with?

For indoor shows, **Skybrush** currently supports drones based on the flight controllers of the [Crazyflie](https://bitcraze.io) ecosystem, both the "stock" Crazyflie and larger drones based on the Crazyflie Bolt. We use a modified version of the Crazyflie firmware and we publish its source code [on Github](https://github.com/skybrush-io/crazyflie-firmware) as well. You need to compile and install our modified version on your drone in order to ensure full compatibility. We publish pre-compiled versions of the firmware for the stock Crazyflie and several suggested Bolt-based builds.


## If I decide to build a custom light show drone, what components are required?

If you wish to make your drones compatible with Skybrush, contact us to do it together to become trusted partners! If you wish to try it on your own, these are the basic components needed:

1. A [flight controller](#what-flight-controller-can-i-use-with-skybrush-firmware) running Ardupilot 
2. A [WiFi module](#what-wifi-module-do-i-need-on-the-drone) to connect to the ground station running Live
3. A GPS receiver - [RTK GPS](#should-i-use-rtk-capable-gnss-receivers-for-outdoor-drone-shows) is highly recommended
4. An [RC receiver](#what-is-an-rc-receiver-and-why-do-i-need-one-on-each-drone)
5. A [light fixture](#what-kinds-of-light-fixtures-does-skybrush-firmware-support)
6. An optional [SiK radio](#what-is-a-sik-radio-and-what-does-it-do)
7. An optional [pyro device](#what-kinds-of-pyro-devices-does-skybrush-firmware-support)


## What flight controller can I use with Skybrush firmware?

You will need a flight controller capable of running Ardupilot firmware that includes a micro SD card slot. The SD card has a file system where Skybrush stores the show trajectory. Ardupilot also stores its log files on the SD card. It is best to purchase a flight controller that has 2MB of internal flash memory to accommodate the Skybrush firmware as it is getting increasingly harder to fit the firmware in smaller 1MB boards. Boards with 2MB flash also tend to have more RAM, which can be important if you want to drive many NeoPixel LEDs as the signals needed to drive these LEDs need more RAM.


## What WiFi module do I need on the drone?

You will need a WiFi module on your drone (in station mode) to connect to the WiFi router on your ground station. WiFi is used to upload flight plans (trajectories) to the drone before a show, and to monitor the fleet via MAVLink telemetry. Most users run our fork of the [`mavesp8266` firmware](https://github.com/skybrush-io/mavesp8266) on their WiFi modules.

If you require dual-band Wifi, an ESP32 based module may be used. Note that our firmware fork and the original `mavesp8266` firmware does not support ESP32 officially yet, but we are working on ESP32 compatibility.

You can also opt for using 4G/5G connectivity with VPN, but then you need a dedicated onboard computer to handle the 4G/5G connection and the VPN itself as the autopilot boards are not equipped for handling VPN connections.


## Should I use RTK capable GNSS receivers for outdoor drone shows?

RTK capability is not strictly required for drone shows, but it is highly recommended (especially if you want to compete with the bigger players on the market who all use RTK corrections). The 2-3 m positioning accuracy of regular GNSS receivers can drop down to 1-10 cm using RTK corrections, which increases the accuracy and quality of the show, reduces the required minimal distance between drones and - in case of stable GNSS+RTK reception - increases the overall safety of the system.

Note that when using RTK receivers, you also need an RTK base station or another data source for RTK corrections at the place of the flight.

For testing purposes, it is entirely possible to fly without RTK; the formations will not be as accurate (especially in the vertical direction) and you need a bit larger safety distance between drones, though.


## Do I need RTK GPS both in the GCS and on the drones?

Yes, you need RTK-capable GPS receivers on both sides. The RTK base station is needed to _send_ RTK corrections to the drone while the RTK GNSS receiver on the drone is needed to _receive_ the corrections. The RTK base station assumes that it knows its own position very precisely and it also assumes that any deviation from that hypothetical position in its _current_ measurement is due to atmospheric conditions. _Then_ it  assembles a stream of packets that contain the inferred atmospheric conditions (delays in signal transmissions etc), and then Skybrush sends that stream to the drones. At that point, it is the responsibility of the drone to interpret the atmospheric conditions _and_ correct its own measurements. So, the GPS unit on the drone does some heavy computations as well, that's why you need an RTK-enabled GPS on the drone. A standard non-RTK GPS won't know what to do with the corrections, and, of course, a base without RTK will not be able to generate corrections.


## What is an RC receiver and why do I need one on each drone?

An RC (Remote Control) controller is generally used by RC hobbyists to fly RC models such as fixed-wing aircraft and jets, helicopters, and drones. The system uses a controller (held by the pilot who uses sticks and switches to fly the model) connected by radio to a receiver on the model. The Ardupilot documentation describes it [here](https://ardupilot.org/copter/docs/common-rc-systems.html).

For show drones, RC control is required for three things:

1. To test fly and tune a new or reconfigured drone,
2. An RC controller is the Skybrush recommended way to start a drone show, and
3. As a secondary or tertiary way to control the drones during emergencies.

One of the challenges of light show drones, is to bind a single RC controller to multiple receivers on the drones.


## What kinds of light fixtures does Skybrush firmware support?

All drones should be equipped with a strong, bright RGBW LED light or many smaller LEDs distributed all along the body of the drone, controlled by the same color input in parallel. There are multiple options to connect the LEDs:

- the easiest is to use three or four PWM outputs of the autopilot to drive the red, green, blue (and optionally the white) channels of the LED using a custom LED board, something like [this](https://github.com/ugcs/ddc/tree/master/Drone_hardware/Fireball_LED_payload).

- our firmware supports driving NeoPixel (WS2812) or ProfiLED LED strips with a single serial line (which means less wiring); no need for custom hardware, just connect the LED strip to a servo output and you are good to go. The downside is that you need a stronger CPU, most likely an STM32H7 as the LED control signals need to be assembled in memory and the more LEDs you have the longer the signal will be. (And you need a spare DMA channel).
  
- there is also an option for I2C-connected LED modules. You can use an Arduino Nano or something similar, with a small sketch that presents the Arduino as an I2C device towards the flight controller. You can use [this sketch](#is-it-possible-to-use-the-i2c-bus-of-the-flight-controller-to-control-the-leds-on-my-drone).

- You can tweak an ESP8266 or ESP32 wifi module and use it both to connect to the ground via wifi and to control the LEDs. Our firmware can be configured to send MAVLink commands to the wifi module to control the LEDs, but you need a custom firmware on the ESP to take care of both the wifi connection and the LEDs. You can probably use our `mavesp8266` fork as a starting point, but you need to add the LED handling.

> **Note**
> We were told that earlier revisions of the [Fireball LED payload](https://github.com/ugcs/ddc/tree/master/Drone_hardware/Fireball_LED_payload) had issues with heat generated from the LEDs. Rev F attempted to solve the heating problem, but some of the issues remained. We were also informed that the schematics does not show that each LED needed to be grounded. There is ongoing work on a new revision of the board by a member of our [Discord](https://skybrush.io/r/discord) community to solve the issues with Rev F, so before you start building this board, feel free to ask around on our Discord server to see if you could simply order a newer revision.

The most up-to-date list of supported light fixtures can be found in the [LED configuration](https://doc.collmot.com/public/skybrush-firmware-doc/latest/configuration/led.html) section of the **Skybrush firmware** documentation.

## What kinds of pyro devices does Skybrush firmware support?

Skybrush supports optional pyro triggering on multiple pyro channels. The supported list of pyro devices can be found in the [Pyro configuration](https://doc.collmot.com/public/skybrush-firmware-doc/latest/configuration/pyro.html) section of the **Skybrush firmware** documentation.

## What is a SiK radio, and what does it do?

The ArduPilot documentation has a great introduction to SiK telemetry radios [here](https://ardupilot.org/copter/docs/common-sik-telemetry-radio.html#:~:text=Overview,patch%20antenna%20on%20the%20ground). 

Skybrush uses SiK radios as a secondary or tertiary control link to send emergency commands. It sends commands one-way from the control station to the drone(s) and does not receive telemetry. [Sidekick](https://skybrush.io/modules/sidekick/) software is required (available with a Skybrush licence).

> **Note**
> SiK radios are not really designed for broadcasting; they want to "pair" with each other. Skybrush uses a trick where the duty cycle of each drone radio is pulled down to zero so they are not allowed to transmit. the GCS radio then _thinks_ that it's all alone (as it hears no traffic from the other radios) and starts sending data into the void. The drone radio listens to the traffic from the GCS radio and aligns its own transmit / receive cycle to the GCS radio but it will never transmit anything.


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

Note that you will need the FastLED library for the sketch above; you can install it from the **Tools** / **Manage Libraries...** menu in the Arduino IDE.


## Can you help me in building a drone compatible with Skybrush?

[CollMot Robotics Ltd.](https://collmot.com) provides enterprise-grade consultancy services for Skybrush, which also covers the case of building show drones. Contact us for more details and pricing information, lets cooperate!


## Can I bundle Skybrush with the drones that I sell?

Yes, you can. You are allowed to redistribute the pre-compiled binaries for Skybrush components, but note that these pre-compiled binaries may include limitations in the number of drones that the software is willing to handle simultaneously, or other features of the software. You may also compile Skybrush from its source code, and you are then allowed to redistribute the unrestricted binaries. However, note that we cannot provide support beyond the standard community support for your customers for free.

Contact us if you would like us to be responsible for supporting your customers in using Skybrush beyond community support as part of our trusted partner program.


## Are there any budget-friendly small flight controllers without all the unnecessary functions which we don't need for a light show?

It depends on whether you are thinking long-term or not. If you want to plan ahead, you should probably buy something with an STM32H7 processor. If you don't care, older flight controllers based on STM32F4 will do, but note that you might be running into problems if you want to drive lots of NeoPixel LEDs with older flight controllers due to insufficient amount of RAM available on the flight controller after boot (NeoPixel pulses are assembled in RAM and they are proportional in length to the number of LEDs to drive). Also, it is getting increasingly harder to fit the firmware in 1MB of flash so older flight controllers having only 1MB of flash might become unsupported at some point in the future.


## Are all the flight controllers with an STM32H7 compatible with ArduPilot / Skybrush?

The ArduPilot documentation has a good section on [selecting an autopilot](https://ardupilot.org/copter/docs/common-autopilots.html).

Not all of these are tested as we do not have the capacity to test all of them, but in general those with an SD card slot and an STM32H7 should work. We publish firmware images for those flight controllers that we have tested ourselves; if you do not see your flight controller on our homepage but you know that it supports ArduPilot, you might get lucky by compiling the firmware image on your own. You can ask for guidance on our [Discord server](https://skybrush.io/r/discord).

## When I bought my drone, it came loaded with and tuned for the PX4 flight stack. When I load ArduCopter / Skybrush, it too unstable to even hover. Can you provide settings for me?

The drones we have settings for are listed [here](https://doc.collmot.com/public/skybrush-live-doc/latest/appendix/drone_specific_settings.html). If we don't have settings for your specific drone, the most problematic part is the tuning of the low-level controllers. For the initial low-level tuning of the controllers, the [First flight and tuning](https://ardupilot.org/copter/docs/flying-arducopter.html) section from the ArduCopter documentation should be enough to get started.

Hints:

- Use a tether until the drone becomes stable in manual flight
- Don't fly at high altitudes
 
You should be able to avoid most crashes :-)

When you come up with a set of parameters that makes the drone fly more-or-less stable in autonomous modes, you can tweak your tune automatically using [this ArduCopter procedure](https://ardupilot.org/copter/docs/autotune.html). Once your drone is flying well using your remote control both in manual and autonomous modes, be certain to set Skybrush's higer level settings, [documented here](https://doc.collmot.com/public/skybrush-live-doc/latest/tutorials/setup-hardware-outdoor/setup_arducopter_params.html). Now you should be ready to fly a show.

If you are willing to contribute it to the project send it to us so we can make it public here!
