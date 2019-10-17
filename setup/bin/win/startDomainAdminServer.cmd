@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

REM extract the server name from arguments
:loop
IF NOT "%1"=="" (
    IF "%1" == "-server" (
    SET SERVER_NAME=%2
    SHIFT
    )
    SHIFT
    GOTO :loop
)

REM set server-specific properties
IF EXIST "%JEUS_HOME%\bin\%SERVER_NAME%.properties.cmd" (
    CALL %JEUS_HOME%\bin\%SERVER_NAME%.properties.cmd
)

IF ERRORLEVEL == 3 EXIT /B

ECHO **************************************************************
ECHO   - JEUS Home         : %JEUS_HOME%
ECHO   - Added Java Option : %JAVA_ARGS%
ECHO   - Java Vendor       : %JAVA_VENDOR%
ECHO **************************************************************


IF DEFINED USERNAME (
	SET BOOT_PARAMETER=-u %USERNAME% -p %PASSWORD% %*
) ELSE (
	SET BOOT_PARAMETER=%*
)

REM execute jeus with echo
@echo on
"%JAVA_HOME%\bin\java" %VM_OPTION% %LAUNCHER_MEM% ^
-Xbootclasspath/p:"%JEUS_HOME%\lib\system\extension.jar" ^
-classpath "%BOOTSTRAP_CLASSPATH%" ^
-Dsun.rmi.dgc.client.gcInterval=3600000 ^
-Dsun.rmi.dgc.server.gcInterval=3600000 ^
-Djeus.jvm.version=%VM_TYPE% ^
-Djeus.home="%JEUS_HOME%" ^
-Djava.naming.factory.initial=jeus.jndi.JNSContextFactory ^
-Djava.naming.factory.url.pkgs=jeus.jndi.jns.url ^
-Djava.library.path="%JEUS_LIBPATH%" ^
-Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
-Djava.util.logging.manager=jeus.util.logging.JeusLogManager ^
-Djava.util.logging.config.file="%JEUS_HOME%\bin\logging.properties" ^
-Djeus.properties.replicate=jeus,java.util.logging,sun.rmi.dgc,java.net ^
-Djava.net.preferIPv4Stack=true ^
%JAVA_ARGS% ^
jeus.server.LauncherBootstrapper %BOOT_PARAMETER%
@echo off

ENDLOCAL
