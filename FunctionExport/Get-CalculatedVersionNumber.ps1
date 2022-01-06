function Get-CalculatedVersionNumber
{
    <#
        .SYNOPSIS
            Calculates the next version number

        .DESCRIPTION
            Calculates the next version number.
            It tries to keep the same number of digits in output as in input (unless -Trim is set).
            It returns [System.Version] that can easily be converted to string (see examples)

            The list of approved verbs in PowerShell really should include somthing like "Caluclate"!
            This function should normally be available with the alias Calculate-VersionNumber
            (now that Calculate isn't an approved verb)

        .PARAMETER Version
            Version number

        .PARAMETER Manifest
            Read version number from manifest (.psd1) file
            Unless -DryRun is set, it will update file with new version number

        .PARAMETER Major
            Bump up major number
            - '1.2.3.4' returns '2.0.0.0'
            - '6.4.2'   returns '7.0.0'
            - '3.5'     returns '4.0'

        .PARAMETER Minor
            Bump up minor number
            - '1.2.3.4' returns '1.3.0.0'
            - '6.4.2'   returns '6.5.0'
            - '3.5'     returns '3.6'

        .PARAMETER Build
            Bump up build number (-Patch is an alias for -Build)
            - '1.2.3.4' returns '1.2.4.0'
            - '6.4.2'   returns '6.4.3'
            - '3.5'     returns '3.5.1'   - one extra digit is added to output

        .PARAMETER Revision
            Bump up revision number
            - '1.2.3.4' returns '1.2.3.5'
            - '6.4.2'   returns '6.4.2.1' - one extra digit is added to output
            - '3.5'     returns '3.5.0.1' - two extra digits are added to output

        .PARAMETER Trim
            Removes zeroes

        .PARAMETER DryRun
            Don't update source (manifest) file with new version number

        .EXAMPLE
            Get-CalculatedVersionNumber -Version 8.6.4.2 -Minor
            Bump up 8.6.4.2 with minor number
            Result is 8.7.0.0

        .EXAMPLE
            [string](Get-CalculatedVersionNumber 2.2 -Patch)
            Bump up 2.2 with patch number and return convert to string
            Result is 2.2.1

        .EXAMPLE
            Calculate-VersionNumber -Version 8.6.4.2 -Major
            Bump up 8.6.4.2 with major number
            and use the "Calculate-VersionNumber" alias
            Result is 9.0.0.0
    #>

    [OutputType([System.Version])]
    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName='Major',            Mandatory = $true, Position=0)]
        [Parameter(ParameterSetName='Minor',            Mandatory = $true, Position=0)]
        [Parameter(ParameterSetName='Build',            Mandatory = $true, Position=0)]
        [Parameter(ParameterSetName='Revision',         Mandatory = $true, Position=0)]
        [System.Version]
        $Version,

        [Parameter(ParameterSetName='ManifestMajor',    Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestMinor',    Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestBuild',    Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestRevision', Mandatory = $true)]
        [System.String]
        $Manifest,

        [Parameter(ParameterSetName='Major',            Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestMajor',    Mandatory = $true)]
        [System.Management.Automation.SwitchParameter]
        $Major,

        [Parameter(ParameterSetName='Minor',            Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestMinor',    Mandatory = $true)]
        [System.Management.Automation.SwitchParameter]
        $Minor,

        [Parameter(ParameterSetName='Build',            Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestBuild',    Mandatory = $true)]
        [Alias('Patch')]
        [System.Management.Automation.SwitchParameter]
        $Build,

        [Parameter(ParameterSetName='Revision',         Mandatory = $true)]
        [Parameter(ParameterSetName='ManifestRevision', Mandatory = $true)]
        [System.Management.Automation.SwitchParameter]
        $Revision,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Trim,

        [Parameter(ParameterSetName='ManifestMajor'   )]
        [Parameter(ParameterSetName='ManifestMinor'   )]
        [Parameter(ParameterSetName='ManifestBuild'   )]
        [Parameter(ParameterSetName='ManifestRevision')]
        [System.Management.Automation.SwitchParameter]
        $DryRun
    )

    function _Add([System.Int32]$v, [System.Int32]$i=1)
    {
        if ($v -eq -1)
        {
            $i
        }
        else
        {
            $v + $i
        }
    }

    function _Rst([System.Int32]$v)
    {
        if ($v -eq -1)
        {
            -1
        }
        else
        {
            0
        }
    }

    Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
    $origErrorActionPreference = $ErrorActionPreference

    try
    {
        # Stop execution inside this function, and catch the error
        $ErrorActionPreference = 'Stop'

        Write-Verbose -Message "Input version: $Version"
        Write-Verbose -Message ('Input ParameterSetName: ' + $PsCmdlet.ParameterSetName)

        if ($Manifest)
        {
            Write-Verbose -Message "Getting version from manifest file <$Manifest>"
            $Version = (Test-ModuleManifest -Path $Manifest).Version
        }

        Write-Verbose -Message "Version number before changes: $Version"

        if ($Major)
        {
            Write-Verbose -Message 'Bumping up major number'
            $vMajor    = _Add $Version.Major
            $vMinor    = _Rst $Version.Minor
            $vBuild    = _Rst $Version.Build
            $vRevision = _Rst $Version.Revision
        }
        elseif ($Minor)
        {
            Write-Verbose -Message 'Bumping up minor number'
            $vMajor    =      $Version.Major
            $vMinor    = _Add $Version.Minor
            $vBuild    = _Rst $Version.Build
            $vRevision = _Rst $Version.Revision
        }
        elseif ($Build)
        {
            Write-Verbose -Message 'Bumping up build number'
            $vMajor    =      $Version.Major
            $vMinor    =      $Version.Minor
            $vBuild    = _Add $Version.Build
            $vRevision = _Rst $Version.Revision
        }
        elseif ($Revision)
        {
            Write-Verbose -Message 'Bumping up revision number'
            $vMajor    =      $Version.Major
            $vMinor    =      $Version.Minor
            $vBuild    = _Add $Version.Build 0
            $vRevision = _Add $Version.Revision
        }
        else
        {
            throw 'This should never happen'
        }

        if (-not ($vRevision -eq -1 -or ($vRevision -eq 0 -and $Trim)))
        {
            $return = New-Object -TypeName 'System.Version' -ArgumentList $vMajor, $vMinor, $vBuild, $vRevision
        }
        elseif (-not ($vBuild -eq -1 -or ($vBuild -eq 0 -and $Trim)))
        {
            $return = New-Object -TypeName 'System.Version' -ArgumentList $vMajor, $vMinor, $vBuild
        }
        else
        {
            $return = New-Object -TypeName 'System.Version' -ArgumentList $vMajor, $vMinor
        }

        if ($Manifest -and -not $DryRun)
        {
            Write-Verbose -Message "Updating version in manifest file <$Manifest>"
            Update-ModuleManifest -Path $Manifest -ModuleVersion $return
        }

        # Return
        Write-Verbose  -Message "Returning version number $return"
        $return
    }
    catch
    {
        # If error was encountered inside this function then stop doing more
        # But still respect the ErrorAction that comes when calling this function
        # And also return the line number where the original error occured
        $msg = $_.ToString() + "`r`n" + $_.InvocationInfo.PositionMessage.ToString()
        Write-Verbose -Message "Encountered an error: $msg"
        Write-Error -ErrorAction $origErrorActionPreference -Exception $_.Exception -Message $msg
    }
    finally
    {
        $ErrorActionPreference = $origErrorActionPreference
    }

    Write-Verbose -Message 'End'
}
