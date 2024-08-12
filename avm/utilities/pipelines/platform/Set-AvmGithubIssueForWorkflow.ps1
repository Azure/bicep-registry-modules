<#
.SYNOPSIS
Check for failing pipelines and create issues for those, that are failing.

.DESCRIPTION
If a pipeline fails, a new issue will be created, with a link to the failed pipeline. If the issue is already existing, a comment will be added, if a new run failed (with the link for the new failed run). If a pipeline run succeeds and an issue is open for the failed run, it will be closed (and a link to the successful run is added to the issue).

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER LimitNumberOfRuns
Optional. Number of recent runs to scan for failed runs. Default is 100.

.PARAMETER LimitInDays
Optional. Only runs in the past selected days will be analyzed. Default is 2.

.PARAMETER IgnoreWorkflows
Optional. List of workflow names that should be ignored (even if they fail, no ticket will be created). Default is an empty array.

.EXAMPLE
Set-AvmGithubIssueForWorkflow -Repo 'owner/repo01' -LimitNumberOfRuns 100 -LimitInDays 2 -IgnoreWorkflows @('Pipeline 01')

Check the last 100 workflow runs in the repository 'owner/repo01' that happened in the last 2 days. If the workflow name is 'Pipeline 01', then ignore the workflow run.

.NOTES
Will be triggered by the workflow platform.manage-workflow-issue.yml
#>
function Set-AvmGithubIssueForWorkflow {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [int] $LimitNumberOfRuns = 100,

        [Parameter(Mandatory = $false)]
        [int] $LimitInDays = 2,

        [Parameter(Mandatory = $false)]
        [String[]] $IgnoreWorkflows = @()
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Add-GithubIssueToProject.ps1')

    $issues = gh issue list --state open --limit 500 --label 'Type: AVM :a: :v: :m:,Type: Bug :bug:' --json 'title,url,body,comments,labels' --repo $Repo | ConvertFrom-Json -Depth 100
    $runs = gh run list --json 'url,workflowName,headBranch,startedAt' --limit $LimitNumberOfRuns --repo $Repo | ConvertFrom-Json -Depth 100
    $workflowRuns = @{}
    $issuesCreated = 0
    $issuesCommented = 0
    $issuesClosed = 0

    foreach ($run in $runs) {
        $runStartTime = [Datetime]::ParseExact($run.startedAt, 'MM/dd/yyyy HH:mm:ss', $null)

        if (($run.headBranch -eq 'main') -and ($runStartTime -gt (Get-Date).AddDays(-$LimitInDays)) -and ($IgnoreWorkflows -notcontains $run.workflowName)) {
            $runId = $run.url.Split('/') | Select-Object -Last 1
            $runDetails = gh run view $runId --json 'conclusion,number' --repo $Repo | ConvertFrom-Json -Depth 100

            if ($run.workflowName.StartsWith('avm.')) {
                if (-not $workflowRuns.ContainsKey($run.workflowName) -or $runDetails.number -gt $workflowRuns[$run.workflowName].number) {
                    $workflowRun = New-Object PSObject -Property @{
                        workflowName = $run.workflowName
                        number       = $runDetails.number
                        url          = $run.url
                        conclusion   = $runDetails.conclusion
                    }

                    if (-not $workflowRuns.ContainsKey($run.workflowName)) {
                        $workflowRuns.Add($run.workflowName, $workflowRun)
                    } else {
                        $workflowRuns[$run.workflowName] = $workflowRun
                    }
                }
            }
        }
    }

    foreach ($workflowRun in $workflowRuns.values) {
        if ($workflowRun.conclusion -eq 'failure') {
            $issueName = "[Failed pipeline] $($workflowRun.workflowName)"
            $failedrun = "Failed run: $($workflowRun.url)"
            $moduleName = $workflowRun.workflowName.Replace('.', '/')

            if ($issues.title -notcontains $issueName) {
                if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Create')) {
                    $issueUrl = gh issue create --title "$issueName" --body "$failedrun" --label 'Type: AVM :a: :v: :m:,Type: Bug :bug:' --repo $Repo
                    $ProjectNumber = 538 # AVM - Issue Triage
                    $comment = @"
> [!IMPORTANT]
> This module is currently orphaned (has no owner), therefore expect a higher response time.
> @Azure/avm-core-team-technical-bicep, the workflow for the ``$moduleName`` module has failed. Please investigate the failed workflow run.
"@

                    if ($workflowRun.workflowName -match 'avm.(?:res|ptn)') {
                        $moduleIndex = $moduleName.StartsWith('avm/res') ? 'Bicep-Resource' : 'Bicep-Pattern'
                        # get CSV data
                        $module = Get-AvmCsvData -ModuleIndex $moduleIndex | Where-Object ModuleName -EQ $moduleName

                        if (($module.ModuleStatus -ne 'Orphaned :eyes:') -and (-not ([string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle)))) {
                            $ProjectNumber = 566 # AVM - Module Issues
                            $comment = @"
> [!IMPORTANT]
> @Azure/$($module.ModuleOwnersGHTeam), the workflow for the ``$moduleName`` module has failed. Please investigate the failed workflow run. If you are not able to do so, please inform the AVM core team to take over.
"@
                            # assign owner
                            $assign = gh issue edit $issueUrl --add-assignee $module.PrimaryModuleOwnerGHHandle --repo $Repo

                            if ([String]::IsNullOrEmpty($assign)) {
                                if ($PSCmdlet.ShouldProcess("missing user comment to issue [$($issueName)]", 'Add')) {
                                    $comment = @"
> [!WARNING]
> This issue couldn't be assigend due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@

                                    gh issue comment $issueUrl --body $comment --repo $Repo
                                }
                            }
                        }
                    }

                    # add issue to project
                    Add-GithubIssueToProject -Repo $Repo -ProjectNumber $ProjectNumber -IssueUrl $issueUrl
                    # add comment
                    gh issue comment $issueUrl --body $comment --repo $Repo
                }

                $issuesCreated++
            } else {
                $issue = ($issues | Where-Object { $_.title -eq $issueName })[0]

                if (-not $issue.body.Contains($failedrun)) {
                    if ($issue.comments.length -eq 0) {
                        if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Add comment')) {
                            gh issue comment $issue.url --body $failedrun --repo $Repo
                        }

                        $issuesCommented++
                    } else {
                        if (-not $issue.comments.body.Contains($failedrun)) {
                            if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Close')) {
                                gh issue comment $issue.url --body $failedrun --repo $Repo
                            }

                            $issuesCommented++
                        }
                    }
                }
            }
        } else {
            $issueName = "[Failed pipeline] $($workflowRun.workflowName)"

            if ($issues.title -contains $issueName) {
                $issue = ($issues | Where-Object { $_.title -eq $issueName })[0]
                $successfulrun = "successful run: $($workflowRun.url)"
                gh issue close $issue.url --comment $successfulrun --repo $Repo
                $issuesClosed++
            }
        }
    }

    Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, $($WhatIfPreference ? ' would have been' : ''))
    Write-Verbose ('[{0}] issue(s){1} commented' -f $issuesCommented, $($WhatIfPreference ? ' would have been' : ''))
    Write-Verbose ('[{0}] issue(s){1} closed' -f $issuesClosed, $($WhatIfPreference ? ' would have been' : ''))
}
