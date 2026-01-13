<#
.SYNOPSIS
  Extracts GeoCodes from Azure Backup GeoCode Mappings JSON and updates the Bicep main.bicep (`.\avm\ptn\network\private-link-private-dns-zones\main.bicep`) file variables. It also sorts the everything alphabetically.

  MSFT FTEs should see https://dev.azure.com/CSUSolEng/Azure%20Landing%20Zones/_wiki/wikis/ALZ-Wiki/735/Getting-Geo-Codes-For-Private-DNS-Zones for information on getting the Azure Backup GeoCode Mappings JSON file.

.EXAMPLE
  .\bicep-registry-modules\avm\ptn\network\private-link-private-dns-zones\helpers\Convert-GeoCodesFromJsonToBicepInput.ps1 -pathToAzureBackupGeoCodeMappingsJson "<YOUR PATH>\AzureBackupGeoCodeMappings.json"

  This will automatically update the main.bicep file with the new geo codes and retain any usgov/usdod entries.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $pathToAzureBackupGeoCodeMappingsJson
)

# Path to main.bicep file
$mainBicepPath = '.\avm\ptn\network\private-link-private-dns-zones\main.bicep'

# Read the current main.bicep file to extract existing usgov* and usdod* entries
$bicepContent = Get-Content $mainBicepPath -Raw

# Extract existing usgov* and usdod* entries from azureRegionGeoCodeShortNameAsKey
$geoCodeGovDodEntries = @()
if ($bicepContent -match '(?s)var azureRegionGeoCodeShortNameAsKey = \{([^}]*)\}') {
    $existingGeoCodeContent = $matches[1]
    $existingGeoCodeContent -split "`n" | ForEach-Object {
        if ($_ -match '^\s*(usgov\w+|usdod\w+):\s*''([^'']+)''') {
            $geoCodeGovDodEntries += "  $($matches[1]): '$($matches[2])'"
        }
    }
}

# Extract existing usgov* and usdod* entries from azureRegionShortNameDisplayNameAsKey
$displayNameGovDodEntries = @()
if ($bicepContent -match '(?s)var azureRegionShortNameDisplayNameAsKey = \{([^}]*)\}') {
    $existingDisplayNameContent = $matches[1]
    $existingDisplayNameContent -split "`n" | ForEach-Object {
        if ($_ -match '^\s*''([^'']*(?:usgov|usdod)[^'']*)'':\s*''([^'']+)''') {
            $displayNameGovDodEntries += "  '$($matches[1])': '$($matches[2])'"
        }
    }
}

# Read and convert the geo codes JSON
$geoCodesJson = Get-Content $pathToAzureBackupGeoCodeMappingsJson -Raw
$geoCodesJsonConverted = $geoCodesJson | ConvertFrom-Json -Depth 99

# Filter out usgov* and usdod* entries from JSON (they'll be added from existing file)
$filteredGeoCodes = $geoCodesJsonConverted | Where-Object {
    $_.ShortName -notmatch '^(usgov|usdod)'
}

# Sort by ShortName for consistent output
$sortedGeoCodes = $filteredGeoCodes | Sort-Object ShortName

# Create the azureRegionGeoCodeShortNameAsKey variable (ShortName -> GeoCode)
$geoCodeLines = @()
foreach ($region in $sortedGeoCodes) {
    $geoCodeLines += "  $($region.ShortName): '$($region.GeoCode)'"
}
# Add the gov/dod entries at the end
$geoCodeLines += $geoCodeGovDodEntries
$geoCodeVariable = "var azureRegionGeoCodeShortNameAsKey = {`n$($geoCodeLines -join "`n")`n}"

# Create the azureRegionShortNameDisplayNameAsKey variable (FriendlyName lowercase -> ShortName)
$displayNameLines = @()
foreach ($region in ($sortedGeoCodes | Sort-Object FriendlyName)) {
    $friendlyNameLower = $region.FriendlyName.ToLower()
    $displayNameLines += "  '$friendlyNameLower': '$($region.ShortName)'"
}
# Add the gov/dod entries at the end
$displayNameLines += $displayNameGovDodEntries
$displayNameVariable = "var azureRegionShortNameDisplayNameAsKey = {`n$($displayNameLines -join "`n")`n}"

# Replace the azureRegionGeoCodeShortNameAsKey variable
$bicepContent = $bicepContent -replace '(?s)var azureRegionGeoCodeShortNameAsKey = \{[^}]*\}', $geoCodeVariable

# Replace the azureRegionShortNameDisplayNameAsKey variable
$bicepContent = $bicepContent -replace '(?s)var azureRegionShortNameDisplayNameAsKey = \{[^}]*\}', $displayNameVariable

# Write back to the file
$bicepContent | Set-Content -Path $mainBicepPath -Encoding UTF8 -NoNewline

Write-Host "Successfully updated $mainBicepPath" -ForegroundColor Green
Write-Host 'Updated variables:' -ForegroundColor Cyan
Write-Host "  - azureRegionGeoCodeShortNameAsKey ($($sortedGeoCodes.Count) regions)" -ForegroundColor Cyan
Write-Host "  - azureRegionShortNameDisplayNameAsKey ($($sortedGeoCodes.Count) regions)" -ForegroundColor Cyan
