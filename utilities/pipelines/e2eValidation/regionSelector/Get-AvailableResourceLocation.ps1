<#
.SYNOPSIS
Set the location for the resource deployment.

.DESCRIPTION
Select a supported, allowed resource region without using excluded or previously rejected regions.
Query the provider namespace explicitly: provider enumeration otherwise includes only registered providers.
Only an explicit global location uses GlobalResourceGroupLocation. Missing metadata and empty candidate sets fail.
Each metadata read retries only typed request timeouts, with three total attempts and five-second delays.

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

.PARAMETER UnavailableRegions
Optional. Regions already rejected by template validation. These do not replace the excluded region list.

.PARAMETER AsObject
Optional. Return the location and whether the resource explicitly reports global availability.

.EXAMPLE
Get-AvailableResourceLocation -ModuleRoot ".\avm\res\resources\resource-group" -repoRoot .\

Get the recommended paired regions available for the service.

.LINK
https://learn.microsoft.com/powershell/module/az.resources/get-azresourceprovider
#>

function Get-AvailableResourceLocation {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [array] $AllowedRegionsList = @(
            # Refreshed to currently "green" regions from the Azure capacity list (https://aka.ms/azurecapacity)
            # per the AVM PG + Core Team sync on 23 Jul 2026. Re-review this list quarterly against the capacity list.
            'swedencentral',
            'belgiumcentral',
            'norwayeast',
            'eastasia', # Including as Edge Region for services like static-site
            'polandcentral',
            'austriaeast',
            'denmarkeast',
            'koreacentral',
            'eastus',
            'centralus',
            'newzealandnorth'
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
            'qatercentral',
            'southcentralus',
            'switzerlandnorth',
            'uaenorth',
            'westeurope',
            'westus2'
        ),

        [Parameter(Mandatory = $false)]
        [string[]] $UnavailableRegions = @(),

        [Parameter(Mandatory = $false)]
        [switch] $AsObject
    )

    # Load used functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-DeploymentErrorKind.ps1')

    function Invoke-RegionMetadataRead {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)]
            [ValidateSet('Get-AzResourceProvider', 'Get-AzLocation')]
            [string] $Operation,

            [Parameter()]
            [hashtable] $Parameters = @{}
        )

        for ($attempt = 1; $attempt -le 3; $attempt++) {
            try {
                # Buffer the read so a failed attempt cannot emit partial metadata.
                $metadata = & $Operation @Parameters -ErrorAction Stop
                return $metadata
            } catch [System.Management.Automation.PipelineStoppedException] {
                throw
            } catch {
                $terminalCategories = @('AuthenticationError', 'PermissionDenied', 'SecurityError')
                if ($attempt -eq 3 -or $_.CategoryInfo.Category -in $terminalCategories -or
                    (Get-DeploymentErrorKind -ErrorRecord $_) -ne 'Timeout') {
                    throw
                }

                $pending = [System.Collections.Generic.Stack[System.Exception]]::new()
                $pending.Push($_.Exception)
                $visited = [System.Collections.Generic.HashSet[System.Exception]]::new()
                while ($pending.Count -gt 0) {
                    $exception = $pending.Pop()
                    if (-not $visited.Add($exception)) { continue }
                    if ($exception -is [System.UnauthorizedAccessException] -or
                        $exception -is [System.Security.Authentication.AuthenticationException] -or
                        $exception -is [System.Security.SecurityException] -or
                        $exception.StatusCode -in @(401, 403, 'Unauthorized', 'Forbidden') -or
                        $exception.Response.StatusCode -in @(401, 403, 'Unauthorized', 'Forbidden') -or
                        ($exception -is [System.Management.Automation.RuntimeException] -and
                            $exception.ErrorRecord.CategoryInfo.Category -in $terminalCategories)) {
                        throw
                    }
                    if ($exception -is [System.AggregateException]) {
                        foreach ($inner in $exception.InnerExceptions) { $pending.Push($inner) }
                    } elseif ($null -ne $exception.InnerException) {
                        $pending.Push($exception.InnerException)
                    } elseif ($exception -is [System.Management.Automation.RuntimeException] -and $null -ne $exception.ErrorRecord.Exception) {
                        $pending.Push($exception.ErrorRecord.Exception)
                    }
                }

                Write-Warning "Region metadata read [$Operation] timed out on attempt [$attempt/3]; retrying in [5] seconds."
                Start-Sleep -Seconds 5
            }
        }
    }

    # Configure Resource Type
    $fullModuleIdentifier = ($ModuleRoot -split '[\/|\\]{0,1}avm[\/|\\]{1}(res|ptn|utl)[\/|\\]{1}')[2] -replace '\\', '/'

    $isGlobal = $false
    $excludedLocations = @($ExcludedRegions + $UnavailableRegions | ForEach-Object { ($_ -replace '\s', '').ToLowerInvariant() })
    $allowedLocations = @($AllowedRegionsList | ForEach-Object { ($_ -replace '\s', '').ToLowerInvariant() })

    if ($ModuleRoot -match '(^|[\\/])avm[\\/]res[\\/]') {

        Write-Verbose "Full module identifier: $fullModuleIdentifier"
        $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $fullModuleIdentifier -Verbose
        Write-Verbose "Formatted resource type: $formattedResourceType"

        # Get the resource provider and resource name
        $formattedResourceProvider, $formattedServiceName = $formattedResourceType -split '[\\/]', 2
        Write-Verbose "Resource type: $formattedResourceProvider"
        Write-Verbose "Resource: $formattedServiceName"

        $provider = Invoke-RegionMetadataRead -Operation Get-AzResourceProvider -Parameters @{ ProviderNamespace = $formattedResourceProvider }
        $resourceRegionList = @($provider.ResourceTypes | Where-Object {
                $_.ResourceTypeName -eq $formattedServiceName
            } | Select-Object -ExpandProperty Locations | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        Write-Verbose "Region list: $($resourceRegionList | ConvertTo-Json)"

        if ($resourceRegionList.Count -eq 0) {
            throw "No location metadata was returned for [$formattedResourceType]. Specify customLocation instead of assuming global availability."
        }

        $providerLocations = @($resourceRegionList | ForEach-Object { ($_ -replace '\s', '').ToLowerInvariant() } | Sort-Object -Unique)
        if ($providerLocations.Count -eq 1 -and $providerLocations[0] -eq 'global') {
            if ([string]::IsNullOrWhiteSpace($GlobalResourceGroupLocation)) {
                throw "A resource group location is required for global resource [$formattedResourceType]."
            }
            if (($GlobalResourceGroupLocation -replace '\s', '').ToLowerInvariant() -in @($UnavailableRegions | ForEach-Object { ($_ -replace '\s', '').ToLowerInvariant() })) {
                throw "The global resource's resource group location has already failed validation."
            }
            $isGlobal = $true
            $location = $GlobalResourceGroupLocation
            Write-Verbose "Resource explicitly reports global availability; using resource group location [$location]."
        } else {
            $locations = Invoke-RegionMetadataRead -Operation Get-AzLocation | Where-Object {
                (($_.DisplayName -replace '\s', '').ToLowerInvariant() -in $providerLocations -or $_.Location -in $providerLocations) -and
                $_.Location -notin $excludedLocations -and
                $_.PairedRegion -ne '{}' -and
                $_.RegionCategory -eq 'Recommended'
            } | Select-Object -ExpandProperty Location
            Write-Verbose "Available Locations: $($locations | ConvertTo-Json)"

            $candidates = @($locations | Where-Object { $_ -in $allowedLocations } | Sort-Object -Unique)
        }
    } else {
        Write-Verbose 'Module is not a resource module; selecting from the allowed region list.'
        $candidates = @($allowedLocations | Where-Object { $_ -notin $excludedLocations } | Sort-Object -Unique)
    }

    if (-not $isGlobal) {
        if ($candidates.Count -eq 0) {
            throw "No supported, allowed regions remain for [$ModuleRoot] after exclusions and previous validation attempts."
        }
        $location = $candidates[(Get-Random -Maximum $candidates.Count)]
    }

    Write-Verbose "Selected location [$location]" -Verbose

    if ($AsObject) {
        return @{ Location = $location; IsGlobal = $isGlobal }
    }
    return $location
}
