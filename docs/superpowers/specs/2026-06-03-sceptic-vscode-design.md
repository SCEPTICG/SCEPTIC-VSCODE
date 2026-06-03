# Diseno de SCEPTIC-VSCODE

Fecha: 2026-06-03

## Proposito

SCEPTIC-VSCODE es un perfil standalone y reproducible de Visual Studio Code
para trabajo general multi-lenguaje y tareas de infraestructura/devops. El
repositorio es la fuente de verdad del perfil. VSCode Settings Sync puede
existir en una maquina, pero no forma parte de este diseno y no debe ser
necesario para una instalacion limpia.

El perfil es independiente de las configuraciones existentes de Neovim y Zsh.
La unica integracion intencional con la terminal es poder abrir archivos o
carpetas con el comando `code` cuando VSCode lo exponga.

## Alcance

El perfil cubre:

- Ajustes de usuario.
- Atajos de teclado.
- Snippets.
- Listas de extensiones.
- Configuracion especifica por lenguaje.
- Valores por defecto de formato y linting cuando la herramienta o extension
  necesaria este clara.
- Rutas de instalacion para Windows, macOS y Linux.
- Scripts de instalacion idempotentes con backups.
- Scripts doctor para validacion.
- Scripts de exportacion para capturar la configuracion local actual de VSCode.

El perfil no tiene como objetivo principal el desarrollo de aplicaciones web.
React, Vite, Next.js, Tailwind y herramientas similares no son dependencias
centrales. La edicion basica de HTML, CSS, JavaScript y TypeScript puede seguir
soportada mediante los valores por defecto de VSCode o extensiones generales,
pero no debe dominar la configuracion.

## Estructura del repositorio

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

`config/User/` refleja los archivos de configuracion de usuario que se copiaran
al directorio de configuracion de VSCode. Los archivos de extensiones son listas
de texto plano con un identificador de extension por linea, para que sean
faciles de auditar e instalar con la CLI `code`.

## Plataformas objetivo

El instalador debe soportar Windows y macOS como sistemas principales, con Linux
cubierto mediante el mismo instalador tipo Unix cuando sea posible.

Rutas esperadas de configuracion de usuario de VSCode:

- Windows: `%APPDATA%\Code\User`
- macOS: `~/Library/Application Support/Code/User`
- Linux: `~/.config/Code/User`

Los scripts deben detectar la plataforma y fallar con un mensaje claro cuando
no puedan determinar la ruta destino.

## Contenido del perfil

El perfil debe ser sobrio, duradero y util para trabajo tecnico repetido. Debe
preferir valores claros por defecto por encima de personalizacion decorativa.

Lenguajes y tipos de archivo principales:

- Python.
- PowerShell.
- Bash y scripts shell.
- JSON y JSONC.
- YAML.
- TOML.
- Markdown.
- Dockerfile y Docker Compose.
- Terraform y HCL.
- Archivos de configuracion e ignore de Git.

Los ajustes deben cubrir:

- Legibilidad del editor.
- Autosave razonable.
- Reduccion de ruido en el explorador.
- Usabilidad de la terminal integrada.
- Visibilidad de Git.
- Comodidad al editar Markdown.
- Valores de formato/linting especificos por lenguaje.
- Minimo ruido visual.

Los atajos de teclado deben ser pocos, memorables y no inspirados en Vim. Deben
priorizar abrir la terminal, usar la paleta de comandos, formatear, buscar y
moverse entre paneles.

Los snippets deben aportar plantillas practicas para:

- Secciones de README.
- Scripts PowerShell.
- Scripts Bash.
- Entradas CLI minimas en Python.
- Bases de Docker Compose.
- Bloques YAML usados en flujos de infraestructura/devops.

## Extensiones

Las extensiones se dividen en tres listas:

- `core.txt`: esenciales generales para todo el perfil.
- `infra.txt`: extensiones de infraestructura/devops.
- `optional.txt`: extras utiles instalados solo cuando se soliciten.

El conjunto de extensiones debe ser conservador y auditable. Hay que evitar
packs grandes de extensiones salvo que exista una razon fuerte. Cada extension
incluida en las listas principales debe documentarse en el README con un motivo
breve.

Categorias probables para core e infra:

