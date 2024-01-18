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

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName,

    [Parameter(Mandatory = $true)]
    [string] $ModuleRoot
  )

  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
  $fullModuleIdentifier = ($moduleRoot -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/'
  Write-Verbose "Full module identifier: $fullModuleIdentifier"
  $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $fullModuleIdentifier -Verbose
  Write-Verbose "Formatted resource type: $formattedResourceType"

  $type = ($formattedResourceType -split '[\/|\\]{1}')[0]
  Write-Verbose "Resource type: $type"
  $resource = ($formattedResourceType -split '[\/|\\]{1}')[1]
  Write-Verbose "Resource: $resource"

  $controlledRegionList = Get-Content -Path $RepoRoot/avm/regions.json -Raw | ConvertFrom-Json

  if ($controlledRegionList | Get-Member -Name $formattedResourceType) {
    $controlledRegions += $controlledRegionList."$($formattedResourceType)"
    $regionList = Get-AzLocation | Where-Object { $_.Location -in $controlledRegions }
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

  Write-Verbose "Region list: $($regionList.Location | ConvertTo-Json)"

  # Filter regions where RegionCategory is 'Recommended' and not in the excluded list
  $recommendedRegions = $regionList | Where-Object { $_.RegionCategory -eq "Recommended" }
  Write-Verbose "Recommended regions: $($recommendedRegions.Location | ConvertTo-Json)"

  if ($usePairedRegionsOnly) {
    # Filter regions where PairedRegionName is not null
    $recommendedRegions = $recommendedRegions | Where-Object { $_.PairedRegion -ne "{}" }
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
