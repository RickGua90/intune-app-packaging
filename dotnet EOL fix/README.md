# .NET 8 Migration & EOL removal

### **Overview**
In an enterprise environment, managing **.NET Runtimes** is a significant security and infrastructure challenge. Older, unpatched versions often linger on endpoints, increasing the attack surface. This project provides a comprehensive **Win32 App (IntuneWin)** solution to deploy **.NET 8.0.24** while proactively "scrubbing" all obsolete and vulnerable versions from the system.

### **The Packaging Framework**
To ensure consistent, repeatable builds, this project utilizes a structured local environment on the packaging workstation. This setup allows for clean version control and ensures all dependencies are bundled correctly.

* **Root Directory**: `C:\intunepackage\`
* **Source Folder**: `\Source\` (Contains all `.exe`, `.msi`, and `.ps1` logic)
* **Output Folder**: `\Output\` (Destination for the encrypted `.intunewin` file)
* **Tooling**: `IntuneWinAppUtil.exe` is placed in the root for streamlined command-line execution.

### **Source Folder Requirements**
Due to GitHub's 25MB file limit, the .exe installers are not hosted here. You must download the following installers directly from official Microsoft sources and place them in your \Source\ folder:

dotnet-core-uninstall.msi from: https://github.com/dotnet/cli-lab/releases

windowsdesktop-runtime-VERSION-win-x64.exe: Get the x64 installer from https://dotnet.microsoft.com/en-us/download

dotnet-runtime-VERSION-win-x64.exe: Get the x64 installer from https://dotnet.microsoft.com/en-us/download

aspnetcore-runtime-VERSION-win-x64.exe: Get the x64 installer from https://dotnet.microsoft.com/en-us

dotnet_install.ps1: The script provided in this repository.

dotnet_detection.ps1: The script provided in this repository.

### If You download different versions from the 8.0.24, remember to amend the scripts provided!!

### **Key Features**
* **Self-Contained Remediation**: The package bundles the **.NET Core Uninstall Tool (MSI)**, allowing the script to perform deep-cleaning without requiring external downloads during the installation phase.
* **Intelligent Detection**: The detection script (**dotnet_detection.ps1**) verifies the physical installation path and queries the **dotnet host** to ensure no legacy versions remain active.
* **Architecture Standardisation**: Automatically identifies and purges **x86** runtimes to standardise the fleet on **x64** architecture, reducing complexity and support overhead.
* **Zero-Downtime Logic**: The script is designed to install the secure version **before** removing old ones, preventing application crashes or missing dependency errors during the migration.

### **How to Build the Package**
Update the $TargetVersion variable at the top of the .ps1 scripts to match your downloaded files (e.g., 8.0.24).

To replicate this deployment, place all installers and the script in your `Source` folder and execute the following command from the root directory:

.\IntuneWinAppUtil.exe -c .\Source -s dotnet_install.ps1 -o .\Output

### **Intune Deployment Configuration**
Install Command: powershell.exe -ExecutionPolicy Bypass -File dotnet_install.ps1

Uninstall Command: powershell.exe -ExecutionPolicy Bypass -Command "& { Get-Package -Name '*dotnet*' | Uninstall-Package -Force }"

Install Behavior: System

Detection Method: Custom Script (dotnet_detection.ps1)

Device Restart Behavior: App install may force a device restart

### **Disclaimer**
**READ BEFORE USE**: These scripts are provided for educational and testing purposes only. I hold no responsibility for system instability, broken functionality, or data loss in your environment. Always validate in a sandbox/testing group before production use.
