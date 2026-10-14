. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'Get-DeploymentOperationAtScope.ps1')

function Invoke-NicEvidenceGet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [uri] $Uri,
        [Parameter(Mandatory)]
        [securestring] $Token,
        [Parameter(Mandatory)]
        [ValidateRange(1, 5)]
        [int] $TimeoutSeconds
    )

    if ($Uri.Scheme -ne 'https' -or $Uri.Authority -ne 'management.azure.com' -or $Uri.UserInfo -or $Uri.Fragment) {
        throw 'Evidence reads must remain on the AzureCloud ARM endpoint.'
    }
    $handler = [System.Net.Http.HttpClientHandler]::new()
    $handler.AllowAutoRedirect = $false
    $client = New-Object -TypeName System.Net.Http.HttpClient -ArgumentList $handler
    $response = $null
    try {
        $client.Timeout = [timespan]::FromSeconds($TimeoutSeconds)
        $client.MaxResponseContentBufferSize = 1048576
        $client.DefaultRequestHeaders.Authorization = [System.Net.Http.Headers.AuthenticationHeaderValue]::new(
            'Bearer', ([System.Net.NetworkCredential]::new('', $Token)).Password
        )
        $response = $client.GetAsync($Uri, [System.Net.Http.HttpCompletionOption]::ResponseContentRead).GetAwaiter().GetResult()
        $requestIds = $null
        $null = $response.Headers.TryGetValues('x-ms-request-id', [ref] $requestIds)
        return @{
            StatusCode = [int] $response.StatusCode
            Headers = @{ 'x-ms-request-id' = $requestIds -join ' ' }
            Content = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
        }
    } finally {
        if ($null -ne $response) { $response.Dispose() }
        $client.Dispose()
    }
}

<#
.SYNOPSIS
Save allowlisted windows.max NIC diagnostic-storage evidence for one recorded attempt.

