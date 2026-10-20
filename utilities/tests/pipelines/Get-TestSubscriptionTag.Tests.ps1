param (
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Test subscription reservation configuration' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionTag.ps1')
    }

    BeforeEach {
        $mapPath = Join-Path $TestDrive '.reserved-test-subscriptions.json'
        '{"avm/res/azure-stack-hci/cluster":"Azure Local"}' | Set-Content -LiteralPath $mapPath
    }

    It 'Matches exact roots only and defaults unrelated or child paths to General' {
        Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath 'avm/res/azure-stack-hci/cluster' | Should -BeExactly 'Azure Local'
        foreach ($path in @('avm/res/azure-stack-hci/logical-network', 'avm/res/azure-stack-hci/cluster/deployment-setting', 'avm/res/hybrid-compute/machine')) {
            Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath $path | Should -BeExactly 'General'
        }
    }

    It 'Allows an explicitly empty reservation map' {
        '{}' | Set-Content -LiteralPath $mapPath
        Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath 'avm/res/azure-stack-hci/cluster' | Should -BeExactly 'General'
    }

    It 'Requires the map to be present rather than silently removing reservations' {
        Remove-Item -LiteralPath $mapPath
        { Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath 'avm/res/azure-stack-hci/cluster' } |
            Should -Throw '*require a file named exactly*'
    }

    It 'Rejects invalid module input [<path>]' -ForEach @(
        @{ path = 'avm/res/azure-stack-hci/*' }
        @{ path = 'avm/res/azure-stack-hci/cluster/' }
        @{ path = 'avm\res\azure-stack-hci\cluster' }
        @{ path = 'avm/res/Azure-Stack-HCI/cluster' }
        @{ path = '../avm/res/azure-stack-hci/cluster' }
        @{ path = 'avm/res/azure-stack-hci/../cluster' }
    ) {
        { Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath $path } | Should -Throw '*exact repository-relative*'
    }

    It 'Validates the whole map, including unrelated entries: <case>' -ForEach @(
        @{ case = 'empty file'; json = '' }
        @{ case = 'malformed JSON'; json = '{broken' }
        @{ case = 'null'; json = 'null' }
        @{ case = 'array'; json = '[]' }
        @{ case = 'duplicate keys'; json = '{"avm/res/example/module":"Azure Local","avm/res/example/module":"General"}' }
        @{ case = 'wildcard'; json = '{"avm/res/azure-stack-hci/*":"Azure Local"}' }
        @{ case = 'parent directory'; json = '{"avm/res/azure-stack-hci":"Azure Local"}' }
        @{ case = 'invalid tag type'; json = '{"avm/res/example/module":["Azure Local"]}' }
        @{ case = 'null tag'; json = '{"avm/res/example/module":null}' }
        @{ case = 'empty tag'; json = '{"avm/res/example/module":""}' }
        @{ case = 'trailing whitespace'; json = '{"avm/res/example/module":"Azure Local "}' }
        @{ case = 'multiline tag'; json = '{"avm/res/example/module":"Azure\nLocal"}' }
        @{ case = 'oversized tag'; json = '{"avm/res/example/module":"' + ('a' * 65) + '"}' }
    ) {
        $json | Set-Content -LiteralPath $mapPath
        { Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath 'avm/res/azure-stack-hci/cluster' } | Should -Throw
    }

    It 'Rejects oversized configuration before parsing' {
        (' ' * 65537) | Set-Content -LiteralPath $mapPath
        { Get-TestSubscriptionTag -RepoRootPath $TestDrive -ModulePath 'avm/res/azure-stack-hci/cluster' } | Should -Throw '*64 KiB*'
    }

    It 'Reserves exactly the Azure Local resource module roots in this repository' {
        $configured = Get-Content -LiteralPath (Join-Path $repoRootPath '.reserved-test-subscriptions.json') -Raw | ConvertFrom-Json -AsHashtable
        $expected = @(
            'avm/res/azure-stack-hci/cluster'
            'avm/res/azure-stack-hci/logical-network'
            'avm/res/azure-stack-hci/marketplace-gallery-image'
            'avm/res/azure-stack-hci/network-interface'
            'avm/res/azure-stack-hci/virtual-hard-disk'
            'avm/res/azure-stack-hci/virtual-machine-instance'
            'avm/res/hybrid-container-service/provisioned-cluster-instance'
        )
        @($configured.Keys | Sort-Object) | Should -Be $expected
        foreach ($path in $expected) {
            Test-Path -LiteralPath (Join-Path $repoRootPath $path 'main.bicep') -PathType Leaf | Should -BeTrue
            Get-TestSubscriptionTag -RepoRootPath $repoRootPath -ModulePath $path | Should -BeExactly 'Azure Local'
        }
        Get-TestSubscriptionTag -RepoRootPath $repoRootPath -ModulePath 'avm/res/hybrid-compute/machine' | Should -BeExactly 'General'
    }
}
