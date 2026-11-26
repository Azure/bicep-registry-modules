param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    . (Join-Path $RepoRootPath '.github' 'scripts' 'Invoke-PrCheckRerun.ps1')

    $workflowPath = Join-Path $RepoRootPath '.github' 'workflows' 'platform.on-pull-request-rerun-e2e.yml'
    $workflowContent = Get-Content -LiteralPath $workflowPath -Raw
    $workflow = $workflowContent | ConvertFrom-Yaml
    $rerunJob = $workflow.jobs.'rerun-pr-check'
}

Describe 'PR label rerun workflow' {
    It 'reacts only to the two E2E labels with a trusted base checkout' {
        $workflow.on.pull_request_target.types | Should -Be @('labeled')
        $workflow.on.ContainsKey('pull_request') | Should -BeFalse
        $workflow.on.ContainsKey('workflow_dispatch') | Should -BeFalse
        $workflow.on.pull_request_target.ContainsKey('paths') | Should -BeFalse
        $rerunJob.if | Should -Match "'PR: Run Required E2E Tests'"
        $rerunJob.if | Should -Match "'PR: Run All E2E Tests'"

        $checkout = $rerunJob.steps | Where-Object uses -Like 'actions/checkout@*'
        $checkout.uses | Should -Match '^actions/checkout@[0-9a-f]{40}$'
        $checkout.with.ref | Should -BeExactly '${{ github.event.repository.default_branch }}'
        $checkout.with.'persist-credentials' | Should -BeFalse
        $rerunJob.steps[-1].env.GH_TOKEN | Should -BeExactly '${{ github.token }}'
    }

    It 'has only the permissions required to inspect and rerun Actions runs' {
        $rerunJob.permissions.Keys | Sort-Object | Should -Be @('actions', 'contents', 'pull-requests')
        $rerunJob.permissions.actions | Should -BeExactly 'write'
        $rerunJob.permissions.contents | Should -BeExactly 'read'
        $rerunJob.permissions.'pull-requests' | Should -BeExactly 'read'
        $workflow.permissions.Keys | Should -BeNullOrEmpty
        $workflowContent.Contains('/dispatches') | Should -BeFalse
        $workflowContent.Contains('workflow_dispatch') | Should -BeFalse
        $workflowContent.Contains('pull_request.head.repo') | Should -BeFalse
        $workflowContent.Contains('secrets: inherit') | Should -BeFalse
    }

    It 'serializes label events for the same pull request' {
        $workflow.concurrency.group | Should -BeExactly 'pr-check-label-${{ github.event.pull_request.number }}'
        $workflow.concurrency.'cancel-in-progress' | Should -BeFalse
    }

    It 'keeps label changes off the main PR-check trigger' {
        $prCheck = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw |
            ConvertFrom-Yaml
        $prCheck.on.pull_request.types | Should -Be @('opened', 'reopened', 'synchronize')
    }
}

