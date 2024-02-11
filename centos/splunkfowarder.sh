wget -O splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz
sudo tar xvzf splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz -C /opt
cd /opt/splunkforwarder/bin
sudo ./splunk start --accept-license 
sudo ./splunk enable boot-start
/opt/splunkforwarder/bin/splunk add forward-server 172.20.241.20:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index main -sourcetype syslog -host centOS
# This line added for centos
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index main -sourcetype linux_secure -host centOS

/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd/access_log -index main -sourcetype access_log -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/cron -index main -sourcetype cron -host centos
/opt/splunkforwarder/bin/splunk add monitor /var/log/httpd/error_log -index main -sourcetype error_log -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/secure -index main -sourcetype secure -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/messages -index main -sourcetype messages -host centOS
/opt/splunkforwarder/bin/splunk add monitor /var/log/audit/audit.log -index main -sourcetype audit -host centOS
/opt/splunkforwarder/bin/splunk list forward-server
/opt/splunkforwarder/bin/splunk restart
