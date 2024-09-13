<#
.SYNOPSIS
This Function Helps with Testing A Module Locally

.DESCRIPTION
This Function aggregates all the different token types (Default and Local) and then passes them to the Convert Tokens Script to replace tokens in a parameter file

.PARAMETER FilePathList
Mandatory. The list of file paths that contain tokens to be replaced.

.PARAMETER Tokens
Mandatory. An object containing the parameter file tokens to set

.PARAMETER AbsoluteTokens
Optional. Exact tokens to replace. These will not be prefixed or suffixed.

.PARAMETER TokenPrefix
Mandatory. The prefix used to identify a token in the parameter file (i.e. #_)

.PARAMETER TokenSuffix
Mandatory. The suffix used to identify a token in the parameter file (i.e. _#)

.PARAMETER SwapValueWithName
Optional. A boolean that enables the search for the original value and replaces it with a token. Used to revert configuration. Default is false

.PARAMETER OutputDirectory
Optional. A string for a custom output directory of the modified parameter file

.NOTES
- Make sure you provide the right information in the objects that contain tokens. This is in the form of
@(
        @{ Name = 'tenantId'; Value = '12345678-1234-1234-1234-123456789123' }

- Ensure you have the ability to perform the deployment operations using your account
- If providing TokenKeyVaultName parameter, ensure you have read access to secrets in the key vault to be able to retrieve the tokens.
#>

function Convert-TokensInFileList {
    [CmdletBinding()]
    param (
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [String[]] $FilePathList,

        [parameter(Mandatory = $false)]
        [hashtable] $Tokens = @{},

        [parameter(Mandatory = $false)]
        [hashtable] $AbsoluteTokens = @{},

        [parameter(Mandatory = $false)]
        [string] $TokenPrefix = '#_',

        [parameter(Mandatory = $false)]
        [string] $TokenSuffix = '_#',

        [parameter(Mandatory = $false)]
        [bool] $SwapValueWithName = $false,

        [parameter(Mandatory = $false)]
        [string] $OutputDirectory
    )

    begin {
        # Load used funtions
        . (Join-Path $PSScriptRoot 'helper' 'Convert-TokenInFile.ps1')
    }

    process {
        # Combine All Input Token Types, Remove Duplicates and Only Select entries with on empty values
        $FilteredTokens = ($Tokens | Sort-Object -Culture 'en-US' -Unique).Clone()
        @($FilteredTokens.Keys) | ForEach-Object {
            if ([String]::IsNullOrEmpty($FilteredTokens[$_])) {
                $FilteredTokens.Remove($_)
            }
        }
        Write-Verbose ('Using [{0}] tokens' -f $FilteredTokens.Keys.Count)

        # Apply Prefix and Suffix to Tokens and Prepare Object for Conversion
        Write-Verbose ("Applying Token Prefix '$TokenPrefix' and Token Suffix '$TokenSuffix'")
        foreach ($Token in @($FilteredTokens.Keys)) {
            $newKey = -join ($TokenPrefix, $Token, $TokenSuffix)
            $FilteredTokens[$newKey] = $FilteredTokens[$Token] # Add formatted entry
            $FilteredTokens.Remove($Token) # Replace original
        }
        # Convert Tokens in Parameter Files
        try {
            foreach ($FilePath in $FilePathList) {
                # Prepare Input to Token Converter Function
                $ConvertTokenListFunctionInput = @{
                    FilePath             = $FilePath
                    TokenNameValueObject = ($FilteredTokens ?  $FilteredTokens.Clone() : @{}) + ($AbsoluteTokens ? $AbsoluteTokens : @{})
                    SwapValueWithName    = $SwapValueWithName
                }
                if ($OutputDirectory) {
                    $ConvertTokenListFunctionInput += @{OutputDirectory = $OutputDirectory }
                }
                # Convert Tokens in the File
                Convert-TokenInFile @ConvertTokenListFunctionInput
                $ConversionStatus = $true
            }
        } catch {
            $ConversionStatus = $false
            Write-Verbose $_.Exception.Message -Verbose
        }
    }
    end {
        Write-Verbose "Token Replacement Status: $ConversionStatus"
        return [bool] $ConversionStatus
    }
}
