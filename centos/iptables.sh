#!/bin/bash

# Description: Configures iptables to block all traffic except what's needed for PrestaShop.
# WARNING: This script completely disables SSH access! Use with caution.
# Run as root: sudo ./secure_iptables_prestashop.sh

set -e  # Exit on error

echo "Flushing existing iptables rules..."
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

echo "Setting default policies: Block ALL inbound and forwarded traffic..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT  # Outbound traffic is allowed

# ----------------------
# 1. Allow Loopback Interface (localhost)
# ----------------------
echo "Allowing loopback interface..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# ----------------------
# 2. Allow ICMP (Ping) for Monitoring
# ----------------------
echo "Allowing ICMP (ping)..."
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# ----------------------
# 3. Allow Only PrestaShop Traffic (Web Server)
# ----------------------
echo "Allowing HTTP (80) and HTTPS (443) for PrestaShop..."
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# ----------------------
# 4. Allow Established and Related Connections
# ----------------------
echo "Allowing established and related connections..."
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ----------------------
# 5. Explicitly Block SSH
# ----------------------
echo "Blocking all SSH access (Port 22)..."
iptables -A INPUT -p tcp --dport 22 -j DROP

# ----------------------
# 6. Save Rules for Persistence
# ----------------------
echo "Saving iptables rules for persistence..."
iptables-save > /etc/sysconfig/iptables

echo "Final iptables rules applied successfully."
sudo iptables -A OUTPUT -p tcp --dport 9997 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 9997 -j ACCEPT

iptables -L -v -n
