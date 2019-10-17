@echo off
SETLOCAL

REM set JEUS_HOME if not specified
SET FileDir=%~dp0?
SET FileDir=%FileDir:\domains\@domain_name@\servers\@server_name@\bin\?=?%
FOR /f "tokens=1,2 delims=?" %%a in ("%FileDir%") do set FileDir=%%a

IF "%JEUS_HOME%"=="" (
SET JEUS_HOME=%FileDir%
)

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

REM set server-specific properties
IF EXIST "%JEUS_HOME%\bin\@server_name@.properties.cmd" (
    CALL %JEUS_HOME%\bin\@server_name@.properties.cmd
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
jeus.server.ManagedServerLauncherBootstrapper %BOOT_PARAMETER% -domain @domain_name@ -server @server_name@
@echo off

ENDLOCAL
