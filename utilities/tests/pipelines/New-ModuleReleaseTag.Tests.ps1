param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'New-ModuleReleaseTag' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'helper' 'New-ModuleReleaseTag.ps1')

        function New-ReleaseTagTestRepository {
            $testRootPath = Join-Path $TestDrive ([guid]::NewGuid().ToString())
            $remotePath = Join-Path $testRootPath 'remote.git'
            $repoPath = Join-Path $testRootPath 'repo'
            $modulePath = Join-Path $repoPath 'avm' 'res' 'test' 'module'

            git init --bare $remotePath | Out-Null
            git init $repoPath | Out-Null
            git -C $repoPath config user.email 'avm-tests@example.com'
            git -C $repoPath config user.name 'AVM Tests'
            git -C $repoPath remote add origin $remotePath

            $null = New-Item -Path $modulePath -ItemType Directory -Force
            Set-Content -Path (Join-Path $modulePath 'main.bicep') -Value 'metadata name = ''test'''
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
        $testRepository = New-ReleaseTagTestRepository
        $script:modulePath = $testRepository.modulePath
        $script:repoPath = $testRepository.repoPath
        Push-Location $script:repoPath
    }

    AfterEach {
        Pop-Location
    }

    It 'Creates a release tag' {
        $result = New-ModuleReleaseTag -ModuleFolderPath $script:modulePath -TargetVersion '1.0.0'

        $result | Should -Be 'avm/res/test/module/1.0.0'
        git ls-remote --tags origin 'avm/res/test/module/1.0.0' | Should -Not -BeNullOrEmpty
    }

    It 'Reuses an existing release tag at the current commit' {
        $null = New-ModuleReleaseTag -ModuleFolderPath $script:modulePath -TargetVersion '1.0.0'

        $result = New-ModuleReleaseTag -ModuleFolderPath $script:modulePath -TargetVersion '1.0.0'

        $result | Should -Be 'avm/res/test/module/1.0.0'
    }

    It 'Rejects an existing release tag at a different commit' {
        $null = New-ModuleReleaseTag -ModuleFolderPath $script:modulePath -TargetVersion '1.0.0'

        Add-Content -Path (Join-Path $script:modulePath 'main.bicep') -Value 'metadata description = ''updated'''
        git add .
        git commit -m 'Second commit' | Out-Null

        {
            New-ModuleReleaseTag -ModuleFolderPath $script:modulePath -TargetVersion '1.0.0'
        } | Should -Throw '*already exists at a different commit.'
    }
}
