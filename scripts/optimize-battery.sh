#! /bin/bash
# This script requires root privileges
echo 'auto' > '/sys/bus/usb/devices/4-4/power/control';
bluetooth off
