param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Attempt-bound NIC diagnostic-storage evidence' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Export-NicDiagnosticStorageEvidence.ps1')

        function Get-AzContext { [CmdletBinding()] param() throw 'Unexpected live context lookup.' }
        function Get-AzAccessToken {
            [CmdletBinding()]
            param([string] $ResourceUrl, [switch] $AsSecureString, [object] $DefaultProfile)
            throw 'Unexpected live authentication.'
        }
        function New-EvidenceOperation {
            param([string] $Id, [string] $Type, [string] $State = 'Succeeded')
            $script:operationNumber++
            @{
                operationId = $script:operationNumber.ToString('X16')
                properties = @{
                    targetResource = @{ id = $Id; resourceType = $Type }
                    provisioningOperation = 'Create'
                    provisioningState = $State
                    statusCode = 'OK'
                    timestamp = '2026-10-14T09:27:24Z'
                    serviceRequestId = '11111111-2222-3333-4444-555555555555'
                    statusMessage = @{ error = @{ code = 'BadRequest'; message = 'private-response-message'; details = 'private-detail' } }
                    request = @{ content = 'private-request-body' }
                    response = @{ content = 'private-response-body' }
                }
            }
        }
        function Read-EvidenceFile {
            Get-Content -LiteralPath (Join-Path $captureInput.OutputFolderPath "$($captureInput.DeploymentName).json") -Raw |
                ConvertFrom-Json -AsHashtable
        }
    }

    BeforeEach {
        $script:subscriptionId = '11111111-1111-1111-1111-111111111111'
        $script:rootId = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/fixture-t2"
        $script:groupId = "/subscriptions/$script:subscriptionId/resourceGroups/fixture-vmwinmax"
        $script:diagnosticDependency = "$script:groupId/providers/Microsoft.Resources/deployments/abcdefghijklm-diagnosticDependencies"
        $script:vmDeployment = "$script:groupId/providers/Microsoft.Resources/deployments/abcdefghijklm-test-vmwinmax-init"
        $script:wrapper = "$script:groupId/providers/Microsoft.Resources/deployments/abcdefghijklm-VM-Nic-0"
        $script:nicDeployment = "$script:wrapper-NetworkInterface"
        $script:nicId = "$script:groupId/providers/Microsoft.Network/networkInterfaces/nic-test-01"
        $script:storageId = "$script:groupId/providers/Microsoft.Storage/storageAccounts/fixturediagnostics"
        $script:diagnosticId = "$script:nicId/providers/Microsoft.Insights/diagnosticSettings/customSetting"
        $script:operationNumber = 0
        $script:seenRequests = [System.Collections.Generic.List[string]]::new()
        $script:responses = @{
            $script:rootId = @{
                id = $script:rootId
                properties = @{
                    provisioningState = 'Failed'
                    templateHash = '123456789'
                    correlationId = '11111111-2222-3333-4444-555555555555'
                    timestamp = '2026-10-14T09:32:15Z'
                    parameters = @{
                        serviceShort = @{ value = 'vmwinmax' }
                        resourceGroupName = @{ value = 'fixture-vmwinmax' }
                        resourceLocation = @{ value = 'koreacentral' }
                        adminPassword = @{ value = 'private-parameter' }
                    }
                }
            }
            "$script:rootId/operations" = @{ value = @(
                    (New-EvidenceOperation $script:diagnosticDependency 'Microsoft.Resources/deployments')
                    (New-EvidenceOperation $script:vmDeployment 'Microsoft.Resources/deployments' 'Failed')
                    (New-EvidenceOperation "$script:groupId/providers/Microsoft.Resources/deployments/abcdefghijklm-nestedDependencies" 'Microsoft.Resources/deployments')
                ) }
            "$script:diagnosticDependency/operations" = @{ value = @(
                    (New-EvidenceOperation $script:storageId 'Microsoft.Storage/storageAccounts')
                ) }
            "$script:vmDeployment/operations" = @{ value = @(
                    (New-EvidenceOperation $script:wrapper 'Microsoft.Resources/deployments' 'Failed')
                ) }
            "$script:wrapper/operations" = @{ value = @(
                    (New-EvidenceOperation $script:nicDeployment 'Microsoft.Resources/deployments' 'Failed')
                ) }
            $script:nicDeployment = @{
                id = $script:nicDeployment
                properties = @{
                    parameters = @{
                        diagnosticSettings = @{ value = @(@{ name = 'customSetting'; storageAccountResourceId = $script:storageId; privateValue = 'private-setting' }) }
                    }
                }
            }
            "$script:nicDeployment/operations" = @{ value = @(
                    (New-EvidenceOperation $script:nicId 'Microsoft.Network/networkInterfaces')
                    (New-EvidenceOperation $script:diagnosticId 'Microsoft.Insights/diagnosticSettings' 'Failed')
                ) }
            $script:diagnosticId = @{ id = $script:diagnosticId; properties = @{ storageAccountId = $script:storageId; workspaceId = 'private-workspace' } }
            $script:nicId = @{
                id = $script:nicId; type = 'Microsoft.Network/networkInterfaces'; location = 'koreacentral'
                properties = @{ provisioningState = 'Succeeded'; ipConfigurations = @(@{ privateIPAddress = 'private-address' }) }
            }
            $script:storageId = @{
                id = $script:storageId; type = 'Microsoft.Storage/storageAccounts'; location = 'koreacentral'
                kind = 'StorageV2'; sku = @{ name = 'Standard_LRS' }; tags = @{ note = 'private-tag' }
                properties = @{
                    provisioningState = 'Succeeded'; dnsEndpointType = 'Standard'; publicNetworkAccess = 'Enabled'
                    primaryEndpoints = @{ blob = 'private-endpoint' }
                    networkAcls = @{
                        defaultAction = 'Deny'; bypass = 'AzureServices, Logging'
                        ipRules = @(@{ value = 'private-firewall-address' })
                        virtualNetworkRules = @(@{ id = 'private-subnet-id' })
                    }
                }
            }
        }
        Mock Get-AzContext { @{ Subscription = @{ Id = $script:subscriptionId }; Environment = @{ ResourceManagerUrl = 'https://management.azure.com/' } } }
        Mock Get-AzAccessToken { @{ Token = ConvertTo-SecureString 'private-token' -AsPlainText -Force } }
        Mock Invoke-NicEvidenceGet {
            $Token | Should -BeOfType [securestring]
            $TimeoutSeconds | Should -BeGreaterThan 0
            $TimeoutSeconds | Should -BeLessOrEqual 5
            $requestUri = [uri] $Uri
            $requestUri.Authority | Should -Be 'management.azure.com'
            $script:seenRequests.Add($requestUri.AbsolutePath)
            if (-not $script:responses.ContainsKey($requestUri.AbsolutePath)) { throw 'Unexpected unbound GET.' }
            @{
                StatusCode = 200
                Headers = @{ 'x-ms-request-id' = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee' }
                Content = $script:responses[$requestUri.AbsolutePath] | ConvertTo-Json -Depth 30 -Compress
            }
        }
        $captureInput = @{
            DeploymentName = 'fixture-t2'
            SubscriptionId = $script:subscriptionId
            OutputFolderPath = Join-Path $TestDrive 'evidence'
            RecoveryDeadlineUtc = [datetime]::UtcNow.AddMinutes(1)
        }
    }

    AfterEach {
        $path = Join-Path $captureInput.OutputFolderPath "$($captureInput.DeploymentName).json"
        if (Test-Path -LiteralPath $path) {
            $schema = Join-Path $PSScriptRoot 'fixtures' 'nic-diagnostic-storage-evidence.schema.json'
            Test-Json -Json (Get-Content -LiteralPath $path -Raw) -SchemaFile $schema -ErrorAction Stop | Should -BeTrue
        }
    }

    It 'Records the exact NIC-reference-storage relationship, actual properties and child operation IDs' {
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.status | Should -Be 'complete'
        $evidence.links.Count | Should -Be 1
        $evidence.links[0].submittedStorageId | Should -Be $script:storageId
        $evidence.links[0].materializedReferenceMatches | Should -BeTrue
        $evidence.resources.Count | Should -Be 2
        $storage = $evidence.resources | Where-Object id -EQ $script:storageId
        $storage.location | Should -Be 'koreacentral'
        $storage.skuName | Should -Be 'Standard_LRS'
        $storage.networkAcls.ipRuleCount | Should -Be 1
        ([datetime] $evidence.root.timestamp).ToUniversalTime() | Should -Be ([datetime]::new(2026, 10, 14, 9, 32, 15, [DateTimeKind]::Utc))
        ($evidence.operations | Where-Object targetId -EQ $script:storageId).operationId | Should -Not -BeNullOrEmpty
        ([datetime] ($evidence.operations | Where-Object targetId -EQ $script:storageId).timestamp).ToUniversalTime() |
            Should -Be ([datetime]::new(2026, 10, 14, 9, 27, 24, [DateTimeKind]::Utc))
        $script:seenRequests | Should -Not -Match 'nestedDependencies|listKeys|secrets|tokens'
        $evidence.requests.Count | Should -BeLessOrEqual 32
    }

    It 'Never serializes raw request/response bodies, private configuration, parameters or credentials' {
        Export-NicDiagnosticStorageEvidence @captureInput
        $text = Get-Content -LiteralPath (Join-Path $captureInput.OutputFolderPath 'fixture-t2.json') -Raw
        $text | Should -Not -Match 'private-|adminPassword|primaryEndpoints|ipConfigurations|workspaceId|statusMessage'
        $text | Should -Not -Match '"ipRules"|"virtualNetworkRules"|"tags"|"Token"|"Authorization"'
    }

    It 'Records actual region mismatch without changing either resource or declaring a source fix' {
        $script:responses[$script:storageId].location = 'centralus'
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        ($evidence.resources | Where-Object id -EQ $script:storageId).location | Should -Be 'centralus'
        ($evidence.resources | Where-Object id -EQ $script:nicId).location | Should -Be 'koreacentral'
        (Get-Command Invoke-NicEvidenceGet).Parameters.Keys | Should -Not -Contain 'Method'
    }

    It 'Records HTTP <status> as a gap without logging the error response or trying other resources' -ForEach @(
        @{ status = 403 }, @{ status = 404 }, @{ status = 429 }
    ) {
        Mock Invoke-NicEvidenceGet { @{ StatusCode = $status; Content = '{"error":{"message":"private-denial"}}'; Headers = @{} } } `
            -ParameterFilter { ([uri] $Uri).AbsolutePath -eq $script:storageId }
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.status | Should -Be 'partial'
        ($evidence.requests | Where-Object resourceId -EQ $script:storageId).httpStatus | Should -Be $status
        $evidence.gaps.resourceId | Should -Contain $script:storageId
        ($evidence | ConvertTo-Json -Depth 20) | Should -Not -Match 'private-'
        Should -Invoke Invoke-NicEvidenceGet -Times 1 -Exactly -ParameterFilter { ([uri] $Uri).AbsolutePath -eq $script:storageId }
    }

    It 'Does not follow a storage reference outside the recorded diagnostic dependency' {
        $unrelated = "$script:groupId/providers/Microsoft.Storage/storageAccounts/unrelatedaccount"
        $script:responses[$script:nicDeployment].properties.parameters.diagnosticSettings.value[0].storageAccountResourceId = $unrelated
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.gaps.reason | Should -Contain 'diagnostic-storage-reference-not-bound'
        $script:seenRequests | Should -Not -Contain $unrelated
        $evidence.resources.Count | Should -Be 0
    }

    It 'Does not follow child deployment operations into a different resource group' {
        $script:responses["$script:rootId/operations"].value[1].properties.targetResource.id = $script:vmDeployment.Replace('fixture-vmwinmax', 'not-owned')
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.gaps.reason | Should -Contain 'no-bound-nic-storage-pair'
        $script:seenRequests | Should -Not -Match 'not-owned'
    }

    It 'Rejects ambiguous target arrays instead of serializing unvalidated IDs' {
        $script:responses["$script:diagnosticDependency/operations"].value[0].properties.targetResource.id = @($script:storageId, 'private-unrelated-id')
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.gaps.reason | Should -Contain 'invalid-operation-target'
        ($evidence | ConvertTo-Json -Depth 20) | Should -Not -Match 'private-unrelated-id'
        $evidence.resources.Count | Should -Be 0
    }

    It 'Omits unreferenced storage accounts even when they appear in the diagnostic dependency' {
        $unrelated = "$script:groupId/providers/Microsoft.Storage/storageAccounts/unreferenced"
        $script:responses["$script:diagnosticDependency/operations"].value += New-EvidenceOperation $unrelated 'Microsoft.Storage/storageAccounts'
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.operations.targetId | Should -Not -Contain $unrelated
        $script:seenRequests | Should -Not -Contain $unrelated
    }

    It 'Preserves equivalent resource IDs while canonicalizing operation resource types' {
        $operation = $script:responses["$script:diagnosticDependency/operations"].value[0]
        $operation.properties.targetResource.id = $script:storageId.ToUpperInvariant()
        $operation.properties.targetResource.resourceType = 'microsoft.storage/storageaccounts'
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.status | Should -Be 'complete'
        ($evidence.operations | Where-Object targetId -EQ $script:storageId).targetType | Should -BeExactly 'Microsoft.Storage/storageAccounts'
    }

    It 'Records a missing NIC branch even if a different VM branch supplied evidence' {
        $vmIdem = $script:vmDeployment.Replace('-init', '-idem')
        $script:responses["$script:rootId/operations"].value += New-EvidenceOperation $vmIdem 'Microsoft.Resources/deployments'
        $script:responses["$vmIdem/operations"] = @{ value = @() }
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.links.Count | Should -Be 1
        $evidence.status | Should -Be 'partial'
        ($evidence.gaps | Where-Object resourceId -EQ $vmIdem).reason | Should -Contain 'deployment-branch-unavailable'
    }

    It 'Does not treat an existing-resource read as an attempt-created NIC' {
        $script:responses["$script:nicDeployment/operations"].value[0].properties.provisioningOperation = 'Read'
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain 'nic-operation-not-unique'
        $script:seenRequests | Should -Not -Contain $script:nicId
        $script:seenRequests | Should -Not -Contain $script:storageId
    }

    It 'Rejects a next page for another <target>' -ForEach @(
        @{ target = 'host'; next = 'https://not-the-arm-host.invalid/operations?api-version=2025-04-01' }
        @{ target = 'deployment'; next = 'https://management.azure.com/subscriptions/other/providers/Microsoft.Resources/deployments/other/operations?api-version=2025-04-01' }
    ) {
        $script:responses["$script:rootId/operations"].nextLink = $next
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain 'operation-page-outside-scope'
        $script:seenRequests | Should -Not -Match '/other'
    }

    It 'Stops a repeated operation page without reading it again' {
        $script:responses["$script:rootId/operations"].nextLink = "https://management.azure.com$script:rootId/operations?api-version=2025-04-01"
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain 'operation-page-limit'
        Should -Invoke Invoke-NicEvidenceGet -Times 1 -Exactly -ParameterFilter { ([uri] $Uri).AbsolutePath -eq "$script:rootId/operations" }
    }

    It 'Reads no more than four distinct operation pages per deployment' {
        $script:pageNumber = 0
        Mock Invoke-NicEvidenceGet {
            $script:pageNumber++
            @{
                StatusCode = 200
                Headers = @{}
                Content = @{ value = @(); nextLink = "https://management.azure.com$script:rootId/operations?api-version=2025-04-01&page=$script:pageNumber" } |
                    ConvertTo-Json -Depth 5 -Compress
            }
        } -ParameterFilter { ([uri] $Uri).AbsolutePath -eq "$script:rootId/operations" }
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain 'operation-page-limit'
        Should -Invoke Invoke-NicEvidenceGet -Times 4 -Exactly -ParameterFilter { ([uri] $Uri).AbsolutePath -eq "$script:rootId/operations" }
    }

    It 'Rejects an excessive <kind> before following further resources' -ForEach @(
        @{ kind = 'operation page'; reason = 'invalid-operation-page' }
        @{ kind = 'deployment branch'; reason = 'deployment-branch-limit' }
        @{ kind = 'diagnostic settings'; reason = 'diagnostic-setting-limit' }
    ) {
        switch ($kind) {
            'operation page' { $script:responses["$script:rootId/operations"].value = @($script:responses["$script:rootId/operations"].value[0]) * 257 }
            'deployment branch' { $script:responses["$script:rootId/operations"].value += $script:responses["$script:rootId/operations"].value[0] }
            'diagnostic settings' { $script:responses[$script:nicDeployment].properties.parameters.diagnosticSettings.value *= 5 }
        }
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain $reason
        $script:seenRequests | Should -Not -Contain $script:nicId
        $script:seenRequests | Should -Not -Contain $script:storageId
    }

    It 'Enforces the32-read ceiling on a larger permitted NIC branch' {
        $vmIdem = $script:vmDeployment.Replace('-init', '-idem')
        $script:responses["$script:rootId/operations"].value += New-EvidenceOperation $vmIdem 'Microsoft.Resources/deployments'
        $wrapperOperations = @(for ($i = 0; $i -lt 4; $i++) {
                $wrapper = $script:wrapper -replace '-0$', "-$i"
                $nicDeployment = "$wrapper-NetworkInterface"
                $script:responses["$wrapper/operations"] = @{ value = @((New-EvidenceOperation $nicDeployment 'Microsoft.Resources/deployments')) }
                $script:responses[$nicDeployment] = @{
                    id = $nicDeployment
                    properties = $script:responses[$script:nicDeployment].properties
                }
                $script:responses["$nicDeployment/operations"] = $script:responses["$script:nicDeployment/operations"]
                New-EvidenceOperation $wrapper 'Microsoft.Resources/deployments'
            })
        $script:responses["$script:vmDeployment/operations"] = @{ value = $wrapperOperations }
        $script:responses["$vmIdem/operations"] = @{ value = $wrapperOperations }
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.requests.Count | Should -Be 32
        $evidence.gaps.reason | Should -Contain 'read-budget-exhausted'
        $script:seenRequests.Count | Should -Be 32
    }

    It 'Reports invalid JSON, transport errors and changed response identities without raw exceptions' -ForEach @(
        @{ outcome = 'ambiguous-json' }, @{ outcome = 'timeout' }, @{ outcome = 'different-id' }
    ) {
        Mock Invoke-NicEvidenceGet {
            switch ($outcome) {
                'ambiguous-json' { return @{ StatusCode = 200; Headers = @{}; Content = '{"id":"one","ID":"private-secret"}' } }
                'timeout' { throw [System.TimeoutException]::new('private-exception-message') }
                'different-id' { return @{ StatusCode = 200; Headers = @{}; Content = '{"id":"/wrong"}' } }
            }
        } -ParameterFilter { ([uri] $Uri).AbsolutePath -eq $script:rootId }
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.status | Should -Be 'partial'
        ($evidence | ConvertTo-Json -Depth 20) | Should -Not -Match 'private-|/wrong'
        $evidence.resources.Count | Should -Be 0
    }

    It 'Does not authenticate or read after the original recovery deadline' {
        $captureInput.RecoveryDeadlineUtc = [datetime]::UtcNow.AddMinutes(-1)
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain 'read-budget-exhausted'
        Should -Invoke Get-AzContext -Times 0 -Exactly
        Should -Invoke Get-AzAccessToken -Times 0 -Exactly
        Should -Invoke Invoke-NicEvidenceGet -Times 0 -Exactly
    }

    It 'Keeps missing properties and a changed materialized reference explicit' {
        $script:responses[$script:storageId].properties.Remove('dnsEndpointType')
        $script:responses[$script:diagnosticId].properties.storageAccountId = "$script:storageId-other"
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $evidence.status | Should -Be 'partial'
        $evidence.gaps.reason | Should -Contain 'storage-properties-incomplete'
        $evidence.gaps.reason | Should -Contain 'materialized-reference-mismatch'
        $evidence.links[0].materializedReferenceMatches | Should -BeFalse
        $script:seenRequests | Should -Not -Contain "$script:storageId-other"
    }

    It 'Treats malformed network rule collections as unknown rather than reporting a fabricated count' {
        $script:responses[$script:storageId].properties.networkAcls.ipRules = 'private-malformed-rules'
        $script:responses[$script:storageId].properties.networkAcls.virtualNetworkRules = @{ id = 'private-malformed-subnet' }
        Export-NicDiagnosticStorageEvidence @captureInput
        $evidence = Read-EvidenceFile
        $storage = $evidence.resources | Where-Object id -EQ $script:storageId
        $storage.networkAcls.ipRuleCount | Should -BeNullOrEmpty
        $storage.networkAcls.virtualNetworkRuleCount | Should -BeNullOrEmpty
        $evidence.gaps.reason | Should -Contain 'storage-properties-incomplete'
        ($evidence | ConvertTo-Json -Depth 20) | Should -Not -Match 'private-'
    }

    It 'Refuses a changed subscription context without changing it' {
        Mock Get-AzContext { @{ Subscription = @{ Id = '22222222-2222-2222-2222-222222222222' }; Environment = @{ ResourceManagerUrl = 'https://management.azure.com/' } } }
        Export-NicDiagnosticStorageEvidence @captureInput
        (Read-EvidenceFile).gaps.reason | Should -Contain 'capture-failed'
        Should -Invoke Get-AzAccessToken -Times 0 -Exactly
        Should -Invoke Invoke-NicEvidenceGet -Times 0 -Exactly
    }

    It 'Keeps cancellation distinct from optional capture failure' {
        $catches = @((Get-Command Export-NicDiagnosticStorageEvidence).ScriptBlock.Ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.CatchClauseAst] -and
                    $node.CatchTypes.TypeName.FullName -contains 'System.Management.Automation.PipelineStoppedException'
                }, $true))
        $catches.Count | Should -Be 2
        foreach ($clause in $catches) {
            $clause.Body.Statements.Count | Should -Be 1
            $clause.Body.Statements[0] | Should -BeOfType ([System.Management.Automation.Language.ThrowStatementAst])
        }
    }

    It 'Gates capture to manual windows.max and uploads only after normal cleanup' {
        $action = Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw
        $action | Should -Match '\$env:GITHUB_EVENT_NAME -eq ''workflow_dispatch'''
        $action | Should -Match 'inputs\.templateFilePath.* -eq ''avm/res/compute/virtual-machine/tests/e2e/windows\.max/main\.test\.bicep'''
        $action.IndexOf('Upload NIC diagnostic-storage evidence') | Should -BeGreaterThan $action.IndexOf('Invoke-ModuleDeploymentCleanup @functionInput')
        $upload = $action.Substring($action.IndexOf('Upload NIC diagnostic-storage evidence'))
        $upload | Should -Match 'continue-on-error: true'
        $upload | Should -Match 'if-no-files-found: warn'
        $upload | Should -Match 'retention-days: 7'
    }
}

Describe 'Bounded ARM evidence GET transport' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Export-NicDiagnosticStorageEvidence.ps1')
        if (-not ('NicEvidenceTestHandler' -as [type])) {
            Add-Type -TypeDefinition @'
using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

public sealed class NicEvidenceTestHandler : HttpMessageHandler
{
    public string Body = "{\"ok\":true}";
    public int StatusCode = 200;
    public int DelayMilliseconds;
    public int RequestCount;
    public string Method;
    public string RequestUri;
    public bool TokenMatches;
    public bool Disposed;
    public bool ContentDisposed;
    public bool ContentCanceled;

    protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        RequestCount++;
        Method = request.Method.Method;
        RequestUri = request.RequestUri.AbsoluteUri;
        TokenMatches = request.Headers.Authorization?.Scheme == "Bearer" && request.Headers.Authorization?.Parameter == "offline-only";
        var response = new HttpResponseMessage((HttpStatusCode)StatusCode);
        response.Headers.TryAddWithoutValidation("x-ms-request-id", "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee");
        response.Headers.Location = new Uri("https://not-arm.invalid/");
        response.Content = new TestContent(this);
        return Task.FromResult(response);
    }

    protected override void Dispose(bool disposing) { Disposed = true; base.Dispose(disposing); }

    private sealed class TestContent : HttpContent
    {
        private readonly NicEvidenceTestHandler owner;
        public TestContent(NicEvidenceTestHandler owner) { this.owner = owner; }
        protected override bool TryComputeLength(out long length) { length = Encoding.UTF8.GetByteCount(owner.Body); return true; }
        protected override Task SerializeToStreamAsync(Stream stream, TransportContext context) =>
            SerializeToStreamAsync(stream, context, CancellationToken.None);
        protected override async Task SerializeToStreamAsync(Stream stream, TransportContext context, CancellationToken cancellationToken)
        {
            try {
                await Task.Delay(owner.DelayMilliseconds, cancellationToken);
                byte[] bytes = Encoding.UTF8.GetBytes(owner.Body);
                await stream.WriteAsync(bytes, 0, bytes.Length, cancellationToken);
            } catch (OperationCanceledException) { owner.ContentCanceled = true; throw; }
        }
        protected override void Dispose(bool disposing) { owner.ContentDisposed = true; base.Dispose(disposing); }
    }
}
'@
        }
    }

    BeforeEach {
        $script:transport = [NicEvidenceTestHandler]::new()
        $script:request = @{
            Uri = 'https://management.azure.com/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/fixture-t2?api-version=2025-04-01'
            Token = ConvertTo-SecureString 'offline-only' -AsPlainText -Force
            TimeoutSeconds = 5
        }
        Mock New-Object {
            $ArgumentList[0].AllowAutoRedirect | Should -BeFalse
            $ArgumentList[0].Dispose()
            [System.Net.Http.HttpClient]::new($script:transport)
        } -ParameterFilter { $TypeName -eq 'System.Net.Http.HttpClient' }
    }

    It 'Rejects endpoint changes before making a request' -ForEach @(
        @{ uri = 'https://not-arm.invalid/subscriptions/example' }
        @{ uri = 'http://management.azure.com/subscriptions/example' }
        @{ uri = 'https://user@management.azure.com/subscriptions/example' }
        @{ uri = 'https://management.azure.com/subscriptions/example#fragment' }
    ) {
        $token = ConvertTo-SecureString 'offline-only' -AsPlainText -Force
        { Invoke-NicEvidenceGet -Uri $uri -Token $token -TimeoutSeconds 5 } | Should -Throw '*AzureCloud ARM endpoint*'
    }

    It 'Uses one authenticated GET and disposes the client and buffered response' {
        $response = Invoke-NicEvidenceGet @script:request
        $response.StatusCode | Should -Be 200
        $response.Content | Should -Be '{"ok":true}'
        $response.Headers['x-ms-request-id'] | Should -Be 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
        $script:transport.RequestCount | Should -Be 1
        $script:transport.Method | Should -BeExactly 'GET'
        $script:transport.RequestUri | Should -Be $script:request.Uri
        $script:transport.TokenMatches | Should -BeTrue
        $script:transport.Disposed | Should -BeTrue
        $script:transport.ContentDisposed | Should -BeTrue
    }

    It 'Returns HTTP <status> without retrying or following a redirect' -ForEach @(
        @{ status = 302 }, @{ status = 403 }, @{ status = 404 }, @{ status = 429 }
    ) {
        $script:transport.StatusCode = $status
        (Invoke-NicEvidenceGet @script:request).StatusCode | Should -Be $status
        $script:transport.RequestCount | Should -Be 1
        $script:transport.Disposed | Should -BeTrue
    }

    It 'Accepts exactly one MiB but rejects a larger buffered response' {
        $script:transport.Body = 'x' * 1048576
        (Invoke-NicEvidenceGet @script:request).Content.Length | Should -Be 1048576
        $script:transport = [NicEvidenceTestHandler]::new()
        $script:transport.Body = 'x' * 1048577
        { Invoke-NicEvidenceGet @script:request } | Should -Throw
        $script:transport.RequestCount | Should -Be 1
        $script:transport.Disposed | Should -BeTrue
    }

    It 'Applies the timeout while buffering content after response headers arrived' {
        $script:transport.DelayMilliseconds = 10000
        $script:request.TimeoutSeconds = 1
        { Invoke-NicEvidenceGet @script:request } | Should -Throw
        $script:transport.RequestCount | Should -Be 1
        $script:transport.ContentCanceled | Should -BeTrue
        $script:transport.Disposed | Should -BeTrue
    }
}
