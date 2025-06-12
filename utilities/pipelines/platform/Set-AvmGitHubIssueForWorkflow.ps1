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
            '.Platform - Check PSRule', # Ignoring as a PSRule check workflow. It failing usually just shows that modules failed the rules.
            '.Platform - Semantic PR Check', # Ignoring as a PR check workflow. It failing usually just shows that a PR is invalid.
            'Semantic PR Check' # Outdated, yet seemingly still existing somewhere.
        )
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Add-GitHubIssueToProject.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowList.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowLatestRun.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueCommentsList.ps1')
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
    Write-Verbose '⏳ Fetching each workflow''s latest run using the main branch' -Verbose
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

    $issueTriageProjectNumber = 538
    $moduleIssuesProjectNumber = 566
    $repo = "$RepositoryOwner/$RepositoryName"
    $bugLabel = 'Type: Bug :bug:'
    $avmLabel = 'Type: AVM :a: :v: :m:'
    $duplicateLabel = 'Type: Duplicate :palms_up_together:'

    $issuesCreated = 0
    $issuesCommented = 0
    $issuesClosed = 0
    foreach ($workflowRun in $workflowRunsToProcess) {
        $issueName = '[Failed pipeline] {0}' -f $workflowRun.name
        $moduleName = $workflowRun.name.Replace('.', '/')

        if ($workflowRun.conclusion -eq 'failure') {
            # Handle failed runs in main
            # --------------------------
            $failedRunText = 'Failed run: {0}' -f $workflowRun.url -replace 'api\.github.com\/repos', 'github.com'

            if ($issues.title -notContains $issueName) {
                # Handle non-existend issues for failed runs in main
                # --------------------------------------------------
                # Logic ahead
                # -----------
                # - Create a new issue
                # - Differentiate a failed platform workflow from a module workflow
                #   - Platform
                #     - Add issue to project
                #     - Comment issue
                #   - Module
                #     - Add issue to project
                #     - If module is orphaned, tag the core team in a comment
                #     - If module is not orphaned, assign the owner & tag the owner in a comment
                #       -  If the owner-assignment failed, add an extra comment to call this out

                # Create a new issue and add it to project
                # ----------------------------------------
                if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Create')) {
                    $issueUrl = gh issue create --title $issueName --body $failedRunText --label "$avmLabel,$bugLabel" --repo $repo
                }
                Write-Warning ('⚠️   Created issue {0} ({1}) as the module''s latest run in the main branch failed.' -f $issueUrl, $issueName)

                $workflowRun.name -notMatch 'avm.(?:res|ptn|utl)'
                switch ($matches[0]) {
                    'avm.ptn' { $module = $knownPatterns | Where-Object { $_.ModuleName -eq $moduleName }; break }
                    'avm.res' { $module = $knownResources | Where-Object { $_.ModuleName -eq $moduleName }; break }
                    'avm.utl' { $module = $knownUtilities | Where-Object { $_.ModuleName -eq $moduleName }; break }
                    default {
                        Write-Verbose ('Handling platform workflow [{0}]' -f $workflowRun.name)
                    }
                }

                # CASE : Platform workflow
                # ------------------------
                if ($null -eq $module) {
                    # Non resource module. Could be platform workflow
                    if ($PSCmdlet.ShouldProcess("Issue [$issueName] to project [AVM - Issue Triage]", 'Add')) {
                        $null = Add-GitHubIssueToProject -Repo $repo -ProjectNumber $issueTriageProjectNumber -IssueUrl $issueUrl
                    }
                    $platformIssueComment = @'
> [!IMPORTANT]
> This issue was created for a platform workflow. The maintainer team @Azure/avm-core-team-technical-bicep should investigate and mitigate the reason.
'@
                    if ($PSCmdlet.ShouldProcess("Comment for maintainers to issue [$issueName]", 'Add')) {
                        $userCommentUrl = gh issue comment $issueUrl --body $platformIssueComment --repo $repo
                    }
                    Write-Verbose ('💬 Commented issue {0} ({1}) as the maintainer team should be notified of a failed platform workflow' -f $issueUrl, $issueName) -Verbose
                    $issuesCommented++
                    continue
                }

                # CASE : Module workflow
                # ----------------------
                $moduleIsOrphaned = $module.ModuleStatus -eq 'Orphaned' -and [string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle)

                $ProjectNumber = $moduleIsOrphaned ? $issueTriageProjectNumber : $moduleIssuesProjectNumber
                if ($PSCmdlet.ShouldProcess("Issue [$issueName] to project [AVM - Issue Triage]", 'Add')) {
                    $null = Add-GitHubIssueToProject -Repo $repo -ProjectNumber $ProjectNumber -IssueUrl $issueUrl
                }

                # Handle comments & ownership
                # ----------------------------
                $taggingComment = $moduleIsOrphaned ? @"
> [!IMPORTANT]
> This module is currently orphaned (has no owner), therefore expect a higher response time.
> @Azure/avm-core-team-technical-bicep, the workflow for the ``$moduleName`` module has failed. Please investigate the failed workflow run.
"@ : @"
> [!IMPORTANT]
> @Azure/$($module.ModuleOwnersGHTeam), the workflow for the ``$moduleName`` module has failed. Please investigate the failed workflow run. If you are not able to do so, please inform the AVM core team to take over.
"@

                if (-not $moduleIsOrphaned) {
                    # If not orphaned we should assign the issue to the module owner
                    # --------------------------------------------------------------
                    if ($PSCmdlet.ShouldProcess(('Owner [{0}] to issue [{1}]' -f $module.PrimaryModuleOwnerGHHandle, $issueName), 'Assign')) {
                        $assign = gh issue edit $issueUrl --add-assignee $module.PrimaryModuleOwnerGHHandle --repo $repo
                    }

                    # Error handling of owner assignment failed
                    if ([String]::IsNullOrEmpty($assign)) {
                        $ownerAssignmentFailedComment = @"
> [!WARNING]
> This issue couldn't be assigend due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                        if ($PSCmdlet.ShouldProcess("Missing user comment to issue [$issueName]", 'Add')) {
                            $userCommentUrl = gh issue comment $issueUrl --body $ownerAssignmentFailedComment --repo $repo
                        }
                        Write-Verbose ('💬 Commented issue {0} ({1}) as the automation was unable to auto-assign the module owner. ({2})' -f $issueUrl, $issueName, $userCommentUrl) -Verbose
                    }
                    else {
                        Write-Verbose ('👋 Assigned owner [@{0}] to issue {1} ({2})' -f $module.PrimaryModuleOwnerGHHandle, $issueUrl, $issueName) -Verbose
                    }
                }

                if ($PSCmdlet.ShouldProcess("Comment to issue [$issueName]", 'Add')) {
                    $commentUrl = gh issue comment $issueUrl --body $taggingComment --repo $repo
                }
                Write-Verbose ('💬 Commented issue {0} ({1}) as its module''s latest run in the main branch failed. ({2})' -f $issueUrl, $issueName, $commentUrl) -Verbose

                $issuesCreated++
            }
            else {
                # Handle existing issues for failed runs in main
                # ----------------------------------------------
                # If an issue does already exist, add a comment to it
                $issueToComment = @() + ($issues | Where-Object {
                        $_.title -eq $issueName
                    })

                # Handling duplicated issues (which should be cleaned up)
                if ($issueToComment.Count -gt 1) {
                    Write-Warning ('[{0}] identical issues found for [{1}]' -f $issueToComment.Count, $issueName)
                    $sortedIssues = $issueToComment | Sort-Object -Property 'created_at' -Descending

                    # We only comment on the newest duplicated issue
                    $issueToComment = $sortedIssues[0]

                    # We close all older duplicated issues
                    $issuesToClose = $sortedIssues[1..$sortedIssues.Count]
                    foreach ($issueToClose in $issuesToClose) {
                        if ($PSCmdlet.ShouldProcess(('Label [duplicate] to issue [{0}] with URL [{1}] created [{2}], as it is a duplicate issue and older than the latest issue [{3}] from [{4}].' -f $issueToClose.title, $issueToClose.html_url, $issueToClose.created_at, $issueToComment.html_url, $issueToComment.created_at), 'Add')) {
                            $null = gh issue edit $issueToClose.html_url --add-label $duplicateLabel --repo $repo 2>&1 # Suppressing output to show custom message
                        }
                        if ($PSCmdlet.ShouldProcess(('Issue [{0}] with URL [{1}] created [{2}], as it is a duplicate issue and older than the latest issue [{3}] from [{4}].' -f $issueToClose.title, $issueToClose.html_url, $issueToClose.created_at, $issueToComment.html_url, $issueToComment.created_at), 'Close')) {
                            $null = gh issue close $issueToClose.html_url --comment ('This issue is succeeded by the newer issue: {0}' -f $issueToClose.html_url) --reason 'not planned' --repo $repo 2>&1 # Suppressing output to show custom message
                        }
                        Write-Verbose ('✅ Closed issue {0} ({1}) as it was redundant and a newer issue for the same worklow exists' -f $issueToClose.html_url, $issueToClose.title) -Verbose
                        $issuesClosed++
                    }
                }

                # Comment on latest issue - but ONLY if the same comment was not already provided at the same day
                $existingComments = Get-GitHubIssueCommentsList -RepositoryOwner $RepositoryOwner -RepositoryName $RepositoryName -IssueNumber $issueToComment.number -SinceWhen (Get-Date -AsUTC).ToString('yyyy-MM-ddT00:00:00Z')
                if ($existingComments.body -contains $failedRunText) {
                    Write-Verbose ('📎 Issue {0} ({1}) was already commented today using the same text. Skipping.' -f $issueToComment.html_url, $issueToComment.title) -Verbose
                    continue
                }
                if ($PSCmdlet.ShouldProcess(('Comment to issue [{0}] with URL [{1}] as its lastest run in the main branch failed' -f $issueToComment.title, $issueToComment.html_url), 'Add')) {
                    $commentUrl = gh issue comment $issueToComment.html_url --body $failedRunText --repo $repo
                }
                Write-Verbose ('💬 Commented issue {0} ({1}) as its lastest run in the main branch failed. ({2})' -f $issueToComment.html_url, $issueToComment.title, ($WhatIfPreference ? '<WhatIf-Id>' : $commentUrl)) -Verbose
                $issuesCommented++
            }
        }
        else {
            # Handle successful runs in main
            # ------------------------------
            # Fetch and close all issues that match the issue name and match the successful run
            $issuesToClose = $issues | Where-Object {
                $_.title -eq $issueName
            }

            foreach ($issueToClose in $issuesToClose) {
                $comment = 'Successful run: {0}' -f $workflowRun.url -replace 'api\.github.com\/repos', 'github.com'
                if ($PSCmdlet.ShouldProcess(('Issue [{0}] with URL [{1}] as its lastest run in the main branch was successful' -f $issueToClose.title, $issueToClose.html_url), 'Close')) {
                    $null = gh issue close $issueToClose.html_url --comment $comment --repo $repo 2>&1 # Suppressing output to show custom message
                }
                Write-Verbose ('✅ Closed issue {0} ({1}) as it its latest run in the main branch was successful.' -f $issueToClose.html_url, $issueToClose.title) -Verbose
                $issuesClosed++
            }
        }
    }

    Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, ($WhatIfPreference ? ' would have been' : '')) -Verbose
    Write-Verbose ('[{0}] issue(s){1} commented' -f $issuesCommented, ($WhatIfPreference ? ' would have been' : '')) -Verbose
    Write-Verbose ('[{0}] issue(s){1} closed' -f $issuesClosed, ($WhatIfPreference ? ' would have been' : '')) -Verbose
}
