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
