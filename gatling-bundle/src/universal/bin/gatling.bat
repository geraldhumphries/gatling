@ECHO OFF
@REM
@REM Copyright 2011-2022 GatlingCorp (http://gatling.io)
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM 		http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM

setlocal

set USER_ARGS=%*

rem set GATLING_HOME automatically if possible
set "OLD_DIR=%cd%"
cd ..
set "DEFAULT_GATLING_HOME=%cd%"
cd %OLD_DIR%

rem if gatling home is correctly set
if exist "%GATLING_HOME%\bin\gatling.bat" goto gotHome
rem if gatling home is not correctly set
if not "%GATLING_HOME%" == "" goto badHome
rem if not try current folder
if exist "%OLD_DIR%\bin\gatling.bat" set "GATLING_HOME=%OLD_DIR%" && goto gotHome
rem if not try parent folder
if exist "%DEFAULT_GATLING_HOME%\bin\gatling.bat" set "GATLING_HOME=%DEFAULT_GATLING_HOME%" && goto gotHome
rem else tell user to set GATLING_HOME
goto :noHome

:gotHome

echo GATLING_HOME is set to "%GATLING_HOME%"

set JAVA_OPTS=%JAVA_OPTS%

set CLASSPATH="%GATLING_HOME%"\lib\*

set JAVA=java
if exist "%JAVA_HOME%\bin\java.exe" goto setJavaHome
goto run

:setJavaHome
set JAVA="%JAVA_HOME%\bin\java.exe"

:run
echo JAVA = "%JAVA%"
%JAVA% %JAVA_OPTS% -cp %CLASSPATH% io.gatling.bundle.GatlingCLI %USER_ARGS%

goto exit

:badHome
echo The GATLING_HOME environment variable points to the wrong directory.
echo Please set it to the correct folder and try to launch Gatling again.
goto exit

:noHome
echo GATLING_HOME environment variable is not set and could not be guessed automatically.
echo Please set GATLING_HOME and try to launch Gatling again.
goto exit

:exit
if not defined NO_PAUSE pause
endlocal
exit /b 0
