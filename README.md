# Winget Package Manager Automation Script

This script is designed to streamline and automate the process of updating Winget packages, exporting package configurations to a JSON file, and seamlessly integrating the changes with a Git repository. Tailored for Windows environments, this PowerShell script is an essential tool for system administrators and developers.

## System Requirements

- Windows 10 or Windows 11 operating system.
- Windows Package Manager (Winget).
- Git (The script is designed to install Git via Winget if it is not pre-installed).

## Set-up Instructions

Repository Initialization
Start by creating a new repository from this template repository. Clone the newly created repository to your local machine, selecting an appropriate directory for cloning. Use the following command by replacing <your-repo-url> with the URL of your repository:

```shell
git clone <your-repo-url>
```

## Git Installation

If Git is not installed on your machine, use Winget to install it. Open PowerShell as an administrator and execute the following command:

```shell
winget install Git.Git
```

## Running the Script

Navigate to the directory where your repository is cloned, and initiate the script WingetUpdater.ps1 via PowerShell:

```shell
Copy code
cd <path-to-the-repo>
.\wingetup.ps1
```

On running the script, the following actions will be performed:

- Verification and installation of Git if it is not installed.
- Synchronization with the latest changes from your Git repository.
- In case your PowerShell execution policy is restrictive, you will be prompted to change it to 'RemoteSigned'. Consent to this prompt to enable the script.
- Establishment of a PowerShell alias wingetup which simplifies subsequent script executions. Simply enter wingetup in PowerShell.
- Updating of all Winget packages.
- Exporting the package configuration to a JSON file, named using the hostname of the machine.
- Committing and pushing the changes to your Git repository.

## Script Execution

After the initial set-up, simply enter wingetup in PowerShell to execute the script:

```shell
wingetup
```

## Package Installation From JSON Configuration

This script exports package configurations to a JSON file. To install Winget packages from an exported JSON file, execute the following command in PowerShell:

```shell
winget import -i <path-to-json-file>
```

## Considerations

The script establishes an alias wingetup, streamlining future executions.
Ensure that you possess the requisite permissions for script execution and policy modification in PowerShell.
Licensing
This project operates under the MIT License. For further details, please refer to the LICENSE file.
