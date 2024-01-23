<#
.SYNOPSIS
Updating the module names list in the issue template

.DESCRIPTION
CSV data for moules and pattern is loaded and overwrites the list in the issue template. The changes are then commited to the repository.

.PARAMETER Repo
Repository name according to GitHub (owner/name)

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Sync-AvmModulesList -Repo 'Azure/bicep-registry-modules'

.NOTES
Will be triggered by the workflow avm.platform.sync-avm-modules-list.yml
#>
function Sync-AvmModulesList {
  param (
    [Parameter(Mandatory = $true)]
    [string] $Repo,

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
  )

  # Loading helper functions
  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'Get-AvmCsvData.ps1')

  $workflowFilePath = Join-Path $RepoRoot '.github' 'ISSUE_TEMPLATE' 'avm_module_issue.yml'

  # get CSV data
  $modules = Get-AvmCsvData -ModuleIndex "Bicep-Resource" | Select-Object -Property "ModuleName"
  $patterns = Get-AvmCsvData -ModuleIndex "Bicep-Pattern" | Select-Object -Property "ModuleName"

  # build new strings
  $prefix = '        - "'
  $postfix = '"'
  $newModuleLines = $modules | ForEach-Object { $prefix + $_.ModuleName + $postfix }
  $newPatternLines = $patterns | ForEach-Object { $prefix + $_.ModuleName + $postfix }

  # parse workflow file
  $workflowFileLines = Get-Content $workflowFilePath
  $startIndex = 0
  $endIndex = 0

  for ($lineNumber = 0; $lineNumber -lt $workflowFileLines.Count; $lineNumber++) {
    if ($startIndex -gt 0 -and (-not ($workflowFileLines[$lineNumber]).Trim().StartsWith('- "avm/'))) {
      $endIndex = $lineNumber
      break
    }

    if (($workflowFileLines[$lineNumber]).Trim() -eq '- "Other, as defined below..."') {
      $startIndex = $lineNumber
    }
  }

  $oldLines = $workflowFileLines[($startIndex + 1)..($endIndex - 1)]
  $newLines = $newModuleLines + $newPatternLines
  $body = $newLines -join ([Environment]::NewLine)

  if ($oldLines -ne $newLines) {
    gh issue create --title "[AVM] Module/pattern list is not in sync with CSV file" --body $body --label "Needs: Attention :wave:" --repo $Repo
  }
}