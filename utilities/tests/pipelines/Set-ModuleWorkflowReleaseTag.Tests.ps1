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
                remotePath = $remotePath
                repoPath   = $repoPath
            }
        }
    }

    BeforeEach {
        $testRepository = Initialize-ReleaseTagTestRepository
        $script:modulePath = $testRepository.modulePath
        $script:remotePath = $testRepository.remotePath
        $script:repoPath = $testRepository.repoPath
        $script:originalGitHubRepository = $env:GITHUB_REPOSITORY
        $env:GITHUB_REPOSITORY = 'Azure/bicep-registry-modules'
        Mock Invoke-ModuleReleaseTagGitHubApi {
            param (
                [string] $Repository,
                [string] $TagName,
                [string] $TargetCommit,
                [string] $GitHubToken
            )

            git --git-dir $script:remotePath update-ref "refs/tags/$TagName" $TargetCommit
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to create test tag [$TagName]."
            }
        }
        Push-Location $script:repoPath
    }

    AfterEach {
        Pop-Location
        $env:GITHUB_REPOSITORY = $script:originalGitHubRepository
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
        Should -Invoke Invoke-ModuleReleaseTagGitHubApi -Times 1 -Exactly
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

    It 'Reuses a tag created concurrently after an API failure' {
        Mock Invoke-ModuleReleaseTagGitHubApi {
            param (
                [string] $Repository,
                [string] $TagName,
                [string] $TargetCommit,
                [string] $GitHubToken
            )

            git --git-dir $script:remotePath update-ref "refs/tags/$TagName" $TargetCommit
            throw 'Simulated create conflict.'
        }

        $result = Set-ModuleWorkflowReleaseTag `
            -TemplateFilePath (Join-Path $script:modulePath 'main.bicep') `
            -RepoRoot $script:repoPath `
            -Force

        $result['avm/res/test/module'].gitTagName | Should -Be 'avm/res/test/module/1.0.0'
    }

    It 'Rejects a tag created concurrently at a different commit' {
        $script:conflictingCommit = git rev-parse HEAD
        git commit --allow-empty -m 'Target commit' | Out-Null
        $targetCommit = git rev-parse HEAD
        Mock Invoke-ModuleReleaseTagGitHubApi {
            param (
                [string] $Repository,
                [string] $TagName,
                [string] $TargetCommit,
                [string] $GitHubToken
            )

            git --git-dir $script:remotePath update-ref "refs/tags/$TagName" $script:conflictingCommit
            throw 'Simulated create conflict.'
        }

        {
            New-ModuleWorkflowReleaseTag `
                -ModuleFolderPath $script:modulePath `
                -TargetVersion '1.0.0' `
                -TargetCommit $targetCommit
        } | Should -Throw '*concurrently created at a different commit*'
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

Describe 'Invoke-ModuleReleaseTagGitHubApi' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'helper' 'New-ModuleReleaseTagReference.ps1')
    }

    BeforeEach {
        $script:originalGhToken = $env:GH_TOKEN
        $env:GH_TOKEN = 'test-token'
        Mock Invoke-RestMethod { }
    }

    AfterEach {
        $env:GH_TOKEN = $script:originalGhToken
    }

    It 'Creates the exact lightweight tag through the Git Refs API' {
        $expectedBody = @{
            ref = 'refs/tags/avm/res/test/module/1.0.0'
            sha = '0123456789012345678901234567890123456789'
        } | ConvertTo-Json -Compress

        Invoke-ModuleReleaseTagGitHubApi `
            -Repository 'Azure/bicep-registry-modules' `
            -TagName 'avm/res/test/module/1.0.0' `
            -TargetCommit '0123456789012345678901234567890123456789'

        Should -Invoke Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
            $Uri -eq 'https://api.github.com/repos/Azure/bicep-registry-modules/git/refs' -and
            $Method -eq 'Post' -and
            $ContentType -eq 'application/json' -and
            $Body -eq $expectedBody -and
            $Headers.Authorization -eq 'Bearer test-token'
        }
    }
}

Describe 'New-ModuleReleaseTag' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'helper' 'New-ModuleReleaseTag.ps1')
    }

    BeforeEach {
        $testRootPath = Join-Path $TestDrive ([guid]::NewGuid().ToString())
        $script:legacyRemotePath = Join-Path $testRootPath 'remote.git'
        $script:legacyRepoPath = Join-Path $testRootPath 'repo'
        $script:legacyModulePath = Join-Path $script:legacyRepoPath 'avm' 'res' 'test' 'module'
        $null = New-Item -Path $script:legacyModulePath -ItemType Directory -Force
        Set-Content -Path (Join-Path $script:legacyModulePath 'main.bicep') -Value "metadata name = 'test'"
        git init --bare $script:legacyRemotePath | Out-Null
        git init $script:legacyRepoPath | Out-Null
        git -C $script:legacyRepoPath config user.email 'avm-tests@example.com'
        git -C $script:legacyRepoPath config user.name 'AVM Tests'
        git -C $script:legacyRepoPath remote add origin $script:legacyRemotePath
        git -C $script:legacyRepoPath add .
        git -C $script:legacyRepoPath commit -m 'Initial commit' | Out-Null
        git -C $script:legacyRepoPath push -u origin HEAD:main | Out-Null
        $script:originalGitHubRepository = $env:GITHUB_REPOSITORY
        $env:GITHUB_REPOSITORY = 'Azure/bicep-registry-modules'
        Mock Invoke-ModuleReleaseTagGitHubApi {
            param (
                [string] $Repository,
                [string] $TagName,
                [string] $TargetCommit,
                [string] $GitHubToken
            )

            git --git-dir $script:legacyRemotePath update-ref "refs/tags/$TagName" $TargetCommit
        }
        Push-Location $script:legacyRepoPath
    }

    AfterEach {
        Pop-Location
        $env:GITHUB_REPOSITORY = $script:originalGitHubRepository
    }

    It 'Creates the legacy release tag through the Git Refs API helper' {
        $targetCommit = git rev-parse HEAD

        $result = New-ModuleReleaseTag `
            -ModuleFolderPath $script:legacyModulePath `
            -TargetVersion '1.0.0'

        $result | Should -Be 'avm/res/test/module/1.0.0'
        Should -Invoke Invoke-ModuleReleaseTagGitHubApi -Times 1 -Exactly -ParameterFilter {
            $Repository -eq 'Azure/bicep-registry-modules' -and
            $TagName -eq 'avm/res/test/module/1.0.0' -and
            $TargetCommit -eq $targetCommit
        }
    }
}
