@ECHO OFF

REM    The Universalator - Modded Minecraft Server Installation / Launching Program.
REM    Copyright (C) <2023>  <Kerry Sherwin>
REM
REM    This program is free software: you can redistribute it and/or modify
REM    it under the terms of the GNU General Public License as published by
REM    the Free Software Foundation, either version 3 of the License, or
REM    (at your option) any later version.
REM
REM    This program is distributed in the hope that it will be useful,
REM    but WITHOUT ANY WARRANTY; without even the implied warranty of
REM    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM    GNU General Public License for more details.
REM
REM    You should have received a copy of the GNU General Public License
REM    along with this program.  If not, see https://www.gnu.org/licenses/.




:: README BELOW -- NOTES -- README -- NOTES
:: ----------------------------------------------
:: INSTRUCTIONS FOR UNIVERSALATOR - MODDED MINECRAFT SERVER INSTALLER / LAUNCHER
:: ----------------------------------------------
  :: -TO USE THIS FILE:
  ::    CREATE A NEW FOLDER SUCH AS (example) C:\MYSERVER
  ::    IN THAT FOLDER PLACE THIS BAT FILE, THE MODS FOLDER AND ANY OTHER SPECIAL FOLDERS/FILES FROM AN EXISTING MODPACK OR CUSTOM PROFILE OR SERVER.
  ::    RUN THIS BAT FILE - EXECUTE NORMALLY, DO NOT RUN AS ADMIN
  ::
  :: 
  :: -TO CREATE A SERVER PACK
  ::    1- ONLY DO FOLLOWING AFTER SUCCESSFULLY LAUNCHING A SERVER AT LEAST ONCE ALL THE WAY TO WORLD CREATION - THIS GUARANTEES FILES AT LEAST WORK TO THAT POINT
  ::    3- CREATE A ZIP FILE CONTAINING:  
  ::        A- THIS BAT
  ::        B- settings-universalator.txt
  ::        C- THE 'MODS' FOLDER
  ::        D- ANY OTHER SPECIAL FOLDERS/FILES WANTED (FOR EXAMPLE THE 'CONFIGS' AND 'DEFAULTCONFIGS' FOLDERS).
  ::      DO NOT INCLUDE MODLOADER / MINECRAFT FILES/FOLDERS.  'DO NOT INCLUDE' EXAMPLES- LIBRARIES, .FABRIC, server.jar
  ::      ONLY INCLUDE FOLDERS/FILES THAT YOU KNOW ARE REQUIRED OR WANTED.  DEFAULT FOLDERS/FILES NOT INCLUDED WILL GENERATE AUTOMATICALLY WITH DEFAULT VALUES.
:: ------------------------------------------------
:: README ABOVE -- NOTES -- README -- NOTES





:: Enter custom JVM arguments in this ARGS variable
:: DO NOT INCLUDE Xmx -- THAT IS HANDLED BY ANOTHER VARIABLE IN PROGRAM
 SET ARGS=-XX:+IgnoreUnrecognizedVMOptions -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -XX:MaxGCPauseMillis=100 -XX:GCPauseIntervalMillis=150 -XX:TargetSurvivorRatio=90 -XX:+UseFastAccessorMethods -XX:+UseCompressedOops -XX:ReservedCodeCacheSize=2048m -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1NewSizePercent=30 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20








:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK









ECHO. && ECHO. && ECHO   Loading ... ... ...

:: BEGIN GENERAL PRE-RUN ITEMS
setlocal enabledelayedexpansion
TITLE Universalator
:: Sets the backgound color of the command window
color 1E
:: Additional JVM arguments that will always be applied
SET OTHERARGS=-Dlog4j2.formatMsgNoLookups=true
:: These variables set to exist as blank in case windows is older than 10 and they aren't assigned otherwise
SET "yellow="
SET "blue="
:: Sets the working directory to this folder directory in case something happens like user runs as admin
CD "%~dp0" >nul 2>&1
:: Sets a HERE variable equal to the current directory string.
SET "HERE=%cd%"

:: TEST LINES FOR WINDOW RESIZING - KIND OF SCREWEY NEEDS FURTHER CHECKS
::mode con: cols=160 lines=55
::powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=160;$B.height=9999;$W.buffersize=$B;}

:: WINDOWS VERSION CHECK
:: Versions equal to or older than Windows 8 (internal version number 6.2) will stop the script with warning.
for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (if %%i==Version (
    set major=%%j
    set minor=%%k 
    ) else (
    set major=%%i
    set minor=%%j
    ))

:: If Windows is greater than or equal to version 10 then set some variables to set console output colors!  Then skip OS warning.
IF %major% GEQ 10 (
  SET yellow=[34;103m
  SET blue=[93;44m
  SET green=[93;42m
  SET red=[93;101m
  GOTO :skipwin
)
IF %major%==6 IF %minor% GEQ 3 (
    GOTO :skipwin
) ELSE (
    ECHO.
    ECHO YOUR WINDOWS VERSION IS OLD ENOUGH TO NOT BE SUPPORTED
    ECHO UPDATING TO WINDOWS 10 OR GREATER IS HIGHLY RECOMMENDED
    ECHO.
    PAUSE && EXIT [\B]
)
:skipwin

:: Checks to see if there are environmental variables trying to set global ram allocation values!  This is a real thing!
:: Check for _JAVA_OPTIONS
IF NOT DEFINED _JAVA_OPTIONS GOTO :skipjavopts
IF DEFINED _JAVA_OPTIONS (
  ECHO %_JAVA_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% _JAVA_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO.
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO.
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO.
    PAUSE && EXIT [\B]
  )
:skipjavopts

: Check for JDK_JAVA_OPTIONS
IF NOT DEFINED JDK_JAVA_OPTIONS GOTO :skipjdkjavaoptions
IF DEFINED JDK_JAVA_OPTIONS (
  ECHO %JDK_JAVA_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% JDK_JAVA_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO.
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO.
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO.
    PAUSE && EXIT [\B]
  )
:skipjdkjavaoptions

:: Check for JAVA_TOOL_OPTIONS
IF NOT DEFINED JAVA_TOOL_OPTIONS GOTO :skipjavatooloptions
IF DEFINED JAVA_TOOL_OPTIONS (
  ECHO %JAVA_TOOL_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% JAVA_TOOL_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO.
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO.
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO.
    PAUSE && EXIT [\B]
  )
:skipjavatooloptions

:: Checks to see if the end of this BAT file name ends in ) which is a special case that causes problems with command executions!
SET THISNAME="%~n0"
SET LASTCHAR="%THISNAME:~-2,1%"
IF %LASTCHAR%==")" (
  CLS
  ECHO.
  ECHO   This BAT file was detected to have a file name ending in a closed parentheses character " ) "
  ECHO.
  ECHO    This is a special case character that causes problems with command executions in BAT scripts.
  ECHO    Please rename this file to remove at least that name ending character and try again.
  ECHO.
  PAUSE && EXIT [\B]
)

:: The below SET PATH only applies to this command window launch and isn't permanent to the system's PATH.
SET PATH=%PATH%;"C:\Windows\Syswow64\"

:: Checks to see if CMD is working by checking WHERE for some commands
WHERE FINDSTR >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE CERTUTIL >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE NETSTAT >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE PING >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y

IF DEFINED CMDBROKEN (
  ECHO.
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO.
  ECHO             FOR REPAIR SOLUTIONS
  ECHO             SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO.
  ECHO             https://github.com/nanonestor/universalator/wiki
  ECHO.
  ECHO             or
  ECHO             Web search for fixing / repairing Windows Command prompt function.
  ECHO.
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO. & ECHO. & ECHO. & ECHO.
  PAUSE && EXIT [\B]
)

:: Checks to see if Powershell is installed.  If not recognized as command or exists as file it will send a message to install.
:: If exists as file then the path is simply not set and the ELSE sets it for this script run.

WHERE powershell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 IF NOT EXIST "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (
  ECHO.
  ECHO   Uh oh - POWERSHELL is not detected as installed to your system.
  ECHO.
  ECHO   'Microsoft Powershell' is required for this program to function.
  ECHO   Web search to find an installer for this product!
  ECHO.
  ECHO   FOR ADDITIONAL INFORMATION - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO   https://github.com/nanonestor/universalator/wiki
  ECHO.
  PAUSE && EXIT [\B]

) ELSE SET PATH=%PATH%;"C:\Windows\System32\WindowsPowerShell\v1.0\"

:: This is to fix an edge case issue with folder paths ending in ).  Yes this is worked on already above - including this anyways!
SET LOC=%cd:)=]%

:: Checks folder location this BAT is being run from for various system folders.  Sends appropriate messages if needed.
ECHO "%LOC%" | FINDSTR /i "onedrive documents desktop downloads" 1>NUL
IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO.
    ECHO   %yellow% %LOC% %blue%
    ECHO.
    ECHO   THE FOLDER THIS SCRIPT PROGRAM IS BEING RUN FROM - shown above - WAS DETECTED TO BE
    ECHO   %yellow% INSIDE A FOLDER OF 'ONEDRIVE', 'DOCUMENTS', 'DESKTOP', OR 'DOWNLOADS'. %blue%
    ECHO   SERVERS SHOULD NOT RUN IN THESE FOLDERS BECAUSE IT CAN CAUSE ISSUES WITH SYSTEM PERMISSIONS OR FUNCTIONS.
    ECHO.
    ECHO   USE A FILE BROWSER TO RELOCATE THIS
    ECHO   SERVER FOLDER TO A NEW LOCATION OUTSIDE OF ANY OF THESE SYSTEM FOLDERS.
    ECHO.
    ECHO   EXAMPLES THAT WORK- C:\MYSERVER\    D:\MYSERVERS\MODDEDSERVERNAME\
    ECHO.
    PAUSE && EXIT [\B]
)

:: The following line is purely done to guarantee the current ERRORLEVEL is reset
ver >nul

:: Checks if standalone command line version of 7-zip is present.  If not downloads it.
IF NOT EXIST "%HERE%\univ-utils\7-zip" (
  MD univ-utils\7-zip
)
SET ZIP7="%HERE%\univ-utils\7-zip\7za.exe"
:try7zipagain
IF NOT EXIST %ZIP7% (
  CLS
  ECHO Downloading and installing 7-Zip...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/nanonestor/utilities/raw/main/7zipfiles/7za.exe', 'univ-utils\7-zip\7za.exe')" >nul
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/utilities/main/7zipfiles/license.txt', 'univ-utils\7-zip\license.txt')" >nul
)
IF NOT EXIST %ZIP7% (
  ECHO.
  ECHO   DOWNLOADING THE 7-ZIP COMMAND LINE PROGRAM FILE HAS FAILED
  ECHO   THIS FILE IS REQUIRED FOR THE UNIVERSALATOR SCRIPT FUNCTION
  ECHO.
  ECHO   PRESS ANY KEY TO RETRY DOWNLOAD
  PAUSE
  ECHO     Attempting to download again...
  GOTO :try7zipagain
)
IF EXIST settings-universalator.txt (
  RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
  IF DEFINED MAXRAMGIGS SET MAXRAM=-Xmx!MAXRAMGIGS!G
)
SET OVERRIDE=N
:: END GENERAL PRE-RUN ITEMS

:: BEGIN CHECKING server.properties FILE FOR IP ENTRY AND OTHER
:: IF NOT EXIST server.properties SET FLIGHT=allow-flight=true
IF NOT EXIST server.properties (
    ECHO allow-flight=true>server.properties
    GOTO :skipserverproperties
)
:: Constructs a pseudo array list to store the server.properties file info
SET idx=0
IF EXIST server.properties (
  FOR /F "usebackq delims=" %%J IN (server.properties) DO (
    SET "serverprops[!idx!]=%%J"
    SET /a idx+=1
  )

:: Sets a variable to the line number that contains server-ip= , also checks if the full line is only that or also contains additional info (different string value)
FOR /L %%T IN (0,1,!idx!) DO (
    IF "!serverprops[%%T]:~0,10!"=="server-ip=" SET IPLINE=%%T
)
)
IF DEFINED IPLINE IF "!serverprops[%IPLINE%]!" NEQ "server-ip=" SET IS_IP_ENTERED=Y
:: The following must be done outside the IF EXIST server.properties list because you can't tag loop back into an IF loop.
:: If it was found that information was entered after server-ip= checks with user if it's ok to blank the value out or leave it alone.
:confirmip
IF DEFINED IPLINE IF !IS_IP_ENTERED!==Y (
    CLS
    ECHO.
    ECHO   %yellow% WARNING WARNING WARNING %blue%
    ECHO.
    ECHO   IT IS DETECTED THAT THE server.properties FILE HAS AN IP ADDRESS ENTERED AFTER server-ip=
    ECHO.
    ECHO   THIS ENTRY IS ONLY TO BE USED USED IF YOU ARE SETTING UP A CUSTOM DOMAIN
    ECHO   IF YOU ARE NOT SETTING UP A CUSTOM DOMAIN THEN THE SERVER WILL NOT LET PLAYERS CONNECT CORRECTLY
    ECHO.
    ECHO   %yellow% WARNING WARNING WARNING %blue%
    ECHO.
    ECHO   CHOOSE TO CORRECT THIS ENTRY OR IGNORE
    ECHO   ONLY CHOOSE IGNORE IF YOU ARE SETTING UP A CUSTOM DOMAIN
    ECHO.
    ECHO   ENTER YOUR CHOICE:
    ECHO   'CORRECT' or 'IGNORE'
    ECHO.
    SET /P "CHOOSE_IP="
)
IF DEFINED IPLINE IF !IS_IP_ENTERED!==Y (
    IF /I !CHOOSE_IP! NEQ CORRECT IF /I !CHOOSE_IP! NEQ IGNORE GOTO :confirmip
)
:: If an IP address was entered and user choses to remove then print server.properties with it made blank, also always set allow-flight to be true
IF DEFINED IPLINE IF /I !CHOOSE_IP!==CORRECT (
    FOR /L %%T IN (0,1,!idx!) DO (
        IF %%T NEQ %IPLINE% IF "!serverprops[%%T]!" NEQ "" IF "!serverprops[%%T]!" NEQ "allow-flight=false" IF "!serverprops[%%T]!" NEQ "online-mode=false" ECHO !serverprops[%%T]!>>server.properties2
        IF "!serverprops[%%T]!"=="allow-flight=false" ECHO allow-flight=true>>server.properties2
        IF "!serverprops[%%T]!"=="online-mode=false" ECHO online-mode=true>>server.properties2
        IF %%T==%IPLINE% ECHO server-ip=>>server.properties2
    )
    DEL server.properties
    RENAME server.properties2 server.properties
    :: Skips past the last section since the job is done for this case.
    GOTO :skipserverproperties
)
:: At this point if IPLINE is defined and user chooses Y then scipt has skipped ahead, also skipped ahead if server.properties does not previously exist.
:: This means that all that's left are cases where IPLINE is not defined or user has chosen IGNORE.
:: Below reprints all lines except always setting allow-flight=true
    FOR /L %%T IN (0,1,!idx!) DO (
        IF "!serverprops[%%T]!" NEQ "" IF "!serverprops[%%T]!" NEQ "allow-flight=false" IF "!serverprops[%%T]!" NEQ "online-mode=false" ECHO !serverprops[%%T]!>>server.properties2
        IF "!serverprops[%%T]!"=="allow-flight=false" ECHO allow-flight=true>>server.properties2
        IF "!serverprops[%%T]!"=="online-mode=false" ECHO online-mode=true>>server.properties2
    )
    DEL server.properties
    RENAME server.properties2 server.properties

