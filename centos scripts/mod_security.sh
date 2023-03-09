#!/bin/bash

# Install dependencies
yum install -y gcc make libxml2 libxml2-devel httpd-devel pcre-devel curl-devel

# Install Mod_Security
yum install -y mod_security

# Restart Apache
systemctl restart httpd

# Move and extract OWASP ModSecurity CRS files
cd /etc/httpd/
mv /MacdaddyHackers/Owasp-modsecurity-crs.zip .
unzip Owasp-modsecurity-crs.zip
mv owasp-modsecurity-crs modsecurity-crs
mv modsecurity-crs/crs-setup.conf.example modsecurity-crs/crs-setup.conf

# Configure ModSecurity
cat <<EOF >> /etc/httpd/conf/httpd.conf
<IfModule security2_module>
Include modsecurity-crs/crs-setup.conf
Include modsecurity-crs/rules/*.conf
</IfModule>
EOF

# Configure ModSecurity whitelist
cat <<EOF >> /etc/httpd/modsecurity.d/whitelist.conf
# Whitelist file to control ModSec
<IfModule mod_security2.c>
SecRuleEngine On
SecRequestBodyAccess On
SecResponseBodyAccess On
SecDataDir /tmp
</IfModule>
EOF

# Restart Apache
systemctl restart httpd
