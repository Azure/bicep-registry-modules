param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeDiscovery {
    $reserved = Get-Content -LiteralPath (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw |
        ConvertFrom-Json -AsHashtable
    $localRoutes = @(
        foreach ($modulePath in ($reserved.Keys | Sort-Object)) {
            @{ ModulePath = $modulePath; Tag = $reserved[$modulePath] }
        }
        @{ ModulePath = 'avm/res/network/route-table'; Tag = 'Dedicated' }
        @{ ModulePath = 'avm/res/network/route-table'; Tag = 'general' }
        @{ ModulePath = 'avm/res/network/route-table'; Tag = 'azure local' }
    )
    $hciRoutes = @($localRoutes | Where-Object { $_.Tag -ceq 'Azure Local' })
}

Describe 'Published module identity across local routes' {
    BeforeAll {
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $entryWorkflow = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.module.yml') -Raw | ConvertFrom-Yaml
        $deploymentWorkflow = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.template.module.deployment.yml') -Raw | ConvertFrom-Yaml
        $hciModule = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.template.hci.module.yml') -Raw | ConvertFrom-Yaml
        $consumer = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.template.hci.consumer.yml') -Raw | ConvertFrom-Yaml
        $preparation = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.template.hci.prepare.yml') -Raw | ConvertFrom-Yaml
        $history = Get-Content -LiteralPath (Join-Path $workflowRoot 'platform.deployment.history.cleanup.yml') -Raw | ConvertFrom-Yaml
        $deploymentAction = Get-Content -LiteralPath (
            Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        ) -Raw | ConvertFrom-Yaml
        $matrixAction = Get-Content -LiteralPath (
            Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-getModuleDeploymentMatrix' 'action.yml'
        ) -Raw | ConvertFrom-Yaml
        $reference = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.res.network.route-table.yml') -Raw | ConvertFrom-Yaml
        $toolsRef = $reference.jobs.'call-workflow-passing-data'.with.'tools-ref'
        $toolsRef | Should -MatchExactly '^[0-9a-f]{40}$'
        $identityUses = "Azure/azure-verified-modules-tools/.github/actions/bicep-module-identity@$toolsRef"
        $toolsRoot = Join-Path $TestDrive 'published-tools'
        $supportFiles = @{
            '.github/actions/bicep-module-identity/action.yml' = 'f399911c2d8d11e3f2f98224a26aef0fa9906f1a'
            'scripts/bicep-workflows/Deployment.ps1' = 'bd1e99ee9d014e27d1f22bfd1c45ac1fad63d2ca'
            'scripts/bicep-workflows/Common.ps1' = 'fe306502f3c398b3b0fae3a122f37f0c3d88c6b0'
            'repository-management/shared/TestTenant.ps1' = 'f4dfdc661effda75e0d9e241fa19dae005c40c1d'
            'repository-management/shared/GroupSettings.ps1' = '26610c2e5ee72e4e7c001d61fdf03b229c95c2ee'
        }
        foreach ($relativePath in $supportFiles.Keys) {
            $destination = Join-Path $toolsRoot $relativePath
            $null = New-Item -Path (Split-Path -Parent $destination) -ItemType Directory -Force
            Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Azure/azure-verified-modules-tools/$toolsRef/$relativePath" -OutFile $destination -ErrorAction Stop
            $bytes = [IO.File]::ReadAllBytes($destination)
            $blob = [Text.Encoding]::UTF8.GetBytes("blob $($bytes.Length)`0") + $bytes
            [Convert]::ToHexString([Security.Cryptography.SHA1]::HashData($blob)).ToLowerInvariant() |
                Should -BeExactly $supportFiles[$relativePath]
        }
        $actionPath = Join-Path $toolsRoot '.github' 'actions' 'bicep-module-identity'
        $identityAction = Get-Content -LiteralPath (Join-Path $actionPath 'action.yml') -Raw | ConvertFrom-Yaml
        $identityScript = [scriptblock]::Create($identityAction.runs.steps[0].run)
        $partitionScript = [scriptblock]::Create(
            ($entryWorkflow.jobs.job_initialize_pipeline.steps | Where-Object id -EQ 'partition-module-matrix').run
        )
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleDeploymentMatrix.ps1')
        $environmentVariables = @(
            'GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'AVM_ACTION_PATH', 'MODULE_PATH', 'MODULE_MATRIX',
            'VALIDATE_MODULE_CLIENT_IDS', 'VALIDATE_TENANT_ID', 'VALIDATE_CLIENT_ID', 'AZURE_CREDENTIALS',
            'HCI_STAGE', 'INITIAL_IDENTITY_KEY', 'CURRENT_IDENTITY_KEY', 'DEPLOYMENT_MATRIX'
        )
        $expectedClientId = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
        $expectedTenantId = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
        $expectedSubscriptionId = 'cccccccc-cccc-cccc-cccc-cccccccccccc'

        function Read-TestOutputs {
            $values = @{}
            foreach ($line in Get-Content -LiteralPath $env:GITHUB_OUTPUT) {
                if ($line) {
                    $key, $value = $line.Split('=', 2)
                    $values.Add($key, $value)
                }
            }
            return $values
        }

        function Invoke-PublishedIdentity {
            Clear-Content -LiteralPath $env:GITHUB_OUTPUT
            . $identityScript
            Read-TestOutputs
        }

        function Assert-MappedJob {
            param([System.Collections.IDictionary] $Job, [string] $ModuleExpression)

            $identity = @($Job.steps | Where-Object id -EQ 'module-identity')
            $identity.Count | Should -Be 1
            $identity[0].uses | Should -BeExactly $identityUses
            @($identity[0].with.Keys | Sort-Object) | Should -Be @('moduleClientIds', 'modulePath', 'tenantId')
            $identity[0].with.modulePath | Should -BeExactly $ModuleExpression
            $identity[0].with.moduleClientIds | Should -Be '${{ vars.VALIDATE_MODULE_CLIENT_IDS }}'
            $identity[0].with.tenantId | Should -Be '${{ vars.VALIDATE_TENANT_ID || secrets.VALIDATE_TENANT_ID }}'
            if ($identity[0].Contains('if')) {
                $identity[0].if | Should -Be '${{ !fromJson(inputs.testCase).e2eIgnore }}'
            }
            ($Job | ConvertTo-Json -Depth 50) | Should -Not -Match '(vars|secrets)\.VALIDATE_CLIENT_ID|AZURE_CREDENTIALS'
            foreach ($step in @($Job.steps | Where-Object {
                        $_.uses -like 'azure/login@*' -or $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment'
                    })) {
                [array]::IndexOf($Job.steps, $identity[0]) | Should -BeLessThan ([array]::IndexOf($Job.steps, $step))
                $step.if | Should -Not -Match '\b(always|failure|cancelled|success)\('
                if ($step.uses -like 'azure/login@*') {
                    $step.with.'client-id' | Should -Be '${{ steps.module-identity.outputs.clientId }}'
                    $step.with.'tenant-id' | Should -Be '${{ steps.module-identity.outputs.tenantId }}'
                    $step.with.'enable-AzPSSession' | Should -BeTrue
                } else {
                    $step.env.VALIDATE_CLIENT_ID | Should -Be '${{ steps.module-identity.outputs.clientId }}'
                    $step.env.VALIDATE_TENANT_ID | Should -Be '${{ steps.module-identity.outputs.tenantId }}'
                }
            }
        }

        function Invoke-TestAuthentication {
            param(
                [System.Collections.IDictionary] $Job,
                [string] $ModuleExpression = '${{ inputs.modulePath }}'
            )

            $resolved = Invoke-PublishedIdentity
            Assert-MappedJob -Job $Job -ModuleExpression $ModuleExpression
            foreach ($step in $Job.steps) {
                if ($step.uses -like 'azure/login@*') {
                    Invoke-TestLogin -ClientId $resolved.clientId -TenantId $resolved.tenantId -SubscriptionId $expectedSubscriptionId
                } elseif ($step.uses -eq './.github/actions/templates/avm-validateModuleDeployment') {
                    foreach ($login in @($deploymentAction.runs.steps | Where-Object { $_.uses -like 'azure/login@*' })) {
                        $login.with.'client-id' | Should -Be '${{ env.VALIDATE_CLIENT_ID }}'
                        $login.with.'tenant-id' | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
                        $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
                        $login.with.'enable-AzPSSession' | Should -BeTrue
                        Invoke-TestLogin -ClientId $resolved.clientId -TenantId $resolved.tenantId -SubscriptionId $expectedSubscriptionId
                    }
                }
            }
            return $resolved
        }

        function Invoke-TestLogin {
            param([string] $ClientId, [string] $TenantId, [string] $SubscriptionId)
            throw 'A real authentication operation must never run in these tests.'
        }

        function Set-TestModule {
            param([string] $ModulePath, [string] $Tag)

            $testFolder = Join-Path $fixtureRoot $ModulePath 'tests' 'e2e' 'defaults'
            $null = New-Item -Path $testFolder -ItemType Directory -Force
            Set-Content -LiteralPath (Join-Path $testFolder 'main.test.bicep') -Value '' -NoNewline
            @{ $ModulePath = $Tag } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $fixtureRoot '.reserved-test-subscriptions.json')
            $env:MODULE_PATH = $ModulePath
            $env:VALIDATE_MODULE_CLIENT_IDS = @{ $ModulePath = $expectedClientId } | ConvertTo-Json -Compress
        }
    }

    BeforeEach {
        $savedExitCode = $global:LASTEXITCODE
        $savedEnvironment = @{}
        foreach ($environmentVariable in $environmentVariables) {
            $savedEnvironment[$environmentVariable] = [Environment]::GetEnvironmentVariable($environmentVariable)
        }
        $fixtureRoot = Join-Path $TestDrive 'caller'
        $scripts = Join-Path $fixtureRoot 'utilities' 'pipelines' 'sharedScripts'
        $null = New-Item -Path $scripts -ItemType Directory -Force
        Copy-Item -LiteralPath (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionTag.ps1') -Destination $scripts
        $env:GITHUB_WORKSPACE = $fixtureRoot
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'identity-output.txt'
        Set-Content -LiteralPath $env:GITHUB_OUTPUT -Value '' -NoNewline
        $env:AVM_ACTION_PATH = $actionPath
        $env:MODULE_PATH = 'avm/res/network/route-table'
        $null = New-Item -Path (Join-Path $fixtureRoot $env:MODULE_PATH 'child' 'deep' 'entry') -ItemType Directory -Force
        $env:VALIDATE_MODULE_CLIENT_IDS = @{ $env:MODULE_PATH = $expectedClientId } | ConvertTo-Json -Compress
        $env:VALIDATE_TENANT_ID = $expectedTenantId
        $env:VALIDATE_CLIENT_ID = 'legacy-client-must-not-be-used'
        $env:AZURE_CREDENTIALS = '{"clientId":"legacy-credential-must-not-be-used"}'
        Mock Invoke-TestLogin {}
        Mock bicep {
            $global:LASTEXITCODE = 0
            '{"$schema":"https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#","resources":[]}'
        }
    }

    AfterEach {
        $global:LASTEXITCODE = $savedExitCode
        foreach ($environmentVariable in $environmentVariables) {
            [Environment]::SetEnvironmentVariable($environmentVariable, $savedEnvironment[$environmentVariable])
        }
    }

    It 'runs the published action without a native package, source fallback or Azure login' {
        @($identityAction.inputs.Keys | Sort-Object) | Should -Be @('moduleClientIds', 'modulePath', 'tenantId')
        @($identityAction.outputs.Keys | Sort-Object) | Should -Be @('clientId', 'identityKey', 'moduleRoot', 'tenantId')
        $identityAction.runs.steps.Count | Should -Be 1
        ($identityAction | ConvertTo-Json -Depth 20) | Should -Not -Match 'azure/login|avm-authoring-version|src/Avm'
        Test-Path -LiteralPath (Join-Path $toolsRoot 'src') | Should -BeFalse

        $identity = Invoke-PublishedIdentity

        $identity.clientId | Should -BeExactly $expectedClientId
        $identity.tenantId | Should -BeExactly $expectedTenantId
        $identity.moduleRoot | Should -BeExactly $env:MODULE_PATH
        $identity.identityKey | Should -MatchExactly '^[0-9a-f]{64}$'
        Should -Invoke Invoke-TestLogin -Times 0 -Exactly
    }

    It 'rejects active generic deployment before authentication for <ModulePath> with tag <Tag>' -ForEach $localRoutes {
        Set-TestModule -ModulePath $ModulePath -Tag $Tag
        $env:MODULE_MATRIX = @{ include = @(@{ modulePath = $ModulePath }) } | ConvertTo-Json -Depth 5 -Compress
        . $partitionScript
        $partitions = Read-TestOutputs
        $partitions.hasSharedModules | Should -BeExactly 'false'
        $selectedModule = (ConvertFrom-Json $partitions.localModuleMatrix -AsHashtable).include[0].modulePath
        $selectedModule | Should -BeExactly $ModulePath
        $matrixAction.inputs.expectedSubscriptionTag.default | Should -BeExactly 'General'
        @($deploymentWorkflow.jobs.Keys) | Should -Be @('job_module_deploy_validation')
        $deploymentWorkflow.jobs.job_module_deploy_validation.ContainsKey('if') | Should -BeFalse

        {
            Get-ModuleDeploymentMatrix -ModulePath $selectedModule -RepoRoot $fixtureRoot -RandomSeed 0 `
                -TestSubscriptionIds (ConvertTo-Json -InputObject @(@{ id = $expectedSubscriptionId; name = 'reserved'; tag = $Tag }) -Compress) `
                -TestFilePaths @(@{ path = 'tests/e2e/defaults/main.test.bicep'; name = 'defaults'; e2eIgnore = $false })
            Invoke-TestAuthentication -Job $deploymentWorkflow.jobs.job_module_deploy_validation
        } | Should -Throw '*Use the module''s dedicated workflow*'

        Should -Invoke bicep -Times 0 -Exactly
        Should -Invoke Invoke-TestLogin -Times 0 -Exactly
    }

    It 'binds every dedicated login and renewal for <ModulePath>' -ForEach $hciRoutes {
        Set-TestModule -ModulePath $ModulePath -Tag $Tag
        $selectionStep = $hciModule.jobs.job_initialize_subscription_selection.steps | Where-Object id -EQ 'deployment-matrix'
        $selectionStep.with.expectedSubscriptionTag | Should -BeExactly 'Azure Local'
        $hciModule.jobs.job_module_deploy_validation.uses | Should -Be './.github/workflows/avm.template.hci.consumer.yml'
        $matrix = Get-ModuleDeploymentMatrix -ModulePath $ModulePath -RepoRoot $fixtureRoot -RandomSeed 0 `
            -ExpectedSubscriptionTag $selectionStep.with.expectedSubscriptionTag `
            -TestSubscriptionIds (ConvertTo-Json -InputObject @(@{ id = $expectedSubscriptionId; name = 'reserved'; tag = $Tag }) -Compress) `
            -TestFilePaths @(@{ path = 'tests/e2e/defaults/main.test.bicep'; name = 'defaults'; e2eIgnore = $false })
        $matrix.testCases[0].ContainsKey('environmentConcurrencyGroup') | Should -BeFalse
        $env:DEPLOYMENT_MATRIX = ConvertTo-Json -InputObject $matrix.testCases -Depth 10 -Compress
        $lockStep = $hciModule.jobs.job_initialize_subscription_selection.steps | Where-Object id -EQ 'hci-matrix'
        . ([scriptblock]::Create($lockStep.run))
        $routedCases = ConvertFrom-Json (Read-TestOutputs).deploymentMatrix -AsHashtable -NoEnumerate
        ($routedCases -is [array]) | Should -BeTrue
        $routedCases.Count | Should -Be 1
        $case = $routedCases[0]
        $case.subscriptionIndex | Should -Be 0
        $case.environmentConcurrencyGroup | Should -Be "avm-hci-$($case.subscriptionKey)"
        $consumer.concurrency.group | Should -Be '${{ fromJson(inputs.testCase).environmentConcurrencyGroup }}'

        $identity = Invoke-TestAuthentication -Job $consumer.jobs.job_module_deploy_validation

        $identity.moduleRoot | Should -BeExactly $ModulePath
        Should -Invoke Invoke-TestLogin -Times 3 -Exactly -ParameterFilter {
            $ClientId -ceq $expectedClientId -and $TenantId -ceq $expectedTenantId -and $SubscriptionId -ceq $expectedSubscriptionId
        }
    }

    It 'resolves an arbitrary-depth descendant through the published root mapping' {
        $root = $env:MODULE_PATH
        $env:MODULE_PATH = "$root/child/deep/entry"

        $identity = Invoke-TestAuthentication -Job $deploymentWorkflow.jobs.job_module_deploy_validation

        $identity.moduleRoot | Should -BeExactly $root
        Should -Invoke Invoke-TestLogin -Times 2 -Exactly
    }

    It 'rejects <Kind> without any authentication or legacy fallback' -ForEach @(
        @{ Kind = 'a missing map'; Mapping = '' }
        @{ Kind = 'an empty map'; Mapping = '{}' }
        @{ Kind = 'malformed JSON'; Mapping = '{' }
        @{ Kind = 'a missing root'; Mapping = '{"avm/res/storage/storage-account":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"}' }
        @{ Kind = 'a zero client'; Mapping = '{"avm/res/network/route-table":"00000000-0000-0000-0000-000000000000"}' }
        @{ Kind = 'a nested identity'; Mapping = '{"avm/res/network/route-table":{"clientId":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"}}' }
        @{ Kind = 'duplicate clients'; Mapping = '{"avm/res/network/route-table":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","avm/res/storage/storage-account":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"}' }
        @{ Kind = 'duplicate roots'; Mapping = '{"avm/res/network/route-table":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa","avm/res/network/route-table":"cccccccc-cccc-cccc-cccc-cccccccccccc"}' }
        @{ Kind = 'an unsupported mapping root'; Mapping = '{"avm/res/network/route-table/child":"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"}' }
    ) {
        $env:VALIDATE_MODULE_CLIENT_IDS = $Mapping
        foreach ($job in @($deploymentWorkflow.jobs.job_module_deploy_validation, $consumer.jobs.job_module_deploy_validation)) {
            { Invoke-TestAuthentication -Job $job } | Should -Throw
            (Get-Item -LiteralPath $env:GITHUB_OUTPUT).Length | Should -Be 0
        }
        Should -Invoke Invoke-TestLogin -Times 0 -Exactly
    }

    It 'rejects an invalid tenant before any authentication' {
        $env:VALIDATE_TENANT_ID = '00000000-0000-0000-0000-000000000000'

        { Invoke-TestAuthentication -Job $deploymentWorkflow.jobs.job_module_deploy_validation } | Should -Throw

        Should -Invoke Invoke-TestLogin -Times 0 -Exactly
        (Get-Item -LiteralPath $env:GITHUB_OUTPUT).Length | Should -Be 0
    }

    It 'binds preparation and reserved maintenance to their existing module selectors' {
        Set-TestModule -ModulePath 'avm/res/azure-stack-hci/logical-network' -Tag 'Azure Local'
        foreach ($job in $preparation.jobs.Values) {
            $identity = Invoke-TestAuthentication -Job $job -ModuleExpression 'avm/res/azure-stack-hci/logical-network'
            $identity.moduleRoot | Should -BeExactly $env:MODULE_PATH
            ($job.steps | Where-Object name -EQ 'Advance the recorded preparation operation').env.VALIDATE_TENANT_ID |
                Should -Be '${{ steps.module-identity.outputs.tenantId }}'
            $guard = $job.steps | Where-Object name -EQ 'Keep the initial preparation identity'
            $login = $job.steps | Where-Object { $_.uses -like 'azure/login@*' }
            [array]::IndexOf($job.steps, $guard) | Should -BeLessThan ([array]::IndexOf($job.steps, $login))
        }
        Set-TestModule -ModulePath 'avm/res/azure-stack-hci/cluster' -Tag 'Azure Local'
        $identity = Invoke-TestAuthentication -Job $history.jobs.job_cleanup_reserved_deployments -ModuleExpression 'avm/res/azure-stack-hci/cluster'
        $identity.moduleRoot | Should -BeExactly $env:MODULE_PATH
        ($history.jobs.job_cleanup_reserved_deployments.steps | Where-Object name -EQ 'Clean history only with confirmed idle ownership').env.VALIDATE_TENANT_ID |
            Should -Be '${{ steps.module-identity.outputs.tenantId }}'
        Should -Invoke Invoke-TestLogin -Times 10 -Exactly -ParameterFilter {
            $ClientId -ceq $expectedClientId -and $TenantId -ceq $expectedTenantId -and $SubscriptionId -ceq $expectedSubscriptionId
        }
    }

    It 'rejects a changed or missing preparation identity before a continuation login' {
        $guard = $preparation.jobs.job_begin.steps | Where-Object name -EQ 'Keep the initial preparation identity'
        $script = [scriptblock]::Create($guard.run)
        $identity = Invoke-PublishedIdentity
        $env:HCI_STAGE = 'ImageObserve'
        $env:INITIAL_IDENTITY_KEY = $identity.identityKey
        $env:CURRENT_IDENTITY_KEY = $identity.identityKey
        { . $script } | Should -Not -Throw
        foreach ($changed in @('', ('0' * 64))) {
            $env:INITIAL_IDENTITY_KEY = $changed
            { . $script } | Should -Throw '*identity changed*'
        }
        $env:HCI_STAGE = 'Begin'
        { . $script } | Should -Not -Throw
        Should -Invoke Invoke-TestLogin -Times 0 -Exactly
    }
}
