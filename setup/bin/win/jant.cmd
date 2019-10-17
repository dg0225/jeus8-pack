@echo off
REM
REM Tmax Soft JEUS Ant
REM

SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

set ANT_HOME=%JEUS_HOME%\lib\etc\ant
set ANT_OPTS=-Djeus.log.level=fatal -Djeus.home="%JEUS_HOME%" -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" 

call "%ANT_HOME%\bin\ant" %*

ENDLOCAL
