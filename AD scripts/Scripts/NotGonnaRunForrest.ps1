$Script = @"
`$Tips = @(
    "Life is like a box of chocolates; you never know what you're gonna get.",
    "Stupid is as stupid does.",
    "My Mama always said you've got to put the past behind you before you can move on.",
    "You have to do the best with what God gave you.",
    "Miracles happen every day. Just believe."
)


while (`$True) {
`$Tip = `$Tips | Get-Random
    `$Message = New-Object -ComObject WScript.Shell
    `$Message.Popup(`$Tip, 0, "Mama's Tip", 0x0 + 0x1000)
    [Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process -Id `$pid).MainWindowTitle)
    
}
"@

$ScriptPath = "C:\Windows\System32\MamasTips.ps1"
$TaskName = "TipScheduler"

$Script | Out-File $ScriptPath -Encoding ASCII

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -NoExit -File $ScriptPath"
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration ([System.TimeSpan]::MaxValue)
$Settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 24) -StartWhenAvailable -MultipleInstances Parallel -Priority 3
$Task = Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $TaskName -Settings $Settings

Write-Output "Mama's Tips scheduled task created."
