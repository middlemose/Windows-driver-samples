<#

.SYNOPSIS
Downloads and installs the WDK vsix.

#>

# Developer PowerShell
"---> Launching the developer powershell environment for WDK.vsix download and install..."
Import-Module (Resolve-Path "$env:ProgramFiles\Microsoft Visual Studio\2022\*\Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
Enter-VsDevShell -VsInstallPath (Resolve-Path "$env:ProgramFiles\Microsoft Visual Studio\2022\*")
"<--- Finished launching the developer powershell environment."

# Check if we have the WDK.vsix
"---> Checking if we have the right WDK.vsix installed..."
$installed = ls "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=*" | Select -ExpandProperty Name
"<--- Installed WDK.vsix version: $installed"
if (Test-Path "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=$env:VSIX_VERSION") {
    "<--- We have the correct WDK.vsix insalled."
}
else {
    "<--- We do not have the correct WDK.vsix installed."
    
    # Download amd64
    "---> Downloading the WDK.vsix for install...."
    Invoke-WebRequest -Uri "$env:VSIX_URI" -OutFile wdk.vsix
    "<--- Finished Downloading the WDK.vsix."

    # Force vsix install
    "---> Starting WDK.vsix install process. This will take some time to complete..."
    Start-Process vsixinstaller -ArgumentList "/f /q .\wdk.vsix" -wait
    "<--- The WDK.vsix install process finished."

    # Check the install
    "---> Checking the WDK.vsix version installed..."
    $installed = ls "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=*" | Select -ExpandProperty Name
    "<--- Installed WDK.vsix version: $installed"
    if (Test-Path "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=$env:VSIX_VERSION") { 
        "<--- The WDK.vsix version is OK."
    }
    else {
        "<--- The WDK.vsix install FAILED."
        return $false
    }
}