:skipserverproperties
:: END CHECKING server.properties FILE FOR IP ENTRY AND OTHER

:portcheckup
:: BEGIN CHECKING IF CURRENT PORT SET IN server.properties IS ALREADY IN USE
:: Assume server.properties exists
FOR /F %%A IN ('findstr server-port server.properties') DO SET PROPSPORT=%%A
IF DEFINED PROPSPORT IF "%PROPSPORT%" NEQ "" SET PORTSET=%PROPSPORT:~12%
IF NOT DEFINED PROPSPORT SET PORTSET=25565

ver > nul
NETSTAT -o -n -a | FINDSTR %PORTSET%
:: If port was not found already after checking netstat entries then assume it's being used and run warning/process kill screen
IF %ERRORLEVEL%==1 GOTO :skipportclear

IF EXIST pid.txt DEL pid.txt && IF EXIST pid2.txt DEL pid2.txt && IF EXIST pid3.txt DEL pid3.txt


for /F "delims=" %%A IN ('netstat -aon') DO (
    ECHO %%A>>pid.txt
)

set idx=0
FOR /F "delims=" %%A IN ('findstr %PORTSET% pid.txt') DO (
    SET BEE[!idx!]=%%A
    set /a idx+=1
)
IF NOT DEFINED BEE[0] GOTO :skipportclear


FOR /F "tokens=5 delims= " %%B IN ("!BEE[0]!") DO (
    SET PIDNUM=%%B
)

FOR /F "delims=" %%C IN ('TASKLIST /fi "pid eq !PIDNUM!"') DO (
    ECHO %%C>>pid3.txt
)
SET idx=0
FOR /F "delims=" %%D IN ('findstr !PIDNUM! pid3.txt') DO (
    SET BOO[!idx!]=%%D
    set /a idx+=1
)
FOR /F "tokens=1,3,4 delims= " %%E IN ("!BOO[0]!") DO (
    SET IMAGENAME=%%E
    SET SESSIONNAME=%%F
    SET SESSIONNUM=%%G
)


IF EXIST pid.txt DEL pid.txt && IF EXIST pid2.txt DEL pid2.txt && IF EXIST pid3.txt DEL pid3.txt

:portwarning
  CLS
  ECHO. && ECHO.
  ECHO   %yellow% WARNING - PORT ALREADY IN USE - WARNING %blue%
  ECHO.
  ECHO   CURRENT %yellow% PORT SET = %PORTSET% %blue%
  ECHO.
  ECHO   IT IS DETECTED THAT THE PORT CURRENTLY SET (SHOWN ABOVE)
  ECHO   IN THE SETTINGS FILE server.properties %yellow% IS ALREADY IN USE %blue%
  ECHO.
  ECHO   THE FOLLOWING IS THE PROCESS RUNNING THAT APPEARS TO BE USING THE PORT
  ECHO   MINECRAFT SERVERS WILL USUALLY CONTAIN THE NAMES java.exe AND Console
  ECHO.
  ECHO   IMAGE NAME - %IMAGENAME%
  ECHO   SESSION NAME - %SESSIONNAME%
  ECHO   PID NUMBER - %PIDNUM%
  ECHO.
  ECHO   %yellow% WARNING - PORT ALREADY IN USE - WARNING %blue%
  ECHO.
  ECHO   Type 'KILL' to try and let the script close the program using the port already.
  ECHO   Type 'Q' to close the script program if you'd like to try and solve the issue on your own.
  ECHO.
  ECHO   Enter your response:
  SET /P "KILLIT="
  IF /I !KILLIT! NEQ KILL IF /I !KILLIT! NEQ Q GOTO :portwarning
  IF /I !KILLIT!==Q (
    PAUSE && EXIT [\B]
  )
  IF /I !KILLIT!==KILL (
    CLS
    ECHO.
    ECHO   ATTEMPTING TO KILL TASK PLEASE WAIT...
    ECHO.
    TASKKILL /F /PID %PIDNUM%
    ping -n 10 127.0.0.1 > nul
  )
ver > nul
NETSTAT -o -n -a | FINDSTR %PORTSET%
IF %ERRORLEVEL%==0 (
  CLS
  ECHO.
  ECHO   OOPS - THE ATTEMPT TO KILL THE TASK PROCESS USING THE PORT SEEMS TO HAVE FAILED
  ECHO.
  ECHO   FURTHER OPTIONS:
  ECHO   --SET A DIFFERENT PORT, OR CLOSE KNOWN SERVERS/PROGRAMS USING THIS PORT.
  ECHO   --IF YOU THINK PORT IS BEING KEPT OPEN BY A BACKGROUND PROGRAM TRY RESTARTING COMPUTER.
  ECHO   --TRY RUNNING THE UNIVERSALATOR SCRIPT AGAIN.
  ECHO. && ECHO.  && ECHO. 
  PAUSE && EXIT [\B]
)
IF %ERRORLEVEL%==1 (
  ECHO.
  ECHO   SUCCESS!
  ECHO   IT SEEMS LIKE KILLING THE PROGRAM WAS SUCCESSFUL IN CLEARING THE PORT!
  ECHO.
  ping -n 5 127.0.0.1 > nul
)

:: Below line is purely done to guarantee that the current ERRORLEVEL is reset to 0
:skipportclear
ver > nul
:: END CHECKING IF CURRENT PORT SET IN server.properties IS ALREAY IN USE

:: BEGIN SETTING VARIABLES TO PUBLIC IP AND PORT SETTING
FOR /F %%B IN ('powershell -Command "Invoke-RestMethod api.ipify.org"') DO SET PUBLICIP=%%B
FOR /F %%A IN ('findstr server-port server.properties') DO SET PORTLINE=%%A
IF DEFINED PORTLINE SET PORT=%PORTLINE:~12%
IF NOT DEFINED PORT SET PORT=25565
:: END SETTING VARIABLES TO PUBLIC IP AND PORT SETTING

:: If file present (upnp port forwarding = loaded') check to see if port forwarding is activated or not using it.

IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
  SET ISUPNPACTIVE=N
  FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
    SET CHECKUPNPSTATUS=%%E
    IF "!CHECKUPNPSTATUS!" NEQ "!CHECKUPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
  )
)
:: Sets ASKMODSCHECK to use as default if no settings file exists yet.
SET ASKMODSCHECK=Y

:: BEGIN MAIN MENU


:mainmenu

TITLE Universalator
IF EXIST settings-universalator.txt (
  RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
  IF DEFINED MAXRAMGIGS IF !MAXRAMGIGS! NEQ "" SET MAXRAM=-Xmx!MAXRAMGIGS!G
)

CLS
ECHO.%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO.
ECHO   %yellow% CURRENT SETTINGS %blue%
ECHO.
ECHO.
IF DEFINED MINECRAFT ECHO   %yellow% MINECRAFT VERSION %blue% !MINECRAFT!
IF NOT DEFINED MINECRAFT ECHO   %yellow% MINECRAFT VERSION %blue% NEEDS SETTING
IF DEFINED  MODLOADER ECHO   %yellow% MODLOADER %blue%         !MODLOADER!
IF NOT DEFINED MODLOADER ECHO   %yellow% MODLOADER %blue%         NEEDS SETTING
IF DEFINED MODLOADER IF DEFINED FORGE IF /I !MODLOADER!==FORGE ECHO   %yellow% FORGE VERSION %blue%     !FORGE!
IF DEFINED MODLOADER IF DEFINED FABRICLOADER IF /I !MODLOADER!==FABRIC ECHO   %yellow% FABRIC LOADER %blue%     !FABRICLOADER!
IF DEFINED MODLOADER IF DEFINED FABRICINSTALLER IF /I !MODLOADER!==FABRIC ECHO   %yellow% FABRIC INSTALLER %blue%  !FABRICINSTALLER!
IF DEFINED JAVAVERSION ECHO   %yellow% JAVA VERSION %blue%      !JAVAVERSION!
IF NOT DEFINED JAVAVERSION ECHO   %yellow% JAVA VERSION %blue%      NEEDS SETTING
IF NOT DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  NEEDS SETTING
ECHO. && ECHO.
IF DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  !MAXRAMGIGS!
ECHO.
ECHO.
IF DEFINED PORT ECHO   %yellow% CURRENT PORT SET %blue%           !PORT!
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO   %yellow% UPNP PROGRAM (MINIUPNP) %blue% NOT LOADED
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO   %yellow% UPNP PROGRAM (MINIUPNP) %blue%  %green% LOADED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue%       %red% NOT ACTIVATED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue%              %green% ACTIVE %blue%
IF EXIST settings-universalator.txt ECHO                                                           %green% L %blue% = LAUNCH SERVER
ECHO                                                           %green% S %blue% = SETTINGS ENTRY
ECHO.
ECHO                                                           %green% UPNP %blue% = UPNP PORT FORWARDING MENU
IF DEFINED MODLOADER ECHO                                                           %green% SCAN %blue% = SCAN MOD FILES FOR CLIENT MODS && ECHO.
IF EXIST settings-universalator.txt ECHO   %green% ENTER YOUR ANSWER BELOW - L,  S,  UPNP, SCAN, J-(JAVA), R-(RAM), or Q-(quit) %blue%
IF NOT DEFINED MODLOADER ECHO. && ECHO   %green% ENTER YOUR ANSWER BELOW - S-(settings),  UPNP-(menu), or  Q-(quit) %blue%
set /P "MAINMENU="
IF DEFINED MODLOADER IF DEFINED MINECRAFT (
  IF /I !MAINMENU! NEQ L IF /I !MAINMENU! NEQ S IF /I !MAINMENU! NEQ R IF /I !MAINMENU! NEQ J IF /I !MAINMENU! NEQ UPNP IF /I !MAINMENU! NEQ Q IF /I !MAINMENU! NEQ SCAN IF /I !MAINMENU! NEQ OVERRIDE IF /I !MAINMENU! NEQ MCREATOR GOTO :mainmenu
)
IF NOT DEFINED MODLOADER (
  IF /I !MAINMENU! NEQ S IF /I !MAINMENU! NEQ UPNP IF /I !MAINMENU! NEQ Q IF /I !MAINMENU! NEQ OVERRIDE IF /I !MAINMENU! NEQ MCREATOR GOTO :mainmenu
)
IF /I !MAINMENU!==Q (
  EXIT [\B]
)
IF /I !MAINMENU!==J GOTO :gojava
IF /I !MAINMENU!==UPNP GOTO :upnpmenu
IF /I !MAINMENU!==R GOTO :justsetram
IF /I !MAINMENU!==S GOTO :startover
IF /I !MAINMENU!==L IF EXIST settings-universalator.txt IF DEFINED MINECRAFT IF DEFINED MODLOADER IF DEFINED JAVAVERSION GOTO :actuallylaunch
IF /I !MAINMENU!==SCAN IF EXIST "%HERE%\mods" GOTO :scanmods
IF /I !MAINMENU!==SCAN IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==OVERRIDE GOTO :override
IF /I !MAINMENU!==MCREATOR IF EXIST "%HERE%\mods" GOTO :mcreator
IF /I !MAINMENU!==MCREATOR IF NOT EXIST "%HERE%\mods" GOTO :mainmenu

:: END MAIN MENU


:startover
:: User entry for Minecraft version
CLS
ECHO. && ECHO.
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO.
ECHO    example: 1.7.10
ECHO    example: 1.16.5
ECHO    example: 1.19.2
ECHO.
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO. && ECHO.
SET /P MINECRAFT=