.DESCRIPTION
Only follows the attempt's diagnostic dependency and VM/NIC deployment branches.
Never writes to Azure or returns evidence to deployment retry classification.
Missing, denied, incomplete or changed contracts are recorded as gaps.
#>
function Export-NicDiagnosticStorageEvidence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^[a-zA-Z0-9_()-][a-zA-Z0-9_.()-]{0,63}\z')]
        [string] $DeploymentName,

        [Parameter(Mandatory)]
        [guid] $SubscriptionId,

        [Parameter(Mandatory)]
        [string] $OutputFolderPath,

        [Parameter(Mandatory)]
        [ValidateScript({ $_.Kind -eq [DateTimeKind]::Utc })]
        [datetime] $RecoveryDeadlineUtc
    )

    $rootId = Get-DeploymentResourceId -Scope subscription -Name $DeploymentName -SubscriptionId $SubscriptionId
    $started = [datetime]::UtcNow
    $budgetEnd = @($started.AddSeconds(30), $RecoveryDeadlineUtc.ToUniversalTime()) | Sort-Object | Select-Object -First 1
    $record = [ordered]@{
        schemaVersion = 1
        fixture = 'avm/res/compute/virtual-machine/tests/e2e/windows.max/main.test.bicep'
        deploymentId = $rootId
        sourceCommit = $env:GITHUB_SHA -match '^[0-9a-fA-F]{40}$' ? $env:GITHUB_SHA : $null
        workflowRunId = $env:GITHUB_RUN_ID -match '^[0-9]{1,20}$' ? $env:GITHUB_RUN_ID : $null
        workflowRunAttempt = $env:GITHUB_RUN_ATTEMPT -match '^[0-9]{1,10}$' ? $env:GITHUB_RUN_ATTEMPT : $null
        capturedAtUtc = $started.ToString('o')
        recoveryDeadlineUtc = $RecoveryDeadlineUtc.ToUniversalTime().ToString('o')
        root = $null
        requests = [System.Collections.Generic.List[object]]::new()
        operations = [System.Collections.Generic.List[object]]::new()
        links = [System.Collections.Generic.List[object]]::new()
        resources = [System.Collections.Generic.List[object]]::new()
        gaps = [System.Collections.Generic.List[object]]::new()
    }

    function Add-Gap {
        param([string] $Id, [string] $Reason)
        $record.gaps.Add(@{ resourceId = $Id; reason = $Reason })
    }

    function Get-Metadata {
        param([object] $Value, [string] $Pattern = '^[a-zA-Z0-9_.:-]{1,128}$')
        if ($Value -is [datetime] -and $Pattern -eq '^[0-9T:.+Z-]{16,40}$') {
            return $Value.ToUniversalTime().ToString('o')
        }
        if ($Value -is [string] -and $Value -cmatch $Pattern) { return $Value }
        return $null
    }

    function Read-EvidenceJson {
        param([string] $Id, [string] $ApiVersion, [string] $Page)
        $remaining = [int] [math]::Floor(($budgetEnd - [datetime]::UtcNow).TotalSeconds)
        if ($remaining -lt 1 -or $record.requests.Count -ge 32) {
            Add-Gap $Id 'read-budget-exhausted'
            return
        }
        $request = @{
            resourceId = $Id
            apiVersion = $ApiVersion
            capturedAtUtc = [datetime]::UtcNow.ToString('o')
            httpStatus = $null
            requestId = $null
        }
        $record.requests.Add($request)
        try {
            $response = Invoke-NicEvidenceGet -Uri ($Page ? $Page : "${endpoint}${Id}?api-version=$ApiVersion") `
                -Token $token -TimeoutSeconds ([math]::Min(5, $remaining)) -ErrorAction Stop
            $request.httpStatus = [int] $response.StatusCode
            $request.requestId = Get-Metadata ([string] $response.Headers['x-ms-request-id']) '^[0-9a-fA-F-]{16,64}$'
            if ($request.httpStatus -ne 200) {
                Add-Gap $Id ($request.httpStatus -in @(401, 403) ? 'read-denied' : 'http-not-successful')
                return
            }
            if ($response.Content -isnot [string] -or $response.Content.Length -gt 1048576 -or
                -not (Test-DeploymentResponseJson -Json $response.Content)) {
                Add-Gap $Id 'invalid-or-excessive-response'
                return
            }
            return $response.Content | ConvertFrom-Json -AsHashtable -NoEnumerate -ErrorAction Stop
        } catch [System.Management.Automation.PipelineStoppedException] {
            throw
        } catch {
            Add-Gap $Id 'read-failed'
        }
    }

    function Read-Operations {
        param([string] $Id)
        $path = "$Id/operations"
        $page = "${endpoint}${path}?api-version=2025-04-01"
        $visited = [System.Collections.Generic.HashSet[string]]::new()
        $operations = [System.Collections.Generic.List[object]]::new()
        while ($page) {
            if (-not $visited.Add($page) -or $visited.Count -gt 4) {
                Add-Gap $Id 'operation-page-limit'
                break
            }
            $body = Read-EvidenceJson $path '2025-04-01' $page
            if ($null -eq $body) { break }
            if ($body.value -isnot [array] -or $body.value.Count -gt 256) {
                Add-Gap $Id 'invalid-operation-page'
                break
            }
            foreach ($operation in $body.value) {
                if ($operation -isnot [System.Collections.IDictionary] -or
                    $operation.properties -isnot [System.Collections.IDictionary]) {
                    Add-Gap $Id 'invalid-operation'
                    continue
                }
                $target = $operation.properties.targetResource
                if ($target -isnot [System.Collections.IDictionary] -or $target.resourceType -isnot [string]) {
                    Add-Gap $Id 'invalid-operation-target'
                    continue
                }
                if ($target.resourceType -notin @('Microsoft.Resources/deployments', 'Microsoft.Storage/storageAccounts',
                        'Microsoft.Network/networkInterfaces', 'Microsoft.Insights/diagnosticSettings')) { continue }
                if ($target.id -isnot [string] -or $operation.properties.provisioningOperation -isnot [string]) {
                    Add-Gap $Id 'invalid-operation-target'
                    continue
                }
                $operations.Add($operation)
            }
            $page = $null
            if ($null -ne $body.nextLink) {
                $next = $null
                if ($body.nextLink -isnot [string] -or [string]::IsNullOrWhiteSpace($body.nextLink) -or
                    -not [uri]::TryCreate([uri] $endpoint, $body.nextLink, [ref] $next) -or
                    $next.Scheme -ne 'https' -or $next.Authority -ne ([uri] $endpoint).Authority -or
                    $next.AbsolutePath -ine $path -or $next.UserInfo -or $next.Fragment) {
                    Add-Gap $Id 'operation-page-outside-scope'
                    break
                }
                $page = $next.AbsoluteUri
            }
        }
        return , @($operations)
    }

    function Save-Operation {
        param([string] $Parent, [object] $Operation)
        $p = $Operation.properties
        $operationId = Get-Metadata $Operation.operationId '^[0-9a-fA-F-]{1,64}$'
        if (-not $operationId) { Add-Gap $Parent 'operation-identity-unavailable' }
        $record.operations.Add(@{
                deploymentId = $Parent
                operationId = $operationId
                targetId = $p.targetResource.id
                targetType = switch ($p.targetResource.resourceType) {
                    'Microsoft.Resources/deployments' { 'Microsoft.Resources/deployments' }
                    'Microsoft.Storage/storageAccounts' { 'Microsoft.Storage/storageAccounts' }
                    'Microsoft.Network/networkInterfaces' { 'Microsoft.Network/networkInterfaces' }
                    'Microsoft.Insights/diagnosticSettings' { 'Microsoft.Insights/diagnosticSettings' }
                }
                provisioningOperation = Get-Metadata $p.provisioningOperation
                provisioningState = Get-Metadata $p.provisioningState
                statusCode = Get-Metadata ([string] $p.statusCode)
                timestamp = Get-Metadata $p.timestamp '^[0-9T:.+Z-]{16,40}$'
                trackingId = Get-Metadata $p.trackingId '^[0-9a-fA-F-]{16,64}$'
                serviceRequestId = Get-Metadata $p.serviceRequestId '^[0-9a-fA-F-]{16,64}$'
                errorCode = Get-Metadata $p.statusMessage.error.code
            })
    }

    function Read-Deployment {
        param([string] $Id)
        $body = Read-EvidenceJson $Id '2025-04-01'
        if ($null -ne $body -and ($body.id -isnot [string] -or $body.id -ine $Id)) {
            Add-Gap $Id 'response-identity-mismatch'
            return
        }
        return $body
    }

    function Get-Children {
        param([object[]] $Operations, [string] $Parent, [string] $NamePattern, [int] $Limit)
        $found = @($Operations | Where-Object {
                $_.properties.provisioningOperation -eq 'Create' -and
                $_.properties.targetResource.resourceType -eq 'Microsoft.Resources/deployments' -and
                $_.properties.targetResource.id -match "^$([regex]::Escape($groupId))/providers/Microsoft\.Resources/deployments/$NamePattern`$"
            })
        if ($found.Count -gt $Limit) {
            Add-Gap $Parent 'deployment-branch-limit'
            return
        }
        if ($found.Count -eq 0) { Add-Gap $Parent 'deployment-branch-unavailable' }
        foreach ($operation in $found) {
            Save-Operation $Parent $operation
            $operation.properties.targetResource.id
        }
    }

    try {
        if ($budgetEnd -le [datetime]::UtcNow) {
            Add-Gap $rootId 'read-budget-exhausted'
        } else {
            $context = Get-AzContext -ErrorAction Stop
            if ($context.Subscription.Id -ine $SubscriptionId.ToString() -or
                $context.Environment.ResourceManagerUrl.TrimEnd('/') -ne 'https://management.azure.com') {
                throw 'Evidence context is not the recorded AzureCloud subscription.'
            }
            $endpoint = $context.Environment.ResourceManagerUrl.TrimEnd('/')
            $token = (Get-AzAccessToken -ResourceUrl $context.Environment.ResourceManagerUrl -AsSecureString `
                    -DefaultProfile $context -ErrorAction Stop -Verbose:$false -Debug:$false).Token
            if ($token -isnot [securestring]) { throw 'Evidence authentication is unavailable.' }
            $root = Read-Deployment $rootId
            $groupName = $root.properties.parameters.resourceGroupName.value
            if ($null -ne $root -and $root.properties.parameters.serviceShort.value -is [string] -and
                $root.properties.parameters.serviceShort.value -ceq 'vmwinmax' -and
                $groupName -is [string] -and $groupName -cmatch '^[a-zA-Z0-9_()-][a-zA-Z0-9_.()-]{0,89}\z') {
                $groupId = "/subscriptions/$SubscriptionId/resourceGroups/$groupName"
                $record.root = @{
                    correlationId = Get-Metadata $root.properties.correlationId '^[0-9a-fA-F-]{36}$'
                    templateHash = Get-Metadata $root.properties.templateHash '^[0-9]{1,32}$'
                    provisioningState = Get-Metadata $root.properties.provisioningState
                    timestamp = Get-Metadata $root.properties.timestamp '^[0-9T:.+Z-]{16,40}$'
                    submittedLocation = Get-Metadata $root.properties.parameters.resourceLocation.value
                }
                $rootOperations = Read-Operations $rootId
                $storageOperations = @{}
                foreach ($id in (Get-Children $rootOperations $rootId '[a-z0-9]{13}-diagnosticDependencies' 1)) {
                    foreach ($operation in (Read-Operations $id)) {
                        $target = $operation.properties.targetResource
                        if ($operation.properties.provisioningOperation -eq 'Create' -and
                            $target.resourceType -eq 'Microsoft.Storage/storageAccounts' -and
                            $target.id -match "^$([regex]::Escape($groupId))/providers/Microsoft\.Storage/storageAccounts/[a-z0-9]{3,24}`$") {
                            $storageOperations[$target.id] = @{ deploymentId = $id; operation = $operation }
                        }
                    }
                }
                $seenResources = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
                foreach ($vmId in (Get-Children $rootOperations $rootId '[a-z0-9]{13}-test-vmwinmax-(init|idem)' 2)) {
                    foreach ($wrapperId in (Get-Children (Read-Operations $vmId) $vmId '[a-z0-9]{13}-VM-Nic-[0-9]+' 4)) {
                        $wrapperName = ($wrapperId -split '/')[-1]
                        foreach ($nicDeploymentId in (Get-Children (Read-Operations $wrapperId) $wrapperId "$([regex]::Escape($wrapperName))-NetworkInterface" 1)) {
                            $nicDeployment = Read-Deployment $nicDeploymentId
                            if ($null -eq $nicDeployment) { continue }
                            $nicOperations = Read-Operations $nicDeploymentId
                            $nics = @($nicOperations | Where-Object {
                                    $_.properties.provisioningOperation -eq 'Create' -and
                                    $_.properties.targetResource.resourceType -eq 'Microsoft.Network/networkInterfaces' -and
                                    $_.properties.targetResource.id -match "^$([regex]::Escape($groupId))/providers/Microsoft\.Network/networkInterfaces/[a-zA-Z0-9_.-]{1,80}`$"
                                })
                            if ($nics.Count -ne 1) { Add-Gap $nicDeploymentId 'nic-operation-not-unique'; continue }
                            $nicId = $nics[0].properties.targetResource.id
                            Save-Operation $nicDeploymentId $nics[0]
                            $settings = @($nicDeployment.properties.parameters.diagnosticSettings.value)
                            if ($settings.Count -gt 4) { Add-Gap $nicDeploymentId 'diagnostic-setting-limit'; continue }
                            foreach ($setting in $settings) {
                                $storageId = $setting.storageAccountResourceId
                                if ($setting.name -isnot [string] -or $setting.name -cnotmatch '^[a-zA-Z0-9_.-]{1,80}$' -or
                                    $storageId -isnot [string] -or -not $storageOperations.ContainsKey($storageId)) {
                                    Add-Gap $nicDeploymentId 'diagnostic-storage-reference-not-bound'
                                    continue
                                }
                                $diagnosticId = "$nicId/providers/Microsoft.Insights/diagnosticSettings/$($setting.name)"
                                $diagnosticOperations = @($nicOperations | Where-Object {
                                        $_.properties.provisioningOperation -eq 'Create' -and
                                        $_.properties.targetResource.resourceType -eq 'Microsoft.Insights/diagnosticSettings' -and
                                        $_.properties.targetResource.id -ieq $diagnosticId
                                    })
                                if ($diagnosticOperations.Count -eq 0) { Add-Gap $nicDeploymentId 'diagnostic-operation-unavailable'; continue }
                                foreach ($operation in $diagnosticOperations) { Save-Operation $nicDeploymentId $operation }
                                $link = @{
                                    deploymentChain = @($rootId, $vmId, $wrapperId, $nicDeploymentId)
                                    nicId = $nicId
                                    diagnosticSettingId = $diagnosticId
                                    submittedStorageId = $storageId
                                    materializedReferenceMatches = $null
                                }
                                $record.links.Add($link)
                                $diagnostic = Read-EvidenceJson $diagnosticId '2021-05-01-preview'
                                if ($null -ne $diagnostic) {
                                    if ($diagnostic.id -isnot [string] -or $diagnostic.id -ine $diagnosticId) { Add-Gap $diagnosticId 'response-identity-mismatch' }
                                    elseif ($diagnostic.properties.storageAccountId -isnot [string]) {
                                        Add-Gap $diagnosticId 'materialized-reference-unavailable'
                                    } else {
                                        $link.materializedReferenceMatches = $diagnostic.properties.storageAccountId -ieq $storageId
                                        if (-not $link.materializedReferenceMatches) { Add-Gap $diagnosticId 'materialized-reference-mismatch' }
                                    }
                                }
                                foreach ($resourceId in @($nicId, $storageId)) {
                                    if (-not $seenResources.Add($resourceId)) { continue }
                                    $isStorage = $resourceId -ieq $storageId
                                    if ($isStorage) {
                                        Save-Operation $storageOperations[$storageId].deploymentId $storageOperations[$storageId].operation
                                    }
                                    $resource = Read-EvidenceJson $resourceId ($isStorage ? '2026-04-01' : '2024-05-01')
                                    $type = $isStorage ? 'Microsoft.Storage/storageAccounts' : 'Microsoft.Network/networkInterfaces'
                                    if ($null -eq $resource) { continue }
                                    if ($resource.id -isnot [string] -or $resource.type -isnot [string] -or
                                        $resource.id -ine $resourceId -or $resource.type -ine $type) {
                                        Add-Gap $resourceId 'response-identity-mismatch'
                                        continue
                                    }
                                    $projection = @{
                                        id = $resourceId
                                        type = $type
                                        location = Get-Metadata $resource.location
                                        provisioningState = Get-Metadata $resource.properties.provisioningState
                                    }
                                    if (-not $projection.location -or -not $projection.provisioningState) {
                                        Add-Gap $resourceId 'resource-properties-incomplete'
                                    }
                                    if ($isStorage) {
                                        $projection.kind = Get-Metadata $resource.kind
                                        $projection.skuName = Get-Metadata $resource.sku.name
                                        $projection.dnsEndpointType = Get-Metadata $resource.properties.dnsEndpointType
                                        $projection.publicNetworkAccess = Get-Metadata $resource.properties.publicNetworkAccess
                                        $acl = $resource.properties.networkAcls
                                        $projection.networkAcls = @{
                                            defaultAction = Get-Metadata $acl.defaultAction
                                            bypass = Get-Metadata $acl.bypass '^(None|AzureServices|Logging|Metrics)(, ?(AzureServices|Logging|Metrics))*$'
                                            ipRuleCount = $acl.ipRules -is [array] ? $acl.ipRules.Count : $null
                                            virtualNetworkRuleCount = $acl.virtualNetworkRules -is [array] ? $acl.virtualNetworkRules.Count : $null
                                        }
                                        if (-not $projection.kind -or -not $projection.skuName -or -not $projection.dnsEndpointType -or
                                            -not $projection.publicNetworkAccess -or -not $projection.networkAcls.defaultAction -or
                                            -not $projection.networkAcls.bypass -or $null -eq $projection.networkAcls.ipRuleCount -or
                                            $null -eq $projection.networkAcls.virtualNetworkRuleCount) {
                                            Add-Gap $resourceId 'storage-properties-incomplete'
                                        }
                                    }
                                    $record.resources.Add($projection)
                                }
                            }
                        }
                    }
                }
                if ($record.links.Count -eq 0) { Add-Gap $rootId 'no-bound-nic-storage-pair' }
            } elseif ($null -ne $root) {
                Add-Gap $rootId 'fixture-parameters-not-recognized'
            }
        }
    } catch [System.Management.Automation.PipelineStoppedException] {
        throw
    } catch {
        Add-Gap $rootId 'capture-failed'
    } finally {
        $token = $null
    }

    $record.status = $record.gaps.Count -gt 0 ? 'partial' : 'complete'
    $record.completedAtUtc = [datetime]::UtcNow.ToString('o')
    $null = New-Item -ItemType Directory -Path $OutputFolderPath -Force -ErrorAction Stop
    $path = Join-Path $OutputFolderPath "$DeploymentName.json"
    $record | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $path -Encoding utf8 -ErrorAction Stop
    if ($record.gaps.Count -gt 0) {
        Write-Warning "NIC diagnostic-storage evidence has [$($record.gaps.Count)] recorded gaps; deployment and cleanup outcomes are unchanged." -WarningAction Continue
    }
}
