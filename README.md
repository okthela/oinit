Well, this init is meant for a distro im making with my friend.

This version currently uses systemd-udev, but the version that will be used on the distro, will use eudev.

All that this does is start up your system and services

Service handling works like this:

The init will first start .sh files located in /init/services/runlevel2
after those files are started, the init will start the files in /init/services/runlevel3

To stop services 

[SOON]
