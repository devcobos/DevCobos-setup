#!/usr/bin/env bash
set -euo pipefail

if ! command -v unzip &>/dev/null; then
  echo "› $MSG_UNZIP_INSTALLING"
  [[ "${APT_UPDATED:-0}" == "1" ]] || sudo apt-get update -qq
  sudo apt-get install -y unzip
fi

if ! command -v fnm &>/dev/null; then
  echo "› $MSG_FNM_INSTALLING"
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
  export PATH="$HOME/.local/bin:$PATH"
  echo "  fnm $(fnm --version)"
else
  echo "› $MSG_FNM_ALREADY_INSTALLED fnm $(fnm --version)"
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
  echo "› $MSG_FNM_ZSHRC"
else
  echo "› $MSG_FNM_ZSHRC_EXISTS"
fi

eval "$(fnm env --shell bash)"

NODE_VERSION="${NODE_VERSION:-lts-latest}"

if [[ "$NODE_VERSION" == "none" ]]; then
  echo "› $MSG_NODE_SKIP"
else
  echo "› $MSG_NODE_INSTALLING $NODE_VERSION..."
  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"
  fnm use "$NODE_VERSION"

  echo "  node $(node --version)"
  echo "  npm  $(npm --version)"

  case "${NODE_PKG_MANAGER:-npm}" in
    pnpm)
      echo "› $MSG_PNPM_INSTALLING"
      npm install -g pnpm
      echo "  pnpm $(pnpm --version)"
      ;;
    yarn)
      echo "› $MSG_YARN_INSTALLING"
      npm install -g yarn
      echo "  yarn $(yarn --version)"
      ;;
    npm)
      echo "› npm $(npm --version)"
      ;;
  esac
fi
