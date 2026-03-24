#!/usr/bin/env bash
set -euo pipefail

if command -v aws &>/dev/null; then
  echo "› $MSG_AWS_ALREADY_INSTALLED $(aws --version 2>&1)"
else
  echo "› $MSG_AWS_INSTALLING"

  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y unzip curl

  local_tmp=$(mktemp -d)
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "$local_tmp/awscliv2.zip"
  unzip -qo "$local_tmp/awscliv2.zip" -d "$local_tmp"
  sudo "$local_tmp/aws/install"
  rm -rf "$local_tmp"

  echo "  $(aws --version 2>&1)"
fi
