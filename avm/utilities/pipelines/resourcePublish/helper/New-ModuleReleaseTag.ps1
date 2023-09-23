<#
.SYNOPSIS
Create a new release tag

.DESCRIPTION
Create a new release tag for the specified module

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER TargetVersion
Mandatory. Target version of the module to be published.

.EXAMPLE
New-ModuleReleaseTag -ModuleFolderPath 'C:\avm\key-vault\vault' -TargetVersion '1.0.0'

Creates 'avm/key-vault/vault/1.0.0' release tag
#>

function New-ModuleReleaseTag {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string] $ModuleFolderPath,

    [Parameter(Mandatory = $true)]
    [string] $TargetVersion
  )

  $ModuleRelativeFolderPath = ("avm/{0}" -f ($ModuleFolderPath -split '[\/|\\]avm[\/|\\]')[-1]) -replace '\\', '/'

  # 1 Build Tag
  $tagName = '{0}/{1}' -f $ModuleRelativeFolderPath, $TargetVersion
  Write-Verbose "Publishing tag [$tagName]" -Verbose

  # 2 Check tag format
  $wellFormattedTag = git check-ref-format --normalize $tagName
  if (-not $wellFormattedTag) {
    Write-Verbose "Tag [$tagName] is not well formatted" -Verbose
    # TODO exception if tag not formatted correctly
  }

  # 3 Check tag not already existing
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
