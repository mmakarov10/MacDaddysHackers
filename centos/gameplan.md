# CentOS Game Plan
1. Change root and sysadmin (must be root for this)
2. cat /etc/passwd
3. configure NTP
    1. sudo yum install ntp
    2. sudo vi /etc/ntp.conf
    3. 'server 172.20.240.20'
    4. comment out other servers
4. check cronjobs
    1. crontab -e
    2. crontab -r
5. secure database
    1. mariadb-secure-installation
    2. do options
    3. show databases
    4. use mysql
    5. show tables
    6. select user, password from user;
    7. ALTER USER 'user'@'hostname' IDENTIFIED BY 'newPass';
    8. After you change the mysql password:
    9. Update password on Database Config File
    10. vi var/www/html/prestashop/config/settings.inc.php (IMPORTANT!!!!!!!)
    11. Service httpd restart
6. Remove Unknown Users From MySql:
    1. mysql -u root -p PASSWORD (Command to login to mysql)
    2. show databases;
    3. use mysql;
    4. SELECT user FROM mysql.user;
    5. DROP user ‘username@localhost’ (Command to del user)
7. Change Passwords In Mysql:
    1. Get MysqlPasswordChange.sh file from GitHub
    2. cp MysqlPasswordChange.sh /home (move the file to home directory)
    3. vi the file and insert the Username and Password in the fields
    4. Chmod +x MysqlPasswordChange.sh (give the file executable permissions)
    5. ./MysqlPasswordChange.sh
    6. rm MysqlPasswordChange.sh
8. Change SSH Port:
    1. Sudo vi /etc/ssh/sshd_config
    2. Change (#port 22) TO (port 64435)
    3. Service sshd restart
9. Backup Web Files:
    1. Get Backup.sh file from GitHub
    2. Chmod +x backup.sh (Give the file executable permissions)
    3. ./backup.sh (Run the script)
    4. Move back up to a different machine.
    5. Scp -ra /backups root@172.20.241.40:/home
10. Restore Using Backups (www files):
    1. Go to /var/www
    2. mv html html-old (rename the html folder to html-old)
    3. Go to /var/backups/www
    4. cp -rap html /var/www
    5. restorecon -R /var/www/html
    6. Reboot system
    7. find . -type f -exec chmod 644 {} \; && find . -type d chmod 755 {} \;
    8. Make sure you are in /var/www
    9. Chown -R apache:apache html
11. Using Backups (mysql database)
    1. Go to var/backups
    2. mysql -u root -p < mysql.sql
12. Rename admin folder
13. systemctl list-units –type=service –state=running
14. Installing Artillery:
    1. Unzip new_artillery.zip
    2. cd Artillery-Master
    3. Run ./setup.py
    4. Go through the steps, click yes to start Artillery.
    5. Navigate to /var/artillery
    6. Run ./start_artillery.py
    7. Run artillery in the background by typing bg and clicking enter.
    8. If you need to change any settings, vi config and edit parameters as needed.
15. Install splunk forwarders:
    1. Get SplunkFowarder.sh from GitHub
    2. Chmod +x SplunkForwarder (Give the file executable permissions)
    3. ./SplunkFowarder.sh (Run the script)
16. UFW Firewall
    1. sudo yum install ufw
    2. sudo ufw allow 22/tcp
    3. sudo ufw allow 80/tcp
    4. sudo ufw allow 443/tcp 
    5. sudo ufw default deny incoming
    6. sudo ufw allow out 80/tcp
    7. sudo ufw default deny outgoing
    8. sudo ufw enable
    9. sudo ufw status verbose
    10. sudo ufw status numbered
    11. sudo ufw delete <number>
    12. sudo ufw disable
    13. sudo ufw deny from <ip>
