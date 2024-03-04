Write-Host "Start windows scheduler task \JDA\multidailycreateplano"
Start-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreateplano"
$varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreateplano"
while($varTask.State -eq "Running") {
    Write-Host "Task is running. Sleeping for 60 seconds"        
    Start-Sleep -Seconds 60
    $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreateplano"
}
Write-Host "Task completed."