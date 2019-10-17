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

REM set java2wsdl options
set JAVA2WSDL_OPTS=

REM execute java2wsdl
"%JAVA_HOME%\bin\java" -classpath "%BOOTSTRAP_CLASSPATH%" %TOOL_OPTION% ^
    -Djeus.home="%JEUS_HOME%" ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    %JAVA2WSDL_OPTS% ^
    %JAVA_ARGS% ^
    %BOOTSTRAPPER% ^
    jeus.webservices.jaxrpc.tools.wscompile.Java2Wsdl %BOOT_PARAMETER%

ENDLOCAL
