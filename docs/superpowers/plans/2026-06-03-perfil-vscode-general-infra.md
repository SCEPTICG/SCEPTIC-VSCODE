# Perfil VSCode General Infra Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear y aplicar un perfil reproducible de VSCode para trabajo general multi-lenguaje e infraestructura/devops, con Windows y macOS como objetivos principales.

**Architecture:** El repositorio contiene la configuracion fuente en `config/User/`, listas auditables de extensiones en `config/extensions/` y scripts de instalacion/diagnostico/exportacion. Los instaladores detectan la ruta real de VSCode, hacen backup timestamped y copian la configuracion sin depender de Settings Sync.

**Tech Stack:** VSCode User Settings, PowerShell, Bash, JSON/JSONC, Git, CLI `code`.

---

## Archivos y responsabilidades

- `README.md`: documentacion en castellano, instalacion, flags, extensiones, backups y uso de `code archivo`.
- `install.ps1`: instalador principal para Windows.
- `install.sh`: instalador principal para macOS y Linux.
- `config/User/settings.json`: ajustes fuente del perfil.
- `config/User/keybindings.json`: atajos fuente del perfil.
- `config/User/snippets/*.json`: snippets por lenguaje.
- `config/extensions/core.txt`: extensiones esenciales generales.
- `config/extensions/infra.txt`: extensiones de infra/devops.
- `config/extensions/optional.txt`: extensiones opcionales.
- `scripts/doctor.ps1`: diagnostico sin cambios para Windows.
- `scripts/doctor.sh`: diagnostico sin cambios para macOS/Linux.
- `scripts/export-current.ps1`: exporta configuracion actual en Windows.
- `scripts/export-current.sh`: exporta configuracion actual en macOS/Linux.

## Task 1: Estructura base del repositorio

**Files:**
- Modify: `README.md`
- Create: `config/User/settings.json`
- Create: `config/User/keybindings.json`
- Create: `config/User/snippets/markdown.json`
- Create: `config/User/snippets/powershell.json`
- Create: `config/User/snippets/python.json`
- Create: `config/User/snippets/shellscript.json`
- Create: `config/User/snippets/yaml.json`
- Create: `config/extensions/core.txt`
- Create: `config/extensions/infra.txt`
- Create: `config/extensions/optional.txt`

- [ ] **Step 1: Crear directorios**

Run:

```powershell
New-Item -ItemType Directory -Force -Path config/User/snippets, config/extensions
```

Expected: los directorios existen y no hay error.

- [ ] **Step 2: Crear settings inicial**

Write `config/User/settings.json`:

```jsonc
{
  "workbench.startupEditor": "none",
  "workbench.editor.enablePreview": false,
  "workbench.tree.indent": 16,
  "workbench.iconTheme": "material-icon-theme",
  "editor.fontFamily": "Cascadia Code, Consolas, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14,
  "editor.lineHeight": 22,
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "boundary",
  "editor.rulers": [88, 120],
  "editor.formatOnSave": true,
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/__pycache__": true,
    "**/.pytest_cache": true,
    "**/.mypy_cache": true,
    "**/.ruff_cache": true
  },
  "search.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/.venv": true,
    "**/venv": true
  },
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.scrollback": 10000,
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "diffEditor.ignoreTrimWhitespace": false,
  "markdown.preview.breaks": true,
  "markdown.updateLinksOnFileMove.enabled": "prompt",
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit",
      "source.fixAll": "explicit"
    }
  },
  "[powershell]": {
    "editor.defaultFormatter": "ms-vscode.powershell"
  },
  "[shellscript]": {
    "editor.defaultFormatter": "foxundermoon.shell-format"
  },
  "[json]": {
    "editor.defaultFormatter": "vscode.json-language-features"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "vscode.json-language-features"
  },
  "[yaml]": {
    "editor.defaultFormatter": "redhat.vscode-yaml"
  },
  "[markdown]": {
    "editor.defaultFormatter": "yzhang.markdown-all-in-one"
  },
  "yaml.validate": true,
  "yaml.format.enable": true,
  "python.analysis.typeCheckingMode": "basic",
  "python.analysis.autoImportCompletions": true,
  "powershell.integratedConsole.showOnStartup": false,
  "telemetry.telemetryLevel": "off"
}
```

