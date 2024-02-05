#!/bin/bash
wget -O splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz
sudo tar xvzf splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz -C /opt
cd /opt/splunkforwarder/bin
sudo ./splunk start --accept-license 
sudo ./splunk enable boot-start
/opt/splunkforwarder/bin/splunk add forward-server 172.20.241.20:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index main -sourcetype syslog -host centOS
# This line added for centos
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index main -sourcetype linux_secure -host centOS

/opt/splunkforwarder/bin/splunk add monitor /var/log/apache2/access.log -index main -sourcetype weblog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/apache2/error.log -index main -sourcetype weblog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd/access_log -index main -sourcetype weblog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd/error_log -index main -sourcetype weblog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/secure -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/messages -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd-errors.log -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/mysql.log -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/mysql.err -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/dpkg.log -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/syslog -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/authlog -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/adm/sulog -index main -sourcetype syslog -host centOS
/opt/splunkforwarder/bin/splunk list forward-server
/opt/splunkforwarder/bin/splunk restart
