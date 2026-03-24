# DevCobos-setup Demo
# Generate with: vhs demo.tape
# Requires: vhs (https://github.com/charmbracelet/vhs)

Output .github/assets/demo.gif

Set Theme "Builtin Dark"
Set FontFamily "FiraCode Nerd Font Mono"
Set FontSize 14
Set Width 1200
Set Height 600
Set Padding 20

# Start the installer
Type "~/DevCobos-setup/install.sh"
Enter
Sleep 3s

# Main menu: select "Select tools"
Enter
Sleep 1s

# Toggle Git and Zsh
Space
Sleep 300ms
Down
Space
Sleep 300ms

# Confirm selection
Enter
Sleep 1s

# Git config: enter name
Type "Dev Cobos"
Enter
Sleep 500ms

# Git config: enter email
Type "dev@cobos.dev"
Enter
Sleep 4s

# Wait for installations to complete and summary
Sleep 3s

# Screenshot the summary
Screenshot .github/assets/summary.png
Sleep 2s
