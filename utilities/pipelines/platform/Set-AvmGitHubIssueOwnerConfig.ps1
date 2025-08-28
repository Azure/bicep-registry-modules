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
Existing assignments won't be removed as we cannot determine whether they were added manually
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
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueCommentsList.ps1')
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
        # Running on a specific issue
        # $issues = @() + (gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --json 'author,title,url,body,comments' --repo $fullRepositoryName | ConvertFrom-Json -Depth 100)

        $issueId = Split-Path $IssueUrl -Leaf
        $issues = @() + (Get-GitHubIssueList @baseInputObject -IssueId $issueId)
    } else {
        Write-Verbose 'Running on all issues' -Verbose
        # Running on all issuee
        $issues = Get-GitHubIssueList @baseInputObject
    }

    # Fetch module data
    $csvData = @{
        res = (Get-AvmCsvData -ModuleIndex 'Bicep-Resource')
        ptn = (Get-AvmCsvData -ModuleIndex 'Bicep-Pattern')
        utl = (Get-AvmCsvData -ModuleIndex 'Bicep-Utility')
    }

    foreach ($issue in $issues) {

        if ($issue.title.StartsWith('[AVM Module Issue]')) {
            $moduleName, $moduleType = [regex]::Match($issue.body, 'avm\/(res|ptn|utl)\/.+').Captures.Groups.value

            if ([string]::IsNullOrEmpty($moduleName)) {
                throw 'No valid module name was found in the issue.'
            }

            # ================== #
            # Collect issue data #
            # ================== #
            # CSV
            # ---
            $module = $csvData[$moduleType] | Where-Object { $_.ModuleName -eq $moduleName }
            $ownerTeamMembers = [array](Get-GithubTeamMembersLogin -OrgName $RepositoryOwner -TeamName $module.ModuleOwnersGHTeam)

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

            # Existing comments
            # -----------------
            $existingCommentsInputObject = @{
                RepositoryOwner = $RepositoryOwner
                RepositoryName  = $RepositoryName
                IssueNumber     = $issue.number
                # SinceWhen (Get-Date -AsUTC).ToString('yyyy-MM-ddT00:00:00Z')
            }
            $existingComments = Get-GitHubIssueCommentsList @existingCommentsInputObject

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
            Write-Verbose ('📃 Issue [{0}]: Added to project [#{1}]' -f $issue.title, $ProjectNumber) -Verbose

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
                Write-Verbose ('🏷️ Issue [{0}]: Added label [{1}]' -f $issue.title, $label) -Verbose
            }

            # Add initial comment
            # -------------------
            # Comments should only be added for new issues to not create unnecessary noise
            if ($issue.created_at -gt (Get-Date '2025-08-31') -and -not ($existingComments.body -contains $reply)) {
                if ($PSCmdlet.ShouldProcess("Initial comment to issue [$($issue.title)]", 'Add')) {
                    # write comment
                    gh issue comment $issue.url --body $reply --repo $fullRepositoryName
                }
                Write-Verbose ('💬 Issue [{0}]: Added initial comment.' -f $issue.title) -Verbose
            }

            if (($module.ModuleStatus -ne 'Orphaned') -and (-not ([string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle)))) {

                # Assign owner team members
                # -------------------------
                $ownerTeamMembers | Where-Object {
                    $existingAssignees -notcontains $_
                } | ForEach-Object {
                    if ($PSCmdlet.ShouldProcess("Owner team member [$_] to issue [$($issue.title)]", 'Assign')) {
                        gh issue edit $issue.url --add-assignee $_ --repo $fullRepositoryName
                    }
                    Write-Verbose ('👋 Issue [{0}]: Added owner team member [{1}]' -f $issue.title, $_) -Verbose
                }

                # Error handling if assignment failed
                if ([String]::IsNullOrEmpty($assign)) {
                    $reply = @"
> [!WARNING]
> This issue couldn't be assigned due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                    if ($issue.created_at -gt (Get-Date '2025-08-31') -and -not ($existingComments.body -contains $reply)) {
                        if ($PSCmdlet.ShouldProcess("'Assignment failed' comment to issue [$($issue.title)]", 'Add')) {
                            gh issue comment $issue.url --body $reply --repo $fullRepositoryName
                        }
                        Write-Verbose ('💬 Issue [{0}]: Added [Assignment failed] comment' -f $issue.title) -Verbose
                    }
                }
            }
        }

        Write-Verbose ('issue {0}{1} updated' -f $issue.title, $($WhatIfPreference ? ' would have been' : ''))
    }
}
