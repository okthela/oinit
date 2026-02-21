import os, osproc, strformat, posix

proc mountfs() =
    echo "Mounting pseudo-filesystems"

    echo "Creating /proc"
    discard execProcess("/sbin/mkdir /proc")

    echo "Creating /sys"
    discard execProcess("/sbin/mkdir /sys")

    echo "Creating /dev"
    discard execProcess("/sbin/mkdir /dev")

    echo "Creating /run"
    discard execProcess("/sbin/mkdir /run")

    echo "Creating /dev/pts"
    discard execProcess("/sbin/mkdir /dev/pts")

    echo "Mounting proc -> /proc"
    discard execProcess("/sbin/mount -t proc proc /proc")

    echo "Mounting sysfs -> /sys"
    discard execProcess("/sbin/mount -t sysfs sysfs /sys")

    echo "Mounting devtmpfs -> /dev"
    discard execProcess("/sbin/mount -t devtmpfs devtmpfs /dev")

    echo "Mounting tmpfs -> /run"
    discard execProcess("/sbin/mount -t tmpfs tmpfs /run -o mode=0755,nosuid,nodev")

    echo "Mounting devpts -> /dev/pts"
    discard execProcess("/sbin/mount -t devpts devpts /dev/pts -o newinstance,ptmxmode=0666,mode=0620")

    echo "Pseudo-filesystems ready"

proc mount() =
    echo "Mounting other partitions according to /etc/fstab..."
    let fstab = readFile("/etc/fstab")
    echo "\n"
    echo fstab
    discard execProcess("/sbin/mount -a")
    echo "Remounting / as read-write..."
    discard execProcess("/sbin/mount -o remount,rw /")

proc udev() =
    echo "\nStarting udev..."
    discard execProcess("/sbin/mkdir -p /run/udev/data") 
    discard startProcess("/lib/systemd/systemd-udevd", args = ["--daemon"])
    discard startProcess("/sbin/udevadm", args = ["trigger --action add"])
    discard startProcess("/sbin/udevadm", args = ["settle"])
    echo "udev started!"

proc keymap() =
    echo "Loading default keymap (us)"
    discard execProcess("loadkeys us")
    echo "\n"

proc services() =
    echo "Entering runlevel 2"
    for service in walkFiles("/init/services/runlevel2/*.sh"):
        echo fmt"Starting {service}"
        discard startProcess("/usr/bin/bash", args = [service], options = {poDaemon})
    echo "Entering runlevel final"
    for service in walkFiles("/init/services/runlevel3/*.sh"):
        echo fmt"Starting {service}"
        discard startProcess("/usr/bin/bash", args = [service], options = {poDaemon})
    echo "\n"

echo "Entering runlevel boot"
mountfs()
mount()
udev()
keymap()
services()

echo "Done!"

while true:
    sleep(1)
