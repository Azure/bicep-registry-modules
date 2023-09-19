<#
.SYNOPSIS
Convert the given template file path into a valid Container Registry repository name

.DESCRIPTION
Convert the given template file path into a valid Container Registry repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.EXAMPLE
Get-PrivateRegistryRepositoryName -TemplateFilePath 'C:\avm\key-vault\vault\main.bicep'

Convert 'C:\avm\key-vault\vault\main.bicep' to e.g. 'bicep/avm/key-vault.vault'
#>
function Get-PrivateRegistryRepositoryName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/avm/')[1]

    $moduleRegistryIdentifier = 'bicep/avm/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

    return $moduleRegistryIdentifier
}
