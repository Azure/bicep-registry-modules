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
Will be triggered by the workflow platform.set-avm-github-issue-owner-config.yml
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
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Add-GitHubIssueToProject.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GithubTeamMembersLogin.ps1')

    $fullRepositoryName = "$RepositoryOwner/$RepositoryName"

    if (-not [String]::IsNullOrEmpty($IssueUrl)) {
        Write-Verbose "Running on issue [$IssueUrl" -Verbose
        # Running on a specific issue
        $issues = @() + (gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --json 'author,title,url,body,comments' --repo $fullRepositoryName | ConvertFrom-Json -Depth 100)
    } else {
        Write-Verbose 'Running on all issues' -Verbose
        # Running on all issues

        $baseInputObject = @{
            RepositoryOwner = $RepositoryOwner
            RepositoryName  = $RepositoryName
        }
        if ($PersonalAccessToken) {
            $baseInputObject['PersonalAccessToken'] = @{
                PersonalAccessToken = $PersonalAccessToken
            }
        }

        $issues = Get-GitHubIssueList @baseInputObject
    }

    # TODO: Group issues into type (res|ptn|utl) so that we can fetch the CSV Data only once (line 94)
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

            # get CSV data
            $module = $csvData[$moduleType] | Where-Object { $_.ModuleName -eq $moduleName }
            $ownerTeamMembers = [array](Get-GithubTeamMembersLogin -OrgName $RepositoryOwner -TeamName $module.ModuleOwnersGHTeam)

            # new/unknown module
            if ($null -eq $module) {
                $reply = @"
**@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> The module does not exist yet, we look into it. Please file a new module proposal under [AVM Module proposal](https://aka.ms/avm/moduleproposal).
"@
            }
            # orphaned module
            elseif ($module.ModuleStatus -eq 'Orphaned') {
                $reply = @"
**@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> Please note, that this module is currently orphaned. The @Azure/avm-core-team-technical-bicep, will attempt to find an owner for it. In the meantime, the core team may assist with this issue. Thank you for your patience!
"@
            }
            # existing module
            else {
                $reply = @"
**@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> A member of the @Azure/$($module.ModuleOwnersGHTeam) team will review it soon!
"@
            }

            # add issue to project
            $ProjectNumber = 566 # AVM - Module Issues
            if ($PSCmdlet.ShouldProcess("Issue [$($issue.title)] to project [$ProjectNumber (AVM - Module Issues)]", 'Add')) {
                Add-GitHubIssueToProject -Repo $fullRepositoryName -ProjectNumber $ProjectNumber -IssueUrl $IssueUrl
            }

            switch ($moduleType) {
                'res' { $label = 'Class: Resource Module :package:' }
                'ptn' { $label = 'Class: Pattern Module :package:' }
                'utl' { $label = 'Class: Utility Module :package:' }
                default {
                    throw "Unknown module type [$moduleType]"
                }
            }

            # TODO: Update to only add label if it doesn't already exist
            if ($PSCmdlet.ShouldProcess("Class label to issue [$($issue.title)]", 'Add')) {
                gh issue edit $issue.url --add-label $label --repo $fullRepositoryName
            }

            # TODO: Update to only add comment if it doesn't already exist
            if ($PSCmdlet.ShouldProcess("Reply comment to issue [$($issue.title)]", 'Add')) {
                # write comment
                gh issue comment $issue.url --body $reply --repo $fullRepositoryName
            }


            if (($module.ModuleStatus -ne 'Orphaned') -and (-not ([string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle)))) {

                # TODO: Update to only add assignee if it doesn't already exist
                # Assign owner team members
                $ownerTeamMembers | ForEach-Object {
                    if ($PSCmdlet.ShouldProcess("Owner team member [$_] to issue [$($issue.title)]", 'Assign')) {
                        gh issue edit $issue.url --add-assignee $_ --repo $fullRepositoryName
                    }
                }

                if ([String]::IsNullOrEmpty($assign)) {
                    $reply = @"
> [!WARNING]
> This issue couldn't be assigned due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                    # TODO: Update to only add comment if it doesn't already exist
                    if ($PSCmdlet.ShouldProcess("Missing user comment to issue [$($issue.title)]", 'Add')) {
                        gh issue comment $issue.url --body $reply --repo $fullRepositoryName
                    }
                }
            }

            # TODO: Add logic to remove assignees
            # -> If orphaned, all assignees
            # -> If owned, any user that is not part of the owner team
        }

        Write-Verbose ('issue {0}{1} updated' -f $issue.title, $($WhatIfPreference ? ' would have been' : ''))
    }
}
