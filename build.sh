#!/bin/bash

echo "Building"
nim c init.nim
echo "Moving to /sbin/oinit"
sudo cp init /sbin/oinit
echo "Removing old file"
rm init