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
    [string] $ModuleFolderPath,

    [Parameter()]
    [string] $TargetVersion
  )

  $ModuleRelativeFolderPath = ($ModuleFolderPath -split '[\/|\\]avm[\/|\\]')[-1] -replace '\\', '/'

  # 1 Build Tag
  $tagName = '{0}/{1}' -f $ModuleRelativeFolderPath, $TargetVersion
  Write-Verbose "Publishing tag [$tagName]" -Verbose

  # 2 Check tag format
  $wellFormattedTag = git check-ref-format --normalize $tagName
  if (-not $wellFormattedTag) {
    Write-Verbose "Tag [$tagName] is not well formatted" -Verbose
    # TODO exception if tag not formatted correctly
  }

  # 3 Check tag already existing, if so return
  $existingTag = git ls-remote --tags origin $tagName
  if ($existingTag) {
    Write-Verbose "Tag [$tagName] already exists" -Verbose
    # TODO exception if tag already existing
  }

  # 3 Create and push tag
  git tag $tagName
  git push origin $tagName

  # 4 Return tag
  return $tagName
}
