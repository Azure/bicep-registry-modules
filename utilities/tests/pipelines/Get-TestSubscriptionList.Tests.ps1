param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Get-TestSubscriptionList' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionList.ps1')

        $subscriptions = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'test-one' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'test-two' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'test-three' }
        )
        $subscriptionJson = ConvertTo-Json -InputObject $subscriptions -Compress
    }

    It 'Preserves the configured order when no shuffle seed is supplied' {
        $result = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson)

        $result.id | Should -Be $subscriptions.id
        $result.name | Should -Be $subscriptions.name
    }

    It 'Keeps a single configured subscription unchanged' {
        $singletonJson = ConvertTo-Json -InputObject @($subscriptions[0]) -Compress

        $result = @(Get-TestSubscriptionList -TestSubscriptionIds $singletonJson -RandomSeed 12345)

        $result.Count | Should -Be 1
        $result[0].id | Should -Be $subscriptions[0].id
        $result[0].name | Should -Be $subscriptions[0].name
    }

    It 'Reproduces one shuffled permutation for every caller using the same seed' {
        $first = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)
        $second = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)

        $first.id | Should -Be $second.id
        ($first.id | Sort-Object) | Should -Be ($subscriptions.id | Sort-Object)
    }

    It 'Can vary the shuffled order between runs' {
        $orders = @(
            0..9 | ForEach-Object {
                (Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed $_).id -join ','
            } | Sort-Object -Unique
        )

        $orders.Count | Should -BeGreaterThan 1
    }

    It 'Rejects every form of missing pool configuration' {
        foreach ($unsetValue in @($null, '', '  ')) {
            { Get-TestSubscriptionList -TestSubscriptionIds $unsetValue -RandomSeed 12345 } |
                Should -Throw '*Missing BAMI configuration*TEST_BAMI_SUBSCRIPTION_IDS*'
        }
    }

    It 'Rejects missing configuration' {
        { Get-TestSubscriptionList } | Should -Throw '*Missing BAMI configuration*TEST_BAMI_SUBSCRIPTION_IDS*'
    }

    It 'Does not accept a legacy fallback parameter' {
        { Get-TestSubscriptionList -FallbackSubscriptionId $subscriptions[0].id } |
            Should -Throw '*parameter*FallbackSubscriptionId*'
    }

    It 'Rejects a negative shuffle seed' {
        { Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed -1 } | Should -Throw
    }

    It 'Rejects <name> with a configuration error' -ForEach @(
        @{ name = 'malformed JSON'; json = '[invalid' }
        @{ name = 'an empty array'; json = '[]' }
        @{ name = 'null'; json = 'null' }
        @{ name = 'a scalar'; json = '"11111111-1111-1111-1111-111111111111"' }
        @{ name = 'a single object outside an array'; json = '{"id":"11111111-1111-1111-1111-111111111111","name":"test-one"}' }
        @{ name = 'a string array'; json = '["11111111-1111-1111-1111-111111111111"]' }
        @{ name = 'a null entry'; json = '[null]' }
        @{ name = 'a missing ID'; json = '[{"name":"test-one"}]' }
        @{ name = 'an invalid ID'; json = '[{"id":"not-a-guid","name":"test-one"}]' }
        @{ name = 'an empty GUID'; json = '[{"id":"00000000-0000-0000-0000-000000000000","name":"test-one"}]' }
        @{ name = 'a padded ID'; json = '[{"id":" 11111111-1111-1111-1111-111111111111 ","name":"test-one"}]' }
        @{ name = 'a duplicate ID'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test-one"},{"id":"11111111-1111-1111-1111-111111111111","name":"test-two"}]' }
        @{ name = 'a missing name'; json = '[{"id":"11111111-1111-1111-1111-111111111111"}]' }
        @{ name = 'a blank name'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":" "}]' }
        @{ name = 'a multiline name'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test\none"}]' }
        @{ name = 'an invalid later entry'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test-one"},{"id":"bad","name":"test-two"}]' }
    ) {
        {
            Get-TestSubscriptionList -TestSubscriptionIds $json -RandomSeed 12345
        } | Should -Throw '*TEST_BAMI_SUBSCRIPTION_IDS*'
    }
}

Describe 'Get-BamiTestConfiguration' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-BamiTestConfiguration.ps1')
        $settings = @{
            TEST_BAMI_TENANT_ID                  = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
            TEST_BAMI_BICEP_CLIENT_ID            = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
            TEST_BAMI_SUBSCRIPTION_IDS           = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test-one"}]'
            TEST_BAMI_MANAGEMENT_GROUP_ID        = 'test-management-group'
            TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID = 'cccccccc-cccc-cccc-cccc-cccccccccccc'
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($environmentName in $settings.Keys) {
            $savedEnvironment[$environmentName] = [Environment]::GetEnvironmentVariable($environmentName)
            [Environment]::SetEnvironmentVariable($environmentName, $settings[$environmentName])
        }
    }

    AfterEach {
        foreach ($environmentName in $settings.Keys) {
            [Environment]::SetEnvironmentVariable($environmentName, $savedEnvironment[$environmentName])
        }
    }

    It 'Returns the five configured BAMI values without collapsing a singleton pool' {
        $result = Get-BamiTestConfiguration

        $result.TenantId | Should -Be $settings.TEST_BAMI_TENANT_ID
        $result.ClientId | Should -Be $settings.TEST_BAMI_BICEP_CLIENT_ID
        $result.ManagementGroupId | Should -Be $settings.TEST_BAMI_MANAGEMENT_GROUP_ID
        $result.PersistentSubscriptionId | Should -Be $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
        $result.Subscriptions -is [array] | Should -BeTrue
        $result.Subscriptions.Count | Should -Be 1
        $result.Subscriptions[0].id | Should -Be '11111111-1111-1111-1111-111111111111'
    }

    It 'Keeps the configured persistent subscription outside the disposable pool' {
        $env:TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID = '11111111-1111-1111-1111-111111111111'

        { Get-BamiTestConfiguration } | Should -Throw '*must not include TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID*'
    }

    It 'Rejects malformed, zero, padded and multiline GUIDs in every identity setting' {
        foreach ($setting in @('TEST_BAMI_TENANT_ID', 'TEST_BAMI_BICEP_CLIENT_ID', 'TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID')) {
            foreach ($invalid in @(
                    '00000000-0000-0000-0000-000000000000'
                    '{aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa}'
                    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
                    ' aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa '
                    "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa`n"
                )) {
                [Environment]::SetEnvironmentVariable($setting, $invalid)
                { Get-BamiTestConfiguration } | Should -Throw "*Invalid BAMI configuration*$setting*"
            }
            [Environment]::SetEnvironmentVariable($setting, $settings[$setting])
        }
    }

    It 'Accepts management group names without imposing a particular tenant or naming convention' -ForEach @(
        @{ name = 'mg_test.prod-(bicep)' }
        @{ name = 'D' * 90 }
        @{ name = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' }
    ) {
        $env:TEST_BAMI_MANAGEMENT_GROUP_ID = $name

        (Get-BamiTestConfiguration).ManagementGroupId | Should -Be $name
    }

    It 'Rejects an invalid management group name [<name>]' -ForEach @(
        @{ name = '/providers/Microsoft.Management/managementGroups/test' }
        @{ name = 'test group' }
        @{ name = "test`ngroup" }
        @{ name = 'D' * 91 }
    ) {
        $env:TEST_BAMI_MANAGEMENT_GROUP_ID = $name

        { Get-BamiTestConfiguration } | Should -Throw '*Invalid BAMI configuration*TEST_BAMI_MANAGEMENT_GROUP_ID*'
    }
}
