# DevCobos-setup

Interactive development environment installer for WSL2 + Ubuntu.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform: WSL2](https://img.shields.io/badge/platform-WSL2%20%2B%20Ubuntu%2022.04%2B-orange.svg)](https://learn.microsoft.com/en-us/windows/wsl/)
[![Shell: Bash](https://img.shields.io/badge/shell-bash-89e051.svg)](https://www.gnu.org/software/bash/)

---

## Table of Contents

- [What you'll get](#what-youll-get)
- [Setup order](#setup-order)
- [Requirements](#requirements)
- [Usage](#usage)
- [Tools](#tools)
- [Language](#language)
- [Project structure](#project-structure)
- [Adding a tool](#adding-a-tool)
- [Troubleshooting](#troubleshooting)

---

## What you'll get

A fully configured WSL2 developer environment with:

- **Zsh** as your default shell with autosuggestions and syntax highlighting
- **Starship** prompt with the **SynthWave** theme
- **Git** pre-configured with your name, email, and sensible defaults
- **Node.js** managed via `fnm` with your choice of version and package manager
- **Docker** with systemd support and optional TCP exposure for Windows Docker Desktop
- **Windows Terminal** themed with Tokyo Night (PowerShell) and SynthWave (Ubuntu WSL)

---

## Setup order

> The setup has two phases. Complete them in order.

**Phase 1 — Windows side** (PowerShell) → [windows-terminal/README.md](windows-terminal/README.md)

1. Install Windows Terminal
2. Install a Nerd Font
3. Install color schemes
4. Install Starship for PowerShell

**Phase 2 — WSL side** (Ubuntu/Bash) → [Usage section](#usage)

5. Clone this repo
6. Run `install.sh`
7. Select your tools

---

## Requirements

**Phase 1 — Windows Terminal** (complete before Phase 2):
- Windows Terminal — [setup guide](windows-terminal/README.md)
- FiraCode Nerd Font or any other [Nerd Font](https://www.nerdfonts.com/font-downloads)

**Phase 2 — WSL**:
- WSL2 with Ubuntu 22.04+
- `curl`
- `sudo` access

> `gum` (the interactive menu library) is installed automatically on first run.

---

## Usage

**Clone and run:**

```bash
git clone https://github.com/devcobos/DevCobos-setup.git ~/DevCobos-setup
sudo -v && ~/DevCobos-setup/install.sh
```

**Or if already cloned:**

```bash
sudo -v && ~/DevCobos-setup/install.sh
```

The installer will:
1. Ask which tools you want to install
2. Collect any required inputs (Git name/email, Node version, etc.)
3. Install and configure each tool with a progress indicator
4. Show a summary of results when done

---

## Tools

| Tool | Description |
| --- | --- |
| Git | Version control + global config (name, email, branch, editor) |
| Zsh + Starship | Zsh shell with SynthWave prompt, autosuggestions, syntax highlighting, and `eza` aliases |
| Node.js (fnm) | JavaScript runtime via `fnm` version manager + choice of npm, pnpm, or yarn |
| Docker | Container runtime with WSL systemd + optional TCP exposure for Windows Docker Desktop |
| Make | GNU Make build tool |
| AWS CLI | AWS Command Line Interface v2 |
| Terraform | HashiCorp Terraform IaC tool with autocomplete |
| [Windows Terminal](windows-terminal/README.md) | Color schemes, Nerd Font, and Starship for PowerShell |

---

## Language

Auto-detected from `$LANG`. Override with `--lang`:

```bash
./install.sh --lang es
./install.sh --lang en
```

Add a new language by creating `lang/<code>.sh` with the same variables as `lang/en.sh`.

---

## Project structure

```
DevCobos-setup/
├── install.sh              # Entry point and interactive menu
├── config/
│   └── starship.toml       # SynthWave Starship prompt theme
├── lang/
│   ├── en.sh               # English strings
│   └── es.sh               # Spanish strings
├── scripts/
│   ├── git.sh              # Git + global config
│   ├── zsh.sh              # Zsh + Starship + plugins
│   ├── node.sh             # fnm + Node.js + package manager
│   ├── docker.sh           # Docker + WSL systemd
│   ├── make.sh             # GNU Make
│   ├── aws.sh              # AWS CLI v2
│   └── terraform.sh        # Terraform + autocomplete
└── windows-terminal/
    ├── README.md            # Windows Terminal setup guide (Phase 1)
    ├── install-themes.ps1   # Color schemes installer
    ├── install-starship.ps1 # Starship for PowerShell
    ├── themes/
    │   ├── tokyo-night-custom.json
    │   └── synthwave-custom.json
    └── starship/
        ├── tokyo-night-custom.toml
        └── synthwave-custom.toml
```

---

## Adding a tool

1. Create `scripts/<id>.sh`
2. Add `collect_inputs_<id>()` in `install.sh` if the tool needs user input before installation
3. Register the tool in the `TOOLS` array in `install.sh`:
   ```bash
   TOOLS=(
     "git|Git|Version control"
     "id|Name|Description"
   )
   ```
4. Add the translation keys to `lang/en.sh` and `lang/es.sh`

---

## Troubleshooting

**Icons/symbols not rendering correctly**
Make sure a Nerd Font is installed and selected in your Windows Terminal profile. See the [Windows Terminal setup guide](windows-terminal/README.md).

**`gum` not found or fails to install**
`gum` requires `curl` and internet access. Run `curl --version` to verify curl is available, then retry.

**Docker: permission denied running `docker` without sudo**
Log out and back in (or close and reopen your WSL terminal) after installation so the `docker` group membership takes effect.

**Docker: systemd not available**
The Docker installer enables WSL systemd automatically. If it was already disabled manually, check `/etc/wsl.conf` and ensure `[boot] systemd=true` is set, then restart WSL with `wsl --shutdown` from PowerShell.

**Zsh is not the default shell after installation**
Run `chsh -s $(which zsh)` manually and restart your terminal.
