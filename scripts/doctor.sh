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
