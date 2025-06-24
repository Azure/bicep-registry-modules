<#
.SYNOPSIS
Based on the provided parameter metadata, determine whether the parameter is required or not

.DESCRIPTION
Based on the provided parameter metadata, determine whether the parameter is required or not

.PARAMETER Parameter
Mandatory. The parameter metadata to analyze.

For example: @{
    type     = 'string'
    metadata = @{
        description = 'Required. The name of the Public IP Address.'
    }
}

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from.

.EXAMPLE
Get-IsParameterRequired -TemplateFileContent @{ resource = @{}; ... } -Parameter @{ type = 'string'; metadata = @{ description = 'Required. The name of the Public IP Address.' } }

Check the given parameter whether it is required. Would result into true.
#>
function Get-IsParameterRequired {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $Parameter,

        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent
    )

    $hasParameterNoDefault = $Parameter.Keys -notcontains 'defaultValue'
    $isParameterNullable = $Parameter['nullable']
    # User defined type
    $isUserDefinedType = $Parameter.Keys -contains '$ref'
    $isUserDefinedTypeNullable = $Parameter.Keys -contains '$ref' ? $TemplateFileContent.definitions[(Split-Path $Parameter.'$ref' -Leaf)]['nullable'] : $false

    # Evaluation
    # The parameter is required IF it
    # - has no default value,
    # - is not nullable
    # - has no nullable user-defined type
    return $hasParameterNoDefault -and -not $isParameterNullable -and -not ($isUserDefinedType -and $isUserDefinedTypeNullable)
}
