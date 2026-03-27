<#
    PROJECT: .NET Wrapper (Installation)
    AUTHOR: Rick
    
    DISCLAIMER: 
    Educational purposes only. Always test in a dedicated group before fleet deployment.

    LOGIC:
    1. Pre-check: If .NET isn't on the machine, the script exits to avoid unnecessary installs.
    2. Tooling: Installs the .NET Core Uninstall Tool if not present in Program Files (x86).
    3. Update: Installs .NET 8.0.25 (Desktop, Runtime, and ASP.NET) to ensure the latest 
       version is active before scrubbing.
    4. Scrub: Uses the Uninstall Tool to purge all versions below 8.0.24 and all x86 versions.
    5. Validation: Confirms only 8.0.25 remains active.

    # Remember to amend any 8.0.25 in the script to the specific version you are trying to deploy
#>

# 1. Check if .NET exists at all on the machine
$dotnetCheck = & dotnet --list-runtimes 2>$null
if (!$dotnetCheck) {
    Write-Host "dotnet not found. No need to install it." -ForegroundColor Green
    exit 0
}

# 2. Check if the Uninstall Tool exists; install if missing
$toolPath = "C:\Program Files (x86)\dotnet-core-uninstall\dotnet-core-uninstall.exe"
$msiPath = "$PSScriptRoot\dotnet-core-uninstall.msi"

if (!(Test-Path $toolPath)) {
    if (Test-Path $msiPath) {
        Write-Host "Installing .NET Uninstall Tool..." -ForegroundColor Cyan
        Start-Process "msiexec.exe" -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait
    } else {
        Write-Host "Error: dotnet-core-uninstall.msi not found." -ForegroundColor Red
        exit 1
    }
}

# 3. Install .NET 8.0.25 components first
# Remember to amend any 8.0.25 in the script to the specific version you are trying to deploy
Write-Host "Installing .NET 8.0.25 components..." -ForegroundColor Cyan
$installers = @(
    "windowsdesktop-runtime-8.0.25-win-x64.exe",
    "dotnet-runtime-8.0.25-win-x64.exe",
    "aspnetcore-runtime-8.0.25-win-x64.exe"
)

foreach ($exe in $installers) {
    $exePath = "$PSScriptRoot\$exe"
    if (Test-Path $exePath) {
        Write-Host "Installing $exe..." -ForegroundColor Gray
        # Using /install /quiet /norestart for .exe installers
        Start-Process "$exePath" -ArgumentList "/install /quiet /norestart" -Wait
    }
}

# 4. Proceed with deleting old versions using the tool
# Remember to amend any 8.0.25 in the script to the specific version you are trying to deploy
if (Test-Path $toolPath) {
    Write-Host "Removing all versions below 8.0.25..." -ForegroundColor Yellow
    
    # x64 Cleanup (removes everything below your new 8.0.25)
    & $toolPath remove --all-below 8.0.25 --runtime --yes --force
    & $toolPath remove --all-below 8.0.25 --windows-desktop-runtime --yes --force
    & $toolPath remove --all-below 8.0.25 --aspnet-runtime --yes --force
    & $toolPath remove --all-below 8.0.25 --hosting-bundle --yes --force
    & $toolPath remove --all-below 8.0.25 --sdk --yes --force
    
    # x86 Cleanup (clears x86 entirely)
    & $toolPath remove --all --x86 --runtime --yes --force
    & $toolPath remove --all --x86 --windows-desktop-runtime --yes --force
    & $toolPath remove --all --x86 --aspnet-runtime --yes --force
    & $toolPath remove --all --x86 --hosting-bundle --yes --force
    & $toolPath remove --all --x86 --sdk --yes --force
}

# 5. Final verification
# Remember to amend any 8.0.25 in the script to the specific version you are trying to deploy
$remaining = & dotnet --list-runtimes 2>$null | Where-Object { $_ -notlike "*8.0.25*" }
if (!$remaining) {
    Write-Host "dotnet 8.0.25 is the only version left" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some older versions might still be present." -ForegroundColor Yellow
    exit 0
}
