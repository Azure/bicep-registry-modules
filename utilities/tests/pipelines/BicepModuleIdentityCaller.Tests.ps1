param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeDiscovery {
    $moduleCallers = @(
        Get-ChildItem -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows') -File -Filter 'avm.*.yml' |
            Where-Object { $_.Name -match '^avm\.(res|ptn|utl)\.' } |
            ForEach-Object {
                @{
                    WorkflowFileName = $_.Name
                    Workflow         = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $_.FullName -Raw)
                }
            }
    )
    if ($moduleCallers.Count -eq 0) {
        throw 'No module workflow callers were discovered.'
    }
}

Describe 'Module identity caller context' {
    BeforeAll {
        function Assert-ModuleIdentityCaller {
            param(
                [hashtable] $Workflow,
                [string] $WorkflowFileName,
                [string] $RepositoryRoot = $RepoRootPath
            )

            $modulePath = $Workflow.env.modulePath
            $modulePath | Should -MatchExactly '\Aavm/(res|ptn|utl)/[a-z0-9]+(?:-[a-z0-9]+)*(?:/[a-z0-9]+(?:-[a-z0-9]+)*)+\z'
            Test-Path -LiteralPath (Join-Path $RepositoryRoot $modulePath 'main.bicep') -PathType Leaf |
                Should -BeTrue
            $expectedFileName = $modulePath.Replace('/', '.') + '.yml'
            $WorkflowFileName | Should -BeExactly $expectedFileName
            $Workflow.env.workflowPath | Should -BeExactly ".github/workflows/$expectedFileName"
            @($Workflow.on.push.branches) | Should -Be @('main')

            $initialize = $Workflow.jobs.job_initialize_pipeline
            ($initialize.outputs.modulePath -replace '\s', '') | Should -Be '${{env.modulePath}}'
            $call = $Workflow.jobs.'call-workflow-passing-data'
            ($call.with.modulePath -replace '\s', '') |
                Should -Be '${{needs.job_initialize_pipeline.outputs.modulePath}}'
            $call.permissions.'id-token' | Should -Be 'write'
            $call.secrets | Should -Be 'inherit'
            @($call.with.Keys | Where-Object { $_ -match '(?i)client.?id|credential|tenant.?id|subscription.?id|workflow.?ref|subject' }) |
                Should -BeNullOrEmpty
            @($Workflow.env.Keys | Where-Object { $_ -match '^(VALIDATE_MODULE_CLIENT_IDS|VALIDATE_CLIENT_ID|AZURE_CREDENTIALS)$' }) |
                Should -BeNullOrEmpty
        }

        $reference = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'avm.res.network.route-table.yml') -Raw
        )
    }

    It 'preserves canonical module and original caller context in <WorkflowFileName>' -ForEach $moduleCallers {
        Assert-ModuleIdentityCaller -Workflow $Workflow -WorkflowFileName $WorkflowFileName
    }

    It 'accepts an existing canonical caller root without assuming a fixed path depth' {
        $fixture = $reference | ConvertTo-Json -Depth 30 | ConvertFrom-Json -AsHashtable
        $fixture.env.modulePath = 'avm/ptn/platform/deep/solution'
        $fileName = $fixture.env.modulePath.Replace('/', '.') + '.yml'
        $fixture.env.workflowPath = ".github/workflows/$fileName"
        $moduleFolder = Join-Path $TestDrive $fixture.env.modulePath
        $null = New-Item -Path $moduleFolder -ItemType Directory -Force
        $null = New-Item -Path (Join-Path $moduleFolder 'main.bicep') -ItemType File

        Assert-ModuleIdentityCaller -Workflow $fixture -WorkflowFileName $fileName -RepositoryRoot $TestDrive
    }

    It 'rejects <Name>' -ForEach @(
        @{
            Name   = 'a child path substituted for the root identity key'
            Mutate = { param($workflow) $workflow.env.modulePath = 'avm/res/network/route-table/route' }
        }
        @{
            Name   = 'a different existing root under the original workflow file'
            Mutate = { param($workflow) $workflow.env.modulePath = 'avm/res/network/virtual-network' }
        }
        @{
            Name   = 'a root that does not exist'
            Mutate = { param($workflow) $workflow.env.modulePath = 'avm/res/example/missing' }
        }
        @{
            Name   = 'noncanonical casing in the identity key'
            Mutate = { param($workflow) $workflow.env.modulePath = 'avm/res/Network/route-table' }
        }
        @{
            Name   = 'a parent traversal in the identity path'
            Mutate = { param($workflow) $workflow.env.modulePath = 'avm/res/network/../route-table' }
        }
        @{
            Name   = 'a workflow path for a different original caller'
            Mutate = { param($workflow) $workflow.env.workflowPath = '.github/workflows/avm.module.yml' }
        }
        @{
            Name   = 'a module argument bypassing initializer output'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.modulePath = 'avm/res/network/virtual-network' }
        }
        @{
            Name   = 'a shared client passed as a new workflow input'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.'client-id' = '${{ vars.VALIDATE_CLIENT_ID }}' }
        }
        @{
            Name   = 'a new workflow-ref authentication input'
            Mutate = { param($workflow) $workflow.jobs.'call-workflow-passing-data'.with.'workflow-ref' = '${{ github.workflow_ref }}' }
        }
        @{
            Name   = 'a caller-local identity mapping override'
            Mutate = { param($workflow) $workflow.env.VALIDATE_MODULE_CLIENT_IDS = '{}' }
        }
    ) {
        $fixture = $reference | ConvertTo-Json -Depth 30 | ConvertFrom-Json -AsHashtable
        . $Mutate $fixture

        { Assert-ModuleIdentityCaller -Workflow $fixture -WorkflowFileName 'avm.res.network.route-table.yml' } |
            Should -Throw
    }
}

