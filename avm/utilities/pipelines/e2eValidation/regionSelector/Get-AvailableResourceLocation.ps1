<#
.SYNOPSIS
Set the location for the resource deployment.

.DESCRIPTION
This script is used to set the location for the resource deployment.

.PARAMETER AllowedRegionsList
Optional. The list of regions to be considered for the selection.

.PARAMETER ExcludedRegions
Optional. The list of regions to be excluded from the selection.

.PARAMETER moduleRoot
Required. The root path of the module.

.PARAMETER repoRoot
Optional. The root path of the repository.

.PARAMETER GlobalResourceGroupLocation
Required. The location of the resource group where the global resources will be deployed.

.EXAMPLE
Get-AvailableResourceLocation -ModuleRoot ".\avm\res\resources\resource-group" -repoRoot .\

Get the recommended paired regions available for the service.
#>

function Get-AvailableResourceLocation {
    param (

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [array] $AllowedRegionsList = @(
            'eastus',
            'uksouth',
            'northeurope',
            'eastasia' # Including as Edge Region for services like static-site
        ),

        [Parameter(Mandatory = $true)]
        [string] $ModuleRoot,

        [Parameter(Mandatory = $false)]
        [string] $GlobalResourceGroupLocation,

        [Parameter(Mandatory = $false)]
        [array] $ExcludedRegions = @(
            'asiasoutheast',
            'brazilsouth',
            'eastus2',
            'japaneast',
            'koreacentral',
            'qatercentral',
            'southcentralus',
            'switzerlandnorth',
            'uaenorth',
            'westeurope',
            'westus2'
        )
    )

    # Load used functions
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')

    # Configure Resource Type
    $fullModuleIdentifier = ($ModuleRoot -split '[\/|\\]{0,1}avm[\/|\\]{1}(res|ptn|utl)[\/|\\]{1}')[2] -replace '\\', '/'

    if ($ModuleRoot -like 'avm/res*') {

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

        if ($resourceRegionList -eq 'global' -or $null -eq $resourceRegionList) {
            Write-Verbose "Resource is global or does not have a location in the Resource Providers API, default region [$GlobalResourceGroupLocation] will be used for resource group creation"
            $location = $GlobalResourceGroupLocation # Set Location to resource group location. Globabl resources should have hardocded location in `main.bicep`
        } else {

            $locations = Get-AzLocation | Where-Object {
                $_.DisplayName -in $ResourceRegionList -and
                $_.Location -notin $ExcludedRegions -and
                $_.PairedRegion -ne '{}' -and
                $_.RegionCategory -eq 'Recommended'
            } | Select-Object -ExpandProperty Location
            Write-Verbose "Available Locations: $($locations | ConvertTo-Json)"

            $filteredAllowedLocations = @($locations | Where-Object { $_ -in $AllowedRegionsList })
            Write-Verbose "Filtered allowed locations: $($filteredAllowedLocations | ConvertTo-Json)"
            $index = Get-Random -Maximum ($filteredAllowedLocations.Count)
            Write-Verbose "Generated random index [$index]"
            $location = $filteredAllowedLocations[$index]
        }
    } else {
        Write-Verbose 'Module is not resource so defaulting to the allowed region list'
        $index = Get-Random -Maximum ($AllowedRegionsList.Count)
        Write-Verbose "Generated random index [$index]"
        $location = $AllowedRegionsList[$index]
    }

    Write-Verbose "Selected location [$location]" -Verbose

    return $location
}
