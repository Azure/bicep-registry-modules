if (-not (Get-Command Get-HciImageOperationIdentity -CommandType Function -ErrorAction SilentlyContinue)) {
    . (Join-Path $PSScriptRoot '..' '..' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'HciImageOperation.ps1')
}

function Get-HciImageReceiptContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Context,
        [Parameter(Mandatory)] [string] $SourceCommit,
        [Parameter(Mandatory)] [string] $RunIdentity,
        [Parameter(Mandatory)] [string] $StorageAccountName
    )

    if ($StorageAccountName -cnotmatch '^sthcircp[a-z0-9]{13}$' -or
        $RunIdentity -cnotmatch '^[^|]+\|[1-9][0-9]*\|[1-9][0-9]*$' -or
        $SourceCommit -cnotmatch '^[a-f0-9]{40}$') {
        throw 'Configure the separate HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT binding and use an explicit workflow run/attempt before starting an image.'
    }
    $registry = Get-HciEnvironmentRegistry -Context $Context -RequireOwner
    $generation = $registry.tags['avm-generation']
    $deadline = ConvertTo-HciImageBuildTimestamp -Value $registry.tags['avm-image-deadline']
    if ($generation -cnotmatch '^[a-f0-9]{32}$' -or $deadline -le [datetimeoffset] (Get-Date)) {
        throw 'The HCI receipt requires the original live generation and unexpired image deadline.'
    }
    $accountId = "$($Context.GroupIds.control)/providers/Microsoft.Storage/storageAccounts/$StorageAccountName"
    $containerId = "$accountId/blobServices/default/containers/hci-operation-receipts"
    $account = Get-HciArmResource -ResourceId $accountId -ApiVersion '2025-06-01'
    $expectedTags = @{
        lifecycle = 'tenant-persistent'
        'avm-owner' = 'Azure/bicep-registry-modules'
        'avm-environment' = 'azure-local'
        'avm-purpose' = 'image-operation-receipts'
        'avm-receipt-version' = '1'
        'avm-tenant' = $Context.TenantId
        'avm-subscription' = $Context.SubscriptionId
    }
    foreach ($entry in $expectedTags.GetEnumerator()) {
        if ($account.tags[$entry.Key] -cne $entry.Value) {
            throw 'The configured HCI receipt account has mismatched ownership; it will not be adopted.'
        }
    }
    foreach ($key in @('avm-ci-client', 'avm-ci-principal')) {
        $id = [guid]::Empty
        if (-not [guid]::TryParse($account.tags[$key], [ref] $id) -or $id -eq [guid]::Empty) {
            throw 'The HCI receipt account has no valid existing CI identity binding.'
        }
    }
    $properties = $account.properties
    if ($account.kind -cne 'StorageV2' -or $account.sku.name -cne 'Standard_LRS' -or
        $account.location -cne $Context.Config.location -or $properties.provisioningState -cne 'Succeeded' -or
        $properties.accessTier -cne 'Hot' -or $properties.allowCrossTenantReplication -cne $false -or
        $properties.defaultToOAuthAuthentication -cne $true -or
        $properties.allowBlobPublicAccess -cne $false -or $properties.allowSharedKeyAccess -cne $false -or
        $properties.supportsHttpsTrafficOnly -cne $true -or $properties.minimumTlsVersion -cne 'TLS1_2' -or
        $properties.publicNetworkAccess -cne 'Enabled' -or
        $properties.primaryEndpoints.blob -cne "https://$StorageAccountName.blob.core.windows.net/") {
        throw 'The configured HCI receipt account does not meet its private, keyless storage contract.'
    }
    $service = Get-HciArmResource -ResourceId "$accountId/blobServices/default" -ApiVersion '2025-06-01'
    if ($service.properties.isVersioningEnabled -cne $false -or
        $service.properties.deleteRetentionPolicy.enabled -cne $false -or
        $service.properties.containerDeleteRetentionPolicy.enabled -cne $false) {
        throw 'The HCI receipt store must not create untracked versioning or soft-delete copies.'
    }
    $container = Get-HciArmResource -ResourceId $containerId -ApiVersion '2025-06-01'
    if ($container.properties.publicAccess -cne 'None') {
        throw 'The HCI receipt container must prohibit anonymous access.'
    }
    $binding = [ordered] @{
        version = '1'
        storeResourceId = $containerId
        tenantId = $Context.TenantId
        subscriptionId = $Context.SubscriptionId
        owner = $Context.Owner
        generation = $generation
        runIdentity = $RunIdentity
        sourceCommit = $SourceCommit
        contract = $Context.Tags['avm-contract']
        imageTemplateResourceId = $Context.ImageTemplateResourceId
        imageVersionResourceId = $Context.ImageVersionResourceId
        deadline = $deadline.ToString('o')
        requiredRegions = @($Context.Config.location)
    }
    return @{
        Endpoint = "https://$StorageAccountName.blob.core.windows.net/hci-operation-receipts"
        TenantId = $Context.TenantId
        ClientId = $account.tags['avm-ci-client']
        PrincipalId = $account.tags['avm-ci-principal']
        Binding = $binding
        Key = Get-HciEnvironmentKey -Value "$($Context.ImageTemplateResourceId.ToLowerInvariant())|$generation|$($Context.Owner)|$RunIdentity"
    }
}

