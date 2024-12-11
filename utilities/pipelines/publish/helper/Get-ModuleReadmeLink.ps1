<#
.SYNOPSIS
Get the formatted README url for the published module

.DESCRIPTION
Get the formatted README url for the published module

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder. For example: `C:\avm\res\network\private-endpoint`.

.PARAMETER TagName
Mandatory. The tag name of the module. For example: `avm/res/network/private-endpoint/1.0.0`.

.PARAMETER RegistryBaseUri
Optional. The uri of the Bicep Registry Repository file tree.

.EXAMPLE
Get-ModuleReadmeLink -ModuleRelativeFolderPath 'avm\res\network\private-endpoint' -TagName 'avm/res/network/private-endpoint/1.0.0'

Returns 'https://github.com/Azure/bicep-registry-modules/tree/avm/res/network/private-endpoint/1.0.0/avm/res/network/private-endpoint/README.md'
#>
function Get-ModuleReadmeLink {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $true)]
        [string] $TagName,

        [Parameter(Mandatory = $false)]
        [string] $RegistryBaseUri = 'https://github.com/Azure/bicep-registry-modules/tree'
    )

    $ModuleRelativeFolderPath = (($ModuleFolderPath -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
    return (('{0}/{1}/{2}/README.md' -f $RegistryBaseUri, $TagName, $ModuleRelativeFolderPath) -replace '\\', '/')
}
