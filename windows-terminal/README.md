# Windows Terminal Setup

> Part of [DevCobos-setup](../README.md) — complete this guide **before** running the WSL installer.

Configures Windows Terminal with **Tokyo Night** for PowerShell and **SynthWave** for Ubuntu WSL, including color schemes, Nerd Font, and Starship prompt.

![Preview](../.github/assets/terminal-preview.png)

![Preview Ubuntu](../.github/assets/terminal-ubuntu-preview.png)

---

## Table of Contents

- [Step 1 — Install Windows Terminal and PowerShell](#step-1--install-windows-terminal-and-powershell)
- [Step 2 — Install a Nerd Font](#step-2--install-a-nerd-font)
- [Step 3 — Install color schemes](#step-3--install-color-schemes)
- [Step 4 — Install Starship for PowerShell](#step-4--install-starship-for-powershell)
- [Step 5 — Install Starship for Ubuntu WSL](#step-5--install-starship-for-ubuntu-wsl)
- [Optional customization](#optional-customization)
- [Back to DevCobos-setup](../README.md)

---

## Step 1 — Install Windows Terminal and PowerShell

1. **Install Windows Terminal** from the Microsoft Store:
   [Windows Terminal - Microsoft Store](https://apps.microsoft.com/detail/9N0DX20HK701?hl=en-us&gl=ES&ocid=pdpshare)

2. **Install PowerShell** from the Microsoft Store:
   [PowerShell - Microsoft Store](https://apps.microsoft.com/detail/9MZ1SNWT0N5D?hl=en-us&gl=ES&ocid=pdpshare)

3. **Set Windows Terminal and PowerShell as defaults:**
   1. Open **Windows Terminal**.
   2. Go to **Settings**.
   3. Set **Windows Terminal** and **PowerShell** as the default options on startup.
   4. Save the changes.

   ![Default options](../.github/assets/windows_terminal_default.png)

---

## Step 2 — Install a Nerd Font

A Nerd Font is **required** for Starship icons and symbols to render correctly.

1. Download **FiraCode Nerd Font** from: [Nerd Fonts - Font Downloads](https://www.nerdfonts.com/font-downloads)
2. Install the font on Windows.
3. Open Windows Terminal and go to `Settings > Profiles > Defaults > Appearance`.
4. Select **FiraCode Nerd Font Mono** and set the font weight to **Medium**.
5. Save the changes.

   ![Set font default](../.github/assets/set_font_fira_code.png)

> Any other Nerd Font works too — FiraCode is the recommended one for this setup.

---

## Step 3 — Install color schemes

This installs **DevCobos - Tokyo Night** (for PowerShell) and **DevCobos - SynthWave** (for Ubuntu WSL).

1. Open a PowerShell terminal.
2. Navigate to the `windows-terminal` folder inside this repository.
3. Run the script:
   ```powershell
   .\install-themes.ps1
   ```
4. Restart Windows Terminal.

**Apply the Tokyo Night scheme to PowerShell:**
1. Go to `Settings > Profiles > PowerShell > Appearance`.
2. Select **DevCobos - Tokyo Night** as the color scheme.
3. Save.

   ![Settings default color](../.github/assets/default_color_theme.png)

**Apply the SynthWave scheme to Ubuntu WSL:**
1. Go to `Settings > Profiles > Ubuntu` (or your WSL distribution) `> Appearance`.
2. Select **DevCobos - SynthWave** as the color scheme.
3. Save.

   ![Settings color](../.github/assets/settings_color_theme.png)

---

## Step 4 — Install Starship for PowerShell

[Starship official docs](https://starship.rs/guide/)

**Install Starship via winget:**

```powershell
winget install --id Starship.Starship
```

**Configure PowerShell to use Starship with the Tokyo Night theme:**

1. Open a PowerShell terminal.
2. Navigate to the `windows-terminal` folder inside this repository.
3. Run the script:
   ```powershell
   .\install-starship.ps1
   ```
   The script will:
   - Check your existing PowerShell profile (`$PROFILE`)
   - Back it up with a timestamp before making changes
   - Append Starship initialization (or ask to overwrite if already configured)
   - Install the **Terminal-Icons** module for file icons in PowerShell

4. Restart Windows Terminal.

   ![Finished](../.github/assets/prompt_starship.png)

---

## Step 5 — Install Starship for Ubuntu WSL

### Automated install with DevCobos-setup (recommended)

The WSL installer configures **Zsh + Starship** with the SynthWave theme, autosuggestions, syntax highlighting, and `eza` aliases — all in one step.

1. Go back to the [main installer](../README.md) and run:
   ```bash
   sudo -v && ~/DevCobos-setup/install.sh
   ```
2. Select **Zsh + Starship** from the tool list.

The script will automatically install and configure everything. Restart your terminal when done.

### Manual install

If you prefer to set it up manually:

**Install Starship:**

```bash
curl -sS https://starship.rs/install.sh | sh
```

**Configure your shell:**

1. Open `~/.bashrc` in your editor:
   ```bash
   nano ~/.bashrc
   ```
2. Add this line at the end:
   ```bash
   eval "$(starship init bash)"
   ```
3. Save (`Ctrl+O`, Enter) and exit (`Ctrl+X`).
4. Reload:
   ```bash
   source ~/.bashrc
   ```

**Apply the SynthWave theme:**

1. Create the config folder and open the config file:
   ```bash
   mkdir -p ~/.config && nano ~/.config/starship.toml
   ```
2. Copy the contents of [`starship/synthwave-custom.toml`](starship/synthwave-custom.toml) into the file.
3. Save and exit.

> **Note:** The automated WSL installer deploys [`config/starship.toml`](../config/starship.toml) which uses `right_format`. The manual config uses `$fill` for the same visual result. Both are SynthWave-themed.

---

## Optional customization

### Acrylic tab row

1. Go to `Settings > Appearance`.
2. Enable **Use Acrylic Material in the tab row**.
3. Save.

   ![acrylic material](../.github/assets/acrylic_material_tab_row.png)
