
@echo off

rem ***
rem *** CKBPUBLISH
rem ***
rem *** Set profile to execute in the DEV environment
rem ***

set CKB_ProgramToRun=ckbcreate
set CKB_TOP=D:\ckb\prd
set CKB_DATA=%CKB_TOP%\data
rem *** set CKB_JAVA_HOME=C:\Program Files\Java\jdk1.8.0_101
D:

%CKB_TOP%\bin\%CKB_ProgramToRun%.cmd MultiDailyCreateFloor.exe