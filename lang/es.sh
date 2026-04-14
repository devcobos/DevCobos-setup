# Español
readonly LANG_NAME="Español"

readonly MSG_INSTALLING_GUM="Instalando gum..."
readonly MSG_GUM_INSTALLED="gum instalado."

readonly MSG_INSTALLER_SUBTITLE="Configuración del entorno de desarrollo"

readonly MSG_MENU_HEADER="¿Qué quieres hacer?"
readonly MSG_MENU_SELECT="Seleccionar herramientas"
readonly MSG_MENU_INSTALL_ALL="Instalar todo"
readonly MSG_MENU_EXIT="Salir"

readonly MSG_SELECT_HEADER="Selecciona las herramientas a instalar  (espacio para marcar, enter para confirmar):"
readonly MSG_NOTHING_SELECTED="No seleccionaste nada."

readonly MSG_CONFIRM_INSTALL_ALL="¿Instalar todas las herramientas?"

readonly MSG_INSTALLING="Instalando"
readonly MSG_DONE="listo"
readonly MSG_FAILED="falló"
readonly MSG_SCRIPT_NOT_FOUND="Script no encontrado:"

readonly MSG_SUMMARY="Instalación completada"
readonly MSG_VIEW_FULL_LOG="¿Ver el log de error completo?"
readonly MSG_BYE="¡Hasta luego!"

# docker
readonly MSG_DOCKER_CONFIG_HEADER="Configuración de Docker"
readonly MSG_DOCKER_EXPOSE_TCP="¿Exponer Docker a Windows via TCP (puerto 2375)?"
readonly MSG_DOCKER_CONFIRM_YES="Sí"
readonly MSG_DOCKER_CONFIRM_NO="No"
readonly MSG_DOCKER_SYSTEMD_ENABLED="systemd ya está habilitado en"
readonly MSG_DOCKER_SYSTEMD_ENABLING="Habilitando systemd en"
readonly MSG_DOCKER_SYSTEMD_DONE="Listo. WSL debe reiniciarse para que systemd tome efecto."
readonly MSG_DOCKER_SYSTEMD_NOT_RUNNING="systemd no está ejecutándose en esta sesión de WSL."
readonly MSG_DOCKER_SYSTEMD_RESTART_HINT="Ejecuta 'wsl --shutdown' desde Windows, reabre Ubuntu y ejecuta el instalador de nuevo."
readonly MSG_DOCKER_INSTALLING="Instalando Docker..."
readonly MSG_DOCKER_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_DOCKER_GROUP_EXISTS="ya está en el grupo docker"
readonly MSG_DOCKER_GROUP_ADDING="Añadiendo al grupo docker..."
readonly MSG_DOCKER_GROUP_DONE="Listo. Se requiere re-login para aplicar la membresía del grupo."
readonly MSG_DOCKER_SERVICE_ENABLING="Habilitando servicio de Docker..."
readonly MSG_DOCKER_TCP_CONFIGURING="Configurando Docker daemon para acceso TCP..."
readonly MSG_DOCKER_TCP_DONE="Docker expuesto en tcp://0.0.0.0:2375"
readonly MSG_DOCKER_VERIFYING="Verificando Docker..."
readonly MSG_DOCKER_VERIFY_OK="Docker funciona correctamente."
readonly MSG_DOCKER_VERIFY_FAIL="Verificación fallida. Intenta re-loguearte en WSL."

# node inputs
readonly MSG_NODE_VERSION_HEADER="Versión de Node.js"
readonly MSG_NODE_VERSION_SELECT="  Selecciona la versión de Node.js:"
readonly MSG_NODE_PKG_HEADER="Gestor de paquetes"
readonly MSG_NODE_PKG_SELECT="  Selecciona el gestor de paquetes:"

# node + fnm
readonly MSG_UNZIP_INSTALLING="Instalando unzip..."
readonly MSG_FNM_INSTALLING="Instalando fnm..."
readonly MSG_FNM_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_FNM_ZSHRC="Añadido fnm init a ~/.zshrc"
readonly MSG_FNM_ZSHRC_EXISTS="fnm init ya está presente en ~/.zshrc"
readonly MSG_NODE_SKIP="Omitiendo instalación de Node.js"
readonly MSG_NODE_INSTALLING="Instalando Node.js"
readonly MSG_PNPM_INSTALLING="Instalando pnpm..."
readonly MSG_YARN_INSTALLING="Instalando yarn..."

# zsh + starship
readonly MSG_ZSH_INSTALLING="Instalando zsh..."
readonly MSG_ZSH_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_ZSH_DEFAULT_SHELL="Estableciendo zsh como shell por defecto..."
readonly MSG_ZSH_DEFAULT_SHELL_DONE="Listo. Reinicia el terminal para aplicar."
readonly MSG_ZSH_ALREADY_DEFAULT="zsh ya es el shell por defecto."
readonly MSG_STARSHIP_INSTALLING="Instalando starship..."
readonly MSG_STARSHIP_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_STARSHIP_BACKUP="Backup del starship.toml existente guardado"
readonly MSG_STARSHIP_CONFIG_DEPLOYED="starship.toml desplegado en ~/.config/starship.toml"
readonly MSG_ZSH_HISTORY_ADDED="Historial configurado en ~/.zshrc"
readonly MSG_ZSH_HISTORY_EXISTS="Historial ya configurado en ~/.zshrc"
readonly MSG_ZSH_AUTOSUGGESTIONS_INSTALLING="Instalando zsh-autosuggestions..."
readonly MSG_ZSH_AUTOSUGGESTIONS_INSTALLED="zsh-autosuggestions ya está instalado"
readonly MSG_ZSH_SYNTAX_INSTALLING="Instalando zsh-syntax-highlighting..."
readonly MSG_ZSH_SYNTAX_INSTALLED="zsh-syntax-highlighting ya está instalado"
readonly MSG_ZSH_PLUGINS_ADDED="Plugins añadidos a ~/.zshrc"
readonly MSG_ZSH_PLUGINS_EXISTS="Plugins ya presentes en ~/.zshrc"
readonly MSG_EZA_INSTALLING="Instalando eza..."
readonly MSG_EZA_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_EZA_ALIASES_ADDED="Alias de eza añadidos a ~/.zshrc"
readonly MSG_EZA_ALIASES_EXISTS="Alias de eza ya presentes en ~/.zshrc"
readonly MSG_STARSHIP_ZSHRC="Añadido starship init a ~/.zshrc"
readonly MSG_STARSHIP_ZSHRC_EXISTS="starship init ya está presente en ~/.zshrc"

