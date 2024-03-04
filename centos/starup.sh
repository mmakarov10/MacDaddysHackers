#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Delete unauthorized users 
awk -F: '$1 != "root" && $1 != "sysadmin" && $7 == "/bin/bash" {print $1}' /etc/passwd | xargs -I {} userdel {}
echo "Removed all unauthorized users"

# Delete all cron jobs
crontab -r
echo "All cron jobs deleted."

# Disable SSH
systemctl stop sshd
systemctl disable sshd
sudo yum remove openssh-server
echo "SSH disabled."

echo "Script execution completed."

