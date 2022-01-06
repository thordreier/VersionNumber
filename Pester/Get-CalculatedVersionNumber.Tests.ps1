Describe 'Get-CalculatedVersionNumber' {

    It 'Positional argmuent' {
        $v = Get-CalculatedVersionNumber 1.1 -Major -ErrorAction Stop
        $v | Should -BeOfType 'System.Version'
        $v | Should -Be '2.0'
    }

    It 'Get-CalculatedVersionNumber -Version <Version> -<Type> == <Result>' -TestCases @(
        @{Version = '1.2'    ; Type = 'Major'   ; Result = '2.0'    }
        @{Version = '1.2'    ; Type = 'Minor'   ; Result = '1.3'    }
        @{Version = '1.2'    ; Type = 'Patch'   ; Result = '1.2.1'  }
        @{Version = '1.2'    ; Type = 'Revision'; Result = '1.2.0.1'}
        @{Version = '1.2.3'  ; Type = 'Major'   ; Result = '2.0.0'  }
        @{Version = '1.2.3'  ; Type = 'Minor'   ; Result = '1.3.0'  }
        @{Version = '1.2.3'  ; Type = 'Patch'   ; Result = '1.2.4'  }
        @{Version = '1.2.3'  ; Type = 'Revision'; Result = '1.2.3.1'}
        @{Version = '1.2.3.0'; Type = 'Major'   ; Result = '2.0.0.0'}
        @{Version = '1.2.3.0'; Type = 'Minor'   ; Result = '1.3.0.0'}
        @{Version = '1.2.3.0'; Type = 'Build'   ; Result = '1.2.4.0'}
        @{Version = '1.2.3.0'; Type = 'Revision'; Result = '1.2.3.1'}
        @{Version = '1.2.3.4'; Type = 'Major'   ; Result = '2.0.0.0'}
        @{Version = '6.4.2'  ; Type = 'Major'   ; Result = '7.0.0'  }
        @{Version = '3.5'    ; Type = 'Major'   ; Result = '4.0'    }
        @{Version = '1.2.3.4'; Type = 'Minor'   ; Result = '1.3.0.0'}
        @{Version = '6.4.2'  ; Type = 'Minor'   ; Result = '6.5.0'  }
        @{Version = '3.5'    ; Type = 'Minor'   ; Result = '3.6'    }
        @{Version = '1.2.3.4'; Type = 'Build'   ; Result = '1.2.4.0'}
        @{Version = '6.4.2'  ; Type = 'Build'   ; Result = '6.4.3'  }
        @{Version = '3.5'    ; Type = 'Build'   ; Result = '3.5.1'  }
        @{Version = '1.2.3.4'; Type = 'Revision'; Result = '1.2.3.5'}
        @{Version = '6.4.2'  ; Type = 'Revision'; Result = '6.4.2.1'}
        @{Version = '3.5'    ; Type = 'Revision'; Result = '3.5.0.1'}
    ) {
        param ($Version, $Type, $Result)
        $param = @{
            Version = $Version
            "$Type" = $true
        }
        $v = Get-CalculatedVersionNumber @param -ErrorAction Stop
        $v | Should -BeOfType 'System.Version'
        $v | Should -Be $Result
    }

    It 'Get-CalculatedVersionNumber -Trim -Version <Version> -<Type> == <Result>' -TestCases @(
        @{Version = '1.2'    ; Type = 'Major'   ; Result = '2.0'    }
        @{Version = '1.2'    ; Type = 'Minor'   ; Result = '1.3'    }
        @{Version = '1.2'    ; Type = 'Patch'   ; Result = '1.2.1'  }
        @{Version = '1.2'    ; Type = 'Revision'; Result = '1.2.0.1'}
        @{Version = '1.2.3'  ; Type = 'Major'   ; Result = '2.0'    }
        @{Version = '1.2.3'  ; Type = 'Minor'   ; Result = '1.3'    }
        @{Version = '1.2.3'  ; Type = 'Patch'   ; Result = '1.2.4'  }
        @{Version = '1.2.3'  ; Type = 'Revision'; Result = '1.2.3.1'}
        @{Version = '1.2.3.0'; Type = 'Major'   ; Result = '2.0'    }
        @{Version = '1.2.3.0'; Type = 'Minor'   ; Result = '1.3'    }
        @{Version = '1.2.3.0'; Type = 'Build'   ; Result = '1.2.4'  }
        @{Version = '1.2.3.0'; Type = 'Revision'; Result = '1.2.3.1'}
        @{Version = '1.2.3.4'; Type = 'Major'   ; Result = '2.0'    }
        @{Version = '6.4.2'  ; Type = 'Major'   ; Result = '7.0'    }
        @{Version = '3.5'    ; Type = 'Major'   ; Result = '4.0'    }
        @{Version = '1.2.3.4'; Type = 'Minor'   ; Result = '1.3'    }
        @{Version = '6.4.2'  ; Type = 'Minor'   ; Result = '6.5'    }
        @{Version = '3.5'    ; Type = 'Minor'   ; Result = '3.6'    }
        @{Version = '1.2.3.4'; Type = 'Build'   ; Result = '1.2.4'  }
        @{Version = '6.4.2'  ; Type = 'Build'   ; Result = '6.4.3'  }
        @{Version = '3.5'    ; Type = 'Build'   ; Result = '3.5.1'  }
        @{Version = '1.2.3.4'; Type = 'Revision'; Result = '1.2.3.5'}
        @{Version = '6.4.2'  ; Type = 'Revision'; Result = '6.4.2.1'}
        @{Version = '3.5'    ; Type = 'Revision'; Result = '3.5.0.1'}
    ) {
        param ($Version, $Type, $Result)
        $param = @{
            Version = $Version
            "$Type" = $true
        }
        $v = Get-CalculatedVersionNumber -Trim @param -ErrorAction Stop
        $v | Should -BeOfType 'System.Version'
        $v | Should -Be $Result
    }

    It 'Manifest' {
        $manifest = (New-TemporaryFile -ErrorAction Stop).FullName + '.psd1'  # FIXXXME cleanup both .tmp and .psd1 file
        New-ModuleManifest -Path $manifest -ModuleVersion 3.4 -ErrorAction Stop
        $v = Get-CalculatedVersionNumber -Manifest $manifest -Minor -ErrorAction Stop
        $v | Should -BeOfType 'System.Version'
        $v | Should -Be '3.5'  # Changed
        (Test-ModuleManifest -Path $manifest).Version | Should -Be '3.5'  # Changed
    }

    It 'Manifest DryRun' {
        $manifest = (New-TemporaryFile -ErrorAction Stop).FullName + '.psd1'  # FIXXXME cleanup both .tmp and .psd1 file
        New-ModuleManifest -Path $manifest -ModuleVersion 9.8.7.6 -ErrorAction Stop
        $v = Get-CalculatedVersionNumber -Manifest $manifest -Build -DryRun -ErrorAction Stop
        $v | Should -BeOfType 'System.Version'
        $v | Should -Be '9.8.8.0'  # Changed
        (Test-ModuleManifest -Path $manifest).Version | Should -Be '9.8.7.6'  # Unchanged
    }

    It 'No arguments set' {
        {Get-CalculatedVersionNumber -ErrorAction Stop} | Should -Throw 'Parameter set cannot be resolved using the specified named parameters*'
    }

    It 'Only -Version argmuent' {
        {Get-CalculatedVersionNumber -Version 1.0 -ErrorAction Stop} | Should -Throw 'Parameter set cannot be resolved using the specified named parameters*'
    }

    It 'Only -Version argmuent, not [version] type' {
        {Get-CalculatedVersionNumber -Version xxx -ErrorAction Stop} | Should -Throw 'Cannot process argument transformation on parameter*'
    }

    It 'Not [version]' {
        {Get-CalculatedVersionNumber -Version xxx -Minor -ErrorAction Stop} | Should -Throw 'Cannot process argument transformation on parameter*'
    }

    It 'Int overflow' {
        {Get-CalculatedVersionNumber -Version 2147483647.0 -Major -ErrorAction Stop} | Should -Throw 'Cannot convert*'
    }
}
