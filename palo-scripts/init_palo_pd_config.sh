# Free to be used by anyone. Please realize you are using these commands
# at your own risk. The author holds no liability and will not be held
# responsible for any damages done to systems or system configurations.

----------------------PRODUCTION-------------------------------------

----------------------OBJECTS---------------------------------------------

set address "docker" ip-netmask 172.20.240.10
set address "debian" ip-netmask 172.20.240.20
set address "ubuntu web" ip-netmask 172.20.242.10
set address "wks" ip-netmask 172.20.242.101
set address "ad" ip-netmask 172.20.242.200
set address "splunk" ip-netmask 172.20.241.20
set address "centos" ip-netmask 172.20.241.30
set address "fedora" ip-netmask 172.20.241.40
set address "palo mgmt" ip-netmask 172.20.242.150

set address "internal segment" ip-netmask 172.20.240.254/24
set address "user segment" ip-netmask 172.20.242.254/24
set address "public segment" ip-netmask 172.20.241.254/24

set address "ad-nat" ip-netmask 172.25.34.27
set address "centos-nat" ip-netmask 172.25.34.11
set address "debian-nat" ip-netmask 172.25.34.20
set address "docker-nat" ip-netmask 172.25.34.97
set address "fedora-nat" ip-netmask 172.25.34.39
set address "splunk-nat" ip-netmask 172.25.34.9
set address "ubuntu web-nat" ip-netmask 172.25.34.23

set service "VPN 500" protocol udp port 500
set service "VPN 4500" protocol udp port 4500
set service port-8000 protocol tcp port 8000

----------------------OBJECTS---------------------------------------------

----------------------RULES-----------------------------------------------

delete rulebase security
#Allow Ping 
set rulebase security rules "Allow Ping" from any source any to any destination any application ping service application-default action allow
#Allowing HTTP/HTTPS To Ubuntu Web From External (Disabled)
set rulebase security rules "Ubuntu Web External Access" from External source any to User destination "Ubuntu Web-NAT" application web-browsing service application-default action allow
set rulebase security rules "Ubuntu Web External Access" disabled yes
#Allowing DNS To AD From External
set rulebase security rules "AD DNS External Access" from External source any to User destination "AD-NAT" application dns service application-default action allow
#Allowing HTTP/HTTPS To Centos From External 
set rulebase security rules "Centos E-comm External Access" from External source any to Public destination "Centos-NAT" application web-browsing service application-default action allow
#Allowing SMTP,POP3,IMAP To Fedora From External
set rulebase security rules "Fedora Mail SMTP External Access" from External source any to Public destination "Fedora-NAT" application smtp service application-default action allow
set rulebase security rules "Fedora Mail POP3 External Access" from External source any to Public destination "Fedora-NAT" application pop3 service application-default action allow
set rulebase security rules "Fedora Mail IMAP External Access" from External source any to Public destination "Fedora-NAT" application imap service application-default action allow
#Allowing LDAP To AD From Fedora  
set rulebase security rules "Fedora AD Auth" from Public source Fedora to User destination AD application ldap service application-default action allow
#Allowing Splunk Traffic To Splunk From Internal And User 
set rulebase security rules "Internal to Splunk App" from Internal source any to Public destination "Splunk" application splunk service application-default action allow
set rulebase security rules "User to Splunk App" from User source any to Public destination "Splunk" application splunk service application-default action allow
set rulebase security rules "Internal Serve Splunk" from Internal source any to Public destination "Splunk" application web-browsing service port-8000 action allow
set rulebase security rules "User Serve Splunk" from User source any to Public destination "Splunk" application web-browsing service port-8000 action allow
#Allowing Port 8000 To Splunk From External
set rulebase security rules "External Web Access to Splunk" from External source any to Public destination "Splunk-NAT" application web-browsing service port-8000 action allow
#Allowing DNS To Debian From External
set rulebase security rules "External DNS Access" from External source any to Internal destination "Debian-NAT" application dns service application-default action allow
#Allowing DNS To Debian From Public And User
set rulebase security rules "Public NTP Access to Debian" from Public source any to Internal destination "Debian" application ntp service application-default action allow
set rulebase security rules "User NTP Access" from User source any to Internal destination "Debian" application ntp service application-default action allow
#Allowing HTTPS And SSH To Palo From WKS
set rulebase security rules "Allow HTTPS to Palo MGT from WKS" from User source "WKS" to "palo mgmt" destination "palo mgmt" application any service service-https action allow
set rulebase security rules "Allow SSH to Palo MGT from WKS" from User source "WKS" to "palo mgmt" destination "palo mgmt" application "ssh" service "service-ssh" action allow
#Block All Traffic To and From WKS (Disabled)
set rulebase security rules "Block Egress Traffic from WKS" from User source "WKS" to any destination any application any service any action deny
set rulebase security rules "Block Egress Traffic from WKS" disabled yes
#Allow Egress DNS ONLY DEBIAN (Disabled)
set rulebase security rules "Egress Allow DNS from Debian" from Internal source debian to External destination any application dns service application-default action allow
set rulebase security rules "Egress Allow DNS from Debian" disabled yes
#Allow NTP to External From Debian 
set rulebase security rules "Egress Allow NTP from Debian" from Internal source debian to External destination any application ntp service application-default action allow
#Allow Egress DNS,HTTP,HTTPS
set rulebase security rules "Egress Allow DNS" from any source any to External destination any application dns service application-default action allow
set rulebase security rules "Egress Allow HTTP" from any source any to External destination any application web-browsing service application-default action allow
set rulebase security rules "Egress Allow HTTPS" from any source any to External destination any application any service service-https action allow

