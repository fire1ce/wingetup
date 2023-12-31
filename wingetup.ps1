<#
.SYNOPSIS
    A script that updates Winget packages, exports the configuration, and pushes to a Git repository.
#>

$ErrorActionPreference = 'Continue'

function Set-ExecutionPolicyIfRequired {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($currentPolicy -ne 'RemoteSigned') {
        # Prompt the user
        $message = "The current execution policy is set to '$currentPolicy'. This script requires the execution policy to be set to 'RemoteSigned'. Changing the execution policy might have security implications. Do you want to proceed?"
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Sets the execution policy to 'RemoteSigned'."
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Exits the script."
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
        $result = $host.ui.PromptForChoice("Change Execution Policy", $message, $options, 1)
        
        switch ($result) {
            0 { # User selected Yes
                try {
                    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
                } catch {
                    Write-Host "Failed to set execution policy. Please run the script as an administrator or change the execution policy manually."
                    exit 1
                }
            }
            1 { # User selected No
                Write-Host "User chose not to change the execution policy. Exiting script."
                exit 1
            }
        }
    }
}

function UpdateOrCreateAlias {
  $profilePath = $PROFILE.CurrentUserAllHosts

  if (!(Test-Path $profilePath)) {
      New-Item -Type File -Path $profilePath -Force
  }

  # Correct the scriptPath to point to the actual script 'wingetup.ps1'
  $scriptPath = "`"$PSScriptRoot\wingetup.ps1`""
  $aliasContent = "Set-Alias -Name wingetup -Value $scriptPath"

  # Check if the alias content already exists in the profile
  $profileContent = Get-Content $profilePath -Raw

  if ([string]::IsNullOrEmpty($profileContent) -or ($profileContent -notmatch [regex]::Escape($aliasContent))) {
      Write-Host "Adding alias to profile..."
      $aliasContent | Out-File -Append -Encoding utf8 -FilePath $profilePath
      Write-Host "Alias 'wingetup' has been added."
      . $profilePath # Reload the profile
  } 
}

function InstallGitIfNotExists {
    try {
        git --version | Out-Null
    } catch {
        Write-Host "Installing Git via winget..."
        winget install Git.Git
    }
}

function Write-Color($Text, $Color) {
    Write-Host $Text -ForegroundColor $Color -NoNewline
    Write-Host
}

function Main {
    Set-ExecutionPolicyIfRequired
    UpdateOrCreateAlias
    InstallGitIfNotExists
    
    # Set working directory as the script location
    $scriptDir = $PSScriptRoot
    Set-Location $scriptDir
    
    # Update the Git repository
    Write-Host "Updating Git repository..."
    git pull

    ## Update winget packages
    Write-Color "==> Updating winget packages..." Yellow
    winget upgrade --all
    
    # Create a JSON dump file with hostname
    $HostName = [System.Net.Dns]::GetHostName()
    $jsonFile = "$PSScriptRoot\WingetExport.$HostName.json"

    # Export installed packages directly to a file
    Write-Color "==> Creating JSON dump file..." Yellow
    winget export --output $jsonFile --include-versions

    # Check if git is available and initialized
    if (Test-Path .git) {
        # Add and commit changes to the git repository
        Write-Color "==> Committing changes to Git repository..." Yellow
        git add .
        git commit -m "Update packages on $HostName"

        # Push the changes to the Git repository
        Write-Color "==> Pushing changes to Git repository..." Yellow
        git push
    } else {
        Write-Color "No Git repository found. Skipping the git push step." Red
    }
    
    Write-Color "==> All Updates & Cleanups Finished" Green
}

Main
