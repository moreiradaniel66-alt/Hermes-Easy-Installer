@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Hermes Agent (Nous Research) • Easy Installer por Moreira Labs

cd /d "%~dp0"

:menu
cls
echo.
echo  ====================================================================
echo    HERMES AGENT • NOUS RESEARCH (2026)
echo    Assistente autônomo com criação dinâmica de ferramentas e memória
echo  ====================================================================
echo    Hermes Easy Installer • Desenvolvido por Daniel Moreira (Moreira Labs)
echo  ====================================================================
echo.
echo    [1] Instalação Padrão do Hermes Agent (CLI + Gateways)
echo    [2] Instalar Hermes Agent + Hermes Desktop (com App Gráfico)
echo    [3] Iniciar Hermes Web Dashboard (hermes dashboard - Painel Web)
echo    [4] Abrir Painel Portátil Executável (Hermes Easy Installer.exe)
echo    [5] Abrir Guia Visual no Navegador (COMECE_AQUI.html)
echo    [6] Configurar Provedor e Chaves (hermes setup)
echo    [7] Diagnóstico do Ambiente (hermes doctor)
echo    [8] Configurar Telegram (hermes gateway setup)
echo    [0] Sair
echo.
echo  ====================================================================
set /p opt="Escolha uma opção [1-8 ou 0] (Pressione Enter para 1): "

if "%opt%"=="" set opt=1
if "%opt%"=="1" goto install_std
if "%opt%"=="2" goto install_desktop
if "%opt%"=="3" goto run_dashboard
if "%opt%"=="4" goto open_exe
if "%opt%"=="5" goto open_browser
if "%opt%"=="6" goto run_setup
if "%opt%"=="7" goto run_doctor
if "%opt%"=="8" goto run_gateway
if "%opt%"=="0" goto end

echo.
echo Opção inválida. Tente novamente.
timeout /t 2 >nul
goto menu

:install_std
cls
echo.
echo ==> Iniciando Instalação Padrão do Hermes Agent (Nous Research)...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_motor\install-hermes-easy.ps1"
echo.
pause
goto menu

:install_desktop
cls
echo.
echo ==> Iniciando Instalação do Hermes Agent + Hermes Desktop...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_motor\install-hermes-easy.ps1" -IncludeDesktop
echo.
pause
goto menu

:run_dashboard
cls
echo.
echo ==> Iniciando Hermes Web Dashboard em http://127.0.0.1:9119...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_motor\install-hermes-easy.ps1" -StartDashboard
echo.
pause
goto menu

:open_exe
echo.
echo ==> Abrindo Painel Portátil...
if exist "%~dp0Hermes Easy Installer.exe" (
    start "" "%~dp0Hermes Easy Installer.exe"
) else (
    start "" "%~dp0COMECE_AQUI.html"
)
goto menu

:open_browser
echo.
echo ==> Abrindo guia visual no navegador padrão...
start "" "%~dp0COMECE_AQUI.html"
goto menu

:run_setup
cls
echo.
echo ==> Abrindo assistente de configuração de chaves (hermes setup)...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_motor\install-hermes-easy.ps1" -SkipInstall
echo.
pause
goto menu

:run_doctor
cls
echo.
echo ==> Executando diagnóstico de saúde do Hermes Agent (hermes doctor)...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_motor\install-hermes-easy.ps1" -SkipInstall -SkipModelSetup
echo.
pause
goto menu

:run_gateway
cls
echo.
echo ==> Configurando Gateway do Telegram (hermes gateway setup)...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_motor\install-hermes-easy.ps1" -SkipInstall -SkipModelSetup -SkipDoctor
echo.
pause
goto menu

:end
echo.
echo Até logo!
exit /b 0
