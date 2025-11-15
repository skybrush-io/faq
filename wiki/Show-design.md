## What Blender version is Skybrush Studio compatible with?

Our commitment is to support full compatibility with the latest LTS release of Blender at all times. The current version of the plugin may or may not work with older versions, though. If you find an issue with the plugin that might be related to Blender's version, install the latest LTS version of Blender first and try again. If the problem persists, feel free to [file an issue](https://github.com/skybrush-io/studio-blender/issues/new).

## Are there video tutorials available to learn Skybrush Studio?

A wide selection of video tutorials are available for Skybrush Studio for Blender - both offical tutorials from [CollMot Robotics](https://collmot.com), and also from third parties.
You can access the tutorials in a [YouTube playlist](https://skybrush.io/support/tutorials/).

## I need to design a show where the drones are launched from a roof but will land on the ground. How can I do that? Will this cause any issues?

The entire Skybrush design and execution pipeline assumes that the drones are launched from Z=0 in the show coordinate system (or very close to that -- a small incline is okay). If you need to launch from a roof, you can set up your show design so that the roof is at Z=0, and the ground is at a negative Z value. This way, the drones will launch from the roof level and land on the ground level as intended. The drones may descend below the roof level as many times during the show as needed -- the only thing you need to ensure is that they are all several meters (2.5m by default) _above_ the roof level before starting the landing sequence. This is needed because the Skybrush firmware determines the time to trigger the landing command based on the time the drone crosses the "landing altitude" (which is 2.5m above the launch altitude by default) _for the last time_ during the show.

More precisely (from a technical point of view):

* Set up your show coordinate system so that the roof level is at Z=0, and the ground level is at a negative Z value.
* Plan your show in a way that the net show content is above z = `SHOW_TAKEOFF_ALT`, where `SHOW_TAKEOFF_ALT` is set on the drone in the parameter set and it is typically 2.5m (this is the default).
* The trajectories uploaded to the drone will be cut at the point where the trajectory altitude sinks below `SHOW_TAKEOFF_ALT` for the last time, so you do not need to bring the drones down to below Z=0 in the design process. You _can_ bring them down to Z=0, however as that's the easiest in Blender (just make sure they do not move sideways below `SHOW_TAKEOFF_ALT`).
* When the trajectory ends at the cut point, the drone will execute the action configured in the `SHOW_POST_ACTION` parameter, where the default value is "land" so the drones will continue descending in a straight line, holding their horizontal position at the point where the landing action was triggered, with the aid of the GPS.
