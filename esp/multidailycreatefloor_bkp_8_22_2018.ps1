Write-Host "Start windows scheduler task \JDA\multidailycreatefloor"
Start-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreatefloor"
$varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreatefloor"
while($varTask.State -eq "Running") {
    Write-Host "Task is running. Sleeping for 60 seconds"        
    Start-Sleep -Seconds 60
    $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreatefloor"
}
Write-Host "Task completed."