Describe 'Synapse CMK activation state machine' -Tag 'CmkActivationRuntime' {
    BeforeEach {
        $script:clock = 0.0
        $script:responses = [System.Collections.Generic.Queue[object]]::new()
        $script:requests = [System.Collections.Generic.List[object]]::new()
        $script:sleeps = [System.Collections.Generic.List[int]]::new()
        $script:waitBudgets = [System.Collections.Generic.List[int]]::new()
        $script:job = $null
        Mock Get-SynapseCmkClock { $script:clock }
        Mock Invoke-AzRestMethod {
            if ($script:responses.Count -eq 0) { throw 'Unexpected extra Azure request.' }
            $script:current = $script:responses.Dequeue()
            if ($Method -cne $script:current.Method) { throw "Expected $($script:current.Method), got $Method." }
            $script:requests.Add(@{ Method = $Method; Path = $Path; Payload = $Payload; AsJob = $AsJob; Time = $script:clock })
            $script:job = [pscustomobject]@{ Id = 17; State = 'Completed' }
            if (-not $script:current.Completes) { $script:job.State = 'Running' }
            return $script:job
        }
        Mock Wait-Job {
            $script:waitBudgets.Add($Timeout)
            $script:clock += $script:current.ElapsedSeconds
            if ($script:current.Completes) { return $script:job }
        }
        Mock Receive-Job {
            if ($null -ne $script:current.Failure) { throw $script:current.Failure }
            return $script:current.Response
        }
        Mock Stop-Job { $script:job.State = 'Stopped' }
        Mock Remove-Job {}
        Mock Start-Sleep {
            $script:sleeps.Add($Milliseconds)
            $script:clock += $Milliseconds / 1000.0
        }
    }

    It 'Returns only a verified active key and performs no PUT or wait when already active' {
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true)
        $result = Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        $result.isActiveCMK | Should -BeTrue
        $result.keyResourceId | Should -BeExactly $keyResourceId
        $script:requests.Count | Should -Be 1
        $script:requests[0].Method | Should -BeExactly GET
        $script:requests[0].Path | Should -BeExactly "${keyResourceId}?api-version=2021-06-01"
        $script:requests[0].AsJob | Should -BeTrue
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Should -Invoke Remove-Job -Times 1 -Exactly
    }

    It 'Retries only the observed post-grant PUT failure and verifies activation with a fresh GET' {
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT (New-CmkErrorResponse)
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT (New-CmkKeyResponse)
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true)
        $result = Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        $result.isActiveCMK | Should -BeTrue
        ($script:requests.Method -join ',') | Should -BeExactly 'GET,PUT,GET,PUT,GET,GET'
        ($script:sleeps -join ',') | Should -BeExactly '5000,10000'
        foreach ($request in $script:requests) {
            $request.Path | Should -BeExactly "${keyResourceId}?api-version=2021-06-01"
            if ($request.Method -eq 'PUT') {
                $body = $request.Payload | ConvertFrom-Json -AsHashtable
                $body.properties.isActiveCMK | Should -BeTrue
                $body.properties.keyVaultUrl | Should -BeExactly $keyVaultUrl
                $body.properties.Keys.Count | Should -Be 2
            }
        }
    }

    It 'Does not repeat an accepted PUT while the GET activation boolean is still false' {
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT (New-CmkKeyResponse -Active $true)
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true)
        (Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl).isActiveCMK |
            Should -BeTrue
        @($script:requests | Where-Object Method -EQ PUT).Count | Should -Be 1
        ($script:sleeps -join ',') | Should -BeExactly '5000,10000'
    }

    It 'Preserves first activation and a sequential already-active IDEM invocation' {
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT (New-CmkKeyResponse)
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true)
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true)
        foreach ($iteration in @('init', 'idem')) {
            (Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl).isActiveCMK |
                Should -BeTrue -Because $iteration
        }
        ($script:requests.Method -join ',') | Should -BeExactly 'GET,PUT,GET,GET'
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Preserves activation and IDEM with response IDs missing the leading slash' -Tag 'CmkResponseId' {
        $responseId = $keyResourceId.Substring(1)
        Add-CmkResponse GET (New-CmkKeyResponse -Id $responseId)
        Add-CmkResponse PUT (New-CmkKeyResponse -Id $responseId)
        Add-CmkResponse GET (New-CmkKeyResponse -Id $responseId -Active $true)
        Add-CmkResponse GET (New-CmkKeyResponse -Id $responseId -Active $true)
        foreach ($iteration in @('init', 'idem')) {
            $result = Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
            $result.isActiveCMK | Should -BeTrue -Because $iteration
            $result.keyResourceId | Should -BeExactly $keyResourceId
        }
        ($script:requests.Method -join ',') | Should -BeExactly 'GET,PUT,GET,GET'
        foreach ($request in $script:requests) {
            $request.Path | Should -BeExactly "${keyResourceId}?api-version=2021-06-01"
        }
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Uses one deadline for failed PUTs, accepted PUTs, reads and readiness waits' {
        Add-CmkResponse GET (New-CmkKeyResponse) -ElapsedSeconds 1
        Add-CmkResponse PUT (New-CmkErrorResponse) -ElapsedSeconds 1
        Add-CmkResponse GET (New-CmkKeyResponse) -ElapsedSeconds 1
        Add-CmkResponse PUT (New-CmkKeyResponse) -ElapsedSeconds 1
        Add-CmkResponse GET (New-CmkKeyResponse) -ElapsedSeconds 1
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 12 } |
            Should -Throw '*deadline expired*'
        $script:clock | Should -Be 12
        $script:requests.Count | Should -Be 5
        ($script:waitBudgets -join ',') | Should -BeExactly '12,11,5,4,3'
        ($script:sleeps -join ',') | Should -BeExactly '5000,2000'
    }

    It 'Bounds permission retries and their backoff without extending the deadline' {
        foreach ($index in 1..6) {
            Add-CmkResponse GET (New-CmkKeyResponse)
            Add-CmkResponse PUT (New-CmkErrorResponse)
        }
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 100 } |
            Should -Throw '*deadline expired*'
        $script:clock | Should -Be 100
        ($script:sleeps -join ',') | Should -BeExactly '5000,10000,20000,30000,30000,5000'
        $script:requests.Count | Should -Be 12
    }

    It 'Rejects an active GET arriving at or after the deadline (<ElapsedSeconds>)' -ForEach @(
        @{ ElapsedSeconds = 10 }
        @{ ElapsedSeconds = 11 }
    ) {
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true) -ElapsedSeconds $ElapsedSeconds
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 10 } |
            Should -Throw '*deadline expired*'
        Should -Invoke Receive-Job -Times 0 -Exactly
        Should -Invoke Remove-Job -Times 1 -Exactly
        $script:requests.Count | Should -Be 1
    }

    It 'Accepts a correctly identified active GET strictly before the deadline' {
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true) -ElapsedSeconds 9.9
        (Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 10).isActiveCMK |
            Should -BeTrue
    }

    It 'Rejects an accepted PUT arriving at the deadline without starting a later GET' {
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT (New-CmkKeyResponse -Active $true) -ElapsedSeconds 10
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 10 } |
            Should -Throw '*deadline expired*'
        $script:requests.Count | Should -Be 2
    }

    It 'Stops and removes only its unfinished request job on timeout' {
        Add-CmkResponse GET $null -ElapsedSeconds 10 -Completes $false
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 10 } |
            Should -Throw '*deadline expired*'
        Should -Invoke Stop-Job -Times 1 -Exactly -ParameterFilter { $Id -eq 17 }
        Should -Invoke Remove-Job -Times 1 -Exactly -ParameterFilter { $Id -eq 17 }
        Should -Invoke Receive-Job -Times 0 -Exactly
    }

    It 'Preserves transport failures and caller cancellation without retrying (<FailureName>)' -ForEach @(
        @{ FailureName = 'transport'; Failure = [System.Net.Http.HttpRequestException]::new('transport failed') }
        @{ FailureName = 'caller cancellation'; Failure = [System.OperationCanceledException]::new('caller cancelled') }
        @{ FailureName = 'timeout'; Failure = [System.TimeoutException]::new('transport timed out') }
    ) {
        Add-CmkResponse GET $null -Failure $Failure
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw "*$($Failure.Message)*"
        $script:requests.Count | Should -Be 1
        Should -Invoke Remove-Job -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Never retries a GET error even when it contains the CMK permission code' {
        Add-CmkResponse GET (New-CmkErrorResponse)
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*GET returned HTTP 400*CustomerManagedKeyPermissionMissing*'
        $script:requests.Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Preserves non-retryable PUT status <StatusCode> even with a CMK permission payload' -ForEach @(
        @{ StatusCode = 401 }
        @{ StatusCode = 403 }
        @{ StatusCode = 404 }
        @{ StatusCode = 409 }
        @{ StatusCode = 429 }
        @{ StatusCode = 500 }
        @{ StatusCode = 202 }
    ) {
        $response = New-CmkErrorResponse -StatusCode $StatusCode
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT $response
        $caught = try {
            Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        } catch { $_ }
        $caught.FullyQualifiedErrorId | Should -Match '^SynapseCmkRequestFailed'
        [object]::ReferenceEquals($caught.TargetObject, $response) | Should -BeTrue
        $script:requests.Count | Should -Be 2
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Rejects a wrong key identity or URL on <Method> (<Mismatch>)' -ForEach @(
        @{ Method = 'GET'; Mismatch = 'resource ID' }
        @{ Method = 'GET'; Mismatch = 'key URL' }
        @{ Method = 'PUT'; Mismatch = 'resource ID' }
        @{ Method = 'PUT'; Mismatch = 'key URL' }
    ) {
        if ($Method -eq 'PUT') { Add-CmkResponse GET (New-CmkKeyResponse) }
        $response = if ($Mismatch -eq 'resource ID') {
            New-CmkKeyResponse -Active $true -Id "$keyResourceId-other"
        } else {
            New-CmkKeyResponse -Active $true -Url "$keyVaultUrl-other"
        }
        Add-CmkResponse $Method $response
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*does not match the expected resource ID, key URL and activation boolean*'
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Rejects a non-boolean activation value (<ValueName>)' -ForEach @(
        @{ ValueName = 'string true'; Value = 'true' }
        @{ ValueName = 'string false'; Value = 'false' }
        @{ ValueName = 'number'; Value = 1 }
        @{ ValueName = 'null'; Value = $null }
    ) {
        Add-CmkResponse GET (New-CmkKeyResponse -Active $Value)
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*activation boolean*'
        $script:requests.Count | Should -Be 1
    }

    It 'Fails malformed success responses rather than inferring activation (<Content>)' -ForEach @(
        @{ Content = '{bad' }
        @{ Content = '{}' }
        @{ Content = '[]' }
        @{ Content = 'null' }
    ) {
        Add-CmkResponse GET ([pscustomobject]@{ StatusCode = 200; Content = $Content })
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } | Should -Throw
        $script:requests.Count | Should -Be 1
    }

    It 'Preserves malformed error bodies without retrying (<Content>)' -ForEach @(
        @{ Content = '{bad' }
        @{ Content = '{}' }
        @{ Content = '[]' }
        @{ Content = '{"error":"CustomerManagedKeyPermissionMissing"}' }
        @{ Content = '{"error":{"code":"CustomerManagedKeyPermissionMissing"},"otherError":{"code":"AuthorizationFailed"}}' }
        @{ Content = '{"error":{"code":"CustomerManagedKeyPermissionMissing"},"count":1,"otherError":{"code":"AuthorizationFailed"}}' }
    ) {
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT ([pscustomobject]@{ StatusCode = 400; Content = $Content })
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*PUT returned HTTP 400*'
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Rejects success that becomes late while collecting or cleaning up the response (<Stage>)' -ForEach @(
        @{ Stage = 'receive' }
        @{ Stage = 'cleanup' }
    ) {
        Add-CmkResponse GET (New-CmkKeyResponse -Active $true)
        if ($Stage -eq 'receive') {
            Mock Receive-Job { $script:clock = 10; return $script:current.Response }
        } else {
            Mock Remove-Job { $script:clock = 10 }
        }
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl -TimeoutSeconds 10 } |
            Should -Throw '*deadline expired*'
        Should -Invoke Remove-Job -Times 1 -Exactly
        $script:requests.Count | Should -Be 1
    }

    It 'Rejects a missing or multiple request result (<Count>)' -ForEach @(
        @{ Count = 0 }
        @{ Count = 2 }
    ) {
        $response = if ($Count -eq 2) { @((New-CmkKeyResponse -Active $true), (New-CmkKeyResponse -Active $true)) }
        Add-CmkResponse GET $response
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*exactly one response*'
        Should -Invoke Remove-Job -Times 1 -Exactly
    }

    It 'Stops a request job that returns without completing' {
        Add-CmkResponse GET $null -Completes $false
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*request did not complete*'
        Should -Invoke Stop-Job -Times 1 -Exactly -ParameterFilter { $Id -eq 17 }
        Should -Invoke Remove-Job -Times 1 -Exactly -ParameterFilter { $Id -eq 17 }
        Should -Invoke Receive-Job -Times 0 -Exactly
    }

    It 'Rejects malformed target inputs before making a request (<InputName>)' -ForEach @(
        @{ InputName = 'resource ID'; Id = '/subscriptions/not-a-key'; Url = 'https://test-vault.vault.azure.net/keys/test-key' }
        @{ InputName = 'URL scheme'; Id = '/subscriptions/00000000-0000-4000-8000-000000000001/resourceGroups/test-rg/providers/Microsoft.Synapse/workspaces/test-workspace/keys/test-key'; Url = 'http://test-vault.vault.azure.net/keys/test-key' }
    ) {
        { Invoke-SynapseCmkActivation -KeyResourceId $Id -KeyVaultUrl $Url } | Should -Throw
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Refuses mixed errors without retrying or replacing the original error' {
        $mixed = @{
            code = 'ValidationFailed'
            details = @(
                @{ code = 'CustomerManagedKeyPermissionMissing' }
                @{ code = 'AuthorizationFailed'; message = 'Unrelated denied operation' }
            )
        }
        Add-CmkResponse GET (New-CmkKeyResponse)
        Add-CmkResponse PUT (New-CmkErrorResponse -ErrorDetail $mixed)
        { Invoke-SynapseCmkActivation -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl } |
            Should -Throw '*PUT returned HTTP 400*AuthorizationFailed*'
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }
}

