param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Generic module workflow' {

    BeforeAll {
        $workflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml'
        $previewWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.preview.yml'
        $staticWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.static.yml'
        $publishWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.publish.yml'
        $publishOnlyWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.template.module.publish-only.yml'
        $toggleWorkflowPath = Join-Path $repoRootPath '.github' 'workflows' 'platform.toggle-avm-workflows.yml'

        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $workflowPath -Raw)
        $previewWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $previewWorkflowPath -Raw)
        $staticWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $staticWorkflowPath -Raw)
        $publishWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $publishWorkflowPath -Raw)
        $publishOnlyWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $publishOnlyWorkflowPath -Raw)
        $toggleWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $toggleWorkflowPath -Raw)
    }

    It 'uses the expected display name and has no global concurrency group' {
        $workflow.name | Should -Be '.Module - Check and Publish [EXPERIMENTAL]'
        $workflow.ContainsKey('concurrency') | Should -BeFalse
    }

    It 'queues generic module jobs without sharing legacy concurrency groups' {
        foreach ($jobName in @('call_module_preview', 'call_module_fork_static', 'call_module_publish', 'call_module_publish_only')) {
            $workflow.jobs[$jobName].concurrency.group | Should -Be 'generic-module-${{ matrix.modulePath }}'
            $workflow.jobs[$jobName].concurrency.queue | Should -Be 'max'
            $workflow.jobs[$jobName].strategy.'max-parallel' | Should -Be 1
        }
    }

    It 'keeps automatic preview permissions read-only' {
        $workflow.jobs.call_module_preview.permissions.contents | Should -Be 'read'
        $workflow.jobs.call_module_fork_static.permissions.contents | Should -Be 'read'
        $previewWorkflow.jobs.Values.permissions.contents | Should -Not -Contain 'write'
        $staticWorkflow.jobs.Values.permissions.contents | Should -Not -Contain 'write'
        $previewWorkflow.jobs.ContainsKey('job_publish_module') | Should -BeFalse
    }

    It 'checks opted-in labeled and synchronized pull requests against the merge commit' {
        $workflow.on.pull_request.types | Should -Be @('labeled', 'synchronize')
        $initialize = $workflow.jobs.job_initialize_pipeline
        $matrixStep = $initialize.steps | Where-Object { $_.id -eq 'get-module-matrix' }

        $initialize.if | Should -Match ([regex]::Escape("contains(github.event.pull_request.labels.*.name, 'PR: Run Checks')"))
        $initialize.if | Should -Match ([regex]::Escape("github.event.label.name == 'PR: Run Checks'"))
        $matrixStep.env.BASE_SHA | Should -Be '${{ case(github.event_name == ''pull_request'', github.event.pull_request.base.sha, github.event.before) }}'
        $matrixStep.env.HEAD_SHA | Should -Be '${{ github.sha }}'
        $matrixStep.run | Should -Match 'Pull request base commit'
        $matrixStep.run | Should -Match ([regex]::Escape('-ExcludeMetadataChanges:($env:EVENT_NAME -ne ''pull_request'')'))
    }

    It 'runs full validation only for internal pull requests' {
        $preview = $workflow.jobs.call_module_preview
        $preview.if | Should -Match "github.event_name == 'push'"
        $preview.if | Should -Match 'github.event.pull_request.head.repo.full_name == github.repository'
        $preview.permissions.'id-token' | Should -Be 'write'
        $preview.secrets | Should -Be 'inherit'
    }

    It 'runs only secret-free static checks for fork pull requests' {
        $fork = $workflow.jobs.call_module_fork_static
        $fork.if | Should -Match "github.event_name == 'pull_request'"
        $fork.if | Should -Match 'github.event.pull_request.head.repo.full_name != github.repository'
        $fork.uses | Should -Be './.github/workflows/avm.template.module.static.yml'
        @($fork.with.Keys) | Should -Be @('modulePath')
        $fork.permissions.Count | Should -Be 1
        $fork.permissions.ContainsKey('id-token') | Should -BeFalse
        $fork.ContainsKey('secrets') | Should -BeFalse

        @($staticWorkflow.jobs.Keys) | Should -Be @('job_module_static_validation')
        $staticJob = $staticWorkflow.jobs.job_module_static_validation
        $staticJob.permissions.contents | Should -Be 'read'
        @($staticJob.steps.uses) | Should -Be @($previewWorkflow.jobs.job_module_static_validation.steps.uses)
        $staticJob.steps[2].with.modulePath | Should -Be '${{ inputs.modulePath }}'
        ($staticWorkflow | ConvertTo-Json -Depth 10) | Should -Not -Match 'vars\.|secrets\.|id-token'
        $previewWorkflow.jobs.job_preview_module.if | Should -Match "github.event_name == 'push'"
    }

    It 'excludes metadata-only pushes without changing manual publishing' {
        $workflow.on.push.paths | Should -Be @('avm/**', '!avm/**/README.md', '!avm/**/metadata.json')
        $matrixStep = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
        $matrixStep.run | Should -Match ([regex]::Escape('Get-ModuleWorkflowMatrix -ChangedFilePath $changedFilePaths -ExcludeMetadataChanges'))
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
        $workflow.jobs.call_module_fork_static.uses | Should -Be './.github/workflows/avm.template.module.static.yml'
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

Describe 'Generic module pull request matrix' {

    BeforeAll {
        $workflowPath = Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml'
        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -Path $workflowPath -Raw)
        $matrixStep = $workflow.jobs.job_initialize_pipeline.steps | Where-Object { $_.id -eq 'get-module-matrix' }
        $testRepo = Join-Path $TestDrive 'module-repo'
        $scriptFolder = Join-Path $testRepo 'utilities' 'pipelines' 'sharedScripts'
        $moduleFolder = Join-Path $testRepo 'avm' 'res' 'test' 'module'
        $null = New-Item -Path $scriptFolder, $moduleFolder -ItemType Directory -Force
        Copy-Item -Path (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleWorkflowMatrix.ps1') -Destination $scriptFolder
        Set-Content -Path (Join-Path $moduleFolder 'main.bicep') -Value "metadata name = 'test'"

        git -C $testRepo init --quiet
        git -C $testRepo config core.autocrlf false
        git -C $testRepo add --all
        git -C $testRepo -c user.name=WorkflowTest -c user.email=test@example.invalid commit --quiet -m base
        if ($LASTEXITCODE -ne 0) { throw 'Failed to create the test base commit.' }
        $baseCommit = git -C $testRepo rev-parse HEAD

        Set-Content -Path (Join-Path $moduleFolder 'metadata.json') -Value '{"name":"test"}'
        git -C $testRepo add --all
        git -C $testRepo -c user.name=WorkflowTest -c user.email=test@example.invalid commit --quiet -m metadata
        if ($LASTEXITCODE -ne 0) { throw 'Failed to create the test head commit.' }
        $headCommit = git -C $testRepo rev-parse HEAD

        $environmentNames = @(
            'BASE_SHA', 'CREATE_RELEASE_TAG', 'CUSTOM_LOCATION', 'DEPLOYMENT_VALIDATION',
            'EVENT_NAME', 'HEAD_SHA', 'MODULE_PATH_INPUT', 'PUBLISH_ONLY',
            'REMOVE_DEPLOYMENT', 'STATIC_VALIDATION', 'GITHUB_WORKSPACE', 'GITHUB_OUTPUT'
        )

        function Invoke-MatrixStep {
            Push-Location $testRepo
            try {
                $null = . ([scriptblock]::Create($matrixStep.run))
                $outputs = @{}
                foreach ($line in (Get-Content -Path $env:GITHUB_OUTPUT)) {
                    $name, $value = $line.Split('=', 2)
                    $outputs[$name] = $value
                }
                return $outputs
            } finally {
                Pop-Location
            }
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
        }
        $savedExitCode = $global:LASTEXITCODE
        $env:BASE_SHA = $baseCommit
        $env:CREATE_RELEASE_TAG = 'false'
        $env:CUSTOM_LOCATION = ''
        $env:DEPLOYMENT_VALIDATION = 'true'
        $env:HEAD_SHA = $headCommit
        $env:MODULE_PATH_INPUT = ''
        $env:PUBLISH_ONLY = 'false'
        $env:REMOVE_DEPLOYMENT = 'true'
        $env:STATIC_VALIDATION = 'true'
        $env:GITHUB_WORKSPACE = $testRepo
        $env:GITHUB_OUTPUT = Join-Path $TestDrive ("matrix-{0}.txt" -f [guid]::NewGuid())
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
        $global:LASTEXITCODE = $savedExitCode
    }

    It 'selects metadata-only changes for a pull request' {
        $env:EVENT_NAME = 'pull_request'

        $outputs = Invoke-MatrixStep

        $outputs.baseCommit | Should -Be $baseCommit
        $outputs.targetCommit | Should -Be $headCommit
        $outputs.hasModules | Should -Be 'true'
        $outputs.includeAllVersionedModules | Should -Be 'false'
        @(($outputs.moduleMatrix | ConvertFrom-Json).include.modulePath) | Should -Be @('avm/res/test/module')
        ($outputs.workflowInput | ConvertFrom-Json).deploymentValidation | Should -Be 'true'
    }

    It 'still excludes metadata-only changes on pushes' {
        $env:EVENT_NAME = 'push'

        $outputs = Invoke-MatrixStep

        $outputs.hasModules | Should -Be 'false'
        @(($outputs.moduleMatrix | ConvertFrom-Json).include).Count | Should -Be 0
    }

    It 'rejects an unavailable pull request base instead of checking every module' {
        $env:EVENT_NAME = 'pull_request'
        $env:BASE_SHA = '0000000000000000000000000000000000000000'

        { Invoke-MatrixStep } | Should -Throw '*Pull request base commit*unavailable*'
        Test-Path -Path $env:GITHUB_OUTPUT | Should -BeFalse
    }
}

Describe 'Module workflow path filters' {

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
        $genericWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'avm.module.yml') -Raw)

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

    It 'skips generic workflow for metadata-only changes while retaining source changes' {
        $paths = $genericWorkflow.on.push.paths
        foreach ($metadataPath in @('metadata.json', 'child/metadata.json', 'child/nested/metadata.json')) {
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("avm/res/storage/storage-account/$metadataPath") |
                Should -BeFalse
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("avm/res/storage/storage-account/$metadataPath", 'avm/res/storage/storage-account/README.md') |
                Should -BeFalse
            Test-ModulePushPaths -Patterns $paths -ChangedFiles @("avm/res/storage/storage-account/$metadataPath", 'avm/res/storage/storage-account/main.bicep') |
                Should -BeTrue
        }

        Test-ModulePushPaths -Patterns $paths -ChangedFiles @('avm/res/storage/storage-account/metadata.json', 'avm/res/network/virtual-network/main.bicep') |
            Should -BeTrue
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
