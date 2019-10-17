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

REM set wsdl2uddi options
SET WSDL2UDDI_OPTS=

REM execute wsdl2uddi
"%JAVA_HOME%\bin\java" -classpath "%BOOTSTRAP_CLASSPATH%" %TOOL_OPTION% ^
    -Djeus.home="%JEUS_HOME%" ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    %WSDL2UDDI_OPTS% ^
    %JAVA_ARGS% ^
    %BOOTSTRAPPER% ^
    jeus.server.Bootstrapper jeus.webservices.tools.wsdl2uddi.Wsdl2Uddi %BOOT_PARAMETER%

ENDLOCAL
