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
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [Console]::InputEncoding = $utf8
    [Console]::OutputEncoding = $utf8
    $OutputEncoding = $utf8
} catch {
    # Some hosts do not allow console encoding changes.
}

$repoZipUrl = "https://codeload.github.com/moreiradaniel66-alt/Hermes-Easy-Installer/zip/refs/heads/main"
$workDir = Join-Path ([IO.Path]::GetTempPath()) ("hermes-easy-installer-" + [Guid]::NewGuid().ToString("N"))
$zipPath = Join-Path $workDir "Hermes-Easy-Installer.zip"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

try {
    Write-Host ""
    Write-Host "Hermes Easy Installer" -ForegroundColor Magenta
    Write-Host "Baixando pacote publico do GitHub..." -ForegroundColor Gray

    New-Item -ItemType Directory -Force -Path $workDir | Out-Null
    $client = [System.Net.WebClient]::new()
    $client.Headers.Add("User-Agent", "Hermes-Easy-Installer")
    $client.DownloadFile($repoZipUrl, $zipPath)

    Write-Step "Extraindo instalador"
    Expand-Archive -LiteralPath $zipPath -DestinationPath $workDir -Force

    $packageDir = Get-ChildItem -LiteralPath $workDir -Directory |
        Where-Object { $_.Name -like "Hermes-Easy-Installer-*" } |
        Select-Object -First 1

    if (-not $packageDir) {
        throw "Nao foi possivel localizar a pasta extraida do Hermes Easy Installer."
    }

    $installer = Join-Path $packageDir.FullName "_motor\install-hermes-easy.ps1"
    if (-not (Test-Path -LiteralPath $installer)) {
        throw "Instalador interno nao encontrado: $installer"
    }

    $forwardArgs = @()
    foreach ($item in @(
        @{ Enabled = $SkipInstall; Name = "-SkipInstall" },
        @{ Enabled = $SkipModelSetup; Name = "-SkipModelSetup" },
        @{ Enabled = $SkipGatewaySetup; Name = "-SkipGatewaySetup" },
        @{ Enabled = $SkipDoctor; Name = "-SkipDoctor" },
        @{ Enabled = $UseWsl; Name = "-UseWsl" },
        @{ Enabled = $NonInteractive; Name = "-NonInteractive" }
    )) {
        if ($item.Enabled) { $forwardArgs += $item.Name }
    }

    Write-Step "Iniciando assistente"
    & powershell -NoProfile -ExecutionPolicy Bypass -File $installer @forwardArgs
} finally {
    if (Test-Path -LiteralPath $workDir) {
        Remove-Item -LiteralPath $workDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
