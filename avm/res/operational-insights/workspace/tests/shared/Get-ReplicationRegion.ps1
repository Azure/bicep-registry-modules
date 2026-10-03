<#
.SYNOPSIS
Selects a supported Log Analytics replication region in the primary region's geography.

.PARAMETER Location
The primary workspace region.

.LINK
https://learn.microsoft.com/azure/azure-monitor/logs/workspace-replication#deployment-considerations
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $Location
)

$normalizedLocation = ($Location -replace '\s', '').ToLowerInvariant()
$regionGroups = @(
    @{
        Primary = @(
            'canadacentral', 'canadaeast', 'centralus', 'eastus', 'eastus2', 'northcentralus',
            'southcentralus', 'westcentralus', 'westus', 'westus2', 'westus3'
        )
        Secondary = @('canadacentral', 'centralus', 'eastus', 'eastus2', 'westus', 'westus2', 'westus3')
    }
    @{
        Primary = @('brazilsouth', 'brazilsoutheast')
        Secondary = @('brazilsouth', 'brazilsoutheast')
    }
    @{
        Primary = @(
            'francecentral', 'francesouth', 'germanynorth', 'germanywestcentral', 'italynorth',
            'northeurope', 'norwayeast', 'norwaywest', 'polandcentral', 'uksouth', 'spaincentral',
            'swedencentral', 'swedensouth', 'switzerlandnorth', 'switzerlandwest', 'westeurope', 'ukwest'
        )
        Secondary = @('francecentral', 'germanywestcentral', 'northeurope', 'uksouth', 'westeurope', 'ukwest')
    }
    @{
        Primary = @('qatarcentral', 'uaecentral', 'uaenorth')
        Secondary = @('qatarcentral', 'uaecentral', 'uaenorth')
    }
    @{
        Primary = @('centralindia', 'jioindiacentral', 'jioindiawest', 'southindia')
        Secondary = @('centralindia', 'jioindiacentral', 'jioindiawest', 'southindia')
    }
    @{
        Primary = @('eastasia', 'japaneast', 'japanwest', 'koreacentral', 'koreasouth', 'southeastasia')
        Secondary = @('eastasia', 'japaneast', 'japanwest', 'koreacentral', 'southeastasia')
    }
    @{
        Primary = @('australiacentral', 'australiacentral2', 'australiaeast', 'australiasoutheast')
        Secondary = @('australiacentral', 'australiaeast', 'australiasoutheast')
    }
    @{
        Primary = @('southafricanorth', 'southafricawest')
        Secondary = @('southafricanorth', 'southafricawest')
    }
)

$group = @($regionGroups | Where-Object { $normalizedLocation -in $_.Primary })
if ($group.Count -ne 1) {
    throw "Log Analytics workspace replication is not supported for primary region [$Location]."
}

$restrictedEasternRegions = @('eastus', 'eastus2', 'southcentralus')
$replicationRegion = $group[0].Secondary | Where-Object {
    $_ -ne $normalizedLocation -and
    ($normalizedLocation -notin $restrictedEasternRegions -or $_ -notin $restrictedEasternRegions)
} | Select-Object -First 1
if ([string]::IsNullOrWhiteSpace($replicationRegion)) {
    throw "No supported Log Analytics replication region is available for [$Location]."
}

$DeploymentScriptOutputs = @{
    replicationRegionName = $replicationRegion
}
