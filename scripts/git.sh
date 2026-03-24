#!/usr/bin/env bash
set -euo pipefail

if ! command -v git &>/dev/null; then
  log_info "$MSG_GIT_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y git
  log_info "$(git --version)"
else
  log_info "$MSG_GIT_ALREADY_INSTALLED $(git --version)"
fi

[[ -n "${GIT_NAME:-}"  ]] && git config --global user.name  "$GIT_NAME"
[[ -n "${GIT_EMAIL:-}" ]] && git config --global user.email "$GIT_EMAIL"

git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global pull.rebase false
git config --global core.editor "$(command -v nvim 2>/dev/null || command -v vim 2>/dev/null || command -v nano 2>/dev/null || echo "vi")"

echo ""
log_info "$MSG_GIT_CONFIG_SUMMARY"
log_info "$MSG_GIT_CONFIG_NAME $(git config --global user.name)"
log_info "$MSG_GIT_CONFIG_EMAIL $(git config --global user.email)"
log_info "$MSG_GIT_CONFIG_EDITOR $(git config --global core.editor)"
