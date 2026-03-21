# Adobe - Automated Security Patching

### **Overview**
In an enterprise environment, maintaining security compliance for the Adobe Creative Cloud suite is a significant challenge due to frequent updates. This project provides a comprehensive Win32 App (IntuneWin) solution to silently deploy the Adobe Remote Update Manager (RUM) and force security patches across managed workstations without user interruption or requiring local administrative rights.

### **The Packaging Framework**
To ensure consistent, repeatable builds, this project utilizes a structured local environment on the packaging workstation. This setup ensures that all dependencies are bundled correctly within the encrypted package.

* **Root Directory**: `C:\intunepackage\`
* **Source Folder**: `\Source\` (Contains all `.exe`, `.msi`, and `.ps1` logic)
* **Output Folder**: `\Output\` (Destination for the encrypted `.intunewin` file)
* **Tooling**: `IntuneWinAppUtil.exe` is placed in the root for streamlined command-line execution.

### **Source Folder Requirements**
Due to GitHub's 25MB file limit, the official Adobe binary is not hosted here. You must download the installer and place it in your \Source\ folder alongside the provided script:

* RemoteUpdateManager.exe: Download from your Adobe Admin Console or the official Adobe enterprise portal.

* AdobeSecurityFix.ps1: The automation script provided in this repository.

### **Key Features**
* The script automatically queries the system for installed Adobe products. If no Adobe software is detected, the script exits cleanly without making any system changes.

* The package automatically installs the Remote Update Manager (RUM) to the local system directory if it is missing before initiating patches.

* Triggers updates for the entire Adobe suite in the background using --silentMode=true, ensuring zero friction for the end-user.

* Specifically designed to ensure security patches are applied immediately to reduce the attack surface.

### **How to Build the Package**
To replicate this deployment, place the RemoteUpdateManager.exe and the AdobeSecurityFix.ps1 script in your Source folder and execute the following command from the root directory:

.\IntuneWinAppUtil.exe -c .\Source -s AdobeSecurityFix.ps1 -o .\Output

### **Intune Deployment Configuration**
* Install Command: powershell.exe -ExecutionPolicy Bypass -File AdobeSecurityFix.ps1

* Uninstall Command: powershell.exe -ExecutionPolicy Bypass -Command "exit 0"

* Install Behavior: System (Mandatory for modifying protected system directories)

* Detection Method: File-based (Verify if RemoteUpdateManager.exe exists in C:\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager)

* Device Restart Behavior: App install may force a device restart

### **Disclaimer**
**READ BEFORE USE**: These scripts are provided for educational and testing purposes only. I hold no responsibility for system instability, broken functionality, or data loss in your environment. Always validate in a sandbox/testing group before production use.

### **Deployment & Testing**
Before deploying these scripts to your entire fleet, it is strongly recommended to use a dedicated Testing Group to validate the results.

* For a step-by-step guide on how to set up a group, please refer to my documentation here: https://github.com/RickGua90/How_To/blob/7aa316a7a7313245b0006747091482029fab9251/Create_or_delete_a_group_in_Intune.pdf

* For a step-by-step guide on how to Create/Edit a WinApp32 in Intune, please refer to my documentation here: https://github.com/RickGua90/How_To/blob/main/HowtoCreateEditaWinApp32inIntune.pdf
