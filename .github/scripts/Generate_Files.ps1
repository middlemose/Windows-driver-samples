<#

.SYNOPSIS
Generates the props and config file for overall less maintenance.

#>

$build_number = "$env:VERBOSE_BUILD_NUMBER"

# generate Directory.Build.props
@"
<Project>
<Import Project="packages\Microsoft.Windows.WDK.x64.$build_number\build\native\Microsoft.Windows.WDK.x64.props" Condition="Exists('packages\Microsoft.Windows.WDK.x64.$build_number\build\native\Microsoft.Windows.WDK.x64.props') and '`$(Platform)' == 'x64'"/>
<Import Project="packages\Microsoft.Windows.WDK.arm64.$build_number\build\native\Microsoft.Windows.WDK.arm64.props" Condition="Exists('packages\Microsoft.Windows.WDK.arm64.$build_number\build\native\Microsoft.Windows.WDK.arm64.props') and '`$(Platform)' == 'ARM64'"/>
<Import Project="packages\Microsoft.Windows.SDK.CPP.x64.$build_number\build\native\Microsoft.Windows.SDK.cpp.x64.props" Condition="Exists('packages\Microsoft.Windows.SDK.CPP.x64.$build_number\build\native\Microsoft.Windows.SDK.cpp.x64.props') and '`$(Platform)' == 'x64'"/>
<Import Project="packages\Microsoft.Windows.SDK.CPP.arm64.$build_number\build\native\Microsoft.Windows.SDK.cpp.arm64.props" Condition="Exists('packages\Microsoft.Windows.SDK.CPP.arm64.$build_number\build\native\Microsoft.Windows.SDK.cpp.arm64.props') and '`$(Platform)' == 'ARM64'"/>
<Import Project="packages\Microsoft.Windows.SDK.CPP.$build_number\build\native\Microsoft.Windows.SDK.cpp.props" Condition="Exists('packages\Microsoft.Windows.SDK.CPP.$build_number\build\native\Microsoft.Windows.SDK.cpp.props')"/>
</Project>
"@ > "$env:GITHUB_WORKSPACE\Directory.Build.props"
Test-Path "$env:GITHUB_WORKSPACE\Directory.Build.props"

# generate packages.config
@"
<?xml version="1.0" encoding="utf-8"?>
<packages>
  <package id="Microsoft.Windows.SDK.CPP" version="$build_number" targetFramework="native" />
  <package id="Microsoft.Windows.SDK.CPP.x64" version="$build_number" targetFramework="native" />
  <package id="Microsoft.Windows.SDK.CPP.arm64" version="$build_number" targetFramework="native" />
  <package id="Microsoft.Windows.WDK.x64" version="$build_number" targetFramework="native" />
  <package id="Microsoft.Windows.WDK.arm64" version="$build_number" targetFramework="native" />
</packages>
"@ > "$env:GITHUB_WORKSPACE\packages.config"
Test-Path "$env:GITHUB_WORKSPACE\packages.config"