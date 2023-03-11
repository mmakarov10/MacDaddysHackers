#!/bin/bash

# Install ModSecurity and enable the module
sudo apt update
sudo apt install libapache2-mod-security2 -y
sudo a2enmod security2

# Rename and configure the ModSecurity configuration file
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/modsecurity/modsecurity.conf
sudo sed -i 's/SecAuditLogParts ABDEFHIJZ/SecAuditLogParts ABCEFHJKZ/g' /etc/modsecurity/modsecurity.conf

# Download and install the OWASP Core Rule Set (CRS)
sudo apt install -y git
cd /tmp
git clone https://github.com/coreruleset/coreruleset.git
sudo mv /tmp/coreruleset/rules /etc/modsecurity/
sudo mv /tmp/coreruleset/crs-setup.conf /etc/modsecurity/
sudo rm -rf /tmp/coreruleset
sudo sed -i 's#IncludeOptional /usr/share/modsecurity-crs/*.load#Include /etc/modsecurity/crs-setup.conf\nIncludeOptional /etc/modsecurity/rules/*.conf#g' /etc/apache2/mods-enabled/security2.conf

# Restart Apache
sudo systemctl restart apache2

# Restart Apache
systemctl restart apache2
