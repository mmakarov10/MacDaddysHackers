# Define download URL for Splunk Universal Forwarder (Update URL if needed)
$SplunkURL = "https://download.splunk.com/products/universalforwarder/releases/latest/windows/splunkforwarder-9.2.0-x64-release.msi"

# Define download path
$DownloadPath = "$env:TEMP\splunkforwarder.msi"

# Download Splunk Forwarder
Write-Host "Downloading Splunk Forwarder..."
Invoke-WebRequest -Uri $SplunkURL -OutFile $DownloadPath

# Install Splunk Forwarder silently
Write-Host "Installing Splunk Forwarder..."
Start-Process msiexec.exe -ArgumentList "/i `"$DownloadPath`" AGREETOLICENSE=Yes /quiet" -Wait -NoNewWindow

# Start Splunk Forwarder service
Write-Host "Starting Splunk Universal Forwarder Service..."
Start-Service splunkforwarder

# Verify installation
Write-Host "Checking Splunk Forwarder status..."
Get-Service splunkforwarder
