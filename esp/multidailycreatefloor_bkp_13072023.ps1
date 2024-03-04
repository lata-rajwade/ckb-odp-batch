$RunAs32Bit = {

 net use X: "\\ODSC03\SPPO$"
 net use Y: "\\USHQFS1\PLANOGRAMS$"
 net use Z: "\\USHQFS1\STOREMAPS$"

Write-Host "Start windows scheduler task \JDA\multidailycreatefloor"

 $logfile = Get-Date -UFormat %m-%d-%Y%T | foreach {$_ -replace ":", ""}
 $pdflog =  "PDFlog_"+$logfile+".txt"
 Write-Host "Log FileName "$pdflog
 $pdflog|out-file -encoding ASCII Z:\Manual_PDF\log\PDFLogHeader.txt

        $result = 1
        $safetyCheck = 0 
        $maxRuns = 50
        Do
        {	
       Remove-Item "Z:\Manual_PDF\log\processedPDFs.txt"	
	  $safetyCheck = $safetyCheck + 1
      #Write-Host "Loop count $safetyCheck" 
      
     Start-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreatefloor"
     $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreatefloor"
	      
      while($varTask.State -eq "Running")
        {
           Write-Host "Task is running. Sleeping for 60 seconds"        
           Start-Sleep -Seconds 60
           $varTask = Get-ScheduledTask -TaskPath "\JDA\" -Taskname "multidailycreatefloor"
            
           }
      
         $inputString = Get-Content "Z:\Manual_PDF\log\processedPDFs.txt"
           
          $asm = [System.Reflection.Assembly]::LoadWithPartialName("System.Data.OracleClient") 
		  $connectionString = "Data Source=chgd05dbs047p:1551/CKBPRD01;uid=CKB_OD;pwd=WMeIAev6";			
	
	
	  $oracleConnection = new-object System.Data.OracleClient.OracleConnection($connectionString);
	  $cmd = new-object System.Data.OracleClient.OracleCommand;
	  $cmd.Connection = $oracleConnection;
	

	  $cmd.CommandText = "CKB_OD.OD_POST_PDF_PROCESS";
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
             }
           
         
         } While ($result -gt 0)



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