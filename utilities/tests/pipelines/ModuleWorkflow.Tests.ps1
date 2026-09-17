param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Generic module workflow' {

    BeforeAll {
        $workflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml'
        $previewWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.preview.yml'
        $publishWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.publish.yml'
        $publishOnlyWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.publish-only.yml'
        $toggleWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'platform.toggle-avm-workflows.yml'

        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $workflowPath -Raw)
        $previewWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $previewWorkflowPath -Raw)
        $publishWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $publishWorkflowPath -Raw)
        $publishOnlyWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $publishOnlyWorkflowPath -Raw)
        $toggleWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $toggleWorkflowPath -Raw)
    }

    It 'uses the expected display name and has no global concurrency group' {
        $workflow.name | Should -Be '.Module - Check and Publish [EXPERIMENTAL]'
        $workflow.ContainsKey('concurrency') | Should -BeFalse
    }

    It 'queues generic module jobs without sharing legacy concurrency groups' {
        foreach ($jobName in @('call_module_preview', 'call_module_publish', 'call_module_publish_only')) {
            $workflow.jobs[$jobName].concurrency.group | Should -Be 'generic-module-${{ matrix.modulePath }}'
            $workflow.jobs[$jobName].concurrency.queue | Should -Be 'max'
            $workflow.jobs[$jobName].strategy.'max-parallel' | Should -Be 1
        }
    }

    It 'keeps automatic preview permissions read-only' {
        $workflow.jobs.call_module_preview.permissions.contents | Should -Be 'read'
        $previewWorkflow.jobs.Values.permissions.contents | Should -Not -Contain 'write'
        $previewWorkflow.jobs.ContainsKey('job_publish_module') | Should -BeFalse
    }

    It 'keeps metadata changes eligible for automatic validation, not publishing' {
        $workflow.on.push.paths | Should -Be @('avm/**', '!avm/**/README.md')
        $workflow.jobs.call_module_preview.if | Should -Match "github.event_name == 'push'"
        foreach ($jobName in @('call_module_publish', 'call_module_publish_only')) {
            $workflow.jobs[$jobName].if | Should -Match "github.event_name == 'workflow_dispatch'"
        }
    }

    It 'keeps publish-only free of OIDC permissions and validation jobs' {
        $workflow.jobs.call_module_publish_only.permissions.ContainsKey('id-token') | Should -BeFalse
        @(
            $publishOnlyWorkflow.jobs.Values |
            Where-Object { $_.permissions.ContainsKey('id-token') }
        ).Count | Should -Be 0
        $publishOnlyWorkflow.jobs.ContainsKey('job_module_deploy_validation') | Should -BeFalse
    }

    It 'gates forced publishing through the approval environment' {
        $workflow.jobs.call_module_publish.with.publishReleaseTag | Should -Be '${{ inputs.createReleaseTag }}'
        $workflow.jobs.call_module_publish.with.requirePublishApproval | Should -Be '${{ inputs.createReleaseTag }}'
        $workflow.jobs.call_module_publish_only.with.requirePublishApproval | Should -Be '${{ inputs.createReleaseTag }}'
        $publishWorkflow.jobs.job_publish_approval.environment | Should -Be 'publish-approval'
        $publishOnlyWorkflow.jobs.job_publish_approval.environment | Should -Be 'publish-approval'
    }

    It 'uses isolated reusable workflows for each permission boundary' {
        $workflow.jobs.call_module_preview.uses | Should -Be './.github/workflows/avm.template.module.preview.yml'
        $workflow.jobs.call_module_publish.uses | Should -Be './.github/workflows/avm.template.module.publish.yml'
        $workflow.jobs.call_module_publish_only.uses | Should -Be './.github/workflows/avm.template.module.publish-only.yml'
    }

    It 'uses the same stable generic name prefix for PSRule and deployment validation' {
        $previewWorkflow.env.TOKEN_NAMEPREFIX | Should -Be 'gci'
        $publishWorkflow.env.TOKEN_NAMEPREFIX | Should -Be 'gci'
        $workflow.jobs.call_module_preview.with.ContainsKey('customTokens') | Should -BeFalse
        $workflow.jobs.call_module_publish.with.ContainsKey('customTokens') | Should -BeFalse
    }

    It 'includes generic and module-specific workflows in the UI kill switch' {
        $filter = $toggleWorkflow.on.workflow_dispatch.inputs.includePattern.default
        foreach ($workflowName in @(
                $workflow.name
                '.Module - Check and Publish'
                'avm.res.storage.storage-account'
                'avm.ptn.test'
                'avm.utl.test'
            )) {
            $workflowName | Should -Match $filter
        }
        '.Platform - Toggle AVM workflows' | Should -Not -Match $filter
        '.Module - Check and Publish [EXPERIMENTAL] extra' | Should -Not -Match $filter
    }

    It 'keeps <FunctionName> aligned with the UI workflow filter' -ForEach @(
        @{
            FunctionName  = 'Get-GitHubModuleWorkflowList'
            RelativePath  = 'utilities\pipelines\platform\helper\Get-GitHubModuleWorkflowList.ps1'
            ParameterName = 'Filter'
        }
        @{
            FunctionName  = 'Switch-WorkflowState'
            RelativePath  = 'utilities\pipelines\platform\Switch-WorkflowState.ps1'
            ParameterName = 'IncludePattern'
        }
        @{
            FunctionName  = 'Invoke-WorkflowsFailedJobsReRun'
            RelativePath  = 'utilities\tools\Invoke-WorkflowsFailedJobsReRun.ps1'
            ParameterName = 'PipelineFilter'
        }
    ) {
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            (Join-Path $repoRootPath $RelativePath), [ref] $null, [ref] $parseErrors
        )
        $parseErrors | Should -BeNullOrEmpty
        $functionAst = $ast.Find({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq $FunctionName
            }, $true)
        $parameter = $functionAst.Body.ParamBlock.Parameters |
            Where-Object { $_.Name.VariablePath.UserPath -eq $ParameterName }
        $parameter.DefaultValue.SafeGetValue() |
            Should -Be $toggleWorkflow.on.workflow_dispatch.inputs.includePattern.default
    }
}

