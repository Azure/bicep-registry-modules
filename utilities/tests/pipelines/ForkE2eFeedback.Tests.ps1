param(
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflow = Get-Content -Raw (Join-Path $RepoRootPath '.github' 'workflows' 'pr-fork-e2e-feedback.yml') | ConvertFrom-Yaml
    $job = $workflow.jobs.feedback
}

Describe 'Fork E2E feedback workflow' {
    It 'uses a trusted completed-run workflow with least-privilege permissions' {
        $workflow.on.workflow_run.workflows | Should -Contain '.Module - PR Check'
        $workflow.on.workflow_run.types | Should -Contain 'completed'
        $job.if | Should -Match "workflow_run.event == 'pull_request'.*workflow_run.conclusion == 'failure'"
        $job.permissions.actions | Should -BeExactly 'read'
        $job.permissions.checks | Should -BeExactly 'read'
        $job.permissions.'pull-requests' | Should -BeExactly 'write'
        @($job.steps | Where-Object { $_.uses -like 'actions/checkout@*' -or $_.ContainsKey('run') }) | Should -BeNullOrEmpty
    }

    It 'delegates fork feedback to the shared Tools reporter' {
        $job.steps | Should -HaveCount 1
        $job.steps[0].uses | Should -Match '^Azure/azure-verified-modules-tools/\.github/actions/report-check-status@[0-9a-f]{40}$'
        $job.steps[0].with.ecosystem | Should -BeExactly 'bicep'
        $job.steps[0].with.results | Should -BeExactly '{}'
        $job.steps[0].with.'fork-run' | Should -BeExactly 'true'
    }
}
