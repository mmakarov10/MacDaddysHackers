# Splunk ReadMe

## Windows 10

### change password for minion and Administrator

`net user <Account Name> <New Password>`

### See users

`net user`

### To see from windows

-   add a route to the splunk machine from admin cmd at win10 `route add destination_network MASK subnet_mask  gateway_ip metric_cost`
-   `route add -P 172.25.34.0 mask 255.255.255.0 172.31.34.2`
-   display routes `route print`
-   make sure the firewall is on `netsh advfirewall set allprofiles state on`
-   make sure windows defender is on

### Running services

search services
stop remote desktop, print spooler, remote access connection

-   check netstat
-   task manager?
-   task scheduler?

-   Install nmap
-   install wireshark

---

## Splunk

https://research.splunk.com/detections/

## CentOS Useful Commands

https://wiki.centos.org/HowTos/OS_Protection

### Check where the bash interpreter is located

`which bash`

### Status, Start, Stop, Restart

`/opt/splunk/bin/splunk status`  
`/opt/splunk/bin/splunk start`  
`/opt/splunk/bin/splunk stop`  
`/opt/splunk/bin/splunk restart`

### Change Password

`sudo passwd root`  
change web admin password

### Restrict Root User

# Check this!!!

-   Root user can only log in at the machine `echo "tty1" > /etc/securetty`
-   Only the root user can access its directory `chmod 700 /root`

### Check users

-   List the users `sudo cut -d: -f1 /etc/passwd`
-   List users that can log in `getent passwd | egrep -v '/s?bin/(nologin|shutdown|sync|halt)' | cut -d: -f1`
-   Get info about hosts `getent hosts`
-   Get info about a service `getent services <Port>`
-   Get info about a user `getent passwd <Username>`

### Login Banner

`vi /etc/motd`  
“This computer network belongs to Team # and may be used by Team # employees ONLY and for approved work-related purposes. All activity is being monitored and logged. Team # reserves the right to consent to a valid law enforcement request to search the network logs for evidence of a crime stored within the network and can be used to prosecute abuse.”

### Splunk TODO:

-   set splunk to listen in port 9997

-   Splunk install Sysmon add on

-   Get the splunk dashboards from the github

### Change NTP Server

`vi /etc/ntp.conf`

change server to the debian ip address
run `service ntpd restart` to restart the ntp process
run `ntpq -p` to see the current ntp
`ntpstat` to see the current ntp status

### ! Copy /etc and splunk

### ! Use netstat to see what is listening

`netstat -plant`

### Scheduled Tasks

-   View scheduled tasks `crontab -e`

-   Remember to scroll all the way down

### figure out index size in splunk and see if there is a way to delete older ones
