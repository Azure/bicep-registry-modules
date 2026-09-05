param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Get-ModuleWorkflowMatrix' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleWorkflowMatrix.ps1')
    }

    It 'Resolves a single module path with its test matrices' {
        $result = Get-ModuleWorkflowMatrix -ModulePathInput 'avm/res/storage/storage-account' -RepoRoot $repoRootPath

        $result.include.modulePath | Should -Be @('avm/res/storage/storage-account')
        @($result.include.moduleTestFilePaths | ConvertFrom-Json).Count | Should -BeGreaterThan 0
        @($result.include.psRuleModuleTestFilePaths | ConvertFrom-Json).Count | Should -BeGreaterThan 0
    }

    It 'Resolves comma-separated paths and removes duplicates' {
        $inputPaths = 'avm/res/storage/storage-account, avm/res/network/virtual-network, avm/res/storage/storage-account'

        $result = Get-ModuleWorkflowMatrix -ModulePathInput $inputPaths -RepoRoot $repoRootPath

        $result.include.modulePath | Should -Be @(
            'avm/res/network/virtual-network'
            'avm/res/storage/storage-account'
        )
    }

    It 'Maps child paths to their top-level module and ignores README changes' {
        $result = Get-ModuleWorkflowMatrix -ChangedFilePath @(
            'avm/res/storage/storage-account/blob-service/container/main.bicep'
            'avm/res/storage/storage-account/tests/e2e/defaults/main.test.bicep'
            'avm/res/network/virtual-network/README.md'
            '.github/workflows/avm.module.yml'
        ) -RepoRoot $repoRootPath

        $result.include.modulePath | Should -Be @('avm/res/storage/storage-account')
    }

    It 'Returns an empty matrix for README-only changes' {
        $result = Get-ModuleWorkflowMatrix -ChangedFilePath @(
            'avm/res/network/virtual-network/README.md'
        ) -RepoRoot $repoRootPath

        $result.include.Count | Should -Be 0
    }

    It 'Rejects a missing manual module path' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput 'avm/res/example/missing'
        } | Should -Throw 'No top-level AVM module was found at path*'
    }

    It 'Rejects an empty path in a comma-separated list' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput 'avm/res/storage/storage-account,'
        } | Should -Throw 'Every module path must be a non-empty string.'
    }

    It 'Rejects wildcard module paths' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput 'avm/res/*/*'
        } | Should -Throw '*contains wildcard characters.'
    }

    It 'Rejects parent-directory traversal' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput 'avm/res/storage/storage-account/../../network/virtual-network'
        } | Should -Throw '*contains a parent-directory segment.'
    }
}
