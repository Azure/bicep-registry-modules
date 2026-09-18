param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Set-ModuleWorkflowReleaseTag' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'Set-ModuleWorkflowReleaseTag.ps1')

        function Initialize-TestModule {
            param (
                [Parameter(Mandatory)]
                [string] $Path,

                [Parameter()]
                [string] $Version = '1.0'
            )

            $null = New-Item -Path $Path -ItemType Directory -Force
            Set-Content -Path (Join-Path $Path 'main.bicep') -Value "metadata name = 'test'"
            Set-Content -Path (Join-Path $Path 'main.json') -Value '{}'
            Set-Content -Path (Join-Path $Path 'version.json') -Value (@{ version = $Version } | ConvertTo-Json)
            Set-Content -Path (Join-Path $Path 'metadata.json') -Value '{"telemetryIdPrefix":"test"}'
        }

        function Initialize-ReleaseTagTestRepository {
            $testRootPath = Join-Path $TestDrive ([guid]::NewGuid().ToString())
            $remotePath = Join-Path $testRootPath 'remote.git'
            $repoPath = Join-Path $testRootPath 'repo'
            $modulePath = Join-Path $repoPath 'avm' 'res' 'test' 'module'

            git init --bare $remotePath | Out-Null
            git init $repoPath | Out-Null
            git -C $repoPath config user.email 'avm-tests@example.com'
            git -C $repoPath config user.name 'AVM Tests'
            git -C $repoPath remote add origin $remotePath
            Initialize-TestModule -Path $modulePath
            git -C $repoPath add .
            git -C $repoPath commit -m 'Initial commit' | Out-Null
            git -C $repoPath push -u origin HEAD:main | Out-Null

            return @{
                modulePath = $modulePath
                repoPath   = $repoPath
            }
        }
    }

    BeforeEach {
        $testRepository = Initialize-ReleaseTagTestRepository
        $script:modulePath = $testRepository.modulePath
        $script:repoPath = $testRepository.repoPath
        Push-Location $script:repoPath
    }

    AfterEach {
        Pop-Location
    }

    It 'Previews a forced release tag without creating it' {
        $result = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -Force `
            -WhatIf

        $result['avm/res/test/module'].version | Should -Be '1.0.0'
        $result['avm/res/test/module'].gitTagName | Should -BeNullOrEmpty
        git ls-remote --tags origin 'avm/res/test/module/1.0.0' | Should -BeNullOrEmpty
    }

    It 'Creates and then reuses a lightweight tag at the same commit' {
        $firstResult = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -Force
        $secondResult = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -Force

        $firstResult['avm/res/test/module'].gitTagName | Should -Be 'avm/res/test/module/1.0.0'
        $secondResult['avm/res/test/module'].gitTagName | Should -Be 'avm/res/test/module/1.0.0'
    }

    It 'Reuses an annotated tag that points at the target commit' {
        git tag -a 'avm/res/test/module/1.0.0' -m 'Annotated release'
        git push origin 'avm/res/test/module/1.0.0' | Out-Null

        $result = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -Force

        $result['avm/res/test/module'].gitTagName | Should -Be 'avm/res/test/module/1.0.0'
    }

    It 'Rejects an annotated tag at a different commit' {
        git tag -a 'avm/res/test/module/1.0.0' -m 'Annotated release'
        git push origin 'avm/res/test/module/1.0.0' | Out-Null
        Add-Content -Path (Join-Path $script:modulePath 'main.bicep') -Value "metadata description = 'updated'"
        git add .
        git commit -m 'Second commit' | Out-Null
        $targetCommit = git rev-parse HEAD

        {
            New-ModuleWorkflowReleaseTag `
                -ModuleFolderPath $script:modulePath `
                -TargetVersion '1.0.0' `
                -TargetCommit $targetCommit
        } | Should -Throw '*already exists at a different commit.'
    }

    It 'Surfaces a conflicting reset version during preview' {
        git tag 'avm/res/test/module/2.0.0'
        git push origin 'avm/res/test/module/2.0.0' | Out-Null
        $baseCommit = git rev-parse HEAD
        Set-Content -Path (Join-Path $script:modulePath 'version.json') -Value (@{ version = '2.0' } | ConvertTo-Json)
        git add .
        git commit -m 'Change major version' | Out-Null

        {
            Set-ModuleWorkflowReleaseTag `
                -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
                -RepoRoot $script:repoPath `
                -BaseCommit $baseCommit `
                -TargetCommit HEAD `
                -Force `
                -WhatIf
        } | Should -Throw '*already exists at a different commit.'
    }

    It 'Preserves equal-length child modules across a multi-commit range' {
        $ptrModulePath = Join-Path $script:modulePath 'ptr'
        $soaModulePath = Join-Path $script:modulePath 'soa'
        Initialize-TestModule -Path $ptrModulePath
        Initialize-TestModule -Path $soaModulePath
        git add .
        git commit -m 'Add child modules' | Out-Null
        $baseCommit = git rev-parse HEAD

        Set-Content -Path (Join-Path $ptrModulePath 'main.json') -Value '{"changed":true}'
        Set-Content -Path (Join-Path $soaModulePath 'main.json') -Value '{"changed":true}'
        git add .
        git commit -m 'Change child modules' | Out-Null
        Add-Content -Path (Join-Path $script:modulePath 'main.bicep') -Value "metadata description = 'later commit'"
        git add .
        git commit -m 'Add later commit' | Out-Null

        $result = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -BaseCommit $baseCommit `
            -TargetCommit HEAD `
            -Force `
            -WhatIf

        $result.Keys | Should -Contain 'avm/res/test/module'
        $result.Keys | Should -Contain 'avm/res/test/module/ptr'
        $result.Keys | Should -Contain 'avm/res/test/module/soa'
        $result.Count | Should -Be 3
    }

    It 'Does not create root or nested tags for metadata-only <Change> changes' -ForEach @(
        @{ Change = 'added' }
        @{ Change = 'modified' }
        @{ Change = 'deleted' }
    ) {
        $childPath = Join-Path $script:modulePath 'child'
        $nestedPath = Join-Path $childPath 'nested'
        Initialize-TestModule -Path $childPath
        Initialize-TestModule -Path $nestedPath
        $metadataPaths = @($script:modulePath, $childPath, $nestedPath) | ForEach-Object { Join-Path $_ 'metadata.json' }
        if ($Change -eq 'added') {
            $metadataPaths | Remove-Item
        }
        git add .
        git commit -m 'Prepare metadata fixtures' | Out-Null
        $baseCommit = git rev-parse HEAD

        if ($Change -eq 'deleted') {
            $metadataPaths | Remove-Item
        } else {
            $metadataPaths | ForEach-Object { Set-Content -Path $_ -Value '{"telemetryIdPrefix":"updated"}' }
        }
        git add .
        git commit -m 'Change metadata only' | Out-Null

        $result = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -BaseCommit $baseCommit `
            -TargetCommit HEAD

        $result.Count | Should -Be 0
        git ls-remote --tags origin | Should -BeNullOrEmpty
    }

    It 'Selects only source or version changes for <Scenario>' -ForEach @(
        @{ Scenario = 'root source'; ChangedPaths = @('main.json'); Templates = @('main.json') }
        @{ Scenario = 'root version'; ChangedPaths = @('version.json'); Templates = @('main.json') }
        @{ Scenario = 'child source'; ChangedPaths = @('child/main.json'); Templates = @('child/main.json') }
        @{ Scenario = 'nested version'; ChangedPaths = @('child/nested/version.json'); Templates = @('child/nested/main.json') }
        @{
            Scenario = 'root source with metadata-only children'
            ChangedPaths = @('main.json', 'child/metadata.json', 'child/nested/metadata.json')
            Templates = @('main.json')
        }
        @{
            Scenario = 'child source with metadata-only parent and sibling'
            ChangedPaths = @('metadata.json', 'child/main.json', 'sibling/metadata.json')
            Templates = @('child/main.json')
        }
    ) {
        foreach ($relativePath in @('child', 'child/nested', 'sibling')) {
            Initialize-TestModule -Path (Join-Path $script:modulePath $relativePath)
        }
        git add .
        git commit -m 'Add release selection fixtures' | Out-Null
        $baseCommit = git rev-parse HEAD
        foreach ($changedPath in $ChangedPaths) {
            Set-Content -Path (Join-Path $script:modulePath $changedPath) -Value '{"changed":true}'
        }
        git add .
        git commit -m 'Change selected module files' | Out-Null

        $result = @(Get-ModuleWorkflowTemplatesToPublish `
                -ModuleFolderPath $script:modulePath `
                -RepoRoot $script:repoPath `
                -BaseCommit $baseCommit `
                -TargetCommit HEAD)

        $result.Count | Should -Be $Templates.Count
        foreach ($template in $Templates) {
            $result | Should -Contain (Join-Path $script:modulePath $template)
        }
    }

    It 'Preserves explicit forced top-level releases after metadata-only changes' {
        $childPath = Join-Path $script:modulePath 'child'
        Initialize-TestModule -Path $childPath
        git add .
        git commit -m 'Add child fixture' | Out-Null
        $baseCommit = git rev-parse HEAD
        Set-Content -Path (Join-Path $childPath 'metadata.json') -Value '{"telemetryIdPrefix":"updated"}'
        git add .
        git commit -m 'Change child metadata only' | Out-Null

        $result = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -BaseCommit $baseCommit `
            -TargetCommit HEAD `
            -Force `
            -WhatIf

        $result.Count | Should -Be 1
        $result.Keys | Should -Contain 'avm/res/test/module'
        git ls-remote --tags origin | Should -BeNullOrEmpty
    }

    It 'Retries and fails a remote query explicitly' {
        {
            Invoke-ModuleWorkflowGitLsRemote `
                -Remote (Join-Path $TestDrive 'missing.git') `
                -Pattern 'avm/res/test/module/*' `
                -RetryCount 2 `
                -RetryDelaySeconds 0
        } | Should -Throw '*after*Git output*'
    }
}
