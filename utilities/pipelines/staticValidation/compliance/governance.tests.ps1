#Requires -Version 7

param(
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.Parent.FullName
)

Describe 'Governance tests' {
    BeforeDiscovery {
        $codeOwnersTestCases = @(@{ repoRootPath = $repoRootPath })
    }

    It 'Module and tooling ownership should be specified correctly in CODEOWNERS file.' -TestCases $codeOwnersTestCases {
        param([string] $repoRootPath)

        $codeownersFilePath = Join-Path $repoRootPath '.github' 'CODEOWNERS'
        $ownershipRules = @(Get-Content $codeownersFilePath | ForEach-Object { $_.Trim() -replace '\s+', ' ' } | Where-Object { $_ -and -not $_.StartsWith('#') })

        $ownershipRules[0] | Should -Be '* @Azure/azure-verified-modules-tooling-contributors' -Because 'the repository default must stay with the tooling team.'
        $ownershipRules[1] | Should -Be '/avm/' -Because 'module reviewers are resolved from metadata.json, so the module tree must have no code owners.'
        $ownershipRules[-3..-1] | Should -Be @(
            '*avm.core.team.tests.ps1 @Azure/azure-verified-modules-tooling-contributors'
            '*.e2eignore @Azure/azure-verified-modules-module-owners'
            'metadata.json @Azure/azure-verified-modules-engineering-owners @Azure/azure-verified-modules-module-owners'
        ) -Because 'tooling and metadata overrides must take precedence over the ownerless module tree.'

        $moduleOwnershipRules = @($ownershipRules | Where-Object { $_ -cmatch '^/avm/\S' })
        $moduleOwnershipRules | Should -BeNullOrEmpty -Because 'per-module entries must not be reintroduced into CODEOWNERS.'

        $ownershipPatterns = @($ownershipRules | ForEach-Object { ($_ -split ' ')[0] })
        @($ownershipPatterns | Sort-Object -Unique).Count | Should -Be $ownershipPatterns.Count -Because 'each ownership pattern must have a single entry.'
    }
}
