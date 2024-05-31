<#
.SYNOPSIS
Downloads and installs the WDK vsix.
#>

$VSIX_VERSION = "10.0.26100.0"

# Developer PowerShell
"---> Launching the developer powershell environment for wdk.vsix download and install..."
Import-Module "$env:ProgramFiles\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell -VsInstallPath "$env:ProgramFiles\Microsoft Visual Studio\2022\Enterprise"
"<--- Finished launching the developer powershell environment."

# Check if we have the WDK.vsix
"---> Checking if we have the right WDK.vsix installed..."
$installed = ls "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=*" | Select -ExpandProperty Name
"<--- Installed WDK package: $installed"
if (Test-Path "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=$VSIX_VERSION") {
    "<--- We have the correct WDK.vsix insalled."
}
else {
    "<--- We do not have the correct WDK.vsix installed."
    
    # Download amd64
    "---> Downloading the WDK.vsix for install...."
    Invoke-WebRequest -Uri "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/DriverDeveloperKits-WDK/vsextensions/WDKVsix/10.0.26100.0/vspackage?targetPlatform=5e3e564c-03bb-4499-8ae5-b2b35e9a86dc" -OutFile wdk.vsix
    "<--- Finished Downloading the WDK.vsix."

    # Force vsix install
    "---> Starting wdk.vsix install process. This will take some time to complete..."
    Start-Process vsixinstaller -ArgumentList "/f /q .\wdk.vsix" -wait
    "<--- The wdk.vsix install process finished."

    # Check the install
    "---> Checking the WDK.vsix install..."
    $installed = ls "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=*" | Select -ExpandProperty Name
    "<--- Installed WDK package: $installed"
    if (Test-Path "${env:ProgramData}\Microsoft\VisualStudio\Packages\Microsoft.Windows.DriverKit,version=$VSIX_VERSION") { 
        "<--- The WDK.vsix install is OK."
    }
    else {
        "<--- The WDK.vsix install FAILED."
        return $false
    }

    # test build
    cd "\a\Windows-driver-samples\Windows-driver-samples"
    msbuild .\general\echo\kmdf\kmdfecho.sln -clp:Verbosity=m -t:rebuild -p:TargetVersion=Windows10 -p:InfVerif_AdditionalOptions="/samples" -noLogo -property:Configuration="Debug"
}
