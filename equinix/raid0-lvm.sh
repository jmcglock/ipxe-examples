#!/bin/bash

# RAID devices
declare -a DEVICES=(
  "/dev/nvme1n1"
  "/dev/nvme5n1" 
  "/dev/nvme4n1"
  "/dev/nvme6n1"
  "/dev/nvme7n1"
  "/dev/nvme2n1"
  "/dev/nvme3n1"  
)

# Custom RAID device name
RAID_DEVICE_NAME="md69"

echo "Stopping any existing RAID $RAID_DEVICE_NAME"
mdadm --stop /dev/$RAID_DEVICE_NAME

echo "Creating RAID 0 array $RAID_DEVICE_NAME"
mdadm --create /dev/$RAID_DEVICE_NAME --level=0 --raid-devices=${#DEVICES[@]} "${DEVICES[@]}"

# Wait for RAID to become active 
while ! cat /proc/mdstat | grep -q "$RAID_DEVICE_NAME"; do
  sleep 1
done

echo "Saving RAID config to mdadm.conf" 
> /etc/mdadm.conf
mdadm --detail --scan >> /etc/mdadm.conf