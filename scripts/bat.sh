#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib.sh
source "${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/scripts/lib.sh" 2>/dev/null \
  || source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if command -v batcat &>/dev/null || command -v bat &>/dev/null; then
  BAT_BIN=$(command -v batcat 2>/dev/null || command -v bat)  # Ubuntu ships bat as batcat
  echo "› $MSG_BAT_ALREADY_INSTALLED $($BAT_BIN --version)"
else
  echo "› $MSG_BAT_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y bat
  BAT_BIN=$(command -v batcat 2>/dev/null || command -v bat)
  echo "  $($BAT_BIN --version)"
fi

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

BAT_BLOCK="# bat (replaces cat)
alias cat=\"$BAT_BIN\""

append_if_missing "$ZSHRC" '# bat (replaces cat)' "$BAT_BLOCK" \
  "$MSG_BAT_ALIAS_ADDED" "$MSG_BAT_ALIAS_EXISTS"

echo ""
echo "  $($BAT_BIN --version)"
