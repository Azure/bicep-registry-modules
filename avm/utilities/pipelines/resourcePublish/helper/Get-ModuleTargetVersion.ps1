<#
.SYNOPSIS
Calculates the module target SemVer version

.DESCRIPTION
Gets major and minor from version.json
Gets patch calling Get-ModuleTargetPatchVersion
Builds version as major.minor.patch

If new major/minor patch is 0

.PARAMETER ModuleRelativePath
Mandatory. The relative path of the module e.g. `avm/res/network/private-endpoint`

.EXAMPLE


#>

function Get-ModuleTargetVersion {

  [CmdletBinding()]
  param (
    [Parameter()]
    [string] $ModuleRelativePath
  )

  # 1. Get MAJOR and MINOR from [version.json]

  # 2. Get PATCH
  # Check if [version.json] file version property was updated (compare with previous head)
  # TODO: update with diff function call
  $versionChange = 0
  if (-not $versionChange) {
    # If [version.json] file version property was updated, reset the patch/bug version back to 0
    Write-Verbose "No changes detected. Skipping publishing" -Verbose
    $patchVersion = '0'
  }
  else {
    # Otherwise calculate the patch version

  }

  # 3. Get fill Semver as MAJOR.MINOR.PATCH

  # IF so, we reset the patch/bug version back to 0
  # ELSE we call Get-ModuleTargetPatchVersion to get the next patch/bug version

  # 2. Concat the version elements

  # 3. Return the version
}
