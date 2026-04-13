<#
.SYNOPSIS
Check if a module in a given path does exist in the MAR file. Returns $true or $false.

.DESCRIPTION
Check if a module in a given path does exist in the MAR file. Only then, it can be published to the MCR.

.PARAMETER PublishedModuleName
Mandatory. The path of the module to check for. For example: 'avm/res/key-vault/vault', 'avm/res/key-vault/vault/1.0.0'

.PARAMETER GitHubToken
Mandatory. A GitHub token with read access to the MAR repository (microsoft/mcr).

.EXAMPLE
Confirm-ModuleInMAR -PublishedModuleName 'avm/res/key-vault/vault' -GitHubToken $env:MAR_REPO_ACCESS_PAT -Verbose

Check if module 'key-vault/vault' exists in the MAR file using a GitHub token for authentication
#>
function Confirm-ModuleInMAR {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "The path of the module to check for. For example: 'avm/res/key-vault/vault', 'avm/res/key-vault/vault/1.0.0'")]
        [string] $PublishedModuleName,

        [Parameter(Mandatory = $false, HelpMessage = 'Provide the URL to the BicepMARModules.json file. For example: "https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepMARModules.json". If not provided, the default URL will be used.')]
        [string] $PublishedModulesUrl = 'https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/refs/heads/main/docs/static/module-indexes/BicepMARModules.json'
    )

    # Strip trailing version (e.g. '/1.0.0') from the module name for matching
    $moduleNameForMatch = $PublishedModuleName -replace '/\d+\.\d+\.\d+$', '' -replace '\\', '/' # remove version number and escape backslashes for regex match'

    ##################################
    ##   Confirm module tag known   ##
    ##################################
    try {
        $marModulesContent = (Invoke-WebRequest -Uri $PublishedModulesUrl -ErrorAction Stop).Content
        $marModuleList = ($marModulesContent | ConvertFrom-Json)
    } catch {
        throw "Failed to fetch the list of published modules from [$PublishedModulesUrl]. Error: $($_.Exception.Message)"
    }
    if ($marModuleList -contains $moduleNameForMatch) {
        Write-Host "Passed: Found module [$moduleNameForMatch] in the MAR file" -ForegroundColor Green
        return $true
    } else {
        Write-Host "Failed: Module [$moduleNameForMatch] was not found in the MAR file. Please review." -ForegroundColor Red
        return $false
    }
}