Describe 'Generic module identity caller context' {
    BeforeAll {
        $workflow = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'avm.module.yml') -Raw
        )
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleWorkflowMatrix.ps1')
    }

    It 'retains generic and bulk deployment controls without adding identity inputs' {
        $workflow.on.workflow_dispatch.inputs.modulePaths.required | Should -BeTrue
        $workflow.on.workflow_dispatch.inputs.deploymentValidation.default | Should -BeTrue
        @($workflow.on.push.branches) | Should -Be @('main')
        @($workflow.on.workflow_dispatch.inputs.Keys |
            Where-Object { $_ -match '(?i)client.?id|credential|tenant.?id|subscription.?id|workflow.?ref|subject' }) |
            Should -BeNullOrEmpty
    }

    It 'preserves pull-request selection without adding workflow-ref or base-branch gates' {
        @($workflow.on.pull_request.Keys) | Should -Be @('types')
        $workflow.on.pull_request.types | Should -Be @('labeled', 'synchronize')
        foreach ($job in @('job_initialize_pipeline', 'call_module_preview', 'call_module_fork_static')) {
            $workflow.jobs[$job].if |
                Should -Not -Match 'github\.(base_ref|event\.pull_request\.base\.ref|workflow_ref|job_workflow_ref)'
        }
        $workflow.jobs.call_module_preview.if |
            Should -Be '${{ (github.event_name == ''push'' || (github.event_name == ''pull_request'' && github.event.pull_request.head.repo.full_name == github.repository)) && needs.job_initialize_pipeline.outputs.hasModules == ''true'' }}'
    }

    It 'checks out the event commit before resolving generic module roots' {
        $checkout = @($workflow.jobs.job_initialize_pipeline.steps |
            Where-Object { $_.uses -like 'actions/checkout@*' })
        $checkout.Count | Should -Be 1
        $checkout[0].with.ref | Should -Be '${{ github.sha }}'
    }

    It 'forwards each matrix root to <Job> without choosing another client' -ForEach @(
        @{ Job = 'call_module_preview' }
        @{ Job = 'call_module_publish' }
    ) {
        $call = $workflow.jobs[$Job]
        $call.with.modulePath | Should -Be '${{ matrix.modulePath }}'
        $call.with.workflowInput | Should -Be '${{ needs.job_initialize_pipeline.outputs.workflowInput }}'
        $call.permissions.'id-token' | Should -Be 'write'
        $call.secrets | Should -Be 'inherit'
        @($call.with.Keys | Where-Object { $_ -match '(?i)client.?id|credential|tenant.?id|subscription.?id|workflow.?ref|subject' }) |
            Should -BeNullOrEmpty
    }

    It 'resolves child <Path> through the existing canonical-root selector' -ForEach @(
        @{ Path = 'avm/res/storage/storage-account/blob-service/container'; Root = 'avm/res/storage/storage-account' }
        @{ Path = 'avm/res/network/virtual-network/subnet'; Root = 'avm/res/network/virtual-network' }
        @{ Path = 'avm/res/authorization/policy-assignment/mg-scope'; Root = 'avm/res/authorization/policy-assignment' }
    ) {
        $matrix = Get-ModuleWorkflowMatrix -ModulePathInput $Path -RepoRoot $RepoRootPath
        @($matrix.include).Count | Should -Be 1
        $matrix.include[0].modulePath | Should -BeExactly $Root
        $rootWorkflowPath = Join-Path $RepoRootPath '.github' 'workflows' ($Root.Replace('/', '.') + '.yml')
        $rootWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $rootWorkflowPath -Raw)
        $rootWorkflow.env.modulePath | Should -BeExactly $matrix.include[0].modulePath
    }

    It 'retains separate canonical roots in a bulk request containing children' {
        $matrix = Get-ModuleWorkflowMatrix -ModulePathInput (
            'avm/res/storage/storage-account/blob-service/container,' +
            'avm/res/network/virtual-network/subnet,' +
            'avm/res/storage/storage-account'
        ) -RepoRoot $RepoRootPath

        @($matrix.include.modulePath) | Should -Be @(
            'avm/res/network/virtual-network'
            'avm/res/storage/storage-account'
        )
    }
}
