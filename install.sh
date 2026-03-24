#!/usr/bin/env bash
set -euo pipefail

declare -rx SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -rx SCRIPTS_DIR="$SCRIPT_DIR/scripts"
declare -rx LANG_DIR="$SCRIPT_DIR/lang"

# Colors (used before gum is available)
readonly YELLOW='\033[1;33m'
readonly GREEN='\033[0;32m'
readonly RESET='\033[0m'

# Theme (matches starship.toml palette)
readonly C_PINK="#ff7edb"
readonly C_LILAC="#b893ce"
readonly C_MINT="#72f1b8"
readonly C_YELLOW="#fede5d"
readonly C_CYAN="#03edf9"
readonly C_RED="#ff5555"
readonly C_DIM="#666666"

INSTALL_RESULTS=()
INSTALL_VERSIONS=()
INSTALL_ORDER=()
LANG_OVERRIDE=""

# Structured logging helpers (available after gum is installed)
log_info()  { gum log --level info  --prefix "setup" "$@"; }
log_warn()  { gum log --level warn  --prefix "setup" "$@"; }
log_error() { gum log --level error --prefix "setup" "$@"; }
export -f log_info log_warn log_error

show_help() {
  local help_text
  help_text=$(cat << 'HELPEOF'
# DevCobos-setup

Interactive development environment installer for **WSL2 + Ubuntu**.

## Usage

```bash
./install.sh              # Interactive mode
./install.sh --lang es    # Force Spanish
./install.sh --help       # This help
```

## Available Tools

| Tool | Description |
|------|-------------|
| Git | Version control + global config |
| Zsh + Starship | Shell, prompt, plugins, eza |
| Node.js (fnm) | JavaScript runtime + version manager |
| Docker | Container runtime + WSL systemd |

## Requirements

- WSL2 with Ubuntu
- `sudo` privileges
- Internet connection
HELPEOF
  )

  if command -v gum &>/dev/null; then
    echo "$help_text" | gum format
  else
    echo "$help_text"
  fi
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h) show_help; exit 0 ;;
      --lang)    LANG_OVERRIDE="$2"; shift 2 ;;
      --lang=*)  LANG_OVERRIDE="${1#--lang=}"; shift ;;
      *)         shift ;;
    esac
  done
}

load_language() {
  local lang_code="${LANG_OVERRIDE:-${LANG%%_*}}"
  local lang_file="$LANG_DIR/${lang_code}.sh"

  set -a
  if [[ -f "$lang_file" ]]; then
    # shellcheck source=/dev/null
    source "$lang_file"
  else
    # shellcheck source=lang/en.sh
    source "$LANG_DIR/en.sh"
  fi
  set +a
}

bootstrap_gum() {
  command -v gum &>/dev/null && return

  printf "${YELLOW}%s${RESET}\n" "$MSG_INSTALLING_GUM"

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" \
    | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt-get update -qq
  sudo apt-get install -y gum

  printf "${GREEN}%s${RESET}\n" "$MSG_GUM_INSTALLED"
}

show_logo() {
  clear
  printf '\033[38;2;255;255;255m'
  cat << 'EOF'
 ██████████                          █████████           █████
░░███░░░░███                        ███░░░░░███         ░░███
 ░███   ░░███  ██████  █████ █████ ███     ░░░   ██████  ░███████   ██████   █████
 ░███    ░███ ███░░███░░███ ░░███ ░███          ███░░███ ░███░░███ ███░░███ ███░░
 ░███    ░███░███████  ░███  ░███ ░███         ░███ ░███ ░███ ░███░███ ░███░░█████
 ░███    ███ ░███░░░   ░░███ ███  ░░███     ███░███ ░███ ░███ ░███░███ ░███ ░░░░███
 ██████████  ░░██████   ░░█████    ░░█████████ ░░██████  ████████ ░░██████  ██████
░░░░░░░░░░    ░░░░░░     ░░░░░      ░░░░░░░░░   ░░░░░░  ░░░░░░░░   ░░░░░░  ░░░░░░
EOF
  printf '\033[0m\n'

  gum style \
    --foreground "$C_LILAC" \
    --align center --width 80 \
    --margin "1 0" \
    --border-foreground "$C_LILAC" \
    --border double \
    "$MSG_INSTALLER_SUBTITLE"
}

# Format: "id|Name|Description"
init_tools() {
  TOOLS=(
    "git|Git|$MSG_TOOL_GIT_DESC"
    "zsh|Zsh + Starship|$MSG_TOOL_ZSH_DESC"
    "node|Node.js (fnm)|$MSG_TOOL_NODE_DESC"
    "docker|Docker|$MSG_TOOL_DOCKER_DESC"
  )
}

tool_id()   { echo "${1}" | cut -d'|' -f1; }
tool_name() { echo "${1}" | cut -d'|' -f2; }
tool_desc() { echo "${1}" | cut -d'|' -f3; }

