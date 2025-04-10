<#
.SYNOPSIS
Assigns issues to module owners and adds comments and labels

.DESCRIPTION
For the given issue, the module owner (according to the AVM CSV file) will be notified in a comment and assigned to the issue

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER IssueUrl
Mandatory. The URL of the GitHub issue, like 'https://github.com/Azure/bicep-registry-modules/issues/757'

.EXAMPLE
Set-AvmGitHubIssueOwnerConfig -Repo 'Azure/bicep-registry-modules' -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

.NOTES
Will be triggered by the workflow platform.set-avm-github-issue-owner-config.yml
#>
function Set-AvmGitHubIssueOwnerConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $true)]
        [string] $IssueUrl,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Add-GithubIssueToProject.ps1')

    $issue = gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --json 'author,title,url,assignees,body,comments,labels' --repo $Repo | ConvertFrom-Json -Depth 100

    if ($issue.title.StartsWith('[AVM Module Issue]')) {
        $moduleName = ($issue.body.Split("`n") -match 'avm/(?:res|ptn|utl)')[0].Trim().Replace(' ', '')

        if ([string]::IsNullOrEmpty($moduleName)) {
            throw 'No valid module name was found in the issue.'
        }

        $moduleIndex = $moduleName.StartsWith('avm/res') ? 'Bicep-Resource' : 'Bicep-Pattern'
        # get CSV data
        $module = Get-AvmCsvData -ModuleIndex $moduleIndex | Where-Object ModuleName -EQ $moduleName

        # new/unknown module
        if ($null -eq $module) {
            $reply = @"
**@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> The module does not exist yet, we look into it. Please file a new module proposal under [AVM Module proposal](https://aka.ms/avm/moduleproposal).
"@
            if ($issue.comments.body -notcontains $reply) {
                if ($PSCmdlet.ShouldProcess("reply comment to issue [$($issue.title)]")) {
                    # write comment
                    gh issue comment $issue.url --body $reply --repo $Repo
                }
            }
        }
        # orphaned module
        elseif ($module.ModuleStatus -eq 'Orphaned :eyes:') {
            if ($issue.labels.name -notcontains 'Status: Module Orphaned :eyes:') {
                if ($PSCmdlet.ShouldProcess("add orphaned label to issue [$($issue.title)]")) {
                    gh issue edit $issue.url --add-label 'Status: Module Orphaned :eyes:' --repo $Repo
                }
            }

            $reply = @"
**@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> Please note, that this module is currently orphaned. The @Azure/avm-core-team-technical-bicep, will attempt to find an owner for it. In the meantime, the core team may assist with this issue. Thank you for your patience!
"@
            if ($issue.comments.body -notcontains $reply) {
                if ($PSCmdlet.ShouldProcess("reply comment to issue [$($issue.title)]")) {
                    # write comment
                    gh issue comment $issue.url --body $reply --repo $Repo
                }
            }
        }
        # existing module
        else {
            $reply = @"
**@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> A member of the @Azure/$($module.ModuleOwnersGHTeam) or @Azure/$($module.ModuleContributorsGHTeam) team will review it soon!
"@
            if ($issue.comments.body -notcontains $reply) {
                if ($PSCmdlet.ShouldProcess("reply comment to issue [$($issue.title)]")) {
                    # write comment
                    gh issue comment $issue.url --body $reply --repo $Repo
                }
            }
        }

        # add issue to project
        $ProjectNumber = 566 # AVM - Module Issues
        Add-GithubIssueToProject -Repo $Repo -ProjectNumber $ProjectNumber -IssueUrl $IssueUrl

        $moduleTypeLabel = $moduleIndex -eq 'Bicep-Resource' ? 'Class: Resource Module :package:' : 'Class: Pattern Module :package:'

        if ($issue.labels.name -notcontains $moduleTypeLabel) {
            if ($PSCmdlet.ShouldProcess("add class label to issue [$($issue.title)]")) {
                gh issue edit $issue.url --add-label $moduleTypeLabel --repo $Repo
            }
        }

        if (($module.ModuleStatus -ne 'Orphaned :eyes:') -and (-not ([string]::IsNullOrEmpty($module.PrimaryModuleOwnerGHHandle))) -and ($issue.assignees.login -notcontains $module.PrimaryModuleOwnerGHHandle)) {
            if ($PSCmdlet.ShouldProcess(("owner [{0}] to issue [$($issue.title)]" -f $module.PrimaryModuleOwnerGHHandle), 'Assign')) {
                # assign owner
                $assign = gh issue edit $issue.url --add-assignee $module.PrimaryModuleOwnerGHHandle --repo $Repo

                if ([String]::IsNullOrEmpty($assign)) {
                    if ($PSCmdlet.ShouldProcess("missing user comment to issue [$($issue.title)]", 'Add')) {
                        $reply = @"
> [!WARNING]
> This issue couldn't be assigend due to an internal error. @$($module.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                        gh issue comment $issue.url --body $reply --repo $Repo
                    }
                }
            }

            if ($issue.labels.name -contains 'Status: Module Orphaned :eyes:') {
                if ($PSCmdlet.ShouldProcess("orphaned label from issue [$($issue.title)]", 'Remove')) {
                    gh issue edit $issue.url --remove-label 'Status: Module Orphaned :eyes:' --repo $Repo
                }
            }
        }
        Write-Verbose ('issue {0}{1} updated' -f $issue.title, $($WhatIfPreference ? ' would have been' : ''))
    }
}
