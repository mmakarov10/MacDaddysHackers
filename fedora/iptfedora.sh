#!/bin/bash

# Flush existing rules
iptables -F
iptables -X

#Allow udp for ntp
iptables -A INPUT -p udp -m udp -j ACCEPT

#Allow for already established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow incoming web traffic (HTTP and HTTPS)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow incoming mail traffic (POP3, IMAP, SMTP)
iptables -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j ACCEPT

# Allow incoming ICMP traffic
iptables -A INPUT -p icmp -m state --state NEW,ESTABLISHED -j ACCEPT

#Drop all incoming traffic
iptables -A INPUT -j DROP
