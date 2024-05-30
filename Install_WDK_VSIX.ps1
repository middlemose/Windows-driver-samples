<#
.SYNOPSIS
Downloads and installs the WDK vsix.
#>

# Developer PowerShell
"---> Launching the developer powershell environment for wdk.vsix download and install..."
Import-Module "$env:ProgramFiles\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath "$env:ProgramFiles\Microsoft Visual Studio\2022\Enterprise"
"<--- Finished launching the developer powershell environment."

# Download amd64
"---> Downloading the wdk.vsix...."
Invoke-WebRequest -Uri "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/DriverDeveloperKits-WDK/vsextensions/WDKVsix/10.0.26100.0/vspackage?targetPlatform=5e3e564c-03bb-4499-8ae5-b2b35e9a86dc" -OutFile wdk.vsix
"<--- Finished Downloading the wdk.vsix."

# Force vsix install
"---> Starting wdk.vsix install..."
Start-Process vsixinstaller -ArgumentList "/f /q .\wdk.vsix" -wait
"<--- The wdk.vsix install process finished."

# Check
"---> Checking the wkd.vsix install..."
if (!Test-Path "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=10.0.26100.0") { 
    return $false 
}
"<--- The wdk.vsix install is OK."
