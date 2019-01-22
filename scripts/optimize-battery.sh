#! /bin/bash
# This script requires root privileges

# Put touchscreen to sleep.
echo 'auto' > '/sys/bus/usb/devices/4-4/power/control';

# Optimize disk access power usage.
echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy';
echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy';
echo 'min_power' > '/sys/class/scsi_host/host2/link_power_management_policy';
echo 'min_power' > '/sys/class/scsi_host/host3/link_power_management_policy';

# Disable Bluetooth.
bluetooth off
