function Test-ModuleVersionUpdate {

  [CmdletBinding()]
  param (
    [Parameter()]
    [string] $VersionFilePath
  )

  # 1 boolean check if version changed

  # 2 boolean check if version value changed

  $diff = git diff --diff-filter=AM HEAD^ HEAD $VersionFilePath | Out-String

  if ($diff -match '\-\s*"version":\s*"([0-9]{1})\.([0-9]{1})".*') {
    $oldVersion = (New-Object System.Version($matches[1], $matches[2]))
  }
  else {
    throw 'Unable to find the old version in diff'
  }

  if ($diff -match '\+\s*"version":\s*"([0-9]{1})\.([0-9]{1})".*') {
    $newVersion = (New-Object System.Version($matches[1], $matches[2]))
  }
  else {
    throw 'Unable to find the new version in diff'
  }

  Write-Verbose "The old version is [$oldVersion]" -Verbose
  Write-Verbose "The new version is [$newVersion]" -Verbose

  if ($newVersion -lt $oldVersion) {
    Write-Verbose "The new version is smaller than the old version" -Verbose
  }
  elseif ($newVersion -eq $oldVersion) {
    Write-Verbose "The new version equals the old version" -Verbose
  }
  else {
    Write-Verbose "The new version is greater than the old version" -Verbose
  }

  return ($newVersion -eq $oldVersion)

}
