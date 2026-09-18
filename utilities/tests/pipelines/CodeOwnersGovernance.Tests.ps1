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
            return $tokens[1..($tokens.Count - 1)]
        }
    }

    BeforeEach {
        $script:ownershipRules = @(
            '* @Azure/azure-verified-modules-tooling-contributors'
            '/avm/ @Azure/azure-verified-modules-module-owners'
            '/avm/ptn/example/pattern/ @pattern-owner @Azure/azure-verified-modules-module-owners'
            '/avm/res/storage/storage-account/ @Owner-One @owner-two @Azure/azure-verified-modules-module-owners'
            '/avm/res/network/virtual-network/ @network-owner @Azure/azure-verified-modules-module-owners'
            '/avm/utl/example/utility/ @Azure/azure-verified-modules-module-owners'
            '*avm.core.team.tests.ps1 @Azure/azure-verified-modules-tooling-contributors'
            '*.e2eignore @Azure/azure-verified-modules-tooling-contributors'
            'metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners'
        )
    }

    It 'Accepts generated resource, pattern and utility module ownership' {
        Invoke-TestCodeOwnersGovernance
    }

    It 'Accepts the checked-in CODEOWNERS file' {
        $script:ownershipRules = @(Get-Content -Path (Join-Path $repoRootPath '.github' 'CODEOWNERS'))
        Invoke-TestCodeOwnersGovernance
    }

    It 'Accepts the owners team as the only reviewer for an ownerless module' {
        $script:ownershipRules[3] = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners'
        Invoke-TestCodeOwnersGovernance
    }

    It 'Preserves the current shared ownership format during rollout' {
        $script:ownershipRules = $script:ownershipRules[0, 1, 6, 7, 8]
        $script:ownershipRules[1] = '/avm/ @Azure/azure-verified-modules-module-contributors'
        Invoke-TestCodeOwnersGovernance
    }

    It 'Allows the fallback to cover modules awaiting their first synchronization' {
        $script:ownershipRules = $script:ownershipRules[0, 1, 6, 7, 8]
        Invoke-TestCodeOwnersGovernance
    }

    It 'Allows engineering owners or module owners as the only approvers for <Path>' -ForEach @(
        @{ Path = 'metadata.json' }
        @{ Path = 'avm/res/storage/storage-account/metadata.json' }
        @{ Path = 'avm/res/storage/storage-account/blob-service/metadata.json' }
        @{ Path = 'avm/res/storage/storage-account/blob-service/container/metadata.json' }
        @{ Path = 'avm/ptn/network/hub-networking/metadata.json' }
        @{ Path = 'avm/ptn/network/hub-networking/child/nested/metadata.json' }
        @{ Path = 'avm/utl/types/avm-common-types/metadata.json' }
        @{ Path = 'avm/utl/types/avm-common-types/child/nested/metadata.json' }
        @{ Path = 'avm/res/unindexed/example/child/nested/metadata.json' }
        @{ Path = 'avm/ptn/unindexed/example/child/nested/metadata.json' }
        @{ Path = 'avm/utl/unindexed/example/child/nested/metadata.json' }
        @{ Path = 'utilities/metadata.json' }
        @{ Path = '.github/metadata.json' }
    ) {
        $script:ownershipRules = @(Get-Content -Path (Join-Path $repoRootPath '.github' 'CODEOWNERS'))
        @(Get-TestCodeOwners -Path $Path) | Should -Be @(
            '@Azure/azure-verified-modules-engineering-owners'
            '@Azure/azure-verified-modules-module-owners'
        )
    }

    It 'Preserves non-metadata ownership for <Path>' -ForEach @(
        @{
            Path = 'avm/res/storage/storage-account/blob-service/container/main.bicep'
            Owners = @('@Owner-One', '@owner-two', '@Azure/azure-verified-modules-module-owners')
        }
        @{
            Path = 'avm/res/storage/storage-account/tests/unit/avm.core.team.tests.ps1'
            Owners = @('@Azure/azure-verified-modules-tooling-contributors')
        }
        @{
            Path = 'avm/res/storage/storage-account/tests/e2e/defaults/.e2eignore'
            Owners = @('@Azure/azure-verified-modules-tooling-contributors')
        }
        @{
            Path = 'utilities/script.ps1'
            Owners = @('@Azure/azure-verified-modules-tooling-contributors')
        }
    ) {
        @(Get-TestCodeOwners -Path $Path) | Should -Be $Owners
    }

    It 'Rejects missing or shadowed metadata ownership' {
        $script:ownershipRules = $script:ownershipRules[0..7]
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*metadata files must allow approval from engineering owners or module owners*'

        $script:ownershipRules = @($script:ownershipRules[0..1]) +
            @('metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners') +
            @($script:ownershipRules[2..7])
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*metadata files must allow approval from engineering owners or module owners*'
    }

    It 'Rejects metadata ownership that omits an approved team, adds another approver or misses nested files: <Rule>' -ForEach @(
        @{ Rule = 'metadata.json @Azure/azure-verified-modules-engineering-owners' }
        @{ Rule = 'metadata.json @Azure/azure-verified-modules-module-owners' }
        @{ Rule = 'metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners @Azure/azure-verified-modules-tooling-contributors' }
        @{ Rule = 'metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners @owner-one' }
        @{ Rule = '/metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/*/metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners' }
    ) {
        $script:ownershipRules[-1] = $Rule
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*metadata files must allow approval from engineering owners or module owners*'
    }

    It 'Ignores generation comments, blank lines and harmless whitespace' {
        $script:ownershipRules = @('# Generated ownership', '') + $script:ownershipRules + @('', '# End')
        $script:ownershipRules[2] = "  *`t@Azure/azure-verified-modules-tooling-contributors  "
        Invoke-TestCodeOwnersGovernance
    }

    It 'Selects module paths independently of additional tooling rules at index <Index>' -ForEach @(
        @{ Index = 2 }
        @{ Index = 6 }
    ) {
        $script:ownershipRules = @($script:ownershipRules[0..($Index - 1)]) +
            @('/utilities/ @Azure/azure-verified-modules-tooling-contributors') +
            @($script:ownershipRules[$Index..($script:ownershipRules.Count - 1)])
        Invoke-TestCodeOwnersGovernance
    }

    It 'Rejects malformed or unexpected module ownership: <Rule>' -ForEach @(
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/legacy-module-team @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-contributors' }
        @{ Rule = '/avm/res/storage/storage-account/' }
        @{ Rule = '/avm/res/storage/storage-account @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/blob-service/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/blob-service/container/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @invalid--owner @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @-invalid @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @invalid- @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @owner_one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @abcdefghijklmnopqrstuvwxyzabcdefghijklmn @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @owner-one @owner-two' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners @owner-one' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/Storage/storage-account/ @owner-one @Azure/azure-verified-modules-module-owners' }
    ) {
        $script:ownershipRules[3] = $Rule
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*per-module entries must use a top-level module path*'
    }

    It 'Rejects unexpected non-module ownership: <Rule>' -ForEach @(
        @{ Rule = '/avm/unknown/storage/storage-account/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/utilities/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/.github/CODEOWNERS @owner-one' }
    ) {
        $script:ownershipRules[3] = $Rule
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*non-module rules must preserve tooling ownership*'
    }

    It 'Accepts one-character and maximum-length individual handles' {
        $script:ownershipRules[3] = '/avm/res/storage/storage-account/ @a @abcdefghijklmnopqrstuvwxyzabcdefghijklm @Azure/azure-verified-modules-module-owners'
        Invoke-TestCodeOwnersGovernance
    }

    It 'Rejects duplicate module patterns' {
        $script:ownershipRules[4] = '/avm/res/storage/storage-account/ @another-owner @Azure/azure-verified-modules-module-owners'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*each ownership pattern must have a single entry*'
    }

    It 'Rejects duplicate static patterns at index <Index>' -ForEach @(
        @{ Index = 0 }
        @{ Index = 1 }
    ) {
        $script:ownershipRules[4] = $script:ownershipRules[$Index]
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*each ownership pattern must have a single entry*'
    }

    It 'Keeps repository-default ownership with the tooling team' {
        $script:ownershipRules[0] = '* @owner-one'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw
    }

    It 'Requires an approved shared module fallback' {
        $script:ownershipRules[1] = '/avm/ @owner-one'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw
    }

    It 'Rejects a late module rule that shadows tooling overrides' {
        $script:ownershipRules = @($script:ownershipRules[0..7]) + @(
            '/avm/res/key-vault/vault/ @owner-one @Azure/azure-verified-modules-module-owners'
            $script:ownershipRules[-1]
        )
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*tooling overrides must take precedence*'
    }

    It 'Rejects removal of either tooling override at index <Index>' -ForEach @(
        @{ Index = 6 }
        @{ Index = 7 }
    ) {
        $script:ownershipRules = @($script:ownershipRules | Where-Object { $_ -ne $script:ownershipRules[$Index] })
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*tooling overrides must take precedence*'
    }

    It 'Rejects an incomplete ownership file' {
        $script:ownershipRules = @('* @Azure/azure-verified-modules-tooling-contributors')
        { Invoke-TestCodeOwnersGovernance } | Should -Throw
    }
}
