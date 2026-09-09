param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Module ownership automation' {
    BeforeAll {
        $platformPath = Join-Path $repoRootPath 'utilities' 'pipelines' 'platform'
        foreach ($scriptName in @('Set-AvmGitHubIssueOwnerConfig', 'Set-AvmGitHubIssueForWorkflow', 'Set-AvmGitHubPrLabels')) {
            . (Join-Path $platformPath "$scriptName.ps1")
        }

        $helperNames = @(
            'Get-AvmCsvData', 'Get-AvmModuleOwnerLogin', 'Get-GitHubIssueList',
            'Get-GitHubIssueTimeline', 'Get-GitHubIssueProjectAssignment', 'Add-GitHubIssueToProject',
            'Get-GitHubModuleWorkflowList', 'Get-GitHubModuleWorkflowLatestRun', 'Get-GitHubIssueCommentsList'
        )
        $script:mockRepoRoot = Join-Path $TestDrive 'repo'
        $mockHelperPath = Join-Path $script:mockRepoRoot 'utilities' 'pipelines' 'platform' 'helper'
        $null = New-Item -Path $mockHelperPath -ItemType Directory -Force
        foreach ($helperName in $helperNames) {
            . (Join-Path $platformPath 'helper' "$helperName.ps1")
            # Runtime imports must not replace mocked dependencies.
            $null = New-Item -Path (Join-Path $mockHelperPath "$helperName.ps1") -ItemType File
        }

        function gh {
            throw 'The real GitHub CLI must never run in these tests.'
        }

        function New-TestModule {
            param (
                [string] $Name = 'avm/res/storage/storage-account',
                [string] $Primary = 'owner-one',
                [string] $Secondary = 'owner-two',
                [string] $Status = 'Available',
                [string] $Parent = ''
            )
            [pscustomobject]@{
                ModuleName                   = $Name
                ModuleStatus                 = $Status
                ParentModule                 = $Parent
                PrimaryModuleOwnerGHHandle   = $Primary
                SecondaryModuleOwnerGHHandle = $Secondary
            }
        }

        function Invoke-TestIssueRouting {
            Set-AvmGitHubIssueOwnerConfig -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot
        }

        function Invoke-TestReviewerRouting {
            Set-AvmGitHubPrLabels -Repo 'test-org/test-repo' -PrUrl 'https://github.com/test-org/test-repo/pull/42' -RepoRoot $script:mockRepoRoot
        }

        function Invoke-TestFailureRouting {
            Set-AvmGitHubIssueForWorkflow -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot
        }
    }

    BeforeEach {
        $script:moduleIndex = @(New-TestModule)
        $script:ghCalls = [System.Collections.Generic.List[object]]::new()
        $script:prReadExitCode = 0
        $script:filesExitCode = 0
        $script:editExitCode = 0
        $script:pr = @{
            number         = 42
            url            = 'https://github.com/test-org/test-repo/pull/42'
            author         = @{ login = 'contributor' }
            isDraft        = $false
            reviewRequests = @(@{ name = 'azure-verified-modules-module-contributors' })
        }
        $script:changedFiles = @('avm/res/storage/storage-account/main.bicep')
        $script:issues = @([pscustomobject]@{
                number     = 17
                title      = '[AVM Module Issue]: Storage issue'
                body       = "### Module`navm/res/storage/storage-account`n"
                user       = @{ login = 'reporter' }
                html_url   = 'https://github.com/test-org/test-repo/issues/17'
                url        = 'https://api.github.com/repos/test-org/test-repo/issues/17'
                assignees  = @()
                assignee   = $null
                labels     = @(@{ name = 'Class: Resource Module :package:' })
                created_at = (Get-Date).ToString('o')
            })
        $script:timeline = @()
        $script:workflowName = 'avm.res.storage.storage-account'

        Mock Invoke-WebRequest {
            if ($Uri -notmatch '^https://aka.ms/avm/index/bicep/(res|ptn|utl)/csv$') {
                throw "Unexpected web request [$Uri]."
            }
            $entries = @($script:moduleIndex | Where-Object { $_.ModuleName.StartsWith("avm/$($matches[1])/") })
            $content = if ($entries.Count -gt 0) {
                $entries | ConvertTo-Csv -NoTypeInformation
            } else {
                '"ModuleName","ModuleStatus","ParentModule","PrimaryModuleOwnerGHHandle","SecondaryModuleOwnerGHHandle"'
            }
            [pscustomobject]@{ Content = $content -join "`n" }
        }
        Mock Invoke-RestMethod { throw 'Unexpected REST request.' }
        Mock Get-GitHubIssueList { $script:issues }
        Mock Get-GitHubIssueTimeline { $script:timeline }
        Mock Get-GitHubIssueProjectAssignment { @{ number = 566 } }
        Mock Add-GitHubIssueToProject {}
        Mock Get-GitHubIssueCommentsList { @() }
        Mock Get-GitHubModuleWorkflowList { [pscustomobject]@{ id = 1; name = $script:workflowName } }
        Mock Get-GitHubModuleWorkflowLatestRun {
            @{
                id         = 2
                name       = $script:workflowName
                status     = 'completed'
                conclusion = 'failure'
                url        = 'https://api.github.com/repos/test-org/test-repo/actions/runs/2'
            }
        }
        Mock gh {
            $script:ghCalls.Add([pscustomobject]@{ Arguments = @($args) })
            $global:LASTEXITCODE = 0
            if ($args[0] -eq 'pr' -and $args[1] -eq 'view') {
                $global:LASTEXITCODE = $script:prReadExitCode
                return $script:pr | ConvertTo-Json -Depth 10
            }
            if ($args[0] -eq 'api' -and ($args -match '/pulls/42/files')) {
                $global:LASTEXITCODE = $script:filesExitCode
                return $script:changedFiles
            }
            if ($args[0] -eq 'pr' -and $args[1] -eq 'edit') {
                $global:LASTEXITCODE = $script:editExitCode
                return $script:pr.url
            }
            if ($args[0] -eq 'issue' -and $args[1] -in @('create', 'edit', 'comment')) {
                return 'https://github.com/test-org/test-repo/issues/17'
            }
            throw "Unexpected GitHub CLI arguments [$($args -join ' ')]."
        }
    }

    Context 'Individual owner resolution' {
        It 'Resolves primary and secondary owners without team metadata' {
            Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex |
                Should -Be @('owner-one', 'owner-two')
        }

        It 'Normalizes handles and removes case-insensitive duplicates' {
            $script:moduleIndex = @(New-TestModule -Primary ' @Owner-One ' -Secondary 'owner-one')
            Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex |
                Should -Be @('Owner-One')
        }

        It 'Supports a secondary owner when no primary handle is populated' {
            $script:moduleIndex = @(New-TestModule -Primary '')
            Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex |
                Should -Be @('owner-two')
        }

        It 'Inherits child ownership from its indexed parent' {
            $childName = 'avm/res/storage/storage-account/blob-service/container'
            $script:moduleIndex += New-TestModule -Name $childName -Primary '' -Secondary '' -Parent 'avm/res/storage/storage-account'
            Get-AvmModuleOwnerLogin -ModuleName $childName -ModuleIndexData $script:moduleIndex |
                Should -Be @('owner-one', 'owner-two')
        }

        It 'Uses explicitly populated child owners instead of parent owners' {
            $childName = 'avm/res/storage/storage-account/blob-service'
            $script:moduleIndex += New-TestModule -Name $childName -Primary 'child-owner' -Secondary ''
            Get-AvmModuleOwnerLogin -ModuleName $childName -ModuleIndexData $script:moduleIndex |
                Should -Be @('child-owner')
        }

        It 'Falls back to the immediate parent when ParentModule is absent' {
            $childName = 'avm/res/storage/storage-account/blob-service'
            $script:moduleIndex += New-TestModule -Name $childName -Primary '' -Secondary ''
            Get-AvmModuleOwnerLogin -ModuleName $childName -ModuleIndexData $script:moduleIndex |
                Should -Be @('owner-one', 'owner-two')
        }

        It 'Returns no owners for an orphaned module even with stale handles' {
            $script:moduleIndex[0].ModuleStatus = 'Orphaned'
            @(Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex).Count | Should -Be 0
        }

        It 'Inherits an orphaned parent even when the child index status is still Available' {
            $script:moduleIndex[0].ModuleStatus = 'Orphaned'
            $childName = 'avm/res/storage/storage-account/blob-service'
            $script:moduleIndex += New-TestModule -Name $childName -Primary '' -Secondary '' -Parent 'avm/res/storage/storage-account'
            @(Get-AvmModuleOwnerLogin -ModuleName $childName -ModuleIndexData $script:moduleIndex).Count | Should -Be 0
        }

        It 'Rejects invalid owner handle [<Handle>]' -ForEach @(
            @{ Handle = 'Azure/team-name' }
            @{ Handle = 'two owners' }
            @{ Handle = '--all' }
            @{ Handle = '@@owner-one' }
            @{ Handle = 'invalid--owner' }
        ) {
            $script:moduleIndex[0].PrimaryModuleOwnerGHHandle = $Handle
            { Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex } |
                Should -Throw '*Invalid owner handle*'
        }

        It 'Rejects missing owner metadata' {
            $script:moduleIndex = @(New-TestModule -Primary '' -Secondary '')
            { Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex } |
                Should -Throw '*No individual owners*'
        }

        It 'Rejects missing or duplicate module entries' {
            { Get-AvmModuleOwnerLogin -ModuleName 'avm/res/missing/module' -ModuleIndexData $script:moduleIndex } |
                Should -Throw '*Expected one index entry*'
            $script:moduleIndex += New-TestModule
            { Get-AvmModuleOwnerLogin -ModuleName $script:moduleIndex[0].ModuleName -ModuleIndexData $script:moduleIndex } |
                Should -Throw '*Expected one index entry*'
        }

        It 'Rejects a parent reference that does not identify an ancestor' {
            $childName = 'avm/res/storage/storage-account/blob-service'
            $script:moduleIndex += New-TestModule -Name $childName -Primary '' -Secondary '' -Parent $childName
            { Get-AvmModuleOwnerLogin -ModuleName $childName -ModuleIndexData $script:moduleIndex } |
                Should -Throw '*Invalid parent module*'
        }

        It 'Reads indexes that no longer contain ModuleOwnersGHTeam' {
            $result = @(Get-AvmCsvData -ModuleIndex 'Bicep-Resource')
            $result.Count | Should -Be 1
            $result[0].PrimaryModuleOwnerGHHandle | Should -Be 'owner-one'
            $result[0].PSObject.Properties.Name | Should -Not -Contain 'ModuleOwnersGHTeam'
        }
    }

    Context 'Issue ownership' {
        It 'Assigns and mentions individual indexed owners without querying teams' {
            Invoke-TestIssueRouting
            $assignments = @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' })
            $assignments.Count | Should -Be 2
            $assignments[0].Arguments | Should -Contain 'owner-one'
            $assignments[1].Arguments | Should -Contain 'owner-two'
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@owner-one, @owner-two'
            ($script:ghCalls.Arguments -join ' ') | Should -Not -Match '/teams/'
        }

        It 'Preserves indexed and manually assigned users and removes obsolete bot assignees' {
            $script:issues[0].assignees = @(@{ login = 'owner-one' }, @{ login = 'manual-owner' }, @{ login = 'former-owner' })
            $script:timeline = @(@{ event = 'assigned'; actor = @{ login = 'maintainer' }; assignee = @{ login = 'manual-owner' } })
            Invoke-TestIssueRouting
            $removals = @($script:ghCalls | Where-Object { $_.Arguments -contains '--remove-assignee' })
            $removals.Count | Should -Be 1
            $removals[0].Arguments | Should -Contain 'former-owner'
        }

        It 'Does not reassign an owner who was manually unassigned' {
            $script:timeline = @(@{ event = 'unassigned'; assignee = @{ login = 'owner-two' } })
            Invoke-TestIssueRouting
            $assignments = @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' })
            $assignments.Count | Should -Be 1
            $assignments[0].Arguments | Should -Contain 'owner-one'
        }

        It 'Makes no updates when individual owner metadata cannot be resolved' {
            $script:moduleIndex = @(New-TestModule -Primary '' -Secondary '')
            $script:issues[0].assignees = @(@{ login = 'owner-one' })
            Set-AvmGitHubIssueOwnerConfig -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot -WarningVariable warnings
            $script:ghCalls.Count | Should -Be 0
            ($warnings -join ' ') | Should -Match 'preserving existing assignees'
        }

        It 'Makes no updates when duplicate entries disagree about orphaned status' {
            $script:moduleIndex += New-TestModule -Status 'Orphaned'
            $script:issues[0].assignees = @(@{ login = 'owner-one' })
            Invoke-TestIssueRouting
            $script:ghCalls.Count | Should -Be 0
        }

        It 'Preserves existing assignees for an unknown module' {
            $script:issues[0].body = "### Module`navm/res/unknown/module`n"
            $script:issues[0].assignees = @(@{ login = 'owner-one' })
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--remove-assignee' }).Count | Should -Be 0
        }

        It 'Resolves child issue owners from the parent index entry' {
            $childName = 'avm/res/storage/storage-account/blob-service'
            $script:moduleIndex += New-TestModule -Name $childName -Primary '' -Secondary '' -Parent 'avm/res/storage/storage-account'
            $script:issues[0].body = "### Module`n$childName`n"
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 2
        }

        It 'Notifies the tooling team when a child inherits an orphaned parent' {
            $script:moduleIndex[0].ModuleStatus = 'Orphaned'
            $childName = 'avm/res/storage/storage-account/blob-service'
            $script:moduleIndex += New-TestModule -Name $childName -Primary '' -Secondary '' -Parent 'avm/res/storage/storage-account'
            $script:issues[0].body = "### Module`n$childName`n"
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 0
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@Azure/azure-verified-modules-tooling-contributors'
        }

        It 'Does not reuse owners from the previous issue when processing an orphan' {
            $script:moduleIndex += New-TestModule -Name 'avm/res/network/virtual-network' -Primary '' -Secondary '' -Status 'Orphaned'
            $orphanIssue = $script:issues[0].PSObject.Copy()
            $orphanIssue.number = 18
            $orphanIssue.body = "### Module`navm/res/network/virtual-network`n"
            $orphanIssue.assignees = @(@{ login = 'owner-one' })
            $script:issues += $orphanIssue
            Invoke-TestIssueRouting
            $removals = @($script:ghCalls | Where-Object { $_.Arguments -contains '--remove-assignee' })
            $removals.Count | Should -Be 1
            $removals[0].Arguments | Should -Contain 18
            $removals[0].Arguments | Should -Contain 'owner-one'
        }

        It 'Performs no GitHub writes under WhatIf' {
            Set-AvmGitHubIssueOwnerConfig -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot -WhatIf
            $script:ghCalls.Count | Should -Be 0
        }
    }

    Context 'Reviewer routing' {
        It 'Uses indexed owners instead of the shared contributors team' {
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[0] -eq 'pr' -and $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Module Owner :mega:'
            $edit.Arguments | Should -Contain 'owner-one,owner-two'
            ($script:ghCalls.Arguments -join ' ') | Should -Not -Match '/teams/'
            ($script:ghCalls | Where-Object { $_.Arguments[0] -eq 'api' }).Arguments | Should -Contain '--paginate'
        }

        It 'Requests the other owner instead of the author' {
            $script:pr.author.login = 'OWNER-ONE'
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'owner-two'
            $edit.Arguments | Should -Not -Contain 'owner-one,owner-two'
        }

        It 'Does not duplicate an existing individual review request' {
            $script:pr.reviewRequests += @{ login = 'owner-one' }
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'owner-two'
        }

        It 'Preserves explicit core-team review requests' {
            $script:pr.reviewRequests += @{ slug = 'azure-verified-modules-tooling-contributors' }
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Core Team :genie:'
            $edit.Arguments | Should -Not -Contain '--add-reviewer'
        }

        It 'Keeps module-owner routing when all eligible reviewers are already requested' {
            $script:pr.reviewRequests += @(@{ login = 'owner-one' }, @{ login = 'owner-two' })
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Module Owner :mega:'
            $edit.Arguments | Should -Not -Contain '--add-reviewer'
        }

        It 'Skips draft pull requests until they are ready for review' {
            $script:pr.isDraft = $true
            Invoke-TestReviewerRouting
            $script:ghCalls.Count | Should -Be 1
        }

        It 'Routes tooling changes and protected files to the core team [<Path>]' -ForEach @(
            @{ Path = 'utilities/tools/example.ps1' }
            @{ Path = 'avm/res/storage/storage-account/tests/unit/avm.core.team.tests.ps1' }
            @{ Path = 'avm/res/storage/storage-account/tests/e2e/defaults/.e2eignore' }
            @{ Path = 'avm/README.md' }
        ) {
            $script:changedFiles += $Path
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Core Team :genie:'
            $edit.Arguments | Should -Not -Contain '--add-reviewer'
        }

        It 'Routes cross-module changes, including rename source paths, to the core team' {
            $script:moduleIndex += New-TestModule -Name 'avm/res/network/virtual-network'
            $script:changedFiles += 'avm/res/network/virtual-network/main.bicep'
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Core Team :genie:'
            $edit.Arguments | Should -Not -Contain '--add-reviewer'
            ($script:ghCalls | Where-Object { $_.Arguments[0] -eq 'api' }).Arguments | Should -Contain '.[] | .filename, (.previous_filename // empty)'
        }

        It 'Routes orphaned modules to the core team and adds the orphan label' {
            $script:moduleIndex[0].ModuleStatus = 'Orphaned'
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Core Team :genie:'
            $edit.Arguments | Should -Contain 'Status: Module Orphaned :yellow_circle:'
            $edit.Arguments | Should -Not -Contain '--add-reviewer'
        }

        It 'Routes a sole-owner contribution to the core team' {
            $script:moduleIndex[0].SecondaryModuleOwnerGHHandle = ''
            $script:pr.author.login = 'owner-one'
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'Needs: Core Team :genie:'
        }

        It 'Routes an unindexed module to the core team' {
            $script:changedFiles = @('avm/res/unknown/module/main.bicep')
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'Needs: Core Team :genie:'
        }

        It 'Maps child-module files to the top-level module owner' {
            $script:changedFiles = @('avm/res/storage/storage-account/blob-service/container/main.bicep')
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'owner-one,owner-two'
        }

        It 'Selects the correct index for [<ModuleName>]' -ForEach @(
            @{ ModuleName = 'avm/ptn/example/pattern'; IndexType = 'ptn' }
            @{ ModuleName = 'avm/utl/example/utility'; IndexType = 'utl' }
        ) {
            $script:moduleIndex = @(New-TestModule -Name $ModuleName)
            $script:changedFiles = @("$ModuleName/main.bicep")
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'owner-one,owner-two'
            Should -Invoke Invoke-WebRequest -Times 1 -Exactly -ParameterFilter { $Uri -eq "https://aka.ms/avm/index/bicep/$IndexType/csv" }
        }

        It 'Makes no edits when pull request lookup fails' {
            $script:prReadExitCode = 1
            { Invoke-TestReviewerRouting } | Should -Throw '*Unable to retrieve pull request*'
            @($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Count | Should -Be 0
        }

        It 'Makes no edits when changed-file lookup fails' {
            $script:filesExitCode = 1
            { Invoke-TestReviewerRouting } | Should -Throw '*Unable to retrieve changed files*'
            @($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Count | Should -Be 0
        }

        It 'Makes no edits when the module index has duplicate entries' {
            $script:moduleIndex += New-TestModule -Status 'Orphaned'
            { Invoke-TestReviewerRouting } | Should -Throw '*Multiple index entries*'
            @($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Count | Should -Be 0
        }

        It 'Surfaces failures when updating labels or reviewers' {
            $script:editExitCode = 1
            { Invoke-TestReviewerRouting } | Should -Throw '*Unable to update reviewer routing*'
        }
    }

    Context 'Failed-workflow notifications' {
        It 'Mentions both indexed owners and assigns the primary owner' {
            Invoke-TestFailureRouting
            $assignment = $script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }
            $assignment.Arguments | Should -Contain 'owner-one'
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@owner-one, @owner-two'
            ($comment.Arguments -join ' ') | Should -Not -Match 'module-owners|module-contributors'
        }

        It 'Notifies the tooling team for an orphaned module without assigning stale owners' {
            $script:moduleIndex[0].ModuleStatus = 'Orphaned'
            Invoke-TestFailureRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 0
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@Azure/azure-verified-modules-tooling-contributors'
        }

        It 'Preserves tooling-team notifications for platform workflows' {
            $script:workflowName = '.Platform - Example'
            Invoke-TestFailureRouting
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@Azure/azure-verified-modules-tooling-contributors'
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 0
        }

        It 'Inherits child-module notifications and primary-owner assignment' {
            $script:moduleIndex += New-TestModule -Name 'avm/res/storage/storage-account/blob-service' -Primary '' -Secondary '' -Parent 'avm/res/storage/storage-account'
            $script:workflowName = 'avm.res.storage.storage-account.blob-service'
            Invoke-TestFailureRouting
            ($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Arguments | Should -Contain 'owner-one'
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@owner-one, @owner-two'
        }

        It 'Does not create an issue when owner metadata cannot be resolved' {
            $script:moduleIndex = @(New-TestModule -Primary '' -Secondary '')
            { Invoke-TestFailureRouting } | Should -Throw '*No individual owners*'
            $script:ghCalls.Count | Should -Be 0
        }

        It 'Performs no GitHub writes under WhatIf' {
            Set-AvmGitHubIssueForWorkflow -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot -WhatIf
            $script:ghCalls.Count | Should -Be 0
        }
    }
}
