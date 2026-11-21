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
        $prepareSteps = $manual.jobs.job_begin.steps
        $consumer = Get-Content (Join-Path $workflowRoot 'avm.template.hci.consumer.yml') -Raw | ConvertFrom-Yaml
        $hciModule = Get-Content (Join-Path $workflowRoot 'avm.template.hci.module.yml') -Raw | ConvertFrom-Yaml
        $action = Get-Content (Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw | ConvertFrom-Yaml
        $consumerScript = Get-Content (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Invoke-HciTestConsumer.ps1') -Raw
        $roots = (Get-Content (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw | ConvertFrom-Json -AsHashtable).Keys
        $compiled = @{}
        foreach ($root in $roots) {
            foreach ($file in Get-ChildItem (Join-Path $RepoRootPath $root 'tests' 'e2e') -Filter 'main.test.bicep' -Recurse) {
                $output = Join-Path $TestDrive "$($compiled.Count).json"
                $diagnostics = bicep restore $file.FullName 2>&1
                if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
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
            $diagnostics = bicep restore (Join-Path $assetRoot $file) 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $diagnostics = bicep build (Join-Path $assetRoot $file) --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $compiled[$file] = Get-Content $output -Raw | ConvertFrom-Json -AsHashtable
        }
    }

    It 'Serializes setup and consumers on the same cross-module environment lock while preserving existing locks' {
        $wrapper = $hciModule.jobs.job_module_deploy_validation
        $consumer.concurrency.group | Should -Be '${{ fromJson(inputs.testCase).environmentConcurrencyGroup }}'
        $consumer.concurrency.queue | Should -Be 'max'
        $consumer.concurrency.Contains('cancel-in-progress') | Should -BeFalse
        $wrapper.uses | Should -Be './.github/workflows/avm.template.hci.consumer.yml'
        @($consumer.jobs.Keys) | Should -Be @('job_module_deploy_validation')
        $consumer.jobs.job_module_deploy_validation.concurrency.group | Should -Be '${{ fromJson(inputs.testCase).concurrencyGroup }}'
        foreach ($name in @(
                'job_bootstrap', 'job_begin', 'job_image_wait_1', 'job_image_wait_2', 'job_image_wait_3',
                'job_foundation_start', 'job_foundation_wait_1', 'job_foundation_wait_2',
                'job_foundation_wait_3', 'job_ready', 'job_status', 'job_teardown'
            )) {
            $manual.jobs[$name].concurrency.group | Should -Be '${{ needs.job_select_subscription.outputs.environmentConcurrencyGroup }}'
            $manual.jobs[$name].concurrency.queue | Should -Be 'max'
            $manual.jobs[$name].concurrency.Contains('cancel-in-progress') | Should -BeFalse
        }
    }

    It 'Exposes lifecycle operations only through the manual workflow' {
        @($manual.on.Keys) | Should -Be @('workflow_dispatch')
        $manual.on.workflow_dispatch.inputs.operation.default | Should -Be 'status'
        @($manual.on.workflow_dispatch.inputs.operation.options) | Should -Be @('status', 'prepare', 'teardown', 'recreate')
        @($manual.on.workflow_dispatch.inputs.Keys | Sort-Object) | Should -Be @('operation', 'subscriptionIndex')
        $consumer.jobs.Keys | Should -Not -Contain 'job_prepare_environment'
        $invoke = $prepareSteps | Where-Object name -EQ 'Advance the recorded lifecycle operation'
        $invoke.env.HCI_RECREATE | Should -Be '${{ inputs.operation == ''recreate'' && env.HCI_STAGE == ''Begin'' }}'
        $invoke.with.inlineScript | Should -Match ([regex]::Escape('-Maintenance:$true'))
    }

    It 'Checks cleanup in the consumer job before checkout, login or acquiring ownership' {
        $check = $consumer.jobs.job_module_deploy_validation.steps[0]
        $check.name | Should -Be 'Check cleanup policy'
        $check.env.REMOVE_DEPLOYMENT | Should -Be '${{ fromJson(inputs.workflowInput).removeDeployment }}'
        $saved = $env:REMOVE_DEPLOYMENT
        try {
            foreach ($value in @('', 'false', 'unknown')) {
                $env:REMOVE_DEPLOYMENT = $value
                { . ([scriptblock]::Create($check.run)) } | Should -Throw '*require cleanup*'
            }
            foreach ($value in @('true', 'True', 'TRUE')) {
                $env:REMOVE_DEPLOYMENT = $value
                { . ([scriptblock]::Create($check.run)) } | Should -Not -Throw
            }
        } finally {
            $env:REMOVE_DEPLOYMENT = $saved
        }
    }

    It 'Keeps lifecycle setup in one manual workflow and reserved consumption in dedicated wrappers' {
        @(Get-ChildItem $workflowRoot -Filter 'avm.template.hci.*.yml' | Sort-Object Name | ForEach-Object Name) |
            Should -Be @('avm.template.hci.consumer.yml', 'avm.template.hci.module.yml')
        foreach ($job in $manual.jobs.Values) {
            $job.Contains('uses') | Should -BeFalse
        }
    }

    It 'Allows shared provisioning only from dedicated manual setup, never from ordinary consumers' {
        @($manual.on.Keys) | Should -Be @('workflow_dispatch')
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
        $deployScript | Should -Not -Match 'Hci|Azure Local|Resolve-CIParameterFallback'
        $consumerScript | Should -Match 'Enter-HciEnvironmentTest'
        $consumerScript | Should -Not -Match 'Start-HciEnvironment|RefreshKubernetes|Initialize-KubernetesVersionReadiness'
    }

    It 'Splits long operations into dedicated hosted-runner jobs with explicit ordered handoffs' {
        $preparationJobs = @(
            'job_begin', 'job_image_wait_1', 'job_image_wait_2', 'job_image_wait_3',
            'job_foundation_start', 'job_foundation_wait_1', 'job_foundation_wait_2',
            'job_foundation_wait_3', 'job_ready'
        )
        foreach ($name in $preparationJobs) {
            $job = $manual.jobs[$name]
            $job.'timeout-minutes' | Should -Be 330
            $job.'runs-on' | Should -Be 'ubuntu-latest'
            $job.environment | Should -Be 'avm-validation'
            $job.permissions.contents | Should -Be 'read'
            $job.permissions.'id-token' | Should -Be 'write'
            ($job.steps | ConvertTo-Json -Depth 20 -Compress) |
                Should -Be ($prepareSteps | ConvertTo-Json -Depth 20 -Compress)
        }
        $manual.jobs.job_begin.env.HCI_STAGE | Should -Be 'Begin'
        $manual.jobs.job_bootstrap.env.HCI_STAGE | Should -Be 'Bootstrap'
        $manual.jobs.job_bootstrap.'timeout-minutes' | Should -Be 60
        $manual.jobs.job_bootstrap.needs | Should -Be 'job_select_subscription'
        $manual.jobs.job_begin.needs | Should -Contain 'job_select_subscription'
        $manual.jobs.job_begin.needs | Should -Contain 'job_bootstrap'
        $manual.jobs.job_image_wait_1.needs | Should -Contain 'job_begin'
        $manual.jobs.job_foundation_wait_1.needs | Should -Contain 'job_foundation_start'
        $manual.jobs.job_foundation_start.needs | Should -Contain 'job_image_wait_3'
        $manual.jobs.job_foundation_start.env.HCI_STAGE | Should -Be 'FoundationStart'
        $manual.jobs.job_ready.needs | Should -Contain 'job_foundation_wait_3'
        $manual.jobs.job_ready.env.HCI_STAGE | Should -Be 'Ready'
        foreach ($index in 1..3) {
            $manual.jobs["job_image_wait_$index"].env.HCI_STAGE | Should -Be 'ImageObserve'
            $manual.jobs["job_foundation_wait_$index"].env.HCI_STAGE | Should -Be 'FoundationObserve'
            if ($index -gt 1) {
                $manual.jobs["job_image_wait_$index"].needs | Should -Contain "job_image_wait_$($index - 1)"
                $manual.jobs["job_foundation_wait_$index"].needs | Should -Contain "job_foundation_wait_$($index - 1)"
            }
        }
        $manual.jobs.job_status.env.HCI_STAGE | Should -Be 'Status'
        $manual.jobs.job_status.'timeout-minutes' | Should -Be 30
        $manual.jobs.job_teardown.env.HCI_STAGE | Should -Be 'Teardown'
        $manual.jobs.job_teardown.'timeout-minutes' | Should -Be 180
        foreach ($name in $preparationJobs + @('job_bootstrap', 'job_status', 'job_teardown')) {
            $manual.jobs[$name].outputs.environmentGeneration | Should -Be '${{ steps.lifecycle.outputs.environmentGeneration }}'
            $manual.jobs[$name].outputs.environmentState | Should -Be '${{ steps.lifecycle.outputs.environmentState }}'
        }
    }

    It 'Uses variable overrides before secrets, without transporting resource identities as cross-job outputs' {
        $selector = $prepareSteps | Where-Object id -EQ subscription
        $selector.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
        $selector.run | Should -Match ([regex]::Escape("Get-HciTestSubscription -ModulePath 'avm/res/azure-stack-hci/logical-network'"))
        $invoke = $prepareSteps | Where-Object { $_.name -eq 'Advance the recorded lifecycle operation' }
        $invoke.with.inlineScript | Should -Match ([regex]::Escape('Invoke-HciPreparationStep -Stage $env:HCI_STAGE'))
        $invoke.with.inlineScript | Should -Match ([regex]::Escape("-ModulePath 'avm/res/azure-stack-hci/logical-network'"))
        $invoke.with.inlineScript | Should -Match 'git rev-parse HEAD'
        $invoke.env.HCI_RUN_IDENTITY | Should -Be '${{ github.repository }}|${{ github.run_id }}|${{ github.run_attempt }}'
        $invoke.env.HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT | Should -Be '${{ vars.HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT || secrets.HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT }}'
        $invoke.env.CI_KEY_VAULT_NAME | Should -Be '${{ vars.CI_KEY_VAULT_NAME }}'
        $invoke.with.inlineScript | Should -Match ([regex]::Escape('-ReceiptStorageAccountName $env:HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT'))
        $invoke.with.inlineScript | Should -Match ([regex]::Escape('-KeyVaultName $env:CI_KEY_VAULT_NAME'))
        $invoke.id | Should -Be 'lifecycle'
        $invoke.with.inlineScript | Should -Match '-ClientId \$env:VALIDATE_CLIENT_ID'
        $invoke.env.VALIDATE_CLIENT_ID | Should -Be '${{ vars.VALIDATE_CLIENT_ID || secrets.VALIDATE_CLIENT_ID }}'
        $invoke.with.inlineScript | Should -Match 'environmentGeneration=\$\(\$result\.Generation\)'
        $invoke.with.inlineScript | Should -Match 'environmentState=\$\(\$result\.State\)'
        $invoke.with.inlineScript | Should -Match 'storageAccountResourceId=\$\(\$result\.StorageAccountResourceId\)'
        $invoke.with.inlineScript | Should -Match 'storageContainerResourceId=\$\(\$result\.StorageContainerResourceId\)'
        $manual.jobs.job_bootstrap.outputs.storageAccountResourceId | Should -Be '${{ steps.lifecycle.outputs.storageAccountResourceId }}'
        $manual.jobs.job_bootstrap.outputs.storageContainerResourceId | Should -Be '${{ steps.lifecycle.outputs.storageContainerResourceId }}'
    }

    It 'Masks the subscription, tenant, client and receipt identifiers before signing in' {
        $jobSteps = @{ prepare = @($prepareSteps); consumer = @($consumer.jobs.job_module_deploy_validation.steps) }
        foreach ($steps in $jobSteps.Values) {
            $resolve = $steps | Where-Object id -EQ subscription
            $login = $steps | Where-Object { $_.uses -like 'azure/login@*' }
            [array]::IndexOf($steps, $resolve) | Should -BeLessThan ([array]::IndexOf($steps, $login))
            $resolve.env.VALIDATE_CLIENT_ID | Should -Be '${{ vars.VALIDATE_CLIENT_ID || secrets.VALIDATE_CLIENT_ID }}'
            $resolve.env.HCI_LOG_MASKS | Should -Be '${{ secrets.HCI_LOG_MASKS }}'
            $resolve.run | Should -Match '\[string\] \$env:VALIDATE_CLIENT_ID'
            $resolve.run | Should -Match ([regex]::Escape('Register-HciLogMask -AdditionalMasks $env:HCI_LOG_MASKS'))
        }
        $receipt = $prepareSteps | Where-Object id -EQ subscription
        $receipt.env.HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT | Should -Be '${{ vars.HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT || secrets.HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT }}'
        $receipt.run | Should -Match '\[string\] \$env:HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT'
    }

    It 'Uses the pinned Tools CAS action across lifecycle, consumer and history boundaries' {
        $actionRef = 'Azure/azure-verified-modules-tools/.github/actions/azure-local-environment-lease@ed65b1e2c6168c366be694fa13fb8a07c85b1dff'
        $lifecycleLeaseSteps = @($prepareSteps | Where-Object uses -EQ $actionRef)
        @($lifecycleLeaseSteps.with.operation) | Should -Be @('status', 'acquire', 'acquire', 'acquire', 'release')
        @($lifecycleLeaseSteps | Where-Object id -EQ 'hci-lease-status') | Should -HaveCount 1
        ($lifecycleLeaseSteps | Where-Object id -EQ hci-lease-status).if | Should -Match "HCI_STAGE != 'Bootstrap'"
        ($lifecycleLeaseSteps | Where-Object id -EQ hci-lease-status).if | Should -Match "HCI_STAGE != 'Status'"
        $postBootstrap = $lifecycleLeaseSteps | Where-Object { $_.if -Match "HCI_STAGE == 'Bootstrap'" }
        $postBootstrap.with.mode | Should -Be 'lifecycle'
        $postBootstrap.with.expectedGeneration | Should -Be '${{ steps.lifecycle.outputs.environmentGeneration }}'
        $lifecycleRefresh = $lifecycleLeaseSteps | Where-Object { $_.with.refreshGeneration -ceq 'true' }
        $lifecycleRefresh.with.ownerHash | Should -Be '${{ steps.subscription.outputs.ownerHash }}'
        $lifecycleRefresh.if | Should -Match "HCI_STAGE == 'Begin'"
        $lifecycleRefresh.with.expectedGeneration | Should -Be '${{ steps.lifecycle.outputs.environmentGeneration }}'
        $lifecycleRelease = $lifecycleLeaseSteps | Where-Object { $_.with.operation -ceq 'release' }
        $lifecycleRelease.with.cleanupConfirmed | Should -Be 'true'
        $lifecycleRelease.with.mode | Should -Be 'lifecycle'

        $consumerSteps = @($consumer.jobs.job_module_deploy_validation.steps)
        $consumerLease = @($consumerSteps | Where-Object uses -EQ $actionRef)
        @($consumerLease.with.operation) | Should -Be @('status', 'acquire', 'release')
        $consumerStatus = $consumerSteps | Where-Object id -EQ 'hci-lease-status'
        $consumerStatus.with.mode | Should -Be 'consumer'
        $consumerStatus.if | Should -Be '${{ !fromJson(inputs.testCase).e2eIgnore }}'
        $consumerLease[1].if | Should -Be '${{ !fromJson(inputs.testCase).e2eIgnore }}'
        $consumerRelease = $consumerLease[-1]
        $consumerRelease.with.cleanupConfirmed | Should -Be 'true'
        $consumerRelease.if | Should -Be '${{ success() && steps.hci-consumer.outcome == ''success'' }}'
        [array]::IndexOf($consumerSteps, $consumerLease[1]) |
            Should -BeLessThan ([array]::IndexOf($consumerSteps, ($consumerSteps | Where-Object id -EQ hci-consumer)))
        [array]::IndexOf($consumerSteps, ($consumerSteps | Where-Object name -EQ 'Release only a successfully cleaned test environment')) |
            Should -BeLessThan ([array]::IndexOf($consumerSteps, $consumerRelease))

        $history = Get-Content (Join-Path $workflowRoot 'platform.deployment.history.cleanup.yml') -Raw | ConvertFrom-Yaml
        $historySteps = @($history.jobs.job_cleanup_reserved_deployments.steps)
        ($historySteps | Where-Object id -EQ hci-coordination) | Should -Not -BeNullOrEmpty
        @($historySteps | Where-Object uses -EQ $actionRef | ForEach-Object { $_.with.operation }) |
            Should -Be @('status', 'acquire', 'release')
        $historyActions = @($historySteps | Where-Object uses -EQ $actionRef)
        $historyActions[0].if | Should -Match "leaseRequired == 'true'"
        $historyActions[1].if | Should -Match "leaseRequired == 'true'"
        $historyRelease = $historySteps[-1]
        $historyRelease.with.cleanupConfirmed | Should -Be 'true'

        foreach ($steps in @(@($prepareSteps), $consumerSteps, $historySteps)) {
            ($steps | ConvertTo-Json -Depth 20) | Should -Match 'steps\.subscription\.outputs\.ownerHash'
        }
    }

    It 'Keeps private receipt storage out of generic deployments and HCI consumers' {
        foreach ($workflow in @($consumer, $deployment, $action)) {
            ($workflow | ConvertTo-Json -Depth 30) | Should -Not -Match 'HciImageReceipt|ReceiptStorageAccountName'
        }
        ($consumer | ConvertTo-Json -Depth 30) | Should -Match 'HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT'
        @($manual.on.workflow_dispatch.inputs.Keys | Sort-Object) | Should -Be @('operation', 'subscriptionIndex')
        ($manual | ConvertTo-Json -Depth 30) | Should -Not -Match 'upload-artifact|storageAccountKey|storageSasToken'
    }

    It 'Keeps the complete history inventory on the same canonical pool and identity bundle' {
        $history = Get-Content (Join-Path $workflowRoot 'platform.deployment.history.cleanup.yml') -Raw | ConvertFrom-Yaml
        foreach ($name in @('job_cleanup_subscription_deployments', 'job_cleanup_managementGroup_deployments')) {
            $select = $history.jobs[$name].steps | Where-Object id -EQ 'get-test-subscriptions'
            $select.env.TEST_SUBSCRIPTION_IDS | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
            $select.run | Should -Not -Match '-ModulePath'
            $login = $history.jobs[$name].steps | Where-Object { $_.uses -like 'azure/login@*' }
            $login.with.'client-id' | Should -Be '${{ vars.VALIDATE_CLIENT_ID || secrets.VALIDATE_CLIENT_ID }}'
            $login.with.'tenant-id' | Should -Be '${{ vars.VALIDATE_TENANT_ID || secrets.VALIDATE_TENANT_ID }}'
        }
        $history.jobs.job_cleanup_reserved_deployments.Contains('uses') | Should -BeFalse
        $history.jobs.job_cleanup_reserved_deployments.concurrency.group | Should -Be '${{ matrix.testCase.environmentConcurrencyGroup }}'
    }

    It 'Requires prepared inputs before deployment and bypasses the old gallery fallback with an immutable image' {
        $deployScript = ($action.runs.steps | Where-Object id -EQ deploy_step).with.inlineScript
        $consumerScript | Should -Match 'Enter-HciEnvironmentTest'
        $consumerScript | Should -Match 'Get-HciEnvironmentParameterMap'
        $consumerScript | Should -Match 'overrides\.hciHostImageReferenceId = \$result\.ImageVersionResourceId'
        $consumerScript | Should -Match 'overrides\.preparedHciEnvironment'
        $deployScript | Should -Match 'ProtectedResourceIds'
        $consumerScript | Should -Match 'cannot override their per-run disposable resource group'
        $deployScript | Should -Not -Match 'Hci|Azure Local|Resolve-CIParameterFallback'
        $steps = @($consumer.jobs.job_module_deploy_validation.steps)
        $acquire = $steps | Where-Object id -EQ hci-consumer
        $deploy = $steps | Where-Object id -EQ deployment
        [array]::IndexOf($steps, $acquire) | Should -BeLessThan ([array]::IndexOf($steps, $deploy))
        $deploy.with.deploymentDataFile | Should -Be '${{ runner.temp }}/avm-module-deployment-data.json'
        $deploy.with.requireCompleteRemoval | Should -Be 'true'
    }

    It 'Releases only after exact pending-history and strict resource removal, never on cancellation' {
        $cleanup = $action.runs.steps | Where-Object id -EQ remove-deployed-resources
        $cleanup.if | Should -Match '\(success\(\) \|\| failure\(\)\)'
        $cleanup.if | Should -Not -Match 'always\(\)'
        $script = $cleanup.with.inlineScript
        $script | Should -Match 'Invoke-ModuleDeploymentCleanup'
        $script | Should -Match 'ProtectedResourceIds'
        $script | Should -Not -Match 'Hci|Azure Local'
        $consumerScript | Should -Match 'Test-CleanupResourceAbsent -ResourceId \$context\.TestResourceGroupId'
        $consumerScript | Should -Match 'Exit-HciEnvironment -Context \$context -CleanupConfirmed:\$true'
        $consumerScript.IndexOf('Test-CleanupResourceAbsent') | Should -BeLessThan $consumerScript.IndexOf('Exit-HciEnvironment')
        $release = $consumer.jobs.job_module_deploy_validation.steps | Where-Object name -EQ 'Release only a successfully cleaned test environment'
        $release.if | Should -Match 'success\(\) \|\| failure\(\)'
        $release.if | Should -Not -Match 'always\(\)'
        $release.env.CLEANUP_STATUS | Should -Be '${{ steps.deployment.outputs.cleanupStatus }}'
        $release.env.DEPLOYMENT_OUTCOME | Should -Be '${{ steps.deployment.outcome }}'
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
                -ExpectedSubscriptionTag 'Azure Local' -RandomSeed 42 -DisplaySubscriptionNames -RepoRoot $RepoRootPath
            $matrix.testCases.Count | Should -Be $files.Count
            foreach ($test in $matrix.testCases) {
                $test.subscriptionIndex | Should -Be 0
                $test.subscriptionName | Should -Be 'sub-avm-test-001'
                $test.subscriptionKey | Should -Be $reservedKey
                $test.ContainsKey('environmentConcurrencyGroup') | Should -BeFalse
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
        # Key Vault rejects an explicit false; omitting the property leaves purge protection off.
        $vault[0].properties.Contains('enablePurgeProtection') | Should -BeFalse
        # A deleted vault keeps its name until purged, and reserved tests have no purge permission.
        $vault[0].name | Should -Match "uniqueString\(deployment\(\)\.name, resourceGroup\(\)\.id\)"
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

    It 'Grants the cluster module''s resource-provider roles before the host waits for the node extensions' {
        $foundation = $compiled['foundation.bicep']
        Get-ParameterExpression $foundation.resources.dependencies.properties.parameters.hciResourceProviderObjectId |
            Should -Be "[parameters('builtInServicePrincipalObjectId')]"
        $hostDeployment = $foundation.resources.dependencies.properties.template.resources.hciHostDeployment
        Get-ParameterExpression $hostDeployment.properties.parameters.hciResourceProviderObjectId |
            Should -Be "[parameters('hciResourceProviderObjectId')]"
        $getResources = { param($Template) $Template.resources -is [System.Collections.IDictionary] ? @($Template.resources.Values) : @($Template.resources) }
        $hostResources = & $getResources $hostDeployment.properties.template
        $hostRoleNames = @($hostResources | Where-Object { $_.type -eq 'Microsoft.Authorization/roleAssignments' -and $_.name -match 'hciResourceProviderObjectId' } | ForEach-Object { $_.name })
        $clusterRoleNames = @(& $getResources $foundation.resources.cluster.properties.template | Where-Object { $_.type -eq 'Microsoft.Authorization/roleAssignments' -and $_.name -match 'hciResourceProviderObjectId' } | ForEach-Object { $_.name })
        $hostRoleNames.Count | Should -Be 4
        $hostRoleNames | Sort-Object | Should -Be ($clusterRoleNames | Sort-Object)
        $stage7 = @($hostResources | Where-Object { $_.type -eq 'Microsoft.Compute/virtualMachines/runCommands' -and $_.name -match 'runCommand7' })
        $stage7.Count | Should -Be 1
        foreach ($pattern in @(
                '^nodeAzureConnectedMachineResourceManagerRolePermissions$'
                '^nodeAzureStackHCIDeviceManagementRole$'
                '^nodeReaderRolePermissions$'
                "^spConnectedMachineResourceManagerRolePermissions$|'ConnectedMachineResourceManagerRolePermissions'"
            )) {
            @($stage7[0].dependsOn | Where-Object { $_ -match $pattern }).Count | Should -Be 1
        }
        ($stage7[0].properties.parameters | Where-Object name -EQ 'ensureEdgeDevices').value |
            Should -Be "[string(variables('createHciResourceProviderRoleAssignments'))]"
    }

    It 'Reads the Arc machine identities only after stage 6 registers the machines' {
        # ARM reads a resource that reference() names outside the template when the deployment starts, whatever its dependencies.
        $hostTemplate = $compiled['foundation.bicep'].resources.dependencies.properties.template.resources.hciHostDeployment.properties.template
        $hostResources = $hostTemplate.resources -is [System.Collections.IDictionary] ? @($hostTemplate.resources.Values) : @($hostTemplate.resources)
        $reader = @($hostResources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match 'arcMachineIdentities' })
        $reader.Count | Should -Be 1
        @($reader[0].dependsOn | Where-Object { $_ -match "'runCommand6'" }).Count | Should -Be 1
        $nodeRoles = @($hostResources | Where-Object { $_.type -eq 'Microsoft.Authorization/roleAssignments' -and $_.copy -and $_.name -match 'hciResourceProviderObjectId' })
        $nodeRoles.Count | Should -Be 3
        foreach ($role in $nodeRoles) {
            $role.properties.principalId | Should -Match "arcMachineIdentities'.*\.outputs\.principalIds\.value\[copyIndex\(\)\]"
        }
        @($hostResources | Where-Object { -not [object]::ReferenceEquals($_, $reader[0]) }) | ConvertTo-Json -Depth 50 |
            Should -Not -Match "reference\((variables\('arcNodeResourceIds'\)|resourceId\('Microsoft\.HybridCompute/machines')"
    }

    It 'Gives the cluster resource the same name as its Active Directory name, within 15 characters' {
        $cluster = $compiled['foundation.bicep'].resources.cluster
        $cluster.properties.template.parameters.clusterADName.maxLength | Should -Be 15
        @($cluster.properties.parameters.Keys) | Should -Not -Contain 'clusterADName'
        $environment.clusterName.Length | Should -BeLessOrEqual 15
    }

    It 'Keeps the foundation host from installing updates and restarting in a maintenance window' {
        $dependencies = $compiled['foundation.bicep'].resources.dependencies
        $dependencies.properties.parameters.enableScheduledPatching.value | Should -BeFalse
        $hostDeployment = $dependencies.properties.template.resources.hciHostDeployment
        Get-ParameterExpression $hostDeployment.properties.parameters.enableScheduledPatching |
            Should -Be "[parameters('enableScheduledPatching')]"
        $hostResources = $hostDeployment.properties.template.resources
        $hostResources = $hostResources -is [System.Collections.IDictionary] ? @($hostResources.Values) : @($hostResources)
        $maintenance = @($hostResources | Where-Object type -Match '^Microsoft\.Maintenance/')
        $maintenance.Count | Should -Be 2
        $maintenance | ForEach-Object { $_.condition | Should -Be "[parameters('enableScheduledPatching')]" }
        $vm = @($hostResources | Where-Object type -EQ 'Microsoft.Compute/virtualMachines')
        $vm.Count | Should -Be 1
        $vm[0].properties.osProfile.windowsConfiguration.enableAutomaticUpdates | Should -Be "[parameters('enableScheduledPatching')]"
        $vm[0].properties.osProfile.windowsConfiguration.patchSettings | Should -Match "parameters\('enableScheduledPatching'\).*'Manual'"
    }

    It 'Grants the foundation host identity the Arc registration and edge-device roles instead of Owner' {
        $dependencies = $compiled['foundation.bicep'].resources.dependencies
        $dependencies.properties.parameters.assignResourceGroupOwner.value | Should -BeFalse
        $hostDeployment = $dependencies.properties.template.resources.hciHostDeployment
        Get-ParameterExpression $hostDeployment.properties.parameters.assignResourceGroupOwner |
            Should -Be "[parameters('assignResourceGroupOwner')]"
        $hostTemplate = $hostDeployment.properties.template
        $hostResources = $hostTemplate.resources -is [System.Collections.IDictionary] ? @($hostTemplate.resources.Values) : @($hostTemplate.resources)
        $identityRoles = @($hostResources | Where-Object {
                $_.type -eq 'Microsoft.Authorization/roleAssignments' -and $_.properties.principalId -match "userAssignedIdentities'"
            })
        $identityRoles.Count | Should -Be 2
        $owner = @($identityRoles | Where-Object { -not $_.copy })
        $owner[0].properties.roleDefinitionId | Should -Match '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
        $owner[0].condition | Should -Be "[parameters('assignResourceGroupOwner')]"
        @($identityRoles | Where-Object { $_.copy })[0].condition | Should -Be "[not(parameters('assignResourceGroupOwner'))]"
        $hostTemplate.variables.hostIdentityRoleDefinitionIds | Should -Be @(
            'b64e21ea-ac4e-4cdf-9dc9-5b892992bee7' # Azure Connected Machine Onboarding
            'cd570a14-e51a-42ad-bac8-bafd67325302' # Azure Connected Machine Resource Administrator
            '865ae368-6a45-4bd1-8fbf-0d5151f56fc1' # Azure Stack HCI Device Management Role
        )
    }
}
