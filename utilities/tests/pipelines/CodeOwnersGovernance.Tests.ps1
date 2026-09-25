param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'CODEOWNERS governance' {
    BeforeAll {
        $testPath = Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'module.tests.ps1'
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($testPath, [ref] $null, [ref] $parseErrors)
        if ($parseErrors.Count -gt 0) {
            throw "Unable to parse module governance tests: $($parseErrors -join '; ')"
        }
        $ownershipTests = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.CommandAst] -and
                    $node.GetCommandName() -eq 'It' -and
                    $node.CommandElements[1].Extent.Text -like '*CODEOWNERS file.*'
                }, $true))
        if ($ownershipTests.Count -ne 1) {
            throw "Expected one CODEOWNERS governance assertion, found [$($ownershipTests.Count)]."
        }

        # Exercise the actual assertion without compiling unrelated Bicep modules during discovery.
        $script:assertOwnership = $ownershipTests[0].CommandElements[-1].ScriptBlock.GetScriptBlock()
        $null = New-Item -Path (Join-Path $TestDrive '.github') -ItemType Directory
        $script:ownershipMatchRepo = Join-Path $TestDrive 'ownership-matching'
        git init --quiet $script:ownershipMatchRepo
        if ($LASTEXITCODE -ne 0) {
            throw 'Unable to initialize the local CODEOWNERS matching fixture.'
        }
        $script:emptyGitExcludes = Join-Path $script:ownershipMatchRepo 'empty-excludes'
        Set-Content -Path $script:emptyGitExcludes -Value ''

        function Invoke-TestCodeOwnersGovernance {
            Set-Content -Path (Join-Path $TestDrive '.github' 'CODEOWNERS') -Value $script:ownershipRules
            . $script:assertOwnership -repoRootPath $TestDrive
        }

        function Get-TestCodeOwners {
            param (
                [Parameter(Mandatory)]
                [string] $Path
            )

            $rules = @($script:ownershipRules | ForEach-Object { $_.Trim() -replace '\s+', ' ' } | Where-Object { $_ -and -not $_.StartsWith('#') })
            # CODEOWNERS selects owners for files instead of pruning ignored directories.
            $patterns = @($rules | ForEach-Object {
                    $pattern = ($_ -split ' ')[0]
                    $pattern.EndsWith('/') ? "$pattern**" : $pattern
                }) + '!*/'
            Set-Content -Path (Join-Path $script:ownershipMatchRepo '.gitignore') -Value $patterns
            $match = git -C $script:ownershipMatchRepo -c "core.excludesFile=$script:emptyGitExcludes" check-ignore --no-index --verbose -- $Path
            if ($LASTEXITCODE -ne 0 -or $match -notmatch '^\.gitignore:(\d+):') {
                throw "Unable to resolve CODEOWNERS for [$Path] using Git's path matcher."
            }

            $tokens = $rules[[int] $matches[1] - 1] -split ' '
            return $tokens.Count -eq 1 ? @() : $tokens[1..($tokens.Count - 1)]
        }
    }

    BeforeEach {
        $script:ownershipRules = @(
            '* @Azure/azure-verified-modules-tooling-contributors'
            '/avm/'
            '*avm.core.team.tests.ps1 @Azure/azure-verified-modules-tooling-contributors'
            '*.e2eignore @Azure/azure-verified-modules-tooling-contributors'
            'metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners'
        )
    }

    It 'Accepts ownerless module governance' {
        Invoke-TestCodeOwnersGovernance
    }

    It 'Accepts the checked-in CODEOWNERS file' {
        $script:ownershipRules = @(Get-Content -Path (Join-Path $repoRootPath '.github' 'CODEOWNERS'))
        Invoke-TestCodeOwnersGovernance
    }

    It 'Leaves module files without code owners for <Path>' -ForEach @(
        @{ Path = 'avm/res/storage/storage-account/main.bicep' }
        @{ Path = 'avm/res/storage/storage-account/blob-service/container/main.bicep' }
        @{ Path = 'avm/ptn/network/hub-networking/main.bicep' }
        @{ Path = 'avm/utl/types/avm-common-types/main.bicep' }
        @{ Path = 'avm/README.md' }
    ) {
        $script:ownershipRules = @(Get-Content -Path (Join-Path $repoRootPath '.github' 'CODEOWNERS'))
        @(Get-TestCodeOwners -Path $Path) | Should -BeNullOrEmpty
    }

    It 'Allows engineering owners or module owners as the only approvers for <Path>' -ForEach @(
        @{ Path = 'metadata.json' }
        @{ Path = 'avm/res/storage/storage-account/metadata.json' }
        @{ Path = 'avm/res/storage/storage-account/blob-service/container/metadata.json' }
        @{ Path = 'avm/ptn/network/hub-networking/metadata.json' }
        @{ Path = 'avm/utl/types/avm-common-types/metadata.json' }
        @{ Path = 'utilities/metadata.json' }
        @{ Path = '.github/metadata.json' }
    ) {
        $script:ownershipRules = @(Get-Content -Path (Join-Path $repoRootPath '.github' 'CODEOWNERS'))
        @(Get-TestCodeOwners -Path $Path) | Should -Be @(
            '@Azure/azure-verified-modules-engineering-owners'
            '@Azure/azure-verified-modules-module-owners'
        )
    }

    It 'Preserves tooling ownership for <Path>' -ForEach @(
        @{ Path = 'avm/res/storage/storage-account/tests/unit/avm.core.team.tests.ps1' }
        @{ Path = 'avm/res/storage/storage-account/tests/e2e/defaults/.e2eignore' }
        @{ Path = 'utilities/script.ps1' }
        @{ Path = '.github/workflows/platform.toggle-avm-workflows.yml' }
    ) {
        $script:ownershipRules = @(Get-Content -Path (Join-Path $repoRootPath '.github' 'CODEOWNERS'))
        @(Get-TestCodeOwners -Path $Path) | Should -Be @('@Azure/azure-verified-modules-tooling-contributors')
    }

    It 'Ignores generation comments, blank lines and harmless whitespace' {
        $script:ownershipRules = @('# Generated ownership', '') + $script:ownershipRules + @('', '# End')
        $script:ownershipRules[2] = "  *`t@Azure/azure-verified-modules-tooling-contributors  "
        Invoke-TestCodeOwnersGovernance
    }

    It 'Rejects reintroduced per-module ownership: <Rule>' -ForEach @(
        @{ Rule = '/avm/res/storage/storage-account/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/ptn/ @Azure/azure-verified-modules-module-owners' }
    ) {
        $script:ownershipRules = @($script:ownershipRules[0..1]) + @($Rule) + @($script:ownershipRules[2..4])
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*per-module entries must not be reintroduced*'
    }

    It 'Rejects an owned module tree: <Rule>' -ForEach @(
        @{ Rule = '/avm/ @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/ @Azure/azure-verified-modules-module-contributors' }
    ) {
        $script:ownershipRules[1] = $Rule
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*the module tree must have no code owners*'
    }

    It 'Keeps repository-default ownership with the tooling team' {
        $script:ownershipRules[0] = '* @owner-one'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*the repository default must stay with the tooling team*'
    }

    It 'Rejects removal of a trailing override at index <Index>' -ForEach @(
        @{ Index = 2 }
        @{ Index = 3 }
        @{ Index = 4 }
    ) {
        $script:ownershipRules = @($script:ownershipRules | Where-Object { $_ -ne $script:ownershipRules[$Index] })
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*overrides must take precedence over the ownerless module tree*'
    }

    It 'Rejects overrides that are shadowed by later rules' {
        $script:ownershipRules += '/utilities/ @Azure/azure-verified-modules-tooling-contributors'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*overrides must take precedence over the ownerless module tree*'
    }

    It 'Rejects duplicate ownership patterns' {
        $script:ownershipRules += '*.e2eignore @Azure/azure-verified-modules-tooling-contributors'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw
    }

    It 'Rejects an incomplete ownership file' {
        $script:ownershipRules = @('* @Azure/azure-verified-modules-tooling-contributors')
        { Invoke-TestCodeOwnersGovernance } | Should -Throw
    }
}
