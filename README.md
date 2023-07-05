# Winget Package Updater and Exporter Script

This script updates Winget packages, exports the configuration to a JSON file, and pushes the changes to a Git repository. The script is intended to be used in Windows environments with PowerShell.

## Prerequisites

- Windows 10 or Windows 11
- [Windows Package Manager](https://github.com/microsoft/winget-cli) (Winget)
- [Git](https://git-scm.com/) (If not installed, the script will attempt to install it via Winget)

## Getting Started

1. **Create Your Own Repository**: Click on "Use this template" to create a new repository based on this template repository.

2. **Clone Your Repository**: Clone the repository you just created to your local machine. Choose a logical location for cloning. Use the following command, replacing `<your-repo-url>` with the URL of your repository.

   ```shell
   git clone <your-repo-url>
   ```

3. **Install Git**: If you don't have Git installed, you can install it using Winget. Open PowerShell as an administrator and run:

   ```shell
   winget install Git.Git
   ```

4. **Initial run of the Scrip**: Navigate to the directory where you cloned your repository, and run the script `WingetUpdater.ps1` with PowerShell:

   ```shell
   cd <path-to-the-repo>
   .\wingetup.ps1
   ```

   The script will:

   - Install Git if it is not already installed.
   - Pull the latest changes from your Git repository.
   - If required, the script will prompt you to change the PowerShell execution policy to 'RemoteSigned'. Accept the prompt to allow the script to run.
   - Create a Powershell alias `wingetup` that you can use to run the script with a simple command. Type `wingetup` in PowerShell to run the script.
   - Update all Winget packages.
   - Export the configuration to a JSON file named with the hostname of the machine.
   - Commit and push changes to your Git repository.

## Usage

After the initial run, you can run the script by typing `wingetup` in PowerShell.

```shell
wingetup
```

## Installing Winget Packages From a Exported JSON File

You can install Winget packages from a JSON file exported by the script. The JSON file contains the list of packages installed on the machine. To install the packages, run the following command in PowerShell:

```shell
winget import -i <path-to-json-file>
```

## Notes

- The script creates an alias `wingetup` that you can use to run the script with a simple command. Type `wingetup` in PowerShell to run the script.
- You should have sufficient permissions to execute scripts and change execution policies in PowerShell.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
