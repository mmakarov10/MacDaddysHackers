#!/bin/bash

# Download and extract Splunk Universal Forwarder
wget -O splunkforwarder-8.2.3-cd0848707637-Linux-x86_64.tgz 'https://download.splunk.com/products/universalforwarder/releases/8.2.3/linux/splunkforwarder-8.2.3-cd0848707637-Linux-x86_64.tgz'
sudo tar xvzf splunkforwarder-8.2.3-cd0848707637-Linux-x86_64.tgz -C /opt

# Start Splunk Universal Forwarder and enable boot-start
cd /opt/splunkforwarder/bin
sudo ./splunk start --accept-license 
sudo ./splunk enable boot-start

# Set hostname to "ubuntu"
sudo ./splunk set default-hostname ubuntu

# Add forward server
sudo ./splunk add forward-server 172.20.241.20:9997

# Add log monitors
sudo ./splunk add monitor /var/log/auth.log -index main -sourcetype linux_secure
sudo ./splunk add monitor /var/log/apache2/access.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/apache2/error.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/apache2/ssl_access.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/apache2/ssl_error.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/apache2/ssl_request.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/modsecurity/modsec_debug.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/modsecurity/modsec_audit.log -index main -sourcetype weblog
sudo ./splunk add monitor /var/log/auth.log -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/auth.log -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/mysql/mysql.log -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/mysql/mysql.err -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/dpkg.log -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/syslog -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/auth.log -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/auth.log -index main -sourcetype syslog
sudo ./splunk add monitor /var/log/auth.log -index main -sourcetype syslog

# List forward servers
sudo ./splunk list forward-server

# Restart Splunk Universal Forwarder
sudo ./splunk restart
