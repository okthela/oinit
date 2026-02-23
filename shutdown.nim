import osproc, posix, os

let whoisi = execProcess("/sbin/whoami")

let option = paramStr(1)

if whoisi == "root\n":
    echo whoisi
else:
    echo whoisi
    echo "must be root"
    quit()

proc shutdown() =
    let poweroff = "o"
    writeFile("/proc/sysrq-trigger", poweroff)
    echo "System going down for poweroff"
    echo "Syncing file systems"
    sync()
    echo "Remounting / as Read-Only"
    discard execProcess("/sbin/mount -o remount,ro /")
    discard posix.sleep(1)
    echo "Bye-bye!"

proc reboot() =
    let poweroff = "b"
    echo "System going down for reboot"
    echo "Syncing file systems"
    sync()
    echo "Remounting / as Read-Only"
    discard execProcess("/sbin/mount -o remount,ro /")
    echo "Bye-bye!"
    discard posix.sleep(1)
    writeFile("/proc/sysrq-trigger", poweroff)

if option == "reboot":
    echo "Rebooting"
    reboot()
elif option == "shutdown":
    echo "Shutting down"
    shutdown()
else:
    echo "unknown option"
#writeFile("/proc/sysrq-trigger", poweroff)