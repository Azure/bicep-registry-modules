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

  # Load used functions
  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')

  # Configure Resource Type
  $fullModuleIdentifier = ($moduleRoot -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/'
  Write-Verbose "Full module identifier: $fullModuleIdentifier"
  $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $fullModuleIdentifier -Verbose
  Write-Verbose "Formatted resource type: $formattedResourceType"

  # Get the resource provider and resource name
  $formattedResourceProvider = ($formattedResourceType -split '[\/|\\]{1}')[0]
  Write-Verbose "Resource type: $formattedResourceProvider"
  $formattedServiceName = ($formattedResourceType -split '[\/|\\]{1}')[1]
  Write-Verbose "Resource: $formattedServiceName"

  # Load regions.json
  $controlledRegionList = Get-Content -Path $RepoRoot/avm/regions.json -Raw | ConvertFrom-Json

  # Validate if wildcard exists
  if ($controlledRegionList | Get-Member -Name "$formattedResourceProvider/*") {
    Write-Verbose "Resource provider [$formattedResourceProvider/*] is in the regions.json"
    Write-Verbose "Adding [$($controlledRegionList."$formattedResourceProvider/*")] to the controlled regions"
    $controlledRegions += $controlledRegionList."$formattedResourceProvider/*"
    Write-Verbose "Controlled regions: $($controlledRegions | ConvertTo-Json)"
    $regionList = Get-AzLocation | Where-Object { $_.Location -in $controlledRegions }
  }

  # Validate if the resource type is in the regions.json
  elseif ($controlledRegionList | Get-Member -Name $formattedResourceType) {
    write-verbose "Resource type [formattedResourceType] is in the regions.json"
    $controlledRegions += $controlledRegionList."$($formattedResourceType)"
    Write-Verbose "Controlled regions: $($controlledRegions | ConvertTo-Json)"
    Write-Verbose "Trying to fetch detailed location information"
    $regionList = Get-AzLocation | Where-Object { $_.Location -in $controlledRegions }
  }

  # Validate usage of default regions
  else {
    Write-Verbose "Resource type and provider [$formattedResourceType] is not in the regions.json"
    Write-Verbose "Trying to fetch detailed location information for resource type"
    try {
      # Fetch available locations for resource type
      $defaultRegionList = Get-AzLocation | Where-Object { $_.Location -in $controlledRegionList.default }
      $providerLocations = (Get-AzResourceProvider | Where-Object { $_.ProviderNamespace -eq $formattedResourceProvider }).ResourceTypes | Where-Object { $_.ResourceTypeName -eq $formattedServiceName }
      if ($null -ne $providerLocations) {
        Write-Verbose "Found the following locations for [$formattedResourceType]: $($providerLocations.Locations | ConvertTo-Json)"

        # Filter regions
        $regionList += $defaultRegionList | Where-Object { $providerLocations.Locations -contains $_.DisplayName }

        Write-Verbose "Using regions: $($defaultRegions.Location | ConvertTo-Json)"
      }
      else {
        # Trigger catch statement as null reponse is not an error
        throw "response is null"
      }
    }
    # Catch when the resource provider is not registered
    catch {
      Write-Verbose "Failed to fetch detailed location information for default regions"
      Write-Verbose "Ensure the resource provider [$formattedResourceProvider] is registered on the target subscription"
      Write-Verbose "Using default regions from regions.json"
      $index = Get-Random -Maximum ($controlledRegionList.default)
      $location = $controlledRegionList.default[$index]
    }
  }

  Write-Verbose "Region list: $($regionList.Location | ConvertTo-Json)"

  # Filter regions where RegionCategory is 'Recommended' and not in the excluded list
  $recommendedRegions = $regionList | Where-Object { $_.RegionCategory -eq "Recommended" }
  Write-Verbose "Filtering recommended regions: $($recommendedRegions.Location | ConvertTo-Json)"

  if ($usePairedRegionsOnly) {
    # Filter regions where PairedRegionName is not null
    $recommendedRegions = $recommendedRegions | Where-Object { $_.PairedRegion -ne "{}" }
    Write-Verbose "Filtering paired regions only: $($recommendedRegions.Location | ConvertTo-Json)"
  }

  $index = Get-Random -Maximum ($recommendedRegions.Count)
  Write-Verbose "Generated random index [$index]"

  $location = $recommendedRegions[$index].Location
  Write-Verbose "Selected location [$location]" -Verbose

  return $location
}
