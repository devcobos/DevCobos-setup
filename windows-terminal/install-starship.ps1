$env:POSH_CACHE_ENABLED = $true
$themesPath = "$env:USERPROFILE\.config"
$themeFile = "$PSScriptRoot\starship\tokyo-night-custom.toml"

# Create .config directory if it doesn't exist
if (-not (Test-Path -Path $themesPath)) {
    New-Item -ItemType Directory -Path $themesPath
}

# Copy Starship theme
$destinationFile = "$themesPath\starship.toml"
Copy-Item -Path $themeFile -Destination $destinationFile -Force

Write-Host "✅ Starship theme copied to $destinationFile" -ForegroundColor Green

# Profile content to add
$starshipInit = @'

# Load Starship with custom theme
Invoke-Expression (&starship init powershell)

# Ensure Terminal-Icons module is loaded
if (-not (Get-Module -Name Terminal-Icons -ListAvailable)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force
}
Import-Module Terminal-Icons
'@

$profilePath = $PROFILE

# Check if profile exists
if (Test-Path $profilePath) {
    $profileContent = Get-Content -Path $profilePath -Raw
    
    # Check if Starship is already configured
    if ($profileContent -match "starship init powershell") {
        Write-Host "⚠️  Starship is already configured in your PowerShell profile." -ForegroundColor Yellow
        Write-Host "   Profile location: $profilePath" -ForegroundColor Cyan
        
        $response = Read-Host "Do you want to overwrite the entire profile? (y/N)"
        
        if ($response -eq 'y' -or $response -eq 'Y') {
            # Backup existing profile
            $backupPath = "$profilePath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item -Path $profilePath -Destination $backupPath
            Write-Host "📦 Backup created at: $backupPath" -ForegroundColor Cyan
            
            # Create new profile
            Set-Content -Path $profilePath -Value $starshipInit.TrimStart()
            Write-Host "✅ Profile overwritten with Starship configuration." -ForegroundColor Green
        } else {
            Write-Host "ℹ️  Profile not modified. Make sure Starship initialization is present." -ForegroundColor Cyan
        }
    } else {
        # Starship not found, append to existing profile
        Write-Host "📝 Adding Starship configuration to existing profile..." -ForegroundColor Yellow
        
        # Backup existing profile
        $backupPath = "$profilePath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item -Path $profilePath -Destination $backupPath
        Write-Host "📦 Backup created at: $backupPath" -ForegroundColor Cyan
        
        Add-Content -Path $profilePath -Value $starshipInit
        Write-Host "✅ Starship configuration added to profile." -ForegroundColor Green
    }
} else {
    # Profile doesn't exist, create new one
    Write-Host "📝 Creating new PowerShell profile..." -ForegroundColor Yellow
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
    Set-Content -Path $profilePath -Value $starshipInit.TrimStart()
    Write-Host "✅ New profile created with Starship configuration." -ForegroundColor Green
}

Write-Output ' '
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "✅ Starship Tokyo Night prompt has been successfully configured!" -ForegroundColor Green
Write-Host "🚀 Restart your terminal for the changes to take effect." -ForegroundColor Yellow
Write-Host "📂 Profile location: $profilePath" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Output ' '