# SCEPTIC-VSCODE Design

Date: 2026-06-03

## Purpose

SCEPTIC-VSCODE is a standalone, reproducible Visual Studio Code profile for
general multi-language work and infrastructure/devops tasks. The repository is
the source of truth for the profile. VSCode Settings Sync may exist on a
machine, but it is not part of this design and must not be required for a clean
install.

The profile is independent from the existing Neovim and Zsh configurations.
The only intentional terminal integration is support for opening files or
folders from a terminal with the `code` command when VSCode exposes it.

## Scope

The profile covers:

- User settings.
- Keybindings.
- Snippets.
- Extension lists.
- Language-specific configuration.
- Formatter and linter defaults where the required tool or extension is clear.
- Windows, macOS, and Linux installation paths.
- Idempotent install scripts with backups.
- Doctor scripts for validation.
- Export scripts for capturing current local VSCode configuration.

The profile does not target web application development as its main purpose.
React, Vite, Next.js, Tailwind, and similar tools are not core dependencies.
Basic HTML, CSS, JavaScript, and TypeScript editing may remain supported through
VSCode defaults or general-purpose extensions, but they should not dominate the
configuration.

## Repository Layout

```text
SCEPTIC-VSCODE/
  README.md
  LICENSE
  install.ps1
  install.sh
  config/
    User/
      settings.json
      keybindings.json
      snippets/
        markdown.json
        powershell.json
        python.json
        shellscript.json
        yaml.json
    extensions/
      core.txt
      infra.txt
      optional.txt
  scripts/
    doctor.ps1
    doctor.sh
    export-current.ps1
    export-current.sh
  docs/
    superpowers/
      specs/
      plans/
```

`config/User/` mirrors the user configuration files copied into VSCode's user
configuration directory. Extension files are plain text lists with one extension
identifier per line, so they are easy to audit and install with the `code` CLI.

## Platform Targets

The installer must support Windows and macOS as first-class systems, with Linux
handled through the same Unix-style installer where possible.

Expected VSCode user configuration paths:

- Windows: `%APPDATA%\Code\User`
- macOS: `~/Library/Application Support/Code/User`
- Linux: `~/.config/Code/User`

The scripts should detect the platform and fail with a clear message when the
target path cannot be determined.

## Profile Content

The profile should be sober, durable, and useful for repeated technical work.
It should prefer clear defaults over decorative customization.

Primary languages and file types:

- Python.
- PowerShell.
- Bash and shell scripts.
- JSON and JSONC.
- YAML.
- TOML.
- Markdown.
- Dockerfile and Docker Compose.
- Terraform and HCL.
- Git configuration files and ignore files.

Settings should cover:

- Editor readability.
- Sensible autosave behavior.
- Reduced explorer noise.
- Integrated terminal usability.
- Git visibility.
- Markdown editing comfort.
- Language-specific formatter/linter defaults.
- Minimal visual clutter.

Keybindings should be few, memorable, and not Vim-like. They should prioritize
opening the terminal, command palette use, formatting, search, and moving across
panels.

Snippets should provide practical templates for:

- README sections.
- PowerShell scripts.
- Bash scripts.
- Python command-line entry points.
- Docker Compose basics.
- YAML blocks used in infra/devops workflows.

## Extensions

Extensions are split into three lists:

- `core.txt`: general-purpose essentials for the whole profile.
- `infra.txt`: infrastructure/devops extensions.
- `optional.txt`: useful extras installed only when requested.

The extension set should stay conservative and auditable. Avoid large extension
packs unless there is a strong reason. Each extension included in the main
lists should be documented in the README with a short reason.

Likely core and infra categories:

- Python and Pylance.
- PowerShell.
- YAML.
- Docker.
- Dev Containers.
- Remote SSH.
- Git enhancement.
- Markdown tooling.
- EditorConfig.
- ShellCheck integration.
- Terraform/HCL support.

## Installers

`install.ps1` and `install.sh` should share the same user-facing contract:

```text
--dry-run          show planned actions without changing files
--no-extensions    apply config but skip extension installation
--with-optional    install extensions/optional.txt as well
--force            apply even when local differences are detected
```

Installer behavior:

- Detect operating system and VSCode user configuration path.
- Check whether the `code` command exists in `PATH`.
- Apply configuration files even when `code` is unavailable.
- Show clear instructions when `code` is missing.
- Back up existing `settings.json`, `keybindings.json`, and `snippets/` before
  replacement.
- Copy files from `config/User/` to the detected VSCode user directory.
- Install extensions with `code --install-extension`.
- Avoid reinstalling extensions when installed extensions can be detected.
- Keep repeated runs safe and predictable.

Backup names should include timestamps, for example:

```text
settings.json.backup.20260603123000
keybindings.json.backup.20260603123000
snippets.backup.20260603123000
```

## Doctor Scripts

`scripts/doctor.ps1` and `scripts/doctor.sh` should inspect the local
environment without changing it.

They should report:

- Detected operating system.
- Detected VSCode user configuration path.
- Whether the `code` command is available.
- VSCode version when available.
- Installed extension count when available.
- Whether the expected profile files exist in the target directory.
- Any missing recommended external tools that the README says are useful.

## Export Scripts

`scripts/export-current.ps1` and `scripts/export-current.sh` should help capture
a local VSCode setup for review. They should copy the current user settings,
keybindings, snippets, and installed extension identifiers into an export
directory, without automatically overwriting the repo profile.

The export workflow is for migration and review, not for blind sync.

## Documentation

`README.md` should include:

- Purpose and scope.
- Installation commands for Windows, macOS, and Linux.
- Supported flags.
- Repository structure.
- Extension list with short reasons.
- How to re-apply the profile.
- How to restore backups.
- How to confirm `code archivo` or `code .` works from a terminal.
- Notes explaining that this profile is independent from Neovim and Zsh.

## Verification

Initial verification should include:

- Running each installer with `--dry-run`.
- Validating JSON/JSONC files where practical.
- Checking expected files exist.
- Running doctor scripts after installation.

The implementation plan should keep validation lightweight but real. The goal is
to catch broken paths, malformed config files, and missing script behavior
before the profile is used on Windows or macOS.

## Decisions

- The repository is the source of truth.
- VSCode Settings Sync is not required.
- Windows and macOS are primary targets.
- Linux support should be included through the Unix installer.
- The profile is general multi-language plus infra/devops.
- Web development frameworks are out of core scope.
- Neovim and Zsh integrations are out of scope, except for opening files from
  the terminal with `code`.
