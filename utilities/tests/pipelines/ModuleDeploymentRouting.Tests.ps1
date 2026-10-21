param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Module deployment workflow expansion' {
    BeforeAll {
        Import-Module powershell-yaml -ErrorAction Stop
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleWorkflowMatrix.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleDeploymentMatrix.ps1')

        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $modulePath = 'avm/res/data-factory/factory'
        $module = (Get-ModuleWorkflowMatrix -ModulePathInput $modulePath -RepoRoot $RepoRootPath).include[0]
        $testFiles = @(ConvertFrom-Json -InputObject $module.moduleTestFilePaths -AsHashtable)
        $selection = Get-ModuleDeploymentMatrix -ModulePath $modulePath -TestFilePaths $testFiles `
            -TestSubscriptionIds '[{"id":"11111111-1111-1111-1111-111111111111","name":"general"}]' `
            -RandomSeed 42 -RepoRoot $RepoRootPath
        $deployment = Get-Content (Join-Path $workflowRoot 'avm.template.module.deployment.yml') -Raw | ConvertFrom-Yaml
        $action = Get-Content (Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw | ConvertFrom-Yaml
        $hciModule = Get-Content (Join-Path $workflowRoot 'avm.template.hci.module.yml') -Raw | ConvertFrom-Yaml
        $consumer = Get-Content (Join-Path $workflowRoot 'avm.template.hci.consumer.yml') -Raw | ConvertFrom-Yaml
        $reservedModules = Get-Content (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw | ConvertFrom-Json -AsHashtable

        function Resolve-TestCaseExpression {
            param([string] $Expression, [hashtable] $TestCase)

            if ($Expression -cnotmatch '^\$\{\{ (?:!)?fromJson\(inputs\.testCase\)\.([A-Za-z][A-Za-z0-9_]*) \}\}$') {
                throw "Unsupported test-case expression [$Expression]."
            }
            $value = $TestCase[$Matches[1]]
            if ($Expression.Contains('!fromJson')) {
                return -not $value
            }
            return $value
        }

        function Test-WorkflowCondition {
            param([string] $Expression, [hashtable] $Context)

            $condition = $Expression.Trim() -replace '^\$\{\{\s*|\s*\}\}$', ''
            $condition = $condition -replace '\(?fromJson\(inputs\.workflowInput\)\)?\.staticValidation', '$Context.staticValidation'
            $condition = $condition -replace '\(?fromJson\(inputs\.workflowInput\)\)?\.deploymentValidation', '$Context.deploymentValidation'
            $condition = $condition.Replace('inputs.moduleTestFilePaths', '$Context.testFiles').
                Replace('inputs.psRuleModuleTestFilePaths', '$Context.psRuleFiles').
                Replace('inputs.publishReleaseTag', '$Context.publishReleaseTag').
                Replace('!inputs.requirePublishApproval', '(-not $Context.requirePublishApproval)').
                Replace('inputs.requirePublishApproval', '$Context.requirePublishApproval').
                Replace('inputs.includeAllVersionedModules', '$Context.includeAllVersionedModules').
                Replace('needs.job_initialize_subscription_selection.result', '$Context.selectionResult').
                Replace('needs.job_module_static_validation.result', '$Context.staticResult').
                Replace('needs.job_psrule_must.result', '$Context.requiredPSRuleResult').
                Replace('needs.job_module_deploy_validation.result', '$Context.deploymentResult').
                Replace('needs.job_publish_approval.result', '$Context.publishApprovalResult').
                Replace('github.event_name', '$Context.eventName').
                Replace('github.ref', '$Context.ref').
                Replace('github.repository', '$Context.repository').
                Replace('!cancelled()', '$Context.notCancelled').
                Replace('!=', '-ne').Replace('==', '-eq').Replace('&&', '-and').Replace('||', '-or')
            if ($condition -match 'inputs\.|needs\.|github\.|fromJson|cancelled\(') {
                throw "Unsupported workflow condition [$Expression]."
            }
            return . ([scriptblock]::Create('param($Context)' + [Environment]::NewLine + $condition)) $Context
        }
    }

    It 'uses all four active Data Factory cases and the ignored cmk-hsm-uami case' {
        @($selection.testCases | Where-Object { -not $_.e2eIgnore } | Sort-Object name | ForEach-Object name) |
            Should -Be @('defaults', 'git-config', 'max', 'waf-aligned')
        @($selection.testCases | Where-Object e2eIgnore | ForEach-Object name) | Should -Be @('cmk-hsm-uami')
        $selection.sharedScope | Should -BeTrue
    }

    It 'expands every declared job lock for <caseName> with <fieldState> optional environment metadata' -ForEach @(
        @{ caseName = 'defaults'; fieldState = 'absent' }
        @{ caseName = 'defaults'; fieldState = 'empty' }
        @{ caseName = 'git-config'; fieldState = 'absent' }
        @{ caseName = 'git-config'; fieldState = 'empty' }
        @{ caseName = 'max'; fieldState = 'absent' }
        @{ caseName = 'max'; fieldState = 'empty' }
        @{ caseName = 'waf-aligned'; fieldState = 'absent' }
        @{ caseName = 'waf-aligned'; fieldState = 'empty' }
        @{ caseName = 'cmk-hsm-uami'; fieldState = 'absent' }
        @{ caseName = 'cmk-hsm-uami'; fieldState = 'empty' }
    ) {
        $record = @($selection.testCases | Where-Object name -EQ $caseName)[0].Clone()
        $record.Remove('environmentConcurrencyGroup')
        if ($fieldState -eq 'empty') {
            $record.environmentConcurrencyGroup = ''
        }
        $testCase = $record | ConvertTo-Json -Compress | ConvertFrom-Json -AsHashtable

        foreach ($jobName in $deployment.jobs.Keys) {
            $job = $deployment.jobs[$jobName]
            if ($job.ContainsKey('concurrency')) {
                $group = Resolve-TestCaseExpression -Expression $job.concurrency.group -TestCase $testCase
                $group | Should -Not -BeNullOrEmpty -Because "GitHub must expand [$jobName] without relying on its if condition to hide an empty concurrency group"
                $group | Should -BeExactly $testCase.concurrencyGroup
            }
        }
    }

    It 'keeps the ordinary deployment workflow and composite free of HCI runtime dependencies' {
        @($deployment.jobs.Keys) | Should -Be @('job_module_deploy_validation')
        $deployment.jobs.job_module_deploy_validation.ContainsKey('if') | Should -BeFalse
        @($deployment.on.workflow_call.inputs.Keys | Sort-Object) |
            Should -Be @('modulePath', 'testCase', 'tokenNamePrefix', 'workflowInput')
        foreach ($document in @($deployment, $action)) {
            $document | ConvertTo-Json -Depth 50 |
                Should -Not -Match 'Hci|Azure Local|environmentConcurrencyGroup|avm-hci'
        }
    }

    It 'preserves the actual <caseName> report/deploy behavior after lock expansion' -ForEach @(
        @{ caseName = 'defaults'; deploy = $true }
        @{ caseName = 'git-config'; deploy = $true }
        @{ caseName = 'max'; deploy = $true }
        @{ caseName = 'waf-aligned'; deploy = $true }
        @{ caseName = 'cmk-hsm-uami'; deploy = $false }
    ) {
        $testCase = @($selection.testCases | Where-Object name -EQ $caseName)[0]
        $steps = @($deployment.jobs.job_module_deploy_validation.steps | Where-Object {
                Resolve-TestCaseExpression -Expression $_.if -TestCase $testCase
            })
        if ($deploy) {
            $steps.Count | Should -Be 3
            $steps[0].uses | Should -Match '^actions/checkout@'
            $steps[1].uses | Should -Be './.github/actions/templates/avm-setEnvironment'
            $steps[2].uses | Should -Be './.github/actions/templates/avm-validateModuleDeployment'
        } else {
            $steps.Count | Should -Be 1
            $steps[0].name | Should -Be 'Report skipped deployment'
            $steps[0].ContainsKey('uses') | Should -BeFalse
        }
    }

    It 'routes Data Factory push/main and manual dispatcher callers through the same generic deployment workflow' {
        $entry = Get-Content (Join-Path $workflowRoot 'avm.res.data-factory.factory.yml') -Raw | ConvertFrom-Yaml
        $entry.on.push.branches | Should -Be @('main')
        $entry.env.modulePath | Should -Be $modulePath
        $entry.jobs.'call-workflow-passing-data'.uses | Should -Be './.github/workflows/avm.template.module.yml'

        $dispatcher = Get-Content (Join-Path $workflowRoot 'avm.module.yml') -Raw | ConvertFrom-Yaml
        $dispatcher.jobs.call_module_preview.uses | Should -Be './.github/workflows/avm.template.module.preview.yml'
        $dispatcher.jobs.call_module_publish.uses | Should -Be './.github/workflows/avm.template.module.publish.yml'
        $dispatcher.jobs.call_module_publish.if | Should -Match "github.event_name == 'workflow_dispatch'"
        foreach ($file in @('avm.template.module.yml', 'avm.template.module.preview.yml', 'avm.template.module.publish.yml')) {
            $caller = Get-Content (Join-Path $workflowRoot $file) -Raw | ConvertFrom-Yaml
            $job = $caller.jobs.job_module_deploy_validation
            $job.uses | Should -Be './.github/workflows/avm.template.module.deployment.yml'
            $job.with.testCase | Should -Be '${{ toJSON(matrix.testCases) }}'
            $job.strategy.matrix.testCases | Should -Be '${{ fromJson(needs.job_initialize_subscription_selection.outputs.deploymentMatrix) }}'
            $caller | ConvertTo-Json -Depth 30 | Should -Not -Match 'Hci|Azure Local|environmentConcurrencyGroup|avm-hci'
        }
    }

    It 'routes every reserved per-module entrypoint through the explicit wrapper without changing inputs or triggers' {
        $reference = Get-Content (Join-Path $workflowRoot 'avm.res.data-factory.factory.yml') -Raw | ConvertFrom-Yaml
        $reservedModules.Count | Should -Be 7
        foreach ($path in $reservedModules.Keys) {
            $file = "$($path.Replace('/', '.')).yml"
            $entry = Get-Content (Join-Path $workflowRoot $file) -Raw | ConvertFrom-Yaml
            $entry.on.workflow_dispatch | ConvertTo-Json -Depth 10 -Compress |
                Should -Be ($reference.on.workflow_dispatch | ConvertTo-Json -Depth 10 -Compress)
            $entry.on.push.branches | Should -Be @('main')
            $entry.on.push.paths | Should -Contain "$path/**"
            $entry.jobs.'call-workflow-passing-data'.uses | Should -Be './.github/workflows/avm.template.hci.module.yml'
            $entry.jobs.'call-workflow-passing-data'.with | ConvertTo-Json -Compress |
                Should -Be ($reference.jobs.'call-workflow-passing-data'.with | ConvertTo-Json -Compress)
            $entry.jobs.'call-workflow-passing-data'.secrets | Should -Be 'inherit'
        }
    }

    It 'resolves every downstream job output against the post-separation producer contract' {
        $files = @(
            'avm.module.yml'
            'avm.res.data-factory.factory.yml'
            'avm.template.module.yml'
            'avm.template.module.preview.yml'
            'avm.template.module.publish.yml'
            'avm.template.module.deployment.yml'
            'avm.template.hci.module.yml'
            'avm.template.hci.consumer.yml'
        ) + @($reservedModules.Keys | ForEach-Object { "$($_.Replace('/', '.')).yml" })
        $referenceCount = 0
        foreach ($file in $files) {
            $source = Get-Content (Join-Path $workflowRoot $file) -Raw
            $source | Should -Not -Match 'job_hci_environment|outputs\.hci\b'
            $workflow = ConvertFrom-Yaml -Yaml $source
            foreach ($reference in [regex]::Matches($source, '(?:needs|jobs)\.([A-Za-z_][A-Za-z0-9_-]*)\.outputs\.([A-Za-z_][A-Za-z0-9_-]*)')) {
                $producerName = $reference.Groups[1].Value
                $outputName = $reference.Groups[2].Value
                @($workflow.jobs.Keys) | Should -Contain $producerName -Because "[$file] consumes [$($reference.Value)]"
                $producer = $workflow.jobs[$producerName]
                $outputs = $producer.outputs
                if ($producer.uses) {
                    $calledWorkflow = Get-Content (Join-Path $RepoRootPath $producer.uses) -Raw | ConvertFrom-Yaml
                    $outputs = $calledWorkflow.on.workflow_call.outputs
                }
                @($outputs.Keys) | Should -Contain $outputName -Because "[$file] must not interpret an undeclared output as an empty value"
                $referenceCount++
            }
        }
        $referenceCount | Should -BeGreaterThan 0
        $deployment.on.workflow_call.ContainsKey('outputs') | Should -BeFalse
        $consumer.on.workflow_call.ContainsKey('outputs') | Should -BeFalse
    }

    It 'does not classify missing deployment outputs as successful non-HCI publishing in <file>' -ForEach @(
        @{ file = 'avm.template.module.yml'; publicationJob = 'job_publish_module' }
        @{ file = 'avm.template.module.preview.yml'; publicationJob = 'job_preview_module' }
        @{ file = 'avm.template.module.publish.yml'; publicationJob = 'job_publish_module' }
        @{ file = 'avm.template.hci.module.yml'; publicationJob = 'job_publish_module' }
    ) {
        $workflow = Get-Content (Join-Path $workflowRoot $file) -Raw | ConvertFrom-Yaml
        $context = @{
            deploymentValidation = 'true'
            testFiles = '[{"name":"defaults","path":"tests/e2e/defaults/main.test.bicep"}]'
            selectionResult = 'success'
            staticResult = 'success'
            requiredPSRuleResult = 'success'
            deploymentResult = 'success'
            publishReleaseTag = $true
            requirePublishApproval = $true
            publishApprovalResult = 'success'
            includeAllVersionedModules = $false
            eventName = 'push'
            ref = 'refs/heads/main'
            repository = 'Azure/bicep-registry-modules'
            notCancelled = $true
        }
        $publish = $workflow.jobs[$publicationJob]
        Test-WorkflowCondition -Expression $publish.if -Context $context | Should -BeTrue
        foreach ($result in @('failure', 'cancelled', 'skipped', '')) {
            $failed = $context.Clone()
            $failed.deploymentResult = $result
            Test-WorkflowCondition -Expression $publish.if -Context $failed | Should -BeFalse
        }
        if ($file -ne 'avm.template.hci.module.yml') {
            $reservedPath = @($reservedModules.Keys | Sort-Object)[0]
            {
                Get-ModuleDeploymentMatrix -ModulePath $reservedPath `
                    -TestFilePaths @(@{ name = 'defaults'; path = 'tests/e2e/defaults/main.test.bicep' }) `
                    -RandomSeed 42 -RepoRoot $RepoRootPath
            } | Should -Throw '*Use the module''s dedicated workflow*'
            $context.selectionResult = 'failure'
            $context.deploymentResult = 'skipped'
            Test-WorkflowCondition -Expression $workflow.jobs.job_module_deploy_validation.if -Context $context | Should -BeFalse
            Test-WorkflowCondition -Expression $publish.if -Context $context | Should -BeFalse
        }
    }

    It 'allows reserved static/PSRule-only requests through <file> without entering deployment selection' -ForEach @(
        @{ file = 'avm.template.module.yml' }
        @{ file = 'avm.template.module.preview.yml' }
        @{ file = 'avm.template.module.publish.yml' }
    ) {
        $workflow = Get-Content (Join-Path $workflowRoot $file) -Raw | ConvertFrom-Yaml
        $context = @{
            staticValidation = 'true'
            deploymentValidation = 'false'
            testFiles = '[{"name":"defaults","path":"tests/e2e/defaults/main.test.bicep"}]'
            psRuleFiles = '[{"name":"defaults","path":"tests/e2e/defaults/main.test.bicep"}]'
        }
        foreach ($jobName in @('job_module_static_validation', 'job_psrule_must', 'job_psrule_opt')) {
            Test-WorkflowCondition -Expression $workflow.jobs[$jobName].if -Context $context | Should -BeTrue
        }
        Test-WorkflowCondition -Expression $workflow.jobs.job_initialize_subscription_selection.if -Context $context |
            Should -BeFalse
        foreach ($path in $reservedModules.Keys) {
            (Get-ModuleWorkflowMatrix -ModulePathInput $path -RepoRoot $RepoRootPath).include.modulePath | Should -Be $path
        }
    }

    It 'preserves existing static/PSRule actions and conditions while reserving Azure Local selection for its own initializer' {
        $legacy = Get-Content (Join-Path $workflowRoot 'avm.template.module.yml') -Raw | ConvertFrom-Yaml
        $hciModule.env | ConvertTo-Json -Compress | Should -Be ($legacy.env | ConvertTo-Json -Compress)
        foreach ($jobName in @('job_module_static_validation', 'job_psrule_must', 'job_psrule_opt')) {
            $job = $hciModule.jobs[$jobName]
            $reference = $legacy.jobs[$jobName]
            $job.if | Should -Be $reference.if
            $job.'runs-on' | Should -Be $reference.'runs-on'
            $job.steps | ConvertTo-Json -Depth 15 -Compress | Should -Be ($reference.steps | ConvertTo-Json -Depth 15 -Compress)
            $job.strategy | ConvertTo-Json -Depth 10 -Compress | Should -Be ($reference.strategy | ConvertTo-Json -Depth 10 -Compress)
        }
        $initialize = $hciModule.jobs.job_initialize_subscription_selection
        $matrixStep = $initialize.steps | Where-Object id -EQ deployment-matrix
        $matrixStep.with.expectedSubscriptionTag | Should -Be 'Azure Local'
        $initialize.outputs.deploymentMatrix | Should -Be '${{ steps.hci-matrix.outputs.deploymentMatrix }}'
        $initialize.outputs.sharedScope | Should -Be '${{ steps.deployment-matrix.outputs.sharedScope }}'
        $deploy = $hciModule.jobs.job_module_deploy_validation
        $deploy.uses | Should -Be './.github/workflows/avm.template.hci.consumer.yml'
        $deploy.with.workflowInput | Should -Be '${{ inputs.workflowInput }}'
        $deploy.concurrency.group | Should -Match "sharedScope == 'true'"
        $deploy.concurrency.queue | Should -Be 'max'
        $deploy.if | Should -Be $legacy.jobs.job_module_deploy_validation.if
        $deploy.needs | Should -Be $legacy.jobs.job_module_deploy_validation.needs
        $deploy.needs | Should -Not -Contain 'job_psrule_opt'
    }

    It 'preserves required versus optional validation gates for dedicated deployment' {
        $context = @{
            deploymentValidation = 'true'
            selectionResult = 'success'
            staticResult = 'success'
            requiredPSRuleResult = 'success'
            notCancelled = $true
        }
        $deploy = $hciModule.jobs.job_module_deploy_validation
        Test-WorkflowCondition -Expression $deploy.if -Context $context | Should -BeTrue
        foreach ($gate in @('selectionResult', 'staticResult', 'requiredPSRuleResult')) {
            $failed = $context.Clone()
            $failed[$gate] = 'failure'
            Test-WorkflowCondition -Expression $deploy.if -Context $failed | Should -BeFalse
        }
        $withoutStatic = $context.Clone()
        $withoutStatic.staticResult = 'skipped'
        $withoutStatic.requiredPSRuleResult = 'skipped'
        Test-WorkflowCondition -Expression $deploy.if -Context $withoutStatic | Should -BeTrue
        $withoutDeployment = $context.Clone()
        $withoutDeployment.deploymentValidation = 'false'
        Test-WorkflowCondition -Expression $deploy.if -Context $withoutDeployment | Should -BeFalse
    }

    It 'adds canonical environment locks only in the dedicated wrapper and isolates ignored cases without subscription metadata' {
        $step = $hciModule.jobs.job_initialize_subscription_selection.steps | Where-Object id -EQ hci-matrix
        $savedMatrix = $env:DEPLOYMENT_MATRIX
        $savedOutput = $env:GITHUB_OUTPUT
        try {
            $records = @($selection.testCases | ForEach-Object { $_.Clone() })
            $env:DEPLOYMENT_MATRIX = ConvertTo-Json -InputObject $records -Depth 10 -Compress
            $env:GITHUB_OUTPUT = Join-Path $TestDrive 'hci-matrix-output.txt'
            . ([scriptblock]::Create($step.run))
            $output = (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim().Split('=', 2)[1]
            $routed = @(ConvertFrom-Json -InputObject $output -AsHashtable)
            $routed.Count | Should -Be $records.Count
            foreach ($index in 0..($routed.Count - 1)) {
                $record = $routed[$index]
                $environmentGroup = Resolve-TestCaseExpression -Expression $consumer.concurrency.group -TestCase $record
                $moduleGroup = Resolve-TestCaseExpression -Expression $consumer.jobs.job_module_deploy_validation.concurrency.group -TestCase $record
                $environmentGroup | Should -Not -BeNullOrEmpty
                $environmentGroup | Should -Not -Be $moduleGroup
                if ($record.e2eIgnore) {
                    $environmentGroup | Should -Be "avm-hci-ignored-$($record.concurrencyGroup)"
                    $record.subscriptionKey | Should -BeNullOrEmpty
                } else {
                    $environmentGroup | Should -Be "avm-hci-$($record.subscriptionKey)"
                }
                $record.Remove('environmentConcurrencyGroup')
                $record | ConvertTo-Json -Compress | Should -Be ($records[$index] | ConvertTo-Json -Compress)
            }
        } finally {
            $env:DEPLOYMENT_MATRIX = $savedMatrix
            $env:GITHUB_OUTPUT = $savedOutput
        }
    }

    It 'reports ignored dedicated cases without cleanup checks, checkout, login or ownership acquisition' {
        $testCase = @{ e2eIgnore = $true }
        $steps = @($consumer.jobs.job_module_deploy_validation.steps)
        $preAcquire = @($steps | Select-Object -First ([array]::IndexOf($steps, ($steps | Where-Object id -EQ deployment))))
        $selected = @($preAcquire | Where-Object {
                Resolve-TestCaseExpression -Expression $_.if -TestCase $testCase
            })
        $selected.Count | Should -Be 1
        $selected[0].name | Should -Be 'Report skipped deployment'
        $selected[0].ContainsKey('uses') | Should -BeFalse
        ($steps | Where-Object id -EQ deployment).if | Should -Be "steps.hci-consumer.outcome == 'success'"
    }

    It 'publishes only after both static and dedicated deployment success, never after failed or skipped HCI validation' {
        $publish = $hciModule.jobs.job_publish_module
        $publish.name | Should -Be 'Publishing'
        $publish.needs | Should -Be @('job_module_static_validation', 'job_module_deploy_validation')
        $publish.concurrency.group | Should -Be 'avm-publish-${{ inputs.modulePath }}'
        $publish.concurrency.queue | Should -Be 'max'
        $context = @{
            staticResult = 'success'
            deploymentResult = 'success'
            ref = 'refs/heads/main'
            repository = 'Azure/bicep-registry-modules'
            notCancelled = $true
        }
        Test-WorkflowCondition -Expression $publish.if -Context $context | Should -BeTrue
        foreach ($gate in @('staticResult', 'deploymentResult')) {
            foreach ($result in @('failure', 'cancelled', 'skipped')) {
                $failed = $context.Clone()
                $failed[$gate] = $result
                Test-WorkflowCondition -Expression $publish.if -Context $failed | Should -BeFalse
            }
        }
        foreach ($change in @(
                @{ name = 'ref'; value = 'refs/heads/feature' }
                @{ name = 'repository'; value = 'contributor/bicep-registry-modules' }
                @{ name = 'notCancelled'; value = $false }
            )) {
            $failed = $context.Clone()
            $failed[$change.name] = $change.value
            Test-WorkflowCondition -Expression $publish.if -Context $failed | Should -BeFalse
        }
        $release = $publish.steps | Where-Object name -EQ 'Create module release tag'
        $release.run | Should -Match 'Set-ModuleReleaseTag @functionInput'
        $release.run | Should -Match ([regex]::Escape('${{ inputs.modulePath }}/main.bicep'))
    }
}
