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
    [string] $ModuleRelativeFolderPath,

    [Parameter()]
    [string] $TargetVersion
  )

  # 1 Build Tag
  $tagName = '{0}.{1}' -f $ModuleRelativeFolderPath, $TargetVersion

  # 2 Check tag already existing, if so return

  # 3 Create local tag

  # 4 Push Tag
  # Update logic, progressive number
}
