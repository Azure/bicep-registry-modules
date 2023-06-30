<#
.SYNOPSIS
  Finds changed module.

.DESCRIPTION
  The script finds the changed module in the pull request that triggers the pipeline.

.PARAMETER GitHubToken
  The GitHub personal access token to use for authentication.

.PARAMETER Repository
  The Bicep registry module repository name.

.PARAMETER PullRequestNumber
  The pull request number.
#>
param(
  # TODO: remove the PAT once the Bicep registry repo goes public.
  [Parameter(mandatory = $True)]
  [string]$GitHubToken,

  [Parameter(mandatory = $True)]
  [string]$Repository,

  [Parameter(mandatory = $True)]
  [string]$PullRequestNumber
)

Import-Module .\scripts\azure-pipelines\utils\AzurePipelinesUtils.psm1 -Force

$pullRequestFiles = Invoke-RestMethod `
  -Uri "https://api.github.com/repos/$Repository/pulls/$PullRequestNumber/files" `
  -Authentication OAuth `
  -Token (ConvertTo-SecureString $GitHubToken -AsPlainText -Force)

$separator = [IO.Path]::DirectorySeparatorChar
$changedModuleDirectories = @(
  $pullRequestFiles |
  Where-Object { $_.filename.StartsWith("modules") } |                # Get changed module files.
  ForEach-Object { Split-Path $_.filename } |                         # Get directories of changed module files.
  Where-Object { $_.Split($separator).Length -ge 3 } |                # Ignore changes outside a module folder, e.g., modules/bicepconfig.json.
  ForEach-Object {
    $_.Split($separator) |
    Select-Object -First 3 |
    Join-String -Separator $separator
  } |                                                                   # Get module root directories.
  Select-Object -Unique |                                               # Remove duplicates.
  Where-Object { Test-Path $_ }                                         # Ignore removed directories.
)

# If no test file or more than one test file was found, set an empty string to skip the subsequent steps.
$changedModuleDirectory = if ($changedModuleDirectories.Length -eq 1) { $changedModuleDirectories[0] } else { "" }
Set-AzurePipelinesVariable -VariableName "ChangedModuleDirectory" -VariableValue $changedModuleDirectory
