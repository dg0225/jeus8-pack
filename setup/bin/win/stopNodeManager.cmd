@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

ECHO ******************************************************************
ECHO   - Usage : stopNodeManager -host host -port port
ECHO ******************************************************************

REM set boot parameter
SET BOOT_PARAMETER=%*

REM execute jeusadmin
"%JAVA_HOME%\bin\java" -classpath "%BOOTSTRAP_CLASSPATH%" %TOOL_OPTION% ^
    -Djeus.home="%JEUS_HOME%" ^
    -Djava.library.path="%JEUS_LIBPATH%" ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    -Djava.naming.factory.initial=jeus.jndi.JNSContextFactory ^
    -Djava.naming.factory.url.pkgs=jeus.jndi.jns.url ^
    -Djeus.baseport=%JEUS_BASEPORT% ^
    -Djava.util.logging.config.file="%JEUS_HOME%\bin\logging.properties" ^
    %JAVA_ARGS% ^
    %BOOTSTRAPPER% ^
    jeus.tool.console.console.ConsoleMain "stop-nodemanager %BOOT_PARAMETER%"

ENDLOCAL