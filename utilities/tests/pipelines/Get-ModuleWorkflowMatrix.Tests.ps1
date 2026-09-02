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

    It 'Resolves a JSON array and removes duplicate module paths' {
        $inputPaths = '["avm/res/storage/storage-account","avm/res/network/virtual-network","avm/res/storage/storage-account"]'

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

    It 'Rejects malformed JSON input' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput '["avm/res/storage/storage-account"'
        } | Should -Throw 'The module path input must be a module path or a valid JSON array of module paths.'
    }

    It 'Rejects an empty JSON array' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput '[]'
        } | Should -Throw 'The module path array must contain at least one module path.'
    }

    It 'Rejects a JSON scalar string' {
        {
            Get-ModuleWorkflowMatrix -ModulePathInput '"avm/res/storage/storage-account"'
        } | Should -Throw 'JSON module path input must be a non-empty array of strings.'
    }
}