::Detects whether Minecraft version is older than, or equal/greater than 1.17 and stores in OLDORNEW variable
::This is done again later after the settings-universalator.txt is present and this is section is skipped
SET DOTORNOT=!MINECRAFT:~3,1!
SET OLDORNEW=IDK
IF %DOTORNOT%==. SET OLDORNEW=OLD
IF %DOTORNOT% NEQ . IF !MINECRAFT! GEQ 1.17 SET OLDORNEW=NEW
IF %DOTORNOT% NEQ . IF !MINECRAFT! LSS 1.17 SET OLDORNEW=OLD

IF %OLDORNEW%==IDK (
  ECHO. && ECHO.  && ECHO %yellow% INVALID MINECRAFT VERSION ENTERED IN VALUES %blue%
  ECHO   PRESS ANY KEY TO TRY AGAIN && ECHO.
  PAUSE
  GOTO :startover
)

:reentermodloader
:: User entry for Modloader version
CLS
ECHO. && ECHO.
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO.
ECHO    Valid entries - %green% FORGE %blue% or %green% FABRIC %blue%
ECHO.
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO. && ECHO.
SET /P "MODLOADER="
IF /I !MODLOADER!==FORGE SET MODLOADER=FORGE
IF /I !MODLOADER!==FABRIC SET MODLOADER=FABRIC
IF /I !MODLOADER! NEQ FORGE IF /I !MODLOADER! NEQ FABRIC (
  GOTO :reentermodloader
)

:: Detects if settings are trying to use some weird old Minecraft Forge version that isn't supported.
:: This is done again later after the settings-universalator.txt is present and this is section is skipped.
IF /I !MODLOADER!==FORGE IF %DOTORNOT%==. IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 (
  ECHO.
  ECHO  SORRY - YOUR ENTERED MINECRAFT VERSION - FORGE FOR MINECRAFT !MINECRAFT! - IS NOT SUPPORTED.
  ECHO.
  ECHO  FIND A MODPACK WITH A MORE POPULARLY USED VERSION.
  ECHO  OR
  ECHO  PRESS ANY KEY TO START OVER AND ENTER NEW VERSION NUMBERS
  ECHO.
  PAUSE
  GOTO :startover
)

:: If Fabric modloader ask user to enter Fabric Installer and Fabric Loader
IF /I !MODLOADER!==FABRIC (
  CLS
  ECHO.
  ECHO    %yellow% ENTER THE VERSION OF FABRIC --INSTALLER-- %blue%
  ECHO.
  ECHO    THIS IS THE VERSION OF THE FILE WHICH INSTALLS FABRIC MODLOADER FILES
  ECHO    AS OF JANUARY 2023 THE LATEST VERSION WAS %green% 0.11.1 %blue%
  ECHO.
  ECHO    UNLESS YOU KNOW OF A NEWER VERSION OR HAVE A PREFERENCE - ENTER %green% 0.11.1 %blue%
  ECHO.
  ECHO    %yellow% ENTER THE VERSION OF FABRIC --INSTALLER-- %blue%
  ECHO.
  SET /P FABRICINSTALLER=
  CLS
  ECHO.
  ECHO   %yellow% ENTER THE VERSION OF FABRIC --LOADER-- %blue%
  ECHO.
  ECHO    THIS IS THE FABRIC MODLOADER VERSION
  ECHO    AS OF JANUARY 2023 THE LATEST VERSION WAS %green% 0.14.13 %blue%
  ECHO.
  ECHO    GENERALLY IT IS A GOOD IDEA TO USE THE SAME VERSION THAT THE CLIENT MODPACK IS KNOWN TO LOAD WITH
  ECHO.
  ECHO   %yellow% ENTER THE VERSION OF FABRIC --LOADER-- %blue%
  ECHO.
  SET /P FABRICLOADER=
  ECHO.
  ECHO.
)

