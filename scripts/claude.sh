#!/usr/bin/env bash
set -euo pipefail

if command -v claude &>/dev/null; then
  echo "› $MSG_CLAUDE_ALREADY_INSTALLED Claude Code $(claude --version | head -1)"
else
  echo "› $MSG_CLAUDE_INSTALLING"
  curl -fsSL https://claude.ai/install.sh | bash
  echo "  Claude Code $(claude --version | head -1)"
fi
