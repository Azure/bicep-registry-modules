param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Register-RequiredSubscriptionResourceProvider.ps1')
}

Describe 'Register-RequiredSubscriptionResourceProvider' {
    BeforeEach {
        $script:subscriptionId = '11111111-1111-4111-8111-111111111111'
        $script:tenantId = '22222222-2222-4222-8222-222222222222'
        $testRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -Path $testRoot -ItemType Directory
        $manifestPath = Join-Path $testRoot '.required-resource-providers.json'
        Set-Content -LiteralPath $manifestPath -Value '{"avm/res/example/module":["Microsoft.Example"]}' -Encoding utf8NoBOM -NoNewline
        $functionInput = @{
            RepoRootPath   = $testRoot
            ModulePath     = 'avm/res/example/module'
            SubscriptionId = $script:subscriptionId
            TenantId       = $script:tenantId
        }
        $script:accountResponse = @{ id = $script:subscriptionId; tenantId = $script:tenantId } | ConvertTo-Json -Compress
        $script:providerResponse = $null
        $script:providerResponseOnRead = 1
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', 'Registered'))
        $script:commands = [System.Collections.Generic.List[object]]::new()
        $script:commandCounts = @{}
        $script:failureCommand = ''
        $script:failureOccurrence = 1
        $script:failure = $null

        Mock Invoke-RequiredFeatureAzCli {
            $script:commands.Add(@{
                    Arguments      = @($ArgumentList)
                    RepoRootPath   = $RepoRootPath
                    Operation      = $Operation
                    PermissionHint = $PermissionHint
                })
            $command = $ArgumentList[0..1] -join ' '
            $script:commandCounts[$command]++
            if ($command -eq $script:failureCommand -and $script:commandCounts[$command] -eq $script:failureOccurrence) {
                throw $script:failure
            }
            if ($command -eq 'account show') {
                return $script:accountResponse
            }
            if ($ArgumentList -notcontains '--subscription' -or
                $ArgumentList[[array]::IndexOf($ArgumentList, '--subscription') + 1] -cne $script:subscriptionId) {
                throw 'Unexpected subscription in mocked Azure command.'
            }
            $namespace = $ArgumentList[[array]::IndexOf($ArgumentList, '--namespace') + 1]
            switch ($command) {
                'provider show' {
                    if ($null -ne $script:providerResponse -and $script:commandCounts[$command] -ge $script:providerResponseOnRead) {
                        return $script:providerResponse
                    }
                    $state = $script:providerStates.Count -gt 1 ? $script:providerStates.Dequeue() : $script:providerStates.Peek()
                    return @{
                        id                = "/subscriptions/$($script:subscriptionId)/providers/$namespace"
                        namespace         = $namespace
                        registrationState = $state
                    } | ConvertTo-Json -Compress
                }
                'provider register' { return '' }
                default { throw "Unexpected Azure command [$command]." }
            }
        }
        Mock Start-Sleep {}
        Mock New-Object { throw 'Unexpected native process.' } -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
    }

    AfterEach {
        Should -Invoke New-Object -Times 0 -Exactly -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
    }

    It 'Logs an absent root map without contacting Azure or creating a file' {
        Remove-Item -LiteralPath $manifestPath

        $messages = @(Register-RequiredSubscriptionResourceProvider @functionInput 4>&1)

        ($messages | Out-String) | Should -Match 'No root .required-resource-providers.json'
        ($messages | Where-Object { $_ -is [pscustomobject] }).Status | Should -Be 'skipped'
        Test-Path -LiteralPath $manifestPath | Should -BeFalse
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Skips <case> with a log and no Azure calls' -ForEach @(
        @{ case = 'an empty map'; json = '{}' }
        @{ case = 'an empty provider array'; json = '{"avm/res/example/module":[]}' }
        @{ case = 'an unrelated module'; json = '{"avm/res/example/other":["Microsoft.Other"]}' }
        @{ case = 'a child declaration'; json = '{"avm/res/example/module/child":["Microsoft.Example"]}' }
        @{ case = 'a longer module prefix'; json = '{"avm/res/example/module-two":["Microsoft.Example"]}' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value $json -Encoding utf8NoBOM

        $messages = @(Register-RequiredSubscriptionResourceProvider @functionInput 4>&1)
        $result = $messages | Where-Object { $_ -is [pscustomobject] }

        $result.Status | Should -Be 'skipped'
        $result.ProvidersTotal | Should -Be 0
        ($messages | Out-String) | Should -Match 'No subscription resource providers are required'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Does not inherit a parent module declaration' {
        $functionInput.ModulePath = 'avm/res/example/module/child'

        (Register-RequiredSubscriptionResourceProvider @functionInput).Status | Should -Be 'skipped'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Does not read a nested manifest or an underscore filename' {
        Remove-Item -LiteralPath $manifestPath
        $nestedRoot = Join-Path $testRoot 'avm' 'res' 'example' 'module'
        $null = New-Item -Path $nestedRoot -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path $nestedRoot '.required-resource-providers.json') -Value '{invalid'
        Set-Content -LiteralPath (Join-Path $testRoot '.required_resource_providers.json') -Value '{invalid'

        (Register-RequiredSubscriptionResourceProvider @functionInput).Status | Should -Be 'skipped'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid module input [<modulePath>] before contacting Azure' -ForEach @(
        @{ modulePath = 'AVM/res/example/module' }
        @{ modulePath = 'avm/res/Example/module' }
        @{ modulePath = 'avm\res\example\module' }
        @{ modulePath = './avm/res/example/module' }
        @{ modulePath = 'avm/res/example/module/' }
        @{ modulePath = 'avm/res/example/../module' }
        @{ modulePath = 'avm/res/example/*' }
        @{ modulePath = 'avm/res/example' }
        @{ modulePath = "avm/res/example/module`n" }
    ) {
        $functionInput.ModulePath = $modulePath

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*ModulePath must be an exact*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects malformed JSON and non-map roots [<json>]' -ForEach @(
        @{ json = '' }
        @{ json = '{invalid' }
        @{ json = '{"avm/res/example/module":[],}' }
        @{ json = '{"avm/res/example/module":/*comment*/[]}' }
        @{ json = 'null' }
        @{ json = '[]' }
        @{ json = '"text"' }
        @{ json = 'false' }
        @{ json = '1' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value $json -Encoding utf8NoBOM -NoNewline

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*.required-resource-providers.json*JSON object*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid keys, duplicates and non-array requirements [<case>]' -ForEach @(
        @{ case = 'empty key'; json = '{"":[]}' }
        @{ case = 'uppercase key'; json = '{"avm/res/Example/module":[]}' }
        @{ case = 'non-module key'; json = '{"module":[]}' }
        @{ case = 'traversal key'; json = '{"avm/res/example/../module":[]}' }
        @{ case = 'wildcard key'; json = '{"avm/res/example/*":[]}' }
        @{ case = 'duplicate key'; json = '{"avm/res/example/module":[],"avm/res/example/module":["Microsoft.Example"]}' }
        @{ case = 'escaped duplicate key'; json = '{"avm/res/example/module":[],"avm/res/example/mod\u0075le":[]}' }
        @{ case = 'escaped duplicate provider'; json = '{"avm/res/example/module":["Microsoft.Example","\u004dicrosoft.Example"]}' }
        @{ case = 'null array'; json = '{"avm/res/example/module":null}' }
        @{ case = 'string array'; json = '{"avm/res/example/module":"Microsoft.Example"}' }
        @{ case = 'object array'; json = '{"avm/res/example/module":{"namespace":"Microsoft.Example"}}' }
        @{ case = 'boolean array'; json = '{"avm/res/example/module":true}' }
        @{ case = 'numeric array'; json = '{"avm/res/example/module":1}' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value $json -Encoding utf8NoBOM

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*.required-resource-providers.json*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Validates unrelated entries even when the selected module <case>' -ForEach @(
        @{ case = 'has requirements'; json = '{"avm/res/example/module":["Microsoft.Example"],"avm/res/example/other":[null]}' }
        @{ case = 'has no requirements'; json = '{"avm/res/example/other":[null]}' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value $json -Encoding utf8NoBOM

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*avm/res/example/other*only provider namespace strings*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid provider arrays [<case>]' -ForEach @(
        @{ case = 'null'; providers = @($null) }
        @{ case = 'number'; providers = @(1) }
        @{ case = 'boolean'; providers = @($true) }
        @{ case = 'object'; providers = @(@{ namespace = 'Microsoft.Example' }) }
        @{ case = 'nested array'; providers = @(, @('Microsoft.Example')) }
        @{ case = 'empty'; providers = @('') }
        @{ case = 'missing dot'; providers = @('Microsoft') }
        @{ case = 'empty segment'; providers = @('Microsoft..Example') }
        @{ case = 'leading digit'; providers = @('Microsoft.1Example') }
        @{ case = 'feature syntax'; providers = @('Microsoft.Example/FeatureOne') }
        @{ case = 'trailing slash'; providers = @('Microsoft.Example/') }
        @{ case = 'leading whitespace'; providers = @(' Microsoft.Example') }
        @{ case = 'trailing whitespace'; providers = @('Microsoft.Example ') }
        @{ case = 'command argument'; providers = @('Microsoft.Example --subscription other') }
        @{ case = 'semicolon'; providers = @('Microsoft.Example;exit') }
        @{ case = 'expression'; providers = @('Microsoft.$(exit)') }
        @{ case = 'newline'; providers = @("Microsoft.Example`n") }
        @{ case = 'non-ASCII'; providers = @("Microsoft.Exampl$([char] 0x00E9)") }
        @{ case = 'long namespace'; providers = @('Microsoft.' + ('A' * 119)) }
        @{ case = 'duplicate'; providers = @('Microsoft.Example', 'Microsoft.Example') }
        @{ case = 'case-insensitive duplicate'; providers = @('Microsoft.Example', 'microsoft.example') }
    ) {
        @{ 'avm/res/example/module' = $providers } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*.required-resource-providers.json*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Accepts 32 providers and rejects 33 before Azure calls, including WhatIf' {
        foreach ($count in @(32, 33)) {
            @{ 'avm/res/example/module' = @(1..$count | ForEach-Object { "Microsoft.Example$_" }) } |
                ConvertTo-Json | Set-Content -LiteralPath $manifestPath
            if ($count -eq 32) {
                (Register-RequiredSubscriptionResourceProvider @functionInput -WhatIf).ProvidersTotal | Should -Be 32
            } else {
                { Register-RequiredSubscriptionResourceProvider @functionInput -WhatIf } | Should -Throw '*no more than 32 resource providers*'
            }
        }
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Accepts 128 ASCII characters and an exact nested <kind> module' -ForEach @(
        @{ kind = 'res' }
        @{ kind = 'ptn' }
        @{ kind = 'utl' }
    ) {
        $functionInput.ModulePath = "avm/$kind/example/module-one/child2"
        @{ $functionInput.ModulePath = @('Contoso.' + ('A' * 120)) } | ConvertTo-Json | Set-Content -LiteralPath $manifestPath

        (Register-RequiredSubscriptionResourceProvider @functionInput -WhatIf).ProvidersTotal | Should -Be 1
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Enforces the 64 KiB byte limit at its exact boundary' {
        Set-Content -LiteralPath $manifestPath -Value ('{}' + (' ' * 65534)) -Encoding utf8NoBOM -NoNewline
        (Register-RequiredSubscriptionResourceProvider @functionInput).Status | Should -Be 'skipped'
        Add-Content -LiteralPath $manifestPath -Value ' ' -Encoding utf8NoBOM -NoNewline

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*64 KiB*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects a directory with the manifest name' {
        Remove-Item -LiteralPath $manifestPath
        $null = New-Item -Path $manifestPath -ItemType Directory

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*file named exactly*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects incorrectly cased manifest filenames' {
        Remove-Item -LiteralPath $manifestPath
        Set-Content -LiteralPath (Join-Path $testRoot '.REQUIRED-RESOURCE-PROVIDERS.json') -Value '{}'

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*file named exactly*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Validates requirements under WhatIf without querying Azure' {
        $result = Register-RequiredSubscriptionResourceProvider @functionInput -WhatIf

        $result.Status | Should -Be 'skipped'
        $result.ProvidersTotal | Should -Be 1
        $result.Reason | Should -Match 'WhatIf'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid <parameter> [<value>] before querying Azure' -ForEach @(
        @{ parameter = 'SubscriptionId'; value = 'invalid' }
        @{ parameter = 'SubscriptionId'; value = '00000000-0000-0000-0000-000000000000' }
        @{ parameter = 'SubscriptionId'; value = '11111111111141118111111111111111' }
        @{ parameter = 'SubscriptionId'; value = '11111111-1111-4111-8111-111111111111 --debug' }
        @{ parameter = 'TenantId'; value = 'invalid' }
        @{ parameter = 'TenantId'; value = '00000000-0000-0000-0000-000000000000' }
        @{ parameter = 'TenantId'; value = '{22222222-2222-4222-8222-222222222222}' }
    ) {
        $functionInput[$parameter] = $value

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw "*$parameter must be an explicit, nonempty GUID*"
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid accounts before looking up any provider [<case>]' -ForEach @(
        @{ case = 'invalid JSON'; response = '{invalid' }
        @{ case = 'empty response'; response = '' }
        @{ case = 'null'; response = 'null' }
        @{ case = 'array'; response = '[]' }
        @{ case = 'missing properties'; response = '{}' }
        @{ case = 'wrong subscription'; response = '{"id":"33333333-3333-4333-8333-333333333333","tenantId":"22222222-2222-4222-8222-222222222222"}' }
        @{ case = 'wrong tenant'; response = '{"id":"11111111-1111-4111-8111-111111111111","tenantId":"33333333-3333-4333-8333-333333333333"}' }
        @{ case = 'nonstring subscription'; response = '{"id":1,"tenantId":"22222222-2222-4222-8222-222222222222"}' }
        @{ case = 'nonstring tenant'; response = '{"id":"11111111-1111-4111-8111-111111111111","tenantId":true}' }
    ) {
        $script:accountResponse = $response

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 1 -Exactly
        $script:commands[0].Arguments | Should -Be @('account', 'show', '--output', 'json', '--only-show-errors')
    }

    It 'Canonicalizes explicit GUIDs without switching subscription or tenant' {
        $script:subscriptionId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
        $script:tenantId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'
        $functionInput.SubscriptionId = $script:subscriptionId.ToUpperInvariant()
        $functionInput.TenantId = $script:tenantId.ToUpperInvariant()
        $script:accountResponse = @{ id = $functionInput.SubscriptionId; tenantId = $functionInput.TenantId } | ConvertTo-Json -Compress

        $result = Register-RequiredSubscriptionResourceProvider @functionInput

        $result.SubscriptionId | Should -BeExactly $script:subscriptionId
        $result.TenantId | Should -BeExactly $script:tenantId
        ($script:commands | ConvertTo-Json -Depth 5) | Should -Not -Match 'account set|Set-AzContext|unregister'
    }

    It 'Skips an already registered provider without registration or polling' {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registered'))

        $result = Register-RequiredSubscriptionResourceProvider @functionInput -Confirm:$false

        $result.Status | Should -Be 'pass'
        $result.AlreadyRegisteredProviders | Should -Be @('Microsoft.Example')
        $result.RegisteredProviders.Count | Should -Be 0
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Handles initially <state> providers without unnecessary registration' -ForEach @(
        @{ state = 'NotRegistered'; registerCount = 1 }
        @{ state = 'Unregistered'; registerCount = 1 }
        @{ state = 'Registering'; registerCount = 0 }
    ) {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @($state, 'Registering', 'Registered'))

        $result = Register-RequiredSubscriptionResourceProvider @functionInput

        $result.Status | Should -Be 'pass'
        $result.RegisteredProviders | Should -Be @('Microsoft.Example')
        $expected = @('account show', 'provider show')
        if ($registerCount) { $expected += 'provider register' }
        $expected += @('provider show', 'provider show')
        @($script:commands | ForEach-Object { $_.Arguments[0..1] -join ' ' }) | Should -Be $expected
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 10 }
        foreach ($command in $script:commands) {
            $command.RepoRootPath | Should -Be $testRoot
            if ($command.Arguments[0] -eq 'provider') {
                $outputFormat = $command.Arguments[1] -eq 'register' ? 'none' : 'json'
                $command.Arguments | Should -Be @(
                    'provider', $command.Arguments[1], '--namespace', 'Microsoft.Example',
                    '--subscription', $script:subscriptionId, '--output', $outputFormat, '--only-show-errors'
                )
            }
        }
        if ($registerCount) {
            ($script:commands | Where-Object { $_.Arguments[1] -eq 'register' }).PermissionHint | Should -Match '/register/action'
        }
    }

    It 'Uses only exact module requirements and handles mixed registered and new providers' {
        Set-Content -LiteralPath $manifestPath -Value '{"avm/res/example/other":["Microsoft.Other"],"avm/res/example/module":["Microsoft.Example","Contoso.Service"]}'
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registered', 'Unregistered', 'Registered'))

        $result = Register-RequiredSubscriptionResourceProvider @functionInput

        $result.ProvidersTotal | Should -Be 2
        $result.AlreadyRegisteredProviders | Should -Be @('Microsoft.Example')
        $result.RegisteredProviders | Should -Be @('Contoso.Service')
        ($script:commands | ConvertTo-Json -Depth 5) | Should -Not -Match 'Microsoft.Other|feature|unregister|--consent|--accept'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 1 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'register' }
    }

    It 'Preserves feature provider refresh and skips the completed provider prerequisite' {
        Set-Content -LiteralPath (Join-Path $testRoot '.required-features.json') -Value '{"avm/res/example/module":["Microsoft.Example/FeatureOne"]}'
        $script:featureReads = 0
        Mock Invoke-RequiredFeatureAzCli {
            $command = $ArgumentList[0..1] -join ' '
            $script:commands.Add($command)
            switch ($command) {
                'account show' { return $script:accountResponse }
                'feature show' {
                    $script:featureReads++
                    return @{
                        id = "/subscriptions/$($script:subscriptionId)/providers/Microsoft.Features/providers/Microsoft.Example/features/FeatureOne"
                        name = 'Microsoft.Example/FeatureOne'
                        properties = @{ state = $script:featureReads -eq 1 ? 'NotRegistered' : 'Registered' }
                    } | ConvertTo-Json -Compress
                }
                'feature register' { return '' }
                'provider register' { return '' }
                'provider show' { return '{"namespace":"Microsoft.Example","registrationState":"Registered"}' }
                default { throw "Unexpected Azure command [$command]." }
            }
        }

        $featureResult = Register-RequiredSubscriptionFeature @functionInput
        $providerResult = Register-RequiredSubscriptionResourceProvider @functionInput

        $featureResult.RegisteredFeatures | Should -Be @('Microsoft.Example/FeatureOne')
        $providerResult.AlreadyRegisteredProviders | Should -Be @('Microsoft.Example')
        $providerResult.RegisteredProviders.Count | Should -Be 0
        @($script:commands) | Should -Be @(
            'account show', 'feature show', 'feature register', 'feature show', 'provider register', 'provider show',
            'account show', 'provider show'
        )
    }

    It 'Rejects an initial terminal or unknown state [<state>]' -ForEach @(
        @{ state = 'Pending' }
        @{ state = 'Failed' }
        @{ state = 'Canceled' }
        @{ state = 'Cancelled' }
        @{ state = 'Unregistering' }
        @{ state = 'Unknown' }
        @{ state = 'registered' }
    ) {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @($state))

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw "*$state*subscription*"
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Stops when polling returns [<state>]' -ForEach @(
        @{ state = 'Pending' }
        @{ state = 'Failed' }
        @{ state = 'Cancelled' }
        @{ state = 'Unregistering' }
        @{ state = 'Unknown' }
    ) {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', $state))

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw "*$state*subscription*"
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 4 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Bounds default polling to 60 checks without resubmitting an existing registration' {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering'))

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*after 60 checks (10 seconds apart)*'
        Should -Invoke Start-Sleep -Times 59 -Exactly -ParameterFilter { $Seconds -eq 10 }
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 61 -Exactly -ParameterFilter { $ArgumentList[0..1] -join ' ' -eq 'provider show' }
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'register' }
    }

    It 'Does not resubmit when a newly requested provider remains [<state>]' -ForEach @(
        @{ state = 'NotRegistered' }
        @{ state = 'Unregistered' }
        @{ state = 'Registering' }
    ) {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', $state))

        { Register-RequiredSubscriptionResourceProvider @functionInput -MaximumPolls 2 -PollIntervalSeconds 1 } | Should -Throw '*after 2 checks (1 seconds apart)*'
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 1 }
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 1 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'register' }
    }

    It 'Accepts Registered on the final permitted poll' {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', 'Registering', 'Registered'))

        (Register-RequiredSubscriptionResourceProvider @functionInput -MaximumPolls 2 -PollIntervalSeconds 1).Status | Should -Be 'pass'
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 1 }
    }

    It 'Rejects invalid <parameter> timing values [<value>]' -ForEach @(
        @{ parameter = 'MaximumPolls'; value = 0 }
        @{ parameter = 'MaximumPolls'; value = 121 }
        @{ parameter = 'PollIntervalSeconds'; value = 0 }
        @{ parameter = 'PollIntervalSeconds'; value = 61 }
    ) {
        $functionInput[$parameter] = $value

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects malformed or mismatched provider responses [<response>]' -ForEach @(
        @{ response = '{invalid' }
        @{ response = '' }
        @{ response = 'null' }
        @{ response = '[]' }
        @{ response = '{}' }
        @{ response = '{"namespace":"Microsoft.Other","registrationState":"Registered"}' }
        @{ response = '{"namespace":"Microsoft.Example","registrationState":false}' }
        @{ response = '{"namespace":"Microsoft.Example","registrationState":" "}' }
        @{ response = '{"namespace":"Microsoft.Example","registrationState":null}' }
        @{ response = '{"namespace":"Microsoft.Example","registrationState":"Registered","id":1}' }
        @{ response = '{"namespace":"Microsoft.Example","registrationState":"Registered","id":"/subscriptions/33333333-3333-4333-8333-333333333333/providers/Microsoft.Example"}' }
        @{ response = '{"namespace":"Microsoft.Example","registrationState":"Registered","id":"/subscriptions/11111111-1111-4111-8111-111111111111/providers/Microsoft.Other"}' }
    ) {
        $script:providerResponse = $response

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*Azure CLI returned*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly
    }

    It 'Revalidates provider identity during polling without repeating registration' {
        $script:providerResponse = '{"namespace":"Microsoft.Other","registrationState":"Registered"}'
        $script:providerResponseOnRead = 2

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*unexpected provider identity*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 4 -Exactly
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 1 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'register' }
    }

    It 'Preserves <phase> failures without continuing to another provider' -ForEach @(
        @{ phase = 'account'; command = 'account show'; occurrence = 1; message = 'Not authenticated' }
        @{ phase = 'initial status'; command = 'provider show'; occurrence = 1; message = 'NoRegisteredProviderFound' }
        @{ phase = 'registration'; command = 'provider register'; occurrence = 1; message = 'AuthorizationFailed: register/action' }
        @{ phase = 'polling'; command = 'provider show'; occurrence = 2; message = 'Provider status lookup failed' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value '{"avm/res/example/module":["Microsoft.Example","Microsoft.Later"]}'
        $script:failureCommand = $command
        $script:failureOccurrence = $occurrence
        $script:failure = [System.InvalidOperationException]::new($message)

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw "*$message*"
        ($script:commands[-1].Arguments[0..1] -join ' ') | Should -Be $command
        ($script:commands | ConvertTo-Json -Depth 5) | Should -Not -Match 'Microsoft.Later'
    }

    It 'Preserves command interruptions without retrying [<type>]' -ForEach @(
        @{ type = 'System.OperationCanceledException' }
        @{ type = 'System.TimeoutException' }
    ) {
        $script:failureCommand = 'provider register'
        $script:failure = [System.Activator]::CreateInstance(($type -as [type]), [object[]] @('Synthetic command interruption'))

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*Synthetic command interruption*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 3 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Stops immediately when polling is cancelled' {
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering'))
        Mock Start-Sleep { throw [System.OperationCanceledException]::new('Synthetic polling cancellation') }

        { Register-RequiredSubscriptionResourceProvider @functionInput } | Should -Throw '*Synthetic polling cancellation*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 3 -Exactly
        Should -Invoke Start-Sleep -Times 1 -Exactly
    }

    It 'Preserves pipeline cancellation during <phase> without returning success' -ForEach @(
        @{ phase = 'command' }
        @{ phase = 'polling' }
    ) {
        $trace = [System.Collections.Generic.List[string]]::new()
        $pipeline = [powershell]::Create()
        try {
            $null = $pipeline.AddScript(@'
param ($HelperPath, $RegistrationInput, $Trace, $Phase)
. $HelperPath
function Invoke-RequiredFeatureAzCli {
    [CmdletBinding()]
    param ([string[]] $ArgumentList, [string] $RepoRootPath, [string] $Operation, [string] $PermissionHint)
    $command = $ArgumentList[0..1] -join ' '
    $Trace.Add($command)
    switch ($command) {
        'account show' {
            return @{ id = $RegistrationInput.SubscriptionId; tenantId = $RegistrationInput.TenantId } | ConvertTo-Json -Compress
        }
        'provider show' {
            return '{"namespace":"Microsoft.Example","registrationState":"NotRegistered"}'
        }
        'provider register' {
            if ($Phase -eq 'command') {
                throw [System.Management.Automation.PipelineStoppedException]::new('Synthetic command cancellation')
            }
            return ''
        }
        default { throw "Unexpected Azure command [$command]." }
    }
}
function Start-Sleep {
    param ([int] $Seconds)
    $Trace.Add('sleep')
    throw [System.Management.Automation.PipelineStoppedException]::new('Synthetic polling cancellation')
}
$null = Register-RequiredSubscriptionResourceProvider @RegistrationInput
$Trace.Add('returned')
'@).AddArgument((Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Register-RequiredSubscriptionResourceProvider.ps1')).AddArgument($functionInput).AddArgument($trace).AddArgument($phase)
            $null = $pipeline.Invoke()

            $pipeline.InvocationStateInfo.State | Should -Be 'Stopped'
            $pipeline.InvocationStateInfo.Reason | Should -BeOfType [System.Management.Automation.PipelineStoppedException]
            $expected = @('account show', 'provider show', 'provider register')
            if ($phase -eq 'polling') { $expected += @('provider show', 'sleep') }
            @($trace) | Should -Be $expected
        } finally {
            $pipeline.Dispose()
        }
    }

    It 'Does not emit unrelated Azure account fields' {
        $script:accountResponse = @{
            id = $script:subscriptionId
            tenantId = $script:tenantId
            user = @{ name = 'synthetic-private-account-field' }
        } | ConvertTo-Json -Compress

        $messages = @(Register-RequiredSubscriptionResourceProvider @functionInput 4>&1)

        ($messages | Out-String) | Should -Not -Match 'synthetic-private-account-field'
    }

    It 'Declares the documented Azure Local providers for the HCI consumer' {
        $modulePath = 'avm/res/hybrid-container-service/provisioned-cluster-instance'
        $expected = @(
            'Microsoft.HybridCompute', 'Microsoft.GuestConfiguration', 'Microsoft.HybridConnectivity',
            'Microsoft.AzureStackHCI', 'Microsoft.Kubernetes', 'Microsoft.KubernetesConfiguration',
            'Microsoft.ExtendedLocation', 'Microsoft.ResourceConnector', 'Microsoft.HybridContainerService',
            'Microsoft.Attestation', 'Microsoft.Storage', 'Microsoft.Insights', 'Microsoft.KeyVault'
        )

        $requirements = @(Get-RequiredSubscriptionRequirement -RepoRootPath $RepoRootPath -ModulePath $modulePath -Kind Provider)

        $requirements.Namespace | Should -Be $expected
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }
}