IF /I !MODLOADER!==FABRIC GOTO :gojava
:usedefaulttryagain
:: If modloader is Forge present user with option to select recommended versions of Forge and Java.
SET USEDEFAULT=BLANK
IF !MINECRAFT!==1.6.4 (
  CLS
  ECHO. && ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.6.4 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 9.11.1.1345 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.6.4 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=9.11.1.1345
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.7.10 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.7.10 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 10.13.4.1614 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.7.10 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=10.13.4.1614
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.8.9 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 11.15.1.2318 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHo.
  ECHO   %yellow% YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=11.15.1.2318
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.9.4 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.9.4 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 12.17.0.2317 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHo.
  ECHO   %yellow% YOU HAVE ENTERED 1.9.4 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=12.17.0.2317
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.10.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 12.18.3.2511 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=12.18.3.2511
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.12.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.12.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 14.23.5.2860 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.12.2 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=14.23.5.2860
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.14.4 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.14.4 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 28.2.26 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.14.4 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=28.2.26
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.15.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.15.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 31.2.57 %blue%
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.15.2 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
  IF /I !USEDEFAULT!==Y (
    SET FORGE=31.2.57
    SET JAVAVERSION=8
    GOTO :goramentry
  )
)
IF !MINECRAFT!==1.16.5 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.16.5 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE?
  ECHO.
  ECHO    FORGE = %green% 36.2.39 %blue%
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.16.5 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
  IF /I !USEDEFAULT!==Y (
    SET FORGE=36.2.39
    GOTO :gojava
  )
)
IF !MINECRAFT!==1.17.1 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.17.1 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE?
  ECHO.
  ECHO    FORGE = %green% 37.1.1 %blue%
  ECHO    JAVA = 16  **JAVA MUST BE 16**
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.17.1 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=37.1.1
  SET JAVAVERSION=16
  GOTO :goramentry
)
IF !MINECRAFT!==1.18.2 (
  CLS
  ECHO. && ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.18.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 40.2.1 %blue%
  ECHO    JAVA = %green% 17 %blue%  **JAVA CAN BE 17, 18, 19**
  ECHO                 **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.18.2 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=40.2.1
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF !MINECRAFT!==1.19.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.19.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 43.2.4 %blue%
  ECHO    JAVA = %green% 17 %blue%  **JAVA CAN BE 17, 18, 19**
  ECHO            **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.19.2 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=43.2.4
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF !MINECRAFT!==1.19.3 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.19.3 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = %green% 44.1.16 %blue%
  ECHO    JAVA = %green% 17 %blue%  **JAVA CAN BE 17, 18, 19**
  ECHO            **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.19.3 WHICH IS A POPULAR VERSION %blue%
  ECHO. && ECHO.
  ECHO    ENTER 'Y' TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER 'N' TO SELECT DIFFERENT VALUES
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=44.1.16
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF /I !USEDEFAULT! NEQ Y IF /I !USEDEFAULT! NEQ N GOTO :usedefaulttryagain
IF /I !USEDEFAULT!==Y GOTO :justsetram

:enterforge
  CLS
  ECHO. && ECHO. 
  ECHO  %yellow% ENTER FORGE VERSION %blue%
  ECHO      example: 14.23.5.2860
  ECHO      example: 40.1.84
  ECHO.
  SET /P FORGE=


:gojava

:: TBD - clean this up to not be entered so many times in the script for checks
:: Detects whether Minecraft version is older than, or equal/greater than 1.17 and stores in OLDORNEW variable
SET DOTORNOT=!MINECRAFT:~3,1!
SET OLDORNEW=IDK
IF %DOTORNOT%==. SET OLDORNEW=OLD
IF %DOTORNOT% NEQ . IF !MINECRAFT! GEQ 1.17 SET OLDORNEW=NEW
IF %DOTORNOT% NEQ . IF !MINECRAFT! LSS 1.17 SET OLDORNEW=OLD
IF /I !OLDORNEW!==NEW SET /a NEWMAJOR=!MINECRAFT:~2,2!
IF !NEWMAJOR! NEQ 17 SET ISITSEVENTEEN=N
IF !NEWMAJOR! EQU 17 SET ISITSEVENTEEN=Y



IF /I !MODLOADER!==FORGE IF /I !OLDORNEW!==NEW (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  IF /I !ISITSEVENTEEN!==Y (
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 %green% MUST BE %blue% 16
  ECHO. && ECHO. && ECHO.
  ) ELSE (
  ECHO   JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer: - %green% 17, 18, 19 %blue%
  ECHO.
  ECHO.  --JAVA 18/19 %green% MAY %blue% WORK OR %red% MAY NOT %blue% DEPENDING ON MODS BEING LOADED OR CHANGES IN FORGE VERSIONS
  ECHO.  --IF THE SERVER LAUNCH FAILS AND YOU HAVE ENTERED JAVA 18 OR 19 - TRY USING 17 INSTEAD
  )
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO. && ECHO.
  SET /P JAVAVERSION=
  IF /I !ISITSEVENTEEN!==N IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 GOTO :gojava
  IF /I !ISITSEVENTEEN!==Y IF !JAVAVERSION! NEQ 16 GOTO :gojava
)

IF /I !MODLOADER!==FORGE  IF /I !OLDORNEW!==OLD IF !MINECRAFT!==1.16.5 (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  ECHO   THE ONLY VERSIONS AVAILABLE THAT WORK WITH MINECRAFT / FORGE 1.16.5 ARE %green% 8 AND 11 %blue%
  ECHO.
  ECHO   USING JAVA 11 %green% MAY %blue% OR %red% MAY NOT %blue% WORK DEPENDING ON MODS BEING LOADED
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :gojava
)

IF /I !MODLOADER!==FORGE IF /I !OLDORNEW!==OLD IF !MINECRAFT! NEQ 1.16.5 (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  ECHO.
  ECHO   -JAVA VERSION FOR MINECRAFT OLDER THAN 1.16.5 %green% MUST BE %blue% 8
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 GOTO :gojava
)

:: IF Fabric ask for Java verison entry
IF !MODLOADER!==FABRIC (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  ECHO   AVAILABLE VERSIONS - 8, 11, 17, 18, 19
  ECHO.
  ECHO   -JAVA VERSION FOR MINECRAFT OLDER THAN 1.16.5 -- *MUST BE* 8
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 -- *MUST BE* 16
  ECHO   -JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer -- 17 *Target version* / 18 / 19
  ECHO.
  ECHO.  JAVA 18/19 MAY WORK OR MAY NOT DEPENDING ON MODS BEING LOADED OR CHANGES IN FORGE VERSIONS
  ECHO   IF YOU TRY JAVA NEWER THAN 17 AND CRASHES HAPPEN -- EDIT SETTINGS TO TRY 17
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 IF !JAVAVERSION! NEQ 16 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 GOTO :gojava
)

IF /I !MAINMENU!==J GOTO :actuallylaunch

:: BEGIN RAM / MEMORY SETTING
:goramentry
:justsetram
:: Uses the systeminfo command to get the total and available/free ram/memory on the computer.
FOR /F "delims=" %%D IN ('systeminfo') DO (
    SET INFO=%%D
    IF "!INFO!" NEQ "!INFO:Total Physical Memory=tot!" SET RAWTOTALRAM=!INFO:~27,4!
    IF "!INFO!" NEQ "!INFO:Available Physical Memory=free!" SET RAWFREERAM=!INFO:~27,4!
)
:: Pulls apart the value obtained above to store the first two spaces and fourth space (after comma) - as integers.
SET /a TOTALRAM=!RAWTOTALRAM:~0,2!
SET /a FREERAM=!RAWFREERAM:~0,2!
SET /a DECIMALTOTAL=!RAWTOTALRAM:~3,1!
SET /a DECIMALFREE=!RAWFREERAM:~3,1!
:: Rounds up the totalram/freeram integer values if the number after the decimal is greater or equal to 5.
IF !DECIMALTOTAL! GEQ 5 SET /a TOTALRAM += 1
IF !DECIMALFREE! GEQ 5 SET /a FREERAM += 1


  CLS
  ECHO.
  ECHO %yellow%    Computer Total Total Memory/RAM     %blue% = %yellow% !TOTALRAM! Gigabytes (GB) %blue%
  ECHO %yellow%    Current Available (Free) Memory/RAM %blue% = %yellow% !FREERAM! Gigabytes (GB) %blue%
  ECHO     *Numbers are rounded from actual values
  ECHO. && ECHO.
  ECHO. && ECHO. && ECHO. && ECHO.
  ECHO   %yellow% ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES (GB) %blue%
  ECHO.
  ECHO    BE SURE TO USE A VALUE THAT LEAVES AT LEAST SEVERAL GB AVAILABLE IF ALL USED
  ECHO    (Refer to the total and available RAM found above)
  ECHO.
  ECHO    TYPICAL VALUES FOR MODDED MINECRAFT SERVERS ARE BETWEEN 4 AND 10
  ECHO.
  ECHO    ONLY ENTER THE NUMBER - %red% MUST NOT %blue% INCLUDE ANY LETTERS.
  ECHO    %green% Example - 6 %blue%
  ECHO.
  ECHO   %yellow% ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES (GB) %blue%
  ECHO. & ECHO.
  SET /P MAXRAMGIGS=
  SET MAXRAM=-Xmx!MAXRAMGIGS!G

  :: END RAM / MEMORY SETTING

:actuallylaunch

IF /I !MAINMENU!==L SET ASKMODSCHECK=N
:: Generates settings-universalator.txt file if settings-universalator.txt does not exist
IF EXIST settings-universalator.txt DEL settings-universalator.txt

    ECHO :: To reset this file - delete and run launcher again.>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Minecraft version below - example: MINECRAFT=1.18.2 >>settings-universalator.txt
    ECHO SET MINECRAFT=!MINECRAFT!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Modloader type - either FORGE or FABRIC>>settings-universalator.txt
    ECHO SET MODLOADER=!MODLOADER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Forge version below - example: FORGE=40.1.84 >>settings-universalator.txt
    ECHO SET FORGE=!FORGE!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Fabric Installer version>>settings-universalator.txt
    ECHO SET FABRICINSTALLER=!FABRICINSTALLER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Fabric Loader version>>settings-universalator.txt
    ECHO SET FABRICLOADER=!FABRICLOADER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Java version below - MUST BE 8, 11, 16, 17, 18, or 19 >>settings-universalator.txt
    ECHO SET JAVAVERSION=!JAVAVERSION!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Ram maximum value in gigabytes - example: 6 >>settings-universalator.txt
    ECHO SET MAXRAMGIGS=!MAXRAMGIGS!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Java additional startup args - DO NOT INCLUDE -Xmx THAT IS ABOVE ENTRY>>settings-universalator.txt
    ECHO SET ARGS=!ARGS!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Whether or not the next settings menu entry done asks to scan for client only mods>>settings-universalator.txt
    ECHO SET ASKMODSCHECK=!ASKMODSCHECK!>>settings-universalator.txt

:: Returns to main menu if menu option was only to enter java or ram values
IF /I !MAINMENU!==J GOTO :mainmenu
IF /I !MAINMENU!==R GOTO :mainmenu

::IF EXIST settings-universalator.txt (
::RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
::)
SET MAXRAM=-Xmx!MAXRAMGIGS!G

:scanmods
::Detects whether Minecraft version is older than, or equal/greater than 1.17 and stores in OLDORNEW variable
SET DOTORNOT=!MINECRAFT:~3,1!
SET OLDORNEW=IDK
IF !DOTORNOT!==. SET OLDORNEW=OLD
IF !DOTORNOT! NEQ . IF !MINECRAFT! GEQ 1.17 SET OLDORNEW=NEW
IF !DOTORNOT! NEQ . IF !MINECRAFT! LSS 1.17 SET OLDORNEW=OLD

:: Sets HOWOLD depending on whether version is newer than, or equal/lessthan 1.12.2.
:: This is used to determine which arrangement of files that mods of that era stored their modID names.  The current mods.toml used started with 1.13.
SET HOWOLD=NOTVERY
IF !OLDORNEW!==OLD IF !DOTORNOT!==. SET HOWOLD=SUPEROLD
IF !OLDORNEW!==OLD IF !DOTORNOT! NEQ . IF !MINECRAFT! LSS 1.13 SET HOWOLD=SUPEROLD

:: If older than MC 1.10 then only passes by this if it is one of the major supported versions below - otherwise setting is rejected
IF !DOTORNOT!==. IF !MODLOADER!==FORGE IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 (
  ECHO.
  ECHO  SORRY - YOUR ENTERED MINECRAFT VERSION - FORGE FOR MINECRAFT !MINECRAFT! - IS NOT SUPPORTED.
  ECHO.
  ECHO  FIND A MODPACK WITH A MORE POPULARLY USED VERSION.
  ECHO.
  PAUSE && EXIT [\B]
)

:: Returns to main menu if asking to scan mods is flagged as done previously once before
:: Otherwise if Y goes to the mod scanning section for each modloader
IF /I !MAINMENU!==S IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==S IF /I !ASKMODSCHECK!==N GOTO :mainmenu
IF /I !MAINMENU!==S IF /I !ASKMODSCHECK!==Y (
  SET ASKMODSCHECK=N
  GOTO :actuallyscanmods
)
IF /I !MAINMENU!==SCAN (
  SET ASKMODSCHECK=N
  GOTO :actuallyscanmods
)

::Stores values in variables depending on Java version entered
SET JAVAGOOD="bad"

IF !JAVAVERSION!==8 (
    SET JAVAFILENAME="jdk8u362-b09/OpenJDK8U-jre_x64_windows_hotspot_8u362b09.zip"
    SET JAVAFOLDER="univ-utils\java\jdk8u362-b09-jre\."
    SET checksumeight=3569dcac27e080e93722ace6ed7a1e2f16d44a61c61bae652c4050af58d12d8b
    SET JAVAFILE="univ-utils\java\jdk8u362-b09-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==11 (
    SET JAVAFILENAME="jdk-11.0.18%%2B10/OpenJDK11U-jre_x64_windows_hotspot_11.0.18_10.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-11.0.18+10-jre\."
    SET checksumeight=dea0fe7fd5fc52cf5e1d3db08846b6a26238cfcc36d5527d1da6e3cb059071b3
    SET JAVAFILE="univ-utils\java\jdk-11.0.18+10-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==16 (
    SET JAVAFILENAME="jdk-16.0.2%%2B7/OpenJDK16U-jdk_x64_windows_hotspot_16.0.2_7.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-16.0.2+7\."
    SET checksumeight=40191ffbafd8a6f9559352d8de31e8d22a56822fb41bbcf45f34e3fd3afa5f9e
    SET JAVAFILE="univ-utils\java\jdk-16.0.2+7\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==17 (
    SET JAVAFILENAME="jdk-17.0.6%%2B10/OpenJDK17U-jre_x64_windows_hotspot_17.0.6_10.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-17.0.6+10-jre\."
    SET checksumeight=85ce690a348977e3739fde3fd729b36c61e86c33da6628bc7ceeba9974a3480b
    SET JAVAFILE="univ-utils\java\jdk-17.0.6+10-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==18 (
    SET JAVAFILENAME="jdk-18.0.2.1%%2B1/OpenJDK18U-jre_x64_windows_hotspot_18.0.2.1_1.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-18.0.2.1+1-jre\."
    SET checksumeight=ba7976e86e9a7e27542c7cf9d5081235e603a9be368b6cbd49673b417da544b1
    SET JAVAFILE="univ-utils\java\jdk-18.0.2.1+1-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==19 (
    SET JAVAFILENAME="jdk-19.0.2%%2B7/OpenJDK19U-jre_x64_windows_hotspot_19.0.2_7.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-19.0.2+7-jre\."
    SET checksumeight=daaaa092343e885b0814dd85caa74529b9dec2c1f28a711d5dbc066a9f7af265
    SET JAVAFILE="univ-utils\java\jdk-19.0.2+7-jre\bin\java.exe"
    SET JAVAGOOD="good"
)

:: Checks to see if the Java version entered is available - this shouldn't even be possible using settings normally, but checking anyways
IF %JAVAGOOD%=="bad" (
  ECHO.
  ECHO   %yellow% THE JAVA VERSION YOU ENTERED IN SETTINGS IS NOT AVAILABLE FOR THIS LAUNCHER %blue%
  ECHO    AVAILABLE VERSIONS ARE = 8, 11, 16, 17, 19
  ECHO.
  PAUSE && EXIT [\B]
)

:: Checks to see if the mods folder even exists yet
SET NEWRESPONSE=Y
IF NOT EXIST "%HERE%\mods" (
  :nommodsfolder
  CLS
  ECHO. && ECHO. && ECHO. && ECHO.
  ECHO   %yellow% NO 'mods' FOLDER OR NO MOD FILES INSIDE AN EXISTING 'mods' FOLDER WERE DETECTED IN THIS DIRECTORY YET %blue%
  ECHO   %yellow% ARE YOU SURE YOU WANT TO CONTINUE? %blue%
  ECHO. && ECHO.
  ECHO    --- IF "Y" PROGRAM WILL INSTALL CORE SERVER FILES AND LAUNCH BUT THERE ARE NO MODS THAT WILL BE LOADED.
  ECHO.
  ECHO    --- IF "N" PROGRAM WILL RETURN TO MAIN MENU
  ECHO.
  ECHO.
  ECHO   %yellow% TYPE YOUR RESPONSE AND PRESS ENTER: %blue%
  ECHO.
  set /P "NEWRESPONSE=" 
  IF /I !NEWRESPONSE! NEQ N IF /I !NEWRESPONSE! NEQ Y GOTO :nomodsfolder
  IF /I !NEWRESPONSE!==N (
    GOTO :mainmenu
  )
)

:: Downloads java binary file
:javaretry
IF NOT EXIST java.zip IF NOT EXIST %JAVAFOLDER% (
  ECHO.
  ECHO. Java installation not detected - Downloading Java files!...
  ECHO.
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/adoptium/temurin!JAVAVERSION!-binaries/releases/download/%JAVAFILENAME%', 'java.zip')" >nul

)

:: Gets the checksum hash of the downloaded java binary file
set idx=0 
IF EXIST java.zip (
  for /f %%F  in ('certutil -hashfile java.zip SHA256') do (
      set "out!idx!=%%F"
      set /a idx += 1
  )

  IF NOT EXIST java.zip IF NOT EXIST %JAVAFOLDER% (
    ECHO.
    ECHO   !yellow! Something went wrong downloading the Java files. !blue!
    ECHO    Press any key to try again.
    PAUSE
    GOTO :javaretry
  )

)
IF EXIST java.zip (
set filechecksum=%out1%
) ELSE (
    set filechecksum=0a
  )
:: Checks to see if the calculated checksum hash is the same as stored value above - unzips file if valid
IF EXIST java.zip (
    IF /i %checksumeight%==%filechecksum% (
    "%HERE%\univ-utils\7-zip\7za.exe" x java.zip -ouniv-utils\java
    ) && DEL java.zip && ECHO Downloaded Java binary and stored hashfile match values - file is valid
)
IF EXIST java.zip IF %checksumeight% NEQ %filechecksum% (
  ECHO.
  ECHO %yellow% THE JAVA INSTALLATION FILE DID NOT DOWNLOAD CORRECTLY - PLEASE TRY AGAIN %blue%
  DEL java.zip && PAUSE && EXIT [\B]
)
:: Sends console message if Java found
IF EXIST %JAVAFOLDER% (
  ECHO.
  ECHO    Java !JAVAVERSION! installation found! ...
  ECHO.
) ELSE (
  ECHO UH-OH - JAVA folder not detected.
  ECHO Perhaps try resetting all files, delete settings-universalator.txt and starting over.
  PAUSE && EXIT [\B]
)


:: BEGIN SPLIT BETWEEN FABRIC AND FORGE SETUP AND LAUNCH - If MODLOADER is FABRIC skips the Forge installation and launch section
IF /I !MODLOADER!==FABRIC GOTO :launchfabric
:: BEGIN FORGE SPECIFIC SETUP AND LAUNCH
:detectforge

IF EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST forge-!MINECRAFT!-!FORGE!.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST minecraftforge-universal-!MINECRAFT!-!FORGE!.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST forge-!MINECRAFT!-!FORGE!-universal.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

:: Downloads the Minecraft server JAR if version is = OLD and does not exist.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets it first.
IF !OLDORNEW!==OLD IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
  powershell -Command "(New-Object Net.WebClient).DownloadFile(((Invoke-RestMethod -Method Get -Uri ((Invoke-RestMethod -Method Get -Uri "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json").versions | Where-Object -Property id -Value !MINECRAFT! -EQ).url).downloads.server.url), 'minecraft_server.!MINECRAFT!.jar')"
)

:pingforgeagain
:: Pings the Forge files server to see it can be reached - decides to ping if forge file not present - accounts for extremely annoyng changes in filenames depending on OLD version names.
IF !OLDORNEW!==OLD IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar IF NOT EXIST forge-!MINECRAFT!-!FORGE!-universal.jar IF NOT EXIST minecraftforge-universal-!MINECRAFT!-!FORGE!.jar IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  ECHO Pinging Forge file server...
  ECHO.
  ping -n 4 maven.minecraftforge.net >nul
  IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO.
    ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
    ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
    ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
    PAUSE
    GOTO :pingforgeagain
  )
)
:: Pings the Forge files server for NEW types of Forge (1.17 and newer).  Decides to ping if specific folder is not detected as existing.
IF !OLDORNEW!==NEW IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (
  ping -n 4 maven.minecraftforge.net >nul
  IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO.
    ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
    ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
    ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
    PAUSE
    GOTO :pingforgeagain

  )
)

:: Forge installer file download
:: Detects if installed files or folders exist - if not then deletes existing JAR files and libraries folder to prevent mash-up of various versions installing on top of each other, and then downloads installer JAR
IF !OLDORNEW!==NEW GOTO :skipolddownload

:: 1.6.4
IF !MINECRAFT!==1.6.4 IF NOT EXIST minecraftforge-universal-1.6.4-!FORGE!.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found.
  ECHO Any existing JAR files and 'libaries' folder deleted.
  ECHO Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.7.10
IF !MINECRAFT!==1.7.10 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.8.9
IF !MINECRAFT!==1.8.9 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.9.4
IF !MINECRAFT!==1.9.4 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.10.2
IF !MINECRAFT!==1.10.2 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul

)

:: OLD versions newer than 1.10.2
IF %OLDORNEW%==OLD IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 IF !MINECRAFT! NEQ 1.10.2 (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul
  IF EXIST forge-installer.jar GOTO :useforgeinstaller
)

:skipolddownload
:: For NEW (1.17 and newer) Forge detect if specific version folder is present - if not delete all JAR files and 'install' folder to guarantee no files of different versions conflicting on later install.  Then downloads installer file.
IF !OLDORNEW!==NEW IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul
  IF EXIST forge-installer.jar GOTO :useforgeinstaller
)

