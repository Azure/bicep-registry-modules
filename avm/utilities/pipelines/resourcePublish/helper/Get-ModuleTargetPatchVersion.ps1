<#
.SYNOPSIS
Calculates the module target patch version

.DESCRIPTION
TBD

.EXAMPLE

#>

function Get-ModuleTargetPatchVersion {

  [CmdletBinding()]
  param (
    [Parameter()]
    [string] $ModuleFolderPath,

    [Parameter()]
    [string] $MajMinVersion
  )

  $ModuleRelativeFolderPath = $ModuleRelativeFolderPath -replace '\\', '/'

  # 1. Get all released module tags
  $existingTagList = git ls-remote --tag origin "$ModuleRelativeFolderPath/$MajMinVersion*"
  if ( $existingTagList.count -eq 0 ) {
    # If first module tag, reset patch
    Write-Verbose "No existing tag for module [$ModuleRelativeFolderPath] starting with version [MajMinVersion]" -Verbose
    Write-Verbose "Setting patch version to 0" -Verbose
    $patch = 0
  }
  else {
    # Otherwise get latest patch
    $existingVersionList = @()
    foreach ($tag in $existingTagList) {
      $existingVersionList += Split-Path ($tag | out-string) -Leaf
    }
    $latestPatch = ''
    # Increase patch count
    $patch = $latestPatch + 1
  }

  # Return PATCH
  return $patch
}
