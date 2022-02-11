<#
.SYNOPSIS
  Finds test Bicep file.
  
.DESCRIPTION
  The script finds the test Bicep file if exact one module is changed by the pull request that triggers the pipeline.

.PARAMETER GitHubToken
  The GitHub personal access token to use for authentication.
#>
param(
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
$testFilePaths = @(
  $pullRequestFiles |
  Where-Object { $_.filename.StartsWith("modules") } |                # Get changed module files.
  ForEach-Object { Split-Path $_.filename } |                         # Get directories of changed module files.
  ForEach-Object { 
    $_.Split($separator) |
    Where-Object { $_.Length -ge 3 } |
    Select-Object -First 3 |
    Join-String -Separator $separator
  } |                                                                 # Get module root directories.
  Select-Object -Unique |                                             # Remove duplicates.
  Where-Object { Test-Path $_ } |                                     # Ignore removed directories.
  ForEach-Object { Join-Path $_ -ChildPath "test\main.test.bicep" } | # Get test file paths.
  Where-Object { Test-Path $_ -PathType "Leaf" }                      # Filter out non-existent test file paths.
)

# If no test file or more than one test file was found, set an empty string to skip the subsequent steps.
$testFilePath = if ($testFilePaths.Length -eq 1) { $testFilePaths[0] } else { "" }
Set-AzurePipelinesVariable -VariableName "TestFilePath" -VariableValue $testFilePath
