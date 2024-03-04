Write-Host "Start windows scheduler task \JDA\ckbcreatefloorplan"
Start-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreatefloorplan"
$varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreatefloorplan"
while($varTask.State -eq "Running") {
    Write-Host "Task is running. Sleeping for 60 seconds"        
    Start-Sleep -Seconds 60
    $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreatefloorplan"
}
Write-Host "Task completed."