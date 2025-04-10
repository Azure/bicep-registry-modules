<#
.SYNOPSIS
Calculates the module target SemVer version.

.DESCRIPTION
Calculates the module target SemVer version based on version.json file and existing published release tags.
Resets patch version if major or minor is updated.
Bumps patch version otherwise.
Builds target version as major.minor.patch

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER CompareJson
Optional. If set to true, compares the the module's main.json (instead of the version.json) with the published GitHub file to detect changes in the module's code or non-function related changes like the changelog file.
A new version is not needed if they are the same. In this case, the function returns the last published version.

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
        [switch] $CompareJson
    )

    # Load used functions
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleVersionChange.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleTargetPatchVersion.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName 'SharedScripts' 'Get-ModulePublishedVersions.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleJsonChange.ps1')

    # 0. Check if [main.json] version number changed. This overrides the logic to check the version in the version.json file
    if ($CompareJson) {
        $jsonChanged = Get-ModuleJsonChange -ModuleFolderPath $ModuleFolderPath
        if ($jsonChanged -eq $false) {
            Write-Verbose 'Version in main.json file did not change. No need to bump the version.' -Verbose
            $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
            $publishedVersions = Get-ModulePublishedVersions -TagListUrl ('https://mcr.microsoft.com/v2/bicep/avm/{0}/{1}/tags/list' -f $moduleType, ($resourceTypeIdentifier -replace '\\', '/'))
            # the last version in the array is the latest published version
            Write-Verbose "Latest published version is [$($publishedVersions[-1])]." -Verbose
            return $publishedVersions[-1]
        }
    }

    # 1. Get [version.json] file path
    $versionFilePath = Join-Path $ModuleFolderPath 'version.json'
    if (-not (Test-Path -Path $versionFilePath)) {
        throw "No version file found at: [$versionFilePath]"
    }

    # 2. Get MAJOR and MINOR from [version.json]
    $versionFileTargetVersion = (Get-Content $versionFilePath | ConvertFrom-Json).version
    $major, $minor = $versionFileTargetVersion -split '\.'

    # 3. Get PATCH
    # Check if [version.json] file version property was updated (compare with previous head)
    $versionChange = Get-ModuleVersionChange -VersionFilePath $versionFilePath

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