Describe 'PR-check rerun selection' {
    BeforeEach {
        $script:headSha = ('a' * 40)
        $script:baseSha = ('b' * 40)
        $script:otherHeadSha = ('c' * 40)
        $script:pullRequest = [pscustomobject] @{
            head = [pscustomobject] @{
                sha  = $script:headSha
                ref  = 'feature'
                repo = [pscustomobject] @{ id = 10 }
            }
            base = [pscustomobject] @{
                sha  = $script:baseSha
                ref  = 'main'
                repo = [pscustomobject] @{ id = 10 }
            }
            labels = @([pscustomobject] @{ name = 'PR: Run Required E2E Tests' })
        }
        $script:dispatcher = [pscustomobject] @{
            event          = 'pull_request_target'
            run_started_at = '2026-11-26T10:00:00Z'
        }
        Mock Start-Sleep
    }

    It 'waits for every matching active run and reruns the newest completed run' {
        $script:poll = 0
        Mock Invoke-GitHubApi {
            param($Path, $Method)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            if ($Path -like '*/pulls/7') { return $script:pullRequest }
            if ($Method -eq 'POST') { return $null }
            $script:poll++
            $runs = @(
                [pscustomobject] @{
                    id            = 101
                    event         = 'pull_request'
                    path          = '.github/workflows/pr-check.yml'
                    head_sha      = $script:headSha
                    head_branch   = 'feature'
                    status        = if ($script:poll -eq 1) { 'in_progress' } else { 'completed' }
                    created_at    = '2026-11-26T09:00:00Z'
                    run_started_at = '2026-11-26T09:00:00Z'
                    pull_requests = @([pscustomobject] @{
                            number = 7
                            head   = $script:pullRequest.head
                            base   = $script:pullRequest.base
                        })
                }
                [pscustomobject] @{
                    id             = 102
                    event          = 'pull_request'
                    path           = '.github/workflows/pr-check.yml'
                    head_sha       = $script:headSha
                    head_branch    = 'feature'
                    status         = 'completed'
                    created_at     = '2026-11-26T09:30:00Z'
                    run_started_at = '2026-11-26T09:30:00Z'
                    pull_requests  = @([pscustomobject] @{
                            number = 7
                            head   = $script:pullRequest.head
                            base   = $script:pullRequest.base
                        })
                }
            )
            return [pscustomobject] @{ workflow_runs = $runs }
        }

        Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
            -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000 `
            -CompletionAttempts 2 -PollIntervalSeconds 0

        Assert-MockCalled Invoke-GitHubApi -Times 1 -ParameterFilter {
            $Method -eq 'POST' -and $Path -eq '/repos/Azure/bicep-registry-modules/actions/runs/102/rerun'
        }
        Assert-MockCalled Start-Sleep -Times 1
    }

    It 'does not rerun when a matching attempt already observed the label event' {
        Mock Invoke-GitHubApi {
            param($Path, $Method)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            if ($Path -like '*/pulls/7') { return $script:pullRequest }
            $run = [pscustomobject] @{
                id             = 201
                event          = 'pull_request'
                path           = '.github/workflows/pr-check.yml'
                head_sha       = $script:headSha
                head_branch    = 'feature'
                status         = 'in_progress'
                created_at     = '2026-11-26T10:00:01Z'
                run_started_at = '2026-11-26T10:00:01Z'
                pull_requests  = @([pscustomobject] @{
                        number = 7
                        head   = $script:pullRequest.head
                        base   = $script:pullRequest.base
                    })
            }
            return [pscustomobject] @{ workflow_runs = @($run) }
        }

        Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
            -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000

        Assert-MockCalled Invoke-GitHubApi -Times 0 -ParameterFilter { $Method -eq 'POST' }
        Assert-MockCalled Start-Sleep -Times 0
    }

    It 'waits for an older active run even when a newer attempt observed the label event' {
        $script:poll = 0
        Mock Invoke-GitHubApi {
            param($Path, $Method)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            if ($Path -like '*/pulls/7') { return $script:pullRequest }
            if ($Method -eq 'POST') { return $null }
            $script:poll++
            $runs = @(
                [pscustomobject] @{
                    id             = 301
                    event          = 'pull_request'
                    path           = '.github/workflows/pr-check.yml'
                    head_sha       = $script:headSha
                    head_branch    = 'feature'
                    status         = if ($script:poll -eq 1) { 'in_progress' } else { 'completed' }
                    created_at     = '2026-11-26T09:00:00Z'
                    run_started_at = '2026-11-26T09:00:00Z'
                    pull_requests  = @([pscustomobject] @{
                            number = 7
                            head   = $script:pullRequest.head
                            base   = $script:pullRequest.base
                        })
                }
                [pscustomobject] @{
                    id             = 302
                    event          = 'pull_request'
                    path           = '.github/workflows/pr-check.yml'
                    head_sha       = $script:headSha
                    head_branch    = 'feature'
                    status         = 'completed'
                    created_at     = '2026-11-26T10:00:01Z'
                    run_started_at = '2026-11-26T10:00:01Z'
                    pull_requests  = @([pscustomobject] @{
                            number = 7
                            head   = $script:pullRequest.head
                            base   = $script:pullRequest.base
                        })
                }
            )
            return [pscustomobject] @{ workflow_runs = $runs }
        }

        Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
            -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000 `
            -CompletionAttempts 2 -PollIntervalSeconds 0

        Assert-MockCalled Invoke-GitHubApi -Times 0 -ParameterFilter { $Method -eq 'POST' }
        Assert-MockCalled Start-Sleep -Times 1
    }

    It 'leaves a moved head to its synchronize run' {
        Mock Invoke-GitHubApi {
            param($Path)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            $moved = $script:pullRequest.PSObject.Copy()
            $moved.head = [pscustomobject] @{
                sha  = $script:otherHeadSha
                ref  = $script:pullRequest.head.ref
                repo = $script:pullRequest.head.repo
            }
            return $moved
        }

        Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
            -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000

        Assert-MockCalled Invoke-GitHubApi -Times 0 -ParameterFilter { $Method -eq 'POST' }
    }

    It 'fails closed when no run has the current head, base, repository and PR association' {
        Mock Invoke-GitHubApi {
            param($Path)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            if ($Path -like '*/pulls/7') { return $script:pullRequest }
            return [pscustomobject] @{ workflow_runs = @() }
        }

        {
            Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
                -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000 `
                -UnavailableAttempts 1 -PollIntervalSeconds 0
        } | Should -Throw '*No PR-check run matched*'

        Assert-MockCalled Invoke-GitHubApi -Times 0 -ParameterFilter { $Method -eq 'POST' }
    }

    It 'fails closed if the base changes before rerun' {
        Mock Invoke-GitHubApi {
            param($Path)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            $moved = $script:pullRequest.PSObject.Copy()
            $moved.base = [pscustomobject] @{
                sha  = ('d' * 40)
                ref  = $script:pullRequest.base.ref
                repo = $script:pullRequest.base.repo
            }
            return $moved
        }

        {
            Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
                -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000
        } | Should -Throw '*base changed*'
    }

    It 'does not rerun fork PRs with a privileged label workflow' {
        Mock Invoke-GitHubApi {
            param($Path)
            if ($Path -like '*/actions/runs/9000') { return $script:dispatcher }
            $fork = $script:pullRequest.PSObject.Copy()
            $fork.head = [pscustomobject] @{
                sha  = $script:pullRequest.head.sha
                ref  = $script:pullRequest.head.ref
                repo = [pscustomobject] @{ id = 30 }
            }
            return $fork
        }

        {
            Invoke-PrCheckRerun -Repository 'Azure/bicep-registry-modules' -PullRequestNumber 7 `
                -ExpectedHeadSha $script:headSha -ExpectedBaseSha $script:baseSha -DispatcherRunId 9000
        } | Should -Throw '*is from a fork*'

        Assert-MockCalled Invoke-GitHubApi -Times 0 -ParameterFilter { $Method -eq 'POST' }
    }
}
