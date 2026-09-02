param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Get-ModuleWorkflowMatrix' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleWorkflowMatrix.ps1')
    }

    It 'Resolves a single module path' {
        $result = Get-ModuleWorkflowMatrix -ModulePathInput 'avm/res/storage/storage-account' -RepoRoot $repoRootPath

        $result.include.modulePath | Should -Be @('avm/res/storage/storage-account')
        $result.include.concurrencyGroup | Should -Be @('avm.res.storage.storage-account')
    }

    It 'Resolves comma-separated paths and removes duplicates' {
        $inputPaths = 'avm/res/storage/storage-account, avm/res/network/virtual-network, avm/res/storage/storage-account'

        $result = Get-ModuleWorkflowMatrix -ModulePathInput $inputPaths -RepoRoot $repoRootPath

        $result.include.modulePath | Should -Be @(
            'avm/res/network/virtual-network'
            'avm/res/storage/storage-account'
        )
    }

    It 'Maps child paths and changed files to their top-level module' {
        $result = Get-ModuleWorkflowMatrix -ChangedFilePath @(
            'avm/res/storage/storage-account/blob-service/container/main.bicep'
            'avm/res/storage/storage-account/tests/e2e/defaults/main.test.bicep'
            '.github/workflows/avm.module.yml'
        ) -RepoRoot $repoRootPath

        $result.include.modulePath | Should -Be @('avm/res/storage/storage-account')
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
}