Describe 'Synapse CMK permission classifier' -Tag 'CmkActivationRuntime' {
    It 'Accepts only the native permission family (<Name>)' -ForEach @(
        @{ Name = 'leaf'; Detail = @{ code = 'CustomerManagedKeyPermissionMissing' }; Expected = $true }
        @{ Name = 'validation wrapper'; Detail = @{ code = 'ValidationFailed'; details = @(@{ code = 'CustomerManagedKeyPermissionMissing' }) }; Expected = $true }
        @{ Name = 'nested validation'; Detail = @{ code = 'ValidationFailed'; details = @(@{ code = 'ValidationFailed'; details = @(@{ code = 'CustomerManagedKeyPermissionMissing' }) }) }; Expected = $true }
        @{ Name = 'authorization failure'; Detail = @{ code = 'AuthorizationFailed'; message = 'CustomerManagedKeyPermissionMissing' }; Expected = $false }
        @{ Name = 'unknown wrapper'; Detail = @{ code = 'DeploymentFailed'; details = @(@{ code = 'CustomerManagedKeyPermissionMissing' }) }; Expected = $false }
        @{ Name = 'missing details'; Detail = @{ code = 'ValidationFailed' }; Expected = $false }
        @{ Name = 'empty details'; Detail = @{ code = 'ValidationFailed'; details = @() }; Expected = $false }
        @{ Name = 'non-array details'; Detail = @{ code = 'ValidationFailed'; details = @{ code = 'CustomerManagedKeyPermissionMissing' } }; Expected = $false }
        @{ Name = 'unexpected inner error'; Detail = @{ code = 'CustomerManagedKeyPermissionMissing'; innererror = @{ code = 'Denied' } }; Expected = $false }
        @{ Name = 'unexpected additional info'; Detail = @{ code = 'CustomerManagedKeyPermissionMissing'; additionalInfo = @(@{ type = 'Error'; info = 'Denied' }) }; Expected = $false }
        @{ Name = 'permission leaf with another error'; Detail = @{ code = 'CustomerManagedKeyPermissionMissing'; details = @(@{ code = 'Denied' }) }; Expected = $false }
        @{ Name = 'unknown sibling'; Detail = @{ code = 'ValidationFailed'; details = @(@{ code = 'CustomerManagedKeyPermissionMissing' }, @{}) }; Expected = $false }
        @{ Name = 'similar code'; Detail = @{ code = 'CustomerManagedKeyPermissionMissingAgain' }; Expected = $false }
        @{ Name = 'array of codes'; Detail = @{ code = @('CustomerManagedKeyPermissionMissing', 'AuthorizationFailed') }; Expected = $false }
        @{ Name = 'non-string code'; Detail = @{ code = @{ code = 'CustomerManagedKeyPermissionMissing' } }; Expected = $false }
        @{ Name = 'unknown error field'; Detail = @{ code = 'CustomerManagedKeyPermissionMissing'; otherError = @{ code = 'Denied' } }; Expected = $false }
        @{ Name = 'masked dictionary keys'; Detail = @{ code = 'CustomerManagedKeyPermissionMissing'; keys = @('code'); otherError = @{ code = 'Denied' } }; Expected = $false }
        @{ Name = 'null'; Detail = $null; Expected = $false }
    ) {
        Test-SynapseCmkPermissionError -ErrorDetail $Detail | Should -Be $Expected
    }

    It 'Refuses excessively deep error trees' {
        $detail = @{ code = 'CustomerManagedKeyPermissionMissing' }
        foreach ($index in 1..18) { $detail = @{ code = 'ValidationFailed'; details = @($detail) } }
        Test-SynapseCmkPermissionError -ErrorDetail $detail | Should -BeFalse
    }
}
Describe 'Synapse CMK response contract diagnostics' -Tag 'CmkResponseDiagnostics' {
    It 'Accepts the documented key response shape with a Boolean activation value (<Active>)' -ForEach @(
        @{ Active = $true }
        @{ Active = $false }
    ) {
        $id = '/subscriptions/00000000-1111-2222-3333-444444444444/resourceGroups/ExampleResourceGroup/providers/Microsoft.Synapse/workspaces/ExampleWorkspace/keys/somekey'
        $url = 'https://vault.azure.net/keys/key1'
        $response = [pscustomobject]@{
            StatusCode = 200
            Content = @{
                id = $id
                name = 'somekey'
                type = 'Microsoft.Synapse/workspaces/keys'
                properties = @{ isActiveCMK = $Active; keyVaultUrl = $url }
            } | ConvertTo-Json -Compress
        }

        Test-SynapseCmkKeyActive -Response $response -KeyResourceId $id -KeyVaultUrl $url |
            Should -Be $Active
    }

    It 'Identifies the failing response field without exposing values (<Case>)' -ForEach @(
        @{ Case = 'missing ID'; Field = 'id'; Container = 'root'; Change = 'remove'; Present = $false; ValueType = 'missing' }
        @{ Case = 'null ID'; Field = 'id'; Container = 'root'; Change = 'null'; Present = $true; ValueType = 'null' }
        @{ Case = 'different ID'; Field = 'id'; Container = 'root'; Change = 'string'; Present = $true; ValueType = 'System.String' }
        @{ Case = 'missing properties'; Field = 'properties'; Container = 'root'; Change = 'remove'; Present = $false; ValueType = 'missing' }
        @{ Case = 'non-object properties'; Field = 'properties'; Container = 'root'; Change = 'string'; Present = $true; ValueType = 'System.String' }
        @{ Case = 'missing URL'; Field = 'keyVaultUrl'; Container = 'properties'; Change = 'remove'; Present = $false; ValueType = 'missing' }
        @{ Case = 'null URL'; Field = 'keyVaultUrl'; Container = 'properties'; Change = 'null'; Present = $true; ValueType = 'null' }
        @{ Case = 'different URL'; Field = 'keyVaultUrl'; Container = 'properties'; Change = 'string'; Present = $true; ValueType = 'System.String' }
        @{ Case = 'missing activation Boolean'; Field = 'isActiveCMK'; Container = 'properties'; Change = 'remove'; Present = $false; ValueType = 'missing' }
        @{ Case = 'null activation Boolean'; Field = 'isActiveCMK'; Container = 'properties'; Change = 'null'; Present = $true; ValueType = 'null' }
        @{ Case = 'string activation value'; Field = 'isActiveCMK'; Container = 'properties'; Change = 'string'; Present = $true; ValueType = 'System.String' }
    ) {
        $canary = 'response-value-must-not-be-logged'
        $body = @{
            id = $keyResourceId
            properties = @{ keyVaultUrl = $keyVaultUrl; isActiveCMK = $false }
            unrecognized = @{ token = $canary }
        }
        $target = if ($Container -eq 'root') { $body } else { $body.properties }
        switch ($Change) {
            'remove' { $target.Remove($Field) }
            'null' { $target[$Field] = $null }
            'string' { $target[$Field] = $canary }
        }
        $response = [pscustomobject]@{ StatusCode = 200; Content = $body | ConvertTo-Json -Depth 8 -Compress }
        $caught = try {
            Test-SynapseCmkKeyActive -Response $response -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        } catch { $_ }

        $caught | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $message = $caught.Exception.Message
        $message | Should -Match 'Validation diagnostics: '
        $diagnostics = ($message -split 'Validation diagnostics: ', 2)[1] | ConvertFrom-Json -AsHashtable
        $diagnostics[$Field].present | Should -Be $Present
        $diagnostics[$Field].type | Should -BeExactly $ValueType
        $diagnostics[$Field].valid | Should -BeFalse
        $message | Should -Not -Match ([regex]::Escape($canary))
        $message | Should -Not -Match ([regex]::Escape($keyResourceId))
        $message | Should -Not -Match ([regex]::Escape($keyVaultUrl))
    }

    It 'Identifies a non-object response without inferring a missing key (<Content>)' -ForEach @(
        @{ Content = 'null'; ValueType = 'null' }
        @{ Content = 'false'; ValueType = 'System.Boolean' }
    ) {
        $response = [pscustomobject]@{ StatusCode = 200; Content = $Content }
        $caught = try {
            Test-SynapseCmkKeyActive -Response $response -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        } catch { $_ }

        $caught.Exception.Message | Should -Match 'Validation diagnostics: '
        $diagnostics = ($caught.Exception.Message -split 'Validation diagnostics: ', 2)[1] |
            ConvertFrom-Json -AsHashtable
        $diagnostics.responseIsObject | Should -BeFalse
        $diagnostics.responseType | Should -BeExactly $ValueType
    }

    It 'Reports simultaneous identity and URL mismatches without dumping the response' {
        $body = @{
            id = 'private-identity-canary'
            properties = @{ keyVaultUrl = 'private-url-canary'; isActiveCMK = $false }
            unrecognized = 'private-body-canary'
        }
        $response = [pscustomobject]@{ StatusCode = 200; Content = $body | ConvertTo-Json -Compress }
        $caught = try {
            Test-SynapseCmkKeyActive -Response $response -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        } catch { $_ }

        $caught.Exception.Message | Should -Match 'Validation diagnostics: '
        $diagnostics = ($caught.Exception.Message -split 'Validation diagnostics: ', 2)[1] |
            ConvertFrom-Json -AsHashtable
        $diagnostics.id.valid | Should -BeFalse
        $diagnostics.keyVaultUrl.valid | Should -BeFalse
        $diagnostics.isActiveCMK.valid | Should -BeTrue
        $caught.Exception.Message | Should -Not -Match 'private-.*-canary'
    }
}

