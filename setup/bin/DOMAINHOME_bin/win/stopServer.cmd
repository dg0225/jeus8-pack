@echo off
SETLOCAL

REM set JEUS_HOME if not specified
SET FileDir=%~dp0?
SET FileDir=%FileDir:\domains\@domain_name@\bin\?=?%
FOR /f "tokens=1,2 delims=?" %%a in ("%FileDir%") do set FileDir=%%a

IF "%JEUS_HOME%"=="" (
SET JEUS_HOME=%FileDir%
)

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

ECHO ****************************************************************************
ECHO   - Usage : stopServer -host host:port -u username -p password
ECHO ****************************************************************************

SET USER_NAME=
SET USERPASSWORD=
SET URL=
SET DEBUG=
SET VERBOSE=
SET CACHELOGIN=
SET DOMAIN=
SET FILENAME=

:BEFORE
if "%1" == "" GOTO NEXT
	if "%1" == "-host" (
		if NOT DEFINED URL (
	  	    SET URL=-host %2
	  )
	)
	if "%1" == "-u" (
		if NOT DEFINED USER_NAME (
	  	    SET USER_NAME=%2
	  )
	)
	if "%1" == "-p" (
		if NOT DEFINED USERPASSWORD (
	  	    SET USERPASSWORD=%2
	  )
	)
	if "%1" == "-debug" (
        if NOT DEFINED DEBUG (
            SET DEBUG="-debug"
      )
    )
    if "%1" == "-verbose" (
        if NOT DEFINED VERBOSE (
            SET VERBOSE="-verbose"
      )
    )
    if "%1" == "-cachelogin" (
        if NOT DEFINED CACHELOGIN (
            SET CACHELOGIN="-cachelogin"
      )
    )
    if "%1" == "-domain" (
        if NOT DEFINED DOMAIN (
            SET DOMAIN=%2
      )
    )
    if "%1" == "-f" (
        if NOT DEFINED FILENAME (
            SET FILENAME=%2
      )
    )
	SHIFT
GOTO BEFORE
:NEXT

IF NOT DEFINED USER_NAME (
	SET USER_NAME=
) ELSE (
	SET USER_NAME=-u %USER_NAME%
)

IF NOT DEFINED USERPASSWORD (
	SET USERPASSWORD=
) ELSE (
	SET USERPASSWORD=-p %USERPASSWORD%
)

IF NOT DEFINED DOMAIN (
	SET DOMAIN=
) ELSE (
	SET DOMAIN=-domain %DOMAIN%
)

IF NOT DEFINED FILENAME (
	SET FILENAME=
) ELSE (
	SET FILENAME=-f %FILENAME%
)

IF NOT DEFINED URL (
	SET URL=
)

REM set boot parameter
IF DEFINED USERNAME (
	SET BOOT_PARAMETER=-u %USERNAME% -p %PASSWORD%
) ELSE (
	SET BOOT_PARAMETER=%USER_NAME% %USERPASSWORD%
)

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
    jeus.tool.console.console.ConsoleMain local-shutdown %URL% %BOOT_PARAMETER% %DEBUG% %VERBOSE% %DOMAIN% %FILENAME% %CACHELOGIN%

ENDLOCAL