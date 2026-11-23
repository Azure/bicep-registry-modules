param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $prCheckContent = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw
    $releaseContent = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'release.yml') -Raw
    $prCheck = $prCheckContent | ConvertFrom-Yaml
    $release = $releaseContent | ConvertFrom-Yaml
    $moduleGate = $prCheck.jobs.'module-gate'
    $reportStep = $moduleGate.steps[0]
}

Describe 'Bicep PR check reporter caller contract' {
    It 'uses the shared reporter with normalized input values' {
        $moduleGate.steps | Should -HaveCount 1
        $reportStep.uses |
            Should -Match '^Azure/azure-verified-modules-tools/\.github/actions/report-check-status@[0-9a-f]{40}$'
        $reportStep.with.ecosystem | Should -BeExactly 'bicep'
        $reportStep.with.results | Should -BeExactly '${{ toJSON(needs) }}'
        $reportStep.with.'require-e2e' |
            Should -BeExactly '${{ github.event_name == ''pull_request'' || inputs.runE2E }}'
        $reportStep.with.ContainsKey('token') | Should -BeFalse
    }

    It 'forwards initializer selection state to the reporter' {
        $outputs = $prCheck.jobs.initialize.outputs
        foreach ($name in @('hasRequiredModules', 'requiredRequested', 'requiredErrors',
                'hasOptionalModules', 'optionalRequested')) {
            $outputs[$name] | Should -BeExactly "`${{ steps.initialize.outputs.$name }}"
        }
    }

    It 'keeps the reporter behind a least-privilege trust boundary' {
        $moduleGate.name | Should -BeExactly 'Report check status'
        $moduleGate.if | Should -BeExactly 'always()'
        $moduleGate.needs | Should -Be @('initialize', 'check')
        $moduleGate.permissions.Keys | Should -Be @('pull-requests')
        $moduleGate.permissions.'pull-requests' | Should -BeExactly 'write'
        $moduleGate.ContainsKey('env') | Should -BeFalse
        @($moduleGate.steps | Where-Object { $_.ContainsKey('run') }) | Should -BeNullOrEmpty
        @($moduleGate.steps | Where-Object { $_.uses -like 'actions/checkout@*' }) | Should -BeNullOrEmpty
        @($moduleGate.steps | Where-Object { $_.uses -like 'actions/github-script@*' }) | Should -BeNullOrEmpty
        $prCheckContent.Contains('pull_request_target') | Should -BeFalse
    }

    It 'pins PR, release and workflow support to one immutable Tools revision' {
        $references = @(
            $prCheck.jobs.initialize.steps[0].uses
            $prCheck.jobs.check.uses
            $moduleGate.steps[0].uses
            $release.jobs.initialize.uses
            $release.jobs.release.uses
        )
        $references | Should -HaveCount 5
        $pins = @($references | ForEach-Object {
                $_ | Should -Match '^Azure/azure-verified-modules-tools/.+@[0-9a-f]{40}$'
                ($_ -split '@')[-1]
            } | Select-Object -Unique)
        $pins | Should -HaveCount 1
        $prCheck.jobs.check.with.'tools-ref' | Should -BeExactly $pins[0]
    }
}
