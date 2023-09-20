<#
.SYNOPSIS
Creates a new release tag

.DESCRIPTION
TBD

.EXAMPLE

#>

function New-ModuleReleaseTag {

  [CmdletBinding()]
  param (
    [Parameter()]
    [string] $ModuleFolderPath
  )

  $oldPatch = 0
  $newPatch = $oldPatch + 1
  return $newPatch
  # Update logic, progressive number
}