Describe 'Synapse CMK response ID representation' -Tag 'CmkResponseId' {
    It 'Accepts the captured missing-leading-slash shape (<Active>, <UpperCase>)' -ForEach @(
        @{ Active = $false; UpperCase = $false }
        @{ Active = $true; UpperCase = $false }
        @{ Active = $false; UpperCase = $true }
        @{ Active = $true; UpperCase = $true }
    ) {
        $responseId = $keyResourceId.Substring(1)
        if ($UpperCase) { $responseId = $responseId.ToUpperInvariant() }
        $response = [pscustomobject]@{
            StatusCode = 200
            Content = @{
                id = $responseId
                name = $keyResourceId.Split('/')[-1]
                type = 'Microsoft.Synapse/workspaces/keys'
                properties = @{ keyVaultUrl = $keyVaultUrl; isActiveCMK = $Active }
            } | ConvertTo-Json -Compress
        }

        $result = Test-SynapseCmkKeyActive -Response $response -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        $result | Should -BeOfType ([bool])
        $result | Should -Be $Active
    }

    It 'Rejects ID differences beyond one omitted leading slash (<Case>)' -ForEach @(
        @{ Case = 'extra leading slash' }
        @{ Case = 'leading space' }
        @{ Case = 'trailing space' }
        @{ Case = 'leading space without slash' }
        @{ Case = 'leading tab without slash' }
        @{ Case = 'trailing newline without slash' }
        @{ Case = 'relative dot prefix' }
        @{ Case = 'relative parent prefix' }
        @{ Case = 'encoded leading slash' }
        @{ Case = 'encoded delimiter' }
        @{ Case = 'encoded key name' }
        @{ Case = 'opaque key name' }
        @{ Case = 'changed subscription' }
        @{ Case = 'changed resource group' }
        @{ Case = 'changed provider' }
        @{ Case = 'changed workspace' }
        @{ Case = 'changed key' }
        @{ Case = 'trailing slash' }
        @{ Case = 'appended segment' }
        @{ Case = 'absolute URL' }
    ) {
        $withoutSlash = $keyResourceId.Substring(1)
        $responseId = switch ($Case) {
            'extra leading slash' { "/$keyResourceId" }
            'leading space' { " $keyResourceId" }
            'trailing space' { "$keyResourceId " }
            'leading space without slash' { " $withoutSlash" }
            'leading tab without slash' { "`t$withoutSlash" }
            'trailing newline without slash' { "$withoutSlash`n" }
            'relative dot prefix' { "./$withoutSlash" }
            'relative parent prefix' { "../$withoutSlash" }
            'encoded leading slash' { "%2F$withoutSlash" }
            'encoded delimiter' { $withoutSlash.Replace('/resourceGroups/', '%2FresourceGroups%2F') }
            'encoded key name' { $withoutSlash -replace '/keys/[^/]+$', '/keys/test%2Dkey' }
            'opaque key name' { $keyResourceId.Split('/')[-1] }
            'changed subscription' { $withoutSlash -replace '^subscriptions/[^/]+/', 'subscriptions/00000000-0000-4000-8000-000000000002/' }
            'changed resource group' { $withoutSlash -replace '/resourceGroups/[^/]+/', '/resourceGroups/other-rg/' }
            'changed provider' { $withoutSlash.Replace('/providers/Microsoft.Synapse/', '/providers/Microsoft.Other/') }
            'changed workspace' { $withoutSlash -replace '/workspaces/[^/]+/', '/workspaces/other-workspace/' }
            'changed key' { $withoutSlash -replace '/keys/[^/]+$', '/keys/other-key' }
            'trailing slash' { "$withoutSlash/" }
            'appended segment' { "$keyResourceId/child" }
            'absolute URL' { "https://management.azure.com$keyResourceId" }
        }
        $response = New-CmkKeyResponse -Id $responseId -Active $true
        $caught = try {
            Test-SynapseCmkKeyActive -Response $response -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        } catch { $_ }

        $caught | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $diagnostics = ($caught.Exception.Message -split 'Validation diagnostics: ', 2)[1] |
            ConvertFrom-Json -AsHashtable
        $diagnostics.id.valid | Should -BeFalse
        $diagnostics.keyVaultUrl.valid | Should -BeTrue
        $diagnostics.isActiveCMK.valid | Should -BeTrue
    }

    It 'Reports an equivalent ID as valid when another field fails (<Field>)' -ForEach @(
        @{ Field = 'keyVaultUrl' }
        @{ Field = 'isActiveCMK' }
    ) {
        $response = New-CmkKeyResponse -Id $keyResourceId.Substring(1)
        $body = $response.Content | ConvertFrom-Json -AsHashtable
        if ($Field -eq 'keyVaultUrl') {
            $body.properties.keyVaultUrl = "$keyVaultUrl/"
        } else {
            $body.properties.isActiveCMK = 'false'
        }
        $response.Content = $body | ConvertTo-Json -Compress
        $caught = try {
            Test-SynapseCmkKeyActive -Response $response -KeyResourceId $keyResourceId -KeyVaultUrl $keyVaultUrl
        } catch { $_ }

        $caught | Should -BeOfType ([System.Management.Automation.ErrorRecord])
        $diagnostics = ($caught.Exception.Message -split 'Validation diagnostics: ', 2)[1] |
            ConvertFrom-Json -AsHashtable
        $diagnostics.id.valid | Should -BeTrue
        $diagnostics[$Field].valid | Should -BeFalse
    }
}

