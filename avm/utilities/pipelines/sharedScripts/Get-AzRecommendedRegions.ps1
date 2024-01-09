<#
.SYNOPSIS
Get the recommended regions for deployment

.DESCRIPTION
This script is used to set the deployment region for the mmodule deployment.

.PARAMETER excludeRegions
Optional. The regions to exclude from the recommended regions list.

.PARAMETER pairedRegionsOnly
Optional. If set, only paired regions will be returned.

.EXAMPLE
Get-AzRecommendedRegions -excludeRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US") -pairedRegionsOnly

Get the recommended regions excluding the regions specified in the excludeRegions parameter and only paired regions.

.EXAMPLE
Get-AzRecommendedRegions -excludeRegions @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US")

Get the recommended regions excluding the regions specified in the excludeRegions parameter.

.EXAMPLE
Get-AzRecommendedRegions -pairedRegionsOnly

Get the recommended paired regions.
#>

function Get-AzRecommendedRegions {
  param (
    [Parameter(Mandatory = $false)]
    [object]$excludeRegions = @("West Europe", "Brazil South", "West US 2", "East US 2", "South Central US"),
    [Parameter(Mandatory = $false)]
    [switch]$pairedRegionsOnly
  )

  # Get all Azure regions
  $allRegions = Get-AzLocation -ExtendedLocation $true

  $exclusions = @()

  foreach ($region in $excludeRegions) {
    if ($region -like "* *") {
      $regionToExclude = $allRegions | Where-Object { $_.DisplayName -eq $region } | Select-Object Location
      $exclusions += $regionToExclude
      Write-Verbose "Excluding region $regionToExclude"
    }
    else {
      $regionToExclude = $allRegions | Where-Object { $_.Location -eq $region } | Select-Object Location
      $exclusions += $regionToExclude
      Write-Verbose "Excluding region $regionToExclude"
    }
  }

  # Filter regions where RegionCategory is 'Recommended' and not in the excluded list
  $recommendedRegions = $allRegions | Where-Object { $_.RegionCategory -eq "Recommended" -and $_.Location -notin $exclusions.Location }
  Write-Verbose "Recommended regions: $($recommendedRegions.Location)"

  # Indexing recommended regions for later use
  # $indexedRegions = $recommendedRegions | Add-member  @{Name = "Index"; Expression = { ($recommendedRegions.IndexOf($_) + 1) } }

  if ($pairedRegionsOnly) {
    # Filter regions where PairedRegionName is not null
    $recommendedRegions = $recommendedRegions | Where-Object { $_.PairedRegion -ne $null }
    Write-Host "Paired regions only: $($recommendedRegions.Location)"
  }

  # Display indexed regions
  return $recommendedRegions

}
