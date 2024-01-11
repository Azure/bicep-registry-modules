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
Set-AzDeploymentRegion -excludedRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US") -usePairedRegionsOnly -useKnownRegionsOnly

Get the recommended regions using known regions excluding the regions specified in the excludedRegions parameter and only paired regions.

.EXAMPLE
Set-AzDeploymentRegion -excludedRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US") -usePairedRegionsOnly

Get the recommended regions excluding the regions specified in the excludedRegions parameter and only paired regions.

.EXAMPLE
Set-AzDeploymentRegion -excludedRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US")

Get the recommended regions excluding the regions specified in the excludedRegions parameter.

.EXAMPLE
Set-AzDeploymentRegion -usePairedRegionsOnly

Get the recommended paired regions.
#>

function Set-AzDeploymentRegion {
  param (
    [Parameter(Mandatory = $false)]
    [array] $excludedRegions = @(
      "westeurope",
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
      "northeurope",
      "eastus",
      "polandcentral",
      "germanywestcentral",
      "francecentral",
      "westus3",
      "australiaeast",
      "uksouth"
    )
  )

  # Load used functions
  . (join-Path $PSScriptRoot 'Get-AzRecommendedRegions.ps1')

  $regions = Get-AzRecommendedRegions -excludedRegions $excludedRegions -usePairedRegionsOnly:$usePairedRegionsOnly -useKnownRegionsOnly:$useKnownRegionsOnly -knownRegionList $knownRegionList
  Write-Verbose "Recommended regions: $($regions.Count)" -Verbose

  $index = Get-Random -Maximum ($regions.Count)
  Write-Verbose "Random index: $index" -Verbose

  $location = $regions[$index].Location
  Write-Verbose "Random location: $location" -Verbose

  return $location
}
