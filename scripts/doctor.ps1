$ErrorActionPreference = "Stop"

function Write-Check {
    param([string]$Name, [string]$Value)
    Write-Host ("{0}: {1}" -f $Name, $Value)
}

$TargetUser = if ($env:APPDATA) { Join-Path $env:APPDATA "Code\User" } else { "" }
$CodeCommand = Get-Command code -ErrorAction SilentlyContinue

Write-Check "Sistema" "Windows"
Write-Check "Ruta VSCode User" $(if ($TargetUser) { $TargetUser } else { "No detectada" })
Write-Check "Comando code" $(if ($CodeCommand) { "Disponible" } else { "No disponible" })

if ($CodeCommand) {
    Write-Check "Version VSCode" (& code --version | Select-Object -First 1)
    Write-Check "Extensiones instaladas" ((& code --list-extensions).Count.ToString())
}

if ($TargetUser) {
    Write-Check "settings.json" $(if (Test-Path (Join-Path $TargetUser "settings.json")) { "Existe" } else { "No existe" })
    Write-Check "keybindings.json" $(if (Test-Path (Join-Path $TargetUser "keybindings.json")) { "Existe" } else { "No existe" })
    Write-Check "snippets" $(if (Test-Path (Join-Path $TargetUser "snippets")) { "Existe" } else { "No existe" })
}