- [ ] **Step 3: Crear keybindings iniciales**

Write `config/User/keybindings.json`:

```jsonc
[
  {
    "key": "ctrl+alt+t",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  {
    "key": "ctrl+alt+f",
    "command": "editor.action.formatDocument",
    "when": "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly"
  },
  {
    "key": "ctrl+alt+e",
    "command": "workbench.view.explorer"
  },
  {
    "key": "ctrl+alt+g",
    "command": "workbench.view.scm"
  }
]
```

- [ ] **Step 4: Crear snippets Markdown**

Write `config/User/snippets/markdown.json`:

```json
{
  "README base": {
    "prefix": "readme-base",
    "body": [
      "# ${1:Nombre}",
      "",
      "## Proposito",
      "",
      "${2:Descripcion breve.}",
      "",
      "## Instalacion",
      "",
      "```bash",
      "${3:comando}",
      "```",
      "",
      "## Uso",
      "",
      "```bash",
      "${4:comando}",
      "```"
    ],
    "description": "Estructura base de README tecnico"
  }
}
```

- [ ] **Step 5: Crear snippets PowerShell**

Write `config/User/snippets/powershell.json`:

```json
{
  "Script estricto": {
    "prefix": "ps-strict",
    "body": [
      "$ErrorActionPreference = \"Stop\"",
      "",
      "function Write-Info {",
      "    param([string]$Message)",
      "    Write-Host \"[info] $Message\"",
      "}",
      "",
      "${1:# codigo}"
    ],
    "description": "Base de script PowerShell con errores estrictos"
  }
}
```

- [ ] **Step 6: Crear snippets Python**

Write `config/User/snippets/python.json`:

```json
{
  "CLI minima": {
    "prefix": "py-cli",
    "body": [
      "from __future__ import annotations",
      "",
      "",
      "def main() -> int:",
      "    ${1:print(\"Hola\")}",
      "    return 0",
      "",
      "",
      "if __name__ == \"__main__\":",
      "    raise SystemExit(main())"
    ],
    "description": "Entrada CLI minima para Python"
  }
}
```

- [ ] **Step 7: Crear snippets shell**

Write `config/User/snippets/shellscript.json`:

```json
{
  "Script seguro": {
    "prefix": "sh-safe",
    "body": [
      "#!/usr/bin/env bash",
      "set -euo pipefail",
      "",
      "log() {",
      "  printf '[info] %s\\n' \"$1\"",
      "}",
      "",
      "${1:# codigo}"
    ],
    "description": "Base de script shell con modo estricto"
  }
}
```

- [ ] **Step 8: Crear snippets YAML**

Write `config/User/snippets/yaml.json`:

```json
{
  "Docker Compose servicio": {
    "prefix": "compose-service",
    "body": [
      "${1:servicio}:",
      "  image: ${2:imagen}",
      "  restart: unless-stopped",
      "  ports:",
      "    - \"${3:8080}:$4\"",
      "  environment:",
      "    - ${5:VARIABLE=valor}"
    ],
    "description": "Bloque de servicio para Docker Compose"
  }
}
```

- [ ] **Step 9: Crear listas de extensiones**

Write `config/extensions/core.txt`:

```text
ms-python.python
ms-python.vscode-pylance
charliermarsh.ruff
ms-vscode.powershell
redhat.vscode-yaml
editorconfig.editorconfig
yzhang.markdown-all-in-one
oderwat.indent-rainbow
pkief.material-icon-theme
eamodio.gitlens
```

Write `config/extensions/infra.txt`:

```text
ms-azuretools.vscode-docker
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-containers
hashicorp.terraform
timonwong.shellcheck
foxundermoon.shell-format
ms-kubernetes-tools.vscode-kubernetes-tools
```

Write `config/extensions/optional.txt`:

```text
github.vscode-github-actions
streetsidesoftware.code-spell-checker
```

- [ ] **Step 10: Commit**

Run:

```powershell
git add README.md config
git commit -m "feat: add vscode profile base"
```

Expected: commit creado con configuracion base.

## Task 2: Instalador Windows

**Files:**
- Create: `install.ps1`

- [ ] **Step 1: Crear instalador PowerShell**

Write `install.ps1`:

```powershell
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

