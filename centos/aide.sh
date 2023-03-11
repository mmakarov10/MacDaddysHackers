#!/bin/bash

# Install AIDE
yum install -y aide

# Modify the AIDE configuration file
cat <<EOF > /etc/aide.conf
# AIDE configuration file

database=file:/var/lib/aide/aide.db
database_out=file:/var/lib/aide/aide.db.new
gzip_dbout=yes
verbose=4

# Directories and files to monitor
/boot R
/bin R
/sbin R
/usr/bin R
/usr/sbin R
/usr/lib{,64} R
/etc R
/var/log R
/var/spool/cron R
/root R
/home R

# Add checks for web files and the /tmp directory
!/var/www/html/* U
!/var/www/cgi-bin/* U
!/tmp/* U

EOF

# Initialize the AIDE database with the new configuration
aide --init

# Remove the .new extension from the new database file
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Create a cron job to run aide --check every 2 minutes
echo "*/2 * * * * /usr/sbin/aide --check" | crontab -
