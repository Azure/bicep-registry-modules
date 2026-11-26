param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflowContent = Get-Content -LiteralPath (
        Join-Path $RepoRootPath '.github' 'workflows' 'platform.on-pull-request-rerun-e2e.yml'
    ) -Raw
    $workflow = $workflowContent | ConvertFrom-Yaml
    $rerunJob = $workflow.jobs.'rerun-pr-check'
    $prCheck = Get-Content -LiteralPath (
        Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml'
    ) -Raw | ConvertFrom-Yaml
}

Describe 'PR label rerun consumer workflow' {
    It 'wires only pull request label events to the shared rerun workflow' {
        $workflow.on.pull_request_target.types | Should -Be @('labeled', 'unlabeled')
        $workflow.on.ContainsKey('pull_request') | Should -BeFalse
        $workflow.on.ContainsKey('workflow_dispatch') | Should -BeFalse
        $workflow.on.pull_request_target.ContainsKey('paths') | Should -BeFalse
        $workflow.jobs.Keys | Should -Be @('rerun-pr-check')
        $rerunJob.uses |
            Should -Match '^Azure/azure-verified-modules-tools/\.github/workflows/pr-check-label-rerun\.yml@[0-9a-f]{40}$'
        $rerunJob.ContainsKey('if') | Should -BeFalse
        $rerunJob.ContainsKey('steps') | Should -BeFalse
    }

    It 'grants only the reusable workflow permissions it needs' {
        $workflow.permissions.Keys | Should -BeNullOrEmpty
        $rerunJob.permissions.Keys | Sort-Object |
            Should -Be @('actions', 'contents', 'issues', 'pull-requests')
        $rerunJob.permissions.actions | Should -BeExactly 'write'
        $rerunJob.permissions.contents | Should -BeExactly 'read'
        $rerunJob.permissions.issues | Should -BeExactly 'read'
        $rerunJob.permissions.'pull-requests' | Should -BeExactly 'read'
    }

    It 'pins the reusable workflow and nested Tools checkout to the same revision' {
        $rerunPin = ($rerunJob.uses -split '@')[-1]
        $rerunJob.with.'tools-ref' | Should -BeExactly $rerunPin
        $rerunPin | Should -Match '^[0-9a-f]{40}$'
    }

    It 'does not duplicate shared rerun implementation in BRM' {
        $workflow.ContainsKey('concurrency') | Should -BeFalse
        $workflowContent.Contains('gh api') | Should -BeFalse
        $workflowContent.Contains('actions/checkout') | Should -BeFalse
        $workflowContent.Contains('GITHUB_TOKEN') | Should -BeFalse
        Test-Path -LiteralPath (
            Join-Path $RepoRootPath '.github' 'scripts' 'Invoke-PrCheckRerun.ps1'
        ) | Should -BeFalse
    }

    It 'keeps label changes off the main PR-check trigger' {
        $prCheck.on.pull_request.types | Should -Be @('opened', 'reopened', 'synchronize')
    }
}
