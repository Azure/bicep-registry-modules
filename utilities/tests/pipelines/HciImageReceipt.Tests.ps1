param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'HCI confidential JSON parsing' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'HciImageOperation.ps1')
    }

    It 'Preserves the exact timestamp string <timestamp> at every depth' -ForEach @(
        @{ timestamp = '2026-10-15T13:26:36.1234567Z' }
        @{ timestamp = '2026-10-15T13:26:36.1234567+00:00' }
        @{ timestamp = '2026-10-15T13:26:36.1234567+05:45' }
        @{ timestamp = '2026-10-15T13:26:36.1234567-07:30' }
        @{ timestamp = '2026-10-15T13:26:36' }
        @{ timestamp = '2026-10-15' }
    ) {
        $json = [ordered] @{
            deadline = $timestamp
            binding = [ordered] @{ deadline = $timestamp; records = @([ordered] @{ deadline = $timestamp }) }
            timestamps = @($timestamp)
        } | ConvertTo-Json -Depth 10 -Compress
        $private = ConvertTo-HciPrivateValue -Value $json
        try {
            $record = ConvertFrom-HciPrivateJson -Value $private

            foreach ($value in @($record.deadline, $record.binding.deadline, $record.binding.records[0].deadline, $record.timestamps[0])) {
                $value | Should -BeOfType [string]
                $value | Should -BeExactly $timestamp
            }
            ($record | ConvertTo-Json -Depth 10 -Compress) | Should -BeExactly $json
        } finally {
            $private.Dispose()
        }
    }

    It 'Preserves ordered case-sensitive keys, scalar types, metadata and nested array shapes' {
        $private = ConvertTo-HciPrivateValue '{"Name":"first","name":"second","":null,"items":[[],[1],null,{"number":2,"enabled":false}],"count":3,"ratio":1.5,"big":9223372036854775808,"enabled":true,"$type":"private-sentinel"}'
        try {
            $record = ConvertFrom-HciPrivateJson -Value $private

            $record | Should -BeOfType [System.Management.Automation.OrderedHashtable]
            @($record.Keys) | Should -Be @('Name', 'name', '', 'items', 'count', 'ratio', 'big', 'enabled', '$type')
            $record['Name'] | Should -BeExactly 'first'
            $record['name'] | Should -BeExactly 'second'
            ($null -eq $record['']) | Should -BeTrue
            $record.items.GetType().FullName | Should -Be 'System.Object[]'
            $record.items.Count | Should -Be 4
            $record.items[0].GetType().FullName | Should -Be 'System.Object[]'
            $record.items[0].Count | Should -Be 0
            $record.items[1].GetType().FullName | Should -Be 'System.Object[]'
            $record.items[1].Count | Should -Be 1
            $record.items[1][0] | Should -Be 1
            ($null -eq $record.items[2]) | Should -BeTrue
            $record.items[3].number | Should -Be 2
            $record.items[3].enabled | Should -BeFalse
            $record['count'] | Should -BeOfType [long]
            $record.ratio | Should -BeOfType [double]
            $record.big | Should -BeOfType [System.Numerics.BigInteger]
            $record.enabled | Should -BeOfType [bool]
            $record['$type'] | Should -BeExactly 'private-sentinel'
        } finally {
            $private.Dispose()
        }
    }

    It 'Rejects <label> without exposing confidential JSON' -ForEach @(
        @{ label = 'an empty value'; json = '' }
        @{ label = 'malformed JSON'; json = '{"value":"private-sentinel"' }
        @{ label = 'a single-object array'; json = '[{"value":"private-sentinel"}]' }
        @{ label = 'a string array'; json = '["private-sentinel"]' }
        @{ label = 'a string scalar'; json = '"private-sentinel"' }
        @{ label = 'null'; json = 'null' }
        @{ label = 'trailing JSON'; json = '{"value":"private-sentinel"}{"other":1}' }
    ) {
        $private = ConvertTo-HciPrivateValue -Value $json
        try {
            $failure = { ConvertFrom-HciPrivateJson -Value $private } |
                Should -Throw 'The confidential HCI receipt is not a valid JSON object.' -PassThru

            $failure.Exception.Message | Should -BeExactly 'The confidential HCI receipt is not a valid JSON object.'
            $failure.ToString() | Should -Not -Match 'private-sentinel'
        } finally {
            $private.Dispose()
        }
    }
}

