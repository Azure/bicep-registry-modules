<#
.SYNOPSIS
    Gets the registered AVM modules list from the official index.

.DESCRIPTION
    Downloads the AVM Bicep Resource Modules index CSV and extracts module names to a JSON file.

.PARAMETER OutputFile
    Path to the output JSON file containing the module list. Defaults to 'allowlist.json'.

.EXAMPLE
    ./Get-RegisteredModulesList.ps1 -OutputFile "allowlist.json"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$OutputFile = 'allowlist.json'
)

$VerbosePreference = 'Continue'

Write-Verbose 'Fetching registered modules list from AVM index...'

# Fetch the AVM Bicep Resource Modules index CSV
$indexUrl = 'https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepResourceModules.csv'

try {
    $response = Invoke-WebRequest -Uri $indexUrl -UseBasicParsing -ErrorAction Stop
    $csvContent = $response.Content

    # Parse CSV and extract ModuleName column
    $modules = $csvContent | ConvertFrom-Csv | Select-Object -ExpandProperty ModuleName | Where-Object { $_ }

    # Save as JSON array for the verification step
    $modules | ConvertTo-Json | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Verbose 'Successfully fetched and parsed AVM index.'
    Write-Verbose "Found $($modules.Count) registered modules."
} catch {
    Write-Error "Failed to fetch AVM index from $indexUrl."
    Write-Error 'Cannot verify new modules without the index. Blocking merge.'
    exit 1
}
