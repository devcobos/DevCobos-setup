$tokyoNightPath = "$Env:LocalAppData\Microsoft\Windows Terminal\Fragments\tokyo-night-custom"
$synthWavePath = "$Env:LocalAppData\Microsoft\Windows Terminal\Fragments\synthwave-custom"

# Install Tokyo Night Custom
if (!(Test-Path $tokyoNightPath)) {
  New-Item -Type Directory -Path $tokyoNightPath
}

Copy-Item -Path "$PSScriptRoot\themes\tokyo-night-custom.json" -Destination $tokyoNightPath

# Install SynthWave Custom
if (!(Test-Path $synthWavePath)) {
  New-Item -Type Directory -Path $synthWavePath
}

Copy-Item -Path "$PSScriptRoot\themes\synthwave-custom.json" -Destination $synthWavePath


Write-Output ' '
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "🌙 Tokyo Night Colorscheme Fragment Installed." -ForegroundColor Green
Write-Host "🌆 SynthWave Colorscheme Fragment Installed." -ForegroundColor Magenta
Write-Host "🚀 Restart your terminal for the changes to take effect." -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Output ' '