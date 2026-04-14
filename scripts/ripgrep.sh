#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=lib.sh
source "${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}/scripts/lib.sh" 2>/dev/null \
  || source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if command -v rg &>/dev/null; then
  RG_VER=$(rg --version | head -1)
  echo "› $MSG_RIPGREP_ALREADY_INSTALLED $RG_VER"
else
  echo "› $MSG_RIPGREP_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y ripgrep
  RG_VER=$(rg --version | head -1)
  echo "  $RG_VER"
fi

ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

RG_BLOCK='# ripgrep (replaces grep)
alias grep="rg"'

append_if_missing "$ZSHRC" '# ripgrep (replaces grep)' "$RG_BLOCK" \
  "$MSG_RIPGREP_ALIAS_ADDED" "$MSG_RIPGREP_ALIAS_EXISTS"

echo ""
echo "  $RG_VER"
