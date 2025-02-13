# Stop, disable, and view services status
echo "Modifying services"

# Print Spooler Service
Stop-Service -Name Spooler -Force
Set-Service -Name Spooler -StartupType Disabled
echo "Print Spooler service status:"
Get-Service -Name Spooler

# RDP Usermode Port
Stop-Service -Name UmRdpService
Set-Service -Name UmRdpService -StartupType Disabled
echo "RDP Usermode Port service status:"
Get-Service -Name UmRdpService

# RDP Desktop Service
Stop-Service -Name SessionEnv
Set-Service -Name SessionEnv -StartupType Disabled
echo "RDP Desktop service status:"
Get-Service -Name SessionEnv

# RDP Service
Stop-Service -Name TermService
Set-Service -Name TermService -StartupType Disabled
echo "RDP service status:"
Get-Service -Name TermService

# Start configuring firewall rules
echo ""
echo "Disabling all inbound rules..."
Disable-NetFirewallRule -Direction Inbound

# Set explicit inbound firewall deny rule
echo "Setting explicit firewall rules..."
New-NetFirewallRule -DisplayName "Initial Block" `
-Direction Inbound `
-LocalPort 88,135,139,445,49152-49157 `
-Protocol TCP `
-Action Block

# Set outbound firewall deny rule
New-NetFirewallRule -DisplayName "Initial Block" `
-Direction Outbound `
-LocalPort 88,135,139,445,49152-49157 `
-Protocol TCP `
-Action Block

echo ""
echo "Enabling necessary firewall rules..."

# Check if the rules exist first before setting them
$rules = @(
    "Active Directory Domain Controller - Echo Request (ICMPv4-In)",
    "Google Chrome (mDNS-In)",
    "Secure Socket Tunneling Protocol (SSTP-In)",
    "World Wide Web Services (HTTPS Traffic-In)",
    "World Wide Web Services (HTTP Traffic-In)"
)

foreach ($rule in $rules) {
    if (Get-NetFirewallRule -DisplayName $rule -ErrorAction SilentlyContinue) {
        Set-NetFirewallRule -DisplayName $rule -Enabled True
    } else {
        echo "WARNING: Firewall rule '$rule' does not exist. Skipping..."
    }
}

# Modify LDAP Authentication Firewall rules to allow authentication from Fedora
echo "Configuring LDAP Authentication firewall rules..."
$MailAddr = Read-Host -Prompt "Input Mail Server IP for firewall rules"
Set-NetFirewallRule -DisplayName "Active Directory Domain Controller - LDAP (UDP-In)" -Enabled True -LocalAddress $MailAddr
Set-NetFirewallRule -DisplayName "Active Directory Domain Controller - LDAP (TCP-In)" -Enabled True -LocalAddress $MailAddr
Set-NetFirewallRule -DisplayName "Active Directory Domain Controller - LDAP for Global Catalog (TCP-In)" -Enabled True -LocalAddress $MailAddr
Set-NetFirewallRule -DisplayName "Active Directory Domain Controller - Secure LDAP (TCP-In)" -Enabled True -LocalAddress $MailAddr
Set-NetFirewallRule -DisplayName "Active Directory Domain Controller - Secure LDAP for Global Catalog (TCP-In)" -Enabled True -LocalAddress $MailAddr

# Configure DNS Firewall Rules
echo "Configuring DNS firewall rules..."
Set-NetFirewallRule -DisplayName "DNS (TCP, Incoming)" -Enabled True -Profile Public,Private,Domain
Set-NetFirewallRule -DisplayName "DNS (UDP, Incoming)" -Enabled True -Profile Public,Private,Domain

# Configure w32tm firewall rule to only accept packets from Debian NTP server
echo "Configuring w32time firewall rule..."
$NtpAddr = Read-Host -Prompt "Input external NTP Server IP"
Set-NetFirewallRule -DisplayName "Active Directory Domain Controller - W32Time (NTP-UDP-In)" -Enabled True -LocalAddress $NtpAddr

