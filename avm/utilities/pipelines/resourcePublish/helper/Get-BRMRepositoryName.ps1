<#
.SYNOPSIS
Convert the given template file path into a valid Container Registry repository name

.DESCRIPTION
Convert the given template file path into a valid Container Registry repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.EXAMPLE
Get-BRMRepositoryName -TemplateFilePath 'C:\avm\key-vault\vault\main.bicep'

Convert 'C:\avm\key-vault\vault\main.bicep' to e.g. 'avm-res-keyvault-vault'
#>
function Get-BRMRepositoryName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath
    )

    $moduleIdentifier = ((Split-Path $TemplateFilePath -Parent) -split '[\/|\\]avm[\/|\\]')[-1]
    $formattedModuleIdentifier = ($moduleIdentifier -replace '-', '') -replace '[\/|\\]', '-'

    return "avm-$formattedModuleIdentifier"
}
