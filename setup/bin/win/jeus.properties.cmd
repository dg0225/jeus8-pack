@echo off
rem  **************************************************************************
rem  *  This is a script for a JEUS environment.                              *
rem  *  This uses the following environment variables.                        *
rem  *                                                                        *
rem  *  JEUS_HOME       - The root directory of JEUS installed.               *
rem  *  JEUS_LIBPATH    - The navtive library for JEUS.                       *
rem  *  JEUS_LANG       - The language for JEUS.                              *
rem  *  VM_TYPE         - The JAVA which JEUS uses to boot.                   *
rem  *                    Avaiable values are 'hotspot' and 'old'.            *
rem  *                                                                        *
rem  *  USERNAME        - Administrator name                                  *
rem  *  PASSWORD        - Administrator password                              *
rem  *                                                                        *
rem  *  JAVA_HOME       - Java Home directory.                                *
rem  *  JAVA_ARGS       - JVM Parameter(s).                                   *
rem  *  JAVA_VENDOR     - JVM Vender name.                                    *
rem  *  LAUNCHER_MEM    - JVM memory argument                                 *
rem  *  TOOL_CLASSPATH  - classpath for console tool.                         *
rem  *  SESSION_VERSION - Network protocol for JEUS Session Server.           *
rem  *                    Available values are 'SOCKET' or 'RMI'              *
rem  *                                                                        *
rem  *  You must set the following variables;                                 *
rem  *      JEUS_HOME, VM_TYPE, JAVA_HOME, JAVA_VENDOR                        *
rem  *                                                                        *
rem  *  For additional information, please refer to the JEUS Server Guide or  *
rem  *  visit the following web sites.                                        *
rem  *                                                                        *
rem  *   - http://www.tmaxsoft.com(English)                                   *
rem  *   - http://www.tmax.co.kr(Korean)                                      *
rem  *   - http://www.tmaxchina.com.cn(Chinese)                               *
rem  *   - http://www.tmaxsoft.co.jp(Japanese)                                *
rem  *   - http://technet.tmaxsoft.com(English/Korean)                        *
rem  **************************************************************************

rem
rem For customizing JEUS environment.
rem

rem set up JEUS_LIBPATH
SET JEUS_LIBPATH=%JEUS_HOME%\lib\system

rem Select language for JEUS. Available value can be ko, en, zh and ja.
SET JEUS_LANG=@SW_LANG@

rem set up LAUNCHER_MEM
SET LAUNCHER_MEM=-Xmx256m

rem set up JAVA_HOME
SET JAVA_HOME=@JDKDir@
SET JDK_HOME=%JAVA_HOME%

rem setup JAVA_ARGS.
SET JAVA_ARGS=

rem set up JDK vendor. Possible values are Sun, HP, IBM, etc. Default, Sun.
SET JAVA_VENDOR=Sun


rem
rem This part is for booting JEUS automatically.
rem BE CAREFUL!! THIS IS ONLY FOR TEST AND DEVELOPMENT ENVIRONMENT.
rem

rem Set up administrator name
SET USERNAME=

rem Set up administrator password
SET PASSWORD=


rem **************************************************************************
rem  This part is for JEUS System environment.
rem  DO NOT MODIFY except a JEUS expert!!
rem **************************************************************************

rem
rem For Console tool.
rem
SET BOOTSTRAP_CLASSPATH=%JEUS_HOME%\lib\system\bootstrap.jar
SET BOOTSTRAPPER=jeus.server.Bootstrapper
SET TOOL_OPTION=-Djeus.tm.not_use=true -Djava.net.preferIPv4Stack=true -Djeus.tool.console.patchinfo=false -Djeus.boot.ignorepatchoverlap=true

rem
rem For Java applications' compatibility
rem
SET TOOL_CLASSPATH=%JEUS_HOME%\lib\client\clientcontainer.jar;%JEUS_HOME%\lib\client\jclient.jar;%JEUS_HOME%\lib\client\jclient_jaxb.jar;%JEUS_HOME%\lib\system\mail.jar;%JEUS_HOME%\lib\system\javaee.jar;%JEUS_HOME%\lib\system\jms.jar;%JEUS_HOME%\lib\system\jeus-ws.jar;%JEUS_HOME%\lib\system\wsdl4j.jar;%JEUS_HOME%\lib\system\jmxremote.jar;%JEUS_HOME%\lib\system\commons-cli.jar;%JEUS_HOME%\lib\system\jaxb2-basics-runtime.jar

rem If VM_TYPE is not set, determine it.
IF "%JAVA_VENDOR%" == "Sun" (
	SET VM_TYPE=hotspot
	SET VM_OPTION=-server
) else (
	SET VM_TYPE=old
	SET VM_OPTION=-Djeus.dispatcher.blocking=true 
)

rem Check significant variables.

IF NOT DEFINED JEUS_HOME (
	ECHO JEUS_HOME is not defined.
	EXIT \B 3
)

IF NOT DEFINED JAVA_HOME (
	ECHO JAVA_HOME is not defined.
	EXIT \B 3
)


TITLE TmaxSoft JEUS 8
