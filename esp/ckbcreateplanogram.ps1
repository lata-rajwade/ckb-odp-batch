﻿$RunAs32Bit = {

 net use X: "\\ODSC03\SPPO$"
 net use Y: "\\USHQFS1\PLANOGRAMS$"
 net use Z: "\\USHQFS1\STOREMAPS$"

Write-Host "Start windows scheduler task \JDA\ckbcreateplanogram"

 $logfile = Get-Date -UFormat %m-%d-%Y%T | foreach {$_ -replace ":", ""}
 $pdflog =  "PDFlog_"+$logfile+".txt"
 Write-Host "Log FileName "$pdflog
 $pdflog|out-file -encoding ASCII Y:\JDA_PRD_Staging_D\log\PDFPOGLCMLogHeader.txt

        $result = 1
        $safetyCheck = 0 
        $maxRuns = 50
        Do
        {	
       Remove-Item "Y:\JDA_PRD_Staging_D\log\processedPOGLCMPDFs.txt"	
	  $safetyCheck = $safetyCheck + 1
      #Write-Host "Loop count $safetyCheck" 
      
     Start-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreateplanogram" 

    $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreateplanogram"
     
      while($varTask.State -eq "Running")
        {
           Write-Host "Task is running. Sleeping for 10 seconds"        
           Start-Sleep -Seconds 10
           $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "ckbcreateplanogram"
            
           }

      $inputString = Get-Content "Y:\JDA_PRD_Staging_D\log\processedPOGLCMPDFs.txt"
           
          $asm = [System.Reflection.Assembly]::LoadWithPartialName("System.Data.OracleClient") 
		  $connectionString = "Data Source=aoldckb01p.apdboracle2.aodvcni.oraclevcn.com:1521/CKBPRD01.apdboracle2.aodvcni.oraclevcn.com;uid=CKB_OD;pwd=WMeIAev6";			
	
	
	  $oracleConnection = new-object System.Data.OracleClient.OracleConnection($connectionString);
	  $cmd = new-object System.Data.OracleClient.OracleCommand;
	  $cmd.Connection = $oracleConnection;
	

	  $cmd.CommandText = "CKB_OD.OD_POST_POG_LCM_PDF_PROCESS";
	  $cmd.CommandType = [System.Data.CommandType]::StoredProcedure;
	  

    $cmd.Parameters.Add("o_Rows_Remaining", [System.Data.OracleClient.OracleType]::Number)  | out-null;
     $cmd.Parameters["o_Rows_Remaining"].Direction = [System.Data.ParameterDirection]::Output;

     	
   $cmd.Parameters.Add("i_PDF_list", [System.Data.OracleClient.OracleType]::VarChar) | out-null;
 $cmd.Parameters["i_PDF_list"].Direction = [System.Data.ParameterDirection]::Input;

 $cmd.Parameters["i_PDF_list"].Value = $inputString;
				
	
	
      $oracleConnection.Open();
	  $cmd.ExecuteNonQuery() | out-null;
	  $oracleConnection.Close();
	 
	  $result = $cmd.Parameters["o_Rows_Remaining"].Value;
       Write-Host "Remaining rows to process $result"
	 
          if ( $safetyCheck -ge $maxRuns) 
           {
             $result = 0
             write-host "Maximun runs of $maxRuns exceeded............Halting process";
             $SmtpClient = new-object system.net.mail.smtpClient

              $MailMessage = New-Object system.net.mail.mailmessage

              $SmtpClient.Host = ("chrelay.na.odcorp.net")

              $mailmessage.from = ("noreply@jda.officedepot.com")

              $mailmessage.To.add("IT_MERCH_OPS_DEV_ONCALL@officedepot.com,stephen.mondry@officedepot.com")
 
              $mailmessage.Subject =  "PRD - PDF Mail Notification - Nightly POG"

              $mailmessage.Body = "Nightly POG process loops for 50 times."

              $smtpclient.Send($mailmessage)
             }
           
         
         } While ($result -gt 0)


$fileCheck = “Y:\JDA_PRD_Staging_D\log\”+$pdflog

  if (-NOT $fileCheck) 
 {
 $SmtpClient = new-object system.net.mail.smtpClient

$MailMessage = New-Object system.net.mail.mailmessage

$SmtpClient.Host = ("chrelay.na.odcorp.net")

$mailmessage.from = ("no-reply-JDA@officedepot.com ")

$mailmessage.To.add("it_merchplan_oncall@officedepot.com")

$mailmessage.Subject = “No log found for PDF Process.”

$mailmessage.Body = “No log found for LCM PDF Process.Process may not have completed as expected”

$smtpclient.Send($mailmessage)

}

Write-Host "Task completed."

}

#Run the code in 32bit mode if PowerShell isn't already running in 32bit mode
If($env:PROCESSOR_ARCHITECTURE -ne "x86"){
    Write-Host "Task Started in 32bit mode."
    $Job = Start-Job $RunAs32Bit -RunAs32
    $SCStore = $Job | Wait-Job | Receive-Job
}Else{
    $SCStore = $RunAs32Bit.Invoke()
}

