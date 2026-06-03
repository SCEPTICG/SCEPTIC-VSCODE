$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

function Assert-Exists {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "No existe: $Path"
    }
}

function Assert-Json {
    param([string]$Path)

    Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json | Out-Null
    Write-Host "JSON OK: $Path"
}

function Assert-ExtensionList {
    param([string]$Path)

    $Extensions = Get-Content -LiteralPath $Path |
        Where-Object { $_.Trim() -and -not $_.Trim().StartsWith("#") }

    if (-not $Extensions) {
        throw "Lista de extensiones vacia: $Path"
    }

    foreach ($Extension in $Extensions) {
        if ($Extension -notmatch "^[a-zA-Z0-9][a-zA-Z0-9-]*\.[a-zA-Z0-9][a-zA-Z0-9-]*$") {
            throw "Identificador de extension invalido en ${Path}: $Extension"
        }
    }

    Write-Host "Extensiones OK: $Path"
}

$RequiredFiles = @(
    "install.ps1",
    "install.sh",
    "scripts/doctor.ps1",
    "scripts/doctor.sh",
    "scripts/export-current.ps1",
    "scripts/export-current.sh",
    "config/User/settings.json",
    "config/User/keybindings.json",
    "config/extensions/core.txt",
    "config/extensions/infra.txt",
    "config/extensions/optional.txt"
)

foreach ($File in $RequiredFiles) {
    Assert-Exists (Join-Path $RepoRoot $File)
}

Get-ChildItem -Path (Join-Path $RepoRoot "config/User") -Recurse -Filter "*.json" |
    ForEach-Object { Assert-Json $_.FullName }

Get-ChildItem -Path (Join-Path $RepoRoot "config/extensions") -Filter "*.txt" |
    ForEach-Object { Assert-ExtensionList $_.FullName }

& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $RepoRoot "install.ps1") --dry-run --no-extensions | Out-Host

Write-Host "Validacion del perfil completada."
