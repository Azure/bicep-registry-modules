<#
.SYNOPSIS
    Gets the best available ADX SKU for a given region and deployment configuration.

.DESCRIPTION
    Checks Azure Data Explorer SKU availability in the specified region and returns
    the best available SKU based on the deployment configuration (minimal vs waf-aligned).
    
    For minimal/dev deployments, prefers Dev SKUs (no markup charges, single node).
    For waf-aligned/production, prefers the newest compute-optimized Standard SKUs.

.PARAMETER Location
    The Azure region to check SKU availability.

.PARAMETER DeploymentConfiguration
    The deployment configuration: 'minimal' or 'waf-aligned'.

.EXAMPLE
    $result = .\Get-BestAdxSku.ps1 -Location "italynorth" -DeploymentConfiguration "minimal"
    Write-Host "Best SKU: $($result.Sku), Tier: $($result.Tier), Capacity: $($result.Capacity)"

.NOTES
    SKU Priority for FinOps workloads (compute-optimized, high core-to-cache ratio):
    
    Dev/Minimal (no SLA, single node, no ADX markup - just VM cost):
    1. Dev(No SLA)_Standard_E2a_v4  - AMD EPYC v4, 2 cores, 16GB (newest Dev)
    2. Dev(No SLA)_Standard_D11_v2  - Intel v2, 2 cores, 14GB (legacy fallback)
    
    Production/WAF-aligned (with SLA, min 2 nodes):
    1. Standard_E2ads_v5  - AMD EPYC v5, 2 cores, 16GB (newest, cheapest Standard)
    2. Standard_E2d_v5    - Intel v5, 2 cores, 16GB
    3. Standard_E4ads_v5  - AMD EPYC v5, 4 cores, 32GB
    4. Standard_E2d_v4    - Intel v4, 2 cores, 16GB (fallback)
    5. Standard_E2a_v4    - AMD v4, 2 cores, 16GB (fallback)
    
    Reference: https://learn.microsoft.com/azure/data-explorer/manage-cluster-choose-sku
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Location,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet('minimal', 'waf-aligned')]
    [string]$DeploymentConfiguration = 'minimal'
)

# SKU priority lists - ordered from most preferred to least preferred
$DevSkuPriority = @(
    'Dev(No SLA)_Standard_E2a_v4',   # AMD v4 - newest Dev SKU
    'Dev(No SLA)_Standard_D11_v2'    # Intel v2 - legacy fallback
)

$StandardSkuPriority = @(
    'Standard_E2d_v5',    # Intel v5 - 2-core, best regional availability
    'Standard_E2ads_v5',  # AMD v5 - 2-core, newest but limited availability
    'Standard_E4d_v5',    # Intel v5 - 4-core (if 2-core unavailable)
    'Standard_E4ads_v5',  # AMD v5 - 4-core
    'Standard_E2a_v4',    # AMD v4 - fallback
    'Standard_E2d_v4'     # Intel v4 - fallback
)

Write-Verbose "Checking ADX SKU availability in region: $Location"

# Get all available SKUs in the specified region
try {
    $allSkus = az kusto cluster list-sku -o json 2>$null | ConvertFrom-Json
    if (-not $allSkus) {
        throw "Failed to retrieve ADX SKU list from Azure"
    }
}
catch {
    Write-Error "Failed to query Azure for ADX SKUs: $_"
    exit 1
}

# Filter SKUs available in the target region
# Note: SKU API returns 'locations' as an array property
$normalizedLocation = $Location.ToLower().Replace(' ', '')
$regionSkus = $allSkus | Where-Object { $_.locations -contains $normalizedLocation }
$availableSkuNames = $regionSkus | Select-Object -ExpandProperty name -Unique

Write-Verbose "Found $($availableSkuNames.Count) SKUs available in $Location"

# Select the priority list based on deployment configuration
if ($DeploymentConfiguration -eq 'minimal') {
    $priorityList = $DevSkuPriority
    $skuType = "Dev"
}
else {
    $priorityList = $StandardSkuPriority
    $skuType = "Standard"
}

# Find the best available SKU from our priority list
$selectedSku = $null
foreach ($sku in $priorityList) {
    if ($sku -in $availableSkuNames) {
        $selectedSku = $sku
        Write-Verbose "Found preferred SKU: $sku"
        break
    }
    else {
        Write-Verbose "SKU not available in region: $sku"
    }
}

# If no preferred SKU found, try the other tier as fallback
if (-not $selectedSku) {
    Write-Warning "No $skuType SKUs available in $Location. Trying fallback options..."
    
    if ($DeploymentConfiguration -eq 'minimal') {
        # Try Standard SKUs as fallback for minimal (will cost more but works)
        foreach ($sku in $StandardSkuPriority) {
            if ($sku -in $availableSkuNames) {
                $selectedSku = $sku
                Write-Warning "Using Standard SKU as fallback: $sku (min 2 nodes required)"
                break
            }
        }
    }
    else {
        # For waf-aligned, we must have Standard - no Dev fallback
        Write-Error "No Standard SKUs available in $Location for production deployment"
        exit 1
    }
}

if (-not $selectedSku) {
    Write-Error "No suitable ADX SKU found in region: $Location"
    Write-Error "Available SKUs: $($availableSkuNames -join ', ')"
    exit 1
}

# Determine tier and capacity based on selected SKU
if ($selectedSku -like 'Dev*') {
    $tier = 'Basic'
    $capacity = 1
}
else {
    $tier = 'Standard'
    $capacity = 2  # Standard SKUs require minimum 2 nodes
}

# Return the result as an object
$result = [PSCustomObject]@{
    Sku           = $selectedSku
    Tier          = $tier
    Capacity      = $capacity
    Location      = $Location
    Configuration = $DeploymentConfiguration
    IsDevSku      = $selectedSku -like 'Dev*'
}

Write-Host "Selected ADX SKU for $Location ($DeploymentConfiguration):"
Write-Host "  SKU:      $($result.Sku)"
Write-Host "  Tier:     $($result.Tier)"
Write-Host "  Capacity: $($result.Capacity) node(s)"

return $result