# Collect inputs in main shell to guarantee TTY access
collect_inputs_git() {
  echo ""
  gum style \
    --foreground "$C_PINK" \
    --border-foreground "$C_LILAC" \
    --border normal \
    --padding "0 2" \
    --bold \
    "$MSG_GIT_CONFIG_HEADER"
  echo ""

  GIT_NAME=$(gum input \
    --placeholder "$MSG_GIT_NAME_PLACEHOLDER" \
    --prompt "$MSG_GIT_NAME_PROMPT" \
    --prompt.foreground "$C_CYAN" \
    --cursor.foreground "$C_LILAC" \
    --width 50 \
    --value "$(git config --global user.name 2>/dev/null || true)")

  GIT_EMAIL=$(gum input \
    --placeholder "$MSG_GIT_EMAIL_PLACEHOLDER" \
    --prompt "$MSG_GIT_EMAIL_PROMPT" \
    --prompt.foreground "$C_CYAN" \
    --cursor.foreground "$C_LILAC" \
    --width 50 \
    --value "$(git config --global user.email 2>/dev/null || true)")

  export GIT_NAME GIT_EMAIL
}

collect_inputs_node() {
  echo ""
  gum style \
    --foreground "$C_PINK" \
    --border-foreground "$C_LILAC" \
    --border normal \
    --padding "0 2" \
    --bold \
    "$MSG_NODE_VERSION_HEADER"
  echo ""

  NODE_VERSION=$(gum choose \
    --header "$MSG_NODE_VERSION_SELECT" \
    --header.foreground "$C_CYAN" \
    --cursor "→ " \
    --cursor.foreground "$C_LILAC" \
    --selected.foreground "$C_PINK" \
    --item.foreground "$C_DIM" \
    "24" "22" "20" "none")

  if [[ "$NODE_VERSION" != "none" ]]; then
    echo ""
    gum style \
      --foreground "$C_PINK" \
      --border-foreground "$C_LILAC" \
      --border normal \
      --padding "0 2" \
      --bold \
      "$MSG_NODE_PKG_HEADER"
    echo ""

    NODE_PKG_MANAGER=$(gum choose \
      --header "$MSG_NODE_PKG_SELECT" \
      --header.foreground "$C_CYAN" \
      --cursor "→ " \
      --cursor.foreground "$C_LILAC" \
      --selected.foreground "$C_PINK" \
      --item.foreground "$C_DIM" \
      "npm" "pnpm" "yarn")
  fi

  export NODE_VERSION NODE_PKG_MANAGER
}

collect_inputs_docker() {
  echo ""
  gum style \
    --foreground "$C_PINK" \
    --border-foreground "$C_LILAC" \
    --border normal \
    --padding "0 2" \
    --bold \
    "$MSG_DOCKER_CONFIG_HEADER"
  echo ""

  if gum confirm \
    --affirmative "$MSG_DOCKER_CONFIRM_YES" \
    --negative "$MSG_DOCKER_CONFIRM_NO" \
    --default=no \
    "  $MSG_DOCKER_EXPOSE_TCP"; then
    DOCKER_EXPOSE_TCP="true"
  else
    DOCKER_EXPOSE_TCP="false"
  fi

  export DOCKER_EXPOSE_TCP
}

collect_inputs() {
  local fn="collect_inputs_${1}"
  if declare -f "$fn" > /dev/null; then "$fn"; fi
}

extract_version() {
  local id="$1" log_file="$2"
  [[ -f "$log_file" ]] || { echo "--"; return; }
  local ver
  case "$id" in
    git)    ver=$(grep -oP 'git version \K[\d.]+' "$log_file" | tail -1) ;;
    zsh)    ver=$(grep -oP 'zsh \K[\d.]+' "$log_file" | tail -1) ;;
    node)   ver=$(grep -oP 'node v\K[\d.]+' "$log_file" | tail -1) ;;
    docker) ver=$(grep -oP 'Docker version \K[\d.]+' "$log_file" | tail -1) ;;
    *)      ver="" ;;
  esac
  echo "${ver:---}"
}

run_install() {
  local id="$1"
  local name="$2"
  local script="$SCRIPTS_DIR/${id}.sh"

  if [[ ! -f "$script" ]]; then
    gum style --foreground "$C_RED" "  $MSG_SCRIPT_NOT_FOUND $script"
    return 1
  fi

  echo ""
  gum style --foreground "$C_PINK" --bold "▶ $name"

  collect_inputs "$id"

  local log_file="/tmp/devcobos_install_${id}.log"

  if gum spin \
       --spinner dot \
       --spinner.foreground "$C_CYAN" \
       --title "  $MSG_INSTALLING $name..." \
       --title.foreground "$C_LILAC" \
       -- bash -c 'bash "$1" > "$2" 2>&1' _ "$script" "$log_file"; then
    local version
    version=$(extract_version "$id" "$log_file")

    INSTALL_RESULTS+=("$name:success")
    INSTALL_VERSIONS+=("$name:$version")
    INSTALL_ORDER+=("$name")

    gum style --foreground "$C_MINT" "  ✓ $name $MSG_DONE"
  else
    INSTALL_RESULTS+=("$name:failed")
    INSTALL_VERSIONS+=("$name:--")
    INSTALL_ORDER+=("$name")

    gum style --foreground "$C_RED" "  ✗ $name $MSG_FAILED"

    if [[ -f "$log_file" ]]; then
      if gum confirm --default=no "$MSG_VIEW_FULL_LOG"; then
        gum pager --border-foreground "$C_PINK" < "$log_file"
      else
        tail -3 "$log_file" | while IFS= read -r line; do
          gum style --foreground "$C_DIM" "    $line"
        done
      fi
    fi
  fi

  rm -f "$log_file"
}

select_tools() {
  local options=()
  for tool in "${TOOLS[@]}"; do
    options+=("$(tool_name "$tool") — $(tool_desc "$tool")")
  done

  gum choose --no-limit \
    --header "$MSG_SELECT_HEADER" \
    --header.foreground "$C_CYAN" \
    --cursor "→ " \
    --cursor.foreground "$C_LILAC" \
    --selected.foreground "$C_PINK" \
    --item.foreground "$C_DIM" \
    --selected-prefix "◉ " \
    --unselected-prefix "◯ " \
    --height 8 \
    "${options[@]}"
}

install_selected() {
  local selected=("$@")

  # Iterate TOOLS order to guarantee install sequence (e.g. zsh before node)
  for tool in "${TOOLS[@]}"; do
    local name
    name="$(tool_name "$tool")"

    for line in "${selected[@]}"; do
      if [[ "${line%% —*}" == "$name" ]]; then
        run_install "$(tool_id "$tool")" "$name"
        break
      fi
    done
  done
}

install_all() {
  for tool in "${TOOLS[@]}"; do
    run_install "$(tool_id "$tool")" "$(tool_name "$tool")"
  done
}

main_menu() {
  local opt_select="$MSG_MENU_SELECT"
  local opt_all="$MSG_MENU_INSTALL_ALL"
  local opt_exit="$MSG_MENU_EXIT"

  while true; do
    local choice
    choice=$(gum choose \
      --header "$MSG_MENU_HEADER"$'\n' \
      --header.foreground "$C_CYAN" \
      --cursor "→ " \
      --cursor.foreground "$C_LILAC" \
      --selected.foreground "$C_PINK" \
      --item.foreground "$C_DIM" \
      --height 6 \
      "$opt_select" \
      "$opt_all" \
      "$opt_exit")

    case "$choice" in
      "$opt_select")
        local selected
        mapfile -t selected < <(select_tools)

        if [[ ${#selected[@]} -eq 0 ]]; then
          gum style --foreground "$C_YELLOW" "  $MSG_NOTHING_SELECTED"
          sleep 1
          show_logo
          continue
        fi

        install_selected "${selected[@]}"
        break
        ;;
      "$opt_all")
        if gum confirm \
          --affirmative "$MSG_DOCKER_CONFIRM_YES" \
          --negative "$MSG_DOCKER_CONFIRM_NO" \
          --default=yes \
          "  $MSG_CONFIRM_INSTALL_ALL"; then
          install_all
          break
        else
          show_logo
          continue
        fi
        ;;
      "$opt_exit"|"")
        echo ""
        gum style --foreground "$C_PINK" "  $MSG_BYE"
        exit 0
        ;;
    esac
  done
}

show_summary() {
  [[ ${#INSTALL_ORDER[@]} -eq 0 ]] && return

  show_logo

  gum style \
    --foreground "$C_MINT" \
    --border-foreground "$C_PINK" \
    --border rounded \
    --align center \
    --width 50 \
    --padding "1 2" \
    "$MSG_SUMMARY"

  local csv="Status,$MSG_SUMMARY_TOOL,$MSG_SUMMARY_VERSION"
  for entry in "${INSTALL_ORDER[@]}"; do
    local status="?" version="--"

    for r in "${INSTALL_RESULTS[@]}"; do
      [[ "$r" == "$entry:success" ]] && { status="✓"; break; }
      [[ "$r" == "$entry:failed" ]]  && { status="✗"; break; }
    done

    for v in "${INSTALL_VERSIONS[@]}"; do
      [[ "$v" == "$entry:"* ]] && { version="${v#*:}"; break; }
    done

    csv+=$'\n'"$status,$entry,$version"
  done

  echo "$csv" | gum table \
    --border.foreground "$C_PINK" \
    --cell.foreground "$C_MINT" \
    --header.foreground "$C_CYAN"

  echo ""
}

parse_args "$@"
load_language
init_tools
bootstrap_gum
sudo apt-get update -qq
export APT_UPDATED=1
show_logo
main_menu
show_summary
