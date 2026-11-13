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
        $result.index | Should -Be @(0, 1, 2)
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
        foreach ($record in $first) {
            $record.id | Should -Be $subscriptions[$record.index].id
        }
    }

    It 'Hashes only the canonical GUID, independently of names, order, seed or fallback source' {
        $id = 'ABCDEF12-3456-7890-ABCD-EF1234567890'
        $pool = @(
            @{ id = $id; name = 'original-name' }
            $subscriptions[0]
        )
        $first = @(Get-TestSubscriptionList -TestSubscriptionIds (ConvertTo-Json -InputObject $pool -Compress) -RandomSeed 42) |
            Where-Object { $_.id -eq $id }
        $pool = @(
            $subscriptions[0]
            @{ id = $id.ToLowerInvariant(); name = 'renamed' }
        )
        $second = @(Get-TestSubscriptionList -TestSubscriptionIds (ConvertTo-Json -InputObject $pool -Compress) -RandomSeed 17) |
            Where-Object { $_.id -eq $id }
        $fallback = Get-TestSubscriptionList -FallbackSubscriptionId $id.ToLowerInvariant()

        $first.key | Should -Match '^[a-f0-9]{64}$'
        $first.key | Should -BeExactly $second.key
        $first.key | Should -BeExactly $fallback.key
        $first.index | Should -Be 0
        $second.index | Should -Be 1
        $first.key | Should -Not -Be (Get-TestSubscriptionList -FallbackSubscriptionId $subscriptions[0].id).key
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
        foreach ($unsetValue in @($null, '')) {
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
        @{ name = 'whitespace'; json = ' ' }
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
        @{ name = 'an empty GUID'; json = '[{"id":"00000000-0000-0000-0000-000000000000","name":"test"}]' }
        @{ name = 'a blank tag'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":""}]' }
        @{ name = 'a null tag'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":null}]' }
        @{ name = 'a nonstring tag'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":["General"]}]' }
        @{ name = 'a multiline tag'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":"Azure\nLocal"}]' }
        @{ name = 'tag leading whitespace'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":" General"}]' }
        @{ name = 'a miscapitalized tag property'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","Tag":"Azure Local"}]' }
        @{ name = 'a misspelled tag property'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tga":"Azure Local"}]' }
        @{ name = 'a plural tag property'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tags":"Azure Local"}]' }
        @{ name = 'a tag property with whitespace'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag ":"Azure Local"}]' }
        @{ name = 'an unknown property'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","unexpected":true}]' }
        @{ name = 'an unknown property alongside a valid tag'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":"General","unexpected":true}]' }
        @{ name = 'a miscapitalized ID property'; json = '[{"ID":"11111111-1111-1111-1111-111111111111","name":"test"}]' }
        @{ name = 'a miscapitalized name property'; json = '[{"id":"11111111-1111-1111-1111-111111111111","Name":"test"}]' }
        @{ name = 'duplicate tag properties'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"test","tag":"Azure Local","tag":"General"}]' }
        @{ name = 'duplicate ID properties'; json = '[{"id":"11111111-1111-1111-1111-111111111111","id":"22222222-2222-2222-2222-222222222222","name":"test"}]' }
        @{ name = 'the same subscription in two pools'; json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"reserved","tag":"Azure Local"},{"id":"11111111-1111-1111-1111-111111111111","name":"general","tag":"General"}]' }
    ) {
        {
            Get-TestSubscriptionList -TestSubscriptionIds $json -FallbackSubscriptionId $subscriptions[0].id -RandomSeed 12345
        } | Should -Throw
    }

    It 'Rejects a misspelled reservation before allocating any subscription to <modulePath>' -ForEach @(
        @{ modulePath = 'avm/res/storage/storage-account' }
        @{ modulePath = 'avm/res/azure-stack-hci/cluster' }
    ) {
        foreach ($json in @(
                '[{"id":"11111111-1111-4111-8111-111111111111","name":"offline-fixture","tga":"Azure Local"}]',
                '[{"id":"22222222-2222-4222-8222-222222222222","name":"valid-first"},{"id":"11111111-1111-4111-8111-111111111111","name":"offline-fixture","tga":"Azure Local"}]'
            )) {
            $allocated = [System.Collections.Generic.List[object]]::new()
            {
                Get-TestSubscriptionList -TestSubscriptionIds $json -ModulePath $modulePath -RepoRootPath $repoRootPath `
                    -FallbackSubscriptionId $subscriptions[0].id -RandomSeed 12345 | ForEach-Object { $allocated.Add($_) }
            } | Should -Throw '*may contain only id, name, and optional tag properties*'
            $allocated.Count | Should -Be 0
        }
    }

    It 'Partitions mixed tags and untagged records while preserving source indices and canonical hashes' {
        $pool = @(
            @{ id = $subscriptions[0].id; name = 'untagged' }
            @{ id = $subscriptions[1].id; name = 'reserved'; tag = 'Azure Local' }
            @{ id = $subscriptions[2].id; name = 'general'; tag = 'General' }
        )
        $poolJson = ConvertTo-Json -InputObject $pool -Compress
        $all = @(Get-TestSubscriptionList -TestSubscriptionIds $poolJson)
        $general = @(Get-TestSubscriptionList -TestSubscriptionIds $poolJson -ModulePath 'avm/res/storage/storage-account')
        $reserved = @(Get-TestSubscriptionList -TestSubscriptionIds $poolJson -ModulePath 'avm/res/azure-stack-hci/cluster' -RandomSeed 42)

        $all.tag | Should -Be @('General', 'Azure Local', 'General')
        $all.index | Should -Be @(0, 1, 2)
        $general.index | Should -Be @(0, 2)
        $general.id | Should -Be @($subscriptions[0].id, $subscriptions[2].id)
        $general[0].key | Should -BeExactly $all[0].key
        $general[1].key | Should -BeExactly $all[2].key
        $reserved.Count | Should -Be 1
        $reserved[0].index | Should -Be 1
        $reserved[0].key | Should -BeExactly $all[1].key
    }

    It 'Rejects case variants of the same subscription ID even when tags differ' {
        $json = '[{"id":"ABCDEF12-3456-7890-ABCD-EF1234567890","name":"reserved","tag":"Azure Local"},{"id":"abcdef12-3456-7890-abcd-ef1234567890","name":"general"}]'
        { Get-TestSubscriptionList -TestSubscriptionIds $json } | Should -Throw '*duplicate subscription IDs*'
    }

    It 'Never uses a General or legacy fallback for a reserved module' {
        { Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -ModulePath 'avm/res/azure-stack-hci/cluster' } |
            Should -Throw '*No test subscriptions match required tag*'
        { Get-TestSubscriptionList -FallbackSubscriptionId $subscriptions[0].id -ModulePath 'avm/res/azure-stack-hci/cluster' } |
            Should -Throw '*legacy subscription cannot be used*'
    }

    It 'Does not reinterpret an unknown tag as General' {
        $json = '[{"id":"11111111-1111-1111-1111-111111111111","name":"reserved","tag":"general"}]'
        { Get-TestSubscriptionList -TestSubscriptionIds $json -ModulePath 'avm/res/storage/storage-account' } |
            Should -Throw '*No test subscriptions match required tag*'
    }
}
