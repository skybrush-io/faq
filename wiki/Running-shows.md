## How many drones can Skybrush handle at the same time?

There are no programmatic limits on the number of drones that Skybrush itself can handle, provided that all other components of your operation (laptops, network routers, radio transmitters, chargers, logistics and so on) can also handle the drone count that you have in mind. 

A soft limitation occurs when you are using MAVLink-based drones, as their ID stored in the [SYSID_THISMAV](https://ardupilot.org/copter/docs/parameters.html#sysid-thismav-mavlink-system-id-of-this-vehicle) parameter can only handle one byte ID-s, so practically you are limited to handle around 250 drones per network. If you need more than that, you have to use multiple routers in parallel and configure Skybrush Server to access them in different subnets.

Finally, please note that the pre-compiled community version of Skybrush Server is limited to handle max 10 drones. To enjoy the full extent of Skybrush with unlimited drone number and many other pro features, we encourage you to buy a professional licence.


## Are there any built-in limitations in Skybrush?

Binaries (i.e. pre-compiled versions) of Skybrush that we distribute _may_ have built-in limitations on the number of drones that the software is willing to handle simultaneously, or other features of the software. The current limitations are always displayed when you start Skybrush Live or Skybrush Server. You can remove the limitations either by compiling Skybrush on your own from the source code, or by [buying a professional licence](https://skybrush.io/shop/) or [subscribing to an enterprise support tier](https://skybrush.io/support/), which entitles you to pre-compiled binaries without the limitations, according to contractual terms.

In practice, the limitations we build into pre-compiled versions of Skybrush will not prevent you from evaluating and testing Skybrush with smaller shows; we only ask you to [purchase a professional licence](https://skybrush.io/shop/), to [subscribe to enterprise support](https://skybrush.io/support/) or to compile the code on your own if you intend to perform larger projects.

By subscribing to our paid services and products, you are helping us financially in maintaining and developing Skybrush further, and this benefits your own business as well in the long term.


## Do I need active internet connection during drone light shows?

You don’t necessarily need active internet connection during drone shows. You should be connected to the local network of the drones created by your dedicated router to access them from Skybrush Live. However, there are a few handy features in Skybrush Live that require access to data on the internet, such as the weather widget that attempts to retreive latest Kp-index or any tile server that provides your map tiles. For what it's worth, you can always buy a 4G mobile wifi dongle and connect it via USB to your laptop to also have internet connection along with your local network connection. 


## Can you tell me more about what happens when Live uploads show data to the drones during the pre-flight preparation?

Let me summarize:

- Show data and the geofence are uploaded at the same time, in a single transaction. "Show data" basically includes the trajectories, the show origin, the show orientation and the geofence. Notably, the start time and the start method (RC or automatic) are _not_ part of the upload -- more about this later.

- When you upload new show data for a drone, the old show data gets removed. The geofence is also replaced when uploading new show data.

- It is possible to upload show data to only a sub-selection of drones from Live; in this case, the new show data gets uploaded to the selected drones, but any show data on drones that were not part of the upload transaction will not be touched. This is helpful in last-minute changes before a show when you replace a faulty drone with a new one -- you only need to upload the trajectory to the new drone and not touch the rest

- Start time and start method are broadcast separately to the drones in a data packet once per second. This allows you to change the start time and the start method _after_ the upload, without having to re-upload the entire show data. But this also means that _all_ drones that you turn on will receive the start time and the start method, _and_ if they have valid show data _and_ happen to be at the right takeoff coordinate for that show data, they will start flying when the time comes. So, it is advised to turn off those drones that are not participating in the current flight, just to avoid the rare occasion that you happen to have a previous show trajectory on the drone and the drone is coincidentally placed at the right takeoff position for that show.

 **Note**

- It is a well-kept secret that sending the message `show remove` to a drone from its Messages panel will clear the show data uploaded to the drone. It is meant primarily for debugging purposes only, but nevertheless it's there. Not having show data in show mode before takeoff is treated as a preflight check failure so in this case the drones should not take off.
