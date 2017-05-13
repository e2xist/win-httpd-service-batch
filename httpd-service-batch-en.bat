@echo off
setlocal
REM ====================================
REM configuration
REM ====================================
set SERVICE_NAME=httpd-2.4.25

REM ====================================
REM messages
REM ====================================
set message_already_installed="already installed."
set message_not_installed="not installed yet."
set message_error="error occured."
set message_error_install="error occurred."



REM ====================================
REM starting sentences
REM ====================================
REM sets color with windows
mode con cols=60 lines=20
COLOR 3F
REM current path
PUSHD "%~DP0"


REM ====================================
REM httpd.exe path
REM ====================================
set CURPATH=%~DP0
set APPPATH=%CURPATH%





:SELECTION
cls
echo ==========================================
echo ★ Apache Web Server Service Add/Remover ★
echo                    Author : Hong seok-hoon
echo                    version : 1.0.0
echo ==========================================
echo (selection)
echo   0. exit
echo   1. apache service install
echo   2. apache service uninstall
echo   3. apache service check
echo   4. apache service start
echo   5. apache service stop
echo.
set CHOICE=
CALL NET SESSION >nul 2>&1
IF NOT %ERRORLEVEL% == 0 (
    echo Administrative permissions required.
    goto EXITPROG
)
set /p CHOICE=Choices number :


if "%CHOICE%" == "" goto :SELECTION

if %CHOICE% == 0 (
    goto EXITPROG
)

if %CHOICE% == 1 (
    goto INSTALL
)

if %CHOICE% == 2 (
    goto REMOVE
)

if %CHOICE% == 3 (
    goto CHECK
)

if %CHOICE% == 4 (
    goto SERVICE_START
)

if %CHOICE% == 5 (
    goto SERVICE_STOP
)




REM ==========================================
REM checking installed
REM ==========================================
:CHECK
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	echo "%message_already_installed%"
	timeout /t 60
	goto SELECTION
) else (
	echo "%message_not_installed%"
	timeout /t 60
	goto SELECTION
)





REM ==========================================
REM installing as a Windows service
REM ==========================================
:INSTALL

REM 설치 여부 확인
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	echo "%message_already_installed%"
	timeout /t 60
	goto SELECTION
)


REM 설치 진행
"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k install
if "%ERRORLEVEL%"=="0" (
	cls
	echo ======================================
	echo installed successfully
	echo ======================================

) else (
	echo ======================================
	echo "%message_error%"
	echo ======================================

)
timeout /t 60
goto SELECTION





REM ==========================================
REM uninstalling as a Windows service
REM ==========================================
:REMOVE
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k stop
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k uninstall
	if "%ERRORLEVEL%"=="0" (
		cls
		echo ======================================
		echo uninstalled successfully.
		echo ======================================

	) else (
		cls
		echo ======================================
		echo "%message_error%"
		echo ======================================

	)
) else (
	echo "%message_not_installed%"
)
timeout /t 60
goto SELECTION





REM ==========================================
REM running as a Windows service
REM ==========================================
:SERVICE_START
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k start
	echo starting apache service.

) else (
	echo "%message_not_installed%"

)
timeout /t 60
goto SELECTION





REM ==========================================
REM stopping as a Windows service
REM ==========================================
:SERVICE_STOP
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k stop
	echo stopping apache service.

) else (
	echo "%message_not_installed%"

)
timeout /t 60
goto SELECTION





:EXITPROG
timeout /t 60