Describe 'Synapse CMK activation template' -Tag 'CmkActivationTemplate' {
    BeforeAll {
        $moduleRoot = Join-Path $PSScriptRoot '..' '..'
        $compiledPath = Join-Path $TestDrive 'workspace.json'
        $diagnostics = bicep build (Join-Path $moduleRoot 'main.bicep') --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = @(Get-CmkTemplateResources $template)
        $activation = @($resources | Where-Object { $_.name -match '-cmk-activation' })[0]
        $activationResources = @(Get-CmkTemplateResources $activation.properties.template)
        $script = @($activationResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
        $identities = @($activationResources | Where-Object type -EQ 'Microsoft.ManagedIdentity/userAssignedIdentities')
        $assignments = @($activationResources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments')
        $scriptSource = $activation.properties.template.variables.Values -join "`n"
    }

    It 'Uses an opt-in bounded activation script after the existing workspace grant' {
        $template.parameters.encryptionActivateWorkspace.defaultValue | Should -BeFalse
        $activation.condition | Should -BeExactly "[parameters('encryptionActivateWorkspace')]"
        $activation.dependsOn | Should -Contain 'workspace_cmk_rbac'
        $script.Count | Should -Be 1
        $script[0].kind | Should -BeExactly 'AzurePowerShell'
        $script[0].properties.timeout | Should -BeExactly 'PT15M'
        $script[0].properties.cleanupPreference | Should -BeExactly 'Always'
        $script[0].properties.scriptContent | Should -Match "variables\('activationCommand'\)"
        $scriptSource | Should -Match 'function Invoke-SynapseCmkActivation'
        $scriptSource | Should -Not -Match 'Get-AzAccessToken|Connect-AzAccount'
    }

    It 'Embeds the actual helper and invokes its entry point with only the expected key metadata' {
        $embedded = $activation.properties.template.variables['$fxv#0']
        $expected = Get-Content -LiteralPath (Join-Path $moduleRoot 'modules' 'Invoke-SynapseCmkActivation.ps1') -Raw
        $embedded.Replace("`r`n", "`n") | Should -BeExactly $expected.Replace("`r`n", "`n")
        $script[0].properties.scriptContent | Should -BeExactly "[format('{0}`n{1}', variables('`$fxv#0'), variables('activationCommand'))]"
        $entry = $activation.properties.template.variables.activationCommand
        $expectedResourceId = $keyResourceId
        $expectedKeyUrl = $keyVaultUrl
        $oldId = $env:WORKSPACE_KEY_RESOURCE_ID
        $oldUrl = $env:KEY_VAULT_URL
        try {
            $env:WORKSPACE_KEY_RESOURCE_ID = $keyResourceId
            $env:KEY_VAULT_URL = $keyVaultUrl
            Mock Invoke-SynapseCmkActivation { @{ keyResourceId = $KeyResourceId; isActiveCMK = $true } }
            . ([scriptblock]::Create($entry))
            $DeploymentScriptOutputs.isActiveCMK | Should -BeTrue
            Should -Invoke Invoke-SynapseCmkActivation -Times 1 -Exactly -ParameterFilter {
                $KeyResourceId -ceq $expectedResourceId -and $KeyVaultUrl -ceq $expectedKeyUrl
            }
        } finally {
            $env:WORKSPACE_KEY_RESOURCE_ID = $oldId
            $env:KEY_VAULT_URL = $oldUrl
        }
    }

    It 'Waits for activation before dependent Synapse children and the workspace lock' {
        foreach ($symbol in @('synapse_integrationRuntimes', 'workspace_administrator', 'workspace_firewallRules',
                'workspace_bigDataPools', 'workspace_sqlPools', 'workspace_lock')) {
            $template.resources[$symbol].dependsOn | Should -Contain 'workspace_key' -Because $symbol
        }
    }

    It 'Grants only the new helper identity Contributor on the existing workspace key' {
        $identities.Count | Should -Be 1
        $assignments.Count | Should -Be 1
        $assignments[0].scope | Should -Match "Microsoft.Synapse/workspaces/keys"
        $assignments[0].properties.roleDefinitionId | Should -Match 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        $assignments[0].properties.principalType | Should -BeExactly 'ServicePrincipal'
        $assignments[0].properties.principalId | Should -Match 'activationIdentity|Microsoft.ManagedIdentity/userAssignedIdentities'
        @($activationResources | Where-Object { $_.type -like 'Microsoft.KeyVault/*' -and -not $_.existing }).Count |
            Should -Be 0
        @($activationResources | Where-Object { $_.type -eq 'Microsoft.Synapse/workspaces/keys' -and -not $_.existing }).Count |
            Should -Be 0
        $script[0].identity.type | Should -BeExactly 'UserAssigned'
        ($script[0].dependsOn -join ' ') | Should -Match 'activationRoleAssignment|Microsoft.Authorization/roleAssignments'
    }

    It 'Keeps helper names stable while checking activation again on each deployment' {
        $identities[0].name | Should -Match 'uniqueString'
        $script[0].name | Should -Match 'uniqueString'
        $identities[0].name | Should -Not -Match 'utcNow|deployment\(\)'
        $script[0].name | Should -Not -Match 'utcNow|deployment\(\)'
        $activation.properties.template.parameters.forceUpdateTag.defaultValue | Should -BeExactly '[utcNow()]'
        $script[0].properties.forceUpdateTag | Should -BeExactly "[parameters('forceUpdateTag')]"
    }

    It 'Preserves the workspace system identity, vault Crypto User grant and serial first-deployment coverage' {
        $template.variables.identity.type | Should -Match 'SystemAssigned'
        $grant = @($resources | Where-Object { $_.name -match '-cmk-rbac' })[0]
        $grant.properties.parameters.workspaceIndentityPrincipalId.value | Should -Match 'workspace.*identity.principalId'
        $grantResources = @(Get-CmkTemplateResources $grant.properties.template)
        $cryptoUser = @($grantResources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments')[0]
        $cryptoUser.properties.roleDefinitionId | Should -Match '12338af0-0e69-4776-bea7-57ae8d297424'

        $fixturePath = Join-Path $TestDrive 'encrwsai.json'
        $diagnostics = bicep build (Join-Path $moduleRoot 'tests' 'e2e' 'encrwsai' 'main.test.bicep') --no-restore --outfile $fixturePath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $fixture = Get-Content -LiteralPath $fixturePath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $testDeployment = @(Get-CmkTemplateResources $fixture | Where-Object { $_.name -match '-test-' })[0]
        $testDeployment.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testDeployment.copy.mode | Should -BeExactly 'serial'
        $testDeployment.copy.batchSize | Should -Be 1
        $testDeployment.properties.parameters.encryptionActivateWorkspace.value | Should -BeTrue
        $testDeployment.properties.parameters.customerManagedKey.value.ContainsKey('userAssignedIdentityResourceId') |
            Should -BeFalse
    }
}
BeforeAll {
    . (Join-Path $PSScriptRoot '..' '..' 'modules' 'Invoke-SynapseCmkActivation.ps1')

    function Get-CmkTemplateResources {
        param([object] $Template)
        if ($Template.resources -is [System.Collections.IDictionary]) {
            return @($Template.resources.Values)
        }
        return @($Template.resources)
    }

    function Invoke-AzRestMethod {
        [CmdletBinding(SupportsShouldProcess)]
        param([string] $Method, [string] $Path, [string] $Payload, [switch] $AsJob)
        throw 'Live Azure requests are disabled in these unit tests.'
    }

    $keyResourceId = '/subscriptions/00000000-0000-4000-8000-000000000001/resourceGroups/test-rg/providers/Microsoft.Synapse/workspaces/test-workspace/keys/test-key'
    $keyVaultUrl = 'https://test-vault.vault.azure.net/keys/test-key'

    function New-CmkKeyResponse {
        param (
            [object] $Active = $false,
            [string] $Id = $keyResourceId,
            [string] $Url = $keyVaultUrl
        )
        [pscustomobject]@{
            StatusCode = 200
            Content = @{ id = $Id; properties = @{ isActiveCMK = $Active; keyVaultUrl = $Url } } |
                ConvertTo-Json -Compress
        }
    }

    function New-CmkErrorResponse {
        param (
            [int] $StatusCode = 400,
            [object] $ErrorDetail = @{
                code = 'ValidationFailed'
                details = @(@{ code = 'CustomerManagedKeyPermissionMissing'; message = "Could not perform a 'Get' operation." })
            }
        )
        [pscustomobject]@{
            StatusCode = $StatusCode
            Content = @{ error = $ErrorDetail } | ConvertTo-Json -Depth 32 -Compress
        }
    }

    function Add-CmkResponse {
        param (
            [string] $Method,
            [object] $Response,
            [double] $ElapsedSeconds = 0,
            [bool] $Completes = $true,
            [object] $Failure
        )
        $script:responses.Enqueue([pscustomobject]@{
                Method = $Method
                Response = $Response
                ElapsedSeconds = $ElapsedSeconds
                Completes = $Completes
                Failure = $Failure
            })
    }
}
