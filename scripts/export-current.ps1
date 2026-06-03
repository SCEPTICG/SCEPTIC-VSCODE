$ErrorActionPreference = "Stop"

if (-not $env:APPDATA) {
    throw "No se pudo detectar APPDATA. No se puede localizar la configuracion de VSCode."
}

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$TargetUser = Join-Path $env:APPDATA "Code\User"
$ExportDir = Join-Path $RepoRoot ("exports\windows-" + (Get-Date -Format "yyyyMMddHHmmss"))

New-Item -ItemType Directory -Force -Path $ExportDir | Out-Null

foreach ($Name in @("settings.json", "keybindings.json")) {
    $Source = Join-Path $TargetUser $Name
    if (Test-Path -LiteralPath $Source) {
        Copy-Item -LiteralPath $Source -Destination (Join-Path $ExportDir $Name)
    }
}

$SnippetSource = Join-Path $TargetUser "snippets"
if (Test-Path -LiteralPath $SnippetSource) {
    Copy-Item -LiteralPath $SnippetSource -Destination (Join-Path $ExportDir "snippets") -Recurse
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    & code --list-extensions | Set-Content -LiteralPath (Join-Path $ExportDir "extensions.txt")
}

Write-Host "Exportacion creada en: $ExportDir"
