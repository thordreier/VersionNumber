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
