# Intune Google Chrome Policy Management (ADMX)

## Overview
This repository contains the configuration templates and implementation logic for managing Google Chrome at scale using **Microsoft Intune**. By leveraging ADMX-backed policies, this project enables centralised management of browser settings, security configurations, and update behaviours across a Windows workstation fleet.

## Key Features
* **ADMX & ADML Ingestion**: Demonstrates the process of importing custom administrative templates (`google.admx`) alongside their language-specific resource files (`google.adml`) into the Microsoft Intune portal.
* **Granular Browser Control**: Enables the enforcement of specific security settings, such as forced extensions, homepage lockdowns, and password manager restrictions.
* **Update Governance**: Includes the `GoogleUpdate.admx` template to manage the frequency and automation of browser updates, ensuring the fleet remains protected against zero-day vulnerabilities.
* **Modern Desktop Management**: Transitions legacy browser management into a modern MDM workflow, aligning with a cloud-native configuration strategy.

---

## Deployment & Dependencies

### **Core Dependency: Windows 11 ADMX & ADML**
Before importing Chrome-specific templates, ensure that your Intune tenant has the latest **Windows 11 Administrative Templates** available. Intune requires both the logic file (**ADMX**) and the language-specific resource file (**ADML**) to be uploaded simultaneously.

These can be sourced directly from a local Windows 11 installation to ensure version parity:

* **ADMX Location**: `C:\Windows\PolicyDefinitions\Windows.admx`
* **ADML Location**: `C:\Windows\PolicyDefinitions\en-US\Windows.adml`

### **Step-by-Step Ingestion Order**
To ensure all parent-child relationships are maintained, import the files into Intune (**Devices > Configuration > Import ADMX**) using the following sequence. For each entry, you must upload both the **ADMX** and the corresponding **ADML** from the `en-US` folder:

1. **Windows.admx / Windows.adml** (The OS master dictionary)
2. **google.admx / google.adml** (The base Google dependency)
3. **chrome.admx / chrome.adml** (Core browser settings)
4. **GoogleUpdate.admx / googleupdate.adml** (Update service management)

Once the status shows as **Available**, you can create a new Configuration Profile using the **Imported Administrative Templates** type.

---

## Testing & Validation
Before a global rollout, validate the deployment using a dedicated testing group. For detailed instructions on establishing a secure testing environment and managing groups in Intune, refer to the following documentation:

**Guide: Create or Delete a Group for Testing** https://github.com/RickGua90/How_To/blob/main/Create_or_delete_a_group_in_Intune.pdf

---

## Disclaimer
**READ BEFORE USE**: These templates are provided for infrastructure management purposes. Always ensure you are using the latest versions from the official vendor source. I hold no responsibility for system instability caused by incorrect policy configurations.
