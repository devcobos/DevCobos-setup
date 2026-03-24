#!/usr/bin/env bash
set -euo pipefail

if ! command -v make &>/dev/null; then
  echo "› $MSG_MAKE_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y make
  echo "  $(make --version | head -1)"
else
  echo "› $MSG_MAKE_ALREADY_INSTALLED $(make --version | head -1)"
fi
