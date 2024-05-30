<#
.SYNOPSIS
If module list is not in sync with CSV file, an issue is created

.DESCRIPTION
CSV data for moules and pattern is loaded and compared with the list in the issue template. If they are not in sync, an issue with the necessary changes is created

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Sync-AvmModulesList -Repo 'Azure/bicep-registry-modules'

.NOTES
Will be triggered by the workflow platform.sync-avm-modules-list.yml
#>
function Sync-AvmModulesList {
  param (
    [Parameter(Mandatory = $true)]
    [string] $Repo,

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
  )

  # Loading helper functions
  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Add-GithubIssueToProject.ps1')

  $workflowFilePath = Join-Path $RepoRoot '.github' 'ISSUE_TEMPLATE' 'avm_module_issue.yml'

  # get CSV data
  $modules = Get-AvmCsvData -ModuleIndex 'Bicep-Resource' | Select-Object -Property 'ModuleName'
  $patterns = Get-AvmCsvData -ModuleIndex 'Bicep-Pattern' | Select-Object -Property 'ModuleName'

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
    $title = '[AVM core] Module(s) missing from AVM Module Issue template'
    $label = 'Type: AVM :a: :v: :m:,Type: Hygiene :broom:,Needs: Triage :mag:'
    $issues = gh issue list --state open --limit 500 --label $label --json 'title' --repo $Repo | ConvertFrom-Json -Depth 100

    if ($issues.title -notcontains $title) {
      # create issue
      $issueUrl = gh issue create --title $title --body $body --label $label --repo $Repo
      # add issue to project
      $ProjectNumber = 538 # AVM - Issue Triage
      Add-GithubIssueToProject -Repo $Repo -ProjectNumber $ProjectNumber -IssueUrl $issueUrl
    }
  }
}
