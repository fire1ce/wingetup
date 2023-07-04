# PowerShell Script
$ErrorActionPreference = 'Continue'

# Determine if the alias already exists
$aliasExists = Get-Alias -Name wingetup -ErrorAction SilentlyContinue

# Profile path for current user and all hosts
$profilePath = $PROFILE.CurrentUserAllHosts

# Check if the profile file exists, create it if not
if (!(Test-Path $profilePath)) {
    New-Item -Type File -Path $profilePath -Force
}

# Check if the alias exists, create it if not
if (!(Get-Alias -Name "wingetup" -ErrorAction SilentlyContinue)) {
    "Set-Alias -Name wingetup -Value `"$((Get-Item $MyInvocation.MyCommand.Path).FullName)`"" | Out-File -Append -Encoding utf8 -FilePath $profilePath
    Write-Host "Alias 'wingetup' has been created."
    . $profilePath # Reload the profile
}

# Define function for writing colored text
function Write-Color($Text, $Color) {
    Write-Host $Text -ForegroundColor $Color -NoNewline
    Write-Host
}

# Check if Git is installed, if not install it
try {
    git --version | Out-Null
}
catch {
    Write-Host "Installing Git via winget..."
    winget install Git.Git
}

# Set working directory as the script location
$scriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

# Update the Git repository
Write-Host "Updating Git repository..."
git pull

# Winget packages update
Write-Color "==> Running Winget Updates..." Yellow
winget upgrade --all

# Create a JSON dump file with hostname
$HostName = [System.Net.Dns]::GetHostName()
$wingetFileName = "./WingetExport.${HostName}.json"
Write-Color "==> Creating JSON dump file..." Yellow

winget export -o $wingetFileName 2>&1 | ForEach-Object {
    $message = $_.ToString()
    if (-not $message.StartsWith("Installed package is not available from any source")) {
        Write-Host $message
    }
}


# Pushing to repo
$Date = Get-Date -Format 'yyyyMMdd.HHmm'
Write-Host "Pushing to repository..."
git add .
git commit -m "${Date}_update"
git push

Write-Color "==> All Updates & Cleanups Finished" Green
