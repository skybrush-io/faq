
## Skybrush drone light shows are magic! Can you give me a birds-eye overview of how a drone show works?

During the show, each drone flies its own unique flight plan (trajectory). The drones are not being controlled in real time via a radio link to the Control Station. Nor are they communicating between each other. However triple-redundant command and control links allow the operator to take immediate control of any or all drones.

Because they are flying pre-programmed trajectories and not dependant on a radio link, problems with radio interference, bandwidth saturation or range are eliminated.

Synchronized pre-programmed flight creates these challenges:

- Accurately [synchronizing events](#how-are-the-drones-slaved-to-a-common-timeline-if-they-are-not-communicating-among-each-other) across the fleet to a common timeline,
- Ensuring the required [3D position accuracy](#how-do-the-drones-achieve-such-amazing-position-accuracy),
- Creating a [unique synchronized trajectory](#how-are-the-synchronized-trajectories-created-and-how-are-collisions-avoided) for each drone (the choreography), and
- Developing appropriate [procedures to deal with emergencies](#if-the-drones-are-flying-pre-programmed-trajectories-how-do-you-interrupt-a-flight-to-handle-unforseen-circumstances).

## How are the drones slaved to a common timeline if they are not communicating among each other?

The GNSS (Global Navigation Satellite System) works by timing signals from satellites at nano-second accuracy, making GNSS receiver clocks incredibly precise.

Accurate timing of events across the fleet is achieved by synchronizing each drone’s flight events (trajectories and light effects) to the common GNSS clock time.

## How do the drones achieve such amazing position accuracy?

For outdoor drone shows, the synchronized flight system [most often](https://doc.collmot.com/public/faq/latest/building-custom-drones.html#should-i-use-rtk-capable-gnss-receivers-for-outdoor-drone-shows) uses RTK (Real Time Kinematics) GPS:

- The Control Station is connected to an RTK base station, which _surveys in_ to achieve very high 3D position accuracy.
- Each drone carries an RTK rover GPS which receives a correction data stream from the Control Station base station via WiFi to correct for atmospheric and other errors.

For indoor shows, a local indoor positioning system is used.

## How are the synchronized trajectories created, and how are collisions avoided?

The show's 3D choreography is created using [Blender](https://www.blender.org) and the [Skybrush Studio](https://doc.collmot.com/public/skybrush-studio-for-blender/latest/index.html) add-on. Both Blender and Studio are open-source software.

Blender’s standard tools are used to create static or animated formations of drones. Skybrush Studio is used to:

- Ensure adequate separation between the drones in the formations,
- Calculate collision-free transitions between these formations,
- Ensure that trajectories (accelerations and velocities etc) are within your drones' real-world physical capabilities.
- Once the flight choreography is prepared, Skybrush Studio sends each drone’s position (in local X Y Z coordinates), velocity and lighting commands for each frame to a compiled flight plan file.
- The compiled flight plan is extensively tested in [Skybrush Viewer](https://skybrush.io/modules/viewer/), and using simulated drones before being flown by the physical drone fleet.

## If the drones are flying pre-programmed trajectories, how do you interrupt a flight to handle unforseen circumstances?

Operators have 3 independent command and control links which may be used to interrupt a flight:

1. Skybrush Live running on the main Ground Station and communicating with the fleet via WiFi.
2. Skybrush Sidekick running on an separate computer and capable of sending one-way commands to any or all drones via a separate radio link, and
3. RC control capable of sending one way commands to the entire fleet.

Each operator must understand their own setup and develop [security procedures](https://doc.collmot.com/public/faq/latest/security.html). Standard and emergency operating procedures will be required by the your [national aviation authority](https://doc.collmot.com/public/faq/latest/legal-issues.html) when you apply for authorization to fly drone shows in your country.
