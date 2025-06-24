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
        [string] $ModuleFolderPath
    )

    # Load used functions
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleVersionChange.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleTargetPatchVersion.ps1')

    # 1. Get [version.json] file path
    $versionFilePath = Join-Path $ModuleFolderPath 'version.json'
    if (-not (Test-Path -Path $VersionFilePath)) {
        throw "No version file found at: [$VersionFilePath]"
    }

    # 2. Get MAJOR and MINOR from [version.json]
    $versionFileTargetVersion = (Get-Content $VersionFilePath | ConvertFrom-Json).version
    $major, $minor = $versionFileTargetVersion -split '\.'

    # 3. Get PATCH
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
