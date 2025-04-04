<#
.SYNOPSIS
Compares the version in main.json with the one in the published GitHub version.json.

.DESCRIPTION
The version in the main.json files are generated before publishing the module.
Comparing the version in main.json with the one in the published GitHub version.json allows to check if a new version is needed.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER RepositoryOwner
Optional. The repository owner. Default is 'Azure'.

.PARAMETER RepositoryName
Optional. The repository name. Default is 'bicep-registry-modules'.

.EXAMPLE
# Note: "version" value in main.json is "0.32.4.45862" and on GitHub "0.34.4.45862"
Get-ModuleJsonVersionChange -ModuleFolderPath 'C:\avm\res\key-vault\vault'

Returns $true

#>

function Get-ModuleJsonVersionChange {

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

    $currentJsonVersion = (Get-Content $mainJsonFilePath | ConvertFrom-Json).metadata._generator.version

    # Fetch the content of the file in GitHub
    $module = ($ModuleFolderPath -split '[\/|\\]avm[\/|\\]')[-1]
    $filePathInRepo = 'avm/{0}/main.json' -f ($module -replace '\\', '/')
    $apiUrl = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $RepositoryOwner, $RepositoryName, $filePathInRepo
    Write-Verbose "Fetching the content of the file '[$filePathInRepo]' from GitHub." -Verbose

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'PowerShell' }
        $githubFileContent = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($response.content))
        $githubJsonVersion = ($githubFileContent | ConvertFrom-Json).metadata._generator.version
    } catch {
        throw "Failed to fetch the file content from GitHub: $($_.Exception.Message)"
    }

    # Compare the versions in the main.json file.
    $versionChanged = $currentJsonVersion -ne $githubJsonVersion
    Write-Verbose "main.json Version of the current file is '$currentJsonVersion'. The GitHub version of the file is '$githubJsonVersion. Returning '$versionChanged'" -Verbose
    return $versionChanged
}