CLS
ECHO.
ECHO forge-installer.jar not found. Maybe the Forge servers are having trouble.
ECHO Please try again in a couple of minutes.
ECHO.
ECHO %yellow% THIS COULD ALSO MEAN YOU HAVE INCORRECT MINECRAFT OR FORGE VERSION NUMBERS ENTERED - CHECK THE VALUES ENTERED %blue%
ECHO         MINECRAFT - !MINECRAFT!
ECHO         FORGE ----- !FORGE!
ECHO.
ECHO Press any key to try to download forge installer file again.
PAUSE
GOTO :pingforgeagain

:: Installs forge, detects if successfully made the main JAR file, deletes extra new style files that this BAT replaces
:useforgeinstaller
IF EXIST forge-installer.jar (
  ECHO Installer downloaded. Installing...
  !JAVAFILE! -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
  DEL forge-installer.jar >nul 2>&1
  DEL forge-installer.jar.log >nul 2>&1
  ECHO Installation complete. forge-installer.jar deleted. && ECHO.
  GOTO :detectforge
)

ECHO THE FORGE INSTALLATION FILE DID NOT DOWNLOAD OR INSTALL CORRECTLY - IT WAS NOT FOUND
ECHO - PLEASE RESET FILES AND TRY AGAIN -
PAUSE && EXIT [\B]

:foundforge

:: Forge was found to exist at this point - delete the files which Forge installs that this script replaces the functions of.
IF !OLDORNEW!==NEW (
  DEL "%HERE%\run.*" >nul 2>&1
  IF EXIST "%HERE%\user_jvm_args.txt" DEL "%HERE%\user_jvm_args.txt"
)

:eula
::If eula.txt doens't exist yet 
SET RESPONSE=IDKYET
IF NOT EXIST eula.txt (
  CLS
  ECHO.
  ECHO.
  ECHO Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO.
  ECHO   %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue%
  ECHO.
  ECHO   %yellow% ENTER YOUR RESPONSE %blue%
  ECHO.
  SET /P RESPONSE=
)
IF /I !RESPONSE!==AGREE (
  ECHO.
  ECHO User agreed to Mojang's EULA.
  ECHO.
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF NOT EXIST eula.txt (
  GOTO :eula
)
IF EXIST eula.txt (
  ECHO.
  ECHO eula.txt file found! ..
  ECHO.
)

:: Moves any nuisance client mods that should never be placed on a server - for every launch of any version.
IF EXIST "%HERE%\mods" (
  MOVE "%HERE%\mods\?pti?ine*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\optifabric*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\?pti?orge*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\Essential??orge*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\Essential??abric*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\?ssential.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
)

:: If launching L then skip to launching sections
IF /I !MAINMENU!==L IF /I !MODLOADER!==FORGE GOTO :launchforge
IF /I !MAINMENU!==L IF /I !MODLOADER!==FABRIC GOTO :fabricmain

:: MODULE TO CHECK FOR CLIENT SIDE MODS
:actuallyscanmods
SET ASKMODSCHECK=N
IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% && ECHO.
  ECHO      %green% WOULD YOU LIKE TO SCAN THE MODS FOLDER FOR MODS THAT ARE NEEDED ONLY ON CLIENTS? %blue%
  ECHO      %green% FOUND CLIENT MODS CAN BE AUTOMATICALLY MOVED TO A DIFFERENT FOLDER FOR STORAGE. %blue%
  ECHO.
  ECHO       --MANY CLIENT MODS ARE NOT CODED TO SELF DISABLE ON SERVERS AND MAY CRASH THEM
  ECHO. && ECHO. && ECHO.
  ECHO       --THE UNIVERSALATOR SCRIPT CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT && ECHO.
  ECHO         For an explanation of how the script scans files - visit the official wiki at:
  ECHO         https://github.com/nanonestor/universalator/wiki
  ECHO.
  ECHO.
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% && ECHO.
  ECHO.
  ECHO.
  ECHO             %yellow% Please choose 'Y' or 'N' %blue%
  ECHO.
  SET /P DOSCAN=

  IF /I !DOSCAN! NEQ N IF /I !DOSCAN! NEQ Y GOTO :askscan
  IF /I !DOSCAN!==N GOTO :mainmenu
  IF !MODLOADER!==FABRIC GOTO :scanfabric

:: BEGIN CLIENT MOD SCANNING FORGE

  IF EXIST rawidlist.txt DEL rawidlist.txt
  IF EXIST serveridlist.txt DEL serveridlist.txt
  ECHO.
  ECHO Searching for client only mods . . .
  :: Goes to mods folder and gets file names lists.  FINDSTR prints only files with .jar found

  PUSHD mods
  dir /b /a-d > list1.txt
  FINDSTR .jar list1.txt > list2.txt
  SORT list2.txt > servermods.txt
  DEL list1.txt && DEL list2.txt
  
  ::MOVE mods\servermods.txt servermods.txt >nul

  REM Gets the client only list from github file, checks if it's empty or not after download attempt, then sends
  REM to a new file masterclientids.txt with any blank lines removed.
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt', 'rawclientids.txt')" >nul


  REM Checks if the just downloaded file's first line is empty or not.  Better never save that webfile with the first line empty!
  IF EXIST rawclientids.txt SET /P EMPTYCHECK=<rawclientids.txt
  IF NOT EXIST rawclientids.txt SET EMPTYCHECK=""
  IF [!EMPTYCHECK!]==[] (
    CLS
    ECHO.
    ECHO.
    ECHO   SOMETHING WENT WRONG DOWNLOADING THE MASTER CLIENT-ONLY LIST FROM THE GITHUB HOSTED LIST
    ECHO   CHECK THAT YOU HAVE NO ANTIVIRUS PROGRAM OR WINDOWS DEFENDER BLOCKING THE DOWNLOAD FROM -
    ECHO.
    ECHO   https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt
    ECHO.
    PAUSE && EXIT [\B]
  )
  FINDSTR /v "^$" rawclientids.txt >masterclientids.txt
  IF EXIST rawclientids.txt DEL rawclientids.txt
  
  :: Gets the list of modIDs from actual mod JAR files using servermods.txt
  :: Saves corresponding file names and modIDs in variable array
  :: Extracts the mods.toml file from each JAR

  SET SERVCOUNT=0
  IF EXIST mods.toml DEL mods.toml
  :: START SCANNING MODS
  IF !HOWOLD!==SUPEROLD GOTO :scanmcmodinfo
  REM Get total number of mods currently in mods folder
  SET rawmodstotal=0
  FOR /F "usebackq delims=" %%J IN (servermods.txt) DO (
    SET /a rawmodstotal+=1
  )

  REM BEGIN SCANNING NEW STYLE MODS.TOML
  SET modcount=0
  FOR /F "delims= usebackq" %%W IN (servermods.txt) DO (
    
    "%HERE%\univ-utils\7-zip\7za.exe" e -aoa "%HERE%\mods\%%W" "META-INF\mods.toml" >nul
    SET /a modcount+=1
    ECHO SCANNING - !modcount!/!rawmodstotal! - %%W
    
    IF EXIST mods.toml (
      FINDSTR modId mods.toml >temp2.txt
        REM Goes through modIds in temp2.txt and only prints to rawlist.txt the first modID found
        REM --IF the mod author puts the modID for forge first in mods.toml its a big bummmer - will filter out forge results later
      set idx=0
      FOR /F "delims=#" %%X IN (temp2.txt) DO (
        set "thing[!idx!]=%%X"
        set /a idx+=1
      )
      ECHO !thing[0]!>>rawidlist.txt
      SET "FULLARRAY[!SERVCOUNT!].name=%%W"
      SET /a SERVCOUNT+=1
      DEL mods.toml
    )
  )
  SET TOTCOUNT=!SERVCOUNT!

  REM replaces spaces in the rawidlist.txt with astericks to let then next FOR loop find the modID using delims
  powershell -Command "(gc rawidlist.txt) -replace '""', '*' | Out-File -encoding ASCII rawidlist.txt"
  REM Uses delims to only return the actual string of the real modID name in the text and makes the serveridlist.txt
  REM --Only prints the modID if its not actually forge because of it being top of a mods.toml list
  SET SERVCOUNT=0

  FOR /F "tokens=2 delims=*" %%M in (rawidlist.txt) DO (
      ECHO %%M>>serveridlist.txt
      SET "FULLARRAY[!SERVCOUNT!].id=%%M"
      set /a SERVCOUNT+=1
  )
  REM Below skips to finishedscan label to bypass old style mod scan.
  IF !HOWOLD!==NOTVERY GOTO :finishedscan

  REM END SCANNING NEW STYLE MODS.TOML - BEGIN SCANNING OLD STYLE MCMOD.INFO
  :scanmcmodinfo


  REM Get total number of mods currently in mods folder
  SET rawmodstotal=0
  FOR /F "usebackq delims=" %%J IN (servermods.txt) DO (
    SET /a rawmodstotal+=1
  )

  SET modcount=0
  FOR /F "delims= usebackq" %%W IN (servermods.txt) DO (

    "%HERE%\univ-utils\7-zip\7za.exe" e -aoa "%HERE%\mods\%%W" "mcmod.info" >nul
    
    SET /a modcount+=1
    ECHO SCANNING - !modcount!/!rawmodstotal! - %%W

    IF EXIST mcmod.info (
      
      FINDSTR /i modid mcmod.info >temp2.txt
        REM Goes through modIds in temp2.txt and only prints to rawlist.txt the first modID found
        REM --IF the mod author puts the modID for forge first in mods.toml its a big bummmer - will filter out forge results later
      set idx=0
      FOR /F "delims=" %%X IN (temp2.txt) DO (
        set "thing[!idx!]=%%X"
        set /a idx+=1
      )
    
      ECHO !thing[0]!>>rawidlist.txt
      SET "FULLARRAY[!SERVCOUNT!].name=%%W"
      SET /a SERVCOUNT+=1
      DEL mcmod.info
    )
  )
  SET TOTCOUNT=!SERVCOUNT!

  REM replaces spaces in the rawidlist.txt with astericks to let then next FOR loop find the modID using delims
  powershell -Command "(gc rawidlist.txt) -replace '""', '*' | Out-File -encoding ASCII rawidlist.txt"
  REM Uses delims to only return the actual string of the real modID name in the text and makes the serveridlist.txt
  REM --Only prints the modID if its not actually forge because of it being top of a mods.toml list
  SET SERVCOUNT=0

  FOR /F "tokens=4 delims=*" %%M in (rawidlist.txt) DO (
      ECHO %%M>>serveridlist.txt
      SET "FULLARRAY[!SERVCOUNT!].id=%%M"
      set /a SERVCOUNT+=1
  )

  :: END SCANNING OLD STYLE MCMOD.INFO
  
  :: FINISHED SCANNING MODS serveridlist.txt and FULLARRAY.id variable array generated
  :finishedscan

  IF EXIST foundclientids.txt (
    SET /P EMPTYCHECK=<foundclientids.txt
    IF [!EMPTYCHECK!]==[] GOTO :skipcompare
  )

  :: Compares the two lists
  FINDSTR /xig:masterclientids.txt serveridlist.txt >foundclientids.txt

  :: Makes an array of the client ids and counts how many
  SET CLIENTCOUNT=0
  FOR /F %%S IN (foundclientids.txt) DO (
    SET "FOUND[!CLIENTCOUNT!]=%%S"
    SET /a CLIENTCOUNT+=1
  )
  SET TOTCLIENTCOUNT=!CLIENTCOUNT!

  :: Makes an array of only the client ids and matching mod file names
  FOR /L %%B IN (0,1,%TOTCLIENTCOUNT%) DO (
    FOR /L %%Q IN (0,1,%TOTCOUNT%) DO (
      IF !FULLARRAY[%%Q].id!==!FOUND[%%B]! (
        SET "FINALARRAY[%%B].name=!FULLARRAY[%%Q].name!"
        SET "FINALARRAY[%%B].id=!FOUND[%%B]!"
      )
    )
  )

:skipcompare
:: Cleans up the utility txt files used for mod scanning if present.
IF EXIST foundclientids.txt DEL foundclientids.txt
IF EXIST masterclientids.txt DEL masterclientids.txt
IF EXIST mods.toml DEL mods.toml
IF EXIST rawidlist.txt DEL rawidlist.txt
IF EXIST serveridlist.txt DEL serveridlist.txt
IF EXIST servermods.txt DEL servermods.txt
IF EXIST temp2.txt DEL temp2.txt
POPD

:: Skips ahead to the no clients found message if no client modIDs found in foundclientids.txt
IF [!FINALARRAY[0].name!]==[] GOTO :noclients
IF DEFINED EMPTYCHECK IF [!EMPTYCHECK!]==[] GOTO :noclients

  :: Prints report to user - echos all entries without the modID name = forge
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% THE FOLLOWING CLIENT ONLY MODS WERE FOUND %blue%
  ECHO.
  IF !HOWOLD!==SUPEROLD (
  ECHO    *NOTE - IT IS DETECTED THAT YOUR MINECRAFT VERSION STORES ITS ID NUMBER IN THE OLD WAY*
  ECHO     SOME CLIENT ONLY MODS MAY NOT BE DETECTED BY THE SCAN - I.E. MODS THAT DO NOT USE A MCMOD.INFO FILE
  )
  ECHO.
  ECHO    ------------------------------------------------------
  :: Prints to the screen all of the values in the array that are not equal to forge or null
  FOR /L %%T IN (0,1,%TOTCLIENTCOUNT%) DO (
    IF /I !FINALARRAY[%%T].id! NEQ forge IF /I "!FINALARRAY[%%T].id!" NEQ "" (
    ECHO        !FINALARRAY[%%T].name! - !FINALARRAY[%%T].id!
    )
  )
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO   %green% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO.
  ECHO         If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named %green% CLIENTMODS %blue%
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO.
  ECHO.
  ECHO      - IF YOU THINK THE CURRENT MASTER LIST IS INNACURATE OR HAVE FOUND A MOD TO ADD -
  ECHO         PLEASE CONTACT THE LAUNCHER AUTHOR OR
  ECHO         FILE AN ISSUE AT https://github.com/nanonestor/universalator/issues !
  ECHO.
  :typo
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO       %yellow% ENTER YOUR RESPONSE - 'Y' OR 'N' %blue%
  ECHO.
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N GOTO :mainmenu
  IF /I !MOVEMODS!==Y (
    IF NOT EXIST "%HERE%\CLIENTMODS" (
      MD CLIENTMODS
      )
      ) ELSE GOTO :typo
  :: Moves files if MOVEMODS is Y.  Checks to see if the value of the array is null for each spot.
  CLS
  ECHO.
  ECHO.
  FOR /L %%L IN (0,1,%TOTCLIENTCOUNT%) DO (
    IF "!FINALARRAY[%%L].name!" NEQ "" (
    MOVE "%HERE%\mods\!FINALARRAY[%%L].name!" "%HERE%\CLIENTMODS\!FINALARRAY[%%L].name!" >nul
    ECHO   MOVED - "!FINALARRAY[%%L].name!" 
    )
  )
  ECHO.
  ECHO      %yellow%   CLIENT MODS MOVED TO THIS FOLDER AS STORAGE:     %blue%
  ECHO      %yellow%   "%HERE%\CLIENTMODS" 
  ECHO.
  ECHO.
  ECHO      %yellow% -PRESS ANY KEY TO CONTINUE- %blue%
  ECHO.
  PAUSE
  
GOTO :mainmenu

:noclients
CLS
ECHO.
ECHO.
ECHO   %yellow% ----------------------------------------- %blue%
ECHO   %yellow%     NO CLIENT ONLY MODS FOUND             %blue%
ECHO   %yellow% ----------------------------------------- %blue%
ECHO.
ECHO    PRESS ANY KEY TO CONTINUE...
ECHO.
PAUSE
GOTO :mainmenu

:: FINALLY LAUNCH FORGE SERVER!
:launchforge

CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO   %yellow% READY TO LAUNCH FORGE SERVER! %blue%
ECHO.
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
ECHO        FORGE - !FORGE!
IF !OVERRIDE!==N ECHO        JAVA - !JAVAVERSION!
IF !OVERRIDE!==Y ECHO        JAVA - CUSTOM OVERRIDE
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO.
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==ON ECHO       %yellow% UPNP STATUS %blue% - %green% ENABLED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==OFF ECHO       %yellow% UPNP STATUS %blue% ------------------ %red% NOT ACTIVE %blue%
ECHO.
ECHO       %yellow% PUBLIC IPv4 %blue% AND PORT ADDRESS - %green% %PUBLICIP%:%PORT% %blue%
ECHO            --CLIENTS OUTSIDE THE CURRENT ROUTER NETWORK USE THIS ADDRESS TO CONNECT
IF NOT DEFINED UPNPSTATUS ECHO            --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER OR HAVE UPNP FORWARDING ENABLED
IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==OFF ECHO            --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER OR HAVE UPNP FORWARDING ENABLED
IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==ON ECHO.
ECHO.
ECHO       %yellow% INTERNAL IPv4 %blue% AND PORT ADDRESS 
ECHO            --ENTER 'ipconfig' FROM A COMMAND PROMPT TO FIND
ECHO            --CLIENTS INSIDE THE CURRENT ROUTER NETWORK USE THIS ADDRESS TO CONNECT
ECHO.
ECHO       %yellow% SAME COMPUTER %blue%
ECHO            --THE WORD 'localhost' WORKS FOR CLIENTS ON SAME COMPUTER INSTEAD OF ENTERING AN IP ADDRESS
ECHO ============================================
ECHO.
ECHO   %yellow% READY TO LAUNCH FORGE SERVER! %blue%
ECHO    PRESS ANY KEY TO START SERVER LAUNCH
ECHO.
PAUSE
ECHO. && ECHO   Launching... && ping -n 2 127.0.0.1 > nul && ECHO   Launching.. && ping -n 2 127.0.0.1 > nul && ECHO   Launching. && ECHO.
:: Starts forge depending on what java version is set.  Only correct combinations will launch - others will crash.

IF !OVERRIDE!==Y SET "JAVAFILE=java"
TITLE Universalator - !MINECRAFT! Forge
ver >nul
:: Special case forge.jar filenames for older OLD versions
IF %OLDORNEW%==OLD IF !MINECRAFT!==1.6.4 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar minecraftforge-universal-1.6.4-!FORGE!.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.7.10 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.7.10-!FORGE!-1.7.10-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.8.9 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.8.9-!FORGE!-1.8.9-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.9.4 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.9.4-!FORGE!-1.9.4-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.10.2 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.10.2-!FORGE!-universal.jar nogui
) 

