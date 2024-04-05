<#
.SYNOPSIS
Recieves an Input Object of Name/Value and Searches the Current File for the Name and Replaces it with the Value

.DESCRIPTION
Recieves an Input Object of Name/Value and Searches the Current File for the Name and Replaces it with the Value

.PARAMETER FilePath
Mandatory. Full Path for the file that contains the strings that need to be replaced. Supports multiple files comma seperated.

.PARAMETER TokenNameValueObject
Mandatory. An Object that contains the Name Key and Value Key For replacing tokens in files. See Example for structure.

.PARAMETER SwapValueWithName
Optional. A Boolean That swaps the tokens in the TokenNameValueObject Object. Used to find the Value and Swap with the Name instead. Default is False

.EXAMPLE
$Object = @(
    @{ Name = "TextA"; Value = "TextB" }
    @{ Name = "TextC"; Value = "TextD" }
)
Convert-TokenInFile -FilePath 'C:\fileA.txt','C:\fileB.txt' -TokenNameValueObject $Object

.EXAMPLE
$Object = @(
    @{ Name = "TextA"; Value = "TextB" }
    @{ Name = "TextC"; Value = "TextD" }
)
Convert-TokenInFile -FilePath 'C:\fileA.txt','C:\fileB.txt' -TokenNameValueObject $Object -OutputDirectory 'C:\customDirectory'

.EXAMPLE
$Object = @(
    @{ Name = "TextA"; Value = "TextB" }
    @{ Name = "TextC"; Value = "TextD" }
)
Convert-TokenInFile -FilePath 'C:\fileA.txt','C:\fileB.txt' -TokenNameValueObject $Object -SwapValueWithName $true
#>
function Convert-TokenInFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $FilePath,

        [Parameter(Mandatory, ValueFromPipeline = $true)]
        [psobject] $TokenNameValueObject,

        [Parameter(Mandatory = $false)]
        [string] $OutputDirectory,

        [Parameter(Mandatory = $false)]
        [bool] $SwapValueWithName = $false
    )
    # Swap Value with Name instead
    if ($SwapValueWithName) {
        Write-Verbose "Swapping 'Value' with 'Name'"
        @($TokenNameValueObject.Keys) | ForEach-Object {
            $newKey = $TokenNameValueObject[$_]
            $TokenNameValueObject[$newKey] = $_ # Add swapped entry
            $TokenNameValueObject.Remove($_) # Remove original
        }
    }
    # Begin the Replace Function
    # Process Path for Token Replacement
    foreach ($Path in $FilePath) {
        # Extract Required Content From the Input
        try {
            $File = Get-Content -Path $Path
            $FileName = Split-Path -Path $Path -Leaf
        } catch {
            throw $PSItem.Exception.Message
        }
        Write-Verbose "Processing Tokens for file: $FileName"
        # Perform the Replace of Tokens in the File
        $TokenNameValueObject.Keys | ForEach-Object {
            # If type is secure string
            if ($TokenNameValueObject[$_] -is [System.Security.SecureString]) {
                $TokenNameValueObject[$_] = $TokenNameValueObject[$_] | ConvertFrom-SecureString -AsPlainText
            }
            $File = $File -replace [Regex]::Escape($_), $TokenNameValueObject[$_]
        }
        # Set Content
        if ($OutputDirectory -and (Test-Path -Path $OutputDirectory -PathType Container)) {
            # If Specific Output Directory Provided
            $Path = Join-Path $OutputDirectory $FileName
        }
        # Set Content
        $File | Set-Content -Path $Path
    }
}
