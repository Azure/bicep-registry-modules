<#
.SYNOPSIS
Check if a module in a given path does exist in the MAR file

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

        [Parameter(
            Mandatory,
            HelpMessage = 'Provide a GitHub token (PAT for testing or GitHub App token for production) with read access to the MAR repository (microsoft/mcr).')]
        [string] $GitHubToken
    )

    # Strip trailing version (e.g. '/1.0.0') from the module name for matching
    $moduleNameForMatch = $PublishedModuleName -replace '/\d+\.\d+\.\d+$', ''

    ##################################
    ##   Confirm module tag known   ##
    ##################################
    $marFileUrl = 'https://raw.githubusercontent.com/ReneHezser/mcr/refs/heads/main/teams/bicep/bicep.yml'
    $headers = @{
        Authorization = "Bearer $GitHubToken"
        Accept        = 'application/vnd.github.v3.raw'
        'User-Agent'  = 'AVM-Publish-Pipeline'
    }

    try {
        # sample entry in https://github.com/microsoft/mcr/blob/main/teams/bicep/bicep.yml
        # - name: public/bicep/avm/res/key-vault/vault
        #     displayName: Key Vault
        #     description: AVM Resource Module for Key Vault
        #     logoUrl: https://raw.githubusercontent.com/Azure/bicep/main/src/vscode-bicep/icons/bicep-logo-256.png
        #     supportLink: https://github.com/Azure/bicep-registry-modules/issues
        #     documentationLink: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault/README.md
        $marFileContent = (Invoke-WebRequest -Uri $marFileUrl -Headers $headers -ErrorAction Stop).Content
    } catch {
        throw "Failed to fetch MAR file from [$marFileUrl]. Error: $($_.Exception.Message)"
    }
    if ($marFileContent -match "name:\s*public/bicep/$moduleNameForMatch\s") {
        Write-Host "Passed: Found module [$moduleNameForMatch] in the MAR file" -ForegroundColor Green
    } else {
        Write-Host "Failed: Module [$moduleNameForMatch] was not found in the MAR file. Please review." -ForegroundColor Red
    }
}
