<#
.SYNOPSIS
Check for failing pipelines and create issues for those, that are failing.

.DESCRIPTION
If a pipeline fails, a new issue will be created, with a link to the failed pipeline. If the issue is already existing, a comment will be added, if a new run failed (with the link for the new failed run). If a pipeline run succeeds and an issue is open for the failed run, it will be closed (and a link to the successful run is added to the issue).

.PARAMETER RepositoryOwner
Optional. The GitHub organization to run the workfows in.

.PARAMETER RepositoryName
Optional. The GitHub repository to run the workfows in.

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER IgnoreWorkflows
Optional. List of workflow names that should be ignored (even if they fail, no ticket will be created). Default is an empty array.

.EXAMPLE
Set-AvmGitHubIssueForWorkflow -Repo 'owner/repo01' -IgnoreWorkflows @('Pipeline 01')

Check the last 100 workflow runs in the repository 'owner/repo01' that happened in the last 2 days. If the workflow name is 'Pipeline 01', then ignore the workflow run.

.NOTES
Will be triggered by the workflow platform.manage-workflow-issue.yml
#>
function Set-AvmGitHubIssueForWorkflow {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryOwner = 'Azure',

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'bicep-registry-modules',

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [String[]] $IgnoreWorkflows = @(
            '.Platform - Semantic PR Check' # Ignoring as a PR check workflow. Failing is expected.
        )
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Add-GithubIssueToProject.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowList.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowLatestRun.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueList.ps1')


    ##################################
    #   Loading module information   #
    ##################################
    $knownPatterns = Get-AvmCsvData -ModuleIndex 'Bicep-Pattern'
    $knownResources = Get-AvmCsvData -ModuleIndex 'Bicep-Resource'
    $knownUtilities = Get-AvmCsvData -ModuleIndex 'Bicep-Utility'

    #######################
    #    Get all issues   #
    #######################
    $baseInputObject = @{
        RepositoryOwner = $RepositoryOwner
        RepositoryName  = $RepositoryName
    }
    if ($PersonalAccessToken) {
        $baseInputObject['PersonalAccessToken'] = @{
            PersonalAccessToken = $PersonalAccessToken
        }
    }

    $issues = Get-GitHubIssueList @baseInputObject | Where-Object {
        $_.title -match '^\[Failed pipeline\] .+'
    }

    ##########################
    #    Get all workflows   #
    ##########################

    Write-Verbose 'Fetching current GitHub workflows' -Verbose
    $workflows = Get-GitHubModuleWorkflowList @baseInputObject -Filter $PipelineFilter | Where-Object {
        $_.name -notin $IgnoreWorkflows
    }
    Write-Verbose ('Fetched [{0}] workflows' -f $workflows.Count) -Verbose

    ############################################
    #   Fetching latest run of each workflow   #
    ############################################
    $workflowRunsToProcess = [System.Collections.ArrayList]@()
    $totalCount = $workflows.Count
    $currentCount = 1
    foreach ($workflow in $workflows) {

        $percentageComplete = [math]::Round(($currentCount / $totalCount) * 100)
        Write-Progress -Activity ('Fetching workflow [{0}]' -f $workflow.name) -Status "$percentageComplete% complete" -PercentComplete $percentageComplete
        # Get relevant run
        $latestWorkflowRun = Get-GitHubModuleWorkflowLatestRun @baseInputObject -WorkflowId $workflow.id

        if ($latestWorkflowRun.status -eq 'completed') {
            $workflowRunsToProcess += $latestWorkflowRun
        }

        $currentCount++
    }

    ############################
    #   Processing workflows   #
    ############################
    $issuesCreated = 0
    $issuesCommented = 0
    $issuesClosed = 0
    foreach ($workflowRun in $workflowRunsToProcess) {
        $issueName = '[Failed pipeline] {0}' -f $workflowRun.name

        if ($workflowRun.conclusion -eq 'failure') {
            $failedRunText = 'Failed run: {0}' -f $workflowRun.url
            $moduleName = $workflowRun.name.Replace('.', '/')

            if ($issues.title -notcontains $issueName) {
                # If no issue exists yet, create a new one
                if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Create')) {
                    $issueUrl = gh issue create --title $issueName --body $failedRunText --label 'Type: AVM :a: :v: :m:,Type: Bug :bug:' --repo "$RepositoryOwner/$RepositoryName"
                }

                $ProjectNumber = 538 # AVM - Issue Triage
                $comment = @"
> [!IMPORTANT]
> This module is currently orphaned (has no owner), therefore expect a higher response time.
> @Azure/avm-core-team-technical-bicep, the workflow for the ``$moduleName`` module has failed. Please investigate the failed workflow run.
"@

                if ($workflowRun.name -match 'avm.(?:res|ptn|utl)') {
                    switch ($matches[0]) {
                        'avm.ptn' { $module = $knownPatterns | Where-Object { $_.ModuleName -eq $moduleName }; break }
                        'avm.res' { $module = $knownResources | Where-Object { $_.ModuleName -eq $moduleName }; break }
                        'avm.utl' { $module = $knownUtilities | Where-Object { $_.ModuleName -eq $moduleName }; break }
                        Default {
                            throw 'Impossible regex condition.'
                        }
                    }

                    if (($module.ModuleStatus -ne 'Orphaned :eyes:') -and (-not ([string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle)))) {
                        $ProjectNumber = 566 # AVM - Module Issues
                        $comment = @"
> [!IMPORTANT]
> @Azure/$($module.ModuleOwnersGHTeam), the workflow for the ``$moduleName`` module has failed. Please investigate the failed workflow run. If you are not able to do so, please inform the AVM core team to take over.
"@
                        # assign owner
                        if ($PSCmdlet.ShouldProcess(('Owner [{0}] to issue [{1}]' -f $module.PrimaryModuleOwnerGHHandle, $issueName), 'Assign')) {
                            $assign = gh issue edit $issueUrl --add-assignee $module.PrimaryModuleOwnerGHHandle --repo "$RepositoryOwner/$RepositoryName"
                        }
                        if ([String]::IsNullOrEmpty($assign)) {
                            $comment = @"
> [!WARNING]
> This issue couldn't be assigend due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                            if ($PSCmdlet.ShouldProcess("Missing user comment to issue [$($issueName)]", 'Add')) {
                                gh issue comment $issueUrl --body $comment --repo "$RepositoryOwner/$RepositoryName"
                            }
                        }
                    }
                }

                if ($PSCmdlet.ShouldProcess("Issue [$issueName] to project [AVM - Issue Triage]", 'Add')) {
                    Add-GithubIssueToProject -Repo "$RepositoryOwner/$RepositoryName" -ProjectNumber $ProjectNumber -IssueUrl $issueUrl
                }

                if ($PSCmdlet.ShouldProcess("Comment to issue [$issueName]", 'Add')) {
                    gh issue comment $issueUrl --body $comment --repo "$RepositoryOwner/$RepositoryName"
                }

                $issuesCreated++
            } else {
                # If an issue does already exist, add a comment to it
                $issuesToComment = @() + ($issues | Where-Object {
                        $_.title -eq $issueName
                    })
                if ($issuesToComment.Count -gt 1) {
                    Write-Warning ('[{0}] identical issues found for [{1}]' -f $issuesToComment.Count, $issueName)
                }
                foreach ($issueToComment in $issuesToComment) {
                    if ($PSCmdlet.ShouldProcess(('Comment to issue [{0}] with URL [{1}] as its lastest run in the main branch failed' -f $issueToComment.title, $issueToComment.url), 'Add')) {
                        gh issue comment $issueToComment.url --body $failedRunText --repo "$RepositoryOwner/$RepositoryName"
                    }
                    $issuesCommented++
                }
            }
        } else {
            # Fetch and close all issues that match the issue name and match the successful run
            $issuesToClose = $issues | Where-Object {
                $_.title -eq $issueName
            }

            foreach ($issueToClose in $issuesToClose) {
                $comment = 'Successful run: {0}' -f $workflowRun.url
                if ($PSCmdlet.ShouldProcess(('Issue [{0}] with URL [{1}] as its lastest run in the main branch was successful' -f $issueToClose.title, $issueToClose.url), 'Close')) {
                    gh issue close $issueToClose.url --comment $comment --repo "$RepositoryOwner/$RepositoryName"
                }
                $issuesClosed++
            }
        }
    }

    Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, ($WhatIfPreference ? ' would have been' : '')) -Verbose
    Write-Verbose ('[{0}] issue(s){1} commented' -f $issuesCommented, ($WhatIfPreference ? ' would have been' : '')) -Verbose
    Write-Verbose ('[{0}] issue(s){1} closed' -f $issuesClosed, ($WhatIfPreference ? ' would have been' : '')) -Verbose
}
