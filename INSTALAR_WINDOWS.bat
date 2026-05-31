@echo off
setlocal
chcp 65001 >nul

cd /d "%~dp0"

echo.
echo Hermes Easy Installer
echo.
echo Abrindo assistente Windows nativo...
echo.
start "" mshta.exe "%~dp0_motor\windows-assistente.hta"
