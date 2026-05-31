@echo off
setlocal
chcp 65001 >nul
cd /d "%~dp0"

:menu
cls
echo.
echo Hermes Easy Installer - Documentacao
echo.
echo Escolha o guia para abrir no Bloco de Notas:
echo.
echo 1 - Guia Windows
echo 2 - Guia macOS
echo 3 - Guia Linux / WSL2 / Termux
echo 4 - Guia Telegram
echo 5 - Checklist de instalacao
echo 6 - Solucao de problemas
echo 0 - Sair
echo.
set /p opcao="Digite o numero e pressione Enter: "

if "%opcao%"=="1" start "" notepad "%~dp0GUIA_WINDOWS.md" & goto menu
if "%opcao%"=="2" start "" notepad "%~dp0GUIA_MACOS.md" & goto menu
if "%opcao%"=="3" start "" notepad "%~dp0GUIA_LINUX.md" & goto menu
if "%opcao%"=="4" start "" notepad "%~dp0GUIA_TELEGRAM.md" & goto menu
if "%opcao%"=="5" start "" notepad "%~dp0CHECKLIST_INSTALACAO.md" & goto menu
if "%opcao%"=="6" start "" notepad "%~dp0SOLUCAO_DE_PROBLEMAS.md" & goto menu
if "%opcao%"=="0" exit /b 0

echo.
echo Opcao invalida.
pause
goto menu