Describe 'HCI confidential receipt HTTP transport' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'HciTestEnvironment.ps1')
        function Get-AzAccessToken { param ($ResourceUrl, [switch] $AsSecureString) }
        if (-not ('HciReceiptTestHandler' -as [type])) {
            Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
public sealed class HciReceiptTestHandler : HttpMessageHandler {
    public readonly Queue<HttpResponseMessage> Responses = new Queue<HttpResponseMessage>();
    public readonly List<Dictionary<string, string>> Requests = new List<Dictionary<string, string>>();
    public bool Fail;
    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) {
        var record = new Dictionary<string, string>();
        record["Method"] = request.Method.Method;
        record["Uri"] = request.RequestUri.OriginalString;
        record["PathAndQuery"] = request.RequestUri.PathAndQuery;
        foreach (var header in request.Headers) record[header.Key] = string.Join(",", header.Value);
        if (request.Content != null) record["Body"] = request.Content.ReadAsStringAsync().GetAwaiter().GetResult();
        Requests.Add(record);
        if (Fail) throw new HttpRequestException("private-sentinel transport failure");
        if (Responses.Count == 0) throw new InvalidOperationException("Unexpected request; no live network is permitted.");
        return Task.FromResult(Responses.Dequeue());
    }
}
'@
        }
        function Add-HttpResponse([int] $Status = 200, [string] $Content = '{}', [hashtable] $Headers = @{}) {
            $response = [Net.Http.HttpResponseMessage]::new([Net.HttpStatusCode] $Status)
            $response.Content = [Net.Http.StringContent]::new($Content)
            foreach ($entry in $Headers.GetEnumerator()) {
                $null = $response.Headers.TryAddWithoutValidation($entry.Key, [string[]] $entry.Value)
            }
            $script:handler.Responses.Enqueue($response)
        }
    }

    BeforeEach {
        $script:handler = [HciReceiptTestHandler]::new()
        Mock New-HciHttpClient { [Net.Http.HttpClient]::new($script:handler, $false) }
        $script:claims = @{
            tid = '22222222-2222-2222-2222-222222222222'
            oid = '33333333-3333-3333-3333-333333333333'
            appid = '44444444-4444-4444-4444-444444444444'
        }
        Mock Get-AzAccessToken {
            $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($script:claims | ConvertTo-Json -Compress))).TrimEnd('=').Replace('+', '-').Replace('/', '_')
            @{ Token = ConvertTo-SecureString "test.$encoded.signature" -AsPlainText -Force }
        }
        $store = @{
            Endpoint = 'https://sthcircpabcdefghijklm.blob.core.windows.net/hci-operation-receipts'
            Key = 'a' * 64
            TenantId = $script:claims.tid
            ClientId = $script:claims.appid
            PrincipalId = $script:claims.oid
        }
        $operationUrl = 'https://management.azure.com/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.VirtualMachineImages/locations/australiaeast/operations/55555555-5555-5555-5555-555555555555?api-version=2025-10-01'
    }

    AfterEach {
        $script:handler.Dispose()
    }

    It 'Uses Entra authentication and exact conditional create, replace and read requests' {
        Add-HttpResponse 201 '{}' @{ ETag = '"0xABC1"' }
        Add-HttpResponse 201 '{}' @{ ETag = '"0xABC2"' }
        Add-HttpResponse 200 '{"state":"Accepted","value":"private-sentinel"}' @{ ETag = '"0xABC2"' }
        $body = ConvertTo-SecureString '{"value":"private-sentinel"}' -AsPlainText -Force

        $created = Invoke-HciImageReceiptRequest -Store $store -Operation Create -Body $body
        $replaced = Invoke-HciImageReceiptRequest -Store $store -Operation Replace -ETag $created.ETag -Body $body
        $read = Invoke-HciImageReceiptRequest -Store $store -Operation Read -ETag $replaced.ETag

        $script:handler.Requests.Count | Should -Be 3
        $script:handler.Requests[0]['If-None-Match'] | Should -Be '*'
        $script:handler.Requests[1]['If-Match'] | Should -BeExactly '"0xABC1"'
        $script:handler.Requests[2]['If-Match'] | Should -BeExactly '"0xABC2"'
        foreach ($request in $script:handler.Requests) {
            $request.Uri | Should -BeExactly "$($store.Endpoint)/runs/$($store.Key).json"
            $request.Authorization | Should -BeLike 'Bearer *'
            $request.Uri | Should -Not -Match '\?|sig=|AccountKey'
            $request.Authorization.StartsWith('Bearer ', [StringComparison]::Ordinal) | Should -BeTrue
        }
        $read.Body | Should -BeOfType [securestring]
        ($created, $replaced, $read | Out-String) | Should -Not -Match 'private-sentinel'
        Should -Invoke Get-AzAccessToken -Times 3 -Exactly -ParameterFilter { $ResourceUrl -ceq 'https://storage.azure.com/' -and $AsSecureString }
    }

    It 'Never retries or leaks private response content for HTTP <status>' -ForEach @(
        @{ status = 302 }, @{ status = 403 }, @{ status = 409 }, @{ status = 412 }, @{ status = 500 }
    ) {
        Add-HttpResponse $status '{"private":"private-sentinel"}' @{ Location = 'https://other.test/private-sentinel' }
        $body = ConvertTo-SecureString '{"value":"private-sentinel"}' -AsPlainText -Force

        $errorRecord = { Invoke-HciImageReceiptRequest -Store $store -Operation Create -Body $body } |
            Should -Throw '*environment remains blocked*' -PassThru

        $script:handler.Requests.Count | Should -Be 1
        $errorRecord.ToString() | Should -Not -Match 'private-sentinel|other.test'
    }

    It 'Rejects a different <claim> identity before any data-plane request' -ForEach @(
        @{ claim = 'tid' }, @{ claim = 'oid' }, @{ claim = 'appid' }
    ) {
        $script:claims[$claim] = '99999999-9999-9999-9999-999999999999'
        { Invoke-HciImageReceiptRequest -Store $store -Operation Read -ETag '"0xABC1"' } | Should -Throw '*unconfirmed*'
        $script:handler.Requests.Count | Should -Be 0
    }

    It 'Rejects changed or missing readback ETags' -ForEach @(
        @{ header = @{} }, @{ header = @{ ETag = '"0xABC3"' } }
    ) {
        Add-HttpResponse 200 '{"value":"private-sentinel"}' $header
        { Invoke-HciImageReceiptRequest -Store $store -Operation Read -ETag '"0xABC1"' } | Should -Throw '*environment remains blocked*'
        $script:handler.Requests.Count | Should -Be 1
    }

    It 'Preserves full signed operation headers and a 4KB URI without returning plaintext values' {
        $signed = "$operationUrl&t=t&c=$('a' * 4300)%2f%2B%3D+%7e&s=private-sentinel&h=h"
        Add-HttpResponse 202 '{}' @{
            'Azure-AsyncOperation' = $signed
            Location = $signed.Replace('private-sentinel', 'other-private-sentinel')
            'Retry-After' = '37'
        }
        $result = Invoke-HciImageOperationRequest -Method POST -Uri (ConvertTo-SecureString "$operationUrl/run" -AsPlainText -Force)
        $result['Azure-AsyncOperation'] | Should -BeOfType [securestring]
        $result.Location | Should -BeOfType [securestring]
        $result.RetryAfterSeconds | Should -Be 37
        ($result | Out-String) | Should -Not -Match 'private-sentinel'
        $id = Get-HciImageOperationIdentity -OperationUri $result['Azure-AsyncOperation'] `
            -SubscriptionId '11111111-1111-1111-1111-111111111111' -Location australiaeast
        $id | Should -Be '55555555-5555-5555-5555-555555555555'
        Add-HttpResponse 200 '{"status":"Succeeded"}'
        $null = Invoke-HciImageOperationRequest -Method GET -Uri $result['Azure-AsyncOperation']
        $script:handler.Requests[1].Uri | Should -BeExactly $signed
        $script:handler.Requests[1].PathAndQuery | Should -BeExactly $signed.Substring('https://management.azure.com'.Length)
    }

    It 'Stops on duplicate operation headers without leaking them or retrying POST' {
        Add-HttpResponse 202 '{}' @{ 'Azure-AsyncOperation' = @("$operationUrl&s=private-sentinel", $operationUrl) }
        $errorRecord = { Invoke-HciImageOperationRequest -Method POST -Uri (ConvertTo-SecureString $operationUrl -AsPlainText -Force) } |
            Should -Throw '*no automatic retry*' -PassThru
        $errorRecord.ToString() | Should -Not -Match 'private-sentinel'
        $script:handler.Requests.Count | Should -Be 1
    }

    It 'Sanitizes an ambiguous transport failure without retrying' {
        $script:handler.Fail = $true
        $errorRecord = { Invoke-HciImageOperationRequest -Method POST -Uri (ConvertTo-SecureString "$operationUrl&s=private-sentinel" -AsPlainText -Force) } |
            Should -Throw '*do not resubmit*' -PassThru
        $errorRecord.ToString() | Should -Not -Match 'private-sentinel'
        $script:handler.Requests.Count | Should -Be 1
    }

    It 'Rejects a malformed Retry-After header without falling back to an earlier poll' {
        Add-HttpResponse 202 '{}' @{ 'Azure-AsyncOperation' = $operationUrl; 'Retry-After' = 'not-a-time' }
        { Invoke-HciImageOperationRequest -Method POST -Uri (ConvertTo-SecureString $operationUrl -AsPlainText -Force) } |
            Should -Throw '*no automatic retry*'
        $script:handler.Requests.Count | Should -Be 1
    }

    It 'Retains an empty synchronous response body as an empty confidential value' {
        Add-HttpResponse 204 ''
        $result = Invoke-HciImageOperationRequest -Method POST -Uri (ConvertTo-SecureString $operationUrl -AsPlainText -Force)
        $result.StatusCode | Should -Be 204
        $result.Body | Should -BeOfType [securestring]
        $result.Body.Length | Should -Be 0
    }

    It 'Rejects unsupported or duplicate query <query> without exposing values' -ForEach @(
        @{ query = '&api-version=2025-10-01' }
        @{ query = '&t=t' }
        @{ query = '&t=t&c=c&s=s&h=h&t=t' }
        @{ query = '&t=t&c=c&s=s&other=h' }
        @{ query = '&t=t&c=c&s=&h=h' }
        @{ query = '?api-version=2025-10-01' }
    ) {
        { Get-HciImageOperationIdentity -OperationUri (ConvertTo-SecureString "$operationUrl$query" -AsPlainText -Force) `
                -SubscriptionId '11111111-1111-1111-1111-111111111111' -Location australiaeast } |
            Should -Throw '*outside the supported endpoint*'
        $script:handler.Requests.Count | Should -Be 0
    }
}

