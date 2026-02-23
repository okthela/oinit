#!/bin/bash

echo "Building"
echo init.nim
nim c -d:danger -d:strip -d:lto --opt:speedinit.nim
echo shutdown.nim  -d:danger
nim c -d:danger -d:strip -d:lto --opt:speed shutdown.nim
echo reboot.nim 
nim c -d:danger -d:strip -d:lto --opt:speed reboot.nim 
echo "Moving to /sbin/oinit"
sudo cp init /sbin/oinit
echo "Moving to /sbin/oinit-reboot"
sudo cp reboot /sbin/oinit-reboot
echo "Moving to /sbin/oinit-shutdown"
sudo cp shutdown /sbin/oinit-shutdown
