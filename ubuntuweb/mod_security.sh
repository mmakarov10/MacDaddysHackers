#!/bin/bash

# Install dependencies
apt-get install -y gcc make libxml2 libxml2-dev apache2-dev libpcre3-dev libcurl4-openssl-dev

# Install Mod_Security
apt-get install -y libapache-mod-security2

# Restart Apache
systemctl restart apache2

# Move owasp-modsecurity-crs.zip to /etc/apache2/ directory and extract files
mv /MacDaddysHackers/ubuntuweb/owasp-modsecurity-crs.zip /etc/apache2/
unzip /etc/apache2/owasp-modsecurity-crs.zip -d /etc/apache2/
mv /etc/apache2/owasp-modsecurity-crs /etc/apache2/modsecurity-crs
mv /etc/apache2/modsecurity-crs/crs-setup.conf.example /etc/apache2/modsecurity-crs/crs-setup.conf

# Configure ModSecurity
cat <<EOF >> /etc/apache2/mods-enabled/security2.conf
<IfModule security2_module>
Include /etc/apache2/modsecurity-crs/crs-setup.conf
Include /etc/apache2/modsecurity-crs/rules/*.conf
</IfModule>
EOF

# Configure ModSecurity whitelist
cat <<EOF >> /etc/apache2/modsecurity.d/whitelist.conf
# Whitelist file to control ModSec
<IfModule mod_security2.c>
SecRuleEngine On
SecRequestBodyAccess On
SecResponseBodyAccess On
SecDataDir /tmp
</IfModule>
EOF

# Restart Apache
systemctl restart apache2
