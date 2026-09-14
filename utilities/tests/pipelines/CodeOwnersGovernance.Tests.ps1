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

        function Invoke-TestCodeOwnersGovernance {
            Set-Content -Path (Join-Path $TestDrive '.github' 'CODEOWNERS') -Value $script:ownershipRules
            . $script:assertOwnership -repoRootPath $TestDrive
        }
    }

    BeforeEach {
        $script:ownershipRules = @(
            '* @Azure/azure-verified-modules-tooling-contributors'
            '/avm/ @Azure/azure-verified-modules-module-owners'
            '/avm/ptn/example/pattern/ @pattern-owner @Azure/azure-verified-modules-module-owners'
            '/avm/res/storage/storage-account/ @Owner-One @owner-two @Azure/azure-verified-modules-module-owners'
            '/avm/res/storage/storage-account/blob-service/ @child-owner @Azure/azure-verified-modules-module-owners'
            '/avm/utl/example/utility/ @Azure/azure-verified-modules-module-owners'
            '*avm.core.team.tests.ps1 @Azure/azure-verified-modules-tooling-contributors'
            '*.e2eignore @Azure/azure-verified-modules-tooling-contributors'
        )
    }

    It 'Accepts generated resource, pattern, utility and child-module ownership' {
        Invoke-TestCodeOwnersGovernance
    }

    It 'Accepts the owners team as the only reviewer for an ownerless module' {
        $script:ownershipRules[3] = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners'
        Invoke-TestCodeOwnersGovernance
    }

    It 'Preserves the current shared ownership format during rollout' {
        $script:ownershipRules = $script:ownershipRules[0, 1, 6, 7]
        $script:ownershipRules[1] = '/avm/ @Azure/azure-verified-modules-module-contributors'
        Invoke-TestCodeOwnersGovernance
    }

    It 'Allows the fallback to cover modules awaiting their first synchronization' {
        $script:ownershipRules = $script:ownershipRules[0, 1, 6, 7]
        Invoke-TestCodeOwnersGovernance
    }

    It 'Ignores generation comments, blank lines and harmless whitespace' {
        $script:ownershipRules = @('# Generated ownership', '') + $script:ownershipRules + @('', '# End')
        $script:ownershipRules[2] = "  *`t@Azure/azure-verified-modules-tooling-contributors  "
        Invoke-TestCodeOwnersGovernance
    }

    It 'Rejects malformed or unexpected module ownership: <Rule>' -ForEach @(
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/legacy-module-team @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-contributors' }
        @{ Rule = '/avm/res/storage/storage-account/' }
        @{ Rule = '/avm/res/storage/storage-account @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @invalid--owner @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @-invalid @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @invalid- @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @owner_one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @abcdefghijklmnopqrstuvwxyzabcdefghijklmn @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/storage/storage-account/ @owner-one @owner-two' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners @owner-one' }
        @{ Rule = '/avm/res/storage/storage-account/ @Azure/azure-verified-modules-module-owners @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/unknown/storage/storage-account/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/avm/res/Storage/storage-account/ @owner-one @Azure/azure-verified-modules-module-owners' }
        @{ Rule = '/utilities/ @owner-one @Azure/azure-verified-modules-module-owners' }
    ) {
        $script:ownershipRules[3] = $Rule
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*per-module entries must include*'
    }

    It 'Accepts one-character and maximum-length individual handles' {
        $script:ownershipRules[3] = '/avm/res/storage/storage-account/ @a @abcdefghijklmnopqrstuvwxyzabcdefghijklm @Azure/azure-verified-modules-module-owners'
        Invoke-TestCodeOwnersGovernance
    }

    It 'Rejects duplicate module patterns' {
        $script:ownershipRules[4] = '/avm/res/storage/storage-account/ @another-owner @Azure/azure-verified-modules-module-owners'
        { Invoke-TestCodeOwnersGovernance } | Should -Throw '*each module must have a single ownership entry*'
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
        $script:ownershipRules += '/avm/res/storage/storage-account/blob-service/container/ @owner-one @Azure/azure-verified-modules-module-owners'
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
