# Log file for command execution tracking
$logPath = "C:\CommandExecutionLog.txt"


# Create the log file if it doesn't exist
if (!(Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType File | Out-Null
}


# Function to write logs
function Write-Log {
    param($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logPath -Value $logMessage
}


Write-Host "Monitoring all executed commands... Press Ctrl+C to stop."


# Main monitoring loop
while ($true) {
    # Get running processes with their command line arguments
    $Processes = Get-WmiObject Win32_Process | Select-Object ProcessId, Name, CommandLine, CreationDate, Handle


    Start-Sleep -Seconds 1  # Wait 1 second before checking again


    # Get updated process list
    $Processes2 = Get-WmiObject Win32_Process | Select-Object ProcessId, Name, CommandLine, CreationDate, Handle


    # Compare both lists to detect new commands executed
    $diff = Compare-Object -ReferenceObject $Processes -DifferenceObject $Processes2 -Property ProcessId


    if ($diff -ne $null) {
        foreach ($change in $diff) {
            $NewProcess = $Processes2 | Where-Object { $_.ProcessId -eq $change.ProcessId }


            if ($NewProcess) {
                # Convert WMI DateTime format to readable time
                $StartTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($NewProcess.CreationDate)


                # Log command execution
                $logMessage = "Command Executed: `"$($NewProcess.CommandLine)`" | Process: $($NewProcess.Name) | PID: $($NewProcess.ProcessId) | Start Time: $StartTime"
                Write-Log $logMessage


                Write-Output "A NEW COMMAND HAS BEEN EXECUTED"
                Write-Output "Command Line: $($NewProcess.CommandLine)"
                Write-Output "Process Name: $($NewProcess.Name)"
                Write-Output "Process ID: $($NewProcess.ProcessId)"
                Write-Output "Start Time: $StartTime"
                Write-Output "A NEW COMMAND HAS BEEN EXECUTED"
                Write-Output "Terminate this process? (y/n)"


                $Return = Read-Host


                if (($Return -eq "Y") -or ($Return -eq "y")) {
                    Stop-Process -Id $NewProcess.ProcessId -Force -ErrorAction SilentlyContinue
                    Write-Output "Process $($NewProcess.Name) ($($NewProcess.ProcessId)) has been eliminated..."
                    Write-Log "Process $($NewProcess.Name) ($($NewProcess.ProcessId)) was terminated."
                }
                elseif (($Return -eq "N") -or ($Return -eq "n")) {
                    Write-Output "Letting that process slide... for now..."
                    break
                }
            }
        }
    }
}



