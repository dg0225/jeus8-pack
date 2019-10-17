@echo off
SETLOCAL

REM set JEUS_HOME if not specified
set FileDir=%~dp0
if "%JEUS_HOME%" == "" ^
set JEUS_HOME=%FileDir:~0,-5%

REM set JEUS properties
CALL %JEUS_HOME%\bin\jeus.properties.cmd

IF ERRORLEVEL == 3 EXIT /B

SET USER_NAME=
SET USERPASSWORD=
SET URL=
SET DEBUG=
SET VERBOSE=
SET CACHELOGIN=
SET DOMAIN=
SET FILENAME=
SET GRACEFUL=
SET SHUTDOWNTIMEOUT=

set argc=0
for %%x in (%*) do Set /A argc+=1
if %argc% == 0 (
    goto USAGE
) else (
    goto BEFORE
)
:USAGE
ECHO ****************************************************************************
ECHO   - Usage : stopServer ^<-host host:port^> ^<-u username^> ^<-p password^>
ECHO                     ^<-cachelogin^> ^<-domain domain^> ^<-f cachelogin_file^>
ECHO                     ^<-g^> ^<-to wait_time^>
ECHO                 options :
ECHO                   -host: Specify the host and port information
ECHO                         for the server you want to shut down.
ECHO                         [Default: localhost:9736]
ECHO                   -u: Specify the user identity with authority to shut down the server.
ECHO                   -p: Specify the password corresponding to -u option.
ECHO                   -cachelogin: Attempts to authenticate with the information
ECHO                               stored in the cache login file.
ECHO                               You must give -u, -domain option as key
ECHO                               to find corresponding user information.
ECHO                               You can store new cache login information
ECHO                               by giving -u, -p, -domain option with -cachelogin.
ECHO                               If you have single domain, you don't have to
ECHO                               specify -d option.
ECHO                   -domain: Specify the domain to use cachelogin.
ECHO                   -f: Set the file path to be used in cachelogin.
ECHO                     If -f option is omitted, default file path will be used.
ECHO                     [Default cachelogin file path: ~/.jeusadmin/.jeuspasswd]
ECHO                   -g: Wait for the server to finish works and then shut down.
ECHO                   -to: Even if the server is working,
ECHO                     it waits for the given time and then shut down.
ECHO                 examples :
ECHO                   stopServer -host localhost:9736 -u user -p passwd
ECHO                     -^> Basic usage of stopServer script.
ECHO                   stopServer -u user -p passwd
ECHO                     -^> You can omit -host option.
ECHO                       Default host(localhost:9736) will shut down.
ECHO                   stopServer -host localhost:9736 -u user -p passwd
ECHO                            -domain domain1 -cachelogin
ECHO                     -^> Stores user information with domain to the default cachelogin file.
ECHO                   stopServer -host localhost:9736 -u user -domain domain1
ECHO                            -cachelogin
ECHO                     -^> Attempts authentication using cachelogin information
ECHO                       instead of using -u, -p option.
ECHO                   stopServer -host localhost:9736 -u user -domain domain1
ECHO                            -cachelogin -f /home/jeus/jeusCachePW
ECHO                     -^> You can specify cachelogin file you want use.
ECHO ****************************************************************************
GOTO:EOF

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
    if "%1" == "-g" (
        if NOT DEFINED GRACEFUL (
            SET GRACEFUL="-g"
        )
    )
    if "%1" == "-to" (
        if NOT DEFINED SHUTDOWNTIMEOUT (
            SET SHUTDOWNTIMEOUT=%2
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

REM set target
SET TARGET="local-shutdown %GRACEFUL%

IF DEFINED SHUTDOWNTIMEOUT (
    SET TARGET=%TARGET% -to %SHUTDOWNTIMEOUT%
)

REM execute jeusadmin
"%JAVA_HOME%\bin\java" -classpath "%BOOTSTRAP_CLASSPATH%" %TOOL_OPTION% ^
    -Djeus.home="%JEUS_HOME%" ^
    -Djava.library.path="%JEUS_LIBPATH%" ^
    -Djava.endorsed.dirs="%JEUS_HOME%\lib\endorsed" ^
    -Djava.naming.factory.initial=jeus.jndi.JNSContextFactory ^
    -Djava.naming.factory.url.pkgs=jeus.jndi.jns.url ^
    -Djava.util.logging.config.file="%JEUS_HOME%\bin\logging.properties" ^
    %JAVA_ARGS% ^
    %BOOTSTRAPPER% ^
    jeus.tool.console.console.ConsoleMain %TARGET%" %URL% %BOOT_PARAMETER% %DEBUG% %VERBOSE%

ENDLOCAL