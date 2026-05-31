@echo off
setlocal
chcp 65001 >nul

cd /d "%~dp0.."

echo.
echo Hermes Easy Installer
echo.
echo Este instalador vai abrir o PowerShell e usar o instalador oficial
echo mais recente do Hermes Agent da Nous Research.
echo.
echo Nenhuma credencial fica salva neste projeto.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-hermes-easy.ps1"

echo.
echo Se a janela mostrar que o Hermes foi instalado, abra um novo terminal
echo e rode: hermes
echo.
pause
