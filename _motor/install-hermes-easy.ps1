param(
    [switch]$SkipInstall,
    [switch]$SkipModelSetup,
    [switch]$SkipGatewaySetup,
    [switch]$SkipDoctor,
    [switch]$UseWsl,
    [switch]$NonInteractive
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

try {
    $script:Utf8Encoding = [System.Text.UTF8Encoding]::new($false)
    [Console]::InputEncoding = $script:Utf8Encoding
    [Console]::OutputEncoding = $script:Utf8Encoding
    $OutputEncoding = $script:Utf8Encoding
} catch {
    # Some PowerShell hosts do not allow console encoding changes.
}

$OfficialWindowsInstaller = "https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1"
$OfficialPosixInstaller = "https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh"
$PackageRoot = if ((Split-Path -Leaf $PSScriptRoot) -eq "_motor") {
    Split-Path -Parent $PSScriptRoot
} else {
    $PSScriptRoot
}
$DocsDir = Join-Path $PackageRoot "Documentacao"

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
        "$env:USERPROFILE\.local\bin\hermes"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) { return $candidate }
    }

    return $null
}

function Invoke-WindowsInstall {
    Write-Step "Baixando instalador oficial mais recente do Hermes Agent"

    $cacheDir = Join-Path $PSScriptRoot ".cache"
    New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null

    $installerPath = Join-Path $cacheDir "official-install.ps1"
    Invoke-WebRequest -UseBasicParsing -Uri $OfficialWindowsInstaller -OutFile $installerPath

    Write-Ok "Instalador oficial baixado em $installerPath"
    Write-Step "Executando instalador oficial"

    if ($NonInteractive) {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $installerPath -NonInteractive
    } else {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $installerPath
    }
}

function Invoke-WslInstall {
    $wsl = Get-Command wsl -ErrorAction SilentlyContinue
    if (-not $wsl) {
        throw "WSL não foi encontrado. Instale WSL2 ou rode sem -UseWsl para usar o instalador nativo Windows."
    }

    Write-Step "Executando instalador oficial dentro do WSL"
    & wsl bash -lc "curl -fsSL '$OfficialPosixInstaller' | bash"
}

function Invoke-HermesModelSetup {
    $hermes = Resolve-HermesCommand
    if (-not $hermes) {
        Write-Warn "Não encontrei o comando hermes nesta janela. Abra um novo terminal e rode: hermes model"
        return
    }

    if (-not (Confirm-Continue "Abrir agora o assistente oficial para escolher modelo/login/API key?")) {
        Write-Warn "Tudo bem. Depois rode: hermes model"
        return
    }

    Write-Step "Abrindo assistente oficial do Hermes"
    & $hermes model
}

function Invoke-HermesDoctor {
    $hermes = Resolve-HermesCommand
    if (-not $hermes) {
        Write-Warn "Não encontrei o comando hermes para rodar diagnóstico. Abra um novo terminal e rode: hermes doctor"
        return
    }

    Write-Step "Rodando diagnóstico"
    & $hermes doctor
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
        Write-Host "Antes de configurar o Telegram, abra o guia e crie seu bot pelo BotFather." -ForegroundColor Yellow
        Write-Host "Guia: $guidePath" -ForegroundColor Gray
        if (Confirm-Continue "Abrir o guia agora?") {
            Start-Process $guidePath
        }
    }

    if (-not (Confirm-Continue "Você já tem o token do BotFather e o seu Telegram User ID?")) {
        Write-Warn "Sem problema. Quando tiver os dois, rode: hermes gateway setup"
        return
    }

    Write-Step "Abrindo configuração oficial do gateway"
    & $hermes gateway setup

    if (Confirm-Continue "Iniciar o gateway do Telegram agora?") {
        Write-Step "Iniciando gateway"
        try {
            & $hermes gateway start
        } catch {
            Write-Warn "Se 'gateway start' não funcionar neste sistema, tente: hermes gateway"
            Write-Warn "Ou, em WSL/Linux/macOS: hermes gateway run"
        }
    }
}

Write-Host ""
Write-Host "Hermes Easy Installer" -ForegroundColor Magenta
Write-Host "Instala o Hermes Agent usando os scripts oficiais da Nous Research." -ForegroundColor Gray
Write-Host "Credenciais não são salvas por este wrapper; use apenas o assistente oficial." -ForegroundColor Gray

if (-not $SkipInstall) {
    if (-not (Confirm-Continue "Continuar e baixar o instalador oficial mais recente?")) {
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
    Invoke-HermesModelSetup
}

if (-not $SkipDoctor) {
    Invoke-HermesDoctor
}

if (-not $SkipGatewaySetup -and -not $NonInteractive) {
    Invoke-HermesGatewaySetup
}

Write-Step "Pronto"
Write-Host "Para conversar com o Hermes, abra um novo terminal e rode:" -ForegroundColor Gray
Write-Host "  hermes" -ForegroundColor Green
Write-Host ""
Write-Host "Para trocar login/modelo/API key depois:" -ForegroundColor Gray
Write-Host "  hermes model" -ForegroundColor Green
Write-Host ""
Write-Host "Para configurar Telegram depois:" -ForegroundColor Gray
Write-Host "  hermes gateway setup" -ForegroundColor Green
