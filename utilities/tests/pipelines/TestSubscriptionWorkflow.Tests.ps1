param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Test subscription workflow integration' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionList.ps1')

        $workflows = @{}
        foreach ($workflowName in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')) {
            $workflowPath = Join-Path $repoRootPath '.github' 'workflows' "$workflowName.yml"
            $workflows[$workflowName] = ConvertFrom-Yaml -Yaml (Get-Content -Path $workflowPath -Raw)
        }
        $actionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -Path $actionPath -Raw)
        $selectionStep = $action.runs.steps | Where-Object { $_.id -eq 'get-test-subscription' }
        $exceptionStep = $action.runs.steps | Where-Object { $_.id -eq 'set-oidc-exception' }
        $cleanupPath = Join-Path $repoRootPath '.github' 'workflows' 'platform.deployment.history.cleanup.yml'
        $cleanupWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $cleanupPath -Raw)
        $subscriptions = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'test-one' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'test-two' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'test-three' }
        )
        $subscriptionJson = ConvertTo-Json -InputObject $subscriptions -Compress
        $environmentNames = @(
            'GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'TEST_SUBSCRIPTION_IDS', 'VALIDATE_SUBSCRIPTION_ID',
            'SUBSCRIPTION_SELECTION_SEED', 'SUBSCRIPTION_JOB_INDEX', 'SELECTED_SUBSCRIPTION_ID',
            'AZURE_CREDENTIALS', 'TEST_SUBSCRIPTIONS'
        )

        function Get-StepOutput {
            $outputs = @{}
            foreach ($line in (Get-Content -Path $env:GITHUB_OUTPUT)) {
                if (-not [string]::IsNullOrWhiteSpace($line)) {
                    $name, $value = $line.Split('=', 2)
                    $outputs[$name] = $value
                }
            }
            return $outputs
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, $null)
        }
        $env:GITHUB_WORKSPACE = $repoRootPath
        $env:GITHUB_OUTPUT = Join-Path $TestDrive ("output-{0}.txt" -f [guid]::NewGuid())
        $null = New-Item -Path $env:GITHUB_OUTPUT -ItemType File
        $env:TEST_SUBSCRIPTION_IDS = $subscriptionJson
        $env:VALIDATE_SUBSCRIPTION_ID = '44444444-4444-4444-4444-444444444444'
        $env:SUBSCRIPTION_SELECTION_SEED = '12345'
        $env:SUBSCRIPTION_JOB_INDEX = '0'
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Wires the Actions variable and shared seed into <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $workflow = $workflows[$workflowName]
        $initializer = $workflow.jobs.job_initialize_subscription_selection
        $deployment = $workflow.jobs.job_module_deploy_validation
        $deploymentStep = $deployment.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }

        $initializer.permissions.Count | Should -Be 0
        $initializer.ContainsKey('environment') | Should -BeFalse
        @($initializer.outputs.Keys) | Should -Be @('randomSeed')
        $initializer.outputs.randomSeed | Should -Be '${{ steps.random-seed.outputs.randomSeed }}'
        $initializer.if | Should -Match "deploymentValidation == 'true'"
        $deployment.needs | Should -Contain 'job_initialize_subscription_selection'
        $deployment.if | Should -Match "needs.job_initialize_subscription_selection.result == 'success'"
        $deploymentStep.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ vars.TEST_SUBSCRIPTION_IDS }}'
        $deploymentStep.env.VALIDATE_SUBSCRIPTION_ID | Should -Be '${{ secrets.VALIDATE_SUBSCRIPTION_ID }}'
        $deploymentStep.with.subscriptionSelectionSeed | Should -Be '${{ needs.job_initialize_subscription_selection.outputs.randomSeed }}'
        $deploymentStep.with.subscriptionJobIndex | Should -Be '${{ strategy.job-index }}'
    }

    It 'Generates a numeric seed without subscription data or Azure access' {
        $seedStep = $workflows['avm.template.module'].jobs.job_initialize_subscription_selection.steps[0]

        . ([scriptblock]::Create($seedStep.run))
        $seed = (Get-StepOutput).randomSeed

        $seed | Should -Match '^\d+$'
        [int] $seed | Should -BeGreaterOrEqual 0
        $seedStep.run | Should -Not -Match 'secrets\.|vars\.|Azure|AzContext'
    }

    It 'Assigns consecutive matrix jobs round-robin over the same shuffled pool' {
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)
        $selectedIds = @(
            foreach ($index in 0..7) {
                Clear-Content -Path $env:GITHUB_OUTPUT
                $env:SUBSCRIPTION_JOB_INDEX = [string] $index
                . ([scriptblock]::Create($selectionStep.run))
                (Get-StepOutput).subscriptionId
            }
        )
        $expectedIds = @(0..7 | ForEach-Object { $shuffled[$_ % $shuffled.Count].id })

        $selectedIds | Should -Be $expectedIds
        @($selectedIds[0..2] | Sort-Object -Unique).Count | Should -Be 3
        $counts = $selectedIds | Group-Object | Select-Object -ExpandProperty Count | Measure-Object -Minimum -Maximum
        ($counts.Maximum - $counts.Minimum) | Should -BeLessOrEqual 1
    }

    It 'Keeps singleton selection unchanged for every matrix index' {
        $env:TEST_SUBSCRIPTION_IDS = ConvertTo-Json -InputObject @($subscriptions[0]) -Compress
        foreach ($index in @(0, 1, 99)) {
            Clear-Content -Path $env:GITHUB_OUTPUT
            $env:SUBSCRIPTION_JOB_INDEX = [string] $index

            . ([scriptblock]::Create($selectionStep.run))

            (Get-StepOutput).subscriptionId | Should -Be $subscriptions[0].id
        }
    }

    It 'Uses the legacy singleton when the variable is not configured' {
        $env:TEST_SUBSCRIPTION_IDS = ''
        $env:SUBSCRIPTION_JOB_INDEX = '5'

        . ([scriptblock]::Create($selectionStep.run))

        (Get-StepOutput).subscriptionId | Should -Be $env:VALIDATE_SUBSCRIPTION_ID
    }

    It 'Fails before login when the configured pool is invalid' {
        $env:TEST_SUBSCRIPTION_IDS = '[]'

        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw
        (Get-StepOutput).Count | Should -Be 0
        $selectionStep.if | Should -Be "env.skip_deployment_ci == 'false'"
    }

    It 'Rejects an invalid matrix index' {
        $env:SUBSCRIPTION_JOB_INDEX = '-1'

        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw '*must not be negative*'
        (Get-StepOutput).Count | Should -Be 0
    }

    It 'Reuses the selected subscription for both logins, token replacement, deployment and removal' {
        $defaultLogins = @($action.runs.steps | Where-Object { $_.name -eq 'Azure Login - Default' })
        $defaultLogins.Count | Should -Be 2
        foreach ($login in $defaultLogins) {
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
        }
        foreach ($stepName in @('Replace tokens in template file', 'Validate template file', 'Deploy template file', 'Remove deployed resources')) {
            $step = $action.runs.steps | Where-Object { $_.name -eq $stepName }
            $step.with.inlineScript | Should -Match ([regex]::Escape('${{ steps.get-test-subscription.outputs.subscriptionId }}'))
            $step.with.inlineScript | Should -Not -Match 'env\.VALIDATE_SUBSCRIPTION_ID'
        }
        $exceptionLogins = @($action.runs.steps | Where-Object { $_.name -eq 'Azure Login - Exception' })
        $exceptionLogins.Count | Should -Be 2
        foreach ($login in $exceptionLogins) {
            $login.with.creds | Should -Be '${{ steps.set-oidc-exception.outputs.azureCredentials }}'
        }
        $exceptionStep.env.SELECTED_SUBSCRIPTION_ID | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
    }

    It 'Updates and masks exception credentials without changing the original secret' {
        $credentials = @{
            clientId                   = 'test-client'
            clientSecret               = 'not-a-real-secret'
            tenantId                   = 'test-tenant'
            subscriptionId             = $env:VALIDATE_SUBSCRIPTION_ID
            activeDirectoryEndpointUrl = 'https://login.example.invalid'
        }
        $env:AZURE_CREDENTIALS = ConvertTo-Json -InputObject $credentials -Compress
        $originalCredentials = $env:AZURE_CREDENTIALS
        $env:SELECTED_SUBSCRIPTION_ID = $subscriptions[2].id
        $script = $exceptionStep.with.inlineScript.Replace('${{ inputs.modulePath }}', 'avm/res/azure-stack-hci/cluster')

        $messages = @(. ([scriptblock]::Create($script)))
        $outputs = Get-StepOutput
        $updatedCredentials = $outputs.azureCredentials | ConvertFrom-Json

        $outputs.oidcException | Should -Be 'true'
        $updatedCredentials.subscriptionId | Should -Be $subscriptions[2].id
        $updatedCredentials.clientId | Should -Be $credentials.clientId
        $updatedCredentials.clientSecret | Should -Be $credentials.clientSecret
        $updatedCredentials.tenantId | Should -Be $credentials.tenantId
        $updatedCredentials.activeDirectoryEndpointUrl | Should -Be $credentials.activeDirectoryEndpointUrl
        $messages | Should -Contain "::add-mask::$($outputs.azureCredentials)"
        $env:AZURE_CREDENTIALS | Should -Be $originalCredentials
    }

    It 'Does not require secret credentials for OIDC-capable modules' {
        $script = $exceptionStep.with.inlineScript.Replace('${{ inputs.modulePath }}', 'avm/res/storage/storage-account')

        $null = . ([scriptblock]::Create($script))
        $outputs = Get-StepOutput

        $outputs.oidcException | Should -Be 'false'
        $outputs.ContainsKey('azureCredentials') | Should -BeFalse
    }

    It 'Uses the configured pool for both history cleanup logins' {
        foreach ($jobName in @('job_cleanup_subscription_deployments', 'job_cleanup_managementGroup_deployments')) {
            Clear-Content -Path $env:GITHUB_OUTPUT
            $job = $cleanupWorkflow.jobs[$jobName]
            $poolStep = $job.steps | Where-Object { $_.id -eq 'get-test-subscriptions' }
            $login = $job.steps | Where-Object { $_.name -eq 'Azure Login' }

            . ([scriptblock]::Create($poolStep.run))

            $poolStep.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ vars.TEST_SUBSCRIPTION_IDS }}'
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscriptions.outputs.subscriptionId }}'
            (Get-StepOutput).subscriptionId | Should -Be $subscriptions[0].id
        }
    }

    It 'Visits every configured subscription during history cleanup' {
        $job = $cleanupWorkflow.jobs.job_cleanup_subscription_deployments
        $poolStep = $job.steps | Where-Object { $_.id -eq 'get-test-subscriptions' }
        $removalStep = $job.steps | Where-Object { $_.name -eq 'Remove deployments' }
        . ([scriptblock]::Create($poolStep.run))
        $env:TEST_SUBSCRIPTIONS = (Get-StepOutput).subscriptions

        $removalStep.env.TEST_SUBSCRIPTIONS | Should -Be '${{ steps.get-test-subscriptions.outputs.subscriptions }}'
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($removalStep.with.inlineScript, [ref] $null, [ref] $null)
        $loop = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.ForEachStatementAst] }, $true)
        $script = $loop.Extent.Text.Replace('${{ (fromJson(needs.job_initialize_pipeline.outputs.workflowInput)).maxDeploymentRetentionInDays }}', '14')

        function Clear-SubscriptionDeploymentHistory {
            param([string] $SubscriptionId, [int] $maxDeploymentRetentionInDays)
            [pscustomobject]@{ id = $SubscriptionId; retention = $maxDeploymentRetentionInDays }
        }

        $visited = @(. ([scriptblock]::Create($script)))

        $visited.id | Should -Be $subscriptions.id
        $visited.retention | Should -Be @(14, 14, 14)
    }
}
