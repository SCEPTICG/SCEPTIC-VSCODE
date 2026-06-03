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
