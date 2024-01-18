<#
.SYNOPSIS
Set the deployment region for the module deployment

.DESCRIPTION
This script is used to set the deployment region for the module deployment.

.PARAMETER usePairedRegionsOnly
Optional. If set, only paired regions will be returned.

.PARAMETER moduleRoot
Optional. If set, only known regions will be returned.

.EXAMPLE
Get-AzDeploymentRegion -usePairedRegionsOnly -ModuleRoot $ModuleRoot

Get the recommended paired regions.
#>

function Get-AzDeploymentRegion {
  param (

    [Parameter(Mandatory = $false)]
    [cmdletbinding()]
    [switch] $usePairedRegionsOnly,

    [Parameter(Mandatory = $true)]
    [string] $ModuleRoot
  )

  . (Join-Path $PSScriptRoot 'helper' 'Get-SpecsAlignedResourceName.ps1')
  $fullModuleIdentifier = ($moduleRoot -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/'
  $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $FullModuleIdentifier

  $type = ($fullModuleIdentifier -split '[\/|\\]{1}')[2]
  $resource = ($fullModuleIdentifier -split '[\/|\\]{1}')[3]

  $controlledRegionList = Get-Content -Path $PSScriptRoot/regions.json -Raw | ConvertFrom-Json

  if ($controlledRegionList | Get-Member -Name $type) {
    $recommendedRegions += $controlledRegionList[$formattedResourceType]
  }
  else {
    $providerLocations = (Get-AzResourceProvider | Where-Object { $_.ProviderNamespace -eq $type }).ResourceTypes | Where-Object { $_.ResourceTypeName -eq $resource }
    foreach ($location in $controlledRegionList.default ) {
      if ($providerLocations.Locations -contains $location) {
        $defaultRegions += $location
      }
    }

    $regionList = Get-AzLocation | Where-Object { $_.Location -in $defaultRegions }
  }

  # Filter regions where RegionCategory is 'Recommended' and not in the excluded list
  $recommendedRegions = $regionList | Where-Object { $_.RegionCategory -eq "Recommended" }
  Write-Verbose "Recommended regions: $($recommendedRegions.Location | ConvertTo-Json)"

  if ($usePairedRegionsOnly) {
    # Filter regions where PairedRegionName is not null
    $recommendedRegions = $recommendedRegions | Where-Object { -not ([array]::IsNullOrEmpty($_.PairedRegion)) }
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
