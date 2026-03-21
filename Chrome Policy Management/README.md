# Intune Google Chrome Policy Management (ADMX)

## Overview
This repository documents the implementation of enterprise-grade Google Chrome management using **ADMX-backed administrative templates** within Microsoft Intune. By moving away from local Group Policy (GPO) and utilising cloud-native ingestion, this project enables centralised control over browser security, extensions, and update protocols.

## Key Features
* **Custom Template Ingestion**: Demonstrates the successful import of `google.admx`, `chrome.admx`, and `GoogleUpdate.admx` into the Intune tenant.
* **Security Hardening**: Implementation of policies for forced browser updates, extension whitelisting, and data protection settings.
* **Modern Desktop Management**: Transitions legacy browser management into a modern MDM workflow, ensuring compliance for remote and hybrid workstations.

---

## Deployment Workflow (Step-by-Step)

### **1. Template Acquisition**
The ADMX and ADML files in this repository were sourced from the official Google Chrome Enterprise bundle. These must be kept up to date to support new browser features.

### **2. Intune Ingestion Process**
To replicate this configuration in a new environment, follow the import order in the Intune portal (**Devices > Configuration > Import ADMX**):
1.  **google.admx**: The base dependency.
2.  **chrome.admx**: The core browser settings.
3.  **GoogleUpdate.admx**: Management for the Google Update service.

### **3. Policy Configuration**
Once the templates show a status of **Available**, create a new **Configuration Profile**:
* **Platform**: Windows 10 and later
* **Profile Type**: Templates
* **Template Name**: Imported Administrative Templates

### **4. Testing & Validation**
Before deploying these policies to the entire fleet, validate them on a specific testing group. For instructions on managing Intune groups for pilot phases, refer to my documentation:

**Guide: Create or Delete a Group for Testing** https://github.com/RickGua90/How_To/blob/main/Create_or_delete_a_group_in_Intune.pdf

---

## Disclaimer
**READ BEFORE USE**: These templates are provided for infrastructure management purposes. Always ensure you are using the latest versions from the official vendor source. I hold no responsibility for system instability caused by incorrect policy enforcement.