- Python y Pylance.
- PowerShell.
- YAML.
- Docker.
- Dev Containers.
- Remote SSH.
- Mejora de Git.
- Herramientas de Markdown.
- EditorConfig.
- Integracion con ShellCheck.
- Soporte Terraform/HCL.

## Instaladores

`install.ps1` e `install.sh` deben compartir el mismo contrato visible para el
usuario:

```text
--dry-run          muestra acciones previstas sin cambiar archivos
--no-extensions    aplica configuracion pero no instala extensiones
--with-optional    instala tambien extensions/optional.txt
--force            aplica aunque se detecten diferencias locales
```

Comportamiento del instalador:

- Detectar sistema operativo y ruta de configuracion de usuario de VSCode.
- Comprobar si el comando `code` existe en `PATH`.
- Aplicar archivos de configuracion aunque `code` no este disponible.
- Mostrar instrucciones claras cuando falte `code`.
- Hacer backup de `settings.json`, `keybindings.json` y `snippets/` antes de
  reemplazarlos.
- Copiar archivos desde `config/User/` a la ruta de usuario detectada.
- Instalar extensiones con `code --install-extension`.
- Evitar reinstalar extensiones cuando se puedan detectar las ya instaladas.
- Mantener ejecuciones repetidas seguras y predecibles.

Los backups deben incluir timestamp, por ejemplo:

```text
settings.json.backup.20260603123000
keybindings.json.backup.20260603123000
snippets.backup.20260603123000
```

## Scripts doctor

`scripts/doctor.ps1` y `scripts/doctor.sh` deben inspeccionar el entorno local
sin cambiarlo.

Deben informar de:

- Sistema operativo detectado.
- Ruta de configuracion de usuario de VSCode detectada.
- Si el comando `code` esta disponible.
- Version de VSCode cuando este disponible.
- Numero de extensiones instaladas cuando este disponible.
- Si los archivos esperados del perfil existen en la ruta destino.
- Herramientas externas recomendadas que falten y que el README declare como
  utiles.

## Scripts de exportacion

`scripts/export-current.ps1` y `scripts/export-current.sh` deben ayudar a
capturar una configuracion local de VSCode para revisarla. Deben copiar los
ajustes de usuario, atajos, snippets e identificadores de extensiones instaladas
a un directorio de exportacion, sin sobrescribir automaticamente el perfil del
repo.

El flujo de exportacion sirve para migracion y revision, no para sincronizacion
ciega.

## Documentacion

`README.md` debe incluir:

- Proposito y alcance.
- Comandos de instalacion para Windows, macOS y Linux.
- Flags soportados.
- Estructura del repositorio.
- Lista de extensiones con motivos breves.
- Como re-aplicar el perfil.
- Como restaurar backups.
- Como confirmar que `code archivo` o `code .` funcionan desde terminal.
- Notas que expliquen que este perfil es independiente de Neovim y Zsh.

Toda la documentacion, mensajes visibles de scripts y comentarios orientados al
usuario deben escribirse en castellano. Se mantienen en ingles solo nombres
tecnicos, identificadores de VSCode, comandos, flags, rutas y convenciones del
ecosistema cuando traducirlos reste claridad.

## Verificacion

La verificacion inicial debe incluir:

- Ejecutar cada instalador con `--dry-run`.
- Validar archivos JSON/JSONC cuando sea practico.
- Comprobar que existen los archivos esperados.
- Ejecutar scripts doctor tras la instalacion.

El plan de implementacion debe mantener la validacion ligera pero real. El
objetivo es detectar rutas rotas, archivos de configuracion mal formados y
comportamiento ausente en scripts antes de usar el perfil en Windows o macOS.

## Decisiones

- El repositorio es la fuente de verdad.
- VSCode Settings Sync no es necesario.
- Windows y macOS son objetivos principales.
- Linux debe estar soportado mediante el instalador Unix.
- El perfil es general multi-lenguaje mas infraestructura/devops.
- Los frameworks de desarrollo web quedan fuera del nucleo.
- Las integraciones con Neovim y Zsh quedan fuera de alcance, excepto abrir
  archivos desde la terminal con `code`.
- La documentacion del proyecto se escribe en castellano.