function Invoke-HciImageReceiptRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Store,
        [Parameter(Mandatory)] [ValidateSet('Create', 'Replace', 'Read')] [string] $Operation,
        [string] $ETag,
        [securestring] $Body
    )

    if ($Store.Endpoint -cnotmatch '^https://sthcircp[a-z0-9]{13}\.blob\.core\.windows\.net/hci-operation-receipts$' -or
        $Store.Key -cnotmatch '^[a-f0-9]{64}$' -or
        ($Operation -ne 'Create' -and $ETag -cnotmatch '^"0x[0-9a-fA-F]+"$') -or
        ($Operation -ne 'Read' -and $null -eq $Body)) {
        throw 'Invalid exact HCI receipt request.'
    }
    $token = $null
    $client = $null
    $request = $null
    $response = $null
    $bytes = $null
    try {
        $token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com/' -AsSecureString -ErrorAction Stop).Token
        if ($token -isnot [securestring] -or $token.Length -eq 0) { throw 'Missing storage token.' }
        $plainToken = [pscredential]::new('token', $token).GetNetworkCredential().Password
        $encodedClaims = $plainToken.Split('.')[1].Replace('-', '+').Replace('_', '/')
        $encodedClaims = $encodedClaims.PadRight($encodedClaims.Length + (4 - $encodedClaims.Length % 4) % 4, '=')
        $claims = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encodedClaims)) | ConvertFrom-Json -AsHashtable -ErrorAction Stop
        $clientId = $claims.appid ? $claims.appid : $claims.azp
        if ($claims.tid -ine $Store.TenantId -or $claims.oid -ine $Store.PrincipalId -or $clientId -ine $Store.ClientId) {
            throw 'The receipt request is not authenticated as the configured existing CI identity.'
        }
        $client = New-HciHttpClient -TimeoutSeconds 60
        $method = $Operation -eq 'Read' ? [Net.Http.HttpMethod]::Get : [Net.Http.HttpMethod]::Put
        $request = [Net.Http.HttpRequestMessage]::new($method, "$($Store.Endpoint)/runs/$($Store.Key).json")
        $request.Headers.Authorization = [Net.Http.Headers.AuthenticationHeaderValue]::new('Bearer', $plainToken)
        $plainToken = $null
        $request.Headers.Add('x-ms-version', '2023-11-03')
        $request.Headers.Add('x-ms-date', [datetime]::UtcNow.ToString('R', [Globalization.CultureInfo]::InvariantCulture))
        $request.Headers.Add('x-ms-client-request-id', [guid]::NewGuid().ToString('D'))
        if ($Operation -eq 'Create') { $request.Headers.Add('If-None-Match', '*') }
        else { $request.Headers.Add('If-Match', $ETag) }
        if ($Operation -ne 'Read') {
            $bytes = [Text.Encoding]::UTF8.GetBytes([pscredential]::new('receipt', $Body).GetNetworkCredential().Password)
            if ($bytes.Length -gt 65536) { throw 'Receipt exceeds the bounded payload size.' }
            $request.Content = [Net.Http.ByteArrayContent]::new($bytes)
            $request.Content.Headers.ContentType = [Net.Http.Headers.MediaTypeHeaderValue]::new('application/json')
            $request.Headers.Add('x-ms-blob-type', 'BlockBlob')
        }
        $response = $client.SendAsync($request).GetAwaiter().GetResult()
        $expectedStatus = $Operation -eq 'Read' ? 200 : 201
        if ([int] $response.StatusCode -ne $expectedStatus) {
            throw "Receipt $Operation returned HTTP $([int] $response.StatusCode)."
        }
        $responseETag = [string] $response.Headers.ETag
        if ($responseETag -cnotmatch '^"0x[0-9a-fA-F]+"$' -or ($Operation -eq 'Read' -and $responseETag -cne $ETag)) {
            throw 'The receipt ETag changed or is missing.'
        }
        $result = @{ ETag = $responseETag }
        if ($Operation -eq 'Read') {
            $content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
            if ([string]::IsNullOrWhiteSpace($content) -or [Text.Encoding]::UTF8.GetByteCount($content) -gt 65536) {
                throw 'The receipt body is empty or exceeds its bounded payload size.'
            }
            $result.Body = ConvertTo-HciPrivateValue $content
        }
        return $result
    } catch {
        $status = $response ? [string] [int] $response.StatusCode : 'unconfirmed'
        throw "HCI receipt $Operation failed (HTTP $status). The environment remains blocked; no request was retried and a build must not be resubmitted."
    } finally {
        $content = $null
        $plainToken = $null
        $encodedClaims = $null
        $claims = $null
        if ($bytes) { [Array]::Clear($bytes) }
        if ($response) { $response.Dispose() }
        if ($request) { $request.Dispose() }
        if ($client) { $client.Dispose() }
        if ($token -is [securestring]) { $token.Dispose() }
    }
}