Describe 'Module publishing workflow path filters' {

    BeforeDiscovery {
        $moduleWorkflows = @(
            Get-ChildItem -Path (Join-Path $repoRootPath '.github' 'workflows') -File -Filter '*.yml' |
            ForEach-Object {
                $workflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $_.FullName -Raw)
                if ($workflow.jobs.Values.uses -contains './.github/workflows/avm.template.module.yml') {
                    @{
                        WorkflowFileName = $_.Name
                        Workflow         = $workflow
                    }
                }
            }
        )
    }

    BeforeAll {
        function Test-ModulePushPaths {
            param (
                [string[]] $Patterns,
                [string[]] $ChangedFiles
            )

            foreach ($file in $ChangedFiles) {
                $included = $false
                foreach ($pattern in $Patterns) {
                    if ($file -clike $pattern.TrimStart('!')) {
                        $included = -not $pattern.StartsWith('!')
                    }
                }
                if ($included) {
                    return $true
                }
            }
            return $false
        }
    }

    It 'preserves source and manual triggers while excluding metadata-only pushes in <WorkflowFileName>' -ForEach $moduleWorkflows {
        $modulePath = $Workflow.env.modulePath
        $paths = $Workflow.on.push.paths
        $paths | Should -Be @(
            ".github/workflows/$WorkflowFileName"
            "$modulePath/**"
            '!*/**/README.md'
            '!avm/**/metadata.json'
        )
        foreach ($inputName in @('staticValidation', 'deploymentValidation', 'removeDeployment')) {
            $Workflow.on.workflow_dispatch.inputs[$inputName].type | Should -Be 'boolean'
            $Workflow.on.workflow_dispatch.inputs[$inputName].default | Should -BeOfType ([bool])
        }
        $Workflow.on.push.branches | Should -Be @('main')

        foreach ($metadataPath in @('metadata.json', 'child/metadata.json', 'child/nested/metadata.json')) {
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("$modulePath/$metadataPath") |
                Should -BeFalse -Because "[$metadataPath] alone must not trigger publishing."
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("$modulePath/$metadataPath", "$modulePath/README.md") |
                Should -BeFalse -Because 'metadata and documentation alone must not trigger publishing.'
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("$modulePath/$metadataPath", "$modulePath/main.bicep") |
                Should -BeTrue -Because 'mixed source and metadata changes must still trigger the module workflow.'
        }

        foreach ($sourcePath in @('main.bicep', 'main.json', 'version.json', 'child/main.bicep', 'child/main.json', 'child/nested/version.json')) {
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("$modulePath/$sourcePath") |
                Should -BeTrue -Because "[$sourcePath] must still trigger the module workflow."
        }

        Test-ModulePushPaths -Patterns $paths -ChangedFiles @("$modulePath/metadata.json", 'avm/res/unrelated/module/main.json') |
            Should -BeFalse -Because 'another module source change must not release a metadata-only module.'
        Test-ModulePushPaths -Patterns $paths -ChangedFiles @("$modulePath/README.md") | Should -BeFalse
        Test-ModulePushPaths -Patterns $paths -ChangedFiles @(".github/workflows/$WorkflowFileName") | Should -BeTrue
    }
}
