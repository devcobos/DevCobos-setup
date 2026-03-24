#!/usr/bin/env bash
set -euo pipefail

if ! command -v unzip &>/dev/null; then
  log_info "$MSG_UNZIP_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y unzip
fi

if ! command -v fnm &>/dev/null; then
  log_info "$MSG_FNM_INSTALLING"
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
  export PATH="$HOME/.local/bin:$PATH"
  log_info "fnm $(fnm --version)"
else
  log_info "$MSG_FNM_ALREADY_INSTALLED fnm $(fnm --version)"
fi

ZSHRC="$HOME/.zshrc"
FNM_BLOCK='# fnm
export PATH="$HOME/.local/bin:$PATH"
if [[ -n "${XDG_RUNTIME_DIR:-}" ]] && ! mkdir -p "$XDG_RUNTIME_DIR/fnm_multishells" 2>/dev/null; then
  export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
  mkdir -p "$XDG_RUNTIME_DIR/fnm_multishells"
fi
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"'

if ! grep -qF "fnm env" "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' "$FNM_BLOCK" >> "$ZSHRC"
  log_info "$MSG_FNM_ZSHRC"
else
  log_info "$MSG_FNM_ZSHRC_EXISTS"
fi

eval "$(fnm env --shell bash)"

NODE_VERSION="${NODE_VERSION:-lts-latest}"

if [[ "$NODE_VERSION" == "none" ]]; then
  log_info "$MSG_NODE_SKIP"
else
  log_info "$MSG_NODE_INSTALLING $NODE_VERSION..."
  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"
  fnm use "$NODE_VERSION"

  log_info "node $(node --version)"
  log_info "npm  $(npm --version)"

  case "${NODE_PKG_MANAGER:-npm}" in
    pnpm)
      log_info "$MSG_PNPM_INSTALLING"
      npm install -g pnpm
      log_info "pnpm $(pnpm --version)"
      ;;
    yarn)
      log_info "$MSG_YARN_INSTALLING"
      npm install -g yarn
      log_info "yarn $(yarn --version)"
      ;;
    npm)
      log_info "npm $(npm --version)"
      ;;
  esac
fi
