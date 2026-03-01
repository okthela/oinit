import os, osproc, strformat

echo "STAGE 2: SERVICES"

for i in walkFiles("/init/services/*"):
    echo fmt"Init service: {i}"
    discard execShellCmd(fmt"sh {i}")

echo "Done."

discard execShellCmd("/sbin/oinit-finale")

quit()