function Invoke-Action {
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
        Invoke-Action "Backup de $Path -> $Backup" {
            Move-Item -LiteralPath $Path -Destination $Backup
        }
    }
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
    Write-Step "En VSCode: abre la paleta de comandos y ejecuta 'Shell Command: Install code command in PATH' si esta disponible."
}

Invoke-Action "Crear ruta destino $TargetUser" {
    New-Item -ItemType Directory -Force -Path $TargetUser | Out-Null
}

Backup-Path (Join-Path $TargetUser "settings.json")
Backup-Path (Join-Path $TargetUser "keybindings.json")
Backup-Path (Join-Path $TargetUser "snippets")

Invoke-Action "Copiar settings.json" {
    Copy-Item -LiteralPath (Join-Path $SourceUser "settings.json") -Destination (Join-Path $TargetUser "settings.json") -Force
}

Invoke-Action "Copiar keybindings.json" {
    Copy-Item -LiteralPath (Join-Path $SourceUser "keybindings.json") -Destination (Join-Path $TargetUser "keybindings.json") -Force
}

Invoke-Action "Copiar snippets" {
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
        $ExtensionFiles += Join-Path $ExtensionRoot "optional.txt"
    }
    foreach ($File in $ExtensionFiles) {
        if (-not (Test-Path -LiteralPath $File)) {
            throw "No existe la lista de extensiones: $File"
        }
        Get-Content -LiteralPath $File | Where-Object { $_ -and -not $_.StartsWith("#") } | ForEach-Object {
            $Extension = $_.Trim()
            if ($Installed -contains $Extension) {
                Write-Step "Extension ya instalada: $Extension"
            }
            else {
                Invoke-Action "Instalar extension $Extension" {
                    & code --install-extension $Extension
                }
            }
        }
    }
}

Write-Step "Instalacion finalizada. Abre VSCode o ejecuta: code ."
```

- [ ] **Step 2: Ejecutar dry-run**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 --dry-run --no-extensions
```

Expected: muestra acciones previstas y no modifica `%APPDATA%\Code\User`.

- [ ] **Step 3: Commit**

Run:

```powershell
git add install.ps1
git commit -m "feat: add windows installer"
```

Expected: commit creado con instalador Windows.

## Task 3: Instalador macOS/Linux

**Files:**
- Create: `install.sh`

- [ ] **Step 1: Crear instalador Bash**