:: General case forge.jar filenames for regular OLD Minecraft Forge newer (higher numbered) than 1.10.2
:: This will let non-specified special cases above slip though (weird unpopular versions).  Only a small percent of use cases will ever try them.
IF %OLDORNEW%==OLD IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 IF !MINECRAFT! NEQ 1.10.2 (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar forge-!MINECRAFT!-!FORGE!.jar nogui
) 

:: General case for NEW (1.17 and newer) Minecraft versions.  This remains unchanged at least until 1.19.3.
IF %OLDORNEW%==NEW (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %*
) 

:: Complaints to report in console output if launch attempt crashes

:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Stopping the server" >nul 2>&1 && PAUSE && GOTO :mainmenu

TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Unsupported class file major version" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO. && ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS CRASHING WITH THE CURRENT FORGE AND MODS VERSIONS %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% && ECHO.
  ECHO        %red% --SPECIAL NOTE-- %blue% && ECHO.
)

  :: Search if the standard client side mod message was found.  Ignore if java 19 is detected as probably the more important item.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"invalid dist DEDICATED_SERVER" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO. && ECHO        %red% --- SPECIAL MESSAGE --- %blue%
  ECHO    THE TEXT 'invalid dist DEDICATED_SERVER' WAS FOUND IN THE LOG FILE
  ECHO    THIS COULD MEAN YOU HAVE CLIENT MODS CRASHING THE SERVER - OTHERWISE SOME MOD AUTHORS DID NOT SILENCE THAT MESSAGE.
  ECHO.
  ECHO    TRY USING THE UNIVERSALATOR %green% 'SCAN' %blue% OPTION TO FIND CLIENT MODS.
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% && ECHO.
)

PAUSE
GOTO :mainmenu
:: END FORGE MAIN SECTION

:launchfabric
:: BEGIN FABRIC MAIN SECTION

:: Skips installation if already present
IF EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar GOTO :launchfabric

:: Deletes existing core files and folders if this specific desired Fabric launch file not present.  This forces a fresh installation and prevents getting a mis-match of various minecraft and/or fabric version files conflicting.
IF NOT EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar (
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  DEL *.jar >nul 2>&1
)

:: Pings the Fabric file server
  :fabricserverpingagain
  ping -n 3 maven.fabricmc.net >nul
  IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO.
    ECHO A PING TO THE FABRIC FILE SERVER HAS FAILED
    ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
    ECHO PRESS ANY KEY TO TRY AGAIN
    PAUSE
    GOTO :fabricserverpingagain
  )

:: Downloads Fabric installer and SHA256 hash value file
  IF EXIST fabric-installer.jar DEL fabric-installer.jar
  IF EXIST fabric-installer.jar.sha256 DEL fabric-installer.jar.sha256
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/!FABRICINSTALLER!/fabric-installer-!FABRICINSTALLER!.jar', 'fabric-installer.jar')" >nul
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/!FABRICINSTALLER!/fabric-installer-!FABRICINSTALLER!.jar.sha256', 'fabric-installer.jar.sha256')" >nul


:: Sends script execution back if no installer file found.
  IF NOT EXIST "fabric-installer.jar" (
    ECHO.
    ECHO    Something went wrong downloading the Fabric Installer file.
    ECHO    Press any key to try again.
    PAUSE
    GOTO :launchfabric
  )

:: Sets variable equal to the value in the sha256 file.
IF EXIST fabric-installer.jar.sha256 (
  SET /P INSTALLERVAL=<fabric-installer.jar.sha256
)
set idf=0 
IF EXIST "fabric-installer.jar" (
  for /f %%F  in ('certutil -hashfile "fabric-installer.jar" SHA256') do (
      set "Fout!idf!=%%F"
      set /a idf += 1
  )
)
IF EXIST fabric-installer.jar (
set fabricinstallerhecksum=%Fout1%
) ELSE (
    set fabricinstallerhecksum=0a
  )

:: Checks to see if the calculated checksum hash is the same as the value from the downloaded SHA256 file value
:: IF yes then install fabric server files
IF EXIST fabric-installer.jar (
    IF /I %INSTALLERVAL%==%fabricinstallerhecksum% (
      %JAVAFILE% -XX:+UseG1GC -jar fabric-installer.jar server -loader !FABRICLOADER! -mcversion !MINECRAFT! -downloadMinecraft
    ) ELSE (
      DEL fabric-installer.jar
      ECHO.
      ECHO   FABRIC INSTALLER FILE CHECKSUM VALUE DID NOT MATCH THE CHECKSUM IT WAS SUPPOSED TO BE
      ECHO   THIS LIKELY MEANS A CORRUPTED DOWNLOAD.
      ECHO.
      ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN!
      PAUSE
      GOTO :launchfabric
    )
)
IF EXIST fabric-installer.jar DEL fabric-installer.jar
IF EXIST fabric-installer.jar.sha256 DEL fabric-installer.jar.sha256
IF EXIST fabric-server-launch.jar (
  RENAME fabric-server-launch.jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar
)

::If eula.txt doens't exist yet 

