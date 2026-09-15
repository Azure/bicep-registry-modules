param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Frozen test tenant workflow integration' {

    BeforeAll {
        $workflows = @{}
        foreach ($name in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish', 'avm.template.test-tenant')) {
            $workflows[$name] = ConvertFrom-Yaml -Yaml (Get-Content (Join-Path $repoRootPath '.github' 'workflows' "$name.yml") -Raw)
        }
        $actions = @{}
        foreach ($name in @('avm-applyTestTenant', 'avm-validateModuleDeployment', 'avm-validateModulePSRule')) {
            $actions[$name] = ConvertFrom-Yaml -Yaml (Get-Content (Join-Path $repoRootPath '.github' 'actions' 'templates' $name 'action.yml') -Raw)
        }
        $applyStep = $actions['avm-applyTestTenant'].runs.steps[0]
        $deploymentSteps = $actions['avm-validateModuleDeployment'].runs.steps
        $selectionStep = $deploymentSteps | Where-Object { $_.id -eq 'get-test-subscription' }
        $exceptionStep = $deploymentSteps | Where-Object { $_.id -eq 'set-oidc-exception' }
        $fixtureStep = $deploymentSteps | Where-Object { $_.name -eq 'Check BAMI fixture compatibility' }
        $settings = @{
            TEST_BAMI_TENANT_ID                  = '20000000-0000-0000-0000-000000000001'
            TEST_BAMI_BICEP_CLIENT_ID            = '30000000-0000-0000-0000-000000000001'
            TEST_BAMI_MANAGEMENT_GROUP_ID        = 'bami-root'
            TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID  = '40000000-0000-0000-0000-000000000001'
            TEST_BAMI_SUBSCRIPTION_IDS           = ConvertTo-Json -InputObject @(
                1..28 | ForEach-Object { @{ name = "test-$_"; id = '10000000-0000-0000-0000-{0:D12}' -f $_ } }
            ) -Compress
        }
        $environmentNames = @(
            'GITHUB_WORKSPACE', 'GITHUB_ENV', 'GITHUB_OUTPUT', 'AVM_TEST_TENANT', 'AVM_TEST_TENANT_SETTINGS',
            'VALIDATE_TENANT_ID', 'VALIDATE_CLIENT_ID', 'VALIDATE_SUBSCRIPTION_ID', 'TEST_SUBSCRIPTION_IDS',
            'ARM_MGMTGROUP_ID', 'TEST_PERSISTENT_SUBSCRIPTION_ID', 'AZURE_CREDENTIALS', 'CI_KEY_VAULT_NAME',
            'SUBSCRIPTION_SELECTION_SEED', 'SUBSCRIPTION_JOB_INDEX', 'SELECTED_SUBSCRIPTION_ID',
            'TEST_BAMI_MODULE_CONFIG', 'AVM_CI_VARIABLES', 'AVM_CI_SECRETS', 'AVM_TEST_TEMPLATE'
        ) + @($settings.Keys)

        function Get-ActionOutput {
            param([string] $Path = $env:GITHUB_OUTPUT)
            $outputs = @{}
            foreach ($line in (Get-Content -Path $Path)) {
                $name, $value = $line.Split('=', 2)
                $outputs[$name] = $value
            }
            return $outputs
        }

        function Set-FrozenTestContext {
            . ([scriptblock]::Create($applyStep.run))
            foreach ($entry in (Get-ActionOutput -Path $env:GITHUB_ENV).GetEnumerator()) {
                [Environment]::SetEnvironmentVariable($entry.Key, $entry.Value)
            }
        }

        function Convert-TokensInFileList {
            param([string[]] $FilePathList, [hashtable] $Tokens)
            throw 'Unexpected token replacement.'
        }
        function Get-LocallyReferencedFileList {
            param([string] $FilePath)
            throw 'Unexpected template access.'
        }
        function Initialize-DeploymentRemoval {
            param([string] $TemplateFilePath, [string[]] $DeploymentNames, [string] $ManagementGroupId, [string] $SubscriptionId)
            throw 'Unexpected Azure removal.'
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, $null)
        }
        $env:GITHUB_WORKSPACE = $repoRootPath
        $env:GITHUB_ENV = Join-Path $TestDrive 'environment.txt'
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'output.txt'
        $null = New-Item -ItemType File -Path $env:GITHUB_ENV, $env:GITHUB_OUTPUT -Force
        $env:AVM_TEST_TENANT = 'bami'
        $env:AVM_TEST_TENANT_SETTINGS = ConvertTo-Json -InputObject $settings -Compress
        $env:VALIDATE_TENANT_ID = 'legacy-tenant-secret'
        $env:VALIDATE_CLIENT_ID = 'legacy-client-secret'
        $env:VALIDATE_SUBSCRIPTION_ID = '50000000-0000-0000-0000-000000000001'
        $env:TEST_SUBSCRIPTION_IDS = '[{"name":"legacy","id":"50000000-0000-0000-0000-000000000002"}]'
        $env:ARM_MGMTGROUP_ID = 'legacy-management-group'
        $env:AZURE_CREDENTIALS = 'legacy-credentials'
        $env:CI_KEY_VAULT_NAME = 'legacy-vault'
        $env:SUBSCRIPTION_SELECTION_SEED = '12345'
        $env:SUBSCRIPTION_JOB_INDEX = '0'
        $env:AVM_CI_VARIABLES = '{}'
        $env:AVM_CI_SECRETS = '{}'
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'resolves the central projection once using the verified immutable Tools action and no secrets' {
        $initializer = $workflows['avm.template.test-tenant']
        $resolver = $initializer.jobs.resolve.steps | Where-Object { $_.id -eq 'test-tenant' }
        $resolver.uses | Should -Be 'Azure/azure-verified-modules-tools/repository-management/test-tenant/actions/resolve-test-tenant@c70eaed1f330c3b2e51de9db0b56a10205f38a03'
        $resolver.with.'module-path' | Should -Be '${{ inputs.modulePath }}'
        $resolver.with.'module-config' | Should -Be '${{ vars.TEST_BAMI_MODULE_CONFIG }}'
        $initializer.permissions.Count | Should -Be 0
        $initializer.jobs.resolve.ContainsKey('environment') | Should -BeFalse
        $initializer.jobs.resolve.outputs.testTenant | Should -Be '${{ steps.test-tenant.outputs.test-tenant }}'
        $initializer.jobs.resolve.outputs.settingsJson | Should -Be '${{ steps.test-tenant.outputs.settings-json }}'
        ($initializer | ConvertTo-Json -Depth 30) | Should -Not -Match 'secrets\.|azure/login|CONTROLLER|ADMIN_SUBSCRIPTION'

        $payload = $resolver.with.'bami-settings'
        foreach ($name in $settings.Keys) {
            $payload = $payload.Replace(('${{ toJSON(vars.' + $name + ') }}'), (ConvertTo-Json -InputObject $settings[$name] -Compress))
        }
        $values = ConvertFrom-Json -InputObject $payload -AsHashtable
        @($values.Keys | Sort-Object) | Should -Be @($settings.Keys | Sort-Object)
        foreach ($name in $settings.Keys) {
            $values[$name] | Should -BeOfType [string]
            $values[$name] | Should -BeExactly $settings[$name]
        }
    }

    It 'freezes context before all PSRule and deployment legs in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $workflow = $workflows[$workflowName]
        $initializer = $workflow.jobs.job_initialize_subscription_selection
        $initializer.uses | Should -Be './.github/workflows/avm.template.test-tenant.yml'
        $initializer.with.modulePath | Should -Be '${{ inputs.modulePath }}'
        $initializer.if | Should -Match "staticValidation == 'true'.*deploymentValidation == 'true'"
        $initializer.ContainsKey('secrets') | Should -BeFalse

        foreach ($jobName in @('job_psrule_must', 'job_psrule_opt', 'job_module_deploy_validation')) {
            $job = $workflow.jobs[$jobName]
            $job.needs | Should -Contain 'job_initialize_subscription_selection'
            $apply = @($job.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-applyTestTenant' })
            $apply.Count | Should -Be 1
            $apply[0].with.testTenant | Should -Be '${{ needs.job_initialize_subscription_selection.outputs.testTenant }}'
            $apply[0].with.settingsJson | Should -Be '${{ needs.job_initialize_subscription_selection.outputs.settingsJson }}'
            $job.steps[1] | Should -Be $apply[0]
            $validation = $job.steps | Where-Object { $_.uses -match 'avm-validateModule(PSRule|Deployment)$' }
            $validation.with.managementGroupId | Should -Be '${{ env.ARM_MGMTGROUP_ID }}'
        }

        $deployment = $workflow.jobs.job_module_deploy_validation
        $deployment.environment | Should -Be 'avm-validation'
        foreach ($name in @('AZURE_CREDENTIALS', 'VALIDATE_CLIENT_ID', 'VALIDATE_TENANT_ID', 'VALIDATE_SUBSCRIPTION_ID')) {
            $deployment.env[$name] | Should -Be ('${{ secrets.' + $name + ' }}')
        }
        $workflow.env.ARM_MGMTGROUP_ID | Should -Be '${{ secrets.ARM_MGMTGROUP_ID }}'
        $deployment.if | Should -Match "needs.job_initialize_subscription_selection.result == 'success'"
        $deployment.if | Should -Match '!cancelled\(\)'
        ($deployment.steps | Where-Object { $_.uses -match 'avm-validateModuleDeployment$' }).with.e2eIgnore |
            Should -Be '${{ matrix.testCases.e2eIgnore }}'
    }

    It 'leaves legacy secrets, subscription fallback, management group and vault untouched' {
        $env:AVM_TEST_TENANT = 'legacy'
        $env:AVM_TEST_TENANT_SETTINGS = '{}'
        $before = @{}
        foreach ($name in @('VALIDATE_TENANT_ID', 'VALIDATE_CLIENT_ID', 'VALIDATE_SUBSCRIPTION_ID', 'TEST_SUBSCRIPTION_IDS', 'ARM_MGMTGROUP_ID', 'AZURE_CREDENTIALS', 'CI_KEY_VAULT_NAME')) {
            $before[$name] = [Environment]::GetEnvironmentVariable($name)
        }

        Set-FrozenTestContext

        (Get-ActionOutput -Path $env:GITHUB_ENV).Count | Should -Be 1
        (Get-ActionOutput -Path $env:GITHUB_ENV).AVM_TEST_TENANT | Should -Be 'legacy'
        foreach ($name in $before.Keys) {
            [Environment]::GetEnvironmentVariable($name) | Should -BeExactly $before[$name]
        }
    }

    It 'applies the complete BAMI context and removes legacy credential and vault fallbacks' {
        Set-FrozenTestContext

        $env:VALIDATE_TENANT_ID | Should -Be $settings.TEST_BAMI_TENANT_ID
        $env:VALIDATE_CLIENT_ID | Should -Be $settings.TEST_BAMI_BICEP_CLIENT_ID
        $env:TEST_SUBSCRIPTION_IDS | Should -Be $settings.TEST_BAMI_SUBSCRIPTION_IDS
        $env:ARM_MGMTGROUP_ID | Should -Be $settings.TEST_BAMI_MANAGEMENT_GROUP_ID
        $env:TEST_PERSISTENT_SUBSCRIPTION_ID | Should -Be $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
        $env:VALIDATE_SUBSCRIPTION_ID | Should -Be ($settings.TEST_BAMI_SUBSCRIPTION_IDS | ConvertFrom-Json)[0].id
        $env:AZURE_CREDENTIALS | Should -BeNullOrEmpty
        $env:CI_KEY_VAULT_NAME | Should -BeNullOrEmpty
    }

    It 'does not reread changed candidate variables or module metadata after resolution' {
        foreach ($name in $settings.Keys) {
            [Environment]::SetEnvironmentVariable($name, 'changed-after-resolution')
        }
        $env:TEST_BAMI_MODULE_CONFIG = 'invalid-after-resolution'

        Set-FrozenTestContext

        $env:VALIDATE_TENANT_ID | Should -Be $settings.TEST_BAMI_TENANT_ID
        $env:TEST_SUBSCRIPTION_IDS | Should -Be $settings.TEST_BAMI_SUBSCRIPTION_IDS
        $applyStep.run | Should -Not -Match 'module-config|modulePath|Resolve-AvmTestTenant|vars\.|secrets\.'
    }

    It 'fails without exporting a partial context for selector <selector>' -ForEach @(
        @{ selector = '' }
        @{ selector = 'BAMI' }
        @{ selector = 'candidate' }
        @{ selector = 'true' }
    ) {
        $env:AVM_TEST_TENANT = $selector

        { Set-FrozenTestContext } | Should -Throw '*exactly legacy or bami*'
        (Get-Item $env:GITHUB_ENV).Length | Should -Be 0
    }

    It 'fails without legacy fallback for malformed frozen settings <json>' -ForEach @(
        @{ json = '{}' }
        @{ json = '[]' }
        @{ json = 'null' }
        @{ json = 'not-json' }
    ) {
        $env:AVM_TEST_TENANT_SETTINGS = $json

        { Set-FrozenTestContext } | Should -Throw
        (Get-Item $env:GITHUB_ENV).Length | Should -Be 0
    }

    It 'rejects a missing, non-string or multiline frozen value before writing any context' {
        foreach ($value in @($null, 123, "injected`nvalue")) {
            $invalid = $settings.Clone()
            $invalid.TEST_BAMI_MANAGEMENT_GROUP_ID = $value
            $env:AVM_TEST_TENANT_SETTINGS = ConvertTo-Json -InputObject $invalid -Compress

            { Set-FrozenTestContext } | Should -Throw '*missing or invalid*'
            (Get-Item $env:GITHUB_ENV).Length | Should -Be 0
        }
    }

    It 'rejects a mixed legacy and BAMI context' {
        $env:AVM_TEST_TENANT = 'legacy'

        { Set-FrozenTestContext } | Should -Throw '*must not contain BAMI settings*'
        (Get-Item $env:GITHUB_ENV).Length | Should -Be 0
    }

    It 'selects every deployment subscription only from the frozen 28-subscription pool' {
        Set-FrozenTestContext
        $selected = @(
            foreach ($index in 0..55) {
                Clear-Content $env:GITHUB_OUTPUT
                $env:SUBSCRIPTION_JOB_INDEX = [string] $index
                . ([scriptblock]::Create($selectionStep.run))
                (Get-ActionOutput).subscriptionId
            }
        )
        @($selected | Sort-Object -Unique).Count | Should -Be 28
        $selected[0..27] | Should -Be $selected[28..55]
        $poolIds = @($settings.TEST_BAMI_SUBSCRIPTION_IDS | ConvertFrom-Json).id
        foreach ($id in $selected) {
            $id | Should -BeIn $poolIds
            $id | Should -Not -Be $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
            $id | Should -Not -Match '^50000000-'
        }
    }

    It 'uses the frozen tenant, management group, subscription and fixture in <actionName> tokens' -ForEach @(
        @{ actionName = 'avm-validateModuleDeployment' }
        @{ actionName = 'avm-validateModulePSRule' }
    ) {
        Set-FrozenTestContext
        . ([scriptblock]::Create($selectionStep.run))
        $subscription = (Get-ActionOutput).subscriptionId
        $script = ($actions[$actionName].runs.steps | Where-Object { $_.name -eq 'Replace tokens in template file' }).with.inlineScript
        $script = $script -replace "(?m)^.*\. \(Join-Path.*'(Convert-TokensInFileList|Get-LocallyReferencedFileList)\.ps1'.*\)\r?\n", ''
        foreach ($replacement in @{
                '${{ inputs.templateFilePath }}'                         = 'unit.test.bicep'
                '${{ inputs.managementGroupId }}'                        = $env:ARM_MGMTGROUP_ID
                '${{ env.VALIDATE_TENANT_ID }}'                           = $env:VALIDATE_TENANT_ID
                '${{ env.VALIDATE_SUBSCRIPTION_ID }}'                     = $env:VALIDATE_SUBSCRIPTION_ID
                '${{ steps.get-test-subscription.outputs.subscriptionId }}' = $subscription
                '${{ env.TOKEN_NAMEPREFIX }}'                            = 'unit'
                '${{  inputs.customTokens }}'                            = ''
                '${{ inputs.customTokens }}'                             = ''
            }.GetEnumerator()) {
            $script = $script.Replace($replacement.Key, $replacement.Value)
        }
        Mock Get-LocallyReferencedFileList { @() }
        Mock Convert-TokensInFileList { $true }

        $null = . ([scriptblock]::Create($script))

        Should -Invoke Convert-TokensInFileList -Times 1 -Exactly -ParameterFilter {
            $Tokens.tenantId -eq $settings.TEST_BAMI_TENANT_ID -and
            $Tokens.managementGroupId -eq $settings.TEST_BAMI_MANAGEMENT_GROUP_ID -and
            $Tokens.persistentSubscriptionId -eq $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID -and
            $Tokens.subscriptionId -in @($settings.TEST_BAMI_SUBSCRIPTION_IDS | ConvertFrom-Json).id
        }
    }

    It 'keeps both logins and cleanup on the selected execution context' {
        Set-FrozenTestContext
        . ([scriptblock]::Create($selectionStep.run))
        $subscription = (Get-ActionOutput).subscriptionId
        $logins = @($deploymentSteps | Where-Object { $_.name -eq 'Azure Login - Default' })
        $logins.Count | Should -Be 2
        foreach ($login in $logins) {
            $login.with.'client-id' | Should -Be '${{ env.VALIDATE_CLIENT_ID }}'
            $login.with.'tenant-id' | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
        }
        $removal = $deploymentSteps | Where-Object { $_.name -eq 'Remove deployed resources' }
        $removal.if | Should -Match 'success\(\) \|\| failure\(\)'
        $script = $removal.with.inlineScript -replace "(?m)^.*\. \(Join-Path.*'Initialize-DeploymentRemoval\.ps1'.*\)\r?\n", ''
        $script = $script.Replace('${{ inputs.templateFilePath }}', 'unit.test.bicep').
            Replace('${{ steps.deploy_step.outputs.deploymentNames }}', '["unit-deployment"]').
            Replace('${{ inputs.managementGroupId }}', $env:ARM_MGMTGROUP_ID).
            Replace('${{ steps.get-test-subscription.outputs.subscriptionId }}', $subscription)
        $env:TEST_BAMI_MANAGEMENT_GROUP_ID = 'changed-after-deployment'
        $env:TEST_BAMI_SUBSCRIPTION_IDS = '[]'
        Mock Initialize-DeploymentRemoval {}

        $null = . ([scriptblock]::Create($script))

        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            $SubscriptionId -eq $subscription -and $ManagementGroupId -eq $settings.TEST_BAMI_MANAGEMENT_GROUP_ID
        }
    }

    It 'blocks the unsupported BAMI credential exception for <modulePath> before login' -ForEach @(
        @{ modulePath = 'avm/res/azure-stack-hci/cluster' }
        @{ modulePath = 'avm/res/azure-stack-hci/logical-network' }
        @{ modulePath = 'avm/res/azure-stack-hci/network-interface' }
        @{ modulePath = 'avm/res/azure-stack-hci/virtual-hard-disk' }
        @{ modulePath = 'avm/res/azure-stack-hci/virtual-machine-instance' }
        @{ modulePath = 'avm/res/hybrid-container-service/provisioned-cluster-instance' }
        @{ modulePath = 'avm/res/azure-stack-hci/cluster/tests/e2e/defaults/main.test.bicep' }
    ) {
        Set-FrozenTestContext
        $script = $exceptionStep.with.inlineScript.Replace('${{ inputs.modulePath }}', $modulePath)

        { . ([scriptblock]::Create($script)) } | Should -Throw '*Missing BAMI candidate authentication configuration*'
        (Get-Item $env:GITHUB_OUTPUT).Length | Should -Be 0
        [array]::IndexOf($deploymentSteps, $exceptionStep) |
            Should -BeLessThan ([array]::IndexOf($deploymentSteps, ($deploymentSteps | Where-Object { $_.uses -match '^azure/login@' } | Select-Object -First 1)))
    }

    It 'keeps the front-door canary on the normal OIDC and test path' {
        Set-FrozenTestContext
        $script = $exceptionStep.with.inlineScript.Replace('${{ inputs.modulePath }}', 'avm/res/network/front-door')

        $null = . ([scriptblock]::Create($script))

        (Get-ActionOutput).oidcException | Should -Be 'false'
        (Get-ActionOutput).ContainsKey('azureCredentials') | Should -BeFalse
        ($deploymentSteps | Where-Object { $_.name -eq 'Validate Test Execution' }).with.inlineScript |
            Should -Not -Match 'BAMI|AVM_TEST_TENANT'
    }

    It 'checks effective BAMI fixtures before subscription selection and login, never for legacy' {
        $fixtureStep.if | Should -Be "env.skip_deployment_ci == 'false' && env.AVM_TEST_TENANT == 'bami'"
        [array]::IndexOf($deploymentSteps, $fixtureStep) | Should -BeLessThan ([array]::IndexOf($deploymentSteps, $selectionStep))
        $fixtureStep.run | Should -Match 'Get-CIParameterMap @parameterInput'
        $fixtureStep.run | Should -Not -Match 'KeyVaultName|Get-Az|Connect-Az|secrets\.|vars\.'
    }

    It 'rejects an inherited legacy fixture secret even when its variable points into BAMI' {
        Set-FrozenTestContext
        $path = Join-Path $TestDrive 'fixture.test.json'
        @{ parameters = @{ networkResourceId = @{ type = 'secureString' } } } |
            ConvertTo-Json -Depth 5 | Set-Content $path
        $env:AVM_TEST_TEMPLATE = $path
        $env:AVM_CI_VARIABLES = '{"CI_NETWORKRESOURCEID":"/subscriptions/10000000-0000-0000-0000-000000000001/resourceGroups/bami"}'
        $env:AVM_CI_SECRETS = '{"CI_NETWORKRESOURCEID":"/subscriptions/50000000-0000-0000-0000-000000000001/resourceGroups/legacy"}'

        $script = $fixtureStep.run.Replace('Join-Path $env:GITHUB_WORKSPACE $env:AVM_TEST_TEMPLATE', '$env:AVM_TEST_TEMPLATE')
        { . ([scriptblock]::Create($script)) } | Should -Throw '*outside the frozen test/Persistent context*'
        (Get-Item $env:GITHUB_OUTPUT).Length | Should -Be 0
    }

    It 'allows neutral fixture credentials and ignores unused legacy fixture settings' {
        Set-FrozenTestContext
        $path = Join-Path $TestDrive 'credentials.test.json'
        @{ parameters = @{ apiKey = @{ type = 'secureString' } } } |
            ConvertTo-Json -Depth 5 | Set-Content $path
        $env:AVM_TEST_TEMPLATE = $path
        $env:AVM_CI_VARIABLES = '{"CI_CLIENTID":"unused-legacy-client"}'
        $env:AVM_CI_SECRETS = '{"CI_APIKEY":"not-a-real-key","CI_NETWORKRESOURCEID":"/subscriptions/50000000-0000-0000-0000-000000000001/resourceGroups/unused"}'

        $script = $fixtureStep.run.Replace('Join-Path $env:GITHUB_WORKSPACE $env:AVM_TEST_TEMPLATE', '$env:AVM_TEST_TEMPLATE')
        { . ([scriptblock]::Create($script)) } | Should -Not -Throw
    }

    It 'keeps actual front-door <testCase> fixtures compatible without Azure access' -ForEach @(
        @{ testCase = 'defaults' }
        @{ testCase = 'max' }
        @{ testCase = 'waf-aligned' }
    ) {
        Set-FrozenTestContext
        $env:AVM_TEST_TEMPLATE = "avm/res/network/front-door/tests/e2e/$testCase/main.test.bicep"
        $env:AVM_CI_SECRETS = '{"CI_NETWORKRESOURCEID":"/subscriptions/50000000-0000-0000-0000-000000000001/resourceGroups/unused"}'

        { . ([scriptblock]::Create($fixtureStep.run)) } | Should -Not -Throw
    }
}
