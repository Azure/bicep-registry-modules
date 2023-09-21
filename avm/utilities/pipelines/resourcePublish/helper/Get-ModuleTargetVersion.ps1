<#
.SYNOPSIS
Calculates the module target SemVer version

.DESCRIPTION
Gets major and minor from version.json
Gets patch calling Get-ModuleTargetPatchVersion
Builds version as major.minor.patch

If new major/minor patch is 0

.PARAMETER ModuleFolderPath
Mandatory. The relative path of the module e.g. `avm/res/network/private-endpoint`

.EXAMPLE


#>

function Get-ModuleTargetVersion {

  [CmdletBinding()]
  param (
    [Parameter()]
    [string] $ModuleFolderPath
  )

  # Load used functions
  . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleTargetPatchVersion.ps1')

  # 1. Get [version.json] file path
  $versionFilePath = Join-Path $ModuleFolderPath 'version.json'
  if (-not (Test-Path -Path $VersionFilePath)) {
    throw "No version file found at: [$VersionFilePath]"
  }

  # 2. Get MAJOR and MINOR from [version.json]
  $versionFileTargetVersion = (Get-Content $VersionFilePath | ConvertFrom-Json).version
  $major, $minor = $versionFileTargetVersion -split '\.', 2

  # 3. Get PATCH
  # Check if [version.json] file version property was updated (compare with previous head)
  # TODO: update with diff function call
  $versionChange = 1
  if ($versionChange) {
    # If [version.json] file version property was updated, reset the patch/bug version back to 0
    Write-Verbose "[version.json] file version property was updated. Resetting PATCH back to 0." -Verbose
    $patch = '0'
  }
  else {
    # Otherwise calculate the patch version
    Write-Verbose "[version.json] file version property was not updated. Calculating new PATCH version." -Verbose
    $patch = Get-ModuleTargetPatchVersion -ModuleFolderPath $ModuleFolderPath -MajMinVersion '$major.$minor'
  }

  # 4. Get full Semver as MAJOR.MINOR.PATCH
  $targetModuleVersion = '{0}.{1}.{2}' -f $major, $minor, $patch
  Write-Verbose "Target version is [$targetModuleVersion]." -Verbose

  # 5. Return the version
  return $targetModuleVersion
}
