$ErrorActionPreference = "Stop"

$DryRun = $false
$NoExtensions = $false
$WithOptional = $false
$Force = $false

foreach ($Arg in $args) {
    switch ($Arg) {
        "--dry-run" { $DryRun = $true }
        "--no-extensions" { $NoExtensions = $true }
        "--with-optional" { $WithOptional = $true }
        "--force" { $Force = $true }
        default { throw "Flag no soportado: $Arg" }
    }
}

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceUser = Join-Path $RepoRoot "config\User"
$ExtensionRoot = Join-Path $RepoRoot "config\extensions"
$TargetUser = Join-Path $env:APPDATA "Code\User"
$Stamp = Get-Date -Format "yyyyMMddHHmmss"

function Write-Step {
    param([string]$Message)
    Write-Host "[SCEPTIC-VSCODE] $Message"
}

function Invoke-ProfileAction {
    param(
        [string]$Message,
        [scriptblock]$Action
    )

    if ($DryRun) {
        Write-Step "DRY-RUN: $Message"
        return
    }

    Write-Step $Message
    & $Action
}

function Backup-Path {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path) {
        $Backup = "$Path.backup.$Stamp"
        Invoke-ProfileAction "Backup de $Path -> $Backup" {
            Move-Item -LiteralPath $Path -Destination $Backup
        }
    }
}

function Get-ExtensionList {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "No existe la lista de extensiones: $Path"
    }

    Get-Content -LiteralPath $Path |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith("#") }
}

if (-not $env:APPDATA) {
    throw "No se pudo detectar APPDATA. No se puede localizar la configuracion de VSCode."
}

if (-not (Test-Path -LiteralPath $SourceUser)) {
    throw "No existe la configuracion fuente: $SourceUser"
}

$CodeCommand = Get-Command code -ErrorAction SilentlyContinue
if (-not $CodeCommand) {
    Write-Step "El comando 'code' no esta en PATH. Se aplicara la configuracion, pero no se instalaran extensiones."
    Write-Step "En VSCode, abre la paleta de comandos y busca 'Shell Command: Install code command in PATH' si esta disponible."
}

Invoke-ProfileAction "Crear ruta destino $TargetUser" {
    New-Item -ItemType Directory -Force -Path $TargetUser | Out-Null
}

Backup-Path (Join-Path $TargetUser "settings.json")
Backup-Path (Join-Path $TargetUser "keybindings.json")
Backup-Path (Join-Path $TargetUser "snippets")

Invoke-ProfileAction "Copiar settings.json" {
    Copy-Item -LiteralPath (Join-Path $SourceUser "settings.json") -Destination (Join-Path $TargetUser "settings.json") -Force
}

Invoke-ProfileAction "Copiar keybindings.json" {
    Copy-Item -LiteralPath (Join-Path $SourceUser "keybindings.json") -Destination (Join-Path $TargetUser "keybindings.json") -Force
}

Invoke-ProfileAction "Copiar snippets" {
    Copy-Item -LiteralPath (Join-Path $SourceUser "snippets") -Destination (Join-Path $TargetUser "snippets") -Recurse -Force
}

if (-not $NoExtensions -and $CodeCommand) {
    $Installed = @()
    if (-not $DryRun) {
        $Installed = & code --list-extensions
    }

    $ExtensionFiles = @(
        (Join-Path $ExtensionRoot "core.txt"),
        (Join-Path $ExtensionRoot "infra.txt")
    )

    if ($WithOptional) {
        $ExtensionFiles += (Join-Path $ExtensionRoot "optional.txt")
    }

    foreach ($File in $ExtensionFiles) {
        foreach ($Extension in Get-ExtensionList $File) {
            if ($Installed -contains $Extension) {
                Write-Step "Extension ya instalada: $Extension"
            }
            else {
                Invoke-ProfileAction "Instalar extension $Extension" {
                    & code --install-extension $Extension
                }
            }
        }
    }
}

if ($Force) {
    Write-Step "Flag --force recibido. En esta version no cambia el comportamiento porque los backups ya protegen la configuracion anterior."
}

Write-Step "Instalacion finalizada. Abre VSCode o ejecuta: code ."
