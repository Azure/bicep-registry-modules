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
        $workflow.name | Should -Be '.Module - Check and Publish'
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

    It 'includes the generic workflow in the UI kill switch' {
        $toggleWorkflow.on.workflow_dispatch.inputs.includePattern.default | Should -Match '\\.Module - Check and Publish'
    }
}
