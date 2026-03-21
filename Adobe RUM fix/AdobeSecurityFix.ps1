<#
    PROJECT: Adobe - Security Patching
    AUTHOR: Rick
    
    LOGIC:
    1. Checks if any Adobe software is currently installed.
    2. If no Adobe software is found, the script exits immediately to avoid unnecessary changes.
    3. If Adobe is present, it ensures RemoteUpdateManager (RUM) is installed.
    4. Scans for and applies available security patches silently.
#>

# 1. Safety Gate: Check for any installed Adobe products
$AdobeApps = Get-Package -Name "*Adobe*" -ErrorAction SilentlyContinue

if ($null -eq $AdobeApps) {
    Write-Output "No Adobe software detected on this device."
    exit 0
}

$rumDir = "C:\Program Files (x86)\Common Files\Adobe\OOBE_Enterprise\RemoteUpdateManager"
$rumPath = "$rumDir\RemoteUpdateManager.exe"
$localInstaller = ".\RemoteUpdateManager.exe"

# 2. Check if the tool exists; if not, install it
if (!(Test-Path $rumPath)) {
    if (!(Test-Path $rumDir)) { New-Item -Path $rumDir -ItemType Directory -Force }
    Copy-Item -Path $localInstaller -Destination $rumPath -Force
}

# 3. Check for vulnerabilities/updates
$scan = & $rumPath --action=list

# 4. If vulnerabilities found, fix them
if ($scan -match "Following Updates are applicable") {
    & $rumPath --action=install
}
