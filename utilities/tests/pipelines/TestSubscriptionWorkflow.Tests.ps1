param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'BAMI-only test workflow integration' {
    BeforeDiscovery {
        $workflowNames = @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')
        $routingCases = foreach ($workflowName in $workflowNames) {
            foreach ($modulePath in @('avm/res/dev-test-lab/lab', 'avm/res/example/unlisted', 'avm/res/example/new-module/child')) {
                foreach ($selector in @(
                        @{ label = 'missing'; value = $null }
                        @{ label = 'empty'; value = '' }
                        @{ label = 'empty list'; value = '[]' }
                        @{ label = 'malformed'; value = '[invalid' }
                        @{ label = 'mismatched'; value = '["avm/res/example/different"]' }
                        @{ label = 'matching'; value = '["avm/res/dev-test-lab/lab"]' }
                    )) {
                    @{
                        workflowName  = $workflowName
                        modulePath    = $modulePath
                        selectorName  = $selector.label
                        selectorValue = $selector.value
                    }
                }
            }
        }
        $configurationCases = foreach ($consumer in @('deployment', 'psrule', 'scheduled-psrule', 'subscription-history', 'management-group-history')) {
            foreach ($setting in @(
                    'TEST_BAMI_TENANT_ID', 'TEST_BAMI_BICEP_CLIENT_ID', 'TEST_BAMI_SUBSCRIPTION_IDS',
                    'TEST_BAMI_MANAGEMENT_GROUP_ID', 'TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID'
                )) {
                foreach ($value in @($null, '', ' ', 'invalid')) {
                    @{
                        consumer = $consumer
                        setting  = $setting
                        value    = $setting -eq 'TEST_BAMI_MANAGEMENT_GROUP_ID' -and $value -eq 'invalid' ? '/invalid/group' : $value
                    }
                }
            }
        }
    }

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionList.ps1')
        $workflows = @{}
        foreach ($workflowName in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')) {
            $workflows[$workflowName] = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' "$workflowName.yml") -Raw)
        }
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw)
        $psrule = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModulePSRule' 'action.yml') -Raw)
        $cleanupWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'platform.deployment.history.cleanup.yml') -Raw)
        $scheduledPSRule = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'platform.check.psrule.yml') -Raw)
        $fixtureAction = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-getModuleTestFiles' 'action.yml') -Raw)
        $selectionStep = $action.runs.steps | Where-Object { $_.id -eq 'get-test-subscription' }
        $oidcStep = $action.runs.steps | Where-Object { $_.id -eq 'check-bami-oidc' }
        $configurationSteps = @{
            deployment                 = $selectionStep
            psrule                     = $psrule.runs.steps | Where-Object { $_.id -eq 'get-test-subscription' }
            'scheduled-psrule'         = $scheduledPSRule.jobs.job_psrule.steps | Where-Object { $_.id -eq 'get-test-subscription' }
            'subscription-history'     = $cleanupWorkflow.jobs.job_cleanup_subscription_deployments.steps | Where-Object { $_.id -eq 'get-test-subscriptions' }
            'management-group-history' = $cleanupWorkflow.jobs.job_cleanup_managementGroup_deployments.steps | Where-Object { $_.id -eq 'get-test-subscriptions' }
        }
        $subscriptions = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'test-one' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'test-two' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'test-three' }
        )
        $subscriptionJson = ConvertTo-Json -InputObject $subscriptions -Compress
        $settings = @{
            TEST_BAMI_TENANT_ID                  = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
            TEST_BAMI_BICEP_CLIENT_ID            = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
            TEST_BAMI_SUBSCRIPTION_IDS           = $subscriptionJson
            TEST_BAMI_MANAGEMENT_GROUP_ID        = 'test-management-group'
            TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID = 'cccccccc-cccc-cccc-cccc-cccccccccccc'
        }
        $environmentNames = @($settings.Keys) + @(
            'GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'TEST_SUBSCRIPTION_IDS', 'VALIDATE_SUBSCRIPTION_ID',
            'SUBSCRIPTION_SELECTION_SEED', 'SUBSCRIPTION_JOB_INDEX', 'TEST_SUBSCRIPTIONS',
            'AZURE_CREDENTIALS', 'AVM_TEST_TENANT', 'TEST_BAMI_MODULE_PATHS', 'MODULE_PATH',
            'VALIDATE_CLIENT_ID', 'VALIDATE_TENANT_ID', 'MANAGEMENT_GROUP_ID', 'ARM_MGMTGROUP_ID',
            'CI_KEY_VAULT_NAME', 'AVM_CI_VARIABLES', 'AVM_CI_SECRETS',
            'localToken_subscriptionId', 'localToken_tenantId', 'localToken_managementGroupId',
            'localToken_persistentSubscriptionId', 'localToken_resourceLocation', 'localToken_namePrefix'
        )

        function Get-StepOutput {
            $outputs = @{}
            foreach ($line in (Get-Content -LiteralPath $env:GITHUB_OUTPUT)) {
                if (-not [string]::IsNullOrWhiteSpace($line)) {
                    $name, $value = $line.Split('=', 2)
                    $outputs[$name] = $value
                }
            }
            return $outputs
        }

        function Set-TestWorkflowEnvironment {
            param([hashtable] $Bindings, [hashtable] $Variables)
            @($Bindings.Keys | Sort-Object) | Should -Be @($settings.Keys | Sort-Object)
            foreach ($name in $Bindings.Keys) {
                $Bindings[$name] | Should -Be ('${{ vars.' + $name + ' }}')
                [Environment]::SetEnvironmentVariable($name, $Variables[$name])
            }
        }

        function Get-TestStepScript {
            param([hashtable] $Step, [hashtable] $Selected, [hashtable] $Outputs = @{})
            $script = $Step.with.inlineScript
            # Keep mocked deployment and token boundaries while executing the actual YAML body.
            $script = $script -replace "(?m)^.*\. \(Join-Path.*('resourceDeployment'|'resourceRemoval'|'tokenReplacement'|'Get-LocallyReferencedFileList.ps1').*\)\r?\n", ''
            $script = $script.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ inputs.templateFilePath }}''',
                "'{0}'" -f $templatePath.Replace("'", "''")
            )
            $script = $script.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ env.targetPath }}''',
                "'{0}'" -f $fixtureRoot.Replace("'", "''")
            )
            foreach ($name in $Selected.Keys) {
                $script = $script.Replace(('${{ steps.get-test-subscription.outputs.' + $name + ' }}'), $Selected[$name])
            }
            $values = @{
                '${{ inputs.modulePath }}'                                          = 'avm/res/example/new-module'
                '${{ inputs.deploymentMetadataLocation }}'                          = 'WestEurope'
                '${{ inputs.customLocation }}'                                      = ''
                '${{ inputs.customTokens }}'                                        = ''
                '${{  inputs.customTokens }}'                                       = ''
                '${{ env.TOKEN_NAMEPREFIX }}'                                       = 'testprefix'
                '${{ env.psRuleFilterRegex }}'                                      = '(defaults|waf-aligned)'
                '${{ steps.replace-tokens.outputs.resourceLocation }}'              = ''
                '${{ steps.validate-template.outputs.resourceLocation }}'           = 'eastus'
                '${{ steps.deploy_step.outputs.deploymentNames }}'                  = $Outputs.deploymentNames ?? ''
                '${{ steps.deploy_step.outputs.preflightRejectedDeploymentNames }}' = $Outputs.preflightRejectedDeploymentNames ?? ''
            }
            foreach ($name in $values.Keys) {
                $script = $script.Replace($name, $values[$name])
            }
            $script | Should -Not -Match '\$\{\{'
            return [scriptblock]::Create($script)
        }

        function Convert-TokensInFileList {
            [CmdletBinding()]
            param([string[]] $FilePathList, [hashtable] $Tokens)
            throw 'Unexpected token replacement.'
        }
        function Get-LocallyReferencedFileList {
            [CmdletBinding()]
            param([string] $FilePath)
            throw 'Unexpected fixture traversal.'
        }
        function Test-TemplateDeploymentWithRetry {
            [CmdletBinding()]
            param([hashtable] $ValidationInput, [string] $ModuleRoot, [string] $CustomLocation, [string] $TokenResourceLocation)
            throw 'Unexpected Azure validation.'
        }
        function New-TemplateDeployment {
            [CmdletBinding()]
            param(
                [string] $TemplateFilePath, [string] $DeploymentMetadataLocation, [string] $SubscriptionId,
                [string] $ManagementGroupId, [string] $RepoRoot, [hashtable] $AdditionalParameters, [bool] $DoNotThrow
            )
            throw 'Unexpected Azure deployment.'
        }
        function Initialize-DeploymentRemoval {
            [CmdletBinding()]
            param(
                [string] $TemplateFilePath, [string[]] $DeploymentNames, [string[]] $PreflightRejectedDeploymentNames,
                [string] $ManagementGroupId, [string] $SubscriptionId
            )
            throw 'Unexpected resource cleanup.'
        }
        function Set-AzContext {
            [CmdletBinding()]
            param([string] $Subscription)
            throw 'Unexpected Azure context change.'
        }
        function Get-AzContext {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure context fallback.'
        }
        function Get-AzAccessToken {
            [CmdletBinding()]
            param([switch] $AsSecureString)
            throw 'Unexpected Azure token request.'
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($environmentName in $environmentNames) {
            $savedEnvironment[$environmentName] = [Environment]::GetEnvironmentVariable($environmentName)
            Remove-Item -LiteralPath "Env:\$environmentName" -ErrorAction SilentlyContinue
        }
        foreach ($environmentName in $settings.Keys) {
            [Environment]::SetEnvironmentVariable($environmentName, $settings[$environmentName])
        }
        $env:GITHUB_WORKSPACE = $repoRootPath
        $env:GITHUB_OUTPUT = Join-Path $TestDrive ("output-{0}.txt" -f [guid]::NewGuid())
        $null = New-Item -Path $env:GITHUB_OUTPUT -ItemType File
        $env:SUBSCRIPTION_SELECTION_SEED = '12345'
        $env:SUBSCRIPTION_JOB_INDEX = '0'
        $env:AVM_TEST_TENANT = 'legacy'
        $env:TEST_BAMI_MODULE_PATHS = '[invalid-unused-selector'
        $env:VALIDATE_SUBSCRIPTION_ID = '44444444-4444-4444-4444-444444444444'
        $env:TEST_SUBSCRIPTION_IDS = '[{"id":"44444444-4444-4444-4444-444444444444","name":"legacy"}]'
        $env:VALIDATE_CLIENT_ID = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
        $env:VALIDATE_TENANT_ID = 'dddddddd-dddd-dddd-dddd-dddddddddddd'
        $env:MANAGEMENT_GROUP_ID = 'legacy-management-group'
        $env:ARM_MGMTGROUP_ID = 'legacy-management-group'
        $env:AZURE_CREDENTIALS = '{"clientId":"eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee","tenantId":"dddddddd-dddd-dddd-dddd-dddddddddddd","subscriptionId":"44444444-4444-4444-4444-444444444444","clientSecret":"unused-test-secret"}'
        $env:CI_KEY_VAULT_NAME = 'unused-legacy-vault'
        $env:AVM_CI_VARIABLES = '{}'
        $env:AVM_CI_SECRETS = '{}'
        $env:MODULE_PATH = 'avm/res/example/new-module'
        $templatePath = Join-Path $TestDrive 'main.test.json'
        '{"parameters":{}}' | Set-Content -LiteralPath $templatePath
        $fixtureRoot = Join-Path $TestDrive 'fixture-module'
        foreach ($fixture in @('defaults', 'max', 'waf-aligned', 'custom')) {
            $folder = Join-Path $fixtureRoot 'tests' 'e2e' $fixture
            $null = New-Item -Path $folder -ItemType Directory -Force
            '// synthetic fixture' | Set-Content -LiteralPath (Join-Path $folder 'main.test.bicep')
        }
        'Synthetic unsupported fixture' | Set-Content -LiteralPath (Join-Path $fixtureRoot 'tests' 'e2e' 'custom' '.e2eignore')

        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Convert-TokensInFileList { $true }
        Mock Get-LocallyReferencedFileList { @() }
        Mock Test-TemplateDeploymentWithRetry { 'eastus' }
        Mock New-TemplateDeployment { @{ deploymentNames = @('selected-deployment'); deploymentOutput = @{} } }
        Mock Initialize-DeploymentRemoval {}
        Mock Set-AzContext {}
        Mock Get-AzContext { throw 'A configured subscription must be supplied.' }
        Mock Get-AzAccessToken { @{ Token = ConvertTo-SecureString -String 'synthetic-token' -AsPlainText -Force } }
    }

    AfterEach {
        foreach ($environmentName in $environmentNames) {
            if ($null -eq $savedEnvironment[$environmentName]) {
                Remove-Item -LiteralPath "Env:\$environmentName" -ErrorAction SilentlyContinue
            }
            else {
                [Environment]::SetEnvironmentVariable($environmentName, $savedEnvironment[$environmentName])
            }
        }
    }

    It 'Wires only the five BAMI settings without changing the matrix or gates in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $workflow = $workflows[$workflowName]
        $initializer = $workflow.jobs.job_initialize_subscription_selection
        $deployment = $workflow.jobs.job_module_deploy_validation
        $deploymentStep = $deployment.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }

        $workflow.env.AVM_TEST_TENANT | Should -Be 'bami'
        ($workflow | ConvertTo-Json -Depth 30) | Should -Not -Match 'TEST_BAMI_MODULE_PATHS|VALIDATE_(CLIENT|TENANT|SUBSCRIPTION)_ID|ARM_MGMTGROUP_ID|CI_KEY_VAULT_NAME|AZURE_CREDENTIALS'
        $initializer.permissions.Count | Should -Be 0
        $initializer.ContainsKey('environment') | Should -BeFalse
        @($initializer.outputs.Keys) | Should -Be @('randomSeed')
        $initializer.outputs.randomSeed | Should -Be '${{ steps.random-seed.outputs.randomSeed }}'
        $initializer.if | Should -Match "deploymentValidation == 'true'"
        $deployment.needs | Should -Contain 'job_initialize_subscription_selection'
        $deployment.if | Should -Match "!cancelled\(\)"
        $deployment.if | Should -Match "needs.job_initialize_subscription_selection.result == 'success'"
        $deployment.if | Should -Match "needs.job_module_static_validation.result != 'failure'"
        $deployment.if | Should -Match "needs.job_psrule_must.result != 'failure'"
        $deployment.environment | Should -Be 'avm-validation'
        $deployment.strategy.'fail-fast' | Should -BeFalse
        $deployment.strategy.matrix.testCases | Should -Be '${{ fromJson(inputs.moduleTestFilePaths) }}'
        $deploymentStep.with.e2eIgnore | Should -Be '${{ matrix.testCases.e2eIgnore }}'
        $deploymentStep.with.removeDeployment | Should -Be '${{ fromJson(inputs.workflowInput).removeDeployment }}'
        $deploymentStep.with.subscriptionSelectionSeed | Should -Be '${{ needs.job_initialize_subscription_selection.outputs.randomSeed }}'
        $deploymentStep.with.subscriptionJobIndex | Should -Be '${{ strategy.job-index }}'
        Set-TestWorkflowEnvironment -Bindings $deploymentStep.env -Variables $settings
        foreach ($jobName in @('job_psrule_must', 'job_psrule_opt')) {
            $step = $workflow.jobs[$jobName].steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModulePSRule' }
            Set-TestWorkflowEnvironment -Bindings $step.env -Variables $settings
            $step.with.ContainsKey('managementGroupId') | Should -BeFalse
        }
        if ($workflowName -ne 'avm.template.module') {
            $deployment.permissions.'id-token' | Should -Be 'write'
        }
        foreach ($job in @($workflow.jobs.Values | Where-Object { $_.name -in @('Publishing', 'Publishing preview', 'Approve release tag creation') })) {
            $job.if | Should -Match "!cancelled\(\)"
            $job.if | Should -Match "github.ref == 'refs/heads/main'"
            $job.if | Should -Match "github.repository\s+== 'Azure/bicep-registry-modules'"
        }
    }

    It 'Routes <modulePath> through BAMI in <workflowName> with a <selectorName> retired selector' -ForEach $routingCases {
        $workflow = $workflows[$workflowName]
        $step = $workflow.jobs.job_module_deploy_validation.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }
        $variables = $settings.Clone()
        $variables.TEST_BAMI_MODULE_PATHS = $selectorValue
        Set-TestWorkflowEnvironment -Bindings $step.env -Variables $variables
        $env:TEST_BAMI_MODULE_PATHS = $selectorValue
        $env:MODULE_PATH = $modulePath
        $env:AVM_TEST_TENANT = $workflow.env.AVM_TEST_TENANT

        $null = . ([scriptblock]::Create($selectionStep.run))
        $null = . ([scriptblock]::Create($oidcStep.run))

        $outputs = Get-StepOutput
        $outputs.subscriptionId | Should -BeIn $subscriptions.id
        $outputs.subscriptionId | Should -Not -Be $env:VALIDATE_SUBSCRIPTION_ID
        $outputs.clientId | Should -Be $settings.TEST_BAMI_BICEP_CLIENT_ID
        $outputs.tenantId | Should -Be $settings.TEST_BAMI_TENANT_ID
        $outputs.managementGroupId | Should -Be $settings.TEST_BAMI_MANAGEMENT_GROUP_ID
        $outputs.persistentSubscriptionId | Should -Be $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
    }

    It 'Generates a numeric shared seed without subscription data or Azure access' {
        $seedStep = $workflows['avm.template.module'].jobs.job_initialize_subscription_selection.steps[0]
        . ([scriptblock]::Create($seedStep.run))
        (Get-StepOutput).randomSeed | Should -Match '^\d+$'
        $seedStep.run | Should -Not -Match 'secrets\.|vars\.|Azure|AzContext'
    }

    It 'Assigns consecutive matrix jobs round-robin over the same shuffled pool' {
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)
        $selectedIds = @(
            foreach ($index in 0..7) {
                Clear-Content -LiteralPath $env:GITHUB_OUTPUT
                $env:SUBSCRIPTION_JOB_INDEX = [string] $index
                . ([scriptblock]::Create($selectionStep.run))
                (Get-StepOutput).subscriptionId
            }
        )
        $selectedIds | Should -Be @(0..7 | ForEach-Object { $shuffled[$_ % $shuffled.Count].id })
        @($selectedIds[0..2] | Sort-Object -Unique).Count | Should -Be 3
        $counts = $selectedIds | Group-Object | Select-Object -ExpandProperty Count | Measure-Object -Minimum -Maximum
        ($counts.Maximum - $counts.Minimum) | Should -BeLessOrEqual 1
    }

    It 'Keeps singleton selection unchanged for every matrix index' {
        $env:TEST_BAMI_SUBSCRIPTION_IDS = ConvertTo-Json -InputObject @($subscriptions[0]) -Compress
        foreach ($index in @(0, 1, 99)) {
            Clear-Content -LiteralPath $env:GITHUB_OUTPUT
            $env:SUBSCRIPTION_JOB_INDEX = [string] $index
            . ([scriptblock]::Create($selectionStep.run))
            (Get-StepOutput).subscriptionId | Should -Be $subscriptions[0].id
        }
    }

    It 'Rejects missing or invalid <setting> [<value>] in <consumer> despite valid legacy inputs' -ForEach $configurationCases {
        [Environment]::SetEnvironmentVariable($setting, $value)

        { . ([scriptblock]::Create($configurationSteps[$consumer].run)) } | Should -Throw "*$setting*"

        (Get-StepOutput).Count | Should -Be 0
        Should -Invoke Test-TemplateDeploymentWithRetry -Times 0 -Exactly
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        Should -Invoke Set-AzContext -Times 0 -Exactly
    }

    It 'Rejects invalid matrix input <name> [<value>] before emitting a target' -ForEach @(
        @{ name = 'SUBSCRIPTION_JOB_INDEX'; value = '-1' }
        @{ name = 'SUBSCRIPTION_JOB_INDEX'; value = 'invalid' }
        @{ name = 'SUBSCRIPTION_SELECTION_SEED'; value = '-1' }
        @{ name = 'SUBSCRIPTION_SELECTION_SEED'; value = '' }
    ) {
        [Environment]::SetEnvironmentVariable($name, $value)
        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw
        (Get-StepOutput).Count | Should -Be 0
    }

    It 'Keeps both logins OIDC-only and after successful configuration and support checks' {
        $logins = @($action.runs.steps | Where-Object { $_.uses -like 'azure/login@*' })
        $logins.Count | Should -Be 2
        foreach ($login in $logins) {
            $login.name | Should -Be 'Azure Login - Default'
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
            $login.with.'client-id' | Should -Be '${{ steps.get-test-subscription.outputs.clientId }}'
            $login.with.'tenant-id' | Should -Be '${{ steps.get-test-subscription.outputs.tenantId }}'
            $login.with.'enable-AzPSSession' | Should -BeTrue
            $login.with.ContainsKey('creds') | Should -BeFalse
            $login.if | Should -Be '${{ steps.check-bami-oidc.outcome == ''success'' && env.skip_deployment_ci == ''false'' }}'
            [array]::IndexOf($action.runs.steps, $selectionStep) | Should -BeLessThan ([array]::IndexOf($action.runs.steps, $login))
            [array]::IndexOf($action.runs.steps, $oidcStep) | Should -BeLessThan ([array]::IndexOf($action.runs.steps, $login))
        }
        foreach ($step in @($selectionStep, $oidcStep)) {
            $step.if | Should -Be "env.skip_deployment_ci == 'false'"
            $step.ContainsKey('continue-on-error') | Should -BeFalse
        }
        ($action | ConvertTo-Json -Depth 20) | Should -Not -Match 'AZURE_CREDENTIALS|azureCredentials|oidcException|VALIDATE_(CLIENT|TENANT|SUBSCRIPTION)_ID|CI_KEY_VAULT_NAME'
    }

    It 'Fails closed for unsupported OIDC path <modulePath> and its children even with legacy credentials' -ForEach @(
        @{ modulePath = 'avm/res/azure-stack-hci/cluster' }
        @{ modulePath = 'avm/res/azure-stack-hci/logical-network' }
        @{ modulePath = 'avm/res/azure-stack-hci/network-interface' }
        @{ modulePath = 'avm/res/azure-stack-hci/virtual-hard-disk' }
        @{ modulePath = 'avm/res/azure-stack-hci/virtual-machine-instance' }
        @{ modulePath = 'avm/res/hybrid-container-service/provisioned-cluster-instance' }
    ) {
        foreach ($path in @($modulePath, "$modulePath/child", "$modulePath/CHILD".ToUpperInvariant())) {
            $env:MODULE_PATH = $path
            { . ([scriptblock]::Create($oidcStep.run)) } | Should -Throw '*BAMI OIDC authentication is not supported*'
            (Get-StepOutput).Count | Should -Be 0
        }
    }

    It 'Does not block a different module whose name only begins with an unsupported name' {
        $env:MODULE_PATH = 'avm/res/azure-stack-hci/cluster-example'
        { . ([scriptblock]::Create($oidcStep.run)) } | Should -Not -Throw
        (Get-StepOutput).Count | Should -Be 0
    }

    It 'Reuses the selected subscription and management group for tokens, validation, deployment and removal' {
        $env:SUBSCRIPTION_JOB_INDEX = '4'
        . ([scriptblock]::Create($selectionStep.run))
        $selected = Get-StepOutput
        Clear-Content -LiteralPath $env:GITHUB_OUTPUT
        foreach ($name in @('Replace tokens in template file', 'Validate template file', 'Deploy template file')) {
            $step = $action.runs.steps | Where-Object { $_.name -eq $name }
            $null = . (Get-TestStepScript -Step $step -Selected $selected)
        }
        $outputs = Get-StepOutput
        $removalStep = $action.runs.steps | Where-Object { $_.name -eq 'Remove deployed resources' }
        $null = . (Get-TestStepScript -Step $removalStep -Selected $selected -Outputs $outputs)

        Should -Invoke Convert-TokensInFileList -Times 1 -Exactly -ParameterFilter {
            $Tokens.subscriptionId -eq $selected.subscriptionId -and
            $Tokens.tenantId -eq $selected.tenantId -and
            $Tokens.managementGroupId -eq $selected.managementGroupId -and
            $Tokens.persistentSubscriptionId -eq $selected.persistentSubscriptionId
        }
        Should -Invoke Test-TemplateDeploymentWithRetry -Times 1 -Exactly -ParameterFilter {
            $ValidationInput.SubscriptionId -eq $selected.subscriptionId -and
            $ValidationInput.ManagementGroupId -eq $selected.managementGroupId
        }
        Should -Invoke New-TemplateDeployment -Times 1 -Exactly -ParameterFilter {
            $SubscriptionId -eq $selected.subscriptionId -and $ManagementGroupId -eq $selected.managementGroupId
        }
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            $SubscriptionId -eq $selected.subscriptionId -and $ManagementGroupId -eq $selected.managementGroupId -and
            $DeploymentNames.Count -eq 1 -and $DeploymentNames[0] -eq 'selected-deployment'
        }
    }

    It 'Reuses BAMI tokens in <consumer> without legacy values or Azure authentication' -ForEach @(
        @{ consumer = 'psrule' }
        @{ consumer = 'scheduled-psrule' }
    ) {
        . ([scriptblock]::Create($configurationSteps[$consumer].run))
        $selected = Get-StepOutput
        $steps = $consumer -eq 'psrule' ? $psrule.runs.steps : $scheduledPSRule.jobs.job_psrule.steps
        $tokenStep = $steps | Where-Object { $_.name -like 'Replace tokens*' }

        $null = . (Get-TestStepScript -Step $tokenStep -Selected $selected)

        Should -Invoke Convert-TokensInFileList -Times 1 -Exactly -ParameterFilter {
            $Tokens.subscriptionId -eq $subscriptions[0].id -and
            $Tokens.tenantId -eq $settings.TEST_BAMI_TENANT_ID -and
            $Tokens.managementGroupId -eq $settings.TEST_BAMI_MANAGEMENT_GROUP_ID -and
            $Tokens.persistentSubscriptionId -eq $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
        }
        @($steps | Where-Object { $_.uses -like 'azure/login@*' }).Count | Should -Be 0
        [array]::IndexOf($steps, $configurationSteps[$consumer]) | Should -BeLessThan ([array]::IndexOf($steps, $tokenStep))
        $configurationSteps[$consumer].ContainsKey('continue-on-error') | Should -BeFalse
    }

    It 'Preserves scheduled PSRule filters and static-only behavior' {
        $scheduledPSRule.on.schedule[0].cron | Should -Be '0 12 * * 0'
        $scheduledPSRule.env.psRuleFilterRegex | Should -Be '(defaults|waf-aligned)'
        $scheduledPSRule.jobs.job_psrule.environment | Should -Be 'avm-validation'
        ($scheduledPSRule | ConvertTo-Json -Depth 20) | Should -Not -Match 'VALIDATE_SUBSCRIPTION_ID|ARM_MGMTGROUP_ID|id-token|azure/login'
        Set-TestWorkflowEnvironment -Bindings $configurationSteps['scheduled-psrule'].env -Variables $settings
    }

    It 'Keeps fixture discovery and e2eIgnore independent of tenant routing' {
        $env:GITHUB_WORKSPACE = $TestDrive
        $script = $fixtureAction.runs.steps[0].run.Replace('${{ inputs.modulePath }}', 'fixture-module').
        Replace('${{ inputs.psRuleFilterRegex }}', '(defaults|waf-aligned)')
        $null = . ([scriptblock]::Create($script))
        $outputs = Get-StepOutput
        $fixtures = @($outputs.moduleTestFilePaths | ConvertFrom-Json)
        @($fixtures.name | Sort-Object) | Should -Be @('custom', 'defaults', 'max', 'waf-aligned')
        @($fixtures | Where-Object e2eIgnore).name | Should -Be @('custom')
        @(($outputs.psRuleModuleTestFilePaths | ConvertFrom-Json).name | Sort-Object) | Should -Be @('defaults', 'waf-aligned')
        foreach ($name in @('Select test subscription', 'Check BAMI OIDC support', 'Validate template file', 'Deploy template file', 'Run post-deployment Pester tests')) {
            ($action.runs.steps | Where-Object name -EQ $name).if | Should -Be "env.skip_deployment_ci == 'false'"
        }
        ($action.runs.steps | Where-Object name -EQ 'Remove deployed resources').if |
            Should -Be '${{ (success() || failure()) && inputs.removeDeployment == ''true'' && steps.deploy_step.outputs.deploymentNames != '''' && env.skip_deployment_ci == ''false'' }}'
    }

    It 'Uses validated BAMI outputs for both history logins and preserves their protection and schedule' {
        $cleanupWorkflow.on.schedule[0].cron | Should -Be '0 0 * * *'
        $cleanupWorkflow.on.workflow_dispatch.inputs.maxDeploymentRetentionInDays.default | Should -Be '14'
        ($cleanupWorkflow | ConvertTo-Json -Depth 20) | Should -Not -Match 'VALIDATE_(CLIENT|TENANT|SUBSCRIPTION)_ID|ARM_MGMTGROUP_ID|bicep-lz-vending-automation-child|customManagementGroupId'
        foreach ($jobName in @('job_cleanup_subscription_deployments', 'job_cleanup_managementGroup_deployments')) {
            $job = $cleanupWorkflow.jobs[$jobName]
            $poolStep = $job.steps | Where-Object { $_.id -eq 'get-test-subscriptions' }
            $login = $job.steps | Where-Object { $_.name -eq 'Azure Login' }
            Set-TestWorkflowEnvironment -Bindings $poolStep.env -Variables $settings
            $job.environment | Should -Be 'avm-validation'
            $job.permissions.'id-token' | Should -Be 'write'
            $job.permissions.Count | Should -Be 1
            $job.if | Should -Match "handle(Subscription|ManagementGroup)Scope == 'true'"
            $login.with.'client-id' | Should -Be '${{ steps.get-test-subscriptions.outputs.clientId }}'
            $login.with.'tenant-id' | Should -Be '${{ steps.get-test-subscriptions.outputs.tenantId }}'
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscriptions.outputs.subscriptionId }}'
            $login.with.ContainsKey('creds') | Should -BeFalse
            [array]::IndexOf($job.steps, $poolStep) | Should -BeLessThan ([array]::IndexOf($job.steps, $login))
            $poolStep.ContainsKey('continue-on-error') | Should -BeFalse
        }
    }

    It 'Preserves singleton subscription history JSON as an array' {
        $env:TEST_BAMI_SUBSCRIPTION_IDS = ConvertTo-Json -InputObject @($subscriptions[0]) -Compress
        . ([scriptblock]::Create($configurationSteps['subscription-history'].run))
        $output = Get-StepOutput
        $pool = ConvertFrom-Json -InputObject $output.subscriptions -NoEnumerate
        $pool -is [array] | Should -BeTrue
        $pool.Count | Should -Be 1
        $output.subscriptionId | Should -Be $pool[0].id
    }

    It 'Cleans only configured <scope> deployment history while retaining recent failures and all running records' -ForEach @(
        @{ scope = 'subscription'; jobName = 'job_cleanup_subscription_deployments'; consumer = 'subscription-history' }
        @{ scope = 'management group'; jobName = 'job_cleanup_managementGroup_deployments'; consumer = 'management-group-history' }
    ) {
        . ([scriptblock]::Create($configurationSteps[$consumer].run))
        $selected = Get-StepOutput
        $selected.subscriptionId | Should -Be $subscriptions[0].id
        $env:TEST_SUBSCRIPTIONS = $selected.subscriptions
        $script:historyRequests = [System.Collections.Generic.List[object]]::new()
        $script:historyQueries = [System.Collections.Generic.List[string]]::new()
        Mock Invoke-RestMethod {
            $script:historyQueries.Add($Uri)
            [pscustomobject]@{
                value = @(
                    foreach ($record in @(
                            @{ name = 'old-failed'; state = 'Failed'; days = 30 }
                            @{ name = 'recent-failed'; state = 'Failed'; days = 1 }
                            @{ name = 'old-running'; state = 'Running'; days = 30 }
                            @{ name = 'recent-running'; state = 'Running'; days = 1 }
                            @{ name = 'succeeded'; state = 'Succeeded'; days = 1 }
                            @{ name = 'cancelled'; state = 'Canceled'; days = 1 }
                        )) {
                        [pscustomobject]@{
                            name       = $record.name
                            properties = [pscustomobject]@{
                                provisioningState = $record.state
                                timestamp         = [datetime]::UtcNow.AddDays(-$record.days).ToString('o')
                            }
                        }
                    }
                )
            }
        } -ParameterFilter { $Method -eq 'GET' }
        Mock Invoke-RestMethod {
            foreach ($request in (($Body | ConvertFrom-Json).requests)) {
                $script:historyRequests.Add($request)
            }
        } -ParameterFilter { $Method -eq 'POST' -and $Uri -eq 'https://management.azure.com/batch?api-version=2020-06-01' }
        $step = $cleanupWorkflow.jobs[$jobName].steps | Where-Object { $_.name -eq 'Remove deployments' }
        $script = $step.with.inlineScript.Replace('${{ (fromJson(needs.job_initialize_pipeline.outputs.workflowInput)).maxDeploymentRetentionInDays }}', '14')
        if ($scope -eq 'management group') {
            $script = $script.Replace('${{ steps.get-test-subscriptions.outputs.managementGroupId }}', $selected.managementGroupId)
        }
        else {
            $step.env.TEST_SUBSCRIPTIONS | Should -Be '${{ steps.get-test-subscriptions.outputs.subscriptions }}'
        }
        $script | Should -Not -Match '\$\{\{'

        $null = . ([scriptblock]::Create($script))

        $targets = $scope -eq 'subscription' ? @($subscriptions.id | ForEach-Object { "/subscriptions/$_" }) :
        @("/providers/Microsoft.Management/managementGroups/$($selected.managementGroupId)")
        $script:historyQueries.Count | Should -Be $targets.Count
        $script:historyRequests.Count | Should -Be (3 * $targets.Count)
        foreach ($target in $targets) {
            @($script:historyQueries | Where-Object { $_.StartsWith("https://management.azure.com$target/providers/Microsoft.Resources/deployments") }).Count | Should -Be 1
            foreach ($name in @('old-failed', 'succeeded', 'cancelled')) {
                @($script:historyRequests | Where-Object { $_.url -eq "$target/providers/Microsoft.Resources/deployments/${name}?api-version=2019-08-01" }).Count | Should -Be 1
            }
        }
        @($script:historyRequests.httpMethod | Sort-Object -Unique) | Should -Be @('DELETE')
        Should -Invoke Get-AzContext -Times 0 -Exactly
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
        if ($scope -eq 'subscription') {
            foreach ($id in $subscriptions.id) {
                Should -Invoke Set-AzContext -Times 1 -Exactly -ParameterFilter { $Subscription -eq $id }
            }
        }
    }
}