Describe 'HCI immutable private receipt references' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'HciTestEnvironment.ps1')
    }

    BeforeEach {
        $store = @{
            Key = 'a' * 64
            Binding = [ordered] @{
                owner = 'owner'
                generation = 'b' * 32
                runIdentity = 'offline/repository|123|1'
                sourceCommit = 'c' * 40
                storeResourceId = '/test/container'
                imageTemplateResourceId = '/test/template'
                imageVersionResourceId = '/test/version'
                deadline = '2026-10-01T19:00:00.0000000+00:00'
            }
        }
        $script:record = @{
            binding = $store.Binding
            state = 'Accepted'
            operation = @{
                operationId = '55555555-5555-5555-5555-555555555555'
                observedRunStartTime = '2026-10-01T10:00:00.0000000+00:00'
                previousRunStartTime = '2026-09-30T10:00:00.0000000+00:00'
                operationUri = 'https://management.azure.com/private-sentinel'
            }
        } | ConvertTo-Json -Depth 10 -Compress
        $tags = @{
            'avm-image-receipt' = $store.Key
            'avm-image-etag' = '"0xABC2"'
            'avm-image-hash' = Get-HciEnvironmentKey -Value $script:record
            'avm-image-operation' = '55555555-5555-5555-5555-555555555555'
            'avm-image-start' = '2026-10-01T10:00:00.0000000+00:00'
            'avm-image-previous' = '2026-09-30T10:00:00.0000000+00:00'
        }
        Mock Invoke-HciImageReceiptRequest {
            if ($Operation -cne 'Read' -or $ETag -cne '"0xABC2"') { throw 'Exact offline ETag is required.' }
            @{ Body = ConvertTo-SecureString $script:record -AsPlainText -Force; ETag = '"0xABC2"' }
        }
    }

    It 'Returns only confidential values for verified accepted receipts' {
        $confirmed = Confirm-HciImageReceipt -Store $store -ETag $tags['avm-image-etag'] -Hash $tags['avm-image-hash']
        $operation = Get-HciImageReceipt -Store $store -Tags $tags
        try {
            $confirmed | Should -BeOfType [securestring]
            $operation | Should -BeOfType [securestring]
            ($confirmed, $operation | Out-String) | Should -Not -Match 'private-sentinel'
        } finally {
            $confirmed.Dispose()
            $operation.Dispose()
        }
    }

    It 'Rejects a changed <field> binding before returning the operation' -ForEach @(
        @{ field = 'owner' }, @{ field = 'generation' }, @{ field = 'runIdentity' }, @{ field = 'sourceCommit' }
        @{ field = 'storeResourceId' }, @{ field = 'imageTemplateResourceId' }, @{ field = 'imageVersionResourceId' }, @{ field = 'deadline' }
    ) {
        $store.Binding[$field] = 'changed'
        { Get-HciImageReceipt -Store $store -Tags $tags } | Should -Throw '*owner, generation, run, resources, source or original deadline changed*'
        Should -Invoke Invoke-HciImageReceiptRequest -Times 1 -Exactly -ParameterFilter { $Operation -ceq 'Read' }
    }

    It 'Rejects a changed public reference <field>' -ForEach @(
        @{ field = 'avm-image-receipt' }, @{ field = 'avm-image-etag' }, @{ field = 'avm-image-hash' }
        @{ field = 'avm-image-operation' }, @{ field = 'avm-image-start' }, @{ field = 'avm-image-previous' }
    ) {
        $tags[$field] = 'd' * 64
        { Get-HciImageReceipt -Store $store -Tags $tags } | Should -Throw
        Should -Invoke Invoke-HciImageReceiptRequest -Times 0 -Exactly -ParameterFilter { $Operation -cne 'Read' }
    }

    It 'Rejects mutated private content even when the returned ETag is unchanged' {
        $script:record = $script:record.Replace('private-sentinel', 'tampered-private-value')
        $errorRecord = { Get-HciImageReceipt -Store $store -Tags $tags } | Should -Throw '*receipt content changed*' -PassThru
        $errorRecord.ToString() | Should -Not -Match 'private-sentinel|tampered-private-value'
    }
}

