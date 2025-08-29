<#
.SYNOPSIS
Assigns issues to module owners and adds comments and labels

.DESCRIPTION
For the given issue, the module owner (according to the AVM CSV file) will be notified in a comment and assigned to the issue

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepositoryOwner
Mandatory. The GitHub organization to run the workfows in.

.PARAMETER RepositoryName
Mandatory. The GitHub repository to run the workfows in,

.PARAMETER IssueUrl
Conditional. The URL of a GitHub issue, like 'https://github.com/Azure/bicep-registry-modules/issues/757'. Required if RepositoryOwner and RepositoryName are empty.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.EXAMPLE
Set-AvmGitHubIssueOwnerConfig -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

.NOTES
Existing assignments won't be removed as we cannot determine whether they were added manually.
One way to address this would be to fetch he timeline per issue and only remove assignees that are not owners and where not manually added as per set timeline.
See:https://docs.github.com/en/rest/issues/timeline?apiVersion=2022-11-28#list-timeline-events-for-an-issue
#>
function Set-AvmGitHubIssueOwnerConfig {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true, ParameterSetName = 'SpecificIssue')]
        [string] $IssueUrl,

        [Parameter(Mandatory = $false, ParameterSetName = 'AllIssues')]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueList.ps1')
    # . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueCommentsList.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueTimeline.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Add-GitHubIssueToProject.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GithubTeamMembersLogin.ps1')

    $fullRepositoryName = "$RepositoryOwner/$RepositoryName"

    $baseInputObject = @{
        RepositoryOwner = $RepositoryOwner
        RepositoryName  = $RepositoryName
    }
    if ($PersonalAccessToken) {
        $baseInputObject['PersonalAccessToken'] = @{
            PersonalAccessToken = $PersonalAccessToken
        }
    }

    if (-not [String]::IsNullOrEmpty($IssueUrl)) {
        Write-Verbose "Running on issue [$IssueUrl" -Verbose
        $issueId = Split-Path $IssueUrl -Leaf
        $issues = @() + (Get-GitHubIssueList @baseInputObject -IssueId $issueId)
    } else {
        Write-Verbose 'Fetching all issues' -Verbose
        $issues = Get-GitHubIssueList @baseInputObject
    }

    # Fetch module data
    $csvData = @{
        res = (Get-AvmCsvData -ModuleIndex 'Bicep-Resource')
        ptn = (Get-AvmCsvData -ModuleIndex 'Bicep-Pattern')
        utl = (Get-AvmCsvData -ModuleIndex 'Bicep-Utility')
    }

    # TODO: Add counter
    $processedCount = 0
    $totalCount = $issues.Count
    foreach ($issue in $issues) {

        if (-not $issue.title.StartsWith('[AVM Module Issue]')) {
            # Not a module issue. Skipping
            continue
        }

        $moduleName, $moduleType = [regex]::Match($issue.body, 'avm\/(res|ptn|utl)\/.+').Captures.Groups.value
        $shortTitle = '{0}...' -f ($issue.title -split ']: ')[1].SubString(0, 15)

        if ([string]::IsNullOrEmpty($moduleName)) {
            throw 'No valid module name was found in the issue.'
        }

        # ================== #
        # Collect issue data #
        # ================== #

        # Issue Timeline
        # --------------
        $timelineEvents = @() + (Get-GitHubIssueTimeline @baseInputObject -IssueNumber $issue.number)

        # Existing comments
        # ----------------
        $commentsOfIssue = @() + ($timelineEvents | Where-Object { $_.event -eq 'commented' })

        # CSV
        # ---
        $module = $csvData[$moduleType] | Where-Object { $_.ModuleName -eq $moduleName }

        if (-not $module) {
            Write-Warning ('⚠️ [{0}/{1}] Module [{2}] not found in CSV. Skipping assignment. Ref: [{3}]' -f $processedCount, $totalCount, $moduleName, $issue.html_url)

            ## TODO: Adding comment?

        } else {
            $ownerTeamMembers = [array](Get-GithubTeamMembersLogin -OrgName $RepositoryOwner -TeamName $module.ModuleOwnersGHTeam)
        }
        # new/unknown module
        if ($null -eq $module) {
            $reply = @"
**@$($issue.user.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> The module does not exist yet, we look into it. Please file a new module proposal under [AVM Module proposal](https://aka.ms/avm/moduleproposal).
"@
        }
        # orphaned module
        elseif ($module.ModuleStatus -eq 'Orphaned') {
            $reply = @"
**@$($issue.user.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> Please note, that this module is currently orphaned. The @Azure/avm-core-team-technical-bicep, will attempt to find an owner for it. In the meantime, the core team may assist with this issue. Thank you for your patience!
"@
        }
        # existing module
        else {
            $reply = @"
**@$($issue.user.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> A member of the @Azure/$($module.ModuleOwnersGHTeam) team will review it soon!
"@
        }

        # Existing assignees
        # ------------------
        $existingAssignees = $issue.assignees.login

        # Existing labels
        # ---------------
        $existingLabels = $issue.labels.name

        # ============= #
        # Process issue #
        # ============= #

        # Add issue to project
        # --------------------
        $ProjectNumber = 566 # AVM - Module Issues
        if ($PSCmdlet.ShouldProcess("Issue [$($issue.title)] to project [$ProjectNumber (AVM - Module Issues)]", 'Add')) {
            Add-GitHubIssueToProject -Repo $fullRepositoryName -ProjectNumber $ProjectNumber -IssueUrl $IssueUrl
        }
        Write-Verbose ('📃 [{0}/{1}] Issue [{2}] {3}: Added to project [#{4}]' -f $processedCount, $totalCount, $issue.number, $shortTitle, $ProjectNumber) -Verbose

        switch ($moduleType) {
            'res' { $label = 'Class: Resource Module :package:' }
            'ptn' { $label = 'Class: Pattern Module :package:' }
            'utl' { $label = 'Class: Utility Module :package:' }
            default {
                throw "Unknown module type [$moduleType]"
            }
        }

        # Add class label
        # ---------------
        if ($existingLabels -notcontains $label) {
            if ($PSCmdlet.ShouldProcess("Class label to issue [$($issue.title)]", 'Add')) {
                gh issue edit $issue.url --add-label $label --repo $fullRepositoryName
            }
            Write-Verbose ('🏷️ [{0}/{1}] Issue [{2}] {3}: Added label [{4}]' -f $processedCount, $totalCount, $issue.title, $shortTitle, $label) -Verbose
        }

        # Add initial comment
        # -------------------
        if ($commentsOfIssue.body -notcontains $reply) {
            if ($PSCmdlet.ShouldProcess("Initial comment to issue [$($issue.title)]", 'Add')) {
                # write comment
                gh issue comment $issue.url --body $reply --repo $fullRepositoryName
            }
            Write-Verbose ('[{0}/{1}] 💬 Issue [{2}] {3}: Added initial comment.' -f $processedCount, $totalCount, $issue.number, $shortTitle) -Verbose
        } else {
            Write-Debug ('[{0}/{1}] 📎 Issue [{2}] {3}: Already received its initial comment. Skipping.' -f $processedCount, $totalCount, $issue.number, $shortTitle)
        }

        if (($module.ModuleStatus -ne 'Orphaned') -and (-not ([string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle)))) {

            # Assign owner team members
            # -------------------------
            foreach ($alias in ($ownerTeamMembers | Where-Object { $existingAssignees -notcontains $_ })) {

                if ($PSCmdlet.ShouldProcess("Owner team member [$alias] to issue [$($issue.title)]", 'Assign')) {
                    $assignment = gh issue edit $issue.url --add-assignee $alias --repo $fullRepositoryName
                } else {
                    $assignment = 'anyValue' # Required for correct error handling if running in WhatIf mode
                }

                Write-Verbose ('👋 [{0}/{1}] Issue [{2}] {3}: Added owner team member [{4}]' -f $processedCount, $totalCount, $issue.number, $shortTitle, $alias) -Verbose

                # Error handling if assignment failed
                if ([String]::IsNullOrEmpty($assignment)) {
                    $reply = @"
> [!WARNING]
> This issue couldn't be assigned due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                    if ($commentsOfIssue.body -notcontains $reply) {
                        if ($PSCmdlet.ShouldProcess("'Assignment failed' comment to issue [$($issue.title)]", 'Add')) {
                            gh issue comment $issue.url --body $reply --repo $fullRepositoryName
                        }
                        Write-Verbose ('💬 [{0}/{1}] Issue [{2}] {3}: Added [Assignment failed] comment' -f $processedCount, $totalCount, $issue.number, $shortTitle) -Verbose
                    } else {
                        Write-Verbose ('📎 [{0}/{1}] Issue [{2}] {3}: Already has a comment calling out the failed assignment. Skipping.' -f $processedCount, $totalCount, $issue.number, $shortTitle) -Verbose
                    }
                }
            }
        }

        # Remove assignees unless owner or manually added (i.e., not by bot)
        # ------------------------------------------------------------------
        $usersAssignedManually = ($timelineEvents | Where-Object {
                ($_.event -eq 'assigned') -and ($_.actor.login -ne 'avm-team-linter[bot]')
            }).assignee.login
        $assigneesToRemove = $existingAssignees | Where-Object {
            ($ownerTeamMembers -notcontains $_) -and ($usersAssignedManually -notcontains $_)

            foreach ($excessAssignee in $assigneesToRemove) {
                if ($PSCmdlet.ShouldProcess("Excess assignee [$excessAssignee] from issue [$($issue.title)]", 'Remove')) {
                    gh issue edit $issue.url --remove-assignee $excessAssignee --repo $fullRepositoryName
                }
                Write-Verbose ('🗑️ [{0}/{1}] Issue [{2}] {3}: Removed excess assignee [{4}]' -f $processedCount, $totalCount, $issue.number, $shortTitle, $excessAssignee) -Verbose
            }
        }

        Write-Debug ('✅ [{0}/{1}] Issue [{2}] {3} {4} updated' -f $processedCount, $totalCount, $issue.number, $shortTitle, $($WhatIfPreference ? 'would have been' : ''))
        $processedCount++
    }
}
