#!/bin/bash

# Install AIDE
yum install -y aide

# Modify the AIDE configuration file to add rules to monitor /var/www and /tmp
sed -i '105i\/var\/www\tCONTENT' /etc/aide.conf
sed -i '106i\/tmp\tCONTENT' /etc/aide.conf

# Initialize the AIDE database with the new configuration
aide --init

# Remove the .new extension from the new database file
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# Wait for AIDE database initialization to complete
sleep 10

# Create a cron job to run aide --check every 2 minutes
echo "*/2 * * * * /usr/sbin/aide --check" | crontab -