Write `install.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

dry_run=0
no_extensions=0
with_optional=0
force=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=1 ;;
    --no-extensions) no_extensions=1 ;;
    --with-optional) with_optional=1 ;;
    --force) force=1 ;;
    *) printf 'Flag no soportado: %s\n' "$arg" >&2; exit 1 ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_user="$repo_root/config/User"
extension_root="$repo_root/config/extensions"
stamp="$(date +%Y%m%d%H%M%S)"

case "$(uname -s)" in
  Darwin) target_user="$HOME/Library/Application Support/Code/User" ;;
  Linux) target_user="$HOME/.config/Code/User" ;;
  *) printf 'Sistema no soportado: %s\n' "$(uname -s)" >&2; exit 1 ;;
esac

log() {
  printf '[SCEPTIC-VSCODE] %s\n' "$1"
}

run_action() {
  message="$1"
  shift
  if [ "$dry_run" -eq 1 ]; then
    log "DRY-RUN: $message"
    return
  fi
  log "$message"
  "$@"
}

backup_path() {
  path="$1"
  if [ -e "$path" ]; then
    run_action "Backup de $path -> $path.backup.$stamp" mv "$path" "$path.backup.$stamp"
  fi
}

if [ ! -d "$source_user" ]; then
  printf 'No existe la configuracion fuente: %s\n' "$source_user" >&2
  exit 1
fi

if ! command -v code >/dev/null 2>&1; then
  log "El comando 'code' no esta en PATH. Se aplicara la configuracion, pero no se instalaran extensiones."
  log "En VSCode: abre la paleta de comandos y ejecuta 'Shell Command: Install code command in PATH' si esta disponible."
  code_available=0
else
  code_available=1
fi

run_action "Crear ruta destino $target_user" mkdir -p "$target_user"

backup_path "$target_user/settings.json"
backup_path "$target_user/keybindings.json"
backup_path "$target_user/snippets"

run_action "Copiar settings.json" cp "$source_user/settings.json" "$target_user/settings.json"
run_action "Copiar keybindings.json" cp "$source_user/keybindings.json" "$target_user/keybindings.json"
run_action "Copiar snippets" cp -R "$source_user/snippets" "$target_user/snippets"

if [ "$no_extensions" -eq 0 ] && [ "$code_available" -eq 1 ]; then
  installed="$(code --list-extensions || true)"
  extension_files=("$extension_root/core.txt" "$extension_root/infra.txt")
  if [ "$with_optional" -eq 1 ]; then
    extension_files+=("$extension_root/optional.txt")
  fi
  for file in "${extension_files[@]}"; do
    if [ ! -f "$file" ]; then
      printf 'No existe la lista de extensiones: %s\n' "$file" >&2
      exit 1
    fi
    while IFS= read -r extension; do
      [ -z "$extension" ] && continue
      case "$extension" in \#*) continue ;; esac
      if printf '%s\n' "$installed" | grep -Fxq "$extension"; then
        log "Extension ya instalada: $extension"
      else
        run_action "Instalar extension $extension" code --install-extension "$extension"
      fi
    done < "$file"
  done
fi

log "Instalacion finalizada. Abre VSCode o ejecuta: code ."
```

- [ ] **Step 2: Ejecutar dry-run**

Run:

```powershell
wsl bash -lc "cd '/mnt/c/Users/SCEPTICG/Documents/MINI PROYECTOS GITHUB/SCEPTIC-VSCODE' && bash install.sh --dry-run --no-extensions"
```

Expected: muestra acciones previstas para ruta Linux o macOS segun entorno.

- [ ] **Step 3: Commit**

Run:

```powershell
git add install.sh
git commit -m "feat: add unix installer"
```

Expected: commit creado con instalador Unix.

## Task 4: Scripts doctor

**Files:**
- Create: `scripts/doctor.ps1`
- Create: `scripts/doctor.sh`

- [ ] **Step 1: Crear directorio scripts**

Run:

```powershell
New-Item -ItemType Directory -Force -Path scripts
```

Expected: `scripts/` existe.

- [ ] **Step 2: Crear doctor PowerShell**

Write `scripts/doctor.ps1`:

```powershell
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
    Write-Check "Extensiones instaladas" ((& code --list-extensions).Count)
}

if ($TargetUser) {
    Write-Check "settings.json" $(if (Test-Path (Join-Path $TargetUser "settings.json")) { "Existe" } else { "No existe" })
    Write-Check "keybindings.json" $(if (Test-Path (Join-Path $TargetUser "keybindings.json")) { "Existe" } else { "No existe" })
    Write-Check "snippets" $(if (Test-Path (Join-Path $TargetUser "snippets")) { "Existe" } else { "No existe" })
}
```

- [ ] **Step 3: Crear doctor Bash**

Write `scripts/doctor.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

check() {
  printf '%s: %s\n' "$1" "$2"
}

case "$(uname -s)" in
  Darwin) system="macOS"; target_user="$HOME/Library/Application Support/Code/User" ;;
  Linux) system="Linux"; target_user="$HOME/.config/Code/User" ;;
  *) system="$(uname -s)"; target_user="" ;;
esac

check "Sistema" "$system"
check "Ruta VSCode User" "${target_user:-No detectada}"

if command -v code >/dev/null 2>&1; then
  check "Comando code" "Disponible"
  check "Version VSCode" "$(code --version | head -n 1)"
  check "Extensiones instaladas" "$(code --list-extensions | wc -l | tr -d ' ')"
else
  check "Comando code" "No disponible"
fi

if [ -n "$target_user" ]; then
  [ -f "$target_user/settings.json" ] && check "settings.json" "Existe" || check "settings.json" "No existe"
  [ -f "$target_user/keybindings.json" ] && check "keybindings.json" "Existe" || check "keybindings.json" "No existe"
  [ -d "$target_user/snippets" ] && check "snippets" "Existe" || check "snippets" "No existe"
fi
```