# Configure w32tm (ntp) to point to Debian
echo "Preparing to set up NTP..."
net start w32time
$Option = Read-Host -Prompt "Setup NTP as server? ('y' or 'n')"
if ($Option -eq "y") {
    echo "SETTING UP NTP SERVER..."
    w32tm /config /manualpeerlist:time.nist.gov /syncfromflags:manual /reliable:yes /update
} else {
    echo "SETTING UP NTP CLIENT..."
    w32tm /config /manualpeerlist:$NtpAddr /syncfromflags:manual /reliable:yes /update
}

# Restart Windows Time Service
echo "Restarting w32time service..."
net stop w32time
net start w32time

# Check peers and source
echo "---PEERS OUTPUT---"
w32tm /query /peers
echo "---SOURCE OUTPUT---"
w32tm /query /source
echo "If the source is still Local CMOS Clock, try 'w32tm /query /source' later."

Read-Host -Prompt "Finished configuring w32time. Press Enter to continue."

# Enable additional networking rules
Set-NetFirewallRule -DisplayName "Core Networking - Destination Unreachable Fragmentation Needed (ICMPv4-In)" -Enabled True
Set-NetFirewallRule -DisplayName "Core Networking - Dynamic Host Configuration Protocol (DHCP-In)" -Enabled True
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -Enabled True

echo "Disabling unnecessary firewall outbound 'allow' rules..."
Set-NetFirewallRule -DisplayName "Active Directory Web Services (TCP-Out)" -Enabled False
Set-NetFirewallRule -DisplayName "File and Printer Sharing (SMB-Out)" -Enabled False
Set-NetFirewallRule -DisplayName "Routing and Remote Access (GRE-Out)" -Enabled False

# Add AD User for mail binding
echo "Adding proftpd user for mail binding..."
New-ADUser proftpd -AccountPassword (Read-Host -AsSecureString "Input Password for user proftpd") -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $true

# View local administrators
echo "Confirm Administrator accounts!!!"
net localgroup administrators
Read-Host -Prompt "Confirm Administrators, then press ENTER to continue."

# Section: Scheduled Tasks Review
echo ""
echo "Reviewing Scheduled Tasks"
echo "--------------------------"


