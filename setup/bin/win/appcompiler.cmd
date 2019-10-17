@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

REM set boot parameters
SET BOOT_PARAMETER=%*

REM execute appcompiler
"%JAVA_HOME%\bin\java" -classpath "%BOOTSTRAP_CLASSPATH%" ^
    -Xmx512m ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    -Djeus.home="%JEUS_HOME%" ^
    jeus.tool.compiler.AppCompilerBootstrapper %BOOT_PARAMETER%

ENDLOCAL
