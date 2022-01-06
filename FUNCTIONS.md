# VersionNumber

Text in this document is automatically created - don't change it manually

## Index

[Get-CalculatedVersionNumber](#Get-CalculatedVersionNumber)<br>

## Functions

<a name="Get-CalculatedVersionNumber"></a>
### Get-CalculatedVersionNumber

```

NAME
    Get-CalculatedVersionNumber
    
SYNOPSIS
    Calculates the next version number
    
    
SYNTAX
    Get-CalculatedVersionNumber [-Version] <Version> -Revision [-Trim] [<CommonParameters>]
    
    Get-CalculatedVersionNumber [-Version] <Version> -Build [-Trim] [<CommonParameters>]
    
    Get-CalculatedVersionNumber [-Version] <Version> -Minor [-Trim] [<CommonParameters>]
    
    Get-CalculatedVersionNumber [-Version] <Version> -Major [-Trim] [<CommonParameters>]
    
    Get-CalculatedVersionNumber -Manifest <String> -Revision [-Trim] [-DryRun] [<CommonParameters>]
    
    Get-CalculatedVersionNumber -Manifest <String> -Build [-Trim] [-DryRun] [<CommonParameters>]
    
    Get-CalculatedVersionNumber -Manifest <String> -Minor [-Trim] [-DryRun] [<CommonParameters>]
    
    Get-CalculatedVersionNumber -Manifest <String> -Major [-Trim] [-DryRun] [<CommonParameters>]
    
    
DESCRIPTION
    Calculates the next version number.
    It tries to keep the same number of digits in output as in input (unless -Trim is set).
    It returns [System.Version] that can easily be converted to string (see examples)
    
    The list of approved verbs in PowerShell really should include somthing like "Caluclate"!
    This function should normally be available with the alias Calculate-VersionNumber
    (now that Calculate isn't an approved verb)
    

PARAMETERS
    -Version <Version>
        Version number
        
    -Manifest <String>
        Read version number from manifest (.psd1) file
        Unless -DryRun is set, it will update file with new version number
        
    -Major [<SwitchParameter>]
        Bump up major number
        - '1.2.3.4' returns '2.0.0.0'
        - '6.4.2'   returns '7.0.0'
        - '3.5'     returns '4.0'
        
    -Minor [<SwitchParameter>]
        Bump up minor number
        - '1.2.3.4' returns '1.3.0.0'
        - '6.4.2'   returns '6.5.0'
        - '3.5'     returns '3.6'
        
    -Build [<SwitchParameter>]
        Bump up build number (-Patch is an alias for -Build)
        - '1.2.3.4' returns '1.2.4.0'
        - '6.4.2'   returns '6.4.3'
        - '3.5'     returns '3.5.1'   - one extra digit is added to output
        
    -Revision [<SwitchParameter>]
        Bump up revision number
        - '1.2.3.4' returns '1.2.3.5'
        - '6.4.2'   returns '6.4.2.1' - one extra digit is added to output
        - '3.5'     returns '3.5.0.1' - two extra digits are added to output
        
    -Trim [<SwitchParameter>]
        Removes zeroes
        
    -DryRun [<SwitchParameter>]
        Don't update source (manifest) file with new version number
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-CalculatedVersionNumber -Version 8.6.4.2 -Minor
    
    Bump up 8.6.4.2 with minor number
    Result is 8.7.0.0
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>[string](Get-CalculatedVersionNumber 2.2 -Patch)
    
    Bump up 2.2 with patch number and return convert to string
    Result is 2.2.1
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Calculate-VersionNumber -Version 8.6.4.2 -Major
    
    Bump up 8.6.4.2 with major number
    and use the "Calculate-VersionNumber" alias
    Result is 9.0.0.0
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-CalculatedVersionNumber -examples".
    For more information, type: "get-help Get-CalculatedVersionNumber -detailed".
    For technical information, type: "get-help Get-CalculatedVersionNumber -full".

```



