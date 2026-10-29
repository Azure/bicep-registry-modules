<#
.SYNOPSIS
    Gets changed AVM modules from a list of changed files.

.DESCRIPTION
    This script analyzes changed files to identify AVM modules. A valid module is defined as
    a folder containing both main.bicep and version.json files.

.PARAMETER ChangedFiles
    Space-separated list of changed file paths.

.EXAMPLE
    ./Get-ChangedModules.ps1 -ChangedFiles "avm/res/storage/storage-account/main.bicep"

.OUTPUTS
    JSON object: { "hasChangedModules": true/false, "changedModules": ["path1", "path2"] }
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ChangedFiles
)

$VerbosePreference = 'Continue'

Write-Verbose 'Checking for changed modules in the PR...'

$changedFilesList = $ChangedFiles -split ' '
$changedModules = @()

foreach ($file in $changedFilesList) {
    if ([string]::IsNullOrWhiteSpace($file)) { continue }

    # Extract module path (parent folder of main.bicep)
    $modulePath = Split-Path -Parent $file

    # A valid module must have both main.bicep and version.json
    $mainBicepPath = Join-Path $modulePath 'main.bicep'
    $versionJsonPath = Join-Path $modulePath 'version.json'

    if ((Test-Path $mainBicepPath) -and (Test-Path $versionJsonPath)) {
        Write-Verbose "Valid module found: $modulePath"
        $changedModules += $modulePath
    } else {
        Write-Verbose "Skipping $modulePath - missing main.bicep or version.json"
    }
}

# Remove duplicates
$uniqueModules = $changedModules | Select-Object -Unique

if ($uniqueModules.Count -eq 0) {
    Write-Verbose 'No changed modules detected.'
} else {
    Write-Verbose "Changed modules detected: $($uniqueModules.Count)"
    $uniqueModules | ForEach-Object { Write-Verbose "  - $_" }
}

# Return result as JSON object
$result = @{
    hasChangedModules = ($uniqueModules.Count -gt 0)
    changedModules    = @($uniqueModules)
}

$result | ConvertTo-Json -Compress
