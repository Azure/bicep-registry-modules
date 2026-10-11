param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeDiscovery {
    $moduleWorkflows = @(
        Get-ChildItem -LiteralPath (Join-Path $repoRootPath '.github' 'workflows') -File -Filter 'avm.*.yml' |
            Where-Object { $_.Name -match '^avm\.(res|ptn|utl)\.' } |
            ForEach-Object {
                @{
                    WorkflowFileName = $_.Name
                    Workflow         = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $_.FullName -Raw)
                }
            }
    )
    if ($moduleWorkflows.Count -eq 0) {
        throw 'No module workflow callers were discovered.'
    }
}

Describe 'Pinned tools workflow callers' {
    BeforeAll {
        $toolsRepository = 'Azure/azure-verified-modules-tools'
        $referenceWorkflow = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'avm.res.network.route-table.yml') -Raw
        )
        $reference = [regex]::Match(
            $referenceWorkflow.jobs.'call-workflow-passing-data'.uses,
            '^Azure/azure-verified-modules-tools/\.github/workflows/bicep-module\.yml@(?<ref>[0-9a-f]{40})$'
        )
        if (-not $reference.Success) {
            throw 'The module workflow must reference an immutable tools workflow commit.'
        }
        $toolsRef = $reference.Groups['ref'].Value
        $authoringVersion = '${{ vars.AVM_AUTHORING_VERSION }}'

        function Assert-GenericSelectionInputs {
            param([hashtable] $Workflow)

            $steps = $Workflow.jobs.job_initialize_pipeline.steps
            $checkout = @($steps | Where-Object { $_.uses -like 'actions/checkout@*' })
            $matrix = @($steps | Where-Object { $_.id -eq 'get-module-matrix' })
            $steps.Count | Should -Be 2
            $checkout.Count | Should -Be 1
            $matrix.Count | Should -Be 1
            $checkout[0].with.ref | Should -Be '${{ github.sha }}'
            $checkout[0].with.ref | Should -Be $matrix[0].with.targetCommit
            $matrix[0].with.baseCommit | Should -Be '${{ github.event.before }}'
            $matrix[0].with.pullRequestHeadCommit | Should -Be '${{ github.event.pull_request.head.sha }}'
            $matrix[0].ContainsKey('run') | Should -BeFalse
        }

        function Assert-ModuleCaller {
            param([hashtable] $Workflow)

            @($Workflow.jobs.Keys | Sort-Object) | Should -Be @('call-workflow-passing-data', 'job_initialize_pipeline')
            $initialize = $Workflow.jobs.job_initialize_pipeline
            $initialize.if | Should -Be '${{ !cancelled() && !(github.repository != ''Azure/bicep-registry-modules'' && github.event_name != ''workflow_dispatch'') }}'
            $initialize.steps.Count | Should -Be 3
            @($initialize.steps | Where-Object { $_.ContainsKey('run') }).Count | Should -Be 0

            $inputStep = $initialize.steps | Where-Object { $_.id -eq 'get-workflow-param' }
            $inputStep.uses | Should -Be "$toolsRepository/.github/actions/bicep-workflow-input@$toolsRef"
            ($inputStep.with.workflowPath -replace '\s', '') | Should -Be '${{env.workflowPath}}'

            $testStep = $initialize.steps | Where-Object { $_.id -eq 'get-module-test-file-paths' }
            $testStep.uses | Should -Be "$toolsRepository/.github/actions/bicep-module-test-files@$toolsRef"
            ($testStep.with.modulePath -replace '\s', '') | Should -Be '${{env.modulePath}}'

            $outputs = @{
                workflowInput             = '${{steps.get-workflow-param.outputs.workflowInput}}'
                moduleTestFilePaths       = '${{steps.get-module-test-file-paths.outputs.moduleTestFilePaths}}'
                psRuleModuleTestFilePaths = '${{steps.get-module-test-file-paths.outputs.psRuleModuleTestFilePaths}}'
                modulePath                = '${{env.modulePath}}'
            }
            @($initialize.outputs.Keys | Sort-Object) | Should -Be @($outputs.Keys | Sort-Object)
            foreach ($name in $outputs.Keys) {
                ($initialize.outputs[$name] -replace '\s', '') | Should -Be $outputs[$name]
            }

            $caller = $Workflow.jobs.'call-workflow-passing-data'
            $caller.name | Should -Be 'Run'
            @($caller.needs) | Should -Be @('job_initialize_pipeline')
            $caller.uses | Should -Be "$toolsRepository/.github/workflows/bicep-module.yml@$toolsRef"
            $caller.with.'tools-ref' | Should -Be $toolsRef
            $caller.with.'avm-authoring-version' | Should -Be $authoringVersion
            $caller.permissions.Count | Should -Be 2
            $caller.permissions.contents | Should -Be 'write'
            $caller.permissions.'id-token' | Should -Be 'write'
            $caller.secrets | Should -Be 'inherit'
            @($caller.with.Keys | Sort-Object) | Should -Be @(
                'avm-authoring-version', 'modulePath', 'moduleTestFilePaths',
                'psRuleModuleTestFilePaths', 'tools-ref', 'workflowInput'
            )
            foreach ($name in @('workflowInput', 'moduleTestFilePaths', 'psRuleModuleTestFilePaths', 'modulePath')) {
                ($caller.with[$name] -replace '\s', '') | Should -Be ('${{needs.job_initialize_pipeline.outputs.' + $name + '}}')
            }
        }
    }

    It 'preserves the initializer boundary and pins all remote uses in <WorkflowFileName>' -ForEach $moduleWorkflows {
        Assert-ModuleCaller -Workflow $Workflow
    }

    It 'rejects <Name>' -ForEach @(
        @{
            Name   = 'an unpinned reusable workflow'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.uses = 'Azure/azure-verified-modules-tools/.github/workflows/bicep-module.yml@main' }
        }
        @{
            Name   = 'a tools checkout ref that differs from the workflow pin'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.'tools-ref' = '0' * 40 }
        }
        @{
            Name   = 'an initializer action from a different tools revision'
            Mutate = { param($workflow) $workflow.jobs.job_initialize_pipeline.steps[1].uses = 'Azure/azure-verified-modules-tools/.github/actions/bicep-workflow-input@main' }
        }
        @{
            Name   = 'caller-local test discovery'
            Mutate = { param($workflow) $workflow.jobs.job_initialize_pipeline.steps[2].uses = './.github/actions/templates/avm-getModuleTestFiles' }
        }
        @{
            Name   = 'an implicit latest authoring package'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.'avm-authoring-version' = 'latest' }
        }
        @{
            Name   = 'a missing authoring release prerequisite'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.Remove('avm-authoring-version') }
        }
        @{
            Name   = 'an initializer that bypasses the upstream and manual guard'
            Mutate = { param($workflow) $workflow.jobs.job_initialize_pipeline.if = '${{ !cancelled() }}' }
        }
        @{
            Name   = 'a module path that bypasses initializer outputs'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.modulePath = 'avm/res/unrelated/module' }
        }
    ) {
        $fixture = $referenceWorkflow | ConvertTo-Json -Depth 30 | ConvertFrom-Json -AsHashtable
        . $Mutate $fixture

        { Assert-ModuleCaller -Workflow $fixture } | Should -Throw
    }

    It 'pins the generic <Job> permission boundary to the same tools revision' -ForEach @(
        @{ Job = 'call_module_preview'; File = 'bicep-module-preview.yml' }
        @{ Job = 'call_module_fork_static'; File = 'bicep-module-static.yml' }
        @{ Job = 'call_module_publish'; File = 'bicep-module-publish.yml' }
        @{ Job = 'call_module_publish_only'; File = 'bicep-module-publish-only.yml' }
    ) {
        $workflow = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml') -Raw
        )
        $workflow.jobs[$Job].uses | Should -Be "$toolsRepository/.github/workflows/$File@$toolsRef"
        $workflow.jobs[$Job].with.'tools-ref' | Should -Be $toolsRef
        $workflow.jobs[$Job].with.'avm-authoring-version' | Should -Be $authoringVersion
    }

    It 'uses tools-owned generic matrix selection with the same release prerequisite' {
        $workflow = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml') -Raw
        )
        Assert-GenericSelectionInputs -Workflow $workflow
        $initialize = $workflow.jobs.job_initialize_pipeline
        $matrix = $initialize.steps | Where-Object { $_.id -eq 'get-module-matrix' }
        $matrix.uses | Should -Be "$toolsRepository/.github/actions/bicep-workflow-matrix@$toolsRef"
        $matrix.with.'avm-authoring-version' | Should -Be $authoringVersion
        $matrix.ContainsKey('run') | Should -BeFalse
        $inputs = @{
            'avm-authoring-version' = $authoringVersion
            baseCommit             = '${{ github.event.before }}'
            targetCommit           = '${{ github.sha }}'
            pullRequestHeadCommit  = '${{ github.event.pull_request.head.sha }}'
            eventName              = '${{ github.event_name }}'
            modulePaths            = '${{ inputs.modulePaths }}'
            createReleaseTag       = '${{ inputs.createReleaseTag }}'
            publishOnly            = '${{ inputs.publishOnly }}'
            customLocation         = '${{ inputs.customLocation }}'
            staticValidation       = '${{ case(github.event_name == ''workflow_dispatch'', inputs.staticValidation, true) }}'
            deploymentValidation   = '${{ case(github.event_name == ''workflow_dispatch'', inputs.deploymentValidation, github.event_name != ''pull_request'' || (contains(github.event.pull_request.labels.*.name, ''PR: Run Checks'') && contains(github.event.pull_request.labels.*.name, ''PR: Run E2E Tests''))) }}'
            removeDeployment       = '${{ case(github.event_name == ''workflow_dispatch'', inputs.removeDeployment, true) }}'
        }
        @($matrix.with.Keys | Sort-Object) | Should -Be @($inputs.Keys | Sort-Object)
        foreach ($name in $inputs.Keys) {
            $matrix.with[$name] | Should -Be $inputs[$name]
        }
        foreach ($name in @('baseCommit', 'hasModules', 'includeAllVersionedModules', 'moduleMatrix', 'targetCommit', 'workflowInput')) {
            $initialize.outputs[$name] | Should -Be ('${{ steps.get-module-matrix.outputs.' + $name + ' }}')
        }
    }

    It 'rejects <Name> in generic selection' -ForEach @(
        @{
            Name   = 'a pull request head checkout instead of the tested merge'
            Mutate = {
                param($workflow)
                $checkout = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.uses -like 'actions/checkout@*' }
                $checkout.with.ref = '${{ github.event.pull_request.head.sha }}'
            }
        }
        @{
            Name   = 'a target commit different from the checked-out merge'
            Mutate = {
                param($workflow)
                $matrix = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
                $matrix.with.targetCommit = '${{ github.event.pull_request.head.sha }}'
            }
        }
        @{
            Name   = 'the mutable pull request event base instead of the push base'
            Mutate = {
                param($workflow)
                $matrix = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
                $matrix.with.baseCommit = '${{ github.event.pull_request.base.sha }}'
            }
        }
        @{
            Name   = 'a missing pull request head binding'
            Mutate = {
                param($workflow)
                $matrix = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
                $matrix.with.Remove('pullRequestHeadCommit')
            }
        }
        @{
            Name   = 'the tested merge supplied as its own pull request head'
            Mutate = {
                param($workflow)
                $matrix = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
                $matrix.with.pullRequestHeadCommit = '${{ github.sha }}'
            }
        }
        @{
            Name   = 'caller-local matrix implementation'
            Mutate = {
                param($workflow)
                $matrix = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
                $matrix.run = 'Get-ModuleWorkflowMatrix'
            }
        }
    ) {
        $workflow = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml') -Raw
        )
        . $Mutate $workflow

        { Assert-GenericSelectionInputs -Workflow $workflow } | Should -Throw
    }
}