# git
readonly MSG_GIT_CONFIG_HEADER="Configuración de Git"
readonly MSG_GIT_NAME_PLACEHOLDER="Tu nombre completo"
readonly MSG_GIT_NAME_PROMPT="  Nombre › "
readonly MSG_GIT_EMAIL_PLACEHOLDER="tu@email.com"
readonly MSG_GIT_EMAIL_PROMPT="  Email  › "
readonly MSG_GIT_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_GIT_INSTALLING="Instalando git..."
readonly MSG_GIT_CONFIG_SUMMARY="Configuración aplicada:"
readonly MSG_GIT_CONFIG_NAME="  Nombre :"
readonly MSG_GIT_CONFIG_EMAIL="  Email  :"
readonly MSG_GIT_CONFIG_EDITOR="  Editor :"

# summary table
readonly MSG_SUMMARY_TOOL="Herramienta"
readonly MSG_SUMMARY_VERSION="Versión"

# tool descriptions
readonly MSG_TOOL_GIT_DESC="Control de versiones"
readonly MSG_TOOL_ZSH_DESC="Shell y prompt"
readonly MSG_TOOL_NODE_DESC="Runtime de JavaScript + gestor de versiones"
readonly MSG_TOOL_DOCKER_DESC="Runtime de contenedores"
readonly MSG_TOOL_MAKE_DESC="Automatización de compilación"
readonly MSG_TOOL_AWS_DESC="CLI de Amazon Web Services"
readonly MSG_TOOL_TERRAFORM_DESC="Infraestructura como Código"
readonly MSG_TOOL_GH_DESC="GitHub CLI — PRs, issues y actions desde la terminal"
readonly MSG_TOOL_RIPGREP_DESC="Búsqueda ultrarrápida — sustituye a grep"
readonly MSG_TOOL_FD_DESC="Buscador de archivos rápido — sustituye a find"
readonly MSG_TOOL_BAT_DESC="Paginador con resaltado de sintaxis — sustituye a cat"

# make
readonly MSG_MAKE_INSTALLING="Instalando make..."
readonly MSG_MAKE_ALREADY_INSTALLED="Ya está instalado:"

# aws cli
readonly MSG_AWS_INSTALLING="Instalando AWS CLI v2..."
readonly MSG_AWS_ALREADY_INSTALLED="Ya está instalado:"

# terraform
readonly MSG_TERRAFORM_INSTALLING="Instalando Terraform..."
readonly MSG_TERRAFORM_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_TERRAFORM_AUTOCOMPLETE="Autocompletado de Terraform configurado"

# claude code
readonly MSG_CLAUDE_INSTALLING="Instalando Claude Code..."
readonly MSG_CLAUDE_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_TOOL_CLAUDE_DESC="CLI del asistente de programación con IA de Anthropic"

# gh
readonly MSG_GH_INSTALLING="Instalando GitHub CLI..."
readonly MSG_GH_ALREADY_INSTALLED="Ya está instalado:"

# ripgrep
readonly MSG_RIPGREP_INSTALLING="Instalando ripgrep..."
readonly MSG_RIPGREP_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_RIPGREP_ALIAS_ADDED="alias grep=\"rg\" añadido a ~/.zshrc"
readonly MSG_RIPGREP_ALIAS_EXISTS="Alias de ripgrep ya presente en ~/.zshrc"

# fd
readonly MSG_FD_INSTALLING="Instalando fd..."
readonly MSG_FD_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_FD_ALIAS_ADDED="Aliases find/fd añadidos a ~/.zshrc"
readonly MSG_FD_ALIAS_EXISTS="Aliases de fd ya presentes en ~/.zshrc"

# bat
readonly MSG_BAT_INSTALLING="Instalando bat..."
readonly MSG_BAT_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_BAT_ALIAS_ADDED="alias cat=\"bat\" añadido a ~/.zshrc"
readonly MSG_BAT_ALIAS_EXISTS="Alias de bat ya presente en ~/.zshrc"

# homebrew
readonly MSG_BREW_INSTALLING="Instalando Homebrew..."
readonly MSG_BREW_ALREADY_INSTALLED="Ya está instalado:"
readonly MSG_BREW_ZSHRC="Añadido Homebrew shellenv a ~/.zshrc"
readonly MSG_BREW_ZSHRC_EXISTS="Homebrew shellenv ya está presente en ~/.zshrc"
readonly MSG_TOOL_BREW_DESC="El gestor de paquetes que falta en Linux"
