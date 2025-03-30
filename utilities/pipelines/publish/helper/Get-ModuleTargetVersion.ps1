<#
.SYNOPSIS
Calculates the module target SemVer version.

.DESCRIPTION
Calculates the module target SemVer version based on version.json file and existing published release tags.
Resets patch version if major or minor is updated.
Bumps patch version otherwise
Builds target version as major.minor.patch

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER CompareJsonVersion
Optional. If set to true, compares the version in main.json with the one in the published GitHub version.json. A new version is not needed if they are the same. In this case, the function returns 0.0.0.

.EXAMPLE
# Note: "version" value in version.json is "0.1" and was not updated in the last commit
# Note: The latest published release tag is "avm/res/key-vault/vault/0.1.6"
Get-ModuleTargetVersion -ModuleFolderPath 'C:\avm\res\key-vault\vault'

Returns 0.1.7

#>

function Get-ModuleTargetVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $false)]
        [bool] $CompareJsonVersion = $false
    )

    # Load used functions
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleVersionChange.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleTargetPatchVersion.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModulePublishedVersions.ps1')

    # 1. Get [version.json] file path
    $versionFilePath = Join-Path $ModuleFolderPath 'version.json'
    if (-not (Test-Path -Path $VersionFilePath)) {
        throw "No version file found at: [$VersionFilePath]"
    }

    # 2. Get MAJOR and MINOR from [version.json]
    $versionFileTargetVersion = (Get-Content $VersionFilePath | ConvertFrom-Json).version
    $major, $minor = $versionFileTargetVersion -split '\.'

    # 3a. Check if a version number increase is needed
    $mainJsonFilePath = Join-Path $ModuleFolderPath 'main.json'
    if ($compareJsonVersion -eq $true -and (Test-Path -Path $mainJsonFilePath)) {
        $currentJsonVersion = (Get-Content $mainJsonFilePath | ConvertFrom-Json).metadata._generator.version

        # Fetch the content of the file in GitHub
        $repoOwner = 'Azure'
        $repoName = 'bicep-registry-modules'
        $filePathInRepo = 'avm/{0}/main.json' -f ($module -replace '\\', '/')
        $apiUrl = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $repoOwner, $repoName, $filePathInRepo

        try {
            $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'PowerShell' }
            $githubFileContent = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($response.content))
            $githubJsonVersion = ($githubFileContent | ConvertFrom-Json).metadata._generator.version
        } catch {
            throw "Failed to fetch the file content from GitHub: $($_.Exception.Message)"
        }

        # Compare the versions
        if ($currentJsonVersion -eq $githubJsonVersion) {
            Write-Verbose "No need to bump the version. Current version: $currentJsonVersion, GitHub version: $githubJsonVersion" -Verbose
            $publishedVersions = Get-ModulePublishedVersions -TagListUrl ('https://mcr.microsoft.com/v2/bicep/avm/{0}/tags/list' -f ($module -replace '\\', '/'))
            # the last version in the array is the latest published version
            return $publishedVersions[-1]
        }
    }

    # 3b. Get PATCH
    # Check if [version.json] file version property was updated (compare with previous head)
    $versionChange = Get-ModuleVersionChange -VersionFilePath $VersionFilePath

    if ($versionChange) {
        # If [version.json] file version property was updated, reset the patch/bug version back to 0
        Write-Verbose '[version.json] file version property was updated. Resetting PATCH back to 0.' -Verbose
        $patch = '0'
    } else {
        # Otherwise calculate the patch version
        Write-Verbose '[version.json] file version property was not updated. Calculating new PATCH version.' -Verbose
        $patch = Get-ModuleTargetPatchVersion -ModuleFolderPath $ModuleFolderPath -MajMinVersion "$major.$minor"
    }

    # 4. Get full Semver as MAJOR.MINOR.PATCH
    $targetModuleVersion = '{0}.{1}.{2}' -f $major, $minor, $patch
    Write-Verbose "Target version is [$targetModuleVersion]." -Verbose

    # 5. Return the version
    return $targetModuleVersion
}