Describe 'HCI persistent receipt infrastructure' {
    BeforeAll {
        $asset = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'hciImageReceiptStore.bicep'
        $output = Join-Path $TestDrive 'receipts.json'
        $diagnostics = bicep build $asset --no-restore --outfile $output 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content $output -Raw | ConvertFrom-Json -AsHashtable
    }

    It 'Creates only the dedicated keyless account, private container, service settings and narrow role' {
        $template.resources.Count | Should -Be 4
        $account = $template.resources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts'
        $container = $template.resources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts/blobServices/containers'
        $service = $template.resources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts/blobServices'
        $assignment = $template.resources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments'
        $account.kind | Should -Be 'StorageV2'
        $account.sku.name | Should -Be 'Standard_LRS'
        $account.properties.accessTier | Should -Be 'Hot'
        $account.properties.minimumTlsVersion | Should -Be 'TLS1_2'
        $account.properties.supportsHttpsTrafficOnly | Should -BeTrue
        $account.properties.allowBlobPublicAccess | Should -BeFalse
        $account.properties.allowSharedKeyAccess | Should -BeFalse
        $account.properties.publicNetworkAccess | Should -Be 'Enabled'
        $account.tags.lifecycle | Should -Be 'tenant-persistent'
        $account.tags.ContainsKey('avm-contract') | Should -BeFalse
        $container.properties.publicAccess | Should -Be 'None'
        $service.properties.isVersioningEnabled | Should -BeFalse
        $assignment.scope | Should -BeExactly "[resourceId('Microsoft.Storage/storageAccounts/blobServices/containers', variables('accountName'), 'default', variables('containerName'))]"
        $assignment.properties.principalType | Should -Be 'ServicePrincipal'
        $template.variables.blobContributorRoleId | Should -Match 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
        $template.variables.accountName | Should -Match 'uniqueString'
        $template.variables.accountName | Should -Match 'toLower'
    }
}
