import osproc, posix

let whoisi = execProcess("/sbin/whoami")

if whoisi == "root":
    echo whoisi
else:
    echo "must be root"
    quit()

echo "System going down for poweroff"
echo "Syncing file systems"
sync()
echo "Remounting / as Read-Only"
discard execProcess("/sbin/mount -o remount,ro /")
echo "Bye-bye!"

discard sleep(1)

let poweroff = "o"
writeFile("/proc/sysrq-trigger", poweroff)