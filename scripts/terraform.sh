#!/usr/bin/env bash
set -euo pipefail

if command -v terraform &>/dev/null; then
  echo "› $MSG_TERRAFORM_ALREADY_INSTALLED $(terraform --version | head -1)"
else
  echo "› $MSG_TERRAFORM_INSTALLING"

  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y gnupg software-properties-common

  wget -qO- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com \
$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -y terraform

  echo "  $(terraform --version | head -1)"
fi

# Enable autocomplete (silently skip if already configured)
terraform -install-autocomplete 2>/dev/null || true
echo "› $MSG_TERRAFORM_AUTOCOMPLETE"
