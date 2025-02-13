#!/bin/bash
# Reset UFW to default settings
sudo ufw --force reset

# Allow Incoming Web Traffic (HTTP and HTTPS)

#sudo ufw allow 80/tcp
#sudo ufw allow 443/tcp

# Allow SSH Traffic
#sudo ufw allow 22/tcp

# Allow Incoming DNS & NTP

sudo ufw allow 123/udp
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 953/tcp
sudo ufw allow 953/udp

# Allow Outgoing DNS & NTP

sudo ufw allow out 443/tcp
sudo ufw allow out 53/udp
sudo ufw allow out 123/udp

# Allow Incoming & Outgoing Ping (ICMP)
echo '### Allow Ping Requests' | sudo tee -a /etc/ufw/before.rules
echo '-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT' | sudo tee -a /etc/ufw/before.rules
echo '-A ufw-before-output -p icmp --icmp-type echo-reply -j ACCEPT' | sudo tee -a /etc/ufw/before.rules
echo '-A ufw-before-output -p icmp --icmp-type echo-request -j ACCEPT' | sudo tee -a /etc/ufw/before.rules
echo '-A ufw-before-input -p icmp --icmp-type echo-reply -j ACCEPT' | sudo tee -a /etc/ufw/before.rules

# Deny Any Other Incoming & Outgoing Traffic By Default
sudo ufw default deny outgoing
sudo ufw default deny incoming

# Enable UFW
sudo ufw --force enable

# Display UFW Status
sudo ufw status verbose
