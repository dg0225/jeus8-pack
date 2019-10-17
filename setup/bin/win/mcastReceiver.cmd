@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

ECHO **************************************************************
ECHO   - JEUS Home         : %JEUS_HOME%
ECHO   - Java Vendor       : %JAVA_VENDOR%
ECHO   - Added Java Option : %JAVA_ARGS%
ECHO **************************************************************

REM execute jeus with echo
@echo on
"%JAVA_HOME%\bin\java" -classpath "%JEUS_HOME%\lib\client\mcast-test.jar" ^
com.tmax.jeus.multicast.MulticastReceiver %*
@echo off

ENDLOCAL
