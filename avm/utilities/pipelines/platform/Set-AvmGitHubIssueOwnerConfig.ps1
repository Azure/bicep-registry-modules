<#
.SYNOPSIS
Assigns issues to module owners and adds comments and labels

.DESCRIPTION
For the given issue, the module owner (according to the AVM CSV file) will be notified in a comment and assigned to the issue

.PARAMETER Repo
Repository name according to GitHub (owner/name)

.PARAMETER IssueUrl
The full GitHub URL to the issue

.EXAMPLE
Set-AvmGitHubIssueOwnerConfig -Repo 'Azure/bicep-registry-modules' -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

.NOTES
Will be triggered by the workflow avm.platform.set-avm-github-issue-owner-config.yml
#>
function Set-AvmGitHubIssueOwnerConfig {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [string] $Repo,

    [Parameter(Mandatory = $true)]
    [string] $IssueUrl
  )

  $issue = gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --json 'author,title,url,body,comments' --repo $Repo | ConvertFrom-Json -Depth 100

  if ($issue.title.StartsWith('[AVM Module Issue]')) {
    $moduleName = ($issue.body.Split("`n") -match "avm/(?:res|ptn)")[0].Trim().Replace(' ', '')

    if ([string]::IsNullOrEmpty($moduleName)) {
      throw 'No valid module name was found in the issue.'
    }

    $moduleIndex = $moduleName.StartsWith("avm/res") ? "Bicep-Resource" : "Bicep-Pattern"
    $module = Get-AvmCsvData -ModuleIndex $moduleIndex | Where-Object ModuleName -eq $moduleName

    if ([string]::IsNullOrEmpty($module)) {
      throw "Module $moduleName was not found in $moduleIndex CSV file."
    }

    $reply = @"
@$($issue.author.login), thanks for submitting this issue for the ``$moduleName`` module!

A member of the @azure/$($module.ModuleOwnersGHTeam) or @azure/$($module.ModuleContributorsGHTeam) team will review it soon!
"@

    if ($PSCmdlet.ShouldProcess("attention label to issue [$($issue.title)]", 'Add')) {
      # add labels
      gh issue edit $issue.url --add-label "Needs: Attention :wave:" --repo $Repo
    }

    if ($PSCmdlet.ShouldProcess("class label to issue [$($issue.title)]", 'Add')) {
      gh issue edit $issue.url --add-label ($moduleIndex -eq "Bicep-Resource" ? "Class: Resource Module :package:" : "Class: Pattern Module :package:") --repo $Repo
    }

    if ($PSCmdlet.ShouldProcess("reply comment to issue [$($issue.title)]", 'Add')) {
      # write comment
      gh issue comment $issue.url --body $reply --repo $Repo
    }

    if ($PSCmdlet.ShouldProcess(("owner [{0}] to issue [$($issue.title)]" -f $module.PrimaryModuleOwnerGHHandle), 'Assign')) {
      # assign owner
      $assign = gh issue edit $issue.url --add-assignee $module.PrimaryModuleOwnerGHHandle --repo $Repo
    }

    if ([String]::IsNullOrEmpty($assign)) {
      $reply = "This issue couldn't be assigend to $($module.PrimaryModuleOwnerGHHandle), because no such users exists."
      if ($PSCmdlet.ShouldProcess("missing user comment to issue [$($issue.title)]", 'Add')) {
        gh issue comment $issue.url --body $reply --repo $Repo
      }
    }
  }

  Write-Verbose ('issue {0}{1} updated' -f $issue.title, $($WhatIfPreference ? ' would have been' : ''))
}