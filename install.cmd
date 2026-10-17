@echo off
setlocal
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%PS%" goto run
where pwsh >nul 2>nul && set "PS=pwsh" && goto run
where powershell >nul 2>nul && set "PS=powershell" && goto run
echo PowerShell tidak ditemukan di komputer ini.
echo Pasang Git for Windows lalu jalankan: bash install.sh
exit /b 1
:run
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
exit /b %ERRORLEVEL%
