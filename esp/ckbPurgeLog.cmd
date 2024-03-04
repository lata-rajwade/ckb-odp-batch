
@echo off

rem ***
rem *** CKBPUBLISH
rem ***
rem *** Set profile to execute in the DEV environment
rem ***

REM *** Delete files that are 21 days old 

NET USE J: \\Ushqfs1\planograms$

rem forfiles /p "\\Ushqfs1\planograms$\Manual_PDF\log" /m *.*  /d -21 /c "cmd /c del @file"
forfiles /p "J:\Manual_PDF\log" /m *.*  /d -21 /c "cmd /c del @file"

rem forfiles /p "\\Ushqfs1\planograms$\JDA_PRD_Staging_D\log" /m *.*  /d -21 /c "cmd /c del @file"
forfiles /p "J:\JDA_PRD_Staging_D\log" /m *.*  /d -21 /c "cmd /c del @file"

NET USE J: /delete

NET USE J: \\Ushqfs1\Storemaps$

rem forfiles /p "\\USHQFS1\Storemaps$\Manual_PDF\log" /m *.*  /d -21 /c "cmd /c del @file"
forfiles /p "J:\Manual_PDF\log" /m *.*  /d -21 /c "cmd /c del @file"

rem forfiles /p "\\USHQFS1\Storemaps$\Merch_PRD\log" /m *.*  /d -21 /c "cmd /c del @file"
forfiles /p "J:\Merch_PRD\log" /m *.*  /d -21 /c "cmd /c del @file"

NET USE J: /delete

