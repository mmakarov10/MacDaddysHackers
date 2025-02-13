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
#sudo ufw allow in proto icmp
#sudo ufw allow out proto icmp

# Allow Incoming & Outgoing Ping (ICMP)
sudo ufw allow in proto icmp from any to any icmp echo-request
sudo ufw allow out proto icmp from any to any icmp echo-reply


# Deny Any Other Incoming & Outgoing Traffic By Default
sudo ufw default deny outgoing
sudo ufw default deny incoming

# Enable UFW
sudo ufw --force enable

# Display UFW Status
sudo ufw status verbose
