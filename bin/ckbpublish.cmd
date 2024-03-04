
@echo off

rem ***
rem *** ckbPublish
rem ***
rem *** Uses environemntal variable
rem ***         CKB_ProgramToRun
rem *** 	CKB_TOP
rem ***         CKB_DATA 
rem ***         CKB_JAVA_HOME

set ckbPublishingRequest=%1
set ckbdate=%date:~4,2%-%date:~7,2%-%date:~-4%
set ckbtime=%time:~0,2%_%time:~3,2%_%time:~6,2%
set logfile=%CKB_DATA%\log\"%CKB_ProgramToRun%_%ckbdate%_%ckbtime%.log"

rem ***
rem *** Create log file
rem ***

echo. >> %logfile%
echo ********************************************************** >> %logfile%
echo	BEGINING OF FILE BATCH EXECUTION			>> %logfile%
echo	--------------------------------			>> %logfile%
echo	DATE : %ckbdate%					>> %logfile%
echo	TIME : %time:~0,2%:%time:~3,2%:%time:~6,2%		>> %logfile%
echo ********************************************************** >> %logfile%
echo. >> %logfile%
echo Exectued by user: %username%                      >> %logfile%
echo. >> %logfile%
echo Using CKB_ProgramToRun as %CKB_ProgramToRun%      >> %logfile%
echo Using CKB_TOP as %CKB_TOP%                        >> %logfile%
echo Using CKB_DATA as %CKB_DATA%                      >> %logfile%
echo Using CKB_JAVA_HOME as %CKB_JAVA_HOME%            >> %logfile%
echo. >> %logfile%
echo Parameter 1 is: %ckbPublishingRequest%            >> %logfile%
echo. >> %logfile%


rem *** Execute program
set _javaClassPath=%CKB_TOP%\javaJars\ckbPublisher.jar
set _javaClassPath=%_javaClassPath%;%CKB_TOP%\javaFrameworks\jackson\*
echo. >> %logfile%
echo The following comand will be executed: >> %logfile%
echo "%CKB_JAVA_HOME%\bin\java" -cp %_javaClassPath% od.ckb.publisher.entry.Publisher %ckbPublishingRequest% %CKB_DATA% >> %logfile%  
echo. >> %logfile%
echo Program log starts >> %logfile%
echo. >> %logfile
"%CKB_JAVA_HOME%\bin\java" -cp %_javaClassPath% od.ckb.publisher.entry.Publisher %ckbPublishingRequest% %CKB_DATA% >> %logfile% 2>&1  
echo. >> %logfile%
echo Program log ends >> %logfile%









