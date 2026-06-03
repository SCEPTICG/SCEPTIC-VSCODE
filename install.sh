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

install_extension_file() {
  file="$1"

  if [ ! -f "$file" ]; then
    printf 'No existe la lista de extensiones: %s\n' "$file" >&2
    exit 1
  fi

  while IFS= read -r extension; do
    extension="$(printf '%s' "$extension" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [ -z "$extension" ] && continue
    case "$extension" in \#*) continue ;; esac

    if printf '%s\n' "$installed_extensions" | grep -Fxq "$extension"; then
      log "Extension ya instalada: $extension"
    else
      run_action "Instalar extension $extension" code --install-extension "$extension"
    fi
  done < "$file"
}

if [ ! -d "$source_user" ]; then
  printf 'No existe la configuracion fuente: %s\n' "$source_user" >&2
  exit 1
fi

if command -v code >/dev/null 2>&1; then
  code_available=1
else
  code_available=0
  log "El comando 'code' no esta en PATH. Se aplicara la configuracion, pero no se instalaran extensiones."
  log "En VSCode, abre la paleta de comandos y busca 'Shell Command: Install code command in PATH' si esta disponible."
fi

run_action "Crear ruta destino $target_user" mkdir -p "$target_user"

backup_path "$target_user/settings.json"
backup_path "$target_user/keybindings.json"
backup_path "$target_user/snippets"

run_action "Copiar settings.json" cp "$source_user/settings.json" "$target_user/settings.json"
run_action "Copiar keybindings.json" cp "$source_user/keybindings.json" "$target_user/keybindings.json"
run_action "Copiar snippets" cp -R "$source_user/snippets" "$target_user/snippets"

if [ "$no_extensions" -eq 0 ] && [ "$code_available" -eq 1 ]; then
  installed_extensions="$(code --list-extensions || true)"
  install_extension_file "$extension_root/core.txt"
  install_extension_file "$extension_root/infra.txt"

  if [ "$with_optional" -eq 1 ]; then
    install_extension_file "$extension_root/optional.txt"
  fi
fi

if [ "$force" -eq 1 ]; then
  log "Flag --force recibido. En esta version no cambia el comportamiento porque los backups ya protegen la configuracion anterior."
fi

log "Instalacion finalizada. Abre VSCode o ejecuta: code ."
