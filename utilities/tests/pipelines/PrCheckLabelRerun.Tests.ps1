param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
    $observerPath = Join-Path $workflowRoot 'platform.on-pull-request-observe-e2e-labels.yml'
    $handlerPath = Join-Path $workflowRoot 'platform.on-pr-label-observer-rerun.yml'
    $observerContent = Get-Content -LiteralPath $observerPath -Raw
    $handlerContent = Get-Content -LiteralPath $handlerPath -Raw
    $observer = $observerContent | ConvertFrom-Yaml
    $handler = $handlerContent | ConvertFrom-Yaml
    $observerJob = $observer.jobs.'observe-labels'
    $handlerJob = $handler.jobs.'rerun-pr-check'
    $prCheck = Get-Content -LiteralPath (Join-Path $workflowRoot 'pr-check.yml') -Raw | ConvertFrom-Yaml
}

Describe 'PR label observer consumer workflow' {
    It 'observes only same-repository label and unlabel events' {
        $observer.on.pull_request.types | Should -Be @('labeled', 'unlabeled')
        $observer.on.ContainsKey('pull_request_target') | Should -BeFalse
        $observer.on.pull_request.ContainsKey('paths') | Should -BeFalse
        $observer.permissions.Keys | Should -BeNullOrEmpty
        $observer.jobs.Keys | Should -Be @('observe-labels')
        $observerJob.if |
            Should -BeExactly 'github.event.pull_request.head.repo.full_name == github.repository'
        $observerJob.uses |
            Should -Match '^Azure/azure-verified-modules-tools/\.github/workflows/pr-check-label-observer\.yml@[0-9a-f]{40}$'
        $observerJob.ContainsKey('steps') | Should -BeFalse
    }

    It 'does not duplicate observer logic in BRM' {
        $observerContent.Contains('pull_request_target') | Should -BeFalse
        $observerContent.Contains('gh api') | Should -BeFalse
        $observerContent.Contains('actions/checkout') | Should -BeFalse
        $observerContent.Contains('GITHUB_TOKEN') | Should -BeFalse
    }
}

Describe 'PR label rerun handler consumer workflow' {
    It 'runs from the default branch only after the exact observer workflow completes' {
        $handler.on.workflow_run.workflows | Should -Be @($observer.name)
        $handler.on.workflow_run.types | Should -Be @('completed')
        $handler.on.ContainsKey('pull_request_target') | Should -BeFalse
        $handler.permissions.Keys | Should -BeNullOrEmpty
        $handler.jobs.Keys | Should -Be @('rerun-pr-check')
        $handlerJob.uses |
            Should -Match '^Azure/azure-verified-modules-tools/\.github/workflows/pr-check-label-rerun\.yml@[0-9a-f]{40}$'
        $handlerJob.ContainsKey('steps') | Should -BeFalse
    }

    It 'grants only the reusable handler permissions it needs' {
        $handlerJob.permissions.Keys | Sort-Object |
            Should -Be @('actions', 'contents', 'issues', 'pull-requests')
        $handlerJob.permissions.actions | Should -BeExactly 'write'
        $handlerJob.permissions.contents | Should -BeExactly 'read'
        $handlerJob.permissions.issues | Should -BeExactly 'read'
        $handlerJob.permissions.'pull-requests' | Should -BeExactly 'read'
    }

    It 'pins both shared workflows, nested tools and the observer path consistently' {
        $observerPin = ($observerJob.uses -split '@')[-1]
        $handlerPin = ($handlerJob.uses -split '@')[-1]
        $handlerJob.with.'tools-ref' | Should -BeExactly $handlerPin
        $handlerPin | Should -BeExactly $observerPin
        $handlerJob.with.'observer-workflow-path' |
            Should -BeExactly '.github/workflows/platform.on-pull-request-observe-e2e-labels.yml'
    }

    It 'does not duplicate handler logic in BRM' {
        $handlerContent.Contains('pull_request_target') | Should -BeFalse
        $handlerContent.Contains('gh api') | Should -BeFalse
        $handlerContent.Contains('actions/checkout') | Should -BeFalse
        $handlerContent.Contains('GITHUB_TOKEN') | Should -BeFalse
        Test-Path -LiteralPath (
            Join-Path $RepoRootPath '.github' 'scripts' 'Invoke-PrCheckRerun.ps1'
        ) | Should -BeFalse
    }

    It 'keeps label changes off the main PR-check trigger' {
        $prCheck.on.pull_request.types | Should -Be @('opened', 'reopened', 'synchronize')
    }
}
