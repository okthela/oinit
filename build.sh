#!/bin/bash

gcc init.c -o init
doas mv init /sbin/oinit
sudo mv init /sbin/oinit

gcc init2.c -o init2
doas mv init2 /sbin/oinit-service
sudo mv init2 /sbin/oinit-service

gcc init3.c -o init3
doas mv init3 /sbin/oinit-finale
