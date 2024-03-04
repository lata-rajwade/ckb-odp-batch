Write-Host "Start windows scheduler task \JDA\createliveplanos"
Start-ScheduledTask -TaskPath "\JDA\" -Taskname "createliveplanos"
$varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "createliveplanos"
while($varTask.State -eq "Running") {
    Write-Host "Task is running. Sleeping for 60 seconds"        
    Start-Sleep -Seconds 60
    $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "createliveplanos"
}
Write-Host "Task completed."