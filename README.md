# DevCobos-setup

Interactive development environment installer for WSL + Ubuntu.

![setup preview](/.github/assets/image.png)

## Requirements

- WSL2 with Ubuntu 22.04+
- `curl`
- `sudo` access
- **Windows Terminal** (Windows-side prerequisite): custom color schemes and a Nerd Font must be installed before using this WSL installer. See the [Windows Terminal setup guide](windows-terminal/README.md).

> `gum` is installed automatically on first run.

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

## Language

Auto-detected from `$LANG`. Override with `--lang`:

```bash
./install.sh --lang es
./install.sh --lang en
```

Add a new language by creating `lang/<code>.sh` with the same variables as `lang/en.sh`.

## Tools

| Tool           | Description                                 |
| -------------- | ------------------------------------------- |
| Git            | Version control + global config             |
| Zsh + Starship | Shell with custom prompt                    |
| Node.js (fnm)  | JavaScript runtime + version manager        |
| Docker         | Container runtime with systemd + WSL config |
| [Windows Terminal](windows-terminal/README.md) | Color schemes, Nerd Font, and Starship for PowerShell |

## Structure

```
DevCobos-setup/
├── install.sh              # Entry point and main menu
├── config/
│   └── starship.toml       # Starship prompt config (SynthWave, deployed by scripts/zsh.sh)
├── lang/
│   ├── en.sh               # English
│   └── es.sh               # Spanish
├── scripts/
│   ├── git.sh              # Git install + config
│   ├── zsh.sh              # Zsh + Starship install + config
│   ├── node.sh             # fnm + Node.js install
│   └── docker.sh           # Docker + WSL systemd config
└── windows-terminal/
    ├── README.md            # Windows Terminal setup guide
    ├── install-themes.ps1   # Color schemes installer
    ├── install-starship.ps1 # Starship + PowerShell profile setup
    ├── themes/
    │   ├── tokyo-night-custom.json
    │   └── synthwave-custom.json
    └── starship/
        ├── tokyo-night-custom.toml
        └── synthwave-custom.toml
```

## Adding a tool

1. Create `scripts/<id>.sh`
2. Add `collect_inputs_<id>()` in `install.sh` if the tool needs user input
3. Register the tool in the `TOOLS` array in `install.sh`:
   ```bash
   TOOLS=(
     "git|Git|Version control"
     "id|Name|Description"
   )
   ```
4. Add the translation keys to `lang/en.sh` and `lang/es.sh`
