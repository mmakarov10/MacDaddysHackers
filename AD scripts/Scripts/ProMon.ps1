 # Log file location
$logPath = "C:\ProcessMonitorLog.txt"

# Ensure log file exists
if (!(Test-Path $logPath)) {
    New-Item -Path $logPath -ItemType File | Out-Null
}

# Function to write logs with timestamps
function Write-Log {
    param($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logPath -Value $logMessage
}

# Dictionary to store already detected processes
$DetectedProcesses = @{}

# Infinite monitoring loop
while ($true) {
    # Get initial list of running processes
    $Processes = Get-WmiObject Win32_Process | Select-Object ProcessId, Name, CommandLine, CreationDate, ExecutablePath

    while ($true) {
        # Get updated process list
        $Processes2 = Get-WmiObject Win32_Process | Select-Object ProcessId, Name, CommandLine, CreationDate, ExecutablePath

        # Compare lists to detect new processes
        $diff = Compare-Object -ReferenceObject $Processes -DifferenceObject $Processes2 -Property ProcessId

        if ($null -ne $diff) {
            foreach ($change in $diff) {
                $NewProcess = $Processes2 | Where-Object { $_.ProcessId -eq $change.ProcessId }

                if ($NewProcess -and -not $DetectedProcesses.ContainsKey($NewProcess.ProcessId)) {
                    # Convert WMI time format to readable time
                    $StartTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($NewProcess.CreationDate)

                    # Process details
                    $ProcessName = $NewProcess.Name
                    $ProcessID = $NewProcess.ProcessId
                    $ProcessPath = if ($NewProcess.ExecutablePath) { $NewProcess.ExecutablePath } else { "N/A" }
                    $CommandLine = if ($NewProcess.CommandLine) { $NewProcess.CommandLine } else { "N/A" }

                    # Write details to console
                    Write-Output "A NEW PROCESS HAS STARTED"
                    Write-Output "Process Name: $ProcessName"
                    Write-Output "Process ID: $ProcessID"
                    Write-Output "Path: $ProcessPath"
                    Write-Output "Command Line: $CommandLine"
                    Write-Output "Start Time: $StartTime"
                    Write-Output "A NEW PROCESS HAS STARTED"
                    Write-Output "Terminate this process? (y/n)"

                    # Write to log file
                    Write-Log "NEW PROCESS: Name=$ProcessName | ID=$ProcessID | Path=$ProcessPath | CommandLine=$CommandLine | Start Time=$StartTime"

                    # Store process in dictionary to prevent repeated prompts
                    $DetectedProcesses[$ProcessID] = $true

                    # User input for process termination
                    $Return = Read-Host

                    if (($Return -eq "Y") -or ($Return -eq "y")) {
                        Stop-Process -Id $ProcessID -Force -ErrorAction SilentlyContinue
                        Write-Output "Process $ProcessName ($ProcessID) has been eliminated..."
                        Write-Output "Might want to search for some bad guys around here..."

                        # Log termination
                        Write-Log "TERMINATED: $ProcessName (PID: $ProcessID)"
                    }
                    elseif (($Return -eq "N") -or ($Return -eq "n")) {
                        Write-Output "Letting that process slide... for now..."
                    }
                }
            }
        }

        # Sleep before checking again
        Start-Sleep -Seconds 1
    }
}



