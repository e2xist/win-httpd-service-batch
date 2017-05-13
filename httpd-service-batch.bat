@echo off
setlocal
REM ====================================
REM ȯ�漳�� �κ�
REM ====================================
set SERVICE_NAME=httpd-2.4.25


REM ====================================
REM ���� ����
REM ====================================
REM â ���� �� ũ�� ����
mode con cols=60 lines=20
COLOR 3F


REM ���� ��η� �̵�
PUSHD "%~DP0"


REM ====================================
REM ��� ����
REM ====================================
REM httpd.exe �� ��θ� ã��
set CURPATH=%~DP0
set APPPATH=%CURPATH%





:SELECTION
cls
echo ==========================================
echo �� Apache Web Server Service Add/Remover ��
echo                    Author : Hong seok-hoon
echo                    version : 1.0.0
echo ==========================================
echo (�����׸�)
echo   0. ����
echo   1. ����ġ �ý��ۼ��� ���
echo   2. ����ġ �ý��ۼ��� �������
echo   3. ����ġ �ý��ۼ��� ��Ͽ��� Ȯ��
echo   4. ����ġ �ý��ۼ��� ����
echo   5. ����ġ �ý��ۼ��� ����
echo.
set CHOICE=
CALL NET SESSION >nul 2>&1
IF NOT %ERRORLEVEL% == 0 (
    echo �����ڱ����� �ʿ� �մϴ�. �����ڸ�� �� ��������ּ���.
    goto EXITPROG
)
set /p CHOICE=�۾��� ��ȣ�� �Է����ּ��� :


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
REM ���� ��� Ȯ��
REM ==========================================
:CHECK
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	echo ����ġ �������� ��ġ�Ǿ� �ֽ��ϴ�.
	timeout /t 60
	goto SELECTION
) else (
	echo ����ġ �������� ���� ��ġ���� �ʾҽ��ϴ�.
	timeout /t 60
	goto SELECTION
)





REM ==========================================
REM ���� ���
REM ==========================================
:INSTALL

REM ��ġ ���� Ȯ��
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	echo ����ġ �������� �̹� ��ϵǾ��ֽ��ϴ�.
	timeout /t 60
	goto SELECTION
)


REM ��ġ ����
"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k install
if "%ERRORLEVEL%"=="0" (
	CLS
	echo ======================================
	echo ����ġ �������� �ý��� ���񽺿� '���' �ǿ����ϴ�.
	echo ======================================

) else (
	echo ======================================
	echo ����ġ ������ ��� ���� �߿� ������ �߻��Ͽ����ϴ�.
	echo ======================================

)
timeout /t 60
goto SELECTION





REM ==========================================
REM ���� ��� ����
REM ==========================================
:REMOVE
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k stop
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k uninstall
	if "%ERRORLEVEL%"=="0" (
		cls
		echo ======================================
		echo ����ġ �������� �ý��� ���񽺿��� '�������' �ǿ����ϴ�.
		echo ======================================

	) else (
		cls
		echo ======================================
		echo ����ġ ������ ������� ���� �߿� ������ �߻��Ͽ����ϴ�.
		echo ======================================

	)
) else (
	echo ����ġ �������� �̹� ���� ��ϵǾ����� �ʽ��ϴ�.
)
timeout /t 60
goto SELECTION





REM ==========================================
REM ���� ����
REM ==========================================
:SERVICE_START
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k start
	echo ����ġ �������� �����մϴ�.

) else (
	echo ����ġ �������� �̹� ���� ��ϵǾ����� �ʽ��ϴ�.

)
timeout /t 60
goto SELECTION





REM ==========================================
REM ���� ����
REM ==========================================
:SERVICE_STOP
sc query "%SERVICE_NAME%" >nul
if "%ERRORLEVEL%" == "0" (
	"%APPPATH%\bin\httpd" -n "%SERVICE_NAME%" -k stop
	echo ����ġ �������� �����մϴ�.

) else (
	echo ����ġ �������� �̹� ���� ��ϵǾ����� �ʽ��ϴ�.

)
timeout /t 60
goto SELECTION





:EXITPROG
timeout /t 60