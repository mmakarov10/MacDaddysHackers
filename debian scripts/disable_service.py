#!/usr/bin/env python3
import subprocess

# List of services to disable
services = [
    "vsftpd",
    "proftpd",
    "sshd",
    "postfix",
    "apache2",
    "rpcbind",
    "exim4",
    "avahi-daemon",
    "ModemManager"
]

def run_command(command):
    """Execute a shell command and return the output."""
    try:
        result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return e.stderr.strip()

for service in services:
    print(f"\n🔍 Checking status of {service}...")

    # Check if service exists
    check_service = run_command(f"systemctl list-units --type=service | grep -w {service}.service")
    
    if check_service:
        print(f"✅ {service} exists. Stopping and disabling it...")
        
        # Stop the service
        stop_output = run_command(f"sudo systemctl stop {service}")
        print(f"🛑 Stopping {service}: {stop_output}")
        
        # Disable the service
        disable_output = run_command(f"sudo systemctl disable {service}")
        print(f"🚫 Disabling {service}: {disable_output}")
        
    else:
        print(f"⚠️ {service} not found or already disabled.")

print("\n✅ All specified services have been processed.")
