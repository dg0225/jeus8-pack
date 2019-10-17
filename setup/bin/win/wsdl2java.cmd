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

REM set wsdl2java options
SET WSDL2JAVA_OPTS=

REM execute wsdl2java
"%JAVA_HOME%\bin\java" -classpath "%BOOTSTRAP_CLASSPATH%" %TOOL_OPTION% ^
    -Djeus.home="%JEUS_HOME%" ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    %WSDL2JAVA_OPTS% ^
    %JAVA_ARGS% ^
    %BOOTSTRAPPER% ^
    jeus.webservices.jaxrpc.tools.wscompile.Wsdl2Java %BOOT_PARAMETER%

ENDLOCAL
