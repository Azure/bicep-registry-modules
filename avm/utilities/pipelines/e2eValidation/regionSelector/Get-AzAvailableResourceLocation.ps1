<#
.SYNOPSIS
Set the location for the resource deployment.

.DESCRIPTION
This script is used to set the location for the resource deployment.

.PARAMETER ExcludedRegions
Optional. The list of regions to be excluded from the selection.

.PARAMETER moduleRoot
Required. The root path of the module.

.PARAMETER repoRoot
Optional. The root path of the repository.

.PARAMETER GlobalResourceGroupLocation
Required. The location of the resource group where the global resources will be deployed.

.EXAMPLE
Get-AzAvailableResourceLocation -ModuleRoot ".\avm\res\resources\resource-group" -repoRoot .\

Get the recommended paired regions available for the service.
#>

function Get-AzAvailableResourceLocation {
  param (

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.parent.FullName,

    [Parameter(Mandatory = $true)]
    [string] $ModuleRoot,

    [Parameter(Mandatory = $false)]
    [string] $GlobalResourceGroupLocation,

    [Parameter(Mandatory = $false)]
    [array] $ExcludedRegions = @(
      "asiasoutheast",
      "brazilsouth",
      "eastus2",
      "japaneast",
      "koreacentral",
      "qatercentral",
      "southcentralus",
      "switzerlandnorth",
      "uaenorth",
      "westeurope",
      "westus2",
      "westus2"
    )
  )

  # Load used functions
  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')

  # Configure Resource Type
  $fullModuleIdentifier = ($ModuleRoot -split '[\/|\\]{0,1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/'
  Write-Verbose "Full module identifier: $fullModuleIdentifier"
  $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $fullModuleIdentifier -Verbose
  Write-Verbose "Formatted resource type: $formattedResourceType"

  # Get the resource provider and resource name
  $formattedResourceProvider = ($formattedResourceType -split '[\/|\\]{1}')[0]
  Write-Verbose "Resource type: $formattedResourceProvider"
  $formattedServiceName = ($formattedResourceType -split '[\/|\\]{1}')[1]
  Write-Verbose "Resource: $formattedServiceName"

  $resourceRegionList = @()
  $ResourceRegionList = (Get-AzResourceProvider | Where-Object { $_.ProviderNamespace -eq $formattedResourceProvider }).ResourceTypes | Where-Object { $_.ResourceTypeName -eq $formattedServiceName } | Select-Object -ExpandProperty Locations
  Write-Verbose "Region list: $($resourceRegionList | ConvertTo-Json)"

  if ($resourceRegionList -eq "global" -or $null -eq $resourceRegionList) {
    Write-Verbose "Resource is global, default region [$GlobalResourceGroupLocation] will be used for resource group creation"
    $location = $GlobalResourceGroupLocation # Set Location to resource group location. Globabl resources should have hardocded location in `main.bicep`
  }
  else {

    $locations = Get-AzLocation | Where-Object {
      $_.DisplayName -in $ResourceRegionList -and
      $_.Location -notin $ExcludedRegions -and
      $_.PairedRegion -ne "{}" -and
      $_.RegionCategory -eq "Recommended"
    } |  Select-Object -ExpandProperty Location
    Write-Verbose "Available Locations: $($locations | ConvertTo-Json)"


    $index = Get-Random -Maximum ($locations.Count)
    Write-Verbose "Generated random index [$index]"

    $location = $locations[$index]

  }
  Write-Verbose "Selected location [$location]" -Verbose

  return $location
}
