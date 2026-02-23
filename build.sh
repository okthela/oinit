#!/bin/bash

echo "Building"
echo init.nim
nim c -d:danger -d:strip -d:lto --opt:speed init.nim
echo shutdown.nim  -d:danger
nim c -d:danger -d:strip -d:lto --opt:speed shutdown.nim

echo "Moving to /sbin/oinit"
sudo cp init /sbin/oinit

echo "Moving to /sbin/oinit-shutdown"
sudo cp shutdown /sbin/oinit-shutdown
