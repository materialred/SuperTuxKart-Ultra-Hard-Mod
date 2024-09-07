::::::::::::::::::::::::::::::::::::::::::::
:: Elevate.cmd - Version 5
:: Automatically check & get admin rights
:: see "https://stackoverflow.com/a/12264592/1016343" for description
::::::::::::::::::::::::::::::::::::::::::::
 @echo off
 CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::START
 ::::::::::::::::::::::::::::
if exist "C:\Program Files\SuperTuxKart 1.4\data\.lock" (
    Echo Mod is Installed, press any key to remove it
    Pause > nul
    move "C:\Program Files\SuperTuxKart 1.4\data\kart_characteristics.xml.bak" "C:\Program Files\SuperTuxKart 1.4\data\kart_characteristics.xml"
    move "C:\Program Files\SuperTuxKart 1.4\data\stk_config.xml.bak" "C:\Program Files\SuperTuxKart 1.4\data\stk_config.xml"

    del "C:\Program Files\SuperTuxKart 1.4\data\stk_config.xml.bak"
    del "C:\Program Files\SuperTuxKart 1.4\data\kart_characteristics.xml.bak"
    del "C:\Program Files\SuperTuxKart 1.4\data\.lock"
) else (
    ECHO Press any key to install the Mod
    Pause > nul
    move "C:\Program Files\SuperTuxKart 1.4\data\kart_characteristics.xml" "C:\Program Files\SuperTuxKart 1.4\data\kart_characteristics.xml.bak"
    move "C:\Program Files\SuperTuxKart 1.4\data\stk_config.xml" "C:\Program Files\SuperTuxKart 1.4\data\stk_config.xml.bak"
    echo.>"C:\Program Files\SuperTuxKart 1.4\data\.lock"

    copy stk_config.xml  "C:\Program Files\SuperTuxKart 1.4\data\stk_config.xml"
    copy kart_characteristics.xml "C:\Program Files\SuperTuxKart 1.4\data\kart_characteristics.xml"


)


Echo Completed! Press any key to close
PAUSE > nul



