#!/bin/bash

# Function to delete user and home directory
delete_user_and_home() {
    username=$1
    if [[ $username != "root" && $username != "sysadmin" ]]; then
        userdel -r $username
        echo "User $username and home directory deleted."
    else
        echo "User $username is a system user. Skipping deletion."
    fi
}

# Function to delete all cron jobs
delete_cron_jobs() {
    crontab -r
    echo "All cron jobs deleted."
}

# Function to disable SSH
disable_ssh() {
    systemctl stop sshd
    systemctl disable sshd
    echo "SSH disabled."
}

# Main script

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Delete non-sysadmin and non-root users
while IFS=: read -r username _; do
    delete_user_and_home $username
done < /etc/passwd

# Delete all cron jobs
delete_cron_jobs

# Disable SSH
disable_ssh

echo "Script execution completed."

