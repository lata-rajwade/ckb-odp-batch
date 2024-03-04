Write-Host "Start windows scheduler task \JDA\ckbcreateplanogram"
Start-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreateplanogram"
$varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreateplanogram"
while($varTask.State -eq "Running") {
    Write-Host "Task is running. Sleeping for 60 seconds"        
    Start-Sleep -Seconds 60
    $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreateplanogram"
}
Write-Host "Task completed."

