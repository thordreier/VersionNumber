# VersionNumber

PowerShell functions for calculating version numbers.

## Usage

### Examples

```powershell
# Bump up version number
Calculate-VersionNumber -Version 8.6.4.2 -Major -Trim  # Returns 9.0
Calculate-VersionNumber -Version 8.6.4.2 -Major        # Returns 9.0.0.0
Calculate-VersionNumber -Version 8.6.4.2 -Minor        # Returns 8.7.0.0
Calculate-VersionNumber -Version 8.6.4.2 -Build        # Returns 8.7.5.0
Calculate-VersionNumber -Version 8.6.4.2 -Revision     # Returns 8.6.4.3
Calculate-VersionNumber -Version 9.0     -Revision     # Returns 9.0.0.1

# Manifest file
New-ModuleManifest -Path module.psd1 -ModuleVersion 0.1.2.3
Calculate-VersionNumber -Manifest module.psd1 -Minor -Trim
(Test-ModuleManifest -Path module.psd1).Version.ToString()  # Returns 0.2

```

Examples are also found in [EXAMPLES.ps1](EXAMPLES.ps1).

### Functions

See [FUNCTIONS.md](FUNCTIONS.md) for documentation of functions in this module.

## Install

### Install module from PowerShell Gallery

```powershell
Install-Module VersionNumber
```

### Install module from source

```powershell
git clone https://github.com/thordreier/VersionNumber.git
cd VersionNumber
git pull
.\Build.ps1 -InstallModule
```
