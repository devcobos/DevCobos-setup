#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/config"

append_if_missing() {
  local file="$1" marker="$2" block="$3" msg_added="$4" msg_exists="$5"
  if ! grep -qF "$marker" "$file"; then
    printf '\n%s\n' "$block" >> "$file"
    echo "› $msg_added"
  else
    echo "› $msg_exists"
  fi
}

if ! command -v zsh &>/dev/null; then
  echo "› $MSG_ZSH_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y zsh
  echo "  $(zsh --version)"
else
  echo "› $MSG_ZSH_ALREADY_INSTALLED $(zsh --version)"
fi

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  echo "› $MSG_ZSH_DEFAULT_SHELL"
  sudo chsh -s "$(command -v zsh)" "$USER"
  echo "  $MSG_ZSH_DEFAULT_SHELL_DONE"
else
  echo "› $MSG_ZSH_ALREADY_DEFAULT"
fi

if ! command -v starship &>/dev/null; then
  echo "› $MSG_STARSHIP_INSTALLING"
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
  echo "  $(starship --version)"
else
  echo "› $MSG_STARSHIP_ALREADY_INSTALLED $(starship --version)"
fi

mkdir -p "$HOME/.config"

if [[ -f "$HOME/.config/starship.toml" ]]; then
  cp "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak"
  echo "› $MSG_STARSHIP_BACKUP"
fi

cp "$CONFIG_DIR/starship.toml" "$HOME/.config/starship.toml"
echo "› $MSG_STARSHIP_CONFIG_DEPLOYED"

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

HISTORY_BLOCK='# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY'

append_if_missing "$ZSHRC" "HISTFILE=~/.zsh_history" "$HISTORY_BLOCK" \
  "$MSG_ZSH_HISTORY_ADDED" "$MSG_ZSH_HISTORY_EXISTS"

ZSH_PLUGINS_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGINS_DIR"

if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
  echo "› $MSG_ZSH_AUTOSUGGESTIONS_INSTALLING"
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
else
  echo "› $MSG_ZSH_AUTOSUGGESTIONS_INSTALLED"
fi

if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
  echo "› $MSG_ZSH_SYNTAX_INSTALLING"
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
else
  echo "› $MSG_ZSH_SYNTAX_INSTALLED"
fi

PLUGINS_BLOCK='# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

append_if_missing "$ZSHRC" "zsh-autosuggestions.zsh" "$PLUGINS_BLOCK" \
  "$MSG_ZSH_PLUGINS_ADDED" "$MSG_ZSH_PLUGINS_EXISTS"

if ! command -v eza &>/dev/null; then
  echo "› $MSG_EZA_INSTALLING"

  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update -qq
  sudo apt-get install -y eza

  echo "  eza $(eza --version | head -1)"
else
  echo "› $MSG_EZA_ALREADY_INSTALLED eza $(eza --version | head -1)"
fi

EZA_BLOCK='# eza (modern ls)
alias ls="eza --icons"
alias ll="eza -lh --icons --git"
alias la="eza -lah --icons --git"
alias lt="eza --tree --icons --level=2"'

append_if_missing "$ZSHRC" 'alias ls="eza' "$EZA_BLOCK" \
  "$MSG_EZA_ALIASES_ADDED" "$MSG_EZA_ALIASES_EXISTS"

STARSHIP_INIT='eval "$(starship init zsh)"'

append_if_missing "$ZSHRC" "$STARSHIP_INIT" \
  "# Starship prompt
$STARSHIP_INIT" \
  "$MSG_STARSHIP_ZSHRC" "$MSG_STARSHIP_ZSHRC_EXISTS"
