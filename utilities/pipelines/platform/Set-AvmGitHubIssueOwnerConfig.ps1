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

Process the issue with issue number 757

.EXAMPLE
Set-avmGitHubIssueOwnerConfig -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -WhatIf

Simulate the processing of ALL issues in the given repository
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
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubIssueProjectAssignment.ps1')
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
        $issues = @() + (Get-GitHubIssueList @baseInputObject -IssueId $issueId | Sort-Object -Property 'created_at')
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
    $moduleDistributionData = [System.Collections.ArrayList]@()
    $statistics = [ordered]@{
        "Updates`n-------"                 = $null
        'Added first comments'             = 0
        'Added failed assignment comments' = 0
        'Added assignees'                  = 0
        'Removed assignees'                = 0
        'Project assignments'              = 0
        Labeled                            = 0

        "`nTotals`n------"                 = $null
        'Total issues'                     = $issues.Count
        'Updated issues'                   = 0
        'Issues to review by core team'    = 0

        "`nCategories`n----------"         = $null
        '📦 Module issues'                 = 0
        '🚀 CI issues'                     = 0
        '❔ Question issues'                = 0
        '⛓️‍💥 Failed workflows issues'    = 0
        '◻️  Other issues'                 = 0
    }

    $processedCount = 1
    $totalCount = $issues.Count
    foreach ($issue in $issues) {

        $anyUpdate = $false
        $plainTitle = $issue.title -replace '^.+?]:? '
        $issueCategory = ($issue.title -replace [regex]::Escape($plainTitle)).Trim().TrimStart('[').TrimEnd(':').TrimEnd(']')
        $shortTitle = '{0}{1}' -f $plainTitle.SubString(0, [Math]::Min(15, $plainTitle.Length)).Trim(), ($plainTitle.Length -gt 15 ? '(...)' : '')

        switch ($issueCategory) {
            'AVM CI Environment Issue' { $issueIcon = '🚀'; $statistics.'🚀 CI issues'++; break }
            'AVM Module Issue' { $issueIcon = '📦'; $statistics.'📦 Module issues'++; break }
            'AVM Question/Feedback' { $issueIcon = '❔'; $statistics.'❔ Question issues'++; break }
            'Failed pipeline' { $issueIcon = '⛓️‍💥'; $statistics.'⛓️‍💥 Failed workflows issues'++; break }
            default { $issueIcon = '◻️ '; $statistics.'◻️  Other issues'++; }
        }

        Write-Verbose ('[{0}/{1}] Issue [{2}] {3} {4}: Analyzing...' -f $processedCount, $totalCount, $issue.html_url, $issueIcon, $shortTitle) -Verbose

        if (-not $issue.title.StartsWith('[AVM Module Issue]')) {
            # Not a module issue. Skipping
            if ([String]::IsNullOrEmpty($issueCategory)) {
                Write-Verbose ('    ⚠️  Issue [{0}] {1}: Not a module issue and unknown category. Is skipped and should be reviewed & updated by the core team.' -f $issue.number, $shortTitle) -Verbose
                $statistics.'Issues to review by core team'++
            } else {
                Write-Verbose ('    ℹ️  Issue [{0}] {1}: Not a module issue but [{2}]. Skipping' -f $issue.number, $shortTitle, $issueCategory) -Verbose
            }
            $processedCount++
            continue
        }

        $moduleName, $moduleType = [regex]::Match($issue.body, '\navm\/(res|ptn|utl)\/.+').Captures.Groups.value | ForEach-Object { ($_ ?? '').Trim() }

        # Populate distribution data
        if ($moduleDistributionData.ModuleName -notcontains ($moduleName ? $moduleName : '<unkown>')) {
            $moduleDistributionData += @{
                ModuleName = $moduleName ? $moduleName : '<unkown>'
                ModuleType = $moduleType ? $moduleType : '<?>'
                References = [System.Collections.ArrayList]@()
            }
        }
        ($moduleDistributionData | Where-Object { $_.ModuleName -eq ($moduleName ? $moduleName : '<unkown>') }).References += $issue.html_url


        if ([string]::IsNullOrEmpty($moduleName)) {
            Write-Warning ('    ⚠️  Issue [{0}] {1}: No valid module name was found in the issue. Skipping' -f $issue.number, $shortTitle)
            $statistics.'Issues to review by core team'++
            $processedCount++
            continue
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
        $moduleCsvData = $csvData[$moduleType] | Where-Object { $_.ModuleName -eq $moduleName }

        # new/unknown module
        if ($null -eq $moduleCsvData) {
            Write-Warning ('    ⚠️  Issue [{0}] {1}: Module [{2}] not found in CSV. Skipping assignment.' -f $issue.number, $shortTitle, $moduleName)
            $statistics.'Issues to review by core team'++
            $reply = @"
**@$($issue.user.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> The module does not exist yet, we look into it. Please file a new module proposal under [AVM Module proposal](https://aka.ms/avm/moduleproposal).
"@
        }
        # orphaned module
        elseif ($moduleCsvData.ModuleStatus -eq 'Orphaned') {
            $reply = @"
**@$($issue.user.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> Please note, that this module is currently orphaned. The @Azure/avm-core-team-technical-bicep, will attempt to find an owner for it. In the meantime, the core team may assist with this issue. Thank you for your patience!
"@
        }
        # existing module
        else {
            $ownerTeamMembers = [array](Get-GithubTeamMembersLogin -OrgName $RepositoryOwner -TeamName $moduleCsvData.ModuleOwnersGHTeam)
            if ($ownerTeamMembers) {
                $reply = @"
**@$($issue.user.login), thanks for submitting this issue for the ``$moduleName`` module!**

> [!IMPORTANT]
> A member of the @Azure/$($moduleCsvData.ModuleOwnersGHTeam) team will review it soon!
"@
            } else {
                Write-Warning ('    ⚠️  Issue [{0}] {1}: No members found in owner team [{2}] or team itself does not exist (e.g., because module was deprecated). Skipping comments & assignment.' -f $issue.number, $shortTitle, $moduleCsvData.ModuleOwnersGHTeam)
                $statistics.'Issues to review by core team'++
            }
        }
        # Existing assignees
        # ------------------
        $existingAssignees = $issue.assignees.login

        # Existing labels
        # ---------------
        $existingLabels = $issue.labels.name

        # Existing project assignments
        # ---------------------------
        $existingLabels = $issue.labels.name

        if ($moduleCsvData.ModuleStatus -eq 'Orphaned' -and $existingLabels -notcontains 'Status: Module Orphaned :yellow_circle:') {
            # Added as I found several incorrectly labeled issues
            Write-Warning ('    ⚠️  Issue [{0}] {1}: Module [{2}] is orphaned but not assigned the required label. Please check.' -f $issue.number, $shortTitle, $moduleName)
            $statistics.'Issues to review by core team'++
        }

        # ============= #
        # Process issue #
        # ============= #
        $projectAssignments = Get-GitHubIssueProjectAssignment @baseInputObject -IssueNumber $issue.number

        # Add issue to project
        # --------------------
        $ProjectNumber = 566 # AVM - Module Issues
        if ($projectAssignments.number -notcontains $projectNumber) {
            $anyUpdate = $true
            $statistics.'Project assignments'++
            if ($PSCmdlet.ShouldProcess("Issue [$($issue.number)] to project [$ProjectNumber (AVM - Module Issues)]", 'Add')) {
                $null = Add-GitHubIssueToProject @baseInputObject -ProjectNumber $ProjectNumber -IssueUrl $issue.url
            }
            Write-Verbose ('    📃  Issue [{0}] {1}: Added to project [#{2}]' -f $issue.number, $shortTitle, $ProjectNumber) -Verbose
        }

        switch ($moduleType) {
            'res' { $label = 'Class: Resource Module :package:'; break }
            'ptn' { $label = 'Class: Pattern Module :package:'; break }
            'utl' { $label = 'Class: Utility Module :package:'; break }
            default {
                throw "Unknown module type [$moduleType]"
            }
        }

        # Add class label
        # ---------------
        if ($existingLabels -notcontains $label) {
            $anyUpdate = $true
            $statistics.Labeled++
            if ($PSCmdlet.ShouldProcess("Class label to issue [$($issue.number)]", 'Add')) {
                $null = gh issue edit $issue.number --add-label $label --repo $fullRepositoryName
            }
            Write-Verbose ('    🏷️  Issue [{0}] {1}: Added label [{2}]' -f $issue.title, $shortTitle, $label) -Verbose
        }

        # Add initial comment (if not an old issue, unless orphaned)
        # ----------------------------------------------------------
        if ($commentsOfIssue.body -notcontains $reply -and ($issue.created_at -gt (Get-Date).AddDays(-7) -or $moduleCsvData.ModuleStatus -eq 'Orphaned')) {
            $anyUpdate = $true
            $statistics.'Added first comments'++
            if ($PSCmdlet.ShouldProcess("Initial comment to issue [$($issue.number)]", 'Add')) {
                # write comment
                $null = gh issue comment $issue.number --body $reply --repo $fullRepositoryName
            }
            Write-Verbose ('    💬  Issue [{0}] {1}: Added initial comment{2}.' -f $issue.number, $shortTitle, ($moduleCsvData.ModuleStatus -eq 'Orphaned' ? ' (for orphaned)' : '')) -Verbose
        }

        if (($moduleCsvData.ModuleStatus -ne 'Orphaned') -and (-not ([string]::IsNullOrEmpty($moduleCsvData.PrimaryModuleOwnerGHHandle)))) {

            # Assign owner team members
            # -------------------------
            foreach ($alias in ($ownerTeamMembers | Where-Object { $existingAssignees -notcontains $_ })) {

                if ($timelineEvents | Where-Object { ($_.event -eq 'unassigned') -and ($_.assignee.login -eq $alias) }) {
                    # Skipping this alias as it was previously manually unassigned
                    Write-Verbose ('    🫷  Issue [{0}] {1}: Skipping re-assignment of owner team member [{2}] as they were manually unassigned' -f $issue.number, $shortTitle, $alias) -Verbose
                    continue
                }

                $anyUpdate = $true
                $statistics.'Added assignees'++
                if ($PSCmdlet.ShouldProcess("Owner team member [$alias] to issue [$($issue.number)]", 'Assign')) {
                    $assignment = gh issue edit $issue.number --add-assignee $alias --repo $fullRepositoryName
                } else {
                    $assignment = 'anyValue' # Required for correct error handling if running in WhatIf mode
                }

                Write-Verbose ('    👋  Issue [{0}] {1}: Added owner team member [{2}]' -f $issue.number, $shortTitle, $alias) -Verbose

                # Error handling if assignment failed
                if ([String]::IsNullOrEmpty($assignment)) {
                    $reply = @"
> [!WARNING]
> This issue couldn't be assigned due to an internal error. @$($moduleCsvData.PrimaryModuleOwnerGHHandle), please make sure this issue is assigned to you and please provide an initial response as soon as possible, in accordance with the [AVM Support statement](https://aka.ms/AVM/Support).
"@
                    if ($commentsOfIssue.body -notcontains $reply) {
                        $statistics.'Added failed assignment comments'++
                        if ($PSCmdlet.ShouldProcess("'Assignment failed' comment to issue [$($issue.number)]", 'Add')) {
                            $null = gh issue comment $issue.number --body $reply --repo $fullRepositoryName
                        }
                        Write-Verbose ('    💬  Issue [{0}] {1}: Added [Assignment failed] comment' -f $issue.number, $shortTitle) -Verbose
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
            $wasManuallyAssigned = $usersAssignedManually -contains $_
            $isInOwnerTeam = $ownerTeamMembers -contains $_
            $isOrphaned = $moduleCsvData.ModuleStatus -eq 'Orphaned'
            -not $wasManuallyAssigned -and (-not $isInOwnerTeam -or $isOrphaned)
        }
        foreach ($excessAssignee in $assigneesToRemove) {
            $anyUpdate = $true
            $statistics.'Removed assignees'++
            if ($PSCmdlet.ShouldProcess("Excess assignee [$excessAssignee] from issue [$($issue.number)]", 'Remove')) {
                $null = gh issue edit $issue.number --remove-assignee $excessAssignee --repo $fullRepositoryName
            }
            Write-Verbose ('    ♻️  Issue [{0}] {1}: Removed excess assignee [{2}]' -f $issue.number, $shortTitle, $excessAssignee) -Verbose
        }

        if ($anyUpdate) {
            $statistics.'Updated issues'++
            Write-Verbose ('    💾  Issue [{0}] {1} {2} updated' -f $issue.number, $shortTitle, $($WhatIfPreference ? 'would have been' : '')) -Verbose
        } else {
            Write-Verbose ('    ✅  Issue [{0}] {1} is up to date' -f $issue.number, $shortTitle) -Verbose
        }
        $processedCount++
    }

    # ================ #
    # Print statistics #
    # ================ #

    Write-Verbose '# ========== #' -Verbose
    Write-Verbose '# Statistics #' -Verbose
    Write-Verbose '# ========== #' -Verbose
    Write-Verbose ($statistics | Format-Table -AutoSize -Wrap -HideTableHeaders | Out-String) -Verbose
    Write-Verbose '' -Verbose
    Write-Verbose '# Assignee distribution' -Verbose
    Write-Verbose '# ---------------------' -Verbose
    # Expand issues by assignees
    # E.g., if one issue has two assignees, the list will contain two copies of that issue, one per assignee
    $expandedList = [System.Collections.ArrayList]@()
    foreach ($issue in $issues) {
        $assignees = $issue.assignees
        if (-not $assignees) {
            $assignees = @(@{ login = 'Unassigned' })
        }
        foreach ($assignee in $assignees) {
            $copy = $issue.PsObject.Copy()
            $copy.assignee = $assignee
            $expandedList += $copy
        }
    }
    Write-Verbose ($expandedList | Group-Object -Property { $_.assignee.login } | ForEach-Object {
            [PSCustomObject]@{
                Assignee = ($_.name ? $_.name : 'Unassigned')
                '#'      = $_.Count
            }
        } | Sort-Object '#' -Descending | Out-String) -Verbose
    Write-Verbose '# Module distribution' -Verbose
    Write-Verbose '# -------------------' -Verbose
    Write-Verbose ($moduleDistributionData | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.ModuleName
                Type = ('{0} {1}' -f $_.ModuleType, ($_.ModuleType -eq 'res' ? '📄' : $_.ModuleType -eq 'ptn' ? '📁' :  $_.ModuleType -eq 'utl' ? '🔨' : '⚠️'))
                '#'  = $_.References.Count
            }
        } | Sort-Object -Property { $_.'#' } -Descending | Format-Table | Out-String) -Verbose
}
