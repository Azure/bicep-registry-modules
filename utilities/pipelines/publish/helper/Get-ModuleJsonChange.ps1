<#
.SYNOPSIS
Compares the main.json of a module with the one published on GitHub.

.DESCRIPTION
Ommiting the Bicep version specific _generator property, the function compares the main.json file in the module with the one published on GitHub.
If they are different, the function returns $true.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER RepositoryOwner
Optional. The repository owner. Default is 'Azure'.

.PARAMETER RepositoryName
Optional. The repository name. Default is 'bicep-registry-modules'.

.EXAMPLE
Get-ModuleJsonChange -ModuleFolderPath 'C:\avm\res\key-vault\vault'

Returns $true

#>

function Get-ModuleJsonChange {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryOwner = 'Azure',

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'bicep-registry-modules'
    )

    # Check if [main.json] version number changed
    $mainJsonFilePath = Join-Path $ModuleFolderPath 'main.json'
    if (-not(Test-Path -Path $mainJsonFilePath)) {
        Write-Error "The file '[$mainJsonFilePath]' does not exist."
        return $false
    }

    $currentJson = Get-Content $mainJsonFilePath | ConvertFrom-Json
    # the _generator property is specific to the Bicep version used, and not relevant for the comparison of the content
    $currentJson.metadata.PSObject.Properties.Remove('_generator')

    # Fetch the content of the file in GitHub
    $module = ($ModuleFolderPath -split '[\/|\\]avm[\/|\\]')[-1]
    $filePathInRepo = 'avm/{0}/main.json' -f ($module -replace '\\', '/')
    $apiUrl = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $RepositoryOwner, $RepositoryName, $filePathInRepo
    Write-Verbose "Fetching the content of the file '[$filePathInRepo]' from GitHub." -Verbose

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'PowerShell' }
        $githubFileContent = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($response.content))
        $githubJson = $githubFileContent | ConvertFrom-Json
        # the _generator property is specific to the Bicep version used, and not relevant for the comparison of the content
        $githubJson.metadata.PSObject.Properties.Remove('_generator')
    } catch {
        throw "Failed to fetch the file content from GitHub: $($_.Exception.Message)"
    }

    # Compare main.json files (without the Bicep version specific _generator property)
    $currentJsonString = $currentJson | ConvertTo-Json -Depth 99
    $githubJsonString = $githubJson | ConvertTo-Json -Depth 99

    # Compute hash values for both JSON strings
    $currentJsonHash = [System.Security.Cryptography.HashAlgorithm]::Create('SHA256').ComputeHash([System.Text.Encoding]::UTF8.GetBytes($currentJsonString)) -join ''
    $githubJsonHash = [System.Security.Cryptography.HashAlgorithm]::Create('SHA256').ComputeHash([System.Text.Encoding]::UTF8.GetBytes($githubJsonString)) -join ''

    # Compare the hash values
    return $currentJsonHash -ne $githubJsonHash
}
