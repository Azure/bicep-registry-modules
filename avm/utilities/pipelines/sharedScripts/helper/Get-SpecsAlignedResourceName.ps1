<#
.SYNOPSIS
Remove a string to its core - i.e. the part the neither indicates plural nor singular.

.DESCRIPTION
Remove a string to its core - i.e. the part the neither indicates plural nor singular.

.PARAMETER StringToReduce
Mandatory. The string to reduce.

.EXAMPLE
Get-ReducedWordString -StringToReduce 'virtualMachines'

Returns 'virtualMachine'.

.EXAMPLE
Get-ReducedWordString -StringToReduce 'factories'

Returns 'factor'.
#>
function Get-ReducedWordString {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $StringToReduce
    )

    if ($StringToReduce -match '(.+?)(y|ii|e|ys|ies|es|s)$') {
        return $Matches[1]
    }

    return $StringToReduce
}

<#
.SYNOPSIS
Try to find the actual provider namespace and resource type for a given resource identifier.

.DESCRIPTION
Try to find the actual provider namespace and resource type for a given resource identifier.
For example, for 'virtual-machine-images/image-template' it we want to find 'Microsoft.VirtualMachineImages/imageTemplates'.

.PARAMETER ResourceIdentifier
Mandatory. The resource identifier to search for.

.PARAMETER SpecsFilePath
Optional. The path to the specs file that contains all available provider namespaces & resource types. Defaults to 'utilities/src/apiSpecsList.json'.

.EXAMPLE
Get-SpecsAlignedResourceName -ResourceIdentifier 'virtual-machine-images/image-template'.

Returns 'Microsoft.VirtualMachineImages/imageTemplates'.
#>
function Get-SpecsAlignedResourceName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceIdentifier,

        [Parameter(Mandatory = $false)]
        [string] $ApiSpecsFileUri = 'https://azure.github.io/Azure-Verified-Modules/governance/apiSpecsList.json'
    )

    try {
        $apiSpecs = Invoke-WebRequest -Uri $ApiSpecsFileUri
        $specs = ConvertFrom-Json $apiSpecs.Content -AsHashtable
    } catch {
        Write-Warning "Failed to download API specs file from [$ApiSpecsFileUri]"
        $specs = @{}
    }

    $reducedResourceIdentifier = $ResourceIdentifier -replace '-'

    $rawProviderNamespace, $rawResourceType = $reducedResourceIdentifier -Split '[\/|\\]', 2 # e.g. 'keyvault' & 'vaults/keys'

    # Find provider namespace
    $foundProviderNamespaceMatches = ($specs.Keys | Sort-Object -Culture 'en-US') | Where-Object { $_ -like "Microsoft.$rawProviderNamespace*" }

    if (-not $foundProviderNamespaceMatches) {
        $providerNamespace = "Microsoft.$rawProviderNamespace"
        Write-Warning "Failed to identify provider namespace [$rawProviderNamespace]. Falling back to [$providerNamespace]."
    } else {
        $providerNamespace = ($foundProviderNamespaceMatches.Count -eq 1) ? $foundProviderNamespaceMatches : $foundProviderNamespaceMatches[0]
    }

    # Find resource type
    $innerResourceTypes = $specs[$providerNamespace].Keys | Sort-Object -Culture 'en-US'

    $rawResourceTypeElem = $rawResourceType -split '[\/|\\]'
    $reducedResourceTypeElements = $rawResourceTypeElem | ForEach-Object { Get-ReducedWordString -StringToReduce $_ }

    ## We built a regex that matches the resource type, but also the plural and singular form of it along its entire path. For example ^vault(y|ii|e|ys|ies|es|s|)(\/|$)key(y|ii|e|ys|ies|es|s|)(\/|$)$
    ### (y|ii|e|ys|ies|es|s|) = Singular or plural form
    ### (\/|$)                = End of string or another resource type level
    $resourceTypeRegex = '^{0}(y|ii|e|ys|ies|es|s|ses|)(\/|$)$' -f ($reducedResourceTypeElements -join '(y|ii|e|ys|ies|es|s|ses|)(\/|$)')
    $resourceType = $innerResourceTypes | Where-Object { $_ -match $resourceTypeRegex }

    # Special case handling: Ambiguous resource types (usually incorrect RP implementations)
    if ($resourceType.count -gt 1) {
        switch ($rawResourceType) {
            'service/api/policy' {
                # Setting explicitly as both [apimanagement/service/apis/policies] & [apimanagement/service/apis/policy] exist in the specs and the later seem to have been an initial incorrect publish (only one API version exists)
                $resourceType = 'service/apis/policies'
            }
            Default {
                throw ('Found ambiguous resource types [{0}] for identifier [{1}]' -f ($resourceType -join ','), $rawResourceType)
            }
        }
    }

    # Special case handling: If no resource type is found, fall back one level (e.g., for 'authorization\role-definition\management-group' as 'management-group' in this context is no actual resource type)
    if (-not $resourceType) {
        $fallbackResourceTypeRegex = '{0}$' -f ($resourceTypeRegex -split $reducedResourceTypeElements[-1])[0]
        $resourceType = $innerResourceTypes | Where-Object { $_ -match $fallbackResourceTypeRegex }
        if (-not $resourceType) {
            # if we still don't find anything (because the resource type straight up does not exist, we fall back to itself as the default)
            Write-Warning "Resource type [$rawResourceType] cannot be found or does not exist in the API specs / is custom. Falling back to it as default."
            $resourceType = $rawResourceType
        } else {
            Write-Warning ('Failed to find exact match between core matched resource types and [{0}]. Fallback on [{1}].' -f $rawResourceType, (Split-Path $rawResourceType -Parent))
        }
    }

    # Build result
    return "$providerNamespace/$resourceType"
}
