<#
    PROJECT: .NET (Detection)
    AUTHOR: Rick
    
    DISCLAIMER: 
    This script is for testing and educational purposes only. 
    I hold no responsibility for any system issues. Use at your own risk.

    LOGIC:
    1. Validates the existence of the specific Target Version (8.0.24) directory.
    2. Executes the dotnet host to list active runtimes.
    3. Returns Exit 0 (Success) only if 8.0.24 is present AND no older versions 
       are detected as active, ensuring a clean environment.

    # Remember to amend any 8.0.24 in the script to the specific version you are trying to deploy
#>

$TargetVersion = "8.0.24"
$Path = "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\$TargetVersion"
$Found = Test-Path $Path

$Runtimes = & "C:\Program Files\dotnet\dotnet.exe" --list-runtimes 2>$null
$OldFound = $Runtimes | Where-Object { $_ -notlike "*$TargetVersion*" }

if ($Found -and !$OldFound) {
    exit 0
} else {
    exit 1
}
