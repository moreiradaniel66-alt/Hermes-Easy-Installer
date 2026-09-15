param(
    [switch]$SkipInstall,
    [switch]$SkipModelSetup,
    [switch]$SkipGatewaySetup,
    [switch]$SkipDoctor,
    [switch]$StartDashboard,
    [switch]$UseWsl,
    [switch]$IncludeDesktop,
    [switch]$NonInteractive
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

try {
    $Host.UI.RawUI.WindowTitle = "Hermes Agent (Nous Research) • Easy Installer"
    chcp 65001 >$null 2>&1
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    # Some PowerShell hosts do not allow console encoding changes.
}

$OfficialWindowsInstaller = "https://hermes-agent.nousresearch.com/install.ps1"
$FallbackWindowsInstaller = "https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1"
$OfficialPosixInstaller = "https://hermes-agent.nousresearch.com/install.sh"
$FallbackPosixInstaller = "https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh"

$PackageRoot = if ((Split-Path -Leaf $PSScriptRoot) -eq "_motor") {
    Split-Path -Parent $PSScriptRoot
} else {
    $PSScriptRoot
}
$DocsDir = Join-Path $PackageRoot "Documentacao"

function Write-Header {
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Magenta
    Write-Host "         HERMES AGENT • NOUS RESEARCH (2026)              " -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor Magenta
    Write-Host "Assistente autônomo com criação dinâmica de ferramentas e memória." -ForegroundColor White
    Write-Host "Hermes Easy Installer • Desenvolvido por Daniel Moreira (Moreira Labs)" -ForegroundColor DarkCyan
    Write-Host "Nenhuma credencial fica salva neste pacote de scripts." -ForegroundColor DarkGray
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Confirm-Continue {
    param([string]$Question)
    if ($NonInteractive) { return $true }
    $answer = Read-Host "$Question [S/n]"
    return ($answer -eq "" -or $answer -match "^[sSyY]")
}

function Sync-Path {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $env:Path = "$userPath;$machinePath;$env:Path"
}

function Resolve-HermesCommand {
    Sync-Path

    $cmd = Get-Command hermes -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $candidates = @(
        "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\hermes.exe",
        "$env:LOCALAPPDATA\hermes\hermes-agent\.venv\Scripts\hermes.exe",
        "$env:USERPROFILE\.local\bin\hermes.exe",
        "$env:USERPROFILE\.local\bin\hermes",
        "$env:LOCALAPPDATA\Programs\hermes\hermes.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) { return $candidate }
    }

    return $null
}

function Download-OfficialScript {
    param([string]$PrimaryUrl, [string]$FallbackUrl, [string]$OutFile)
    
    try {
        Invoke-WebRequest -UseBasicParsing -Uri $PrimaryUrl -OutFile $OutFile
        Write-Ok "Baixado com sucesso de: $PrimaryUrl"
    } catch {
        Write-Warn "Falha ao baixar do domínio principal. Tentando repositório GitHub de backup..."
        Invoke-WebRequest -UseBasicParsing -Uri $FallbackUrl -OutFile $OutFile
        Write-Ok "Baixado com sucesso do GitHub de backup."
    }
}

function Invoke-WindowsInstall {
    Write-Step "Baixando instalador oficial mais recente do Hermes Agent (Nous Research)"

    $cacheDir = Join-Path $env:TEMP "HermesEasyInstaller"
    New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null

    $installerPath = Join-Path $cacheDir "official-install.ps1"
    Download-OfficialScript -PrimaryUrl $OfficialWindowsInstaller -FallbackUrl $FallbackWindowsInstaller -OutFile $installerPath

    Write-Step "Executando instalador oficial"

    $extraArgs = @()
    if ($IncludeDesktop) {
        $extraArgs += "-IncludeDesktop"
        Write-Host "-> Modo Hermes Desktop ativado (compilando aplicativo gráfico)." -ForegroundColor Magenta
    }
    if ($NonInteractive) {
        $extraArgs += "-NonInteractive"
    }

    & powershell -NoProfile -ExecutionPolicy Bypass -File $installerPath @extraArgs
    Write-Ok "Instalação do Hermes concluída com sucesso."
}

function Invoke-WslInstall {
    $wsl = Get-Command wsl -ErrorAction SilentlyContinue
    if (-not $wsl) {
        throw "WSL não foi encontrado. Instale WSL2 ou rode sem -UseWsl para usar o instalador nativo Windows."
    }

    Write-Step "Executando instalador oficial dentro do WSL (Linux)"
    & wsl bash -lc "curl -fsSL '$OfficialPosixInstaller' | bash"
    Write-Ok "Instalação no WSL concluída."
}

function Invoke-HermesSetup {
    $hermes = Resolve-HermesCommand
    if (-not $hermes) {
        Write-Warn "Não encontrei o comando hermes nesta janela ainda."
        Write-Warn "Abra um novo terminal PowerShell e rode: hermes setup"
        return
    }

    if (-not (Confirm-Continue "Deseja abrir agora o assistente oficial de configuração (hermes setup)?")) {
        Write-Warn "Sem problemas. Quando quiser configurar, abra o terminal e rode: hermes setup"
        return
    }

    Write-Step "Abrindo assistente oficial interativo (hermes setup)"
    try {
        & $hermes setup
    } catch {
        Write-Warn "Tentando comando alternativo de modelos (hermes model)..."
        & $hermes model
    }
}

function Invoke-HermesDoctor {
    $hermes = Resolve-HermesCommand
    if (-not $hermes) {
        Write-Warn "Não encontrei o comando hermes para rodar diagnóstico. Abra um novo terminal e rode: hermes doctor"
        return
    }

    Write-Step "Rodando diagnóstico de saúde do Hermes (hermes doctor)"
    & $hermes doctor
}

function Invoke-HermesDashboard {
    $hermes = Resolve-HermesCommand
    if (-not $hermes) {
        Write-Warn "Não encontrei o comando hermes. Abra um novo terminal e rode: hermes dashboard"
        return
    }

    Write-Step "Iniciando Hermes Web Dashboard em http://127.0.0.1:9119"
    Write-Host "O painel de controle web permite gerenciar sessões, memórias, personas, skills e chats." -ForegroundColor Cyan
    Write-Host "Pressione Ctrl+C para encerrar o servidor do dashboard quando desejar." -ForegroundColor Gray
    
    # Inicia o navegador após um breve delay
    Start-Job -ScriptBlock {
        Start-Sleep -Seconds 2
        Start-Process "http://127.0.0.1:9119"
    } | Out-Null

    & $hermes dashboard
}

function Invoke-HermesGatewaySetup {
    $hermes = Resolve-HermesCommand
    if (-not $hermes) {
        Write-Warn "Não encontrei o comando hermes nesta janela. Abra um novo terminal e rode: hermes gateway setup"
        return
    }

    $guidePath = Join-Path $DocsDir "GUIA_COMPLETO_HERMES_E_TELEGRAM.md"
    if (Test-Path $guidePath) {
        Write-Host ""
        Write-Host "Antes de configurar o Telegram, crie seu bot pelo @BotFather e pegue seu ID." -ForegroundColor Yellow
        if (Confirm-Continue "Deseja abrir o guia do Telegram agora?") {
            Start-Process $guidePath
        }
    }

    if (-not (Confirm-Continue "Você já possui o token do BotFather e o seu ID numérico do Telegram?")) {
        Write-Warn "Sem problemas. Quando estiver pronto, rode no terminal: hermes gateway setup"
        return
    }

    Write-Step "Abrindo assistente do Gateway Multicanal (Telegram, Discord, etc.)"
    & $hermes gateway setup

    if (Confirm-Continue "Deseja iniciar o serviço do Gateway agora?") {
        Write-Step "Iniciando gateway"
        try {
            & $hermes gateway start
            Write-Ok "Gateway iniciado com sucesso!"
        } catch {
            Write-Warn "Se 'gateway start' não funcionar em segundo plano neste sistema, rode: hermes gateway run"
        }
    }
}

# --- EXECUÇÃO PRINCIPAL ---
Write-Header

if ($StartDashboard) {
    Invoke-HermesDashboard
    exit 0
}

if (-not $SkipInstall) {
    if (-not (Confirm-Continue "Deseja prosseguir com o download e instalação oficial do Hermes Agent?")) {
        Write-Warn "Instalação cancelada pelo usuário."
        exit 0
    }

    if ($UseWsl) {
        Invoke-WslInstall
    } else {
        Invoke-WindowsInstall
    }
}

Sync-Path

if (-not $SkipModelSetup -and -not $NonInteractive) {
    Invoke-HermesSetup
}

if (-not $SkipDoctor) {
    Invoke-HermesDoctor
}

if (-not $SkipGatewaySetup -and -not $NonInteractive) {
    Invoke-HermesGatewaySetup
}

Write-Step "Tudo pronto!"
Write-Host "Para conversar com o Hermes a qualquer momento no terminal:" -ForegroundColor Gray
Write-Host "  hermes" -ForegroundColor Green
Write-Host ""
Write-Host "Para abrir o Hermes Web Dashboard (painel visual no navegador):" -ForegroundColor Gray
Write-Host "  hermes dashboard" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para alterar configurações, modelos ou chaves de API:" -ForegroundColor Gray
Write-Host "  hermes setup" -ForegroundColor Green
Write-Host ""
Write-Host "Para gerenciar os Gateways (Telegram / Discord):" -ForegroundColor Gray
Write-Host "  hermes gateway status" -ForegroundColor Green
Write-Host "  hermes gateway start" -ForegroundColor Green
Write-Host ""
