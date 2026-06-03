# SCEPTIC-VSCODE

Perfil reproducible de Visual Studio Code para trabajo general multi-lenguaje e infraestructura/devops.

El repositorio es la fuente de verdad. No depende de VSCode Settings Sync ni de
las configuraciones de Neovim o Zsh. La unica integracion intencional con la
terminal es poder abrir archivos o carpetas con `code`.

## Identidad visual

- Tema: Dracula.
- Iconos: Material Icon Theme.
- Barra lateral: a la derecha, para que al abrir/cerrar el explorador no se
  desplace el codigo.
- Editor: sin minimap ni rulers verticales.

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
- `tests/validate-profile.ps1`: validacion rapida del perfil y scripts.

## Extensiones principales

- `dracula-theme.theme-dracula`: tema visual Dracula.
- `pkief.material-icon-theme`: iconos claros para el explorador.
- `ms-python.python`: soporte Python.
- `ms-python.vscode-pylance`: analisis Python.
- `charliermarsh.ruff`: formato y linting Python moderno.
- `ms-vscode.powershell`: soporte PowerShell.
- `redhat.vscode-yaml`: YAML con validacion.
- `editorconfig.editorconfig`: respeto de `.editorconfig`.
- `yzhang.markdown-all-in-one`: utilidades Markdown.
- `DavidAnson.vscode-markdownlint`: linting Markdown.
- `eamodio.gitlens`: contexto Git.
- `ms-azuretools.vscode-docker`: Docker y Compose.
- `ms-vscode-remote.remote-ssh`: trabajo remoto por SSH.
- `ms-vscode-remote.remote-containers`: Dev Containers.
- `hashicorp.terraform`: Terraform/HCL.
- `timonwong.shellcheck`: linting shell.
- `foxundermoon.shell-format`: formato shell.
- `github.vscode-github-actions`: GitHub Actions.

## Comando code

Para abrir una carpeta o archivo desde terminal:

```bash
code .
code README.md
```

Si el comando no existe, abre VSCode, usa la paleta de comandos y busca
`Shell Command: Install code command in PATH` cuando este disponible.

## Backups

El instalador respalda `settings.json`, `keybindings.json` y `snippets/` con
sufijos como:

```text
settings.json.backup.20260603123000
```

Para restaurar, cierra VSCode, elimina el archivo aplicado y renombra el backup
correspondiente.

## Diagnostico

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\doctor.ps1
```

macOS/Linux:

```bash
bash scripts/doctor.sh
```

## Exportar una configuracion local

Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\export-current.ps1
```

macOS/Linux:

```bash
bash scripts/export-current.sh
```

Las exportaciones se guardan en `exports/`, que esta ignorado por Git.
