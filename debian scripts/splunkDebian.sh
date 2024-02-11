wget -O splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz
sudo tar xvzf splunkforwarder-9.1.1-64e843ea36b1-Linux-x86_64.tgz -C /opt
cd /opt/splunkforwarder/bin
sudo ./splunk start --accept-license 
sudo ./splunk enable boot-start
/opt/splunkforwarder/bin/splunk add forward-server 172.20.241.20:9997
/opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index main -sourcetype auth -host debian
/opt/splunkforwarder/bin/splunk add monitor /var/log/mysql.log -index main -sourcetype msqllog -host debian
/opt/splunkforwarder/bin/splunk add monitor /var/log/mysql.err -index main -sourcetype mysql.err -host debian
/opt/splunkforwarder/bin/splunk add monitor /var/log/messages -index main -sourcetype messages -host debian
/opt/splunkforwarder/bin/splunk add monitor /var/log/syslog -index main -sourcetype syslog -host debian
/opt/splunkforwarder/bin/splunk add monitor /var/log/daemon.log -index main -sourcetype daemon -host debian
/opt/splunkforwarder/bin/splunk add monitor /var/log/syslog1 -index main -sourcetype syslog -host debian
/opt/splunkforwarder/bin/splunk list forward-server
/opt/splunkforwarder/bin/splunk restart
