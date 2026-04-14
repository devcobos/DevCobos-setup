#!/usr/bin/env bash
set -euo pipefail

if command -v gh &>/dev/null; then
  echo "› $MSG_GH_ALREADY_INSTALLED $(gh --version | head -1)"
else
  echo "› $MSG_GH_INSTALLING"

  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y curl gpg

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

  sudo apt-get update -qq  # refresh after adding the GitHub source
  sudo apt-get install -y gh

  echo "  $(gh --version | head -1)"
fi
