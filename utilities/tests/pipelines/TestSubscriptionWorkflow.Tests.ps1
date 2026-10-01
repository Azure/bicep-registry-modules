param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Test subscription workflow integration' {

    BeforeDiscovery {
        $routingCases = foreach ($workflowName in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')) {
            foreach ($repositoryCase in @(
                    @{ repository = 'Azure/bicep-registry-modules'; bami = $true }
                    @{ repository = 'contributor/bicep-registry-modules'; bami = $false }
                    @{ repository = 'Azure/contributor-modules'; bami = $false }
                )) {
                foreach ($modulePath in @('avm/res/dev-test-lab/lab', 'avm/res/example/unlisted', 'avm/res/example/new-module')) {
                    foreach ($selector in @(
                            @{ label = 'missing'; value = $null }
                            @{ label = 'empty'; value = '' }
                            @{ label = 'empty array'; value = '[]' }
                            @{ label = 'malformed'; value = '[invalid' }
                            @{ label = 'mismatched'; value = '["avm/res/example/different"]' }
                        )) {
                        @{
                            workflowName  = $workflowName
                            repository    = $repositoryCase.repository
                            bami          = $repositoryCase.bami
                            modulePath    = $modulePath
                            selectorName  = $selector.label
                            selectorValue = $selector.value
                        }
                    }
                }
            }
        }
    }

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
        $psrulePath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModulePSRule' 'action.yml'
        $psrule = ConvertFrom-Yaml -Yaml (Get-Content -Path $psrulePath -Raw)
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($psrule.runs.steps[0].with.inlineScript, [ref] $null, [ref] $null)
        $psruleSelection = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.IfStatementAst] -and $node.Extent.Text.StartsWith('if ($env:AVM_TEST_TENANT') }, $true).Extent.Text
        $subscriptions = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'test-one' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'test-two' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'test-three' }
        )
        $subscriptionJson = ConvertTo-Json -InputObject $subscriptions -Compress
        $environmentNames = @(
            'GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'TEST_SUBSCRIPTION_IDS', 'VALIDATE_SUBSCRIPTION_ID',
            'SUBSCRIPTION_SELECTION_SEED', 'SUBSCRIPTION_JOB_INDEX', 'SELECTED_SUBSCRIPTION_ID',
            'AZURE_CREDENTIALS', 'TEST_SUBSCRIPTIONS', 'AVM_TEST_TENANT',
            'VALIDATE_CLIENT_ID', 'VALIDATE_TENANT_ID', 'MANAGEMENT_GROUP_ID', 'CI_KEY_VAULT_NAME'
        )

        function Resolve-TestRoutingExpression {
            param([string] $Expression, [hashtable] $Context)

            if ($Expression -notmatch '^\$\{\{ case\((github\.repository|env\.AVM_TEST_TENANT) == ''([^'']+)'', (''[^'']*''|(?:vars|secrets)\.[A-Z_]+), (''[^'']*''|(?:vars|secrets)\.[A-Z_]+)\) \}\}$') {
                throw "Unexpected routing expression: $Expression"
            }
            $selected = $Context[$Matches[1]] -eq $Matches[2] ? $Matches[3] : $Matches[4]
            if ($selected.StartsWith("'")) {
                return $selected.Substring(1, $selected.Length - 2)
            }
            if (-not $Context.ContainsKey($selected)) {
                throw "Missing synthetic context value: $selected"
            }
            return $Context[$selected]
        }

        function Set-TestDeploymentEnvironment {
            param([hashtable] $Workflow, [hashtable] $Context)

            $env:AVM_TEST_TENANT = Resolve-TestRoutingExpression -Expression $Workflow.env.AVM_TEST_TENANT -Context $Context
            $Context['env.AVM_TEST_TENANT'] = $env:AVM_TEST_TENANT
            $step = $Workflow.jobs.job_module_deploy_validation.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }
            foreach ($name in $step.env.Keys) {
                [Environment]::SetEnvironmentVariable($name, (Resolve-TestRoutingExpression -Expression $step.env[$name] -Context $Context))
            }
            $env:MANAGEMENT_GROUP_ID = Resolve-TestRoutingExpression -Expression $step.with.managementGroupId -Context $Context
        }

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
        $env:VALIDATE_CLIENT_ID = 'test-client'
        $env:VALIDATE_TENANT_ID = 'test-tenant'
        $env:MANAGEMENT_GROUP_ID = 'test-management-group'
        $routingContext = @{
            'github.repository'                  = 'Azure/bicep-registry-modules'
            'vars.TEST_BAMI_SUBSCRIPTION_IDS'    = $subscriptionJson
            'vars.TEST_BAMI_BICEP_CLIENT_ID'     = 'bami-client'
            'vars.TEST_BAMI_TENANT_ID'           = 'bami-tenant'
            'vars.TEST_BAMI_MANAGEMENT_GROUP_ID' = 'bami-management-group'
            'vars.TEST_SUBSCRIPTION_IDS'         = '[{"id":"55555555-5555-5555-5555-555555555555","name":"contributor-one"}]'
            'vars.CI_KEY_VAULT_NAME'             = 'contributor-vault'
            'secrets.VALIDATE_CLIENT_ID'         = 'contributor-client'
            'secrets.VALIDATE_TENANT_ID'         = 'contributor-tenant'
            'secrets.VALIDATE_SUBSCRIPTION_ID'   = $env:VALIDATE_SUBSCRIPTION_ID
            'secrets.ARM_MGMTGROUP_ID'           = 'contributor-management-group'
            'secrets.AZURE_CREDENTIALS'          = '{"clientId":"contributor-client","tenantId":"contributor-tenant","clientSecret":"synthetic-secret"}'
        }
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
        $workflow.env.AVM_TEST_TENANT | Should -Be '${{ case(github.repository == ''Azure/bicep-registry-modules'', ''bami'', ''legacy'') }}'
        ($workflow | ConvertTo-Json -Depth 20) | Should -Not -Match 'TEST_BAMI_MODULE_PATHS'
        $workflow.env.ARM_MGMTGROUP_ID | Should -Be '${{ secrets.ARM_MGMTGROUP_ID }}'
        $deploymentStep.with.managementGroupId | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_MANAGEMENT_GROUP_ID, secrets.ARM_MGMTGROUP_ID) }}'
        $selectionStep.env.MANAGEMENT_GROUP_ID | Should -Be '${{ inputs.managementGroupId }}'
        $deploymentStep.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_SUBSCRIPTION_IDS, vars.TEST_SUBSCRIPTION_IDS) }}'
        $deploymentStep.env.VALIDATE_CLIENT_ID | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_BICEP_CLIENT_ID, secrets.VALIDATE_CLIENT_ID) }}'
        $deploymentStep.env.VALIDATE_TENANT_ID | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_TENANT_ID, secrets.VALIDATE_TENANT_ID) }}'
        $deploymentStep.env.VALIDATE_SUBSCRIPTION_ID | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', '''', secrets.VALIDATE_SUBSCRIPTION_ID) }}'
        $deploymentStep.env.AZURE_CREDENTIALS | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', '''', secrets.AZURE_CREDENTIALS) }}'
        $deploymentStep.env.CI_KEY_VAULT_NAME | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', '''', vars.CI_KEY_VAULT_NAME) }}'
        $deployment.environment | Should -Be 'avm-validation'
        @($deployment.env.Keys) | Should -Not -Contain 'VALIDATE_CLIENT_ID'
        foreach ($jobName in @('job_psrule_must', 'job_psrule_opt')) {
            $step = $workflow.jobs[$jobName].steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModulePSRule' }
            $step.with.managementGroupId | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_MANAGEMENT_GROUP_ID, secrets.ARM_MGMTGROUP_ID) }}'
            $step.env.VALIDATE_TENANT_ID | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_TENANT_ID, '''') }}'
            $step.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ case(env.AVM_TEST_TENANT == ''bami'', vars.TEST_BAMI_SUBSCRIPTION_IDS, '''') }}'
        }
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

    It 'Routes <modulePath> in <repository> through <workflowName> without reading the <selectorName> retired selector' -ForEach $routingCases {
        $routingContext['github.repository'] = $repository
        $routingContext['inputs.modulePath'] = $modulePath
        $routingContext['vars.TEST_BAMI_MODULE_PATHS'] = $selectorValue
        Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext

        . ([scriptblock]::Create($selectionStep.run))

        if ($bami) {
            $env:AVM_TEST_TENANT | Should -Be 'bami'
            (Get-StepOutput).subscriptionId | Should -BeIn $subscriptions.id
            $env:VALIDATE_CLIENT_ID | Should -Be 'bami-client'
            $env:VALIDATE_TENANT_ID | Should -Be 'bami-tenant'
            $env:MANAGEMENT_GROUP_ID | Should -Be 'bami-management-group'
            $env:VALIDATE_SUBSCRIPTION_ID | Should -BeNullOrEmpty
            $env:AZURE_CREDENTIALS | Should -BeNullOrEmpty
            $env:CI_KEY_VAULT_NAME | Should -BeNullOrEmpty
        } else {
            $env:AVM_TEST_TENANT | Should -Be 'legacy'
            (Get-StepOutput).subscriptionId | Should -Be '55555555-5555-5555-5555-555555555555'
            $env:VALIDATE_CLIENT_ID | Should -Be 'contributor-client'
            $env:VALIDATE_TENANT_ID | Should -Be 'contributor-tenant'
            $env:MANAGEMENT_GROUP_ID | Should -Be 'contributor-management-group'
            $env:VALIDATE_SUBSCRIPTION_ID | Should -Be $routingContext['secrets.VALIDATE_SUBSCRIPTION_ID']
            $env:AZURE_CREDENTIALS | Should -Be $routingContext['secrets.AZURE_CREDENTIALS']
            $env:CI_KEY_VAULT_NAME | Should -Be 'contributor-vault'
        }
    }

    It 'Keeps the external singleton fallback without requiring BAMI configuration in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $routingContext['github.repository'] = 'contributor/bicep-registry-modules'
        $routingContext['vars.TEST_SUBSCRIPTION_IDS'] = ''
        $routingContext['vars.TEST_BAMI_SUBSCRIPTION_IDS'] = '[invalid-unused-pool'
        foreach ($setting in @('BICEP_CLIENT_ID', 'TENANT_ID', 'MANAGEMENT_GROUP_ID')) {
            $routingContext["vars.TEST_BAMI_$setting"] = ''
        }
        Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext

        . ([scriptblock]::Create($selectionStep.run))

        (Get-StepOutput).subscriptionId | Should -Be $routingContext['secrets.VALIDATE_SUBSCRIPTION_ID']
        $env:CI_KEY_VAULT_NAME | Should -Be 'contributor-vault'
        $env:AZURE_CREDENTIALS | Should -Be $routingContext['secrets.AZURE_CREDENTIALS']
    }

    It 'Does not select contributor fallback for missing upstream BAMI variables in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        foreach ($setting in @('SUBSCRIPTION_IDS', 'BICEP_CLIENT_ID', 'TENANT_ID', 'MANAGEMENT_GROUP_ID')) {
            $missingContext = $routingContext.Clone()
            $missingContext["vars.TEST_BAMI_$setting"] = ''
            Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $missingContext

            { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw '*Missing BAMI configuration*'

            $env:AVM_TEST_TENANT | Should -Be 'bami'
            $env:VALIDATE_SUBSCRIPTION_ID | Should -BeNullOrEmpty
            $env:AZURE_CREDENTIALS | Should -BeNullOrEmpty
            $env:CI_KEY_VAULT_NAME | Should -BeNullOrEmpty
            (Get-StepOutput).Count | Should -Be 0
        }
    }

    It 'Rejects missing selected BAMI <setting> before login without using legacy fallback' -ForEach @(
        @{ setting = 'TEST_SUBSCRIPTION_IDS' }
        @{ setting = 'VALIDATE_CLIENT_ID' }
        @{ setting = 'VALIDATE_TENANT_ID' }
        @{ setting = 'MANAGEMENT_GROUP_ID' }
    ) {
        $env:AVM_TEST_TENANT = 'bami'
        [Environment]::SetEnvironmentVariable($setting, '')

        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw "*Missing BAMI configuration for [[]$setting[]]*"
        (Get-StepOutput).Count | Should -Be 0
    }

    It 'Reads the BAMI pool for PSRule only when selected' {
        $ConvertTokensInputs = @{ Tokens = @{ subscriptionId = 'legacy-static-token'; managementGroupId = 'test-management-group' } }
        $env:TEST_SUBSCRIPTION_IDS = 'invalid-unused-candidate'
        . ([scriptblock]::Create($psruleSelection))
        $ConvertTokensInputs.Tokens.subscriptionId | Should -Be 'legacy-static-token'

        $env:AVM_TEST_TENANT = 'bami'
        { . ([scriptblock]::Create($psruleSelection)) } | Should -Throw
        $env:TEST_SUBSCRIPTION_IDS = $subscriptionJson
        . ([scriptblock]::Create($psruleSelection))
        $ConvertTokensInputs.Tokens.subscriptionId | Should -Be $subscriptions[0].id
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

    It 'Blocks the BAMI HCI credential exception but allows the lab OIDC path' {
        $env:AVM_TEST_TENANT = 'bami'
        $hciScript = $exceptionStep.with.inlineScript.Replace('${{ inputs.modulePath }}', 'avm/res/azure-stack-hci/cluster')
        { . ([scriptblock]::Create($hciScript)) } | Should -Throw '*AZURE_CREDENTIALS exception is not supported*'
        (Get-StepOutput).Count | Should -Be 0

        $labScript = $exceptionStep.with.inlineScript.Replace('${{ inputs.modulePath }}', 'avm/res/dev-test-lab/lab')
        $null = . ([scriptblock]::Create($labScript))
        (Get-StepOutput).oidcException | Should -Be 'false'
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