function Confirm-HciImageReceipt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Store,
        [Parameter(Mandatory)] [string] $ETag,
        [Parameter(Mandatory)] [string] $Hash
    )

    $readback = Invoke-HciImageReceiptRequest -Store $Store -Operation Read -ETag $ETag
    try {
        $plain = [pscredential]::new('receipt', $readback.Body).GetNetworkCredential().Password
        if ((Get-HciEnvironmentKey -Value $plain) -cne $Hash) {
            throw 'The HCI receipt content changed; no build may be submitted or resumed.'
        }
        $record = ConvertFrom-HciPrivateJson -Value $readback.Body
        if (($record.binding | ConvertTo-Json -Depth 10 -Compress) -cne ($Store.Binding | ConvertTo-Json -Depth 10 -Compress)) {
            throw 'The HCI receipt owner, generation, run, resources, source or original deadline changed.'
        }
        return $readback.Body.Copy()
    } finally {
        $plain = $null
        $record = $null
        if ($readback.Body -is [securestring]) { $readback.Body.Dispose() }
    }
}

function New-HciImageReceipt {
    [CmdletBinding(SupportsShouldProcess)]
    param ([Parameter(Mandatory)] [hashtable] $Store)

    if (-not $PSCmdlet.ShouldProcess($Store.Key, 'Create and verify the private Pending HCI receipt')) {
        throw 'The private Pending receipt was not created; no image build may be submitted.'
    }
    $json = @{ binding = $Store.Binding; state = 'Pending' } | ConvertTo-Json -Depth 10 -Compress
    $body = ConvertTo-HciPrivateValue $json
    $confirmed = $null
    try {
        $created = Invoke-HciImageReceiptRequest -Store $Store -Operation Create -Body $body
        $confirmed = Confirm-HciImageReceipt -Store $Store -ETag $created.ETag -Hash (Get-HciEnvironmentKey -Value $json)
        $record = ConvertFrom-HciPrivateJson -Value $confirmed
        if ($record.state -cne 'Pending') { throw 'The HCI receipt is not the newly created Pending record.' }
        return @{ ETag = $created.ETag }
    } finally {
        if ($confirmed) { $confirmed.Dispose() }
        $body.Dispose()
    }
}

