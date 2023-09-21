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

  $ModuleRelativeFolderPath = ($ModuleFolderPath -split '[\/|\\]avm[\/|\\]')[-1] -replace '\\', '/'

  # 1. Get all released module tags
  $existingTagList = git ls-remote --tag origin "$ModuleRelativeFolderPath/$MajMinVersion*"
  # $existingTagList = git ls-remote -t origin "$modulerelativefolderpath/$MajMinVersion*"
  if ( $existingTagList.count -eq 0 ) {
    # If first module tag, reset patch
    Write-Verbose "No existing tag for module [$ModuleRelativeFolderPath] starting with version [MajMinVersion]" -Verbose
    Write-Verbose "Setting patch version to 0" -Verbose
    $patch = 0
  }
  else {
    # Otherwise get latest patch
    # $existingTagList | ForEach-Object { [int](($_ -split '\.')[-1]) } | Sort-object -Descending
    $patchList = $existingTagList | ForEach-Object { [int](($_ -split '\.')[-1]) }
    $latestPatch = ($patchList | Measure-Object -Maximum).Maximum
    write-Verbose "Latest tag is [$ModuleRelativeFolderPath/$MajMinVersion.$latestPatch]. Bumping patch." -Verbose
    # Increase patch count
    $patch = $latestPatch + 1
  }

  # Return PATCH
  return $patch
}
