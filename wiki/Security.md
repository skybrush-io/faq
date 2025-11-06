## Is there collision avoidance between the drones during a show?

No, by default all drones follow preprogrammed flight paths individually, which should be designed and validated before flight to have a safe minimal distance between drones at all times. The only drone show system we know of that implements onboard real-time collision avoidance during flight is our own system at CollMot Robotics Ltd., where drones communicate with each other actively and avoid possible collisions using custom swarm intelligence.

## Is there any way to set a dual layer geofence?

Yes, if your national aviation authority requires a dual layer geofence, it can be set up using the Skybrush firmware parameters starting with `SHOW_HFENCE_...`, documented [here](https://doc.collmot.com/public/skybrush-firmware-doc/latest/appendix/arducopter_show_params.html#_show_hfence_en_hard_fence_enabledisable). 

## Does Skybrush support bubble geofence?

Yes, you can setup a bubble geofence to have a small relative fence around drones, moving along the show trajectory together with the drones. If there is too much individual drift, the bubble geofence will kick in. For a more detailed description about setting up geofences, see the [Skybrush firmare documentation](https://doc.collmot.com/public/skybrush-firmware-doc/latest/configuration/geofence.html).