function Set-HciImageReceipt {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)] [hashtable] $Store,
        [Parameter(Mandatory)] [string] $PendingETag,
        [Parameter(Mandatory)] [securestring] $OperationReceipt
    )

    $operation = ConvertFrom-HciPrivateJson -Value $OperationReceipt
    if ($operation.imageTemplateResourceId -cne $Store.Binding.imageTemplateResourceId -or
        $operation.imageVersionResourceId -cne $Store.Binding.imageVersionResourceId -or
        $operation.deadline -cne $Store.Binding.deadline -or
        ($operation.requiredRegions -join ',') -cne ($Store.Binding.requiredRegions -join ',')) {
        throw 'The accepted image operation does not match its private Pending receipt.'
    }
    if (-not $PSCmdlet.ShouldProcess($Store.Key, 'Persist and verify the accepted private HCI receipt')) {
        throw 'The accepted receipt was not persisted. Do not resubmit the image build.'
    }
    $json = @{ binding = $Store.Binding; state = 'Accepted'; operation = $operation } | ConvertTo-Json -Depth 10 -Compress
    $hash = Get-HciEnvironmentKey -Value $json
    $body = ConvertTo-HciPrivateValue $json
    $confirmed = $null
    try {
        $accepted = Invoke-HciImageReceiptRequest -Store $Store -Operation Replace -ETag $PendingETag -Body $body
        $confirmed = Confirm-HciImageReceipt -Store $Store -ETag $accepted.ETag -Hash $hash
        $record = ConvertFrom-HciPrivateJson -Value $confirmed
        if ($record.state -cne 'Accepted') { throw 'The private image receipt was not accepted.' }
        return @{ ETag = $accepted.ETag; Hash = $hash; Key = $Store.Key }
    } finally {
        $json = $null
        $operation = $null
        $record = $null
        if ($confirmed) { $confirmed.Dispose() }
        $body.Dispose()
    }
}

function Get-HciImageReceipt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [hashtable] $Store,
        [Parameter(Mandatory)] [hashtable] $Tags
    )

    if ($Tags['avm-image-receipt'] -cne $Store.Key -or $Tags['avm-image-hash'] -cnotmatch '^[a-f0-9]{64}$') {
        throw 'The image has no matching private receipt reference; an old or uncertain operation cannot be adopted.'
    }
    $confirmed = Confirm-HciImageReceipt -Store $Store -ETag $Tags['avm-image-etag'] -Hash $Tags['avm-image-hash']
    try {
        $record = ConvertFrom-HciPrivateJson -Value $confirmed
        if ($record.state -cne 'Accepted' -or
            $record.operation.operationId -cne $Tags['avm-image-operation'] -or
            $record.operation.observedRunStartTime -cne $Tags['avm-image-start'] -or
            $record.operation.previousRunStartTime -cne $Tags['avm-image-previous']) {
            throw 'The private HCI receipt does not match the recorded image run.'
        }
        return ConvertTo-HciPrivateValue ($record.operation | ConvertTo-Json -Depth 10 -Compress)
    } finally {
        $record = $null
        $confirmed.Dispose()
    }
}
