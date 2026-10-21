param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'Coordinated reserved subscription history maintenance' {
    BeforeAll {
        Import-Module powershell-yaml -ErrorAction Stop
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $history = Get-Content (Join-Path $workflowRoot 'platform.deployment.history.cleanup.yml') -Raw | ConvertFrom-Yaml
        $reservedJob = $history.jobs.job_cleanup_reserved_deployments
        $route = $history.jobs.job_initialize_pipeline.steps | Where-Object id -EQ history-pools
        $ordinary = $history.jobs.job_cleanup_subscription_deployments.steps | Where-Object id -EQ get-test-subscriptions
        $environmentNames = @('GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'TEST_SUBSCRIPTION_IDS', 'VALIDATE_SUBSCRIPTION_ID')

        function Get-TestHistoryOutputs {
            $result = @{}
            foreach ($line in Get-Content $env:GITHUB_OUTPUT) {
                $name, $value = $line.Split('=', 2)
                $result[$name] = $value
            }
            return $result
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, $null)
        }
        $env:GITHUB_WORKSPACE = $RepoRootPath
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'outputs.txt'
        $pool = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'ordinary-one' }
            @{ id = 'ABCDEF12-3456-7890-ABCD-EF1234567890'; name = 'reserved'; tag = 'Azure Local' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'ordinary-two'; tag = 'General' }
        )
        $env:TEST_SUBSCRIPTION_IDS = ConvertTo-Json -InputObject $pool -Compress
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Routes the complete inventory without allowing ordinary history cleanup to bypass the reserved guard' {
        . ([scriptblock]::Create($route.run))
        $outputs = Get-TestHistoryOutputs
        $outputs.hasReservedSubscriptions | Should -Be 'true'
        $outputs.hasOrdinarySubscriptions | Should -Be 'true'
        $matrix = ConvertFrom-Json $outputs.reservedSubscriptions -NoEnumerate
        ($matrix -is [array]) | Should -BeTrue
        $matrix.Count | Should -Be 1
        $matrix[0].subscriptionIndex | Should -Be 1
        $expectedKey = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData(
                [Text.Encoding]::UTF8.GetBytes('abcdef12-3456-7890-abcd-ef1234567890')
            )).ToLowerInvariant()
        $matrix[0].subscriptionKey | Should -Be $expectedKey
        $matrix[0].environmentConcurrencyGroup | Should -Be "avm-hci-$expectedKey"
        $outputs.reservedSubscriptions | Should -Not -Match $pool[1].id

        Clear-Content $env:GITHUB_OUTPUT
        . ([scriptblock]::Create($ordinary.run))
        $selected = (Get-TestHistoryOutputs).subscriptions | ConvertFrom-Json
        @($selected.id) | Should -Be @($pool[0].id, $pool[2].id)
        @($selected.index) | Should -Be @(0, 2)
    }

    It 'Keeps <kind> inventory runnable without an empty matrix or an unguarded reserved fallback' -ForEach @(
        @{ kind = 'ordinary-only'; select = @(0, 2); hasOrdinary = 'true'; hasReserved = 'false'; reservedCount = 0 }
        @{ kind = 'reserved-only'; select = @(1); hasOrdinary = 'false'; hasReserved = 'true'; reservedCount = 1 }
    ) {
        $env:TEST_SUBSCRIPTION_IDS = ConvertTo-Json -InputObject @($pool[$select]) -Compress
        . ([scriptblock]::Create($route.run))
        $outputs = Get-TestHistoryOutputs
        $outputs.hasOrdinarySubscriptions | Should -Be $hasOrdinary
        $outputs.hasReservedSubscriptions | Should -Be $hasReserved
        @(ConvertFrom-Json $outputs.reservedSubscriptions).Count | Should -Be $reservedCount
        if ($hasOrdinary -eq 'false') {
            { . ([scriptblock]::Create($ordinary.run)) } | Should -Throw '*ordinary maintenance pool changed*'
        }
    }

    It 'Preserves the legacy ordinary fallback and canonical variable-before-secret binding' {
        $env:TEST_SUBSCRIPTION_IDS = ''
        $env:VALIDATE_SUBSCRIPTION_ID = $pool[0].id
        . ([scriptblock]::Create($route.run))
        (Get-TestHistoryOutputs).hasReservedSubscriptions | Should -Be 'false'
        (Get-TestHistoryOutputs).hasOrdinarySubscriptions | Should -Be 'true'
        $binding = '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
        $route.env.TEST_SUBSCRIPTION_IDS | Should -Be $binding
        $ordinary.env.TEST_SUBSCRIPTION_IDS | Should -Be $binding
        $selector = $reservedJob.steps | Where-Object id -EQ subscription
        $selector.env.TEST_SUBSCRIPTION_IDS | Should -Be $binding
        $selector.env.TEST_CASE | Should -Be '${{ toJson(matrix.testCase) }}'
    }

    It 'Uses the existing environment lock without nested locks, cancellation, or optional bypasses' {
        $job = $history.jobs.job_cleanup_reserved_deployments
        $job.concurrency.group | Should -Be '${{ matrix.testCase.environmentConcurrencyGroup }}'
        $job.concurrency.queue | Should -Be 'max'
        $job.concurrency.Contains('cancel-in-progress') | Should -BeFalse
        $job.Contains('uses') | Should -BeFalse
        $job.environment | Should -Be 'avm-validation'
        $job.'runs-on' | Should -Be 'ubuntu-latest'
        $job.permissions.contents | Should -Be 'read'
        $job.permissions.'id-token' | Should -Be 'write'
        $job.if | Should -Match 'hasReservedSubscriptions'
        $history.jobs.job_cleanup_subscription_deployments.if | Should -Match 'hasOrdinarySubscriptions'
        $history.jobs.job_initialize_pipeline.environment | Should -Be 'avm-validation'
        $invoke = $job.steps | Where-Object name -EQ 'Clean history only with confirmed idle ownership'
        $invoke.with.inlineScript | Should -Match 'Invoke-HciDeploymentHistoryCleanup'
        $invoke.with.inlineScript | Should -Not -Match 'Start-HciEnvironment|RefreshKubernetes'
        $invoke.env.TEST_CASE | Should -Be '${{ toJson(matrix.testCase) }}'
        $invoke.env.RETENTION_DAYS | Should -Be '${{ fromJson(needs.job_initialize_pipeline.outputs.workflowInput).maxDeploymentRetentionInDays }}'
        Test-Path (Join-Path $workflowRoot 'avm.template.hci.history.yml') | Should -BeFalse
    }
}