:fabriceula
SET RESPONSE=IDKYET
IF NOT EXIST eula.txt (
  CLS
  ECHO.
  ECHO Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO.
  ECHO   %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue%
  ECHO.
  ECHO   %yellow% ENTER YOUR RESPONSE %blue%
  ECHO.
  SET /P "RESPONSE="
)
IF /I !RESPONSE!==AGREE (
  ECHO.
  ECHO User agreed to Mojang's EULA.
  ECHO.
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF !RESPONSE! NEQ IDKYET GOTO :fabriceula

IF EXIST eula.txt (
  ECHO.
  ECHO eula.txt file found! ..
  ECHO.
)
GOTO :launchfabric

:: BEGIN FABRIC client only mods scanning
:: Prompt user to decide to scan for client only mods or not.

:scanfabric

  IF EXIST rawidlist.txt DEL rawidlist.txt
  IF EXIST serveridlist.txt DEL serveridlist.txt

  ECHO.
  ECHO Searching for client mods . . .

  :: Goes to mods folder and gets file names lists.  FINDSTR prints only files with .jar found

  PUSHD mods
  dir /b /a-d > list1.txt
  FINDSTR .jar list1.txt > list2.txt
  SORT list2.txt > servermods.txt
  DEL list1.txt && DEL list2.txt
  
  :: Extracts the fabric.mod.json file from each JAR
  :: Gets the list of ids from actual mod JAR files using servermods.txt for file names
  :: Saves corresponding file names and ids in variable array

  SET SERVCOUNT=0
  IF EXIST "fabric.mod.json" DEL "fabric.mod.json"
  IF EXIST "allfabricdeps.txt" DEL "allfabricdeps.txt"

  :: START SCANNING MODS

  REM Get total number of mods currently in mods folder
  SET rawmodstotal=0
  FOR /F "usebackq delims=" %%J IN (servermods.txt) DO (
    SET /a rawmodstotal+=1
  )

  REM BEGIN SCANNING ALL MOD JAR FILE fabric.mod.json

  SET modcount=0
  FOR /F "usebackq delims=" %%N IN (servermods.txt) DO (

    REM  Uses 7 zip to extract each fabric.mod.json which is then scanned
    "%HERE%\univ-utils\7-zip\7za.exe" e -aoa "%HERE%\mods\%%N" "fabric.mod.json" >nul

    SET /a modcount+=1
    ECHO SCANNING - !modcount!/!rawmodstotal! - %%N

    REM For ALL mods create list of dependency mods for later IDs comparison
    REM Save all special dependencies not fabric, minecraft, or java related to a single text file to sort and remove duplicates from later.
    
    IF EXIST "fabric.mod.json" (

      REM BEGIN BATCH script to process a JSON file to extract values from a property.
      REM In this case the property is 'depends' - It uses FOR loops to detect the beginning
      REM and end of the property to record all values to an output file.
      
      REM ---YES this can be done with one line in a powershell call - however when doing this to hundreds of files it's also 4-5x SLOWER compared to the following CMD / batch method.
      REM powershell -Command "$json=Get-Content -Raw -Path 'fabric.mod.json' | Out-String | ConvertFrom-Json; $json.depends.psobject.properties.name | Out-File -FilePath .\deps.txt" >nul

      SET jsonum=0
      REM Creates a pseudo-array containing the contents of the fabric.mod.json file but with double quotes replaced with hash/pound symbols for making life easier in BATCH searches. Because double quotes are special characters and hash/pound isn't.
      REM The variable jsonum keeps track of how many lines in the json there are, and sets up the pseudo-array number of each line.
      FOR /F "delims=" %%x IN ('type fabric.mod.json') DO (
              SET "tempvar=%%x"
              SET "fabricjson[!jsonum!]=!tempvar:"=#!"
              SET /a jsonum+=1
      )
      SET jsonnumber=!jsonum!
      :: Gets line number of the string 'depends' - by searching the pseudo-array from 0 to the total number of lines 'jsonnumber'.
      SET idg=0
      FOR /L %%T IN (0,1,!jsonnumber!) DO (
          FOR /F "delims=" %%T IN ("!fabricjson[%%T]!") DO (
              SET "tempvar=%%T"
              SET "tempvar3=!tempvar:depends=b!"
              IF "!tempvar!" NEQ "!tempvar3!" SET DEPHEIGHT=!idg!
              SET /a idg+=1
          )
      )
      :: Gets line number of } which is after 'depends' in the same type of method as the way depends was found.  If it gets recorded then done tag takes program out of the loop.
      SET idm=0
      SET FOUNDBRACKET=0
      FOR /L %%T IN (0,1,!jsonnumber!) DO (
          FOR /F "delims=" %%T IN ("!fabricjson[%%T]!") DO (
              SET "tempvar=%%T"
              SET "tempvar2=!tempvar:}=b!"
              IF !FOUNDBRACKET!==0 IF !idm! GTR !DEPHEIGHT! IF "!tempvar!" NEQ "!tempvar2!" (
                  SET BRACKET=!idm!
                  SET FOUNDBRACKET=1
              )
              SET /a idm+=1
          )
      )

      :: Takes the two heights and prints the values between the two
      FOR /L %%T IN (0,1,!jsonnumber!) DO (
          IF %%T GTR !DEPHEIGHT! IF %%T LSS !BRACKET! (
              FOR /F "tokens=2 delims=#" %%A IN ("!fabricjson[%%T]!") DO (
                      ECHO %%A>deps.txt
              )
          )
      )
      
      REM END BATCH SCRIPT parsing JSON file fabric.mod.json - It did it's job of pulling out the dependency mods to deps.txt

      REM For each deps.txt file write to text file the depedency mod ids for further processing later.  The list of IF NEQ conditions filters out some common ones that never need to be included - it cuts down on the text file size for later processing.
      FOR /F %%U IN ('type deps.txt') DO (
        IF /I %%U NEQ fabricloader IF /I %%U NEQ fabric IF /I %%U NEQ minecraft IF /I %%U NEQ java IF /I %%U NEQ cloth-config IF /I %%U NEQ cloth-config2 IF /I %%U NEQ fabric-language-kotlin IF /I %%U NEQ iceberg IF /I %%U NEQ fabric-resource-loader-v0 IF /I %%U NEQ creativecore IF /I %%U NEQ architectury (
          ECHO %%U>>allfabricdeps.txt
        )
      )

      REM Makes a temp file and checks to see if the environment entry was even found or not.
      FINDSTR \^"environment\^" "fabric.mod.json" >whichsided.txt
      FOR /F %%A IN ("whichsided.txt") DO IF %%~zA NEQ 0 (
        REM Figures out if the contents of non-empty whichsided.txt are equal to client or not.
        REM Changes quotes in data to hashmark symbol because easier to enter as delims in FOR loop.
        SET /p whichsided=<whichsided.txt
        SET whichsided=!whichsided:"=#!
        set idr=0
        FOR /F "tokens=4 delims=#" %%A IN ("!whichsided!") DO (
            set "environ[!idr!]=%%A"
            set /a idr+=1
        )
        IF /I !environ[0]!==client (
          REM Assumes now that this fabric.mod.json is a for a client mod and gets the id, then saves to holding variable array
          REM Because this is all going off of the mod file names list the results will be in order of file name alphabetization.
          FOR /F "delims=" %%A in ('FINDSTR \^"id\^" fabric.mod.json') DO SET "idstring=%%A"
          SET idstring=!idstring:"=#!
          SET ide=0
          FOR /F "tokens=4 delims=#" %%A IN ("!idstring!") DO (
            set "idvalue[!ide!]=%%A"
            set /a ide+=1
          )
          REM Creates a pseudo-array using the SERVCOUNT of each found client mod as array number.  This will now contain all of the found client mods by file name and mod ID.
          SET FABRICCLIENTS[!SERVCOUNT!].name=%%N
          SET FABRICCLIENTS[!SERVCOUNT!].id=!idvalue[0]!


          REM Adds 1 to the server client mods count.  This is to keep track of how many entries are done.
          SET /a SERVCOUNT+=1
    )))

    REM Deletes existing fabric.mod.json to ensure that the next unzip/extract attempt and subsequent looking for it will result in nothing if there is nothing in that next JAR file.
    IF EXIST fabric.mod.json DEL fabric.mod.json
  )


  SET TOTCLIENTCOUNT=!SERVCOUNT!

  :: Skips bothering to compare dependency lists of all mods vs client IDs and user report if no client mods found.
  IF [!FABRICCLIENTS[0].name!]==[] GOTO :noclientsfabric

  :: Processes allfabricdeps.txt and compares to list of client mods
  IF EXIST allfabricdepssorted.txt DEL allfabricdepssorted.txt
  IF EXIST actualdeps.txt DEL actualdeps.txt

  SORT allfabricdeps.txt > allfabricdepssorted.txt
  SET prevline=blank
  FOR /F "usebackq delims=" %%a IN (allfabricdepssorted.txt) DO (
    IF /I %%a NEQ !prevline! (
      ECHO %%a>>actualdeps.txt
      SET prevline=%%a
    )
  )

  SET ifinal=0
  SET ISITADEP=0
  
  FOR /L %%T IN (0,1,%TOTCLIENTCOUNT%) DO (
    FOR /F "usebackq delims=" %%b IN (actualdeps.txt) DO (
      IF /I "%%b" EQU "!FABRICCLIENTS[%%T].id!" SET ISITADEP=1
    )
    IF !ISITADEP! EQU 0 (
      SET "FINALFABRICCLIENTS[!ifinal!].name=!FABRICCLIENTS[%%T].name!"
      SET "FINALFABRICCLIENTS[!ifinal!].id=!FABRICCLIENTS[%%T].id!"
      SET /a ifinal+=1
    )
    SET /a ISITADEP=0
  )
  SET finalcount=!ifinal!

  :noclientsfabric
  IF EXIST actualdeps.txt DEL actualdeps.txt
  IF EXIST allfabricdeps.txt DEL allfabricdeps.txt
  IF EXIST allfabricdepssorted.txt DEL allfabricdepssorted.txt
  IF EXIST deps.txt DEL deps.txt
  IF EXIST servermods.txt DEL servermods.txt
  IF EXIST whichsided.txt DEL whichsided.txt
  POPD
  IF [!FABRICCLIENTS[0].name!]==[] GOTO :finalnoclientsfabric


  REM Prints report to user - echos all entries without the modID name = forge
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% THE FOLLOWING FABRIC - CLIENT MARKED MODS WERE FOUND %blue%
  ECHO.
  ECHO    ------------------------------------------------------
  REM Prints to the screen all of the values in the array that are not equal to forge or null
  FOR /L %%T IN (0,1,%finalcount%) DO (
    IF /I "!FINALFABRICCLIENTS[%%T].name!" NEQ "" (
    ECHO        !FINALFABRICCLIENTS[%%T].name! - !FINALFABRICCLIENTS[%%T].id!
    )
  )
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO.
  ECHO   %green% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO.
  ECHO         If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named %green% CLIENTMODS %blue%
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO.
  :typo
  ECHO.
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO       %yellow% ENTER YOUR RESPONSE - 'Y' OR 'N' %blue%
  ECHO.
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N GOTO :mainmenu
  IF /I !MOVEMODS!==Y (
    IF NOT EXIST "%HERE%\CLIENTMODS" (
      MD CLIENTMODS
      )
      ) ELSE GOTO :typo
  :: Moves files if MOVEMODS is Y.  Checks to see if the value of the array is null for each spot.
  CLS
  ECHO.
  ECHO.
  FOR /L %%L IN (0,1,%finalcount%) DO (
    IF "!FINALFABRICCLIENTS[%%L].name!" NEQ "" (
    MOVE "%HERE%\mods\!FINALFABRICCLIENTS[%%L].name!" "%HERE%\CLIENTMODS\!FINALFABRICCLIENTS[%%L].name!" >nul
    ECHO   MOVED - "!FINALFABRICCLIENTS[%%L].name!" 
    )
  )
  ECHO.
  ECHO      %yellow%   CLIENT MODS MOVED TO THIS FOLDER AS STORAGE:     %blue%
  ECHO      %yellow%   "%HERE%\CLIENTMODS" 
  ECHO.
  ECHO.
  ECHO      %yellow% -PRESS ANY KEY TO CONTINUE- %blue%
  ECHO.
  PAUSE
  GOTO :mainmenu

:finalnoclientsfabric
CLS
ECHO.
ECHO.
ECHO   %yellow% ----------------------------------------- %blue%
ECHO   %yellow%     NO CLIENT ONLY MODS FOUND             %blue%
ECHO   %yellow% ----------------------------------------- %blue%
ECHO.
ECHO    PRESS ANY KEY TO CONTINUE...
ECHO.
PAUSE
GOTO :mainmenu

::END FABRIC CLIENT ONLY MODS SCANNING


:: FINALLY LAUNCH FABRIC SERVER!
:launchfabric
CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO   %yellow% READY TO LAUNCH FABRIC SERVER! %blue%
ECHO.
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
ECHO        FABRIC LOADER - !FABRICLOADER!
IF !OVERRIDE!==N ECHO        JAVA - !JAVAVERSION!
IF !OVERRIDE!==Y ECHO        JAVA - CUSTOM OVERRIDE
ECHO.
ECHO.
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
ECHO.
ECHO   %yellow% PUBLIC IPv4 AND PORT ADDRESS %blue% - %green% %PUBLICIP%:%PORT% %blue%
ECHO        --THIS IS WHAT CLIENTS OUTSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO        --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER
ECHO.
ECHO   INTERNAL IPv4 ADDRESS - ENTER 'ipconfig' FROM A COMMAND PROMPT
ECHO        --THIS IS WHAT CLIENTS INSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO.
ECHO        --THE WORD 'localhost' WORKS FOR CLIENTS ON SAME COMPUTER
ECHO.
ECHO ============================================
ECHO.
ECHO   %yellow% PRESS ANY KEY TO START SERVER LAUNCH %blue%
ECHO.
PAUSE
ECHO. && ECHO   Launching... && ping -n 2 127.0.0.1 > nul && ECHO   Launching.. && ping -n 2 127.0.0.1 > nul && ECHO   Launching. && ECHO.

IF !OVERRIDE!==Y SET "JAVAFILE=java"
TITLE Universalator - !MINECRAFT! Fabric

%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar nogui

:: Complains in console output if launch attempt crashes
:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Stopping the server" >nul 2>&1 && PAUSE && GOTO :mainmenu

:: Search if java version mismatch is found
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Unsupported class file major version" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO. && ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS CRASHING WITH THE CURRENT FORGE AND MODS VERSIONS %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% && ECHO.
  ECHO        %red% --SPECIAL NOTE-- %blue% && ECHO.
)

:: Search if the standard client side mod message was found.  Ignore if java 19 is detected as probably the more important item.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"invalid dist DEDICATED_SERVER" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO. && ECHO        %red% --- SPECIAL MESSAGE --- %blue%
  ECHO    THE TEXT 'invalid dist DEDICATED_SERVER' WAS FOUND IN THE LOG FILE
  ECHO    THIS COULD MEAN YOU HAVE CLIENT MODS CRASHING THE SERVER - OTHERWISE SOME MOD AUTHORS DID NOT SILENCE THAT MESSAGE.
  ECHO.
  ECHO    TRY USING THE UNIVERSALATOR %green% 'SCAN' %blue% OPTION TO FIND CLIENT MODS.
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% && ECHO.
)

PAUSE
GOTO :mainmenu

:: BEGIN UPNP SECTION
:upnpmenu
CLS
ECHO.%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO      UPNP PORT FORWARDING MENU    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO.
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO   %yellow% MiniUPnP PROGRAM %blue% - %red% NOT YET INSTALLED / DOWNLOADED %blue%
ECHO   Port forwarding done in one way or another is requied for people outside your router network to connect.
ECHO   ---------------------------------------------------------------------------------------------
ECHO   %yellow% SETTING UP PORT FORWARDING: %blue%
ECHO   1- THE PREFERRED METHOD IS MANUALLY SETTING UP PORT FORWARDING IN YOUR ROUTER
ECHO        Manual setting of port forwarding introduces less risk allowing connections than using UPnP.  
ECHO.
ECHO   2- UPnP CAN BE USED IF YOU HAVE A COMPATIBLE NETWORK ROUTER WITH UPnP SET TO ENABLED
ECHO        UPnP is a connection method with which networked computers can open ports on network routers.
ECHO        Not all routers have UPnP - and if yours does it needs to be enabled in settings  - it often is by default.
ECHO. && ECHO.
ECHO        For personal preference the tool used by the Universalator to do UPnP functions - MiniUPnP - is not downloaded
ECHO        by default.  To check if your router can use UPnP, and use it for setting up port forwarding - you can
ECHO        enter %yellow% DOWNLOAD %blue% to get the file and enable Universalator script UPnP functions.
ECHO. && ECHO.
ECHO      %yellow% FOR MORE INFORMATION ON PORT FORWARDING AND UPnP - VISIT THE UNIVERSALATOR WIKI AT: %blue%
ECHO      %yellow% https://github.com/nanonestor/universalator/wiki                                    %blue%
ECHO. && ECHO   ENTER YOUR SELECTION && ECHO      %green% 'DOWNLOAD' - Download UPnP Program %blue% && ECHO      %green% 'M' - Main Menu %blue%
)

IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO. && ECHO   %yellow% MiniUPnP PROGRAM %blue% - %green% INSTALLED / DOWNLOADED %blue%
IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue% -      %red% NOT ACTIVATED %blue% && ECHO. && ECHO.
IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue% - %green% ACTIVE - FORWARDING PORT %PORT% %blue% && ECHO. && ECHO.
)



IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO. && ECHO.
ECHO   %green% CHECK - Check for a network router with UPnP enabled %blue% && ECHO.
ECHO   %green%                                       %blue%
ECHO   %green% A - Activate UPnP Port Forwarding     %blue%
ECHO   %green%                                       %blue%
ECHO   %green% D - Deactivate UPnP Port Forwarding   %blue%
ECHO   %green%                                       %blue%
ECHO   %green% S - Status of port forwarding refresh %blue%
ECHO   %green%                                       %blue%
ECHO. && ECHO   %green% M - Main Menu %blue%
ECHO. && ECHO   Enter your choice:
)
ECHO.

SET /P "ASKUPNPMENU="
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
IF /I !ASKUPNPMENU!==M GOTO :mainmenu
IF /I !ASKUPNPMENU!==CHECK GOTO :upnpvalid
IF /I !ASKUPNPMENU!==A GOTO :upnpactivate
IF /I !ASKUPNPMENU!==D GOTO :upnpdeactivate
IF /I !ASKUPNPMENU!==S GOTO :upnpstatus
IF /I !ASKUPNPMENU! NEQ M IF /I !ASKUPNPMENU! NEQ CHECK IF /I !ASKUPNPMENU! NEQ A IF /I !ASKUPNPMENU! NEQ D IF /I !ASKUPNPMENU! NEQ S GOTO :upnpmenu
)

IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
IF /I !ASKUPNPMENU!==DOWNLOAD GOTO :upnpdownload
IF /I !ASKUPNPMENU!==M GOTO :mainmenu
IF /I !ASKUPNPMENU! NEQ DOWNLOAD IF /I !ASKUPNPMENU! NEQ M GOTO :upnpmenu
)


:: BEGIN UPNP LOOK FOR VALID & ENABLED UPNP ROUTER
:upnpvalid
:: Loops through the status flag -s looking for lines that are different between itself and itself but replacing any found 'Found valid IGD' with random other string.
SET FOUNDVALIDUPNP=N
ECHO   Checking for UPnP Enabled Network Router ... ... ...
FOR /F "delims=" %%B IN ('univ-utils\miniupnp\upnpc-static.exe -s') DO (
    SET UPNPSCAN=%%B
    IF "!UPNPSCAN!" NEQ "!UPNPSCAN:Found valid IGD=huh!" SET FOUNDVALIDUPNP=Y
)
:: Messages to confirm or give the bad news about finding a UPNP enabled device.
IF !FOUNDVALIDUPNP!==N (
    CLS
    ECHO. && ECHO.
    ECHO   %red% NO UPNP ENABLED NETWORK ROUTER WAS FOUND - SORRY. %blue% && ECHO.
    ECHO   IT IS POSSIBLE THAT YOUR ROUTER DOES HAVE UPNP COMPATIBILITY BUT IT IS CURRENTLY
    ECHO   SET TO DISABLED.  CHECK YOUR NETWORK ROUTER SETTINGS.
    ECHO. && ECHO   or && ECHO.
    ECHO   YOU WILL NEED TO CONFIGURE PORT FORWARDING ON YOUR NETWORK ROUTER MANUALLY
    ECHO   FOR INSRUCTIONS YOU CAN WEB SEARCH PORT FORWARDING MINECRAFT SERVERS
    ECHO   OR
    ECHO   VISIT THE UNIVERSALATOR WIKI AT:
    ECHO   https://github.com/nanonestor/universalator/wiki
    ECHO. && ECHO.
    PAUSE
    GOTO :upnpmenu
)
IF !FOUNDVALIDUPNP!==Y (
    CLS
    ECHO. && ECHO. && ECHO.
    ECHO     %green% FOUND A NETWORK ROUTER WITH UPNP ENABLED FOR USE %blue%
    ECHO.
    SET ISUPNPACTIVE=N
    PAUSE
    GOTO :upnpmenu
)
GOTO :upnpmenu
:: END UPNP LOOK FOR VALID & ENABLED UPNP ROUTER


:: BEGIN UPNP ENABLE PORT FOWARD
:upnpactivate
CLS
ECHO. && ECHO. && ECHO.
ECHO       %yellow% ENABLE UPNP PORT FORWARDING? %blue%
ECHO. && ECHO.
ECHO         Enter your choice:
ECHO.
ECHO         %green% 'Y' or 'N' %blue%
ECHO.
SET /P "ENABLEUPNP="
IF /I !ENABLEUPNP! NEQ N IF /I !ENABLEUPNP! NEQ Y GOTO :upnpactivate
IF /I !ENABLEUPNP!==N GOTO :upnpmenu
IF /I !ENABLEUPNP!==Y (
  univ-utils\miniupnp\upnpc-static.exe -a %PUBLICIP% %PORT% %PORT%% TCP
  univ-utils\miniupnp\upnpc-static.exe -r %PORT% TCP
  GOTO :upnpstatus
)
:: END UPNP ENABLE  PORT FORWARD


:: BEGIN UPNP CHECK STATUS
:upnpstatus
:: Loops through the lines in the -l flag to list MiniUPNP active ports - looks for a line that is different with itself compated to itself but
:: trying to replace any string inside that matches the port number with a random different string - in this case 'PORT' for no real reason.
:: Neat huh?  Is proabably faster than piping an echo of the variables to findstr and then checking errorlevels (other method to do this).
ECHO   %red% Checking Status of UPnP Port Forward ... ... ... %blue%
SET ISUPNPACTIVE=N
FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
    SET UPNPSTATUS=%%E
    IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
)
GOTO :upnpmenu
:: END UPNP CHECK STATUS


:: BEGIN UPNP DEACTIVATE AND CHECK STATUS AFTER
:upnpdeactivate
IF !ISUPNPACTIVE!==Y (
    CLS
    ECHO. && ECHO. && ECHO.
    ECHO   %yellow% UPNP IS CURRENTLY ACTIVE %blue%
    ECHO.
    ECHO   %yellow% DO YOU WANT TO DEACTIVATE IT? %blue%
    ECHO. && ECHO.
    ECHO       %green% 'Y' or 'N' %blue% && ECHO.
    ECHO       Enter your choice: && ECHO.
    SET /P "DEACTIVATEUPNP="
)
IF /I !DEACTIVATEUPNP! NEQ Y IF /I !DEACTIVATEUPNP! NEQ N GOTO :upnpdeactivate
IF /I !DEACTIVATEUPNP!==N GOTO :upnpmenu
:: Deletes the port connection used by the MiniUPNP program.
IF /I !DEACTIVATEUPNP!==Y (
    univ-utils\miniupnp\upnpc-static.exe -d %PORT% TCP
    SET ISUPNPACTIVE=N
    FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
        SET UPNPSTATUS=%%E
        IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
    )
    IF !ISUPNPACTIVE!==N (
        CLS
        ECHO. && ECHO.
        ECHO      UPNP SUCCESSFULLY DEACTIVATED
        ECHO.
        PAUSE
        GOTO :upnpmenu
    )
    IF !ISUPNPACTIVE!==Y (
      ECHO.
      ECHO   %red% DEACTIVATION OF UPNP PORT FORWARDING HAS FAILED %blue% && ECHO.
      ECHO   %red% UPNP PORT FORWARDING IS STILL ACTIVE %blue% && ECHO.
      PAUSE
      GOTO :upnpmenu
    )
)
:: END UPNP DEACTIVATE AND CHECK STATUS AFTER


:: BEGIN UPNP FILE DOWNLOAD
:upnpdownload
CLS
ECHO. && ECHO.
ECHO  %yellow% DOWNLOAD MINIUPNP PROGRAM? %blue% && ECHO.
ECHO  THE SCRIPT WILL DOWNLOAD THE MINIUPnP PROGRAM FROM THAT PROJECTS WEBSITE AT: && ECHO.
ECHO   http://miniupnp.free.fr/files/ && ECHO.
ECHO   MiniUPnP is published / licensed as a free and open source program. && ECHO.
ECHO  %yellow% DOWNLOAD MINIUPNP PROGRAM? %blue% && ECHO.
ECHO   ENTER YOUR CHOICE: && ECHO.
ECHO   %green%  'Y' - Download file %blue%
ECHO   %green%  'N' - NO  (Back to UPnP menu) %blue% && ECHO.
SET /P "ASKUPNPDOWNLOAD="
IF /I !ASKUPNPDOWNLOAD! NEQ N IF /I !ASKUPNPDOWNLOAD! NEQ Y GOTO :upnpdownload
IF /I !ASKUPNPDOWNLOAD!==N GOTO :upnpmenu
:: If download is chosen - download the MiniUPNP Windows client ZIP file, License.  Then unzip out only the standalone miniupnp-static.exe file and delete the ZIP.
IF /I !ASKUPNPDOWNLOAD!==Y IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
  CLS
  ECHO. && ECHO. && ECHO   Downloading ZIP file ... ... ... && ECHO.
  IF NOT EXIST "%HERE%\univ-utils\miniupnp" MD "%HERE%\univ-utils\miniupnp"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('http://miniupnp.free.fr/files/upnpc-exe-win32-20220515.zip', 'univ-utils\miniupnp\upnpc-exe-win32-20220515.zip')"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/miniupnp/miniupnp/master/LICENSE', 'univ-utils\miniupnp\LICENSE.txt')"
  IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" (
    ECHO   %green% SUCCESSFULLY DOWNLOADED MINIUPNP BINARAIES ZIP FILE %blue%
    "%HERE%\univ-utils\7-zip\7za.exe" e -aoa "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" "upnpc-static.exe" -ouniv-utils\miniupnp >nul
    DEL "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" >nul 2>&1
  ) ELSE (
      ECHO. && ECHO  %red% DOWNLOAD OF MINIUPNP FILES ZIP FAILED %blue%
      PAUSE
      GOTO :upnpmenu
  )
  IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
    SET FOUNDUPNPEXE=Y
    ECHO. && ECHO   %green% MINIUPNP FILE upnpc-static.exe SUCCESSFULLY EXTRACTED FROM ZIP %blue% && ECHO. && ECHO.
    PAUSE
  ) ELSE (
    SET FOUNDUPNPEXE=N
    ECHO. && ECHO   %green% MINIUPNP BINARY ZIP FILE WAS FOUND TO BE DOWNLOADED %blue% && ECHO   %red% BUT FOR SOME REASON EXTRACTING THE upnpc-static.exe FILE FROM THE ZIP FAILED %blue%
    PAUSE 
  )
  GOTO :upnpmenu
) ELSE GOTO :upnpmenu

:: END UPNP SECTION

:: BEGIN JAVA OVERRIDE SECTION
:override
CLS
ECHO. && ECHO. && ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% && ECHO   %yellow% Using the following system Path Java %blue% && ECHO.
FOR /F "delims=" %%J IN ('java -version') DO ECHO %%J
ECHO. && ECHO   %yellow% GOOD LUCK WITH THAT !! %blue% && ECHO. && ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% && ECHO.
SET OVERRIDE=Y
PAUSE
GOTO :mainmenu
:: END JAVA OVERRIDE SECTION

:: BEGIN MCREATOR SECTION
:mcreator
CLS
ECHO.
ECHO %yellow% Searching 'mods' folder for MCreator mods [Please Wait] %blue%
ECHO.
PUSHD mods
findstr /i /m "net/mcreator /procedures/" *.jar >final.txt
IF !ERRORLEVEL!==1 (
  IF EXIST final.txt DEL final.txt
  POPD
  ECHO. && ECHO  %green% NO MCREATOR MADE MODS WERE DETECTED IN THE MODS FOLDER %blue% && ECHO.
  PAUSE
  GOTO :mainmenu
)
ver >nul
SORT final.txt > mcreator-mods.txt
DEL final.txt
POPD
MOVE "%HERE%\mods\mcreator-mods.txt" "%HERE%\mcreator-mods.txt"
CLS
ECHO.
ECHO            %yellow% RESULTS OF Search %blue%
ECHO ---------------------------------------------
for /f "tokens=1 delims=" %%i in (mcreator-mods.txt) DO (
  ECHO    mcreator mod - %%i
)
ECHO. && ECHO. && ECHO.
ECHO    The above mod files were created using MCreator.
ECHO    %red% They are known to often cause severe problems because of the way they get coded. %blue% && ECHO.
ECHO    A text tile has been generated in this directory named mcreator-mods.txt listing
ECHO      the mod file names for future reference. && ECHO.
PAUSE
GOTO :mainmenu
:: END MCREATOR SECTION
