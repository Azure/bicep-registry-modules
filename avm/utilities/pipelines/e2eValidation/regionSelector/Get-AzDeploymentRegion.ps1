<#
.SYNOPSIS
Set the deployment region for the module deployment

.DESCRIPTION
This script is used to set the deployment region for the module deployment.

.PARAMETER excludedRegions
Optional. The regions to exclude from the recommended regions list.

.PARAMETER usePairedRegionsOnly
Optional. If set, only paired regions will be returned.

.PARAMETER useKnownRegionsOnly
Optional. If set, only known regions will be returned.

.PARAMETER knownRegionList
Optional. The list of known regions to use when useKnownRegionsOnly is set. ARM Deployment are limited to 10 active deployment regions per subscription.

.EXAMPLE
Get-AzDeploymentRegion -excludedRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US") -usePairedRegionsOnly -useKnownRegionsOnly

Get the recommended regions using known regions excluding the regions specified in the excludedRegions parameter and only paired regions.

.EXAMPLE
Get-AzDeploymentRegion -excludedRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US") -usePairedRegionsOnly

Get the recommended regions excluding the regions specified in the excludedRegions parameter and only paired regions.

.EXAMPLE
Get-AzDeploymentRegion -excludedRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US")

Get the recommended regions excluding the regions specified in the excludedRegions parameter.

.EXAMPLE
Get-AzDeploymentRegion -usePairedRegionsOnly

Get the recommended paired regions.
#>

function Get-AzDeploymentRegion {
  param (
    [Parameter(Mandatory = $false)]
    [array] $excludedRegions = @(
      # "westeurope",
      "westus2",
      "eastus2",
      "centralus",
      "southcentralus",
      "brazilsouth",
      "koreacentral",
      "qatarcentral"
    ),

    [Parameter(Mandatory = $false)]
    [cmdletbinding()]
    [switch] $usePairedRegionsOnly,

    [Parameter(Mandatory = $false)]
    [cmdletbinding()]
    [switch] $useKnownRegionsOnly,

    [Parameter(Mandatory = $false)]
    [array] $knownRegionList = @(
      "westeurope"
    )
  )

  $allRegions = Get-AzLocation -ExtendedLocation $true

  # Filter regions where Location is in the known regions list
  if ($useKnownRegionsOnly) {
    $regionList = $allRegions | Where-Object { $_.Location -in $knownRegionList }
  }
  else {
    $regionList = $allRegions
  }


  $exclusions = @()
  $exclusions = $excludedRegions | Where-Object { $_ -in ($_ -like '* *' ? $regionList.DisplayName : $regionList.Location) }
  Write-Verbose ('Excluding regions: {0}' -f ($exclusions | ConvertTo-Json)) -Verbose


  # Filter regions where RegionCategory is 'Recommended' and not in the excluded list
  $recommendedRegions = $regionList | Where-Object { $_.RegionCategory -eq "Recommended" -and $_.Location -notin $exclusions }
  Write-Verbose "Recommended regions: $($recommendedRegions.Location | ConvertTo-Json)"

  if ($usePairedRegionsOnly) {
    # Filter regions where PairedRegionName is not null
    $recommendedRegions = $recommendedRegions | Where-Object { $null -ne $_.PairedRegion }
    Write-Verbose "Paired regions only: $($recommendedRegions.Location | ConvertTo-Json)"
  }

  # Display indexed regions
  Write-Verbose "Recommended regions: $($recommendedRegions.Location | ConvertTo-Json)" -Verbose

  $index = Get-Random -Maximum ($recommendedRegions.Count)
  Write-Verbose "Generated random index [$index]"

  $location = $recommendedRegions[$index].Location
  Write-Verbose "Selected location [$location]" -Verbose

  return $location
}
