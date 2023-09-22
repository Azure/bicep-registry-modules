<#
.SYNOPSIS
Get current and previous major and minor version, if different.

.DESCRIPTION
Get current and previous major and minor version, if different.
Retrieves target Major.Minor from module version.json and compares with values from the previous head.

.PARAMETER VersionFilePath
Mandatory. Path to the module version.json file.

.EXAMPLE
"version" value is "0.1" and was not updated
  Get-ModuleVersionChange -VersionFilePath 'C:\avm\key-vault\vault\version.json'

Returns null

.EXAMPLE
"version" value is updated from "0.1" to "0.2"
  Get-ModuleVersionChange -VersionFilePath 'C:\avm\key-vault\vault\version.json'

Returns

#>
function Get-ModuleVersionChange {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string] $VersionFilePath
  )

  $diff = git diff --diff-filter=AM HEAD^ HEAD $VersionFilePath | Out-String

  if ($diff -match '\-\s*"version":\s*"([0-9]{1})\.([0-9]{1})".*') {
    $oldVersion = (New-Object System.Version($matches[1], $matches[2]))
  }

  if ($diff -match '\+\s*"version":\s*"([0-9]{1})\.([0-9]{1})".*') {
    $newVersion = (New-Object System.Version($matches[1], $matches[2]))
  }

  Write-Verbose "The old version is [$oldVersion]" -Verbose
  Write-Verbose "The new version is [$newVersion]" -Verbose

  if ($newVersion -lt $oldVersion) {
    Write-Verbose "The new version is smaller than the old version"
  }
  elseif ($newVersion -eq $oldVersion) {
    Write-Verbose "The new version equals the old version"
  }
  else {
    Write-Verbose "The new version is greater than the old version"
  }

  if (-not [String]::IsNullOrEmpty($newVersion) -and -not [String]::IsNullOrEmpty($oldVersion)) {
    return @{
      newVersion = $newVersion
      oldVersion = $oldVersion
    }
  }
}
