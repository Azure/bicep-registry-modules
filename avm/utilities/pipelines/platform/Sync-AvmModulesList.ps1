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

    # get CSV data
    $targetModules = Get-AvmCsvData -ModuleIndex 'Bicep-Resource' | Where-Object { ($_.ModuleStatus -eq 'Available :green_circle:') -or ($_.ModuleStatus -eq 'Orphaned :eyes:') } | Select-Object -ExpandProperty 'ModuleName' | Sort-Object
    $targetPatterns = Get-AvmCsvData -ModuleIndex 'Bicep-Pattern' | Where-Object { ($_.ModuleStatus -eq 'Available :green_circle:') -or ($_.ModuleStatus -eq 'Orphaned :eyes:') } | Select-Object -ExpandProperty 'ModuleName' | Sort-Object

    $issueTemplatePath = Join-Path $RepoRoot '.github' 'ISSUE_TEMPLATE' 'avm_module_issue.yml'
    $issueTemplateContent = Get-Content $issueTemplatePath

    # Identify listed modules
    $startIndex = 0
    while ($issueTemplateContent[$startIndex] -notmatch '^\s*#?\s*\-\s+\"avm\/.+\"' -and $startIndex -ne $issueTemplateContent.Length) {
        $startIndex++
    }

    $endIndex = $startIndex
    while ($issueTemplateContent[$endIndex] -match '.*- "avm\/.*' -and $endIndex -ne $issueTemplateContent.Length) {
        $endIndex++
    }
    $endIndex-- # Go one back to last module line

    $listedModules = $issueTemplateContent[$startIndex..$endIndex] | Where-Object { -not $_.Contains('#') } | ForEach-Object { $_ -replace '.*- "(avm\/.*)".*', '$1' } | Where-Object { $_ -match 'avm\/res\/.*' }
    $listedPatterns = $issueTemplateContent[$startIndex..$endIndex] | Where-Object { -not $_.Contains('#') } | ForEach-Object { $_ -replace '.*- "(avm\/.*)".*', '$1' } | Where-Object { $_ -match 'avm\/ptn\/.*' }

    $body = ''

    $missingModules = $targetModules | Where-Object { $listedModules -NotContains $_ }
    $unexpectedModules = $listedModules | Where-Object { $targetModules -NotContains $_ }
    $unexpectedPatterns = $listedPatterns | Where-Object { $targetPatterns -NotContains $_ }
    $missingPatterns = $targetPatterns | Where-Object { $listedPatterns -NotContains $_ }

    if ($missingModules.Count -gt 0) {
        $body += @"
**Missing resource modules:**

$($missingModules -join ([Environment]::NewLine))
$([Environment]::NewLine)
"@
    }

    if ($unexpectedModules.Count -gt 0) {
        $body += @"
**Unexpected resource modules:**

$($unexpectedModules -join ([Environment]::NewLine))
$([Environment]::NewLine)
"@
    }

    if ($missingPatterns.Count -gt 0) {
        $body += @"
**Missing pattern modules:**

$($missingPatterns -join ([Environment]::NewLine))
$([Environment]::NewLine)
"@
    }

    if ($unexpectedPatterns.Count -gt 0) {
        $body += @"
**Unexpected pattern modules:**

$($unexpectedPatterns -join ([Environment]::NewLine))
$([Environment]::NewLine)
"@
    }

    # Should be at correct location
    $incorrectModuleLines = @()
    foreach ($finding in (Compare-Object $listedModules ($listedModules | Sort-Object) -SyncWindow 0)) {
        if ($finding.SideIndicator -eq '<=') {
            $incorrectModuleLines += $finding.InputObject
        }
    }
    $incorrectModuleLines = $incorrectModuleLines | Sort-Object -Unique

    if ($incorrectModuleLines.Count -gt 0) {
        $body += @"
**Resource modules that are not correctly sorted:**

$($incorrectModuleLines -join ([Environment]::NewLine))
$([Environment]::NewLine)
"@
    }

    $incorrectPatternLines = @()
    foreach ($finding in (Compare-Object $listedPatterns ($listedPatterns | Sort-Object) -SyncWindow 0)) {
        if ($finding.SideIndicator -eq '<=') {
            $incorrectPatternLines += $finding.InputObject
        }
    }
    $incorrectPatternLines = $incorrectPatternLines | Sort-Object -Unique

    if ($incorrectPatternLines.Count -gt 0) {
        $body += @"
**Pattern modules that are not correctly sorted:**

$($incorrectPatternLines -join ([Environment]::NewLine))
$([Environment]::NewLine)
"@
    }

    $issuesFound = $body -ne ''

    $title = '[AVM core] AVM Module Issue template is not in sync with published resource modules and pattern modules list'
    $label = 'Type: AVM :a: :v: :m:,Type: Hygiene :broom:'
    $issues = gh issue list --state open --limit 500 --label $label --json 'title,url' --repo $Repo | ConvertFrom-Json -Depth 100

    $body = @"
> [!IMPORTANT]
> The file [avm_module_issue.yml](https://github.com/Azure/bicep-registry-modules/blob/main/.github/ISSUE_TEMPLATE/avm_module_issue.yml?plain=1) which lists all modules when creating a new issue, is not in sync with the CSV files, that can be found under [resource modules](https://aka.ms/avm/index/bicep/res/csv) and [pattern modules](https://aka.ms/avm/index/bicep/ptn/csv). These CSV files are the single source of truth regarding published modules. Please update the ``avm_module_issue.yml`` accordingly. Please see the following differences that were found.
$([Environment]::NewLine)
"@ + $body

    if ($issues.title -notcontains $title) {
        if ($issuesFound) {
            # create issue
            $issueUrl = gh issue create --title $title --body $body --label $label --repo $Repo
            # add issue to project
            $ProjectNumber = 538 # AVM - Issue Triage
            Add-GithubIssueToProject -Repo $Repo -ProjectNumber $ProjectNumber -IssueUrl $issueUrl
        }
    } else {
        if ($issuesFound) {
            # update body
            gh issue edit $issues[0].url --body $body --repo $Repo
        } else {
            # close issue
            gh issue close $issues[0].url --repo $Repo
        }
    }
}
