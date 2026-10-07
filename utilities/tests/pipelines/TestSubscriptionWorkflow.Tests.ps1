[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Key Vault mocks use synthetic test values, not credentials.')]
param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Test subscription workflow integration' {

    BeforeDiscovery {
        $routingCases = foreach ($workflowName in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')) {
            foreach ($repository in @('Azure/bicep-registry-modules', 'contributor/bicep-registry-modules')) {
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
                            repository    = $repository
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
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-CIParameterMap.ps1')

        $workflows = @{}
        foreach ($workflowName in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')) {
            $workflowPath = Join-Path $repoRootPath '.github' 'workflows' "$workflowName.yml"
            $workflows[$workflowName] = ConvertFrom-Yaml -Yaml (Get-Content -Path $workflowPath -Raw)
        }
        $deploymentWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path (Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.deployment.yml') -Raw)
        $actionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -Path $actionPath -Raw)
        $selectionStep = $action.runs.steps | Where-Object { $_.id -eq 'get-test-subscription' }
        $matrixActionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-getModuleDeploymentMatrix' 'action.yml'
        $matrixAction = ConvertFrom-Yaml -Yaml (Get-Content -Path $matrixActionPath -Raw)
        $matrixStep = $matrixAction.runs.steps | Where-Object { $_.id -eq 'deployment-matrix' }
        $cleanupPath = Join-Path $repoRootPath '.github' 'workflows' 'platform.deployment.history.cleanup.yml'
        $cleanupWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $cleanupPath -Raw)
        $psrulePath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModulePSRule' 'action.yml'
        $psrule = ConvertFrom-Yaml -Yaml (Get-Content -Path $psrulePath -Raw)
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($psrule.runs.steps[0].with.inlineScript, [ref] $null, [ref] $null)
        $psruleSelection = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.IfStatementAst] -and $node.Extent.Text.StartsWith('if (-not [string]::IsNullOrEmpty($env:TEST_SUBSCRIPTION_IDS)') }, $true).Extent.Text
        $subscriptions = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'test-one' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'test-two' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'test-three' }
        )
        $subscriptionJson = ConvertTo-Json -InputObject $subscriptions -Compress
        $environmentNames = @(
            'GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'TEST_SUBSCRIPTION_IDS', 'VALIDATE_SUBSCRIPTION_ID',
            'SUBSCRIPTION_SELECTION_SEED', 'SUBSCRIPTION_JOB_INDEX', 'SELECTED_SUBSCRIPTION_ID',
            'PRESELECTED_SUBSCRIPTION_INDEX', 'PRESELECTED_SUBSCRIPTION_KEY',
            'MODULE_PATH', 'MODULE_TEST_FILE_PATHS', 'DISPLAY_SUBSCRIPTION_NAMES',
            'AZURE_CREDENTIALS', 'TEST_SUBSCRIPTIONS', 'AVM_TEST_TENANT',
            'VALIDATE_CLIENT_ID', 'VALIDATE_TENANT_ID', 'MANAGEMENT_GROUP_ID', 'CI_KEY_VAULT_NAME'
        )

        $poolExpression = '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
        $managementGroupExpression = '${{ vars.VALIDATE_MANAGEMENT_GROUP_ID || vars.ARM_MGMTGROUP_ID || secrets.VALIDATE_MANAGEMENT_GROUP_ID || secrets.ARM_MGMTGROUP_ID }}'

        function Resolve-TestSettingExpression {
            param([string] $Expression, [hashtable] $Context)

            if ($Expression -notmatch '^\$\{\{ ((?:vars|secrets)\.[A-Z_]+(?: \|\| (?:vars|secrets)\.[A-Z_]+)*) \}\}$') {
                throw "Unexpected setting expression: $Expression"
            }
            foreach ($setting in ($Matches[1] -split ' \|\| ')) {
                if (-not [string]::IsNullOrEmpty($Context[$setting])) {
                    return $Context[$setting]
                }
            }
            return ''
        }

        function Set-TestDeploymentEnvironment {
            param([hashtable] $Workflow, [hashtable] $Context)

            $Workflow.jobs.job_module_deploy_validation.uses | Should -Be './.github/workflows/avm.template.module.deployment.yml'
            $step = $deploymentWorkflow.jobs.job_module_deploy_validation.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }
            foreach ($name in $step.env.Keys) {
                [Environment]::SetEnvironmentVariable($name, (Resolve-TestSettingExpression -Expression $step.env[$name] -Context $Context))
            }
            $env:MANAGEMENT_GROUP_ID = Resolve-TestSettingExpression -Expression $step.with.managementGroupId -Context $Context
        }

        function Set-TestInitializationEnvironment {
            param([hashtable] $Workflow, [hashtable] $Context)

            $step = $Workflow.jobs.job_initialize_subscription_selection.steps | Where-Object { $_.id -eq 'deployment-matrix' }
            foreach ($name in $step.env.Keys) {
                [Environment]::SetEnvironmentVariable($name, (Resolve-TestSettingExpression -Expression $step.env[$name] -Context $Context))
            }
            $env:DISPLAY_SUBSCRIPTION_NAMES = [string] (
                -not [string]::IsNullOrEmpty($Context['vars.VALIDATE_SUBSCRIPTION_IDS']) -or
                -not [string]::IsNullOrEmpty($Context['vars.TEST_SUBSCRIPTION_IDS'])
            )
        }

        function Get-AzKeyVaultSecret {
            [CmdletBinding()]
            param([string] $VaultName, [string] $Name)
            throw 'Unexpected Key Vault access.'
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
        $savedExitCode = $global:LASTEXITCODE
        $savedEnvironment = @{}
        foreach ($environmentName in $environmentNames) {
            $savedEnvironment[$environmentName] = [Environment]::GetEnvironmentVariable($environmentName)
            [Environment]::SetEnvironmentVariable($environmentName, $null)
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
        $env:SELECTED_SUBSCRIPTION_ID = $subscriptions[0].id
        $env:MODULE_PATH = 'avm/res/example/module'
        $env:MODULE_TEST_FILE_PATHS = '[{"path":"tests/e2e/defaults/main.test.bicep","name":"defaults","e2eIgnore":false},{"path":"tests/e2e/max/main.test.bicep","name":"max","e2eIgnore":false}]'
        $routingContext = @{
            'vars.VALIDATE_SUBSCRIPTION_IDS'       = $subscriptionJson
            'vars.VALIDATE_CLIENT_ID'              = 'variable-client'
            'vars.VALIDATE_TENANT_ID'              = 'variable-tenant'
            'vars.VALIDATE_MANAGEMENT_GROUP_ID'    = 'variable-management-group'
            'vars.VALIDATE_SUBSCRIPTION_ID'        = '88888888-8888-8888-8888-888888888888'
            'vars.TEST_SUBSCRIPTION_IDS'           = '[{"id":"55555555-5555-5555-5555-555555555555","name":"variable-alias"}]'
            'vars.ARM_MGMTGROUP_ID'                = 'variable-alias-group'
            'vars.CI_KEY_VAULT_NAME'               = 'contributor-vault'
            'secrets.VALIDATE_CLIENT_ID'           = 'secret-client'
            'secrets.VALIDATE_TENANT_ID'           = 'secret-tenant'
            'secrets.VALIDATE_SUBSCRIPTION_IDS'    = '[{"id":"66666666-6666-6666-6666-666666666666","name":"secret-canonical"}]'
            'secrets.TEST_SUBSCRIPTION_IDS'        = '[{"id":"77777777-7777-7777-7777-777777777777","name":"secret-alias"}]'
            'secrets.VALIDATE_SUBSCRIPTION_ID'     = $env:VALIDATE_SUBSCRIPTION_ID
            'secrets.VALIDATE_MANAGEMENT_GROUP_ID' = 'secret-management-group'
            'secrets.ARM_MGMTGROUP_ID'             = 'secret-alias-group'
            'secrets.AZURE_CREDENTIALS'            = '{"clientId":"exception-client","tenantId":"variable-tenant","clientSecret":"synthetic-secret"}'
        }
        Mock Get-AzKeyVaultSecret { throw 'Unexpected Key Vault access.' }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock bicep {
            $global:LASTEXITCODE = 0
            '{"$schema":"https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#","resources":[]}'
        }
    }

    AfterEach {
        $global:LASTEXITCODE = $savedExitCode
        foreach ($environmentName in $environmentNames) {
            [Environment]::SetEnvironmentVariable($environmentName, $savedEnvironment[$environmentName])
        }
    }

    It 'Preselects subscriptions in the deployment environment before acquiring locks in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $workflow = $workflows[$workflowName]
        $initializer = $workflow.jobs.job_initialize_subscription_selection
        $caller = $workflow.jobs.job_module_deploy_validation
        $deployment = $deploymentWorkflow.jobs.job_module_deploy_validation
        $deploymentStep = $deployment.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }
        $initializationStep = $initializer.steps | Where-Object { $_.id -eq 'deployment-matrix' }

        $initializer.permissions.Count | Should -Be 1
        $initializer.permissions.contents | Should -Be 'read'
        $initializer.environment | Should -Be 'avm-validation'
        @($initializer.outputs.Keys | Sort-Object) | Should -Be @('deploymentMatrix', 'sharedScope')
        $initializer.outputs.deploymentMatrix | Should -Be '${{ steps.deployment-matrix.outputs.deploymentMatrix }}'
        $initializer.outputs.sharedScope | Should -Be '${{ steps.deployment-matrix.outputs.sharedScope }}'
        $initializer.ContainsKey('concurrency') | Should -BeFalse
        $initializationStep.uses | Should -Be './.github/actions/templates/avm-getModuleDeploymentMatrix'
        $initializationStep.env.TEST_SUBSCRIPTION_IDS | Should -Be $poolExpression
        $initializationStep.env.VALIDATE_SUBSCRIPTION_ID | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_ID || secrets.VALIDATE_SUBSCRIPTION_ID }}'
        $initializationStep.with.displaySubscriptionNames | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_IDS != '''' || vars.TEST_SUBSCRIPTION_IDS != '''' }}'
        $initializer.steps[0].uses | Should -Match '^actions/checkout@'
        $initializer.steps[1].uses | Should -Be './.github/actions/templates/avm-setEnvironment'
        $initializer.if | Should -Match "deploymentValidation == 'true'"
        $caller.needs | Should -Contain 'job_initialize_subscription_selection'
        $caller.if | Should -Match "needs.job_initialize_subscription_selection.result == 'success'"
        $caller.secrets | Should -Be 'inherit'
        $caller.with.testCase | Should -Be '${{ toJSON(matrix.testCases) }}'
        ($workflow | ConvertTo-Json -Depth 20) | Should -Not -Match 'TEST_BAMI_|AVM_TEST_TENANT|VALIDATE_PERSISTENT_SUBSCRIPTION_ID'
        ($action | ConvertTo-Json -Depth 20) | Should -Not -Match 'TEST_BAMI_|AVM_TEST_TENANT|github\.repository'
        ($psrule | ConvertTo-Json -Depth 20) | Should -Not -Match 'TEST_BAMI_|AVM_TEST_TENANT|github\.repository'
        $workflow.env.ARM_MGMTGROUP_ID | Should -Be $managementGroupExpression
        $deploymentWorkflow.env.ARM_MGMTGROUP_ID | Should -Be $managementGroupExpression
        $deploymentStep.with.managementGroupId | Should -Be $managementGroupExpression
        $selectionStep.env.MANAGEMENT_GROUP_ID | Should -Be '${{ inputs.managementGroupId }}'
        $deploymentStep.env.TEST_SUBSCRIPTION_IDS | Should -Be $poolExpression
        $deploymentStep.env.VALIDATE_CLIENT_ID | Should -Be '${{ vars.VALIDATE_CLIENT_ID || secrets.VALIDATE_CLIENT_ID }}'
        $deploymentStep.env.VALIDATE_TENANT_ID | Should -Be '${{ vars.VALIDATE_TENANT_ID || secrets.VALIDATE_TENANT_ID }}'
        $deploymentStep.env.VALIDATE_SUBSCRIPTION_ID | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_ID || secrets.VALIDATE_SUBSCRIPTION_ID }}'
        $deploymentStep.env.AZURE_CREDENTIALS | Should -Be '${{ secrets.AZURE_CREDENTIALS }}'
        $deploymentStep.env.CI_KEY_VAULT_NAME | Should -Be '${{ vars.CI_KEY_VAULT_NAME }}'
        $deployment.environment | Should -Be 'avm-validation'
        @($deployment.env.Keys) | Should -Not -Contain 'VALIDATE_CLIENT_ID'
        foreach ($jobName in @('job_psrule_must', 'job_psrule_opt')) {
            $step = $workflow.jobs[$jobName].steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModulePSRule' }
            $step.with.managementGroupId | Should -Be $managementGroupExpression
            $step.env.VALIDATE_TENANT_ID | Should -Be $deploymentStep.env.VALIDATE_TENANT_ID
            $step.env.VALIDATE_SUBSCRIPTION_ID | Should -Be $deploymentStep.env.VALIDATE_SUBSCRIPTION_ID
            $step.env.TEST_SUBSCRIPTION_IDS | Should -Be $poolExpression
        }
        $caller.strategy.matrix.testCases | Should -Be '${{ fromJson(needs.job_initialize_subscription_selection.outputs.deploymentMatrix) }}'
        $deploymentStep.with.subscriptionIndex | Should -Be '${{ fromJson(inputs.testCase).subscriptionIndex }}'
        $deploymentStep.with.subscriptionKey | Should -Be '${{ fromJson(inputs.testCase).subscriptionKey }}'
        $deploymentStep.with.ContainsKey('subscriptionSelectionSeed') | Should -BeFalse
        $deploymentStep.with.ContainsKey('subscriptionJobIndex') | Should -BeFalse
        $selectionStep.env.PRESELECTED_SUBSCRIPTION_INDEX | Should -Be '${{ inputs.subscriptionIndex }}'
        $selectionStep.env.PRESELECTED_SUBSCRIPTION_KEY | Should -Be '${{ inputs.subscriptionKey }}'
    }

    It 'Keeps selection identical through initialization and execution for each configuration source in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        foreach ($source in @(
                'vars.VALIDATE_SUBSCRIPTION_IDS', 'vars.TEST_SUBSCRIPTION_IDS',
                'secrets.VALIDATE_SUBSCRIPTION_IDS', 'secrets.TEST_SUBSCRIPTION_IDS',
                'vars.VALIDATE_SUBSCRIPTION_ID', 'secrets.VALIDATE_SUBSCRIPTION_ID'
            )) {
            Clear-Content -Path $env:GITHUB_OUTPUT
            Set-TestInitializationEnvironment -Workflow $workflows[$workflowName] -Context $routingContext
            $records = @(Get-TestSubscriptionList -TestSubscriptionIds $env:TEST_SUBSCRIPTION_IDS -FallbackSubscriptionId $env:VALIDATE_SUBSCRIPTION_ID)

            . ([scriptblock]::Create($matrixStep.run))
            (Get-StepOutput).sharedScope | Should -Be 'false'
            $matrixOutput = (Get-StepOutput).deploymentMatrix
            $matrix = @($matrixOutput | ConvertFrom-Json -AsHashtable)

            $matrix.Count | Should -Be 2
            foreach ($entry in $matrix) {
                $selected = $records[$entry.subscriptionIndex]
                $entry.subscriptionKey | Should -BeExactly $selected.key
                $entry.concurrencyGroup | Should -Be "avm-deploy-avm/res/example/module-$($selected.key)"
                if ($source -like 'vars.*SUBSCRIPTION_IDS') {
                    $entry.subscriptionName | Should -BeExactly $selected.name
                } else {
                    $entry.subscriptionName | Should -Match '^Configured subscription \d+$'
                    foreach ($record in $records) {
                        $matrixOutput | Should -Not -Match ([regex]::Escape($record.id))
                        $matrixOutput | Should -Not -Match ([regex]::Escape($record.name))
                    }
                }

                Clear-Content -Path $env:GITHUB_OUTPUT
                Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext
                $env:PRESELECTED_SUBSCRIPTION_INDEX = [string] $entry.subscriptionIndex
                $env:PRESELECTED_SUBSCRIPTION_KEY = $entry.subscriptionKey
                $env:SUBSCRIPTION_SELECTION_SEED = 'not-used'
                $env:SUBSCRIPTION_JOB_INDEX = 'not-used'
                . ([scriptblock]::Create($selectionStep.run))
                (Get-StepOutput).subscriptionId | Should -BeExactly $selected.id
            }
            $routingContext.Remove($source)
        }
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
    }

    It 'Rejects reordered or replaced preselected records without login outputs or reselection' -ForEach @(
        @{ mutation = 'reordered' }
        @{ mutation = 'replaced' }
    ) {
        $record = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson)[1]
        $env:PRESELECTED_SUBSCRIPTION_INDEX = [string] $record.index
        $env:PRESELECTED_SUBSCRIPTION_KEY = $record.key
        $changed = @($subscriptions[1], $subscriptions[0], $subscriptions[2])
        if ($mutation -eq 'replaced') {
            $changed = @($subscriptions[0], $subscriptions[2])
        }
        $env:TEST_SUBSCRIPTION_IDS = ConvertTo-Json -InputObject $changed -Compress

        $errorRecord = { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw '*no longer matches the preselected subscription identity*' -PassThru

        (Get-StepOutput).Count | Should -Be 0
        $errorRecord.Exception.Message | Should -Not -Match $record.id
    }

    It 'Rejects incomplete or invalid preselection rather than falling back to random assignment' -ForEach @(
        @{ index = ''; key = 'expected'; errorMessage = '*preselected subscription index is invalid*' }
        @{ index = '0'; key = ''; errorMessage = '*preselected subscription identity*' }
        @{ index = '-1'; key = 'expected'; errorMessage = '*preselected subscription index is invalid*' }
        @{ index = '3'; key = 'expected'; errorMessage = '*preselected subscription index is invalid*' }
        @{ index = 'invalid'; key = 'expected'; errorMessage = '*preselected subscription index is invalid*' }
    ) {
        $env:PRESELECTED_SUBSCRIPTION_INDEX = $index
        $env:PRESELECTED_SUBSCRIPTION_KEY = $key

        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw $errorMessage
        (Get-StepOutput).Count | Should -Be 0
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

    It 'Uses generic variables for <modulePath> in <repository> through <workflowName> despite the <selectorName> retired selector' -ForEach $routingCases {
        $routingContext['github.repository'] = $repository
        $routingContext['inputs.modulePath'] = $modulePath
        $routingContext['vars.TEST_BAMI_MODULE_PATHS'] = $selectorValue
        Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext

        . ([scriptblock]::Create($selectionStep.run))

        (Get-StepOutput).subscriptionId | Should -BeIn $subscriptions.id
        $env:VALIDATE_CLIENT_ID | Should -Be 'variable-client'
        $env:VALIDATE_TENANT_ID | Should -Be 'variable-tenant'
        $env:MANAGEMENT_GROUP_ID | Should -Be 'variable-management-group'
        $env:VALIDATE_SUBSCRIPTION_ID | Should -Be '88888888-8888-8888-8888-888888888888'
        $env:AZURE_CREDENTIALS | Should -Be $routingContext['secrets.AZURE_CREDENTIALS']
        $env:CI_KEY_VAULT_NAME | Should -Be 'contributor-vault'
    }

    It 'Supports identifiers supplied only as secrets in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        foreach ($key in @($routingContext.Keys | Where-Object { $_ -like 'vars.*' })) {
            $routingContext.Remove($key)
        }
        Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext

        . ([scriptblock]::Create($selectionStep.run))

        (Get-StepOutput).subscriptionId | Should -Be '66666666-6666-6666-6666-666666666666'
        $env:VALIDATE_CLIENT_ID | Should -Be 'secret-client'
        $env:VALIDATE_TENANT_ID | Should -Be 'secret-tenant'
        $env:MANAGEMENT_GROUP_ID | Should -Be 'secret-management-group'
        $env:VALIDATE_SUBSCRIPTION_ID | Should -Be $routingContext['secrets.VALIDATE_SUBSCRIPTION_ID']
        $env:AZURE_CREDENTIALS | Should -Be $routingContext['secrets.AZURE_CREDENTIALS']
    }

    It 'Supports variable-only identifiers but never reads credentials from variables in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        foreach ($key in @($routingContext.Keys | Where-Object { $_ -like 'secrets.*' })) {
            $routingContext.Remove($key)
        }
        Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext

        . ([scriptblock]::Create($selectionStep.run))

        (Get-StepOutput).subscriptionId | Should -BeIn $subscriptions.id
        $env:VALIDATE_CLIENT_ID | Should -Be 'variable-client'
        $env:VALIDATE_TENANT_ID | Should -Be 'variable-tenant'
    }

    It 'Prefers variables across aliases, then canonical secrets, then legacy secrets in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        foreach ($expected in @(
                @{ removePool = 'vars.VALIDATE_SUBSCRIPTION_IDS'; removeGroup = 'vars.VALIDATE_MANAGEMENT_GROUP_ID'; id = '55555555-5555-5555-5555-555555555555'; group = 'variable-alias-group' }
                @{ removePool = 'vars.TEST_SUBSCRIPTION_IDS'; removeGroup = 'vars.ARM_MGMTGROUP_ID'; id = '66666666-6666-6666-6666-666666666666'; group = 'secret-management-group' }
                @{ removePool = 'secrets.VALIDATE_SUBSCRIPTION_IDS'; removeGroup = 'secrets.VALIDATE_MANAGEMENT_GROUP_ID'; id = '77777777-7777-7777-7777-777777777777'; group = 'secret-alias-group' }
                @{ removePool = 'secrets.TEST_SUBSCRIPTION_IDS'; removeGroup = 'secrets.ARM_MGMTGROUP_ID'; id = '88888888-8888-8888-8888-888888888888'; group = '' }
            )) {
            $routingContext.Remove($expected.removePool)
            $routingContext.Remove($expected.removeGroup)
            Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext
            Clear-Content -Path $env:GITHUB_OUTPUT
            . ([scriptblock]::Create($selectionStep.run))
            (Get-StepOutput).subscriptionId | Should -Be $expected.id
            $env:MANAGEMENT_GROUP_ID | Should -Be $expected.group
        }
        $routingContext.Remove('vars.VALIDATE_SUBSCRIPTION_ID')
        Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $routingContext
        Clear-Content -Path $env:GITHUB_OUTPUT
        . ([scriptblock]::Create($selectionStep.run))
        (Get-StepOutput).subscriptionId | Should -Be $routingContext['secrets.VALIDATE_SUBSCRIPTION_ID']
    }

    It 'Does not fall through a malformed preferred identifier to another source in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        foreach ($source in @('vars', 'secrets')) {
            foreach ($invalidPool in @('[invalid', ' ', '[]')) {
                $invalidContext = $routingContext.Clone()
                if ($source -eq 'secrets') {
                    $invalidContext.Remove('vars.VALIDATE_SUBSCRIPTION_IDS')
                    $invalidContext.Remove('vars.TEST_SUBSCRIPTION_IDS')
                }
                $invalidContext["$source.VALIDATE_SUBSCRIPTION_IDS"] = $invalidPool
                Set-TestDeploymentEnvironment -Workflow $workflows[$workflowName] -Context $invalidContext

                $env:TEST_SUBSCRIPTION_IDS | Should -BeExactly $invalidPool
                { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw
                (Get-StepOutput).Count | Should -Be 0
            }
        }
    }

    It 'Does not use historical provider settings when generic subscriptions are absent' {
        $retiredContext = @{
            'vars.TEST_BAMI_SUBSCRIPTION_IDS'    = $subscriptionJson
            'vars.TEST_BAMI_TENANT_ID'           = 'retired-tenant'
            'vars.TEST_BAMI_BICEP_CLIENT_ID'     = 'retired-client'
            'vars.TEST_BAMI_MANAGEMENT_GROUP_ID' = 'retired-group'
        }
        Set-TestDeploymentEnvironment -Workflow $workflows['avm.template.module'] -Context $retiredContext

        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw '*No test subscriptions configured*'
        (Get-StepOutput).Count | Should -Be 0
    }

    It 'Does not require an unrelated management group or persistent subscription for OIDC selection' {
        $env:MANAGEMENT_GROUP_ID = ''
        . ([scriptblock]::Create($selectionStep.run))

        (Get-StepOutput).subscriptionId | Should -BeIn $subscriptions.id
    }

    It 'Resolves a PSRule pool or singleton without requiring authentication or a management group' {
        $ConvertTokensInputs = @{ Tokens = @{ subscriptionId = 'static-token'; managementGroupId = '' } }
        $env:VALIDATE_CLIENT_ID = ''
        $env:VALIDATE_TENANT_ID = ''
        . ([scriptblock]::Create($psruleSelection))
        $ConvertTokensInputs.Tokens.subscriptionId | Should -Be $subscriptions[0].id

        $env:TEST_SUBSCRIPTION_IDS = ''
        . ([scriptblock]::Create($psruleSelection))
        $ConvertTokensInputs.Tokens.subscriptionId | Should -Be $env:VALIDATE_SUBSCRIPTION_ID

        $env:VALIDATE_SUBSCRIPTION_ID = ''
        $ConvertTokensInputs.Tokens.subscriptionId = 'static-token'
        . ([scriptblock]::Create($psruleSelection))
        $ConvertTokensInputs.Tokens.subscriptionId | Should -Be 'static-token'
    }

    It 'Rejects a supplied invalid pool [<pool>] without falling back for deployment or PSRule' -ForEach @(
        @{ pool = ' ' }
        @{ pool = '[invalid' }
        @{ pool = '[]' }
        @{ pool = '{}' }
        @{ pool = '[{"id":"invalid","name":"test"}]' }
    ) {
        $env:TEST_SUBSCRIPTION_IDS = $pool
        $ConvertTokensInputs = @{ Tokens = @{ subscriptionId = 'static-token' } }

        { . ([scriptblock]::Create($selectionStep.run)) } | Should -Throw
        { . ([scriptblock]::Create($psruleSelection)) } | Should -Throw
        (Get-StepOutput).Count | Should -Be 0
        $ConvertTokensInputs.Tokens.subscriptionId | Should -Be 'static-token'
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
            $login.with.'client-id' | Should -Be '${{ env.VALIDATE_CLIENT_ID }}'
            $login.with.'tenant-id' | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
            $login.if | Should -Be "env.skip_deployment_ci == 'false'"
        }
        foreach ($stepName in @('Replace tokens in template file', 'Deploy template file', 'Remove deployed resources')) {
            $step = $action.runs.steps | Where-Object { $_.name -eq $stepName }
            $step.with.inlineScript | Should -Match ([regex]::Escape('${{ steps.get-test-subscription.outputs.subscriptionId }}'))
            $step.with.inlineScript | Should -Not -Match 'env\.VALIDATE_SUBSCRIPTION_ID'
        }
        foreach ($login in $defaultLogins) {
            [array]::IndexOf($action.runs.steps, $selectionStep) | Should -BeLessThan ([array]::IndexOf($action.runs.steps, $login))
        }
    }

    It 'Keeps the Key Vault warning and GitHub secret over variable over vault precedence after generic binding' {
        Set-TestDeploymentEnvironment -Workflow $workflows['avm.template.module'] -Context $routingContext
        $warningStep = $action.runs.steps | Where-Object { $_.name -eq 'Warn about CI Key Vault deprecation' }
        $messages = @(. ([scriptblock]::Create($warningStep.run)))
        Mock Get-AzKeyVaultSecret {
            if (-not $Name) {
                return @(@{ Name = 'CI-adminSecret' }, @{ Name = 'CI-region' }, @{ Name = 'CI-vaultOnly' })
            }
            return @{ SecretValue = ConvertTo-SecureString -String 'vault-value' -AsPlainText -Force }
        }
        $parameters = Get-CIParameterMap -TemplateParameters @{
            adminSecret = @{ type = 'secureString' }
            region      = @{ type = 'string' }
            vaultOnly   = @{ type = 'secureString' }
        } -GitHubVariables '{"CI_ADMIN_SECRET":"variable-value","CI_REGION":"eastus"}' `
            -GitHubSecrets '{"CI_ADMINSECRET":"secret-value"}' -KeyVaultName $env:CI_KEY_VAULT_NAME

        $messages | Should -Match '^::warning'
        ($messages | Out-String) | Should -Not -Match 'contributor-vault|secret-value|variable-value|vault-value'
        ConvertFrom-SecureString -SecureString $parameters.adminSecret -AsPlainText | Should -Be 'secret-value'
        $parameters.region | Should -Be 'eastus'
        ConvertFrom-SecureString -SecureString $parameters.vaultOnly -AsPlainText | Should -Be 'vault-value'
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $VaultName -eq 'contributor-vault' -and -not $Name }
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $VaultName -eq 'contributor-vault' -and $Name -eq 'CI-vaultOnly' }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -eq 'CI-adminSecret' -or $Name -eq 'CI-region' }
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
