#!/bin/bash

echo "Disabling USB Mass Storage"
echo "blacklist usb-storage" > /etc/modprobe.d/blacklist-usbstorage