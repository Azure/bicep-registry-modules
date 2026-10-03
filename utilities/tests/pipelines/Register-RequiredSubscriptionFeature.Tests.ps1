param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Register-RequiredSubscriptionFeature.ps1')
}

Describe 'Register-RequiredSubscriptionFeature' {
    BeforeAll {
        function Get-TestFeatureResponse {
            param ([string] $Namespace, [string] $Name, [string] $State)

            return @{
                id         = "/subscriptions/$($script:subscriptionId)/providers/Microsoft.Features/providers/$Namespace/features/$Name"
                name       = "$Namespace/$Name"
                properties = @{ state = $State }
            } | ConvertTo-Json -Compress
        }
    }

    BeforeEach {
        $script:subscriptionId = '11111111-1111-4111-8111-111111111111'
        $script:tenantId = '22222222-2222-4222-8222-222222222222'
        $testRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $null = New-Item -Path $testRoot -ItemType Directory
        $manifestPath = Join-Path $testRoot '.required-features.json'
        Set-Content -LiteralPath $manifestPath -Value '{"avm/res/example/module":["Microsoft.Example/FeatureOne"]}' -Encoding utf8NoBOM -NoNewline
        $functionInput = @{
            RepoRootPath   = $testRoot
            ModulePath     = 'avm/res/example/module'
            SubscriptionId = $script:subscriptionId
            TenantId       = $script:tenantId
        }
        $script:accountResponse = @{ id = $script:subscriptionId; tenantId = $script:tenantId } | ConvertTo-Json -Compress
        $script:featureResponse = $null
        $script:providerResponse = $null
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', 'Registered'))
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registered'))
        $script:commands = [System.Collections.Generic.List[object]]::new()
        $script:failureCommand = ''
        $script:failure = $null

        Mock Invoke-RequiredFeatureAzCli {
            $script:commands.Add(@{
                    Arguments      = @($ArgumentList)
                    RepoRootPath   = $RepoRootPath
                    Operation      = $Operation
                    PermissionHint = $PermissionHint
                })
            $command = $ArgumentList[0..1] -join ' '
            if ($command -eq $script:failureCommand) {
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
                'feature show' {
                    if ($null -ne $script:featureResponse) { return $script:featureResponse }
                    $name = $ArgumentList[[array]::IndexOf($ArgumentList, '--name') + 1]
                    $state = $script:featureStates.Count -gt 1 ? $script:featureStates.Dequeue() : $script:featureStates.Peek()
                    return Get-TestFeatureResponse -Namespace $namespace -Name $name -State $state
                }
                'provider show' {
                    if ($null -ne $script:providerResponse) { return $script:providerResponse }
                    $state = $script:providerStates.Count -gt 1 ? $script:providerStates.Dequeue() : $script:providerStates.Peek()
                    return @{ namespace = $namespace; registrationState = $state } | ConvertTo-Json -Compress
                }
                'feature register' { return '' }
                'provider register' { return '' }
                default { throw "Unexpected Azure command [$command]." }
            }
        }
        Mock Start-Sleep {}
        Mock New-Object { throw 'Unexpected native process.' } -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
    }

    It 'Logs an absent root map without contacting Azure or creating a file' {
        Remove-Item -LiteralPath $manifestPath

        $messages = @(Register-RequiredSubscriptionFeature @functionInput 4>&1)

        ($messages | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } | Out-String) | Should -Match 'No root .required-features.json'
        ($messages | Where-Object { $_ -is [pscustomobject] }).Status | Should -Be 'skipped'
        Test-Path -LiteralPath $manifestPath | Should -BeFalse
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Skips <case> without contacting Azure' -ForEach @(
        @{ case = 'an empty map'; json = '{}' }
        @{ case = 'an empty feature array'; json = '{"avm/res/example/module":[]}' }
        @{ case = 'an unrelated module'; json = '{"avm/res/example/other":["Microsoft.Example/FeatureOne"]}' }
        @{ case = 'a child module declaration'; json = '{"avm/res/example/module/child":["Microsoft.Example/FeatureOne"]}' }
        @{ case = 'a longer module prefix'; json = '{"avm/res/example/module-two":["Microsoft.Example/FeatureOne"]}' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value $json -Encoding utf8NoBOM

        $messages = @(Register-RequiredSubscriptionFeature @functionInput 4>&1)
        $result = $messages | Where-Object { $_ -is [pscustomobject] }

        $result.Status | Should -Be 'skipped'
        $result.FeaturesTotal | Should -Be 0
        ($messages | Out-String) | Should -Match 'No subscription features are required'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Does not inherit a parent module requirement' {
        $functionInput.ModulePath = 'avm/res/example/module/child'

        (Register-RequiredSubscriptionFeature @functionInput).Status | Should -Be 'skipped'
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
    ) {
        $functionInput.ModulePath = $modulePath

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*ModulePath must be an exact*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects malformed JSON or a non-map root [<json>]' -ForEach @(
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

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*.required-features.json*JSON object*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid map keys, duplicate keys and non-array requirements [<case>]' -ForEach @(
        @{ case = 'empty key'; json = '{"":[]}' }
        @{ case = 'uppercase key'; json = '{"avm/res/Example/module":[]}' }
        @{ case = 'non-module key'; json = '{"module":[]}' }
        @{ case = 'duplicate key'; json = '{"avm/res/example/module":[],"avm/res/example/module":["Microsoft.Example/FeatureOne"]}' }
        @{ case = 'escaped duplicate key'; json = '{"avm/res/example/module":[],"avm/res/example/mod\u0075le":[]}' }
        @{ case = 'null array'; json = '{"avm/res/example/module":null}' }
        @{ case = 'string array'; json = '{"avm/res/example/module":"Microsoft.Example/FeatureOne"}' }
        @{ case = 'object array'; json = '{"avm/res/example/module":{"feature":"Microsoft.Example/FeatureOne"}}' }
        @{ case = 'boolean array'; json = '{"avm/res/example/module":true}' }
        @{ case = 'numeric array'; json = '{"avm/res/example/module":1}' }
    ) {
        Set-Content -LiteralPath $manifestPath -Value $json -Encoding utf8NoBOM

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*.required-features.json*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Validates an unrelated entry before making any Azure calls' {
        Set-Content -LiteralPath $manifestPath -Value '{"avm/res/example/module":["Microsoft.Example/FeatureOne"],"avm/res/example/other":[null]}'

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*avm/res/example/other*only Namespace/FeatureName strings*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects an invalid feature array [<case>]' -ForEach @(
        @{ case = 'null feature'; features = @($null) }
        @{ case = 'numeric feature'; features = @(1) }
        @{ case = 'boolean feature'; features = @($true) }
        @{ case = 'object feature'; features = @(@{ namespace = 'Microsoft.Example'; name = 'FeatureOne' }) }
        @{ case = 'empty feature'; features = @('') }
        @{ case = 'missing namespace'; features = @('/FeatureOne') }
        @{ case = 'missing feature name'; features = @('Microsoft.Example/') }
        @{ case = 'missing namespace dot'; features = @('Example/FeatureOne') }
        @{ case = 'extra segment'; features = @('Microsoft.Example/FeatureOne/Extra') }
        @{ case = 'whitespace'; features = @('Microsoft.Example/Feature One') }
        @{ case = 'command argument'; features = @('Microsoft.Example/FeatureOne --subscription other') }
        @{ case = 'newline'; features = @("Microsoft.Example/FeatureOne`n") }
        @{ case = 'non-ASCII'; features = @("Microsoft.Example/Featur$([char] 0x00E9)") }
        @{ case = 'long namespace'; features = @(('Microsoft.' + ('A' * 119)) + '/FeatureOne') }
        @{ case = 'long feature'; features = @('Microsoft.Example/' + ('A' * 129)) }
        @{ case = 'duplicate'; features = @('Microsoft.Example/FeatureOne', 'Microsoft.Example/FeatureOne') }
        @{ case = 'case-insensitive duplicate'; features = @('Microsoft.Example/FeatureOne', 'microsoft.example/featureone') }
    ) {
        @{ 'avm/res/example/module' = $features } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*.required-features.json*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Accepts exactly 32 features and rejects 33 without contacting Azure' {
        foreach ($count in @(32, 33)) {
            @{ 'avm/res/example/module' = @(1..$count | ForEach-Object { "Microsoft.Example/Feature$_" }) } |
                ConvertTo-Json | Set-Content -LiteralPath $manifestPath
            if ($count -eq 32) {
                (Register-RequiredSubscriptionFeature @functionInput -WhatIf).FeaturesTotal | Should -Be 32
            } else {
                { Register-RequiredSubscriptionFeature @functionInput -WhatIf } | Should -Throw '*no more than 32 features*'
            }
        }
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Accepts 128 characters per feature part and a nested canonical module path' {
        $functionInput.ModulePath = 'avm/utl/example/module/child'
        $feature = ('Microsoft.' + ('A' * 118)) + '/' + ('B' * 128)
        @{ $functionInput.ModulePath = @($feature) } | ConvertTo-Json | Set-Content -LiteralPath $manifestPath

        (Register-RequiredSubscriptionFeature @functionInput -WhatIf).FeaturesTotal | Should -Be 1
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Enforces the 64 KiB file limit at its exact boundary' {
        Set-Content -LiteralPath $manifestPath -Value ('{}' + (' ' * 65534)) -Encoding utf8NoBOM -NoNewline
        (Register-RequiredSubscriptionFeature @functionInput).Status | Should -Be 'skipped'
        Add-Content -LiteralPath $manifestPath -Value ' ' -Encoding utf8NoBOM -NoNewline

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*64 KiB*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects a directory with the manifest name rather than treating it as absent' {
        Remove-Item -LiteralPath $manifestPath
        $null = New-Item -Path $manifestPath -ItemType Directory

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*file named exactly*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects incorrectly cased manifest filenames' {
        Remove-Item -LiteralPath $manifestPath
        Set-Content -LiteralPath (Join-Path $testRoot '.REQUIRED-FEATURES.json') -Value '{}'

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*file named exactly*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Validates requirements under WhatIf without querying Azure' {
        $result = Register-RequiredSubscriptionFeature @functionInput -WhatIf

        $result.Status | Should -Be 'skipped'
        $result.FeaturesTotal | Should -Be 1
        $result.Reason | Should -Match 'WhatIf'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects invalid <parameter> [<value>] before querying Azure' -ForEach @(
        @{ parameter = 'SubscriptionId'; value = 'invalid' }
        @{ parameter = 'SubscriptionId'; value = '00000000-0000-0000-0000-000000000000' }
        @{ parameter = 'SubscriptionId'; value = '11111111111141118111111111111111' }
        @{ parameter = 'TenantId'; value = 'invalid' }
        @{ parameter = 'TenantId'; value = '00000000-0000-0000-0000-000000000000' }
    ) {
        $functionInput[$parameter] = $value

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw "*$parameter must be an explicit, nonempty GUID*"
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects missing, malformed or mismatched Azure account values [<case>]' -ForEach @(
        @{ case = 'invalid JSON'; response = '{invalid' }
        @{ case = 'empty response'; response = '' }
        @{ case = 'null'; response = 'null' }
        @{ case = 'array'; response = '[]' }
        @{ case = 'missing properties'; response = '{}' }
        @{ case = 'wrong subscription'; response = '{"id":"33333333-3333-4333-8333-333333333333","tenantId":"22222222-2222-4222-8222-222222222222"}' }
        @{ case = 'wrong tenant'; response = '{"id":"11111111-1111-4111-8111-111111111111","tenantId":"33333333-3333-4333-8333-333333333333"}' }
        @{ case = 'nonstring subscription'; response = '{"id":1,"tenantId":"22222222-2222-4222-8222-222222222222"}' }
    ) {
        $script:accountResponse = $response

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 1 -Exactly
        $script:commands[0].Arguments[0..1] | Should -Be @('account', 'show')
    }

    It 'Skips an already registered feature and does not re-register its provider' {
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registered'))

        $result = Register-RequiredSubscriptionFeature @functionInput

        $result.Status | Should -Be 'pass'
        $result.AlreadyRegisteredFeatures | Should -Be @('Microsoft.Example/FeatureOne')
        $result.RegisteredFeatures.Count | Should -Be 0
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Canonicalizes explicit GUIDs without switching subscription or tenant' {
        $script:subscriptionId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
        $script:tenantId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'
        $functionInput.SubscriptionId = $script:subscriptionId.ToUpperInvariant()
        $functionInput.TenantId = $script:tenantId.ToUpperInvariant()
        $script:accountResponse = @{ id = $functionInput.SubscriptionId; tenantId = $functionInput.TenantId } | ConvertTo-Json -Compress

        $result = Register-RequiredSubscriptionFeature @functionInput

        $result.SubscriptionId | Should -BeExactly $script:subscriptionId
        $result.TenantId | Should -BeExactly $script:tenantId
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly -ParameterFilter { $ArgumentList[0] -eq 'account' -and $ArgumentList[1] -eq 'set' }
    }

    It 'Registers an initially <state> feature and waits before refreshing its provider' -ForEach @(
        @{ state = 'NotRegistered'; registerCount = 1 }
        @{ state = 'Unregistered'; registerCount = 1 }
        @{ state = 'Registering'; registerCount = 0 }
    ) {
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @($state, 'Registering', 'Registered'))
        $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering', 'Registered'))

        $result = Register-RequiredSubscriptionFeature @functionInput

        $result.Status | Should -Be 'pass'
        $result.RegisteredFeatures | Should -Be @('Microsoft.Example/FeatureOne')
        $expected = @('account show', 'feature show')
        if ($registerCount) { $expected += 'feature register' }
        $expected += @('feature show', 'feature show', 'provider register', 'provider show', 'provider show')
        @($script:commands | ForEach-Object { $_.Arguments[0..1] -join ' ' }) | Should -Be $expected
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 10 }
        foreach ($command in $script:commands) {
            $command.RepoRootPath | Should -Be $testRoot
            $command.Arguments | Should -Contain '--only-show-errors'
            if ($command.Arguments[0] -ne 'account') {
                $command.Arguments[[array]::IndexOf($command.Arguments, '--subscription') + 1] | Should -BeExactly $script:subscriptionId
            }
        }
        ($script:commands | Where-Object { $_.Arguments[0] -eq 'provider' -and $_.Arguments[1] -eq 'register' }).PermissionHint | Should -Match '/register/action'
    }

    It 'Registers only the exact module requirements and propagates each completed feature' {
        Set-Content -LiteralPath $manifestPath -Value '{"avm/res/example/other":["Microsoft.Other/Unused"],"avm/res/example/module":["Microsoft.Example/FeatureOne","Microsoft.Example/FeatureTwo"]}'
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', 'Registered', 'NotRegistered', 'Registered'))

        $result = Register-RequiredSubscriptionFeature @functionInput

        $result.RegisteredFeatures | Should -Be @('Microsoft.Example/FeatureOne', 'Microsoft.Example/FeatureTwo')
        ($script:commands | ConvertTo-Json -Depth 5) | Should -Not -Match 'Microsoft.Other|Unused|unregister|account set'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly -ParameterFilter { $ArgumentList[0] -eq 'provider' -and $ArgumentList[1] -eq 'register' }
    }

    It 'Rejects an initial terminal feature state [<state>]' -ForEach @(
        @{ state = 'Pending' }
        @{ state = 'Failed' }
        @{ state = 'Canceled' }
        @{ state = 'Cancelled' }
        @{ state = 'Unregistering' }
        @{ state = 'Unknown' }
        @{ state = 'registered' }
    ) {
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @($state))

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw "*$state*subscription*"
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Stops when <kind> polling returns <state>' -ForEach @(
        @{ kind = 'feature'; state = 'Pending' }
        @{ kind = 'feature'; state = 'Failed' }
        @{ kind = 'feature'; state = 'Canceled' }
        @{ kind = 'feature'; state = 'Unregistering' }
        @{ kind = 'provider'; state = 'Pending' }
        @{ kind = 'provider'; state = 'Failed' }
        @{ kind = 'provider'; state = 'Cancelled' }
    ) {
        if ($kind -eq 'feature') {
            $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('NotRegistered', $state))
        } else {
            $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @($state))
        }

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw "*$state*subscription*"
        if ($kind -eq 'feature') {
            Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly -ParameterFilter { $ArgumentList[0] -eq 'provider' }
        }
    }

    It 'Bounds <kind> polling at 60 checks with 59 sleeps by default' -ForEach @(
        @{ kind = 'feature' }
        @{ kind = 'provider' }
    ) {
        if ($kind -eq 'feature') {
            $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering'))
        } else {
            $script:providerStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering'))
        }

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*after 60 checks (10 seconds apart)*'
        Should -Invoke Start-Sleep -Times 59 -Exactly -ParameterFilter { $Seconds -eq 10 }
        $expectedReads = $kind -eq 'feature' ? 61 : 60
        Should -Invoke Invoke-RequiredFeatureAzCli -Times $expectedReads -Exactly -ParameterFilter { $ArgumentList[0] -eq $kind -and $ArgumentList[1] -eq 'show' }
        if ($kind -eq 'feature') {
            Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly -ParameterFilter { $ArgumentList[0] -eq 'provider' }
        }
    }

    It 'Allows bounded polling overrides without sleeping before the first check' {
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering'))

        { Register-RequiredSubscriptionFeature @functionInput -MaximumPolls 2 -PollIntervalSeconds 1 } | Should -Throw '*after 2 checks (1 seconds apart)*'
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 1 }
    }

    It 'Rejects invalid <parameter> timing values [<value>]' -ForEach @(
        @{ parameter = 'MaximumPolls'; value = 0 }
        @{ parameter = 'MaximumPolls'; value = 121 }
        @{ parameter = 'PollIntervalSeconds'; value = 0 }
        @{ parameter = 'PollIntervalSeconds'; value = 61 }
    ) {
        $functionInput[$parameter] = $value

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly
    }

    It 'Rejects malformed or mismatched feature responses [<response>]' -ForEach @(
        @{ response = '{invalid' }
        @{ response = '' }
        @{ response = 'null' }
        @{ response = '[]' }
        @{ response = '{}' }
        @{ response = '{"id":"wrong","name":"Microsoft.Example/FeatureOne","properties":{"state":"Registered"}}' }
        @{ response = '{"id":"/subscriptions/11111111-1111-4111-8111-111111111111/providers/Microsoft.Features/providers/Microsoft.Example/features/FeatureOne","name":"Microsoft.Other/FeatureOne","properties":{"state":"Registered"}}' }
        @{ response = '{"id":"/subscriptions/11111111-1111-4111-8111-111111111111/providers/Microsoft.Features/providers/Microsoft.Example/features/FeatureOne","name":"Microsoft.Example/FeatureOne","properties":{"state":1}}' }
        @{ response = '{"id":"/subscriptions/11111111-1111-4111-8111-111111111111/providers/Microsoft.Features/providers/Microsoft.Example/features/FeatureOne","name":"Microsoft.Example/FeatureOne","properties":{"state":""}}' }
    ) {
        $script:featureResponse = $response

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*Azure CLI returned*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 2 -Exactly
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
    ) {
        $script:providerResponse = $response

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*Azure CLI returned*'
    }

    It 'Preserves a failure from <command> and does not continue' -ForEach @(
        @{ command = 'account show'; message = 'Not authenticated' }
        @{ command = 'feature show'; message = 'FeatureNotFound: unsupported feature' }
        @{ command = 'feature register'; message = 'AuthorizationFailed: Microsoft.Features/register/action' }
        @{ command = 'provider register'; message = 'AuthorizationFailed: provider register/action' }
        @{ command = 'provider show'; message = 'Provider status lookup failed' }
    ) {
        $script:failureCommand = $command
        $script:failure = [System.InvalidOperationException]::new($message)

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw "*$message*"
        ($script:commands[-1].Arguments[0..1] -join ' ') | Should -Be $command
    }

    It 'Preserves cancellation and timeout failures from Azure commands' -ForEach @(
        @{ type = 'System.OperationCanceledException' }
        @{ type = 'System.TimeoutException' }
    ) {
        $script:failureCommand = 'feature register'
        $script:failure = [System.Activator]::CreateInstance(($type -as [type]), [object[]] @('Synthetic command interruption'))

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*Synthetic command interruption*'
        ($script:commands[-1].Arguments[0..1] -join ' ') | Should -Be 'feature register'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 0 -Exactly -ParameterFilter { $ArgumentList[0] -eq 'provider' }
    }

    It 'Stops immediately when waiting is cancelled' {
        $script:featureStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Registering'))
        Mock Start-Sleep { throw [System.OperationCanceledException]::new('Synthetic polling cancellation') }

        { Register-RequiredSubscriptionFeature @functionInput } | Should -Throw '*Synthetic polling cancellation*'
        Should -Invoke Invoke-RequiredFeatureAzCli -Times 3 -Exactly
        Should -Invoke Start-Sleep -Times 1 -Exactly
    }

    It 'Preserves pipeline cancellation during <phase> without continuing to provider registration' -ForEach @(
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
        'feature show' {
            return @{
                id = "/subscriptions/$($RegistrationInput.SubscriptionId)/providers/Microsoft.Features/providers/Microsoft.Example/features/FeatureOne"
                name = 'Microsoft.Example/FeatureOne'
                properties = @{ state = 'NotRegistered' }
            } | ConvertTo-Json -Compress
        }
        'feature register' {
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
$null = Register-RequiredSubscriptionFeature @RegistrationInput
$Trace.Add('returned')
'@).AddArgument((Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Register-RequiredSubscriptionFeature.ps1')).AddArgument($functionInput).AddArgument($trace).AddArgument($phase)
            $null = $pipeline.Invoke()

            $pipeline.InvocationStateInfo.State | Should -Be 'Stopped'
            $pipeline.InvocationStateInfo.Reason | Should -BeOfType [System.Management.Automation.PipelineStoppedException]
            $expected = @('account show', 'feature show', 'feature register')
            if ($phase -eq 'polling') { $expected += @('feature show', 'sleep') }
            @($trace) | Should -Be $expected
        } finally {
            $pipeline.Dispose()
        }
    }
}

Describe 'Required feature Azure CLI process boundary' {
    BeforeEach {
        $script:commandPath = Join-Path $TestDrive 'az.exe'
        $script:process = [pscustomobject]@{
            StartInfo      = $null
            Started        = $false
            HasExited      = $false
            ExitCode       = 0
            Timeout        = $false
            Cancel         = $false
            Killed         = $false
            KillTree       = $false
            Disposed       = $false
            StandardOutput = [System.IO.StringReader]::new('{"state":"synthetic"}')
            StandardError  = [System.IO.StringReader]::new('')
            Waits          = [System.Collections.Generic.List[int]]::new()
        }
        $script:process | Add-Member -MemberType ScriptMethod -Name Start -Value {
            $this.Started = $true
            return $true
        }
        $script:process | Add-Member -MemberType ScriptMethod -Name WaitForExit -Value {
            param ([int] $Milliseconds)
            $this.Waits.Add($Milliseconds)
            if (-not $this.Killed) {
                if ($this.Cancel) { throw [System.OperationCanceledException]::new('Synthetic native cancellation') }
                if ($this.Timeout) { return $false }
            }
            $this.HasExited = $true
            return $true
        }
        $script:process | Add-Member -MemberType ScriptMethod -Name Kill -Value {
            param ([bool] $EntireProcessTree)
            $this.Killed = $true
            $this.KillTree = $EntireProcessTree
            $this.HasExited = $true
        }
        $script:process | Add-Member -MemberType ScriptMethod -Name Dispose -Value { $this.Disposed = $true }
        Mock Get-Command { [pscustomobject]@{ Source = $script:commandPath } } -ParameterFilter { $Name -eq 'az' -and $CommandType -eq 'Application' }
        Mock New-Object { $script:process } -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
        $cliInput = @{
            RepoRootPath = $TestDrive
            ArgumentList = @('feature', 'register', '--namespace', 'Microsoft.Example', '--name', 'FeatureOne', '--subscription', '11111111-1111-4111-8111-111111111111', '--output', 'none', '--only-show-errors')
            Operation = 'register a synthetic feature'
            PermissionHint = 'Synthetic permission hint. '
        }
    }

    It 'Uses native argument tokens, captures output and enforces the command timeout' {
        Invoke-RequiredFeatureAzCli @cliInput | Should -Be '{"state":"synthetic"}'

        $script:process.StartInfo.FileName | Should -Be $script:commandPath
        @($script:process.StartInfo.ArgumentList) | Should -Be $cliInput.ArgumentList
        $script:process.StartInfo.WorkingDirectory | Should -Be $TestDrive
        $script:process.StartInfo.UseShellExecute | Should -BeFalse
        $script:process.StartInfo.RedirectStandardOutput | Should -BeTrue
        $script:process.StartInfo.RedirectStandardError | Should -BeTrue
        @($script:process.Waits) | Should -Be @(60000)
        $script:process.Killed | Should -BeFalse
        $script:process.Disposed | Should -BeTrue
    }

    It 'Includes the command failure and permission hint instead of returning success' {
        $script:process.ExitCode = 1
        $script:process.StandardError = [System.IO.StringReader]::new('AuthorizationFailed: synthetic denial')

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*exit code 1*Synthetic permission hint*AuthorizationFailed*'
        $script:process.Disposed | Should -BeTrue
    }

    It 'Uses native standard output diagnostics when standard error is empty' {
        $script:process.ExitCode = 2
        $script:process.StandardOutput = [System.IO.StringReader]::new('Synthetic stdout failure')

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*exit code 2*Synthetic stdout failure*'
    }

    It 'Kills only the timed-out process tree and disposes it' {
        $script:process.Timeout = $true

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*timed out after 60 seconds*register a synthetic feature*'
        @($script:process.Waits) | Should -Be @(60000, 5000)
        $script:process.Killed | Should -BeTrue
        $script:process.KillTree | Should -BeTrue
        $script:process.Disposed | Should -BeTrue
    }

    It 'Cleans up a cancelled native process without returning success' {
        $script:process.Cancel = $true

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*Synthetic native cancellation*'
        $script:process.Killed | Should -BeTrue
        $script:process.Disposed | Should -BeTrue
    }

    It 'Fails explicitly when the process cannot start' {
        $script:process | Add-Member -MemberType ScriptMethod -Name Start -Force -Value { return $false }

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*Azure CLI could not start*'
        $script:process.Killed | Should -BeFalse
        $script:process.Disposed | Should -BeTrue
    }

    It 'Rejects a missing Azure CLI before creating a process' {
        Mock Get-Command { throw [System.Management.Automation.CommandNotFoundException]::new('Synthetic missing az') } -ParameterFilter { $Name -eq 'az' -and $CommandType -eq 'Application' }

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*Azure CLI is required*'
        Should -Invoke New-Object -Times 0 -Exactly -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
    }

    It 'Uses Windows MSI Python rather than a command shell' -Skip:(-not $IsWindows) {
        $cliRoot = Join-Path $TestDrive 'msi'
        $null = New-Item -Path (Join-Path $cliRoot 'wbin') -ItemType Directory -Force
        $script:commandPath = Join-Path $cliRoot 'wbin' 'az.cmd'
        $pythonPath = Join-Path $cliRoot 'python.exe'
        Set-Content -LiteralPath $pythonPath -Value ''

        Invoke-RequiredFeatureAzCli @cliInput | Should -Be '{"state":"synthetic"}'

        $script:process.StartInfo.FileName | Should -Be $pythonPath
        @($script:process.StartInfo.ArgumentList) | Should -Be (@('-IBm', 'azure.cli') + $cliInput.ArgumentList)
        $script:process.StartInfo.Environment['AZ_INSTALLER'] | Should -Be 'MSI'
    }

    It 'Rejects an incomplete Windows CLI installation' -Skip:(-not $IsWindows) {
        $script:commandPath = Join-Path $TestDrive 'missing-msi' 'wbin' 'az.cmd'

        { Invoke-RequiredFeatureAzCli @cliInput } | Should -Throw '*Windows MSI Python executable was not found*'
        Should -Invoke New-Object -Times 0 -Exactly -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
    }
}
