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
            'Get-AvmModuleMetadataOwner', 'Get-AvmModuleList', 'Get-GitHubIssueList',
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

        function Invoke-TestIssueRouting {
            Set-AvmGitHubIssueOwnerConfig -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot
        }

        function Invoke-TestReviewerRouting {
            Set-AvmGitHubPrLabels -Repo 'test-org/test-repo' -PrUrl 'https://github.com/test-org/test-repo/pull/42' -RepoRoot $script:mockRepoRoot
        }

        function Set-TestModuleMetadata {
            param (
                [string] $ModulePath = 'avm/res/storage/storage-account',
                [object[]] $Owners = @('owner-one', 'owner-two'),
                [switch] $HeadOnly
            )
            if ($HeadOnly) {
                $script:headMetadata["$ModulePath/metadata.json"] = @{ owners = $Owners } | ConvertTo-Json -Depth 5
                return
            }
            $moduleFolderPath = Join-Path $script:mockRepoRoot ($ModulePath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
            $null = New-Item -Path $moduleFolderPath -ItemType Directory -Force
            @{ owners = $Owners } | ConvertTo-Json -Depth 5 | Set-Content -Path (Join-Path $moduleFolderPath 'metadata.json')
        }

        function Remove-TestModuleMetadata {
            $moduleTreePath = Join-Path $script:mockRepoRoot 'avm'
            if (Test-Path -Path $moduleTreePath) {
                Remove-Item -Path $moduleTreePath -Recurse -Force
            }
        }

        function Invoke-TestFailureRouting {
            Set-AvmGitHubIssueForWorkflow -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot
        }
    }

    BeforeEach {
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
            reviews        = @()
            headRefOid     = '0f1e2d3c4b5a69788796a5b4c3d2e1f00f1e2d3c'
        }
        $script:changedFiles = @('avm/res/storage/storage-account/main.bicep')
        $script:headMetadata = @{}
        Remove-TestModuleMetadata
        Set-TestModuleMetadata
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

        Mock Invoke-WebRequest { throw 'Unexpected web request.' }
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
            if ($args[0] -eq 'api' -and ($args[1] -match '^repos/(.+)/contents/(.+)\?ref=(.+)$')) {
                $sourceRepo, $metadataPath, $sourceRef = $matches[1], $matches[2], $matches[3]
                if ($sourceRepo -ne 'test-org/test-repo' -or $sourceRef -ne $script:pr.headRefOid) {
                    throw "Unexpected metadata source [$sourceRepo@$sourceRef]."
                }
                if (-not $script:headMetadata.ContainsKey($metadataPath)) {
                    $global:LASTEXITCODE = 1
                    return $null
                }
                return $script:headMetadata[$metadataPath]
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

    Context 'Metadata owner resolution' {
        It 'Resolves the owners declared in metadata.json' {
            Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $script:mockRepoRoot |
                Should -Be @('owner-one', 'owner-two')
        }

        It 'Normalizes team handles and removes duplicates' {
            Set-TestModuleMetadata -Owners @('@Azure/module-owners', 'owner-one', 'owner-one')
            Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $script:mockRepoRoot |
                Should -Be @('Azure/module-owners', 'owner-one')
        }

        It 'Inherits ownership from the parent module' {
            $childPath = 'avm/res/storage/storage-account/blob-service/container'
            Set-TestModuleMetadata -ModulePath $childPath -Owners @()
            Get-AvmModuleMetadataOwner -ModulePath $childPath -RepoRoot $script:mockRepoRoot |
                Should -Be @('owner-one', 'owner-two')
        }

        It 'Uses explicitly declared child owners instead of the parent owners' {
            $childPath = 'avm/res/storage/storage-account/blob-service'
            Set-TestModuleMetadata -ModulePath $childPath -Owners @('child-owner')
            Get-AvmModuleMetadataOwner -ModulePath $childPath -RepoRoot $script:mockRepoRoot |
                Should -Be @('child-owner')
        }

        It 'Returns no owners for an orphaned module' {
            Set-TestModuleMetadata -Owners @()
            @(Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $script:mockRepoRoot).Count | Should -Be 0
        }

        It 'Returns no owners when the parent metadata is missing' {
            Remove-TestModuleMetadata
            @(Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $script:mockRepoRoot).Count | Should -Be 0
        }

        It 'Rejects invalid owner handle [<Handle>]' -ForEach @(
            @{ Handle = 'Azure/team-name' }
            @{ Handle = 'two owners' }
            @{ Handle = '--all' }
            @{ Handle = '@@owner-one' }
            @{ Handle = 'invalid--owner' }
        ) {
            Set-TestModuleMetadata -Owners @($Handle)
            { Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $script:mockRepoRoot } |
                Should -Throw '*Invalid owner handle*'
        }

        It 'Rejects an invalid module path [<Path>]' -ForEach @(
            @{ Path = 'avm/res/storage' }
            @{ Path = 'utilities/pipelines' }
            @{ Path = 'avm/bad/storage/storage-account' }
        ) {
            { Get-AvmModuleMetadataOwner -ModulePath $Path -RepoRoot $script:mockRepoRoot } |
                Should -Throw '*Invalid module path*'
        }

        It 'Rejects metadata that is not valid JSON' {
            $modulePath = Join-Path $script:mockRepoRoot 'avm' 'res' 'storage' 'storage-account' 'metadata.json'
            'not json' | Set-Content -Path $modulePath
            { Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $script:mockRepoRoot } |
                Should -Throw '*Unable to read module metadata*'
        }
    }

    Context 'Module listing' {
        It 'Lists only top-level module folders' {
            Set-TestModuleMetadata -ModulePath 'avm/res/storage/storage-account/blob-service' -Owners @()
            Set-TestModuleMetadata -ModulePath 'avm/ptn/authorization/role-assignment'
            Get-AvmModuleList -RepoRoot $script:mockRepoRoot |
                Should -Be @('avm/ptn/authorization/role-assignment', 'avm/res/storage/storage-account')
        }

        It 'Restricts the result to a single module type' {
            Set-TestModuleMetadata -ModulePath 'avm/ptn/authorization/role-assignment'
            Get-AvmModuleList -RepoRoot $script:mockRepoRoot -ModuleType 'res' |
                Should -Be @('avm/res/storage/storage-account')
        }

        It 'Returns nothing for a module type that has no modules' {
            @(Get-AvmModuleList -RepoRoot $script:mockRepoRoot -ModuleType 'utl').Count | Should -Be 0
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

        It 'Makes no updates when owner metadata cannot be read' {
            Set-TestModuleMetadata -Owners @('invalid--owner')
            $script:issues[0].assignees = @(@{ login = 'owner-one' })
            Set-AvmGitHubIssueOwnerConfig -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot -WarningVariable warnings
            $script:ghCalls.Count | Should -Be 0
            ($warnings -join ' ') | Should -Match 'preserving existing assignees'
        }

        It 'Mentions owning teams without attempting to assign them' {
            Set-TestModuleMetadata -Owners @('@Azure/storage-owners')
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 0
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@Azure/storage-owners'
            ($comment.Arguments -join ' ') | Should -Not -Match 'currently orphaned'
        }

        It 'Preserves existing assignees for an unknown module' {
            $script:issues[0].body = "### Module`navm/res/unknown/module`n"
            $script:issues[0].assignees = @(@{ login = 'owner-one' })
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--remove-assignee' }).Count | Should -Be 0
        }

        It 'Resolves child issue owners from the parent metadata' {
            $childName = 'avm/res/storage/storage-account/blob-service'
            Set-TestModuleMetadata -ModulePath $childName -Owners @()
            $script:issues[0].body = "### Module`n$childName`n"
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 2
        }

        It 'Notifies the tooling team when a child inherits an orphaned parent' {
            Set-TestModuleMetadata -Owners @()
            $childName = 'avm/res/storage/storage-account/blob-service'
            Set-TestModuleMetadata -ModulePath $childName -Owners @()
            $script:issues[0].body = "### Module`n$childName`n"
            Invoke-TestIssueRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 0
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@Azure/azure-verified-modules-tooling-contributors'
        }

        It 'Does not reuse owners from the previous issue when processing an orphan' {
            Set-TestModuleMetadata -ModulePath 'avm/res/network/virtual-network' -Owners @()
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
        It 'Requests the owners declared in metadata.json' {
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[0] -eq 'pr' -and $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Module Owner :mega:'
            $edit.Arguments | Should -Contain 'owner-one,owner-two'
            ($script:ghCalls.Arguments -join ' ') | Should -Not -Match '/teams/'
            ($script:ghCalls | Where-Object { $_.Arguments[0] -eq 'api' }).Arguments | Should -Contain '--paginate'
            Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        }

        It 'Requests team handles declared in metadata.json' {
            Set-TestModuleMetadata -Owners @('owner-one', '@Azure/example-team')
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'Azure/example-team,owner-one'
        }

        It 'Requests the other owner instead of the author' {
            $script:pr.author.login = 'owner-one'
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

        It 'Does not duplicate an existing team review request' {
            Set-TestModuleMetadata -Owners @('@Azure/example-team')
            $script:pr.reviewRequests += @{ slug = 'example-team' }
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Not -Contain '--add-reviewer'
        }

        It 'Does not re-request an owner who already reviewed' {
            $script:pr.reviews = @(@{ author = @{ login = 'owner-one' }; state = 'APPROVED' })
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'owner-two'
            $edit.Arguments | Should -Not -Contain 'owner-one,owner-two'
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

        It 'Labels tooling changes and protected files for the core team [<Path>]' -ForEach @(
            @{ Path = 'utilities/tools/example.ps1' }
            @{ Path = 'avm/res/storage/storage-account/tests/unit/avm.core.team.tests.ps1' }
            @{ Path = 'avm/res/storage/storage-account/tests/e2e/defaults/.e2eignore' }
            @{ Path = 'avm/README.md' }
        ) {
            $script:changedFiles += $Path
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Core Team :genie:'
            $edit.Arguments | Should -Contain 'owner-one,owner-two'
        }

        It 'Notifies the owners of every changed module, including rename source paths' {
            Set-TestModuleMetadata -ModulePath 'avm/res/network/virtual-network' -Owners @('network-owner')
            $script:changedFiles += 'avm/res/network/virtual-network/main.bicep'
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Module Owner :mega:'
            $edit.Arguments | Should -Contain 'network-owner,owner-one,owner-two'
            ($script:ghCalls | Where-Object { $_.Arguments[0] -eq 'api' }).Arguments | Should -Contain '.[] | .filename, (.previous_filename // empty)'
        }

        It 'Falls back to the module owners team and adds the orphan label when <Reason>' -ForEach @(
            @{ Reason = 'no owners are declared'; Owners = @() }
            @{ Reason = 'the module has no metadata'; Owners = $null }
        ) {
            if ($null -eq $Owners) {
                Remove-TestModuleMetadata
            } else {
                Set-TestModuleMetadata -Owners $Owners
            }
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'Needs: Core Team :genie:'
            $edit.Arguments | Should -Contain 'Status: Module Orphaned :yellow_circle:'
            $edit.Arguments | Should -Contain 'Azure/azure-verified-modules-module-owners'
        }

        It 'Maps child-module files to the inherited top-level module owners' {
            $script:changedFiles = @('avm/res/storage/storage-account/blob-service/container/main.bicep')
            Set-TestModuleMetadata -ModulePath 'avm/res/storage/storage-account/blob-service/container' -Owners @()
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'owner-one,owner-two'
            $edit.Arguments | Should -Not -Contain 'Status: Module Orphaned :yellow_circle:'
        }

        It 'Resolves owners of a module added by the pull request from the head commit' {
            Remove-TestModuleMetadata
            $script:changedFiles = @('avm/res/example/new-module/main.bicep')
            Set-TestModuleMetadata -ModulePath 'avm/res/example/new-module' -Owners @('new-owner') -HeadOnly
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'new-owner'
            $edit.Arguments | Should -Not -Contain 'Status: Module Orphaned :yellow_circle:'
        }

        It 'Reads head metadata through the base repository so the app installation token has access' {
            Set-TestModuleMetadata -Owners @('updated-owner') -HeadOnly
            Invoke-TestReviewerRouting
            $contentsCall = $script:ghCalls | Where-Object { $_.Arguments[0] -eq 'api' -and $_.Arguments[1] -like 'repos/*/contents/*' } | Select-Object -First 1
            $contentsCall.Arguments[1] | Should -BeLike 'repos/test-org/test-repo/contents/*'
        }

        It 'Prefers head metadata over the checked-out base copy' {
            Set-TestModuleMetadata -Owners @('updated-owner') -HeadOnly
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'updated-owner'
            $edit.Arguments | Should -Not -Contain 'owner-one,owner-two'
        }

        It 'Falls back to the checked-out base copy when the head lookup fails' {
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'owner-one,owner-two'
            ($script:ghCalls | Where-Object { $_.Arguments[0] -eq 'api' -and $_.Arguments[1] -like 'repos/*/contents/*' }).Count | Should -BeGreaterThan 0
        }

        It 'Reads metadata from the base copy only when the head commit is unknown' {
            $script:pr.headRefOid = ''
            Set-TestModuleMetadata -Owners @('head-owner') -HeadOnly
            Invoke-TestReviewerRouting
            $edit = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }
            $edit.Arguments | Should -Contain 'owner-one,owner-two'
            @($script:ghCalls | Where-Object { $_.Arguments[1] -like 'repos/*/contents/*' }).Count | Should -Be 0
        }

        It 'Never checks out or executes pull request head content' {
            Invoke-TestReviewerRouting
            $invokedCommands = ($script:ghCalls.Arguments | ForEach-Object { $_ }) -join ' '
            $invokedCommands | Should -Not -Match 'checkout|clone|\bfetch\b'
        }

        It 'Resolves owners for [<ModulePath>]' -ForEach @(
            @{ ModulePath = 'avm/ptn/example/pattern' }
            @{ ModulePath = 'avm/utl/example/utility' }
        ) {
            Set-TestModuleMetadata -ModulePath $ModulePath
            $script:changedFiles = @("$ModulePath/main.bicep")
            Invoke-TestReviewerRouting
            ($script:ghCalls | Where-Object { $_.Arguments[1] -eq 'edit' }).Arguments | Should -Contain 'owner-one,owner-two'
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

        It 'Makes no edits when an owner handle is invalid' {
            Set-TestModuleMetadata -Owners @('invalid owner')
            { Invoke-TestReviewerRouting } | Should -Throw '*Invalid owner handle*'
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
            Set-TestModuleMetadata -Owners @()
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
            Set-TestModuleMetadata -ModulePath 'avm/res/storage/storage-account/blob-service' -Owners @()
            $script:workflowName = 'avm.res.storage.storage-account.blob-service'
            Invoke-TestFailureRouting
            ($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Arguments | Should -Contain 'owner-one'
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@owner-one, @owner-two'
        }

        It 'Mentions an owning team without attempting to assign it' {
            Set-TestModuleMetadata -Owners @('@Azure/storage-owners')
            Invoke-TestFailureRouting
            @($script:ghCalls | Where-Object { $_.Arguments -contains '--add-assignee' }).Count | Should -Be 0
            $comment = $script:ghCalls | Where-Object { $_.Arguments[1] -eq 'comment' }
            ($comment.Arguments -join ' ') | Should -Match '@Azure/storage-owners'
            ($comment.Arguments -join ' ') | Should -Not -Match 'tooling-contributors'
        }

        It 'Does not create an issue when owner metadata cannot be read' {
            Set-TestModuleMetadata -Owners @('invalid--owner')
            { Invoke-TestFailureRouting } | Should -Throw '*Invalid owner handle*'
            $script:ghCalls.Count | Should -Be 0
        }

        It 'Performs no GitHub writes under WhatIf' {
            Set-AvmGitHubIssueForWorkflow -RepositoryOwner 'test-org' -RepositoryName 'test-repo' -RepoRoot $script:mockRepoRoot -WhatIf
            $script:ghCalls.Count | Should -Be 0
        }
    }
}
