param(
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflow = Get-Content -Raw (Join-Path $RepoRootPath '.github' 'workflows' 'pr-fork-e2e-feedback.yml') | ConvertFrom-Yaml
    $job = $workflow.jobs.feedback
    $script:report = [scriptblock]::Create($job.steps[0].run)

    function gh {
        $script:calls.Add(@($args))
        $global:LASTEXITCODE = 0
        $endpoint = @($args | Where-Object { $_ -like 'repos/*' })[0]
        if ($args -contains 'POST' -or $args -contains 'PATCH') { return '{}' }
        $data = switch -Wildcard ($endpoint) {
            '*/actions/runs/*/jobs?*' { @(@{ jobs = @(@{ id = 12; name = 'Report check status'; conclusion = 'failure' }) }) }
            '*/check-runs/*/annotations?*' { ,@($script:annotations) }
            '*/pulls?*' { ,@($script:pulls) }
            '*/issues/*/comments?*' { ,@($script:comments) }
            '*/pulls/*' { $script:current }
            default { throw "Unexpected API request: $endpoint" }
        }
        ConvertTo-Json -InputObject $data -Depth 20 -Compress
    }
}

Describe 'Fork E2E feedback' {
    BeforeEach {
        $script:saved = @{}
        foreach ($name in @('GITHUB_EVENT_PATH', 'GITHUB_REPOSITORY', 'GITHUB_SERVER_URL')) {
            $script:saved[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
        }
        $env:GITHUB_REPOSITORY = 'Azure/bicep-registry-modules'
        $env:GITHUB_SERVER_URL = 'https://github.com'
        $env:GITHUB_EVENT_PATH = Join-Path $TestDrive 'event.json'
        $script:run = @{ id = 123; head_sha = 'abc'; head_branch = 'feature'; head_repository = @{ full_name = 'fork/repo' } }
        @{ workflow_run = $script:run } | ConvertTo-Json -Depth 10 | Set-Content $env:GITHUB_EVENT_PATH
        $script:annotations = @(@{ annotation_level = 'failure'; message = 'Required E2E tests must run and pass before merging. Details.' })
        $script:current = @{ number = 42; state = 'open'; base = @{ ref = 'main' }; head = @{ sha = 'abc'; repo = @{ full_name = 'fork/repo' } } }
        $script:pulls = @((ConvertTo-Json -InputObject $script:current -Depth 10 | ConvertFrom-Json -AsHashtable))
        $script:comments = @()
        $script:calls = [Collections.Generic.List[object]]::new()
    }

    AfterEach {
        foreach ($name in $script:saved.Keys) {
            [Environment]::SetEnvironmentVariable($name, $(if ($null -eq $script:saved[$name]) { [NullString]::Value } else { $script:saved[$name] }), 'Process')
        }
    }

    It 'uses a trusted completed-run workflow with only the permissions needed to report' {
        $workflow.on.workflow_run.workflows | Should -Contain '.Module - PR Check'
        $job.permissions.actions | Should -BeExactly 'read'
        $job.permissions.checks | Should -BeExactly 'read'
        $job.permissions.'pull-requests' | Should -BeExactly 'write'
        @($job.steps | Where-Object { $_.uses -like 'actions/checkout@*' }) | Should -BeNullOrEmpty
    }

    It 'posts a handoff comment for a failed required E2E gate on the matching fork head' {
        & $script:report
        $write = @($script:calls | Where-Object { $_ -contains 'POST' })
        $write | Should -HaveCount 1
        ($write[0] -join ' ') | Should -Match 'issues/42/comments'
        ($write[0] -join ' ') | Should -Match 'cannot run with credentials from a fork'
        ($write[0] -join ' ') | Should -Match 'release-branch handoff process'
    }

    It 'does not comment for unrelated gate failures or stale heads' -ForEach @(
        @{ Case = 'unrelated' }, @{ Case = 'stale' }, @{ Case = 'retargeted' }
    ) {
        if ($Case -ceq 'unrelated') { $script:annotations[0].message = 'Another check failed.' }
        if ($Case -ceq 'stale') { $script:current.head.sha = 'new' }
        if ($Case -ceq 'retargeted') { $script:current.base.ref = 'release/fork' }
        & $script:report
        @($script:calls | Where-Object { $_ -contains 'POST' -or $_ -contains 'PATCH' }) | Should -HaveCount 0
    }

    It 'updates only an existing bot-owned handoff comment' {
        $script:comments = @(
            @{ id = 3; user = @{ login = 'contributor' }; body = '<!-- avm-bicep-fork-e2e-feedback -->' }
            @{ id = 4; user = @{ login = 'github-actions[bot]' }; body = '<!-- avm-bicep-fork-e2e-feedback --> old' }
        )
        & $script:report
        $write = @($script:calls | Where-Object { $_ -contains 'PATCH' })
        $write | Should -HaveCount 1
        ($write[0] -join ' ') | Should -Match 'issues/comments/4'
    }

    It 'does not inspect or comment on same-repository runs' {
        $script:run.head_repository.full_name = $env:GITHUB_REPOSITORY
        @{ workflow_run = $script:run } | ConvertTo-Json -Depth 10 | Set-Content $env:GITHUB_EVENT_PATH
        & $script:report
        $script:calls | Should -HaveCount 0
    }
}
