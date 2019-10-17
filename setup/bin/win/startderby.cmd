@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B


REM set classpath
SET CLASS_PATH=%JEUS_HOME%\derby\lib\derby.jar
SET CLASS_PATH=%CLASS_PATH%;%JEUS_HOME%\derby\lib\derbytools.jar
SET CLASS_PATH=%CLASS_PATH%;%JEUS_HOME%\derby\lib\derbynet.jar


REM move to JEUS HOME's bin
cd /D "%JEUS_HOME%\bin"


REM set the host information of derby server
if "%1" == "" goto setServerHost
set derbyHost=%1
goto set_port

:setServerHost
if not "%DERBY_SERVER_HOST%" == "" goto setServerHost2
set derbyHost=localhost
goto set_port

:setServerHost2
set derbyHost=%DERBY_SERVER_HOST%


REM set the port information of derby server
:set_port
shift
if "%1" == "" goto setServerPort
set derbyPort=%1
goto start_server

:setServerPort
if not "%DERBY_SERVER_PORT%" == ""  goto setServerPort2
set derbyPort=1527
goto start_server

:setServerPort2
set derbyPort=%DERBY_SERVER_PORT%

:start_server


REM set boot parameter
SET BOOT_PARAMETER=start -h %derbyHost% -p %derbyPort%

REM execute startderby
"%JAVA_HOME%\bin\java" -Dderby.system.home="%JEUS_HOME%\derby\databases" ^
    -classpath "%CLASS_PATH%" ^
    %JAVA_ARGS% ^
    org.apache.derby.drda.NetworkServerControl %BOOT_PARAMETER%

ENDLOCAL
