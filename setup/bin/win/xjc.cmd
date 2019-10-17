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

REM set classpath
SET CLASS_PATH=%JEUS_HOME%\lib\system\jaxb-osgi.jar
SET CLASS_PATH=%CLASS_PATH%;%JEUS_HOME%\lib\system\javaee.jar
SET CLASS_PATH=%CLASS_PATH%;%JEUS_HOME%\lib\system\activation.jar

REM set xjc options
SET XJC_OPTS=

REM execute xjc
"%JAVA_HOME%\bin\java" -classpath "%CLASS_PATH%" %TOOL_OPTION% ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    %XJC_OPTS% ^
    %JAVA_ARGS% ^
    com.sun.tools.xjc.XJCFacade %BOOT_PARAMETER%

ENDLOCAL
