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
    It 'only requests resource retention for manual E2E runs that opt in' {
        $inputs = $prCheck.on.workflow_dispatch.inputs
        $inputs.keepResources.type | Should -BeExactly 'boolean'
        $inputs.keepResources.default | Should -BeFalse
        $inputs.runE2E.default | Should -BeFalse
        $prCheck.jobs.initialize.steps[0].with.keepResources |
            Should -BeExactly '${{ github.event_name == ''workflow_dispatch'' && inputs.runE2E && inputs.keepResources && ''true'' || ''false'' }}'
    }

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
        $moduleGate.needs | Should -Be @('initialize', 'check', 'check-fork')
        $moduleGate.permissions.Keys | Should -Be @('pull-requests')
        $moduleGate.permissions.'pull-requests' | Should -BeExactly 'write'
        $moduleGate.ContainsKey('env') | Should -BeFalse
        @($moduleGate.steps | Where-Object { $_.ContainsKey('run') }) | Should -BeNullOrEmpty
        @($moduleGate.steps | Where-Object { $_.uses -like 'actions/checkout@*' }) | Should -BeNullOrEmpty
        @($moduleGate.steps | Where-Object { $_.uses -like 'actions/github-script@*' }) | Should -BeNullOrEmpty
        $prCheckContent.Contains('pull_request_target') | Should -BeFalse
    }

    It 'forwards manual fork secrets without dropping inherited upstream secrets' {
        $upstreamCheck = $prCheck.jobs.check
        $forkCheck = $prCheck.jobs.'check-fork'
        $upstreamCheck.if | Should -BeExactly "needs.initialize.outputs.hasModules == 'true' && !(github.event_name == 'workflow_dispatch' && github.event.repository.fork)"
        $upstreamCheck.secrets | Should -BeExactly 'inherit'
        $forkCheck.if | Should -BeExactly "needs.initialize.outputs.hasModules == 'true' && github.event_name == 'workflow_dispatch' && github.event.repository.fork"
        $forkCheck.needs | Should -BeExactly 'initialize'
        @($forkCheck.permissions.Keys | Sort-Object) | Should -Be @('contents', 'id-token')
        $forkCheck.permissions.contents | Should -BeExactly 'read'
        $forkCheck.permissions.'id-token' | Should -BeExactly 'write'
        $forkCheck.strategy.'fail-fast' | Should -BeFalse
        $forkCheck.strategy.matrix | Should -BeExactly $upstreamCheck.strategy.matrix
        $forkCheck.uses | Should -BeExactly $upstreamCheck.uses
        $forkCheck.with.Count | Should -Be $upstreamCheck.with.Count
        foreach ($name in $upstreamCheck.with.Keys) {
            $forkCheck.with[$name] | Should -BeExactly $upstreamCheck.with[$name]
        }

        $secretNames = @(
            'ARM_CLIENT_ID_OVERRIDE', 'ARM_TENANT_ID_OVERRIDE', 'ARM_SUBSCRIPTION_ID_OVERRIDE',
            'VALIDATE_SUBSCRIPTION_IDS', 'TEST_SUBSCRIPTION_IDS', 'VALIDATE_SUBSCRIPTION_ID',
            'VALIDATE_TENANT_ID', 'VALIDATE_MANAGEMENT_GROUP_ID', 'ARM_MGMTGROUP_ID', 'TOKEN_NAMEPREFIX'
        )
        @($forkCheck.secrets.Keys | Sort-Object) | Should -Be @($secretNames | Sort-Object)
        foreach ($name in $secretNames) {
            $forkCheck.secrets[$name] | Should -BeExactly "`${{ secrets.$name }}"
            $prCheck.on.workflow_dispatch.inputs.ContainsKey($name) | Should -BeFalse
        }
    }

    It 'pins PR, release and workflow support to one immutable Tools revision' {
        $references = @(
            $prCheck.jobs.initialize.steps[0].uses
            $prCheck.jobs.check.uses
            $prCheck.jobs.'check-fork'.uses
            $moduleGate.steps[0].uses
            $release.jobs.initialize.uses
            $release.jobs.release.uses
        )
        $references | Should -HaveCount 6
        $pins = @($references | ForEach-Object {
                $_ | Should -Match '^Azure/azure-verified-modules-tools/.+@[0-9a-f]{40}$'
                ($_ -split '@')[-1]
            } | Select-Object -Unique)
        $pins | Should -HaveCount 1
        $prCheck.jobs.check.with.'tools-ref' | Should -BeExactly $pins[0]
        $prCheck.jobs.'check-fork'.with.'tools-ref' | Should -BeExactly $pins[0]
    }
}
