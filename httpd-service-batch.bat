@echo off
setlocal
REM ====================================
REM 환경설정 부분
REM ====================================
set SERVICE_NAME=httpd-2.4.25


REM ====================================
REM 구문 시작
REM ====================================
REM 창 색상 및 크기 지정
mode con cols=60 lines=20
COLOR 3F


REM 현재 경로로 이동
PUSHD "%~DP0"


REM ====================================
REM 경로 설정
REM ====================================
REM httpd.exe 의 경로를 찾기
set CURPATH=%~DP0
set APPPATH=%CURPATH%





:SELECTION
cls
echo ==========================================
echo ★ Apache Web Server Service Add/Remover ★
echo                    Author : Hong seok-hoon
echo                    version : 1.0.0
echo ==========================================
echo (선택항목)
echo   0. 종료
echo   1. 아파치 시스템서비스 등록
echo   2. 아파치 시스템서비스 등록해제
echo   3. 아파치 시스템서비스 등록여부 확인
echo   4. 아파치 시스템서비스 시작
echo   5. 아파치 시스템서비스 종료
echo.
set CHOICE=
CALL NET SESSION >nul 2>&1
IF NOT %ERRORLEVEL% == 0 (
    echo 관리자권한이 필요 합니다. 관리자모드 로 재시작해주세요.
    goto EXITPROG
)
set /p CHOICE=작업할 번호를 입력해주세요 :


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
REM 서비스 등록 확인
REM ==========================================
:CHECK
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	echo 아파치 웹서버가 설치되어 있습니다.
	timeout /t 60
	goto SELECTION
) else (
	echo 아파치 웹서버가 아직 설치되지 않았습니다.
	timeout /t 60
	goto SELECTION
)





REM ==========================================
REM 서비스 등록
REM ==========================================
:INSTALL

REM 설치 여부 확인
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	echo 아파치 웹서버가 이미 등록되어있습니다.
	timeout /t 60
	goto SELECTION
)


REM 설치 진행
"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k install
if "%ERRORLEVEL%"=="0" (
	CLS
	echo ======================================
	echo 아파치 웹서버가 시스템 서비스에 '등록' 되였습니다.
	echo ======================================

) else (
	echo ======================================
	echo 아파치 웹서버 등록 과정 중에 오류가 발생하였습니다.
	echo ======================================

)
timeout /t 60
goto SELECTION





REM ==========================================
REM 서비스 등록 해제
REM ==========================================
:REMOVE
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k stop
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k uninstall
	if "%ERRORLEVEL%"=="0" (
		cls
		echo ======================================
		echo 아파치 웹서버가 시스템 서비스에서 '등록해제' 되였습니다.
		echo ======================================

	) else (
		cls
		echo ======================================
		echo 아파치 웹서버 등록해제 과정 중에 오류가 발생하였습니다.
		echo ======================================

	)
) else (
	echo 아파치 웹서버가 이미 서비스 등록되어있지 않습니다.
)
timeout /t 60
goto SELECTION





REM ==========================================
REM 서비스 시작
REM ==========================================
:SERVICE_START
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k start
	echo 아파치 웹서버를 시작합니다.

) else (
	echo 아파치 웹서버가 이미 서비스 등록되어있지 않습니다.

)
timeout /t 60
goto SELECTION





REM ==========================================
REM 서비스 종료
REM ==========================================
:SERVICE_STOP
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k stop
	echo 아파치 웹서버를 종료합니다.

) else (
	echo 아파치 웹서버가 이미 서비스 등록되어있지 않습니다.

)
timeout /t 60
goto SELECTION





:EXITPROG
timeout /t 60