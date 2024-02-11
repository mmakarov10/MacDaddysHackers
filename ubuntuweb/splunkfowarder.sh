wget -O splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz
sudo tar xvzf splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz -C /opt
cd /opt/splunkforwarder/bin
sudo ./splunk start --accept-license 
sudo ./splunk enable boot-start
/opt/splunkforwarder/bin/splunk add forward-server 172.20.241.20:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index main -sourcetype auth -host ubuwork
/opt/splunkforwarder/bin/splunk add monitor /var/log/syslog -index main -sourcetype syslog -host ubuwork
/opt/splunkforwarder/bin/splunk add monitor /var/log/ufw.log -index main -sourcetype ufw -host ubuwork
/opt/splunkforwarder/bin/splunk add monitor /var/log/syslog1 -index main -sourcetype syslog -host ubuwork
/opt/splunkforwarder/bin/splunk add monitor /var/log/dpkg.log -index main -sourcetype dpkg.log -host ubuwork
/opt/splunkforwarder/bin/splunk list forward-server
/opt/splunkforwarder/bin/splunk restart
