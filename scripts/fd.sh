#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib.sh
source "${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/scripts/lib.sh" 2>/dev/null \
  || source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if command -v fdfind &>/dev/null || command -v fd &>/dev/null; then
  FD_BIN=$(command -v fdfind 2>/dev/null || command -v fd)  # Ubuntu ships fd as fdfind
  echo "› $MSG_FD_ALREADY_INSTALLED $($FD_BIN --version)"
else
  echo "› $MSG_FD_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y fd-find
  FD_BIN=$(command -v fdfind 2>/dev/null || command -v fd)
  echo "  $($FD_BIN --version)"
fi

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

FD_BLOCK="# fd (replaces find)
alias find=\"$FD_BIN\"
alias fd=\"$FD_BIN\""

append_if_missing "$ZSHRC" '# fd (replaces find)' "$FD_BLOCK" \
  "$MSG_FD_ALIAS_ADDED" "$MSG_FD_ALIAS_EXISTS"

echo ""
echo "  $($FD_BIN --version)"
