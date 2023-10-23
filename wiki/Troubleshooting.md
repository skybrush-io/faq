
## Where is a good place to start to learn about ArduPilot log files?

ArduPilot's documentation is a great place to start. Start reading from [here](https://ardupilot.org/copter/docs/common-logs.html).

## Which log analysis tool is recommended by Skybrush?

Lots of Skybrush users use an on-line tool called [UAV Log Viewer](https://plot.ardupilot.org/). The advantage of this is that you do not need to install anything on your computer to analyze a log. [Mission Planner](https://ardupilot.org/planner/) also has facilities for log analysis. If you prefer the command line, you can also try [MAVExplorer](https://ardupilot.org/dev/docs/using-mavexplorer-for-log-analysis.html) from the MAVProxy suite.

## Can anyone recommend a seminar teaching Ardupilot log analysis?

While there are not (yet) any seminars on log analysis specifically for Skybrush show drone related issues, [this one hosted by ArduPilot developer Andrew Tridgell](https://www.youtube.com/watch?v=WcfLTW_qZ08) is a gold mine of information on the subject.

## If I have an internal and an external compass, is there any problem disabling the internal compass?

Disabling the internal compasses is usually not a problem. Internal compasses tend to be noisy due to all the electronics around them so if you have one or more reliable external compasses, it makes sense to disable the internal ones -- for one thing, you wouldn't get compass inconsistency errors before takeoff just because the internal ones are pointing in the wrong direction.

## My drone starts circling when it is instructed to hover in one place for more than a few seconds, but it is fine while flying from one point to the next. What can be the problem?

This is usually caused by compass calibration issues or interference between the compass and the motors. If the drone is moving, the position and velocity information from the GPS, combined with motor outputs is enough for the EKF to provide a good yaw estimate. Compass-based yaw measurements come into play mostly when the drone is hovering because the velocity is close to zero at that point so it cannot be used to estimate the yaw accurately. That's why compass errors trigger toiletbowling mostly while hovering and not while the drone is going from point A to B.

## I am trying to connect NeoPixels to my PixHawk flight controller, but not having much success. Are there any hints?

One thing that might help is to look at the early boot messages in Mission Planner; there should be a line that looks like this:
```
RCOut: DS1200:1-4 NeoP:5-6
```
This indicates which PWM groups (pins) are assigned to which functions. DS1200 is DShot1200 (i.e. an ESC protocol), NeoP is NeoPixel. This should help in debugging which functionality was assigned to which PWM group by the firmware early at boot. Typically you'll want PWM or a DShot variant on pins 1-4 (that go to the ESCs) and NeoP in some later group that goes to the LED light.
With a PixHawk 6C, the boot message is:
```
RCOut: PWM:1-8 NeoP:9-12 PWM:13-16
```
If you are still having problems, you could grab an oscilloscope and check what's going out on the PWM pins. NeoPixel signals should look like square waves with a bit rate of 800 kHz (so 1.25 usec per bit). You should get square waves consisting of chunks of 24 bits with RGB=(170, 170, 170) (i.e #aaaaaa), followed by 8 bits of "silence" (full zeros). While checking with a scope it's best to leave the drone in a GPS-denied location so it keeps on flashing its LEDs with yellow, and then you can watch the wire signal as it will change constantly.

Here are parameter settings which work for a Pixhawk 6C:
```
SHOW_LED0_CHAN 9
SHOW_LED0_COUNT 5
SHOW_LED0_TYPE 10 (RGBW Lights)
SERVO1_FUNCTION Motor1
SERVO2_FUNCTION Motor2
SERVO3_FUNCTION Motor3
SERVO4_FUNCTION Motor4
SERVOx_FUNCTION ( x=5-16 ) 0 (disabled) (yours may need to be set to -1)
```
The Pixhawk 6C has two physical PWM output rails. The first is labeled ‘I/O PWM OUT’ (the MAIN outputs) which is used for motors. The second is labeled ‘FMU PWM OUT’ which maps to the AUX outputs. In this example, the lights are connected to PWM channel 1 of the FMU PWM OUT rail, which maps to AUX1, and is set by Skybrush as SHOW_LED0_CHAN 9.

On the Pixhawk 6C, there is a grouping concept with regard to PWM servo use. SMT32 MCU has a limited number of timer channels on which motor and servo PWM are dependant. NeoPixel need a specific use case of PWM and timer. The documentation can be found [here](https://ardupilot.org/copter/docs/common-holybro-pixhawk6X.html).
