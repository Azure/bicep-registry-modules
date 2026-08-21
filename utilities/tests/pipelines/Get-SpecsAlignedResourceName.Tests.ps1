<#
The below file tests the helper functions in:
  utilities/pipelines/sharedScripts/helper/Get-SpecsAlignedResourceName.ps1

It covers:
- Get-ReducedWordString: singular/plural-stripping helper.
- Get-SpecsAlignedResourceName:
    * Cache lifecycle (empty / valid / expired / forced refresh / corrupt).
    * Provider namespace resolution (multi-match selection, missing).
    * Resource type resolution (single, nested, dashed, unknown -> fallback,
      one-level fallback).
    * Ambiguous resource type special cases and the unknown-ambiguity throw path.
    * Remote download failure handling.
#>

param(
    [Parameter(Mandatory = $false)]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

$script:repoRootPath = $repoRootPath

Describe 'Test Get-ReducedWordString' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
    }

    It 'Strips trailing plural suffix [<Word>] -> [<Expected>]' -ForEach @(
        # Note: the regex is non-greedy on the prefix, so the first matching
        # suffix from the alternation (y|ii|e|ys|ies|es|s) wins. For
        # 'virtualMachines' that is 'es', leaving 'virtualMachin'.
        @{ Word = 'virtualMachines'; Expected = 'virtualMachin' }
        @{ Word = 'vaults'; Expected = 'vault' }
        @{ Word = 'secrets'; Expected = 'secret' }
    ) {
        Get-ReducedWordString -StringToReduce $Word | Should -Be $Expected
    }

    It 'Strips trailing "ies" from "ies"-plural [<Word>] -> [<Expected>]' -ForEach @(
        @{ Word = 'factories'; Expected = 'factor' }
        @{ Word = 'policies'; Expected = 'polic' }
    ) {
        Get-ReducedWordString -StringToReduce $Word | Should -Be $Expected
    }

    It 'Returns input unchanged when no plural/singular suffix matches' {
        # Final character is not in (y|e|s) -> regex does not match -> input returned as-is
        Get-ReducedWordString -StringToReduce 'abc' | Should -Be 'abc'
    }
}