#Catch-All Deny 
set rulebase security rules "Catch-All Deny Egress" from any source any to External destination any application any service any action deny

set rulebase security rules "Allow Ping" log-start yes log-end yes
set rulebase security rules "Ubuntu Web External Access" log-start yes log-end yes
set rulebase security rules "AD DNS External Access" log-start yes log-end yes
set rulebase security rules "Centos E-comm External Access" log-start yes log-end yes
set rulebase security rules "Fedora Mail SMTP External Access" log-start yes log-end yes
set rulebase security rules "Fedora Mail POP3 External Access" log-start yes log-end yes
set rulebase security rules "Fedora Mail IMAP External Access" log-start yes log-end yes
set rulebase security rules "Fedora AD Auth" log-start yes log-end yes
set rulebase security rules "Internal to Splunk App" log-start yes log-end yes
set rulebase security rules "User to Splunk App" log-start yes log-end yes
set rulebase security rules "Internal Serve Splunk" log-start yes log-end yes
set rulebase security rules "User Serve Splunk" log-start yes log-end yes
set rulebase security rules "External Web Access to Splunk" log-start yes log-end yes
set rulebase security rules "External DNS Access" log-start yes log-end yes
set rulebase security rules "Public NTP Access to Debian" log-start yes log-end yes
set rulebase security rules "User NTP Access" log-start yes log-end yes
set rulebase security rules "Allow HTTPS to Palo MGT from WKS" log-start yes log-end yes
set rulebase security rules "Allow SSH to Palo MGT from WKS" log-start yes log-end yes
set rulebase security rules "Block Egress Traffic from WKS" log-start yes log-end yes
set rulebase security rules "Egress Allow DNS from Debian" log-start yes log-end yes
set rulebase security rules "Egress Allow DNS" log-start yes log-end yes
set rulebase security rules "Egress Allow HTTP" log-start yes log-end yes
set rulebase security rules "Egress Allow HTTPS" log-start yes log-end yes
set rulebase security rules "Egress Allow NTP from Debian" log-start yes log-end yes
set rulebase security rules "Catch-All Deny Egress" log-start yes log-end yes

set profiles virus Best_Sec_Policy decoder ftp action reset-both
set profiles virus Best_Sec_Policy decoder http action reset-both
set profiles virus Best_Sec_Policy decoder imap action reset-both
set profiles virus Best_Sec_Policy decoder pop3 action reset-both
set profiles virus Best_Sec_Policy decoder smb action reset-both
set profiles virus Best_Sec_Policy decoder smtp action reset-both
set profiles virus Best_Sec_Policy decoder ftp wildfire-action reset-both
set profiles virus Best_Sec_Policy decoder http wildfire-action reset-both
set profiles virus Best_Sec_Policy decoder imap wildfire-action reset-both
set profiles virus Best_Sec_Policy decoder pop3 wildfire-action reset-both
set profiles virus Best_Sec_Policy decoder smb wildfire-action reset-both
set profiles virus Best_Sec_Policy decoder smtp wildfire-action reset-both

