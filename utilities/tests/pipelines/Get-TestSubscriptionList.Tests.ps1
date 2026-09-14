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

    It 'Uses the legacy subscription as a singleton only when the variable is unset' {
        foreach ($unsetValue in @($null, '', '  ')) {
            $result = @(Get-TestSubscriptionList -TestSubscriptionIds $unsetValue -FallbackSubscriptionId $subscriptions[0].id -RandomSeed 12345)

            $result.Count | Should -Be 1
            $result[0].id | Should -Be $subscriptions[0].id
            $result[0].name | Should -Be $subscriptions[0].id
        }
    }

    It 'Prefers the configured pool over the legacy subscription' {
        $result = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -FallbackSubscriptionId 'not-used')

        $result.id | Should -Be $subscriptions.id
    }

    It 'Rejects missing configuration' {
        { Get-TestSubscriptionList } | Should -Throw '*No test subscriptions configured*'
    }

    It 'Rejects an invalid legacy subscription' {
        { Get-TestSubscriptionList -FallbackSubscriptionId 'not-a-guid' } | Should -Throw '*subscription GUID*'
    }

    It 'Rejects a negative shuffle seed' {
        { Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed -1 } | Should -Throw
    }

    It 'Rejects <name> instead of silently using the fallback' -ForEach @(
        @{ name = 'malformed JSON'; json = '[invalid' }
        @{ name = 'an empty array'; json = '[]' }
        @{ name = 'null'; json = 'null' }
        @{ name = 'a scalar'; json = '"11111111-1111-1111-1111-111111111111"' }
        @{ name = 'a single object outside an array'; json = '{"id":"11111111-1111-1111-1111-111111111111","name":"test-one"}' }
        @{ name = 'a string array'; json = '["11111111-1111-1111-1111-111111111111"]' }
        @{ name = 'a null entry'; json = '[null]' }
        @{ name = 'a missing ID'; json = '[{"name":"test-one"}]' }
        @{ name = 'an invalid ID'; json = '[{"id":"not-a-guid","name":"test-one"}]' }
        @{ name = 'a missing name'; json = '[{"id":"11111111-1111-1111-1111-111111111111"}]' }
        @{ name = 'a blank name'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":" "}]' }
        @{ name = 'a multiline name'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test\none"}]' }
        @{ name = 'an invalid later entry'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test-one"},{"id":"bad","name":"test-two"}]' }
    ) {
        {
            Get-TestSubscriptionList -TestSubscriptionIds $json -FallbackSubscriptionId $subscriptions[0].id -RandomSeed 12345
        } | Should -Throw
    }
}