- [ ] **Step 4: Ejecutar doctor Windows**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\doctor.ps1
```

Expected: imprime sistema, ruta VSCode User y estado del comando `code`.

- [ ] **Step 5: Commit**

Run:

```powershell
git add scripts/doctor.ps1 scripts/doctor.sh
git commit -m "feat: add vscode doctor scripts"
```

Expected: commit creado con scripts doctor.

## Task 5: Scripts de exportacion

**Files:**
- Create: `scripts/export-current.ps1`
- Create: `scripts/export-current.sh`

- [ ] **Step 1: Crear export-current PowerShell**

Write `scripts/export-current.ps1`:

```powershell
$ErrorActionPreference = "Stop"

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
```

- [ ] **Step 2: Crear export-current Bash**

Write `scripts/export-current.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d%H%M%S)"

case "$(uname -s)" in
  Darwin) target_user="$HOME/Library/Application Support/Code/User"; export_dir="$repo_root/exports/macos-$stamp" ;;
  Linux) target_user="$HOME/.config/Code/User"; export_dir="$repo_root/exports/linux-$stamp" ;;
  *) printf 'Sistema no soportado: %s\n' "$(uname -s)" >&2; exit 1 ;;
esac

mkdir -p "$export_dir"

[ -f "$target_user/settings.json" ] && cp "$target_user/settings.json" "$export_dir/settings.json"
[ -f "$target_user/keybindings.json" ] && cp "$target_user/keybindings.json" "$export_dir/keybindings.json"
[ -d "$target_user/snippets" ] && cp -R "$target_user/snippets" "$export_dir/snippets"

if command -v code >/dev/null 2>&1; then
  code --list-extensions > "$export_dir/extensions.txt"
fi

printf 'Exportacion creada en: %s\n' "$export_dir"
```

- [ ] **Step 3: Actualizar .gitignore para exports**

Write `.gitignore`:

```gitignore
exports/
*.backup.*
```

- [ ] **Step 4: Commit**

Run:

```powershell
git add .gitignore scripts/export-current.ps1 scripts/export-current.sh
git commit -m "feat: add vscode export scripts"
```

Expected: commit creado con exportadores y `.gitignore`.

## Task 6: Documentacion en castellano

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Escribir README**

Write `README.md`:

````markdown
# SCEPTIC-VSCODE

Perfil reproducible de Visual Studio Code para trabajo general multi-lenguaje e infraestructura/devops.

El repositorio es la fuente de verdad. No depende de VSCode Settings Sync ni de las configuraciones de Neovim o Zsh.

## Instalacion

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

macOS/Linux:

```bash
bash install.sh
```

## Flags utiles

```text
--dry-run          muestra acciones previstas sin cambiar archivos
--no-extensions    aplica configuracion pero no instala extensiones
--with-optional    instala tambien extensiones opcionales
--force            reservado para aplicar aunque haya diferencias locales
```

## Estructura

- `config/User/`: configuracion fuente de VSCode.
- `config/extensions/`: listas auditables de extensiones.
- `scripts/doctor.*`: diagnostico local sin cambios.
- `scripts/export-current.*`: exportacion de una configuracion local para revision.

## Extensiones principales

- `ms-python.python`: soporte Python.
- `ms-python.vscode-pylance`: analisis Python.
- `charliermarsh.ruff`: formato y linting Python moderno.
- `ms-vscode.powershell`: soporte PowerShell.
- `redhat.vscode-yaml`: YAML con validacion.
- `editorconfig.editorconfig`: respeto de `.editorconfig`.
- `yzhang.markdown-all-in-one`: utilidades Markdown.
- `pkief.material-icon-theme`: iconos claros para el explorador.
- `eamodio.gitlens`: contexto Git.
- `ms-azuretools.vscode-docker`: Docker y Compose.
- `ms-vscode-remote.remote-ssh`: trabajo remoto por SSH.
- `ms-vscode-remote.remote-containers`: Dev Containers.
- `hashicorp.terraform`: Terraform/HCL.
- `timonwong.shellcheck`: linting shell.
- `foxundermoon.shell-format`: formato shell.

## Comando code

Para abrir una carpeta o archivo desde terminal:

```bash
code .
code README.md
```

Si el comando no existe, abre VSCode, usa la paleta de comandos y busca `Shell Command: Install code command in PATH` cuando este disponible.

## Backups

El instalador respalda `settings.json`, `keybindings.json` y `snippets/` con sufijos como:

```text
settings.json.backup.20260603123000
```

Para restaurar, cierra VSCode, elimina el archivo aplicado y renombra el backup correspondiente.

## Diagnostico

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\doctor.ps1
```

