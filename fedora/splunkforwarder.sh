#!/bin/bash
wget -O splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz
sudo tar xvzf splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz -C /opt
cd /opt/splunkforwarder/bin
sudo ./splunk start --accept-license 
sudo ./splunk enable boot-start
/opt/splunkforwarder/bin/splunk add forward-server 172.20.241.20:9997

# This line added for centos

/opt/splunkforwarder/bin/splunk add monitor /var/log/secure -index main -sourcetype secure -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/messages -index main -sourcetype messages -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/boot.log -index main -sourcetype boot -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/cron -index main -sourcetype cron -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/audit/audit.log -index main -sourcetype audit -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/lastlog -index main -sourcetype lastlog -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/maillog -index main -sourcetype maillog -host fedora
/opt/splunkforwarder/bin/splunk add monitor /var/log/chrony -index main -sourcetype chrony -host fedora




/opt/splunkforwarder/bin/splunk list forward-server
/opt/splunkforwarder/bin/splunk restart
