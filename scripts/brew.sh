#!/usr/bin/env bash
set -euo pipefail

ZSHRC="$HOME/.zshrc"
BREW_MARKER="# homebrew"

if command -v brew &>/dev/null; then
  echo "› $MSG_BREW_ALREADY_INSTALLED $(brew --version | head -1)"
else
  echo "› $MSG_BREW_INSTALLING"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for this script session
  if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  echo "  $(brew --version | head -1)"
fi

# Add brew shellenv to .zshrc
if ! grep -qF "$BREW_MARKER" "$ZSHRC" 2>/dev/null; then
  {
    printf '\n%s\n' "$BREW_MARKER"
    printf 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"\n'
  } >> "$ZSHRC"
  echo "› $MSG_BREW_ZSHRC"
else
  echo "› $MSG_BREW_ZSHRC_EXISTS"
fi
