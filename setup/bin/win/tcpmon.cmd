@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

REM set boot parameter
SET BOOT_PARAMETER=%*

REM execute tcpmon
start /D"%JAVA_HOME%\bin\" javaw ^
    -Dsun.java2d.noddraw ^
    -classpath "%TOOL_CLASSPATH%" %TOOL_OPTION% ^
    -Djeus.home="%JEUS_HOME%" ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    -Djava.naming.factory.initial=jeus.jndi.JEUSContextFactory ^
    -Djava.naming.factory.url.pkgs=jeus.jndi.jns.url ^
    -Djeus.baseport=%JEUS_BASEPORT% ^
    %BOOTSTRAPPER% ^
    com.tmax.axis.utils.tcpmon %BOOT_PARAMETER%

ENDLOCAL
