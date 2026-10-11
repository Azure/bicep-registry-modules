param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Coordinated tools dependency updates' {
    It 'prevents automatic uses-only changes from diverging from tools-ref inputs' {
        $configuration = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'dependabot.yml') -Raw
        )
        $updates = @($configuration.updates | Where-Object { $_.'package-ecosystem' -eq 'github-actions' -and $_.directory -eq '/' })
        $updates.Count | Should -Be 1
        $ignored = @($updates[0].ignore.'dependency-name')
        $ignored | Should -Contain 'Azure/azure-verified-modules-tools'
        $ignored | Should -Contain 'Azure/azure-verified-modules-tools/*'
        @($ignored | Where-Object { 'actions/checkout' -clike $_ }).Count | Should -Be 0
        @($ignored | Where-Object { 'azure/login' -clike $_ }).Count | Should -Be 0
    }
}

Describe 'Registry-owned child module publishing approvals' {
    It 'keeps packaged and legacy publishing approvals identical during the transition' {
        $configurationPath = Join-Path $RepoRootPath '.avm' 'child-module-publish-allowed-list.json'
        $legacyPath = Join-Path $RepoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'helper' 'child-module-publish-allowed-list.json'
        $configuration = Get-Content -LiteralPath $configurationPath -Raw | ConvertFrom-Json -AsHashtable
        $legacy = Get-Content -LiteralPath $legacyPath -Raw | ConvertFrom-Json -AsHashtable

        ($configuration | ConvertTo-Json -Depth 5 -Compress) |
            Should -BeExactly ($legacy | ConvertTo-Json -Depth 5 -Compress)
    }
}