# List all scheduled tasks with their next run time and last modification date
echo ""
echo "Listing all scheduled tasks with next run time and last modified date..."
Get-ScheduledTask | Select-Object TaskName, TaskPath, State, `
    @{Name="NextRunTime"; Expression={(Get-ScheduledTaskInfo -TaskName $_.TaskName -TaskPath $_.TaskPath).NextRunTime}}, `
    @{Name="LastModified"; Expression={(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$($_.TaskName)" -ErrorAction SilentlyContinue).LastWriteTime}} `
    | Format-Table -AutoSize


# Check for suspicious scheduled tasks (e.g., tasks running as SYSTEM or a specific user)
echo ""
echo "Checking for suspicious scheduled tasks..."
Get-ScheduledTask | Where-Object { $_.Principal.UserId -eq "NT AUTHORITY\SYSTEM" } | `
    Select-Object TaskName, Principal, `
    @{Name="NextRunTime"; Expression={(Get-ScheduledTaskInfo -TaskName $_.TaskName -TaskPath $_.TaskPath).NextRunTime}}, `
    @{Name="LastModified"; Expression={(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$($_.TaskName)" -ErrorAction SilentlyContinue).LastWriteTime}} `
    | Format-Table -AutoSize


# Check for disabled tasks
echo ""
echo "Listing Disabled Tasks..."
Get-ScheduledTask | Where-Object { $_.State -eq "Disabled" } | `
    Select-Object TaskName, State, `
    @{Name="NextRunTime"; Expression={(Get-ScheduledTaskInfo -TaskName $_.TaskName -TaskPath $_.TaskPath).NextRunTime}}, `
    @{Name="LastModified"; Expression={(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$($_.TaskName)" -ErrorAction SilentlyContinue).LastWriteTime}} `
    | Format-Table -AutoSize


# Check for recently created or modified tasks (within last 7 days)
echo ""
echo "Checking for recently modified tasks..."
$Last7Days = (Get-Date).AddDays(-7)
Get-ScheduledTask | ForEach-Object {
    $taskName = $_.TaskName
    $taskPath = $_.TaskPath
    $taskInfo = Get-ScheduledTaskInfo -TaskName $taskName -TaskPath $taskPath -ErrorAction SilentlyContinue
    $lastModified = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$taskName" -ErrorAction SilentlyContinue).LastWriteTime
    if ($lastModified -gt $Last7Days) {
        [PSCustomObject]@{
            TaskName = $taskName
            TaskPath = $taskPath
            LastRunTime = $taskInfo.LastRunTime
            NextRunTime = $taskInfo.NextRunTime
            LastModified = $lastModified
        }
    }
} | Format-Table -AutoSize


# Provide option to disable suspicious tasks
echo ""
$DisableTask = Read-Host -Prompt "Enter the name of any suspicious scheduled task you want to disable (or press Enter to skip)"
if ($DisableTask -ne "") {
    Disable-ScheduledTask -TaskName $DisableTask -Confirm:$false
    echo "Task $DisableTask has been disabled."
}


# Keep window open until finished reviewing
Read-Host -Prompt "Finished reviewing scheduled tasks. Press Enter to continue."

# Registry Security Audit
echo ""
echo "Reviewing Registry Keys for Suspicious Entries"
echo "----------------------------------------------"

# Define common persistence registry locations
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
)

# Check for suspicious registry keys
echo ""
echo "Checking common persistence locations..."
foreach ($path in $registryPaths) {
    if (Test-Path $path) {
        echo "Inspecting: $path"
        Get-ItemProperty -Path $path | Select-Object PSChildName, Name, Value | Format-Table -AutoSize
    } else {
        echo "Skipping: $path (Path does not exist)"
    }
}

# Check for recently modified registry keys
echo ""
echo "Checking for recently modified registry keys..."
$Last7Days = (Get-Date).AddDays(-7)
$modifiedKeys = @()

foreach ($path in $registryPaths) {
    if (Test-Path $path) {
        $keys = Get-ChildItem -Path $path
        foreach ($key in $keys) {
            $keyPath = $key.Name -replace "HKEY_LOCAL_MACHINE", "HKLM:" -replace "HKEY_CURRENT_USER", "HKCU:"
            $lastWriteTime = (Get-ItemProperty -Path $keyPath -ErrorAction SilentlyContinue).PSChildName | Get-Item -ErrorAction SilentlyContinue | Select-Object -ExpandProperty LastWriteTime

            if ($lastWriteTime -and $lastWriteTime -gt $Last7Days) {
                $modifiedKeys += [PSCustomObject]@{
                    RegistryKey  = $keyPath
                    LastModified = $lastWriteTime
                }
            }
        }
    }
}

if ($modifiedKeys.Count -gt 0) {
    echo "Recently modified registry keys (last 7 days):"
    $modifiedKeys | Format-Table -AutoSize
} else {
    echo "No recent modifications found in common persistence locations."
}

# Detect hidden registry keys (common malware trick)
echo ""
echo "Checking for hidden registry keys..."
$hiddenKeys = @()
foreach ($path in $registryPaths) {
    if (Test-Path $path) {
        $keys = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
        foreach ($key in $keys) {
            if ($key.Attributes -match "Hidden") {
                $hiddenKeys += [PSCustomObject]@{
                    RegistryKey = $key.Name
                    Attributes  = $key.Attributes
                }
            }
        }
    }
}

if ($hiddenKeys.Count -gt 0) {
    echo "WARNING: Hidden registry keys detected!"
    $hiddenKeys | Format-Table -AutoSize
} else {
    echo "No hidden registry keys detected."
}

# Provide option to remove suspicious entries
echo ""
$RemoveKey = Read-Host -Prompt "Enter the full path of a suspicious registry key to remove (or press Enter to skip)"
if ($RemoveKey -ne "") {
    Remove-Item -Path $RemoveKey -Force -Confirm:$false
    echo "Registry key $RemoveKey has been removed."
}

# Keep window open until finished reviewing
Read-Host -Prompt "Finished reviewing registry keys. Press Enter to continue."





# Open Task Scheduler
echo "Opening Task Scheduler for manual review..."
taskschd

Read-Host -Prompt "Finished script. Press ENTER to exit."



