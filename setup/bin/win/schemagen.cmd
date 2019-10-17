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

REM execute schemagen
"%JAVA_HOME%\bin\java" -classpath "%CLASS_PATH%" %TOOL_OPTION% ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    %JAVA_ARGS% ^
    com.sun.tools.jxc.SchemaGeneratorFacade %BOOT_PARAMETER%

ENDLOCAL
