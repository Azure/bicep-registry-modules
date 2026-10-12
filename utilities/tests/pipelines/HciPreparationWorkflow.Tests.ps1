param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'Reserved Azure Local workflow and fixture wiring' {
    BeforeAll {
        function Get-ParameterExpression($Parameter) {
            if ($Parameter -is [string]) { return $Parameter }
            return $Parameter.value
        }
        Import-Module powershell-yaml -ErrorAction Stop
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $manual = Get-Content (Join-Path $workflowRoot 'platform.hci.prepare.yml') -Raw | ConvertFrom-Yaml
        $prepare = Get-Content (Join-Path $workflowRoot 'avm.template.hci.prepare.yml') -Raw | ConvertFrom-Yaml
        $step = Get-Content (Join-Path $workflowRoot 'avm.template.hci.prepare.step.yml') -Raw | ConvertFrom-Yaml
        $consumer = Get-Content (Join-Path $workflowRoot 'avm.template.hci.consumer.yml') -Raw | ConvertFrom-Yaml
        $deployment = Get-Content (Join-Path $workflowRoot 'avm.template.module.deployment.yml') -Raw | ConvertFrom-Yaml
        $action = Get-Content (Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw | ConvertFrom-Yaml
        $roots = (Get-Content (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw | ConvertFrom-Json -AsHashtable).Keys
        $compiled = @{}
        foreach ($root in $roots) {
            foreach ($file in Get-ChildItem (Join-Path $RepoRootPath $root 'tests' 'e2e') -Filter 'main.test.bicep' -Recurse) {
                $output = Join-Path $TestDrive "$($compiled.Count).json"
                $diagnostics = bicep build $file.FullName --no-restore --outfile $output 2>&1
                if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
                $key = [IO.Path]::GetRelativePath($RepoRootPath, $file.FullName).Replace('\', '/')
                $compiled[$key] = Get-Content $output -Raw | ConvertFrom-Json -AsHashtable
            }
        }
        $assetRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci'
        $environment = Get-Content (Join-Path $assetRoot 'environment.json') -Raw | ConvertFrom-Json -AsHashtable
        foreach ($file in @('foundation.bicep', 'hciHostGalleryBuilder.bicep', 'test-key-vault.bicep')) {
            $output = Join-Path $TestDrive "$file.json"
            $diagnostics = bicep build (Join-Path $assetRoot $file) --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $compiled[$file] = Get-Content $output -Raw | ConvertFrom-Json -AsHashtable
        }
    }

    It 'Serializes setup and consumers on the same cross-module environment lock while preserving existing locks' {
        $wrapper = $deployment.jobs.job_hci_environment
        $wrapper.concurrency.group | Should -Be '${{ fromJson(inputs.testCase).environmentConcurrencyGroup }}'
        $wrapper.concurrency.queue | Should -Be 'max'
        $wrapper.concurrency.Contains('cancel-in-progress') | Should -BeFalse
        $wrapper.uses | Should -Be './.github/workflows/avm.template.hci.consumer.yml'
        $consumer.jobs.job_module_deploy_validation.needs | Should -Be 'job_check_cleanup'
        $consumer.jobs.job_module_deploy_validation.concurrency.group | Should -Be '${{ fromJson(inputs.testCase).concurrencyGroup }}'
        $deployment.jobs.job_module_deploy_validation.concurrency.group | Should -Be '${{ fromJson(inputs.testCase).concurrencyGroup }}'
        $manual.jobs.job_prepare_environment.concurrency.group | Should -Be '${{ needs.job_select_subscription.outputs.environmentConcurrencyGroup }}'
        $manual.jobs.job_prepare_environment.concurrency.queue | Should -Be 'max'
        foreach ($job in $prepare.jobs.Values) { $job.Contains('concurrency') | Should -BeFalse }
        foreach ($job in $step.jobs.Values) { $job.Contains('concurrency') | Should -BeFalse }
    }

    It 'Preserves the outer shared-scope locks of all legacy and experimental callers' -ForEach @(
        @{ file = 'avm.template.module.yml' }
        @{ file = 'avm.template.module.preview.yml' }
        @{ file = 'avm.template.module.publish.yml' }
    ) {
        $caller = Get-Content (Join-Path $workflowRoot $file) -Raw | ConvertFrom-Yaml
        $caller.jobs.job_module_deploy_validation.concurrency.group | Should -Match "sharedScope == 'true'"
        $caller.jobs.job_module_deploy_validation.concurrency.queue | Should -Be 'max'
        $caller.jobs.job_module_deploy_validation.uses | Should -Be './.github/workflows/avm.template.module.deployment.yml'
    }

    It 'Defaults recreation off and exposes it only through manual preparation' {
        $manual.on.workflow_dispatch.inputs.recreate.default | Should -BeFalse
        $prepare.on.workflow_call.inputs.recreate.default | Should -BeFalse
        $consumer.jobs.Contains('job_prepare_environment') | Should -BeFalse
        $manual.jobs.job_prepare_environment.with.maintenance | Should -BeTrue
        $consumer.jobs.job_check_cleanup.steps[0].run | Should -Match 'require cleanup'
    }

    It 'Allows shared provisioning only from dedicated manual setup, never from ordinary consumers' {
        @($manual.on.Keys) | Should -Be @('workflow_dispatch')
        $manual.jobs.job_prepare_environment.uses | Should -Be './.github/workflows/avm.template.hci.prepare.yml'
        $manual.jobs.job_prepare_environment.with.maintenance | Should -BeTrue
        foreach ($job in $prepare.jobs.Values) {
            $job.with.maintenance | Should -Be '${{ inputs.maintenance }}'
        }
        foreach ($file in Get-ChildItem $workflowRoot -Filter '*.yml') {
            $workflow = Get-Content $file.FullName -Raw | ConvertFrom-Yaml
            foreach ($job in $workflow.jobs.Values) {
                if ($job.uses -eq './.github/workflows/avm.template.hci.prepare.yml') {
                    $file.Name | Should -Be 'platform.hci.prepare.yml'
                }
            }
        }
        $consumerText = $consumer | ConvertTo-Json -Depth 30
        $consumerText | Should -Not -Match 'avm\.template\.hci\.prepare|Invoke-HciPreparationStep|Start-HciEnvironment|RefreshKubernetes'
        $deployScript = ($action.runs.steps | Where-Object id -EQ deploy_step).with.inlineScript
        $deployScript | Should -Not -Match 'Invoke-HciPreparationStep|Start-HciEnvironment|RefreshKubernetes|Initialize-KubernetesVersionReadiness'
        $deployScript | Should -Match 'Enter-HciEnvironmentTest'
    }

    It 'Splits long operations into dedicated hosted-runner jobs with explicit ordered handoffs' {
        $step.jobs.job_hci_prepare_step.'timeout-minutes' | Should -Be 330
        $step.jobs.job_hci_prepare_step.'runs-on' | Should -Be 'ubuntu-latest'
        $prepare.jobs.job_begin.with.stage | Should -Be 'Begin'
        $prepare.jobs.job_foundation_start.needs | Should -Be 'job_image_wait_3'
        $prepare.jobs.job_ready.needs | Should -Be 'job_foundation_wait_3'
        foreach ($index in 1..3) {
            $prepare.jobs["job_image_wait_$index"].with.stage | Should -Be 'ImageObserve'
            $prepare.jobs["job_foundation_wait_$index"].with.stage | Should -Be 'FoundationObserve'
            if ($index -gt 1) {
                $prepare.jobs["job_image_wait_$index"].needs | Should -Be "job_image_wait_$($index - 1)"
                $prepare.jobs["job_foundation_wait_$index"].needs | Should -Be "job_foundation_wait_$($index - 1)"
            }
        }
    }

    It 'Uses variable overrides before secrets, without transporting resource identities as cross-job outputs' {
        $selector = $step.jobs.job_hci_prepare_step.steps | Where-Object id -EQ subscription
        $selector.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
        $selector.run | Should -Match 'Get-HciTestSubscription'
        $step.jobs.job_hci_prepare_step.Contains('outputs') | Should -BeFalse
        $invoke = $step.jobs.job_hci_prepare_step.steps | Where-Object { $_.name -eq 'Advance the recorded preparation operation' }
        $invoke.with.inlineScript | Should -Match 'Invoke-HciPreparationStep'
        $invoke.with.inlineScript | Should -Match 'git rev-parse HEAD'
        $invoke.env.HCI_RUN_IDENTITY | Should -Be '${{ github.repository }}|${{ github.run_id }}|${{ github.run_attempt }}'
    }

    It 'Keeps history maintenance unfiltered while using the same canonical pool and identity bundle' {
        $history = Get-Content (Join-Path $workflowRoot 'platform.deployment.history.cleanup.yml') -Raw | ConvertFrom-Yaml
        foreach ($name in @('job_cleanup_subscription_deployments', 'job_cleanup_managementGroup_deployments')) {
            $select = $history.jobs[$name].steps | Where-Object id -EQ 'get-test-subscriptions'
            $select.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
            $select.run | Should -Not -Match '-ModulePath'
            $login = $history.jobs[$name].steps | Where-Object { $_.uses -like 'azure/login@*' }
            $login.with.'client-id' | Should -Be '${{ vars.VALIDATE_CLIENT_ID || secrets.VALIDATE_CLIENT_ID }}'
            $login.with.'tenant-id' | Should -Be '${{ vars.VALIDATE_TENANT_ID || secrets.VALIDATE_TENANT_ID }}'
        }
    }

    It 'Requires prepared inputs before deployment and bypasses the old gallery fallback with an immutable image' {
        $deployScript = ($action.runs.steps | Where-Object id -EQ deploy_step).with.inlineScript
        $deployScript | Should -Match 'Enter-HciEnvironmentTest'
        $deployScript | Should -Match 'Get-HciEnvironmentParameterMap'
        $deployScript | Should -Match 'ciParameters\.hciHostImageReferenceId = ConvertTo-SecureString \$hciResult\.ImageVersionResourceId'
        $deployScript.IndexOf('Enter-HciEnvironmentTest') | Should -BeLessThan $deployScript.IndexOf('Resolve-CIParameterFallback @')
        $deployScript | Should -Match 'ciParameters\.preparedHciEnvironment'
        $deployScript | Should -Match 'ProtectedResourceIds'
        $deployScript | Should -Match 'cannot override their per-run disposable resource group'
    }

    It 'Releases only after exact pending-history and strict resource removal, never on cancellation' {
        $cleanup = $action.runs.steps | Where-Object id -EQ remove-deployed-resources
        $cleanup.if | Should -Match '\(success\(\) \|\| failure\(\)\)'
        $cleanup.if | Should -Not -Match 'always\(\)'
        $script = $cleanup.with.inlineScript
        $script | Should -Match 'Wait-DeploymentRecordRemoval'
        $script | Should -Match 'RequireCompleteRemoval = \$true'
        $script | Should -Match 'Test-CleanupResourceAbsent -ResourceId \$hciContext\.TestResourceGroupId'
        $script | Should -Match 'ProtectedResourceIds'
        $script | Should -Match 'Exit-HciEnvironment -Context \$hciContext -CleanupConfirmed:\$true'
        $script.IndexOf('Test-CleanupResourceAbsent') | Should -BeLessThan $script.IndexOf('Exit-HciEnvironment')
    }

    It 'Keeps all sixteen target deployments active and makes only non-cluster foundations conditional' {
        $fixtures = @($compiled.Keys | Where-Object { $_ -like '*/main.test.bicep' })
        $fixtures.Count | Should -Be 16
        foreach ($path in $fixtures) {
            $template = $compiled[$path]
            $template.resources.testDeployment.Contains('condition') | Should -BeFalse
            if ($path -like 'avm/res/azure-stack-hci/cluster/*') {
                $template.parameters.Contains('preparedHciEnvironment') | Should -BeFalse
                $template.resources.nestedDependencies.Contains('condition') | Should -BeFalse
            } else {
                $template.parameters.Contains('preparedHciEnvironment') | Should -BeTrue
                $template.resources.nestedDependencies.condition | Should -Be "[equals(parameters('preparedHciEnvironment'), null())]"
                $template.resources.azlocal.condition | Should -Be "[equals(parameters('preparedHciEnvironment'), null())]"
                Get-ParameterExpression $template.resources.testDeployment.properties.parameters.customLocationResourceId |
                    Should -Match "parameters\('preparedHciEnvironment'\)"
            }
        }
    }

    It 'Compiles every reserved fixture from the Australia East shared configuration' {
        $environment.location | Should -BeExactly 'australiaeast'
        foreach ($path in @($compiled.Keys | Where-Object { $_ -like '*/main.test.bicep' })) {
            $source = Get-Content (Join-Path $RepoRootPath $path) -Raw
            $source | Should -Match ([regex]::Escape("loadJsonContent('../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/environment.json', 'location')"))
            $template = $compiled[$path]
            if ($template.parameters.Contains('enforcedLocation')) {
                $location = $template.parameters.enforcedLocation.defaultValue
                $template.resources.resourceGroup.location | Should -Be "[parameters('enforcedLocation')]"
            } else {
                $location = $template.variables.enforcedLocation
                $template.resources.resourceGroup.location | Should -Be "[variables('enforcedLocation')]"
            }
            if ($location -match "^\[variables\('(?<variable>[^']+)'\)\]$") {
                $location = $template.variables[$Matches.variable]
            }
            $location | Should -BeExactly $environment.location
            Get-ParameterExpression $template.resources.nestedDependencies.properties.parameters.location |
                Should -Be $template.resources.resourceGroup.location
        }
        foreach ($name in @('dependencies', 'cluster', 'network')) {
            Get-ParameterExpression $compiled['foundation.bicep'].resources[$name].properties.parameters.location |
                Should -Be "[parameters('location')]"
        }
        Get-ParameterExpression $compiled['foundation.bicep'].resources.dependencies.properties.template.resources.hciHostDeployment.properties.parameters.hostVMSize |
            Should -Be 'Standard_E48bds_v5'
    }

    It 'Keeps the compiled shared-region fixtures routed to reserved001 without changing generic pools' {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleDeploymentMatrix.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionList.ps1')
        Mock bicep {
            $key = [IO.Path]::GetRelativePath($RepoRootPath, $args[1]).Replace('\', '/')
            if (-not $compiled.ContainsKey($key)) { throw "Unexpected matrix compilation [$key]." }
            $global:LASTEXITCODE = 0
            $compiled[$key] | ConvertTo-Json -Depth 100 -Compress
        }
        $pool = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'sub-avm-test-001'; tag = 'Azure Local' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'sub-avm-test-002' }
        ) | ConvertTo-Json -Compress
        $reservedKey = (Get-TestSubscriptionList -FallbackSubscriptionId '11111111-1111-1111-1111-111111111111').key
        foreach ($root in $roots) {
            $files = @($compiled.Keys | Where-Object { $_ -like "$root/*/main.test.bicep" } | ForEach-Object {
                    @{
                        path = $_.Substring($root.Length + 1)
                        name = Split-Path (Split-Path $_) -Leaf
                        e2eIgnore = $false
                    }
                })
            $matrix = Get-ModuleDeploymentMatrix -ModulePath $root -TestFilePaths $files -TestSubscriptionIds $pool `
                -RandomSeed 42 -DisplaySubscriptionNames -RepoRoot $RepoRootPath
            $matrix.testCases.Count | Should -Be $files.Count
            foreach ($test in $matrix.testCases) {
                $test.subscriptionIndex | Should -Be 0
                $test.subscriptionName | Should -Be 'sub-avm-test-001'
                $test.subscriptionKey | Should -Be $reservedKey
                $test.environmentConcurrencyGroup | Should -Be "avm-hci-$reservedKey"
                $test.concurrencyGroup | Should -Be "avm-deploy-$root-$reservedKey"
                $test.e2eIgnore | Should -BeFalse
            }
        }
        $general = @(Get-TestSubscriptionList -TestSubscriptionIds $pool -ModulePath 'avm/res/storage/storage-account' -RepoRootPath $RepoRootPath)
        $general.Count | Should -Be 1
        $general[0].index | Should -Be 1
        $general[0].name | Should -Be 'sub-avm-test-002'
    }

    It 'Keeps AKS SSH-key resources and allocations in the disposable test group' {
        foreach ($scenario in @('defaults', 'max', 'waf-aligned')) {
            $template = $compiled["avm/res/hybrid-container-service/provisioned-cluster-instance/tests/e2e/$scenario/main.test.bicep"]
            $template.resources.testKeyVault.condition | Should -Be "[not(equals(parameters('preparedHciEnvironment'), null()))]"
            $template.resources.testKeyVault.resourceGroup | Should -Be "[parameters('resourceGroupName')]"
            $template.resources.logicalNetwork.resourceGroup | Should -Be "[parameters('resourceGroupName')]"
            $template.resources.azLocalInit.condition | Should -Be "[equals(parameters('preparedHciEnvironment'), null())]"
            Get-ParameterExpression $template.resources.testDeployment.properties.parameters.keyVaultName | Should -Match 'testKeyVault'
            Get-ParameterExpression $template.resources.logicalNetwork.properties.parameters.addressPrefix | Should -Match '172.20.0.0/24'
        }
        $vault = @($compiled['test-key-vault.bicep'].resources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')
        $vault.Count | Should -Be 1
        $vault[0].properties.enableRbacAuthorization | Should -BeTrue
        $max = $compiled['avm/res/hybrid-container-service/provisioned-cluster-instance/tests/e2e/max/main.test.bicep']
        Get-ParameterExpression $max.resources.testDeployment.properties.parameters.kubernetesVersion | Should -Match 'kubernetesVersion'
        Get-ParameterExpression $max.resources.testDeployment.properties.parameters.kubernetesVersion | Should -Not -Match '1\.29\.4'
    }

    It 'Uses one strict readiness implementation for prepared and cold AKS paths' {
        $scriptPath = Join-Path $assetRoot 'Initialize-KubernetesVersionReadiness.ps1'
        $source = Get-Content $scriptPath -Raw
        $defaults = $compiled['avm/res/hybrid-container-service/provisioned-cluster-instance/tests/e2e/defaults/main.test.bicep']
        $init = $defaults.resources.azLocalInit.properties.template
        $scripts = @($init.resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deploymentScripts' -and $_.name -like '*-aksarc-init*'
            })
        $scripts.Count | Should -Be 1
        $script = $scripts[0]
        $script.properties.scriptContent | Should -Match "^\[variables\('(?<variable>[^']+)'\)\]$"
        $null = $script.properties.scriptContent -match "^\[variables\('(?<variable>[^']+)'\)\]$"
        $init.variables[$Matches.variable].Replace("`r`n", "`n").Trim() | Should -Be $source.Replace("`r`n", "`n").Trim()
        $shared = Get-Content (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'HciTestEnvironment.ps1') -Raw
        $shared | Should -Match 'Initialize-KubernetesVersionReadiness\.ps1'
        $source | Should -Not -Match '-Method DELETE'
    }

    It 'Keeps the foundation and gallery permissions inside owned groups' {
        $foundation = $compiled['foundation.bicep']
        $foundation.resources.dependencies.properties.parameters.assignSubscriptionContributor.value | Should -BeFalse
        $builder = $compiled['hciHostGalleryBuilder.bicep']
        $builder.resources.imageBuilderRoleDefinition.condition | Should -Be "[not(parameters('useScopedContributorRole'))]"
        Get-ParameterExpression $builder.resources.imageTemplate.properties.parameters.stagingResourceGroupResourceId | Should -Match 'stagingResourceGroupName'
        $builder.resources.stagingRoleAssignment.resourceGroup | Should -Be "[parameters('stagingResourceGroupName')]"
        $foundation.parameters.generation | Should -Not -BeNullOrEmpty
    }
}