macOS/Linux:

```bash
bash scripts/doctor.sh
```
````

- [ ] **Step 2: Commit**

Run:

```powershell
git add README.md
git commit -m "docs: document vscode profile"
```

Expected: commit creado con README en castellano.

## Task 7: Aplicacion local en Windows y revision visual

**Files:**
- Runtime target: `%APPDATA%\Code\User`
- Possible follow-up modifications: `config/User/settings.json`
- Possible follow-up modifications: `config/User/keybindings.json`
- Possible follow-up modifications: `config/extensions/*.txt`

- [ ] **Step 1: Ejecutar diagnostico previo**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\doctor.ps1
```

Expected: muestra si `code` esta disponible y si ya hay configuracion local.

- [ ] **Step 2: Ejecutar dry-run de instalacion**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 --dry-run
```

Expected: lista backups, copias e instalacion de extensiones sin cambiar archivos.

- [ ] **Step 3: Aplicar perfil en Windows**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

Expected: crea backups, aplica configuracion e instala extensiones disponibles.

- [ ] **Step 4: Abrir VSCode en el repo**

Run:

```powershell
code .
```

Expected: VSCode abre el repo `SCEPTIC-VSCODE`.

- [ ] **Step 5: Revisar captura del usuario**

El usuario manda captura de VSCode con explorador, editor y terminal visibles. Revisar:

- Densidad del editor.
- Tema de iconos.
- Tamano de fuente.
- Minimap.
- Ruido del explorador.
- Terminal integrada.
- Estado de Git.
- Errores de extensiones o notificaciones.

- [ ] **Step 6: Ajustar configuracion segun captura**

Modificar solo los archivos fuente del repo, por ejemplo `config/User/settings.json`, y volver a aplicar con:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 --no-extensions
```

Expected: VSCode refleja los cambios tras recargar ventana.

- [ ] **Step 7: Repetir ciclo visual hasta aprobacion**

Pedir nueva captura tras cada cambio visual o ergonomico. Parar cuando el usuario apruebe el aspecto y comportamiento base.

- [ ] **Step 8: Commit final de ajustes locales aprobados**

Run:

```powershell
git add config README.md install.ps1 install.sh scripts
git commit -m "chore: tune vscode profile after local review"
```

Expected: commit creado solo si hubo cambios tras la revision visual.

## Task 8: Verificacion final y push

**Files:**
- No new files expected.

- [ ] **Step 1: Validar JSON con PowerShell**

Run:

```powershell
Get-ChildItem -Recurse -Filter *.json | ForEach-Object { Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json | Out-Null; Write-Host "OK $($_.FullName)" }
```

Expected: todos los JSON validos imprimen `OK`.

- [ ] **Step 2: Validar estado Git**

Run:

```powershell
git status --short --branch
```

Expected: rama `main` sin cambios pendientes, salvo que se decida dejar cambios sin commit para revision.

- [ ] **Step 3: Push a GitHub**

Run:

```powershell
git push origin main
```

Expected: cambios publicados en `SCEPTICG/SCEPTIC-VSCODE`.