Describe 'Test Get-SpecsAlignedResourceName' {

    BeforeAll {
        $script:apiSpecsUri = 'https://azure.github.io/Azure-Verified-Modules/governance/apiSpecsList.json'

        # Rich in-memory specs fixture covering all branches of the resolution logic.
        $script:richSpecs = [ordered]@{
            'Microsoft.Authorization' = [ordered]@{
                'locks'           = @('2020-05-01')
                'roleAssignments' = @('2022-04-01')
                'roleDefinitions' = @('2022-04-01')
            }
            'Microsoft.KeyVault'      = [ordered]@{
                'vaults'         = @('2023-02-01')
                'vaults/secrets' = @('2023-02-01')
                'vaults/keys'    = @('2023-02-01')
            }
            'Microsoft.ApiManagement' = [ordered]@{
                'service'                          = @('2023-03-01')
                'service/apis'                     = @('2023-03-01')
                'service/apis/policies'            = @('2023-03-01')
                'service/apis/policy'              = @('2023-03-01') # ambiguous: triggers special case
                'service/apis/operations'          = @('2023-03-01')
                'service/apis/operations/policies' = @('2023-03-01')
                'service/apis/operations/policy'   = @('2023-03-01') # ambiguous: triggers special case
                'service/products'                 = @('2023-03-01')
                'service/products/policies'        = @('2023-03-01')
                'service/products/policy'          = @('2023-03-01') # ambiguous: triggers special case
            }
            # Two namespaces sharing a common prefix to exercise the multi-match selection branch.
            'Microsoft.Network'       = [ordered]@{
                'virtualNetworks'         = @('2024-01-01')
                'virtualNetworks/subnets' = @('2024-01-01')
            }
            'Microsoft.NetworkCloud'  = [ordered]@{
                'clusters' = @('2024-01-01')
            }
        }
        $script:richSpecsJson = $script:richSpecs | ConvertTo-Json -Depth 10
    }

    BeforeEach {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')

        # Default mock returns the rich fixture
        Mock Invoke-WebRequest { return @{ Content = $script:richSpecsJson } } -ParameterFilter { $Uri -eq $script:apiSpecsUri }

        # Always start tests from a clean cache file
        $cacheFolderPath = $IsWindows ? $env:TEMP : [System.IO.Path]::GetTempPath()
        $script:cacheFilePath = Join-Path $cacheFolderPath 'avm-apiSpecs.json'
        if (Test-Path $script:cacheFilePath) {
            Remove-Item -Path $script:cacheFilePath -Force
        }
    }

    AfterEach {
        if (Test-Path $script:cacheFilePath) {
            Remove-Item -Path $script:cacheFilePath -Force -ErrorAction SilentlyContinue
        }
    }

    Context 'Cache lifecycle' {

        It 'Downloads specs when no cache exists and resolves correctly' {
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/role-assignment'

            $result | Should -Be 'Microsoft.Authorization/roleAssignments'
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Uri -eq $script:apiSpecsUri } -Times 1
        }

        It 'Reuses a fresh cache without re-downloading' {
            # First call populates the cache
            $null = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/role-assignment'
            # Second call must hit the cache only
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'key-vault/vault'

            $result | Should -Be 'Microsoft.KeyVault/vaults'
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Uri -eq $script:apiSpecsUri } -Times 1
        }

        It 'Re-downloads when the cache file is older than 1 day' {
            Set-Content -Path $script:cacheFilePath -Value $script:richSpecsJson -NoNewline
            (Get-Item $script:cacheFilePath).LastWriteTime = (Get-Date).AddDays(-2)

            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/role-assignment'

            $result | Should -Be 'Microsoft.Authorization/roleAssignments'
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Uri -eq $script:apiSpecsUri } -Times 1
        }

        It 'Re-downloads when -ForceCacheRefresh is provided even with a fresh cache' {
            Set-Content -Path $script:cacheFilePath -Value $script:richSpecsJson -NoNewline

            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/role-assignment' -ForceCacheRefresh

            $result | Should -Be 'Microsoft.Authorization/roleAssignments'
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Uri -eq $script:apiSpecsUri } -Times 1
        }

        It 'Refreshes the cache and resolves correctly when the cached file is corrupt' {
            # Pre-seed cache with malformed JSON to reproduce the original failure
            Set-Content -Path $script:cacheFilePath -Value '{ "Astronomer.Astro": { "organizations": [ "2024-01' -NoNewline

            $warnings = @()
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/role-assignment' -WarningVariable warnings -WarningAction SilentlyContinue

            $result | Should -Be 'Microsoft.Authorization/roleAssignments'
            ($warnings -join "`n") | Should -Match 'Cached api specs file is corrupt'
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Uri -eq $script:apiSpecsUri } -Times 1

            # The cache must have been rewritten with valid JSON
            $rewritten = Get-Content -Path $script:cacheFilePath -Raw
            { $rewritten | ConvertFrom-Json -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Context 'Remote download failure' {

        It 'Warns and falls back to a Microsoft.<namespace> default when the download fails and no cache exists' {
            Mock Invoke-WebRequest { throw 'network down' } -ParameterFilter { $Uri -eq $script:apiSpecsUri }

            $warnings = @()
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'foo-bar/baz' -WarningVariable warnings -WarningAction SilentlyContinue

            # With $specs = @{}, the namespace match fails -> "Microsoft.foobar"
            # and the resource type also fails -> falls back to the raw resource type "baz".
            $result | Should -Be 'Microsoft.foobar/baz'
            ($warnings -join "`n") | Should -Match 'Failed to download API specs file'
            ($warnings -join "`n") | Should -Match 'Failed to identify provider namespace'
        }
    }

    Context 'Provider namespace resolution' {

        It 'Picks the first match (alphabetical) when multiple namespaces share the same prefix' {
            # 'network' -> matches both Microsoft.Network and Microsoft.NetworkCloud
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'network/virtual-network'

            $result | Should -Be 'Microsoft.Network/virtualNetworks'
        }

        It 'Warns and falls back when the provider namespace is unknown' {
            $warnings = @()
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'made-up-rp/widget' -WarningVariable warnings -WarningAction SilentlyContinue

            $result | Should -Be 'Microsoft.madeuprp/widget'
            ($warnings -join "`n") | Should -Match 'Failed to identify provider namespace'
        }
    }

    Context 'Resource type resolution' {

        It 'Resolves a dashed top-level identifier' {
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'key-vault/vault'
            $result | Should -Be 'Microsoft.KeyVault/vaults'
        }

        It 'Resolves a nested child resource type' {
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'key-vault/vault/secret'
            $result | Should -Be 'Microsoft.KeyVault/vaults/secrets'
        }

        It 'Falls back one level when the leaf segment does not exist as a resource type' {
            # 'roleDefinitions/managementGroup' is not a real resource type.
            # The function should warn and fall back to the parent ('roleDefinitions').
            $warnings = @()
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/role-definition/management-group' -WarningVariable warnings -WarningAction SilentlyContinue

            $result | Should -Be 'Microsoft.Authorization/roleDefinitions'
            ($warnings -join "`n") | Should -Match 'Failed to find exact match'
        }

        It 'Warns and uses the raw resource type when nothing matches at all' {
            $warnings = @()
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'authorization/totally-unknown' -WarningVariable warnings -WarningAction SilentlyContinue

            $result | Should -Be 'Microsoft.Authorization/totallyunknown'
            ($warnings -join "`n") | Should -Match 'cannot be found or does not exist'
        }
    }

    Context 'Ambiguous resource type special cases' {

        It 'Resolves [service/api/policy] to [service/apis/policies]' {
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'api-management/service/api/policy'
            $result | Should -Be 'Microsoft.ApiManagement/service/apis/policies'
        }

        It 'Resolves [service/api/operation/policy] to [service/apis/operations/policies]' {
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'api-management/service/api/operation/policy'
            $result | Should -Be 'Microsoft.ApiManagement/service/apis/operations/policies'
        }

        It 'Resolves [service/product/policy] to [service/products/policies]' {
            $result = Get-SpecsAlignedResourceName -ResourceIdentifier 'api-management/service/product/policy'
            $result | Should -Be 'Microsoft.ApiManagement/service/products/policies'
        }

        It 'Throws when an ambiguous resource type has no known special-case handler' {
            # Inject a fixture where two ambiguous siblings exist with no special-case mapping
            $ambiguousSpecs = [ordered]@{
                'Microsoft.Contoso' = [ordered]@{
                    'widgets' = @('2024-01-01')
                    'widget'  = @('2024-01-01')
                }
            }
            $ambiguousJson = $ambiguousSpecs | ConvertTo-Json -Depth 10
            Mock Invoke-WebRequest { return @{ Content = $ambiguousJson } } -ParameterFilter { $Uri -eq $script:apiSpecsUri }

            { Get-SpecsAlignedResourceName -ResourceIdentifier 'contoso/widget' } | Should -Throw '*Found ambiguous resource types*'
        }
    }
}
