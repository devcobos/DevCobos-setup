#!/usr/bin/env bash
set -euo pipefail

if ! command -v git &>/dev/null; then
  echo "› $MSG_GIT_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y git
  echo "  $(git --version)"
else
  echo "› $MSG_GIT_ALREADY_INSTALLED $(git --version)"
fi

[[ -n "${GIT_NAME:-}"  ]] && git config --global user.name  "$GIT_NAME"
[[ -n "${GIT_EMAIL:-}" ]] && git config --global user.email "$GIT_EMAIL"

git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global pull.rebase false
git config --global core.editor "$(command -v nvim 2>/dev/null || command -v vim 2>/dev/null || command -v nano 2>/dev/null || echo "vi")"

echo ""
echo "$MSG_GIT_CONFIG_SUMMARY"
echo "$MSG_GIT_CONFIG_NAME $(git config --global user.name)"
echo "$MSG_GIT_CONFIG_EMAIL $(git config --global user.email)"
echo "$MSG_GIT_CONFIG_EDITOR $(git config --global core.editor)"
