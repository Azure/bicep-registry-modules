<#
.SYNOPSIS
Find the correct yml pipeline naming for a given resource identifier.

.DESCRIPTION
Find the correct yml pipeline naming for a given resource identifier.
If a child resource type is provided, the corresponding yml pipeline name is the one of its parent resource type

.PARAMETER ResourceIdentifier
Mandatory. The resource identifier to search for, i.e. the relative module file path starting from the resource provider folder.

.EXAMPLE
Get-PipelineFileName -ResourceIdentifier 'storage/storage-account/blob-service/container/immutability-policy'.

Returns 'ms.storage.storageaccounts.yml'.

.EXAMPLE
Get-PipelineFileName -ResourceIdentifier 'storage/storage-account'.

Returns 'ms.storage.storageaccounts.yml'.
#>
function Get-PipelineFileName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceIdentifier
    )

    . (Join-Path $PSScriptRoot 'Get-SpecsAlignedResourceName.ps1')

    $provider, $parentType, $childTypeString = $ResourceIdentifier -split '[\/|\\]', 3
    $parentResourceIdentifier = $provider, $parentType -join '/'
    $formattedParentResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $parentResourceIdentifier
    $pipelineFileName = '{0}.yml' -f (($formattedParentResourceType -replace 'Microsoft\.', 'ms.') -replace '\/', '.').ToLower()

    return $pipelineFileName
}
