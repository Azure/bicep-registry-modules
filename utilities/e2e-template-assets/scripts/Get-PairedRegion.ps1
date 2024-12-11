<#
.SYNOPSIS
Gets the paired region (location) for a particular Azure region.

.DESCRIPTION
Gets the paired region (location) for a particular Azure region.

.PARAMETER Location
Mandatory. The name of the Azure region (i.e. AustraliaEast, australiaeast, Australia East)

.EXAMPLE
./Get-PairedRegion.ps1 -Location 'australiaeast'

Output will be 'australiasoutheast'.
#>

param(
    [string] $Location
)

# Sleep for role assignment propagation
Start-Sleep -Seconds 10

$PairedRegionName = Get-AzLocation |
    Where-Object -FilterScript { $Location -in @($PSItem.Location, $PSItem.DisplayName) } |
    Select-Object -ExpandProperty PairedRegion |
    Select-Object -ExpandProperty Name

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    pairedRegionName = $PairedRegionName
}
