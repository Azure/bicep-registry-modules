<#
.SYNOPSIS
    Tests that modules are registered in the AVM index.

.DESCRIPTION
    Compares a list of modules against the registered modules allowlist and reports any unregistered modules.

.PARAMETER ModulesJson
    JSON array string of module paths to verify.

.PARAMETER AllowlistFile
    Path to the JSON file containing the registered modules list. Defaults to 'allowlist.json'.

.EXAMPLE
    ./Test-ModulesRegistered.ps1 -ModulesJson '["avm/res/storage/storage-account"]' -AllowlistFile "allowlist.json"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModulesJson,

    [Parameter(Mandatory = $false)]
    [string]$AllowlistFile = 'allowlist.json'
)

$VerbosePreference = 'Continue'

Write-Verbose 'Verifying modules are registered in the AVM index...'

$modules = $ModulesJson | ConvertFrom-Json
$unregisteredModules = @()

# Parse the allowlist - expects JSON array of module paths
# e.g., ["avm/res/storage/storage-account", "avm/ptn/network/hub-networking"]
$allowlist = Get-Content $AllowlistFile | ConvertFrom-Json

foreach ($module in $modules) {
    if ($module -notin $allowlist) {
        $unregisteredModules += $module
    }
}

if ($unregisteredModules.Count -gt 0) {
    Write-Error 'The following modules are not registered in the AVM index:'
    $unregisteredModules | ForEach-Object { Write-Verbose "  - $_" }
    Write-Verbose ''
    Write-Verbose 'Please ensure the module is registered in the AVM index at:'
    Write-Verbose 'https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/'
    Write-Verbose 'before submitting this PR.'
    exit 1
} else {
    Write-Verbose 'All modules are registered in the AVM index.'
}
