# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

An interactive Bash installer for WSL2 + Ubuntu developer environments. Users run `install.sh` and pick tools from an interactive menu powered by [gum](https://github.com/charmbracelet/gum).

## Running the installer

```bash
sudo -v && ./install.sh
# Override language:
./install.sh --lang es
./install.sh --lang en
```

There is no build or test step — the scripts run directly in a WSL2 Ubuntu environment.

## Architecture

**Entry point: `install.sh`**
- Bootstraps `gum` if missing
- Loads language strings from `lang/<code>.sh` (auto-detected from `$LANG`, overridden with `--lang`)
- Defines the `TOOLS` array (`"id|Name|Description"` format) — this controls the menu and install order
- Runs each selected tool's `scripts/<id>.sh` via `gum spin` (output captured to `/tmp/devcobos_install_<id>.log`)
- Collects user inputs (e.g. Git name/email, Node version) before spawning each install script via `collect_inputs_<id>()` functions — these run in the main shell to keep TTY access
- Passes collected inputs to scripts as exported env vars (e.g. `GIT_NAME`, `GIT_EMAIL`, `NODE_VERSION`, `NODE_PKG_MANAGER`, `DOCKER_EXPOSE_TCP`)
- `APT_UPDATED=1` is exported after the initial `apt-get update` so scripts can skip redundant updates

**Install scripts: `scripts/<id>.sh`**
- Each script is self-contained and idempotent (checks if tool is already installed before acting)
- Scripts read env vars set by `collect_inputs_*` in the main shell
- Output is captured to a log file; version strings must match the `extract_version()` regex patterns in `install.sh` to appear in the summary table

**Language files: `lang/<code>.sh`**
- All user-visible strings are `readonly` variables with the `MSG_` prefix
- Sourced with `set -a` so all variables are automatically exported to subshells

**Windows Terminal setup: `windows-terminal/`**
- Separate phase, run from PowerShell before the WSL installer
- `install-themes.ps1` patches `settings.json`; `install-starship.ps1` installs Starship for PowerShell

## Adding a new tool

1. Create `scripts/<id>.sh` (use existing scripts as reference — check `APT_UPDATED`, output version string)
2. If the tool needs user input: add `collect_inputs_<id>()` in `install.sh` before `collect_inputs()`
3. Register in the `TOOLS` array inside `init_tools()` in `install.sh`
4. Add a `case` entry in `extract_version()` in `install.sh` matching the version string your script outputs
5. Add all `MSG_` string keys to both `lang/en.sh` and `lang/es.sh`

## Key conventions

- Scripts use `set -euo pipefail` — any unhandled error aborts the script and marks the tool as failed
- The `append_if_missing` pattern in `zsh.sh` (check for a marker string, then append a block) is the standard way to make `.zshrc` modifications idempotent
- Theme colors (`C_PINK`, `C_LILAC`, etc.) in `install.sh` match the SynthWave palette in `config/starship.toml`
- Install order is determined by the `TOOLS` array in `init_tools()`, not by user selection order
