try
{
    git --version | Out-Null
}
catch [System.Management.Automation.CommandNotFoundException]
{
    Write-Host "No git"
    Write-Host "Installing Git via winget..."
    winget install Git.Git
}