set profiles vulnerability Best_Sec_Policy rules simple-client-critical threat-name any cve any host client severity critical category any action reset-both
set profiles vulnerability Best_Sec_Policy rules simple-client-critical packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-client-high threat-name any cve any host client severity high category any action reset-both
set profiles vulnerability Best_Sec_Policy rules simple-client-high packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-client-medium threat-name any cve any host client severity medium category any action reset-both
set profiles vulnerability Best_Sec_Policy rules simple-client-medium packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-client-informational threat-name any cve any host client severity informational category any action default
set profiles vulnerability Best_Sec_Policy rules simple-client-informational packet-capture disable vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-client-low threat-name any cve any host client severity low category any action default
set profiles vulnerability Best_Sec_Policy rules simple-client-low packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-server-critical threat-name any cve any host server severity critical category any action reset-both
set profiles vulnerability Best_Sec_Policy rules simple-server-critical packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-server-high threat-name any cve any host server severity high category any action reset-both
set profiles vulnerability Best_Sec_Policy rules simple-server-high packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-server-medium threat-name any cve any host server severity medium category any action reset-both
set profiles vulnerability Best_Sec_Policy rules simple-server-medium packet-capture single-packet vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-server-informational threat-name any cve any host server severity informational category any action default
set profiles vulnerability Best_Sec_Policy rules simple-server-informational packet-capture disable vendor-id any
set profiles vulnerability Best_Sec_Policy rules simple-server-low threat-name any cve any host server severity low category any action default
set profiles vulnerability Best_Sec_Policy rules simple-server-low packet-capture single-packet vendor-id any

set profiles spyware Best_Sec_Policy rules simple-critical severity critical action reset-both
set profiles spyware Best_Sec_Policy rules simple-critical category any packet-capture single-packet threat-name any
set profiles spyware Best_Sec_Policy rules simple-high severity high action reset-both
set profiles spyware Best_Sec_Policy rules simple-high category any packet-capture single-packet threat-name any
set profiles spyware Best_Sec_Policy rules simple-medium severity medium action reset-both
set profiles spyware Best_Sec_Policy rules simple-medium category any packet-capture single-packet threat-name any
set profiles spyware Best_Sec_Policy rules simple-informational severity informational action default
set profiles spyware Best_Sec_Policy rules simple-informational category any packet-capture disable threat-name any
set profiles spyware Best_Sec_Policy rules simple-low severity low action default
set profiles spyware Best_Sec_Policy rules simple-low category any packet-capture disable threat-name any

set profiles wildfire-analysis Best_Sec_Policy rules "Send All" application any file-type any direction both analysis public-cloud

set profile-group Best_Practice_Security file-blocking "strict file blocking" spyware Best_Sec_Policy virus Best_Sec_Policy vulnerability Best_Sec_Policy url-filtering default wildfire-analysis Best_Sec_Policy

set rulebase security rules "Allow Ping" profile-setting group Best_Practice_Security
set rulebase security rules "Ubuntu Web External Access" profile-setting group Best_Practice_Security
set rulebase security rules "AD DNS External Access" profile-setting group Best_Practice_Security
set rulebase security rules "Centos E-comm External Access" profile-setting group Best_Practice_Security
set rulebase security rules "Fedora Mail SMTP External Access" profile-setting group Best_Practice_Security
set rulebase security rules "Fedora Mail POP3 External Access" profile-setting group Best_Practice_Security
set rulebase security rules "Fedora Mail IMAP External Access" profile-setting group Best_Practice_Security
set rulebase security rules "Fedora AD Auth" profile-setting group Best_Practice_Security
set rulebase security rules "Internal to Splunk App" profile-setting group Best_Practice_Security
set rulebase security rules "User to Splunk App" profile-setting group Best_Practice_Security
set rulebase security rules "Internal Serve Splunk" profile-setting group Best_Practice_Security
set rulebase security rules "User Serve Splunk" profile-setting group Best_Practice_Security
set rulebase security rules "External Web Access to Splunk" profile-setting group Best_Practice_Security
set rulebase security rules "External DNS Access" profile-setting group Best_Practice_Security
set rulebase security rules "Public NTP Access to Debian" profile-setting group Best_Practice_Security
set rulebase security rules "User NTP Access" profile-setting group Best_Practice_Security
set rulebase security rules "Block Egress Traffic from WKS" profile-setting group Best_Practice_Security
set rulebase security rules "Allow HTTPS to Palo MGT from WKS" profile-setting group Best_Practice_Security
set rulebase security rules "Allow SSH to Palo MGT from WKS" profile-setting group Best_Practice_Security
set rulebase security rules "Egress Allow DNS" profile-setting group Best_Practice_Security
set rulebase security rules "Egress Allow DNS from Debian" profile-setting group Best_Practice_Security
set rulebase security rules "Egress Allow HTTP" profile-setting group Best_Practice_Security
set rulebase security rules "Egress Allow HTTPS" profile-setting group Best_Practice_Security
set rulebase security rules "Egress Allow NTP from Debian" profile-setting group Best_Practice_Security
set rulebase security rules "Catch-All Deny Egress" profile-setting group Best_Practice_Security


set deviceconfig system ntp-servers primary-ntp-server ntp-server-address 172.20.240.20 authentication-type none
set deviceconfig system login-banner "Team 14 network for work only. Monitoring in place. Will provide information to law enforcement if used without authorization."
