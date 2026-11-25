<#
.SYNOPSIS
Selects a supported secondary region, preferring the Azure paired region.

.PARAMETER Location
Required. The name or display name of the primary Azure region.

.PARAMETER ResourceType
Required. The full resource type of the replica.

.EXAMPLE
./Get-ReplicationRegion.ps1 -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'
#>

param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Location,

    [Parameter(Mandatory)]
    [ValidatePattern('^[^/\s]+/[^/\s]+(?:/[^/\s]+)*$')]
    [string] $ResourceType
)

# Allow the deployment script's existing Reader assignment to propagate.
Start-Sleep -Seconds 10

$locations = @(Get-AzLocation -ErrorAction Stop)
$primaryLocation = @($locations | Where-Object { $Location -in @($_.Location, $_.DisplayName) })
if ($primaryLocation.Count -ne 1) {
    throw "Expected one Azure region matching [$Location], found [$($primaryLocation.Count)]."
}

$providerNamespace, $resourceTypeName = $ResourceType -split '/', 2
$provider = Get-AzResourceProvider -ProviderNamespace $providerNamespace -ErrorAction Stop
$providerLocations = @($provider.ResourceTypes |
    Where-Object { $_.ResourceTypeName -eq $resourceTypeName } |
    Select-Object -ExpandProperty Locations |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    ForEach-Object { ($_ -replace '\s', '').ToLowerInvariant() } |
    Sort-Object -Unique)
if ($providerLocations.Count -eq 0) {
    throw "No location metadata was returned for [$ResourceType]."
}

$candidates = @($locations | Where-Object {
        $_.Location -ne $primaryLocation[0].Location -and
        ($_.Location -in $providerLocations -or ($_.DisplayName -replace '\s', '').ToLowerInvariant() -in $providerLocations)
    })
if ($candidates.Count -eq 0) {
    throw "No supported secondary region was found for [$ResourceType] outside [$Location]."
}

$pairedRegions = @($primaryLocation[0].PairedRegion | Select-Object -ExpandProperty Name)
$selectedLocation = $candidates | Sort-Object -Property @(
    @{ Expression = { $_.Location -notin $pairedRegions } }
    @{ Expression = { $_.RegionCategory -ne 'Recommended' } }
    @{ Expression = { $_.GeographyGroup -ne $primaryLocation[0].GeographyGroup } }
    'Location'
) | Select-Object -First 1

$DeploymentScriptOutputs = @{
    replicationRegionName = $selectedLocation.Location
}
