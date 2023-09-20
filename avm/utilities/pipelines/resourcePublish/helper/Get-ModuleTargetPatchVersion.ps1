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
    [string] $ModuleFolderPath
  )

  $oldPatch = 0
  $newPatch = $oldPatch + 1
  return $newPatch
  # Update logic, progressive number
}
