param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'Reserved Azure Local environment ownership and readiness' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'HciTestEnvironment.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Invoke-HciPreparationStep.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Invoke-HciTestConsumer.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Write-HciEnvironmentProjection.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Invoke-HciDeploymentHistoryCleanup.ps1')
        function Get-AzContext {}
        function Get-AzResourceProvider { param ($ProviderNamespace) }
        function Set-AzContext { param ($SubscriptionId) }
        function Invoke-AzRestMethod { param ($Method, $Path, $Payload) }
        function New-AzResourceGroup { param ($Name, $Location, $Tag) }
        function New-AzSubscriptionDeployment { param ($Name, $Location, $TemplateFile, $TemplateParameterObject) }
        function New-AzResourceGroupDeployment {
            param ($ResourceGroupName, $Name, $Mode, $TemplateObject, $TemplateParameterObject)
        }
        function Update-AzTag { param ($ResourceId, $Operation, $Tag) }
        function Get-AzResourceGroupDeployment { param ($ResourceGroupName, $Name, $DefaultProfile) }
        function Get-AzAccessToken { param ([switch] $AsSecureString) }
        function Get-AzResource { [CmdletBinding()] param ($ResourceGroupName) }
        function Add-Group($Id, $Tags) {
            $script:resources[$Id] = @{
                id = $Id
                location = $context.Config.location
                tags = $Tags.Clone()
                properties = @{ provisioningState = 'Succeeded' }
            }
        }
        function Add-Registry([string] $State = 'Preparing', [string] $ImageState = 'Ready', [string] $FoundationState = 'None') {
            $tags = $context.Tags.Clone()
            $tags += @{
                'avm-state' = $State
                'avm-active-owner' = $State -cin @('Preparing', 'InUse', 'Recreating', 'TearingDown') ? $context.Owner : ''
                'avm-image-state' = $ImageState
                'avm-foundation-state' = $FoundationState
                'avm-generation' = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
                'avm-foundation-operation' = '44444444-4444-4444-4444-444444444444'
                'avm-kubernetes-version' = '1.32.6'
            }
            Add-Group $context.GroupIds.control $tags
            foreach ($id in $context.OwnedGroupIds) { Add-Group $id $context.Tags }
        }
        function Add-ReadyImage {
            $script:resources[$context.ImageVersionResourceId] = @{
                id = $context.ImageVersionResourceId
                properties = @{
                    provisioningState = 'Succeeded'
                    publishingProfile = @{ excludeFromLatest = $false; targetRegions = @(@{ name = $context.Config.location }) }
                    replicationStatus = @{ summary = @(@{ region = $context.Config.location; state = 'Completed' }) }
                }
            }
        }
        function Add-ReceiptStore {
            $accountId = "$($context.GroupIds.control)/providers/Microsoft.Storage/storageAccounts/sthcircpabcdefghijklm"
            $script:resources[$accountId] = @{
                id = $accountId
                location = $context.Config.location
                kind = 'StorageV2'
                sku = @{ name = 'Standard_LRS' }
                tags = @{
                    lifecycle = 'tenant-persistent'
                    'avm-owner' = 'Azure/bicep-registry-modules'
                    'avm-environment' = 'azure-local'
                    'avm-purpose' = 'image-operation-receipts'
                    'avm-receipt-version' = '1'
                    'avm-tenant' = $context.TenantId
                    'avm-subscription' = $context.SubscriptionId
                    'avm-ci-client' = '66666666-6666-6666-6666-666666666666'
                    'avm-ci-principal' = '77777777-7777-7777-7777-777777777777'
                }
                properties = @{
                    provisioningState = 'Succeeded'
                    accessTier = 'Hot'
                    allowCrossTenantReplication = $false
                    defaultToOAuthAuthentication = $true
                    allowBlobPublicAccess = $false
                    allowSharedKeyAccess = $false
                    supportsHttpsTrafficOnly = $true
                    minimumTlsVersion = 'TLS1_2'
                    publicNetworkAccess = 'Enabled'
                    primaryEndpoints = @{ blob = 'https://sthcircpabcdefghijklm.blob.core.windows.net/' }
                }
            }
            $id = "$accountId/blobServices/default"
            $script:resources[$id] = @{
                id = $id
                properties = @{
                    isVersioningEnabled = $false
                    deleteRetentionPolicy = @{ enabled = $false }
                    containerDeleteRetentionPolicy = @{ enabled = $false }
                }
            }
            $containerId = "$accountId/blobServices/default/containers/hci-operation-receipts"
            $script:resources[$containerId] = @{ id = $containerId; properties = @{ publicAccess = 'None' } }
            $script:receiptRoleAssignmentId = "$containerId/providers/Microsoft.Authorization/roleAssignments/offline-receipt-access"
            $script:resources[$script:receiptRoleAssignmentId] = @{
                id = $script:receiptRoleAssignmentId
                properties = @{
                    scope = $containerId
                    principalId = '77777777-7777-7777-7777-777777777777'
                    roleDefinitionId = '/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe'
                }
            }
        }
        function Add-ReadyFoundation {
            $prefix = $context.GroupIds.foundation
            $clusterId = "$prefix/providers/Microsoft.AzureStackHCI/clusters/$($context.Config.clusterName)"
            $customLocationId = "$prefix/providers/Microsoft.ExtendedLocation/customLocations/$($context.Config.customLocationName)"
            $networkId = "$prefix/providers/Microsoft.AzureStackHCI/logicalNetworks/$($context.Config.logicalNetworkName)"
            $bridgeId = "$prefix/providers/Microsoft.ResourceConnector/appliances/test-bridge"
            $extensionId = "$bridgeId/providers/Microsoft.KubernetesConfiguration/extensions/test-extension"
            $script:resources[$context.DeploymentResourceId] = @{
                id = $context.DeploymentResourceId
                properties = @{
                    provisioningState = 'Succeeded'
                    correlationId = '44444444-4444-4444-4444-444444444444'
                    outputs = @{ environment = @{ value = @{
                                clusterResourceId = $clusterId
                                customLocationResourceId = $customLocationId
                                logicalNetworkResourceId = $networkId
                                clusterNodeNames = @('hcinode1')
                                vSwitchName = 'ConvergedSwitch(ManagementCompute)'
                                keyVaultName = 'avm-hci-test'
                            } } }
                }
            }
            $script:resources[$clusterId] = @{ id = $clusterId; properties = @{ provisioningState = 'Succeeded'; status = 'ConnectedRecently'; connectivityStatus = 'Connected' } }
            $nodeId = "$prefix/providers/Microsoft.HybridCompute/machines/hcinode1"
            $script:resources[$nodeId] = @{ id = $nodeId; properties = @{ provisioningState = 'Succeeded'; status = 'Connected' } }
            $script:resources[$customLocationId] = @{ id = $customLocationId; properties = @{ provisioningState = 'Succeeded'; hostResourceId = $bridgeId; namespace = 'default'; clusterExtensionIds = @($extensionId) } }
            $script:resources[$bridgeId] = @{ id = $bridgeId; properties = @{ provisioningState = 'Succeeded'; status = 'Running' } }
            $script:resources[$extensionId] = @{ id = $extensionId; properties = @{ provisioningState = 'Succeeded' } }
            $script:resources[$networkId] = @{
                id = $networkId
                extendedLocation = @{ name = $customLocationId }
                properties = @{
                    provisioningState = 'Succeeded'
                    vmSwitchName = 'ConvergedSwitch(ManagementCompute)'
                    subnets = @(@{ properties = @{ addressPrefix = '172.20.0.0/24'; ipAllocationMethod = 'Static' } })
                }
            }
        }
    }

    BeforeEach {
        $script:resources = @{}
        $script:deleted = [System.Collections.Generic.List[string]]::new()
        $script:current = @{
            Subscription = @{ Id = '11111111-1111-1111-1111-111111111111' }
            Tenant = @{ Id = '22222222-2222-2222-2222-222222222222' }
            Environment = @{ Name = 'AzureCloud' }
        }
        Mock Get-AzContext { $script:current }
        Mock Set-AzContext {
            $SubscriptionId | Should -Be $script:current.Subscription.Id
        }
        Mock Start-Sleep {}
        Mock Get-AzResourceGroupDeployment { @() }
        Mock New-AzSubscriptionDeployment { throw 'Unexpected image deployment in offline test.' }
        $script:receiptBlob = $null
        $script:receiptETag = $null
        $script:receiptFailure = ''
        Mock Invoke-HciImageReceiptRequest {
            if ($script:receiptFailure -ceq $Operation) { throw "Offline receipt $Operation failure." }
            if ($Operation -eq 'Create') {
                if ($script:receiptBlob) { throw 'Offline receipt already exists.' }
                $script:receiptETag = '"0xABC1"'
            } elseif ($ETag -cne $script:receiptETag) {
                throw 'Offline receipt ETag mismatch.'
            }
            if ($Operation -eq 'Read') {
                if ($script:receiptFailure -ceq 'AcceptedRead' -and $script:receiptETag -ceq '"0xABC2"') {
                    throw 'Offline accepted receipt read failure.'
                }
                return @{ ETag = $script:receiptETag; Body = ConvertTo-SecureString $script:receiptBlob -AsPlainText -Force }
            }
            if ($Operation -eq 'Replace') { $script:receiptETag = '"0xABC2"' }
            $script:receiptBlob = [pscredential]::new('receipt', $Body).GetNetworkCredential().Password
            return @{ ETag = $script:receiptETag }
        }
        Mock Invoke-HciImageOperationRequest {
            $uriValue = [uri] [pscredential]::new('operation', $Uri).GetNetworkCredential().Password
            $response = Invoke-AzRestMethod -Method $Method -Path $uriValue.PathAndQuery
            $result = @{ StatusCode = $response.StatusCode; RetryAfterSeconds = 15 }
            if ($Method -eq 'GET') {
                $result.Body = ConvertTo-SecureString $response.Content -AsPlainText -Force
            } elseif ($response.Headers) {
                $values = $null
                if ($response.Headers.TryGetValues('Azure-AsyncOperation', [ref] $values)) {
                    $result['Azure-AsyncOperation'] = ConvertTo-SecureString @($values)[0] -AsPlainText -Force
                }
            }
            return $result
        }
        Mock Invoke-AzRestMethod {
            $id = ($Path -split '\?')[0]
            if ($Method -eq 'GET') {
                $body = $script:resources[$id]
                if ($null -eq $body) {
                    $code = if ($id -match '/resourceGroups/[^/]+$') {
                        'ResourceGroupNotFound'
                    } elseif ($id -match '/providers/Microsoft\.Resources/deployments/[^/]+$') {
                        'DeploymentNotFound'
                    } else {
                        'ResourceNotFound'
                    }
                    return [pscustomobject] @{ StatusCode = 404; Content = @{ error = @{ code = $code; target = $id } } | ConvertTo-Json }
                }
                return [pscustomobject] @{ StatusCode = 200; Content = $body | ConvertTo-Json -Depth 40 }
            }
            if ($Method -eq 'DELETE') {
                $script:deleted.Add($id)
                foreach ($key in @($script:resources.Keys)) {
                    if ($key -ieq $id -or $key.StartsWith("$id/", [StringComparison]::OrdinalIgnoreCase)) { $script:resources.Remove($key) }
                }
                return [pscustomobject] @{ StatusCode = 202; Content = '{}' }
            }
            throw "Unexpected ARM write [$Method] in offline test."
        }
        Mock New-AzResourceGroup {
            $Location | Should -BeExactly $context.Config.location
            Add-Group "/subscriptions/$($script:current.Subscription.Id)/resourceGroups/$Name" $Tag
        }
        Mock Update-AzTag {
            $Operation | Should -Be 'Merge'
            foreach ($entry in $Tag.GetEnumerator()) { $script:resources[$ResourceId].tags[$entry.Key] = $entry.Value }
        }
        $inputObject = @{
            RepoRootPath = $RepoRootPath
            SubscriptionId = $script:current.Subscription.Id
            TenantId = $script:current.Tenant.Id
            Owner = 'a' * 64
        }
        $context = Get-HciEnvironmentContext @inputObject
        $script:hciContext = $context
    }

    It 'Masks each identifier and each extra mask entry in every casing, and rejects entries too short to mask safely' {
        $masks = @(Register-HciLogMask -Value @('AbCd-1234', '') -AdditionalMasks "Test Subscription;`r`ntenant.example`n `n")
        $masks | Should -Be @(
            '::add-mask::AbCd-1234', '::add-mask::abcd-1234', '::add-mask::ABCD-1234'
            '::add-mask::Test Subscription', '::add-mask::test subscription', '::add-mask::TEST SUBSCRIPTION'
            '::add-mask::tenant.example', '::add-mask::TENANT.EXAMPLE'
        )
        { Register-HciLogMask -AdditionalMasks "valid-entry`nabc" } | Should -Throw '*at least 4 characters*'
    }

    It 'Uses explicit reserved-subscription identities and distinct CI-owned groups' {
        $context.Config.location | Should -BeExactly 'australiaeast'
        $context.OwnedGroupIds.Count | Should -Be 3
        $context.ImageVersionResourceId | Should -Match '^/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-avm-ci-azure-local-image/'
        $context.ImageVersionResourceId | Should -Not -Match 'persistent'
        $context.Tags.lifecycle | Should -Be 'tenant-persistent'
        $context.GroupIds.Values | Sort-Object -Unique | Should -HaveCount 4
        $context.Config.hciVhdxDownloadUri | Should -BeExactly 'https://azlocalvhds.blob.core.windows.net/images/AzLocal2608.vhdx'
        $context.Config.hciVhdxSha256 | Should -BeExactly 'cd670067f6b07dea2d1a4e7219bf00492de2591557a754a9ed0f13f0b01bfdc5'
    }

    It 'Rejects an invalid payload <field> before resource access' -ForEach @(
        @{ field = 'hciVhdxDownloadUri'; value = '' }
        @{ field = 'hciVhdxDownloadUri'; value = 'http://example.test/AzLocal2601.vhdx' }
        @{ field = 'hciVhdxDownloadUri'; value = 'https://user@example.test/AzLocal2601.vhdx' }
        @{ field = 'hciVhdxDownloadUri'; value = 'https://example.test/AzLocal2601.vhdx?query=1' }
        @{ field = 'hciVhdxDownloadUri'; value = 'https://example.test/AzLocal2601.vhdx#fragment' }
        @{ field = 'hciVhdxSha256'; value = $null }
        @{ field = 'hciVhdxSha256'; value = '' }
        @{ field = 'hciVhdxSha256'; value = 'a' * 63 }
        @{ field = 'hciVhdxSha256'; value = 'a' * 65 }
        @{ field = 'hciVhdxSha256'; value = 'g' * 64 }
        @{ field = 'hciVhdxSha256'; value = ('a' * 64) + "`n" }
    ) {
        $script:unsupportedConfig = $context.Config.Clone()
        $script:unsupportedConfig[$field] = $value
        Mock Get-Content { $script:unsupportedConfig | ConvertTo-Json } -ParameterFilter { $LiteralPath -like '*environment.json' }

        { Get-HciEnvironmentContext @inputObject } | Should -Throw '*payload contract requires*'

        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Binds the payload <field> into the ownership contract' -ForEach @(
        @{ field = 'hciVhdxDownloadUri'; value = 'https://example.test/AzLocal2601.vhdx' }
        @{ field = 'hciVhdxSha256'; value = 'b' * 64 }
    ) {
        $script:changedConfig = $context.Config.Clone()
        $script:changedConfig[$field] = $value
        Mock Get-Content { $script:changedConfig | ConvertTo-Json } -ParameterFilter { $LiteralPath -like '*environment.json' }

        $changedContext = Get-HciEnvironmentContext @inputObject

        $changedContext.Tags['avm-contract'] | Should -Not -Be $context.Tags['avm-contract']
    }

    It 'Blocks an old payload contract on the <kind> group without migrating it automatically' -ForEach @(
        @{ kind = 'control' }
        @{ kind = 'foundation' }
        @{ kind = 'image' }
        @{ kind = 'staging' }
    ) {
        Add-Registry -State Idle -ImageState None
        $oldConfig = $context.Config.Clone()
        $oldConfig.Remove('hciVhdxDownloadUri')
        $oldConfig.Remove('hciVhdxSha256')
        $oldContract = Get-HciEnvironmentKey -Value ($oldConfig | ConvertTo-Json -Depth 5 -Compress)
        $oldContract | Should -Not -Be $context.Tags['avm-contract']
        $script:resources[$context.GroupIds[$kind]].tags['avm-contract'] = $oldContract

        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true } |
            Should -Throw '*mismatched ownership/version tag*avm-contract*'

        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        $script:deleted.Count | Should -Be 0
    }

    It 'Rejects an unsupported shared environment region before resource access' -ForEach @(
        @{ unsupportedLocation = 'southeastasia' }
        @{ unsupportedLocation = 'Australia East' }
        @{ unsupportedLocation = 'AUSTRALIAEAST' }
        @{ unsupportedLocation = '' }
    ) {
        $script:unsupportedConfig = $context.Config.Clone()
        $script:unsupportedConfig.location = $unsupportedLocation
        Mock Get-Content { $script:unsupportedConfig | ConvertTo-Json } -ParameterFilter { $LiteralPath -like '*environment.json' }

        { Get-HciEnvironmentContext @inputObject } | Should -Throw '*Unsupported Azure Local environment contract*'

        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
    }

    It 'Rejects a cluster name that Azure Local cannot register under its Active Directory name' {
        $script:unsupportedConfig = $context.Config.Clone()
        $script:unsupportedConfig.clusterName = 'a' * 16
        Mock Get-Content { $script:unsupportedConfig | ConvertTo-Json } -ParameterFilter { $LiteralPath -like '*environment.json' }

        { Get-HciEnvironmentContext @inputObject } | Should -Throw '*cluster name must be at most 15 characters*'

        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
    }

    It 'Accepts a fork-owned tenant and subscription without an upstream publisher identity' {
        $script:current.Subscription.Id = '99999999-9999-9999-9999-999999999999'
        $script:current.Tenant.Id = 'cccccccc-cccc-cccc-cccc-cccccccccccc'
        $inputObject.SubscriptionId = $script:current.Subscription.Id
        $inputObject.TenantId = $script:current.Tenant.Id
        $forkContext = Get-HciEnvironmentContext @inputObject
        $forkContext.Tags['avm-tenant'] | Should -Be $script:current.Tenant.Id
        $forkContext.Tags['avm-subscription'] | Should -Be $script:current.Subscription.Id
        foreach ($id in $forkContext.GroupIds.Values) {
            $id | Should -BeLike "/subscriptions/$($script:current.Subscription.Id)/resourceGroups/*"
        }
    }

    It 'Treats a supplied image as external and excludes gallery groups from ownership' {
        $external = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/external/providers/Microsoft.Compute/galleries/external/images/host/versions/1.2.3'
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external
        $context.ExternalImage | Should -BeTrue
        $context.ImageVersionResourceId | Should -Be $external
        $context.OwnedGroupIds | Should -Be @($context.GroupIds.foundation)
    }

    It 'Rejects an external image inside the recreatable foundation group' {
        $external = $context.ImageVersionResourceId.Replace($context.GroupIds.image, $context.GroupIds.foundation)
        { Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external } |
            Should -Throw '*external read-only image cannot be inside*'
    }

    It 'Treats an explicitly supplied image in the CI gallery group as read-only rather than adopting that group' {
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $context.ImageVersionResourceId
        $context.ExternalImage | Should -BeTrue
        $context.OwnedGroupIds | Should -Be @($context.GroupIds.foundation)
    }

    It 'Rejects mutable image aliases before any resource access' {
        { Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId ($context.ImageVersionResourceId -replace '/versions/[^/]+$', '/versions/latest') } |
            Should -Throw '*immutable*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Rejects invalid external image subscription identities before resource access' -ForEach @(
        @{ imageSubscriptionId = '00000000-0000-0000-0000-000000000000' }
        @{ imageSubscriptionId = '------------------------------------' }
    ) {
        $external = $context.ImageVersionResourceId.Replace($context.SubscriptionId, $imageSubscriptionId)
        { Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external } |
            Should -Throw '*valid, nonempty subscription identity*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Rejects a changed Azure <field> before using the ownership record' -ForEach @(
        @{ field = 'tenant' }
        @{ field = 'subscription' }
        @{ field = 'cloud' }
    ) {
        Add-Registry
        switch ($field) {
            tenant { $script:current.Tenant.Id = '33333333-3333-3333-3333-333333333333' }
            subscription { $script:current.Subscription.Id = '33333333-3333-3333-3333-333333333333' }
            cloud { $script:current.Environment.Name = 'AzureUSGovernment' }
        }
        { Get-HciEnvironmentRegistry -Context $context -RequireOwner } | Should -Throw '*Azure context changed*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Rejects existing groups with incorrect <tag> rather than adopting them' -ForEach @(
        @{ tag = 'lifecycle' }
        @{ tag = 'avm-owner' }
        @{ tag = 'avm-version' }
        @{ tag = 'avm-owned-groups' }
        @{ tag = 'avm-image-key' }
    ) {
        Add-Registry -State Idle
        $script:resources[$context.GroupIds.foundation].tags[$tag] = 'unexpected'
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true } | Should -Throw '*will not be adopted*'
        Should -Invoke Update-AzTag -Times 0 -Exactly
        $script:deleted.Count | Should -Be 0
    }

    It 'Rejects an owned group outside the shared region without adopting or moving it' {
        Add-Registry -State Idle
        $script:resources[$context.GroupIds.foundation].location = 'southeastasia'

        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true } |
            Should -Throw '*registered location*'

        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        $script:deleted.Count | Should -Be 0
    }

    It 'Blocks a second operation during <state> including explicit recreation' -ForEach @(
        @{ state = 'Preparing' }
        @{ state = 'InUse' }
        @{ state = 'Recreating' }
        @{ state = 'TearingDown' }
    ) {
        Add-Registry -State $state
        $script:resources[$context.GroupIds.control].tags['avm-active-owner'] = 'c' * 64
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Recreate:$true -Maintenance:$true } |
            Should -Throw '*not idle*'
        $script:deleted.Count | Should -Be 0
    }

    It 'Never permits provisioning outside dedicated setup, including recreation' -ForEach @(
        @{ recreate = $false }
        @{ recreate = $true }
    ) {
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Recreate:$recreate } |
            Should -Throw '*platform.hci.prepare.yml*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Rejects the <stage> preparation entry point without explicit maintenance before resolving resources' -ForEach @(
        @{ stage = 'Begin' }
        @{ stage = 'ImageObserve' }
        @{ stage = 'FoundationStart' }
        @{ stage = 'FoundationObserve' }
        @{ stage = 'Ready' }
        @{ stage = 'Status' }
        @{ stage = 'Bootstrap' }
        @{ stage = 'Teardown' }
    ) {
        { Invoke-HciPreparationStep -Stage $stage -RepoRootPath $RepoRootPath `
                -ModulePath 'avm/res/azure-stack-hci/logical-network' -TestCase @{} -TestSubscriptionIds '[]' `
                -TenantId $context.TenantId -RunIdentity 'offline' -SourceCommit ('b' * 40) } |
            Should -Throw '*platform.hci.prepare.yml*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Bootstraps the exact persistent control store before fixture mutation' {
        $clientId = [guid] '66666666-6666-6666-6666-666666666666'
        $principalId = [guid] '77777777-7777-7777-7777-777777777777'
        $storageAccountName = 'sthcircpabcdefghijklm'
        Mock Get-HciWorkflowIdentity {
            @{ ClientId = $clientId.ToString('D'); PrincipalId = $principalId.ToString('D') }
        }
        Mock bicep {
            $global:LASTEXITCODE = 0
            @{ resources = @() } | ConvertTo-Json
        }
        Mock New-AzResourceGroupDeployment {
            Add-ReceiptStore
            [pscustomobject] @{
                ProvisioningState = 'Succeeded'
                Outputs = @{ roleAssignmentResourceId = @{ value = $script:receiptRoleAssignmentId } }
            }
        }

        $status = Initialize-HciEnvironmentBootstrap -Context $context -ClientId $clientId `
            -StorageAccountName $storageAccountName -Maintenance:$true

        $status.State | Should -Be 'Down'
        $status.Generation | Should -Match '^[a-f0-9]{32}$'
        $status.StorageAccountResourceId | Should -Match '/storageAccounts/sthcircpabcdefghijklm$'
        $status.StorageContainerResourceId | Should -Match '/containers/hci-operation-receipts$'
        $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -BeNullOrEmpty
        $script:resources[$context.GroupIds.control].tags['avm-image-state'] | Should -Be 'None'
        Should -Invoke New-AzResourceGroup -Times 1 -Exactly
        Should -Invoke New-AzResourceGroupDeployment -Times 1 -Exactly
        Should -Invoke Update-AzTag -Times 0 -Exactly
        foreach ($id in $context.OwnedGroupIds) { $script:resources.ContainsKey($id) | Should -BeFalse }
    }

    It 'Reconciles a validated persistent store idempotently without adopting unrelated resources' {
        $clientId = [guid] '66666666-6666-6666-6666-666666666666'
        $principalId = [guid] '77777777-7777-7777-7777-777777777777'
        Add-Registry -State Down -ImageState None
        Add-ReceiptStore
        Mock Get-HciWorkflowIdentity {
            @{ ClientId = $clientId.ToString('D'); PrincipalId = $principalId.ToString('D') }
        }
        Mock bicep {
            $global:LASTEXITCODE = 0
            @{ resources = @() } | ConvertTo-Json
        }
        Mock New-AzResourceGroupDeployment {
            [pscustomobject] @{
                ProvisioningState = 'Succeeded'
                Outputs = @{ roleAssignmentResourceId = @{ value = $script:receiptRoleAssignmentId } }
            }
        }

        $status = Initialize-HciEnvironmentBootstrap -Context $context -ClientId $clientId `
            -StorageAccountName 'sthcircpabcdefghijklm' -Maintenance:$true

        $status.State | Should -Be 'Down'
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke New-AzResourceGroupDeployment -Times 1 -Exactly
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Refuses a persistent store bound to another identity' {
        Add-Registry -State Down -ImageState None
        Add-ReceiptStore
        Mock Get-HciWorkflowIdentity {
            @{ ClientId = '66666666-6666-6666-6666-666666666666'; PrincipalId = '77777777-7777-7777-7777-777777777777' }
        }
        $script:resources['/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-avm-ci-azure-local-control/providers/Microsoft.Storage/storageAccounts/sthcircpabcdefghijklm'].tags['avm-ci-principal'] = '88888888-8888-8888-8888-888888888888'
        Mock New-AzResourceGroupDeployment { throw 'Wrong identity must not be adopted.' }

        { Initialize-HciEnvironmentBootstrap -Context $context `
                -ClientId ([guid] '66666666-6666-6666-6666-666666666666') `
                -StorageAccountName 'sthcircpabcdefghijklm' -Maintenance:$true } |
            Should -Throw '*bound to another CI identity*'

        Should -Invoke New-AzResourceGroupDeployment -Times 0 -Exactly
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    Context 'Begin provider registration' {
        BeforeEach {
            $key = Get-HciEnvironmentKey -Value $context.SubscriptionId
            $beginInput = @{
                Stage               = 'Begin'
                RepoRootPath        = $RepoRootPath
                ModulePath          = 'avm/res/azure-stack-hci/logical-network'
                TestCase            = @{
                    path                        = 'tests/e2e/defaults'
                    subscriptionIndex           = 0
                    subscriptionKey             = $key
                    environmentConcurrencyGroup = "avm-hci-$key"
                }
                TestSubscriptionIds = ConvertTo-Json -InputObject @(@{
                        id   = $context.SubscriptionId
                        name = 'offline-reserved'
                        tag  = 'Azure Local'
                    }) -Compress
                TenantId            = $context.TenantId
                RunIdentity         = 'offline'
                SourceCommit        = 'b' * 40
                GitHubSecrets       = @{
                    CI_ARB_LOCAL_ADMIN_AND_DEPLOYMENT_USER_PASS = 'offline'
                } | ConvertTo-Json -Compress
                Recreate            = $false
                Maintenance         = $true
            }
        }

        It 'Begins preparation with <recordCount> Registered resource-type rows per namespace' -ForEach @(
            @{ recordCount = 1 }
            @{ recordCount = 2 }
        ) {
            $script:providerRecordCount = $recordCount
            Mock Get-AzResourceProvider {
                for ($index = 0; $index -lt $script:providerRecordCount; $index++) {
                    [pscustomobject]@{
                        ProviderNamespace = $ProviderNamespace
                        RegistrationState = 'Registered'
                        ResourceTypes     = @([pscustomobject]@{ ResourceTypeName = "offline-type-$index" })
                    }
                }
            }
            Add-Registry -State Idle
            Add-ReadyImage

            Invoke-HciPreparationStep @beginInput

            Should -Invoke Get-AzResourceProvider -Times 16 -Exactly
            Should -Invoke Update-AzTag -Times 1 -Exactly -ParameterFilter { $Tag['avm-state'] -ceq 'Preparing' }
            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -BeExactly 'Preparing'
            Should -Invoke New-AzResourceGroup -Times 0 -Exactly
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
        }

        It 'Rejects a partial resource-bridge service principal before preparation' {
            Mock Get-AzResourceProvider {
                [pscustomobject]@{
                    ProviderNamespace = $ProviderNamespace
                    RegistrationState = 'Registered'
                    ResourceTypes     = @([pscustomobject]@{ ResourceTypeName = 'offline-type' })
                }
            }
            Add-Registry -State Idle
            Add-ReadyImage
            $beginInput.GitHubSecrets = @{
                CI_ARB_LOCAL_ADMIN_AND_DEPLOYMENT_USER_PASS = 'offline'
                CI_ARB_DEPLOYMENT_APP_ID                    = 'offline'
            } | ConvertTo-Json -Compress

            { Invoke-HciPreparationStep @beginInput } | Should -Throw '*all three resource-bridge service principal parameters*'

            Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
            Should -Invoke Update-AzTag -Times 0 -Exactly
            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -BeExactly 'Idle'
        }

        It 'Rejects <case> provider output before preparation' -ForEach @(
            @{ case = 'empty'; records = @() }
            @{ case = 'null'; records = @($null) }
            @{ case = 'missing namespace'; records = @([pscustomobject]@{ RegistrationState = 'Registered' }) }
            @{ case = 'missing state'; records = @([pscustomobject]@{ ProviderNamespace = 'Microsoft.Compute' }) }
            @{ case = 'wrong namespace'; records = @([pscustomobject]@{ ProviderNamespace = 'Microsoft.Network'; RegistrationState = 'Registered' }) }
            @{ case = 'wrong namespace case'; records = @([pscustomobject]@{ ProviderNamespace = 'microsoft.compute'; RegistrationState = 'Registered' }) }
            @{ case = 'NotRegistered'; records = @([pscustomobject]@{ ProviderNamespace = 'Microsoft.Compute'; RegistrationState = 'NotRegistered' }) }
            @{ case = 'wrong state case'; records = @([pscustomobject]@{ ProviderNamespace = 'Microsoft.Compute'; RegistrationState = 'registered' }) }
            @{
                case    = 'mixed states'
                records = @(
                    [pscustomobject]@{ ProviderNamespace = 'Microsoft.Compute'; RegistrationState = 'Registered' }
                    [pscustomobject]@{ ProviderNamespace = 'Microsoft.Compute'; RegistrationState = 'NotRegistered' }
                )
            }
            @{
                case    = 'mixed namespaces'
                records = @(
                    [pscustomobject]@{ ProviderNamespace = 'Microsoft.Compute'; RegistrationState = 'Registered' }
                    [pscustomobject]@{ ProviderNamespace = 'Microsoft.Network'; RegistrationState = 'Registered' }
                )
            }
        ) {
            $script:providerRecords = $records
            Mock Get-AzResourceProvider { $script:providerRecords }

            { Invoke-HciPreparationStep @beginInput } | Should -Throw '*Required provider*Microsoft.Compute*not registered*'

            Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            Should -Invoke New-AzResourceGroup -Times 0 -Exactly
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Update-AzTag -Times 0 -Exactly
        }
    }

    It 'Creates only absent registered groups for a read-only external image' {
        $external = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/external/providers/Microsoft.Compute/galleries/external/images/host/versions/1.2.3'
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external
        Add-ReadyImage

        Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true

        Should -Invoke New-AzResourceGroup -Times 2 -Exactly
        $script:resources[$context.GroupIds.control].tags['avm-image-state'] | Should -Be 'Ready'
        $script:deleted.Count | Should -Be 0
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -in @('POST', 'PUT', 'DELETE') }
    }

    It 'Refuses to adopt a pre-existing group when no registry exists' {
        Add-Group $context.GroupIds.foundation $context.Tags
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true } | Should -Throw '*Unregistered resource group*'
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
    }

    It 'Rejects a read-only external image without an Australia East replica before acquiring ownership' {
        $external = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/external/providers/Microsoft.Compute/galleries/external/images/host/versions/1.2.3'
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external
        Add-Registry -State Idle -FoundationState Ready
        Add-ReadyImage
        $image = $script:resources[$external].properties
        $image.publishingProfile.targetRegions[0].name = 'southeastasia'
        $image.replicationStatus.summary[0].region = 'southeastasia'

        { Enter-HciEnvironmentTest -Context $context } | Should -Throw '*platform.hci.prepare.yml*not usable*'

        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Validates an external image before any opted-in recreation or ownership change' {
        $external = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/external/providers/Microsoft.Compute/galleries/external/images/host/versions/1.2.3'
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external
        Add-Registry -State Idle
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Recreate:$true -Maintenance:$true } | Should -Throw '*Cannot verify*'
        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        $script:deleted.Count | Should -Be 0
        $script:resources.ContainsKey($context.GroupIds.foundation) | Should -BeTrue
    }

    It 'Does not interpret an unrelated 404 as proof of resource-group absence' {
        Mock Invoke-AzRestMethod { [pscustomobject] @{ StatusCode = 404; Content = '{"error":{"code":"ResourceNotFound"}}' } }
        { Get-HciArmResource -ResourceId $context.GroupIds.foundation -ApiVersion '2024-03-01' -AllowNotFound } |
            Should -Throw '*Cannot verify*'
    }

    It 'Rejects ambiguous ARM <field> instead of confirming absence' -ForEach @(
        @{ field = 'status' }
        @{ field = 'target' }
        @{ field = 'body' }
        @{ field = 'single-item body' }
    ) {
        $script:response = [pscustomobject] @{
            StatusCode = 404
            Content = @{ error = @{ code = 'ResourceGroupNotFound'; target = $context.GroupIds.foundation } } | ConvertTo-Json
        }
        switch ($field) {
            status { $script:response.StatusCode = @(404, 200) }
            target { $script:response.Content = @{ error = @{ code = 'ResourceGroupNotFound'; target = @($context.GroupIds.foundation, '/unexpected') } } | ConvertTo-Json }
            body { $script:response.Content = '[]' }
            'single-item body' { $script:response.Content = "[$($script:response.Content)]" }
        }
        Mock Invoke-AzRestMethod { $script:response }
        { Get-HciArmResource -ResourceId $context.GroupIds.foundation -ApiVersion '2024-03-01' -AllowNotFound } |
            Should -Throw '*Cannot verify*'
    }

    It 'Reuses ready images without deploying, building or destroying anything' {
        Add-Registry -State Idle
        Add-ReadyImage
        Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true

        $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Preparing'
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Reports missing and registered state without mutation' {
        $missing = Get-HciEnvironmentStatus -Context $context
        $missing.State | Should -Be 'Missing'
        Should -Invoke Update-AzTag -Times 0 -Exactly

        Add-Registry -State Idle -FoundationState Ready
        $status = Get-HciEnvironmentStatus -Context $context
        $status.State | Should -Be 'Idle'
        $status.Generation | Should -Be 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        $status.ImageState | Should -Be 'Ready'
        $status.FoundationState | Should -Be 'Ready'
        Should -Invoke Update-AzTag -Times 0 -Exactly
        $script:deleted.Count | Should -Be 0
    }

    It 'Rotates the generation when <operation> a torn-down external-image environment' -ForEach @(
        @{ operation = 'prepare'; recreate = $false }
        @{ operation = 'recreate'; recreate = $true }
    ) {
        $external = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/external/providers/Microsoft.Compute/galleries/external/images/host/versions/1.2.3'
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external
        Add-Registry -State Down -ImageState Ready -FoundationState None
        foreach ($id in $context.OwnedGroupIds) { $script:resources.Remove($id) }
        Add-ReadyImage

        Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) `
            -Recreate:$recreate -Maintenance:$true

        $tags = $script:resources[$context.GroupIds.control].tags
        $tags['avm-state'] | Should -Be 'Preparing'
        $tags['avm-generation'] | Should -Match '^[a-f0-9]{32}$'
        $tags['avm-generation'] | Should -Not -Be 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        $tags['avm-image-state'] | Should -Be 'Ready'
        $tags['avm-foundation-state'] | Should -Be 'None'
        foreach ($id in $context.OwnedGroupIds) { $script:resources.ContainsKey($id) | Should -BeTrue }
        Should -Invoke New-AzResourceGroup -Times 1 -Exactly
        $script:resources.ContainsKey($external) | Should -BeTrue
    }

    It 'Tears down only an idle environment and records Down' {
        Add-Registry -State Idle -FoundationState Ready
        Add-ReadyImage

        $status = Stop-HciEnvironment -Context $context -Maintenance:$true

        $status.State | Should -Be 'Down'
        $status.ImageState | Should -Be 'None'
        $status.FoundationState | Should -Be 'None'
        $status.Generation | Should -Be 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        @($script:deleted | Sort-Object) | Should -Be @($context.OwnedGroupIds | Sort-Object)
        $script:resources.ContainsKey($context.GroupIds.control) | Should -BeTrue
        Should -Invoke Update-AzTag -Times 2 -Exactly
    }

    It 'Blocks teardown while the environment is not idle' {
        Add-Registry -State InUse -FoundationState Ready
        { Stop-HciEnvironment -Context $context -Maintenance:$true } | Should -Throw '*idle environment*'
        $script:deleted.Count | Should -Be 0
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Deletes only registered owned groups on explicit maintenance and leaves external images untouched' {
        $external = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/external/providers/Microsoft.Compute/galleries/external/images/host/versions/1.2.3'
        $context = Get-HciEnvironmentContext @inputObject -HciHostImageReferenceId $external
        Add-Registry -State Idle
        Add-ReadyImage
        $unregistered = "/subscriptions/$($context.SubscriptionId)/resourceGroups/rg-avm-persistent-hci-image"
        Add-Group $unregistered @{ lifecycle = 'tenant-persistent' }

        Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Recreate:$true -Maintenance:$true

        @($script:deleted) | Should -Be @($context.GroupIds.foundation)
        $script:resources.ContainsKey($external) | Should -BeTrue
        $script:resources.ContainsKey($unregistered) | Should -BeTrue
        $script:resources[$context.GroupIds.control].tags['avm-generation'] | Should -Not -Be 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    }

    It 'Blocks recreation while an owned deployment is running' {
        Add-Registry -State Idle
        Mock Get-AzResourceGroupDeployment { [pscustomobject] @{ ProvisioningState = 'Running' } }
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Recreate:$true -Maintenance:$true } |
            Should -Throw '*unfinished deployment*'
        $script:deleted.Count | Should -Be 0
    }

    It 'Blocks reuse for failed replicas without falling back or automatically deleting resources' {
        Add-Registry -State Idle
        Add-ReadyImage
        $script:resources[$context.ImageVersionResourceId].properties.replicationStatus.summary[0].state = 'Failed'
        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true } | Should -Throw '*not usable*'
        $script:deleted.Count | Should -Be 0
        $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Preparing'
    }

    It 'Checks cluster, Arc node, bridge, custom location, extensions and network rather than existence alone' {
        Add-Registry -FoundationState Ready
        Add-ReadyImage
        Add-ReadyFoundation
        $result = Get-HciEnvironmentReadiness -Context $context
        $result.Foundation.customLocationResourceId | Should -Match '/Microsoft.ExtendedLocation/customLocations/'
        $result.Foundation.kubernetesVersion | Should -Be '1.32.6'
        $result.OwnedResourceIds | Should -HaveCount 4
    }

    It 'Rejects unhealthy or replaced <component>' -ForEach @(
        @{ component = 'cluster' }
        @{ component = 'node' }
        @{ component = 'bridge' }
        @{ component = 'extension' }
        @{ component = 'network' }
        @{ component = 'custom location' }
        @{ component = 'deployment operation' }
    ) {
        Add-Registry -FoundationState Ready
        Add-ReadyImage
        Add-ReadyFoundation
        $foundation = $script:resources[$context.DeploymentResourceId].properties.outputs.environment.value
        $customLocation = $script:resources[$foundation.customLocationResourceId]
        switch ($component) {
            cluster { $script:resources[$foundation.clusterResourceId].properties.connectivityStatus = 'NotConnected' }
            node { $script:resources["$($context.GroupIds.foundation)/providers/Microsoft.HybridCompute/machines/hcinode1"].properties.status = 'Disconnected' }
            bridge { $script:resources[$customLocation.properties.hostResourceId].properties.status = 'Connecting' }
            extension { $script:resources[$customLocation.properties.clusterExtensionIds[0]].properties.provisioningState = 'Failed' }
            network { $script:resources[$foundation.logicalNetworkResourceId].properties.vmSwitchName = 'wrong-switch' }
            'custom location' { $customLocation.properties.hostResourceId = '/subscriptions/other/resourceGroups/unowned/providers/Microsoft.ResourceConnector/appliances/unowned' }
            'deployment operation' { $script:resources[$context.DeploymentResourceId].properties.correlationId = '55555555-5555-5555-5555-555555555555' }
        }
        { Get-HciEnvironmentReadiness -Context $context } | Should -Throw
        $script:deleted.Count | Should -Be 0
    }

    It 'Writes a runner-local nonsecret projection from read-only readiness validation' {
        Add-Registry -State Idle -FoundationState Ready
        Add-ReadyImage
        Add-ReadyFoundation
        $runnerTemp = Join-Path $TestDrive 'projection'
        $null = New-Item -ItemType Directory -Path $runnerTemp
        $outputPath = Join-Path $runnerTemp 'azure-local.json'
        $key = Get-HciEnvironmentKey -Value $context.SubscriptionId
        $projectionInput = @{
            RepoRootPath = $RepoRootPath
            SubscriptionKey = $key
            TestSubscriptionIds = ConvertTo-Json -InputObject @(@{
                    id = $context.SubscriptionId
                    name = 'reserved'
                    tag = 'Azure Local'
                }) -Compress
            TenantId = $context.TenantId
            Owner = $context.Owner
            OutputPath = $outputPath
        }

        $projection = Write-HciEnvironmentProjection @projectionInput
        $persisted = Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable

        $projection.schemaVersion | Should -Be 1
        $persisted | ConvertTo-Json -Depth 10 -Compress | Should -Be ($projection | ConvertTo-Json -Depth 10 -Compress)
        $persisted.state | Should -Be 'Idle'
        $persisted.generation | Should -Be 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        $persisted.customLocationResourceId | Should -Match '/Microsoft.ExtendedLocation/customLocations/'
        $persisted.vSwitchName | Should -Be 'ConvergedSwitch(ManagementCompute)'
        $persisted.kubernetesVersion | Should -Be '1.32.6'
        ($persisted | ConvertTo-Json -Depth 10) | Should -Not -Match 'activeOwner|keyVaultName|credential'
        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Refuses a projection for a non-idle fixture or an existing output file' {
        Add-Registry -State Down -FoundationState None -ImageState Ready
        $runnerTemp = Join-Path $TestDrive 'projection-errors'
        $null = New-Item -ItemType Directory -Path $runnerTemp
        $outputPath = Join-Path $runnerTemp 'azure-local.json'
        $key = Get-HciEnvironmentKey -Value $context.SubscriptionId
        $projectionInput = @{
            RepoRootPath = $RepoRootPath
            SubscriptionKey = $key
            TestSubscriptionIds = ConvertTo-Json -InputObject @(@{
                    id = $context.SubscriptionId
                    name = 'reserved'
                    tag = 'Azure Local'
                }) -Compress
            TenantId = $context.TenantId
            Owner = $context.Owner
            OutputPath = $outputPath
        }

        { Write-HciEnvironmentProjection @projectionInput } | Should -Throw '*not idle and validated*'
        Test-Path -LiteralPath $outputPath | Should -BeFalse

        $script:resources[$context.GroupIds.control].tags['avm-state'] = 'Idle'
        $script:resources[$context.GroupIds.control].tags['avm-foundation-state'] = 'Ready'
        Add-ReadyImage
        Add-ReadyFoundation
        Set-Content -LiteralPath $outputPath -Value '{}'
        { Write-HciEnvironmentProjection @projectionInput } | Should -Throw '*new runner-local file*'
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Keeps cluster-under-test consumers image-only and does not require or return a persistent cluster' {
        Add-Registry -State Idle
        Add-ReadyImage
        $result = Enter-HciEnvironmentTest -Context $context -ImageOnly:$true
        $result.Foundation | Should -BeNullOrEmpty
        $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'InUse'
        $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -Be $context.Owner
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Path -like '*Microsoft.AzureStackHCI/clusters*' }
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Rejects a missing or <state> environment with setup guidance and no provisioning or ownership changes' -ForEach @(
        @{ state = 'missing' }
        @{ state = 'Preparing' }
        @{ state = 'Recreating' }
        @{ state = 'InUse' }
        @{ state = 'Failed' }
        @{ state = 'image not ready' }
        @{ state = 'foundation not ready' }
        @{ state = 'stale ownership' }
        @{ state = 'incompatible contract' }
        @{ state = 'missing Kubernetes readiness' }
    ) {
        if ($state -ne 'missing') {
            Add-Registry -State Idle -FoundationState Ready
            Add-ReadyImage
            Add-ReadyFoundation
            $tags = $script:resources[$context.GroupIds.control].tags
            switch ($state) {
                'image not ready' { $tags['avm-image-state'] = 'Failed' }
                'foundation not ready' { $tags['avm-foundation-state'] = 'Provisioned' }
                'stale ownership' { $tags['avm-active-owner'] = 'c' * 64 }
                'incompatible contract' { $tags['avm-contract'] = 'unexpected' }
                'missing Kubernetes readiness' { $tags['avm-kubernetes-version'] = '' }
                default { $tags['avm-state'] = $state }
            }
        }

        { Enter-HciEnvironmentTest -Context $context } | Should -Throw '*platform.hci.prepare.yml*'

        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Does not refresh Kubernetes readiness while the environment is <state>' -ForEach @(
        @{ state = 'Idle' }
        @{ state = 'InUse' }
    ) {
        Add-Registry -State $state -FoundationState Ready
        { Get-HciEnvironmentReadiness -Context $context -RefreshKubernetes } |
            Should -Throw '*setup ownership*'
        Should -Invoke Update-AzTag -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Refuses to release test ownership without confirmed cleanup' {
        Add-Registry -State InUse
        { Exit-HciEnvironment -Context $context } | Should -Throw '*confirmed test cleanup*'
        Should -Invoke Update-AzTag -Times 0 -Exactly
    }

    It 'Retains ownership through test cleanup and releases only afterward' {
        Add-Registry -State Idle -FoundationState Ready
        Add-ReadyImage
        Add-ReadyFoundation
        $result = Enter-HciEnvironmentTest -Context $context
        $result.ImageVersionResourceId | Should -Be $context.ImageVersionResourceId
        $result.Foundation.customLocationResourceId | Should -Match '/Microsoft.ExtendedLocation/customLocations/'
        $result.Foundation.kubernetesVersion | Should -Be '1.32.6'
        $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'InUse'
        $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -Be $context.Owner
        Should -Invoke Update-AzTag -Times 1 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
        Exit-HciEnvironment -Context $context -CleanupConfirmed:$true
        $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Idle'
        $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -BeNullOrEmpty
    }

    It 'Releases completed manual setup for an independently owned test without preparing again' {
        Add-Registry -FoundationState Ready
        Add-ReadyImage
        Add-ReadyFoundation
        Exit-HciEnvironment -Context $context -Maintenance:$true
        $inputObject.Owner = 'd' * 64
        $consumerContext = Get-HciEnvironmentContext @inputObject

        $result = Enter-HciEnvironmentTest -Context $consumerContext

        $result.ImageVersionResourceId | Should -Be $context.ImageVersionResourceId
        $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'InUse'
        $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -Be $consumerContext.Owner
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Does not submit a foundation for a pending image or missing existing credentials' {
        Add-Registry -ImageState Running
        { Start-HciEnvironmentFoundation -Context $context -Parameters @{} } | Should -Throw '*completed, recorded image*'
        $script:resources[$context.GroupIds.control].tags['avm-image-state'] = 'Ready'
        Add-ReadyImage
        { Start-HciEnvironmentFoundation -Context $context -Parameters @{} } | Should -Throw '*existing CI identity/credential*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Keeps one accepted build protected through <failure> receipt handling' -ForEach @(
        @{ failure = 'none' }, @{ failure = 'Replace' }, @{ failure = 'AcceptedRead' }, @{ failure = 'Publish' }
    ) {
        Add-ReceiptStore
        $script:receiptFailure = $failure
        $script:fullOperationPath = "/subscriptions/$($context.SubscriptionId)/providers/Microsoft.VirtualMachineImages/locations/$($context.Config.location)/operations/55555555-5555-5555-5555-555555555555?api-version=2025-10-01&t=t&c=$('x' * 4300)&s=private-test-signature&h=h"
        if ($failure -eq 'Publish') {
            Mock Update-AzTag { throw 'Offline receipt publication failure.' } -ParameterFilter { $Tag.ContainsKey('avm-image-receipt') }
        }
        Mock New-AzSubscriptionDeployment {
            $Location | Should -BeExactly $context.Config.location
            $TemplateParameterObject.location | Should -BeExactly $context.Config.location
            $TemplateParameterObject.buildLocation | Should -BeExactly $context.Config.location
            $TemplateParameterObject.replicationRegions | Should -Be @($context.Config.location)
            $TemplateParameterObject.hciVhdxDownloadUri | Should -BeExactly $context.Config.hciVhdxDownloadUri
            $TemplateParameterObject.hciVhdxSha256 | Should -BeExactly $context.Config.hciVhdxSha256
            $TemplateParameterObject.useScopedContributorRole | Should -BeTrue
            $TemplateParameterObject.createResourceGroup | Should -BeFalse
            $TemplateParameterObject.tags.lifecycle | Should -Be 'tenant-persistent'
            $script:resources[$context.ImageTemplateResourceId] = @{
                id = $context.ImageTemplateResourceId
                location = $context.Config.location
                properties = @{ lastRunStatus = @{ startTime = '2025-01-01T00:00:00Z'; runState = 'Succeeded' } }
            }
            [pscustomobject] @{ ProvisioningState = 'Succeeded' }
        }
        Mock Invoke-AzRestMethod {
            $script:resources[$context.ImageTemplateResourceId].properties.lastRunStatus = @{
                startTime = [datetimeoffset]::UtcNow.ToString('o')
                runState = 'Running'
            }
            $response = [System.Net.Http.HttpResponseMessage]::new()
            try {
                $response.Headers.Add('Azure-AsyncOperation', "https://management.azure.com$script:fullOperationPath")
                [pscustomobject] @{
                    StatusCode = 202
                    Content = '{}'
                    Headers = $response.Headers
                }
            } finally {
                $response.Dispose()
            }
        } -ParameterFilter { $Method -eq 'POST' }

        $startInput = @{
            Context = $context
            SourceCommit = 'b' * 40
            Maintenance = $true
            RunIdentity = 'offline/repository|123|1'
            ReceiptStorageAccountName = 'sthcircpabcdefghijklm'
        }
        if ($failure -ne 'none') {
            { Start-HciEnvironmentPreparation @startInput } | Should -Throw '*Offline*receipt*failure*'
            $tags = $script:resources[$context.GroupIds.control].tags
            $tags['avm-image-state'] | Should -Be 'Submitting'
            $deadline = $tags['avm-image-deadline']
            { Start-HciEnvironmentPreparation @startInput } | Should -Throw '*not idle*'
            $tags['avm-image-deadline'] | Should -Be $deadline
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
            Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
            return
        }
        Start-HciEnvironmentPreparation @startInput

        $tags = $script:resources[$context.GroupIds.control].tags
        $tags['avm-image-state'] | Should -Be 'Running'
        $tags['avm-image-operation'] | Should -Be '55555555-5555-5555-5555-555555555555'
        $tags['avm-image-receipt'] | Should -Match '^[a-f0-9]{64}$'
        $tags['avm-image-etag'] | Should -BeExactly '"0xABC2"'
        ($tags | ConvertTo-Json) | Should -Not -Match 'api-version|management.azure.com|private-test-signature'
        $deadline = $tags['avm-image-deadline']
        $freshContext = Get-HciEnvironmentContext @inputObject
        Add-ReadyImage
        $script:resources[$context.ImageTemplateResourceId].properties.lastRunStatus.runState = 'Succeeded'
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = 200; Content = '{"status":"Succeeded"}' }
        } -ParameterFilter { $Method -eq 'GET' -and $Path -like '*/Microsoft.VirtualMachineImages/locations/*/operations/*' }

        Wait-HciEnvironmentImage -Context $freshContext -SourceCommit ('b' * 40) `
            -RunIdentity 'offline/repository|123|1' -ReceiptStorageAccountName 'sthcircpabcdefghijklm'

        $tags['avm-image-state'] | Should -Be 'Ready'
        $tags['avm-image-deadline'] | Should -Be $deadline
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and
            $Path -ceq $script:fullOperationPath
        }
    }

    It 'Stops before image deployment or POST when private receipt <operation> fails' -ForEach @(
        @{ operation = 'Create' }, @{ operation = 'Read' }, @{ operation = 'Conflict' }
    ) {
        Add-Registry -State Idle -ImageState None
        Add-ReceiptStore
        $script:receiptFailure = $operation
        if ($operation -eq 'Conflict') { $script:receiptBlob = '{"state":"existing"}' }

        { Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true `
                -RunIdentity 'offline/repository|123|1' -ReceiptStorageAccountName 'sthcircpabcdefghijklm' } |
            Should -Throw '*Offline receipt*'

        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly
        $script:resources[$context.GroupIds.control].tags['avm-image-state'] | Should -Be 'Submitting'
    }

    It 'Requires a dedicated receipt binding only when a new owned image is needed' {
        Add-Registry -State Idle -ImageState None
        Add-ReadyImage

        Start-HciEnvironmentPreparation -Context $context -SourceCommit ('b' * 40) -Maintenance:$true

        $script:resources[$context.GroupIds.control].tags['avm-image-state'] | Should -Be 'Ready'
        Should -Invoke Invoke-HciImageReceiptRequest -Times 0 -Exactly
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly
    }

    It 'Rejects <change> receipt storage before any data-plane request' -ForEach @(
        @{ change = 'a different returned account'; kind = 'identity' }
        @{ change = 'foreign ownership'; kind = 'owner' }
        @{ change = 'a wrong tenant'; kind = 'tenant' }
        @{ change = 'a missing CI principal'; kind = 'principal' }
        @{ change = 'a different region'; kind = 'region' }
        @{ change = 'anonymous account access'; kind = 'anonymous' }
        @{ change = 'Shared Key authorization'; kind = 'key' }
        @{ change = 'an unexpected blob endpoint'; kind = 'endpoint' }
        @{ change = 'anonymous container access'; kind = 'container' }
        @{ change = 'untracked versions'; kind = 'versions' }
        @{ change = 'untracked soft-delete copies'; kind = 'softDelete' }
    ) {
        Add-Registry -ImageState Submitting
        Add-ReceiptStore
        $script:resources[$context.GroupIds.control].tags['avm-image-deadline'] = [datetimeoffset]::UtcNow.AddMinutes(30).ToString('o')
        $accountId = "$($context.GroupIds.control)/providers/Microsoft.Storage/storageAccounts/sthcircpabcdefghijklm"
        $account = $script:resources[$accountId]
        switch ($kind) {
            identity { $account.id = "$accountId-other" }
            owner { $account.tags['avm-owner'] = 'another/repository' }
            tenant { $account.tags['avm-tenant'] = '99999999-9999-9999-9999-999999999999' }
            principal { $account.tags.Remove('avm-ci-principal') }
            region { $account.location = 'eastus' }
            anonymous { $account.properties.allowBlobPublicAccess = $true }
            key { $account.properties.allowSharedKeyAccess = $true }
            endpoint { $account.properties.primaryEndpoints.blob = 'https://another.blob.core.windows.net/' }
            container { $script:resources["$accountId/blobServices/default/containers/hci-operation-receipts"].properties.publicAccess = 'Blob' }
            versions { $script:resources["$accountId/blobServices/default"].properties.isVersioningEnabled = $true }
            softDelete { $script:resources["$accountId/blobServices/default"].properties.deleteRetentionPolicy.enabled = $true }
        }

        $expected = $kind -eq 'identity' ? '*Cannot verify Azure Local resource*' : '*HCI receipt*'
        { Get-HciImageReceiptContext -Context $context -SourceCommit ('b' * 40) `
                -RunIdentity 'offline/repository|123|1' -StorageAccountName 'sthcircpabcdefghijklm' } | Should -Throw $expected

        Should -Invoke Invoke-HciImageReceiptRequest -Times 0 -Exactly
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly
    }

    Context 'Dedicated test consumer boundary' {
        BeforeEach {
            $runnerTemp = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            $null = New-Item -ItemType Directory -Path $runnerTemp
            $pool = @(
                @{ id = '33333333-3333-3333-3333-333333333333'; name = 'ordinary' }
                @{ id = $context.SubscriptionId; name = 'reserved'; tag = 'Azure Local' }
            ) | ConvertTo-Json -Compress
            $key = Get-HciEnvironmentKey -Value $context.SubscriptionId
            $consumerInput = @{
                RepoRootPath = $RepoRootPath
                ModulePath = 'avm/res/azure-stack-hci/logical-network'
                TestCase = @{
                    subscriptionIndex = 1
                    subscriptionKey = $key
                    environmentConcurrencyGroup = "avm-hci-$key"
                    path = 'tests/e2e/defaults/main.test.bicep'
                    e2eIgnore = $false
                }
                TestSubscriptionIds = $pool
                TenantId = $context.TenantId
                RunIdentity = 'offline/repository|123|1'
                RunnerTempPath = $runnerTemp
                GitHubSecrets = '{"CI_ARBLOCALADMINANDDEPLOYMENTUSERPASS":"credential-not-saved"}'
            }
            $script:consumerDefinitions = @{
                resourceGroupName = @{ type = 'string' }
                hciHostImageReferenceId = @{ type = 'secureString' }
                preparedHciEnvironment = @{ type = 'object' }
                arbLocalAdminAndDeploymentUserPass = @{ type = 'secureString' }
            }
            Mock bicep {
                $global:LASTEXITCODE = 0
                @{ parameters = $script:consumerDefinitions } | ConvertTo-Json -Depth 5
            }
            Mock Start-HciEnvironmentPreparation { throw 'Consumer attempted setup.' }
            Mock Start-HciEnvironmentFoundation { throw 'Consumer attempted foundation provisioning.' }
        }

        It 'Constructs ordinary parameter/protection data from a ready environment without saving credentials' {
            Add-Registry -State Idle -FoundationState Ready
            Add-ReadyImage
            Add-ReadyFoundation

            $messages = @(Initialize-HciTestConsumer @consumerInput 4>&1)
            $dataFile = Join-Path $runnerTemp 'avm-module-deployment-data.json'
            $contextFile = Join-Path $runnerTemp 'avm-hci-test-context.json'
            $data = Get-ModuleDeploymentData -FilePath $dataFile
            $savedContext = Get-Content $contextFile -Raw | ConvertFrom-Json -AsHashtable
            $prepared = $data.ParameterOverrides.preparedHciEnvironment | ConvertFrom-Json
            $prepared.customLocationResourceId | Should -Be "$($context.GroupIds.foundation)/providers/Microsoft.ExtendedLocation/customLocations/$($context.Config.customLocationName)"
            $prepared.kubernetesVersion | Should -Be '1.32.6'
            $data.ParameterOverrides.hciHostImageReferenceId | Should -Be $context.ImageVersionResourceId
            $data.ParameterOverrides.resourceGroupName | Should -Be "dep-avm-hci-$($savedContext.Owner.Substring(0, 20))"
            $savedContext.TestResourceGroupId | Should -Be "/subscriptions/$($context.SubscriptionId)/resourceGroups/$($data.ParameterOverrides.resourceGroupName)"
            $data.ProtectedResourceIds | Should -Be (@($context.GroupIds.control) + $context.OwnedGroupIds + @($context.ImageVersionResourceId))
            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'InUse'
            ((Get-Content $dataFile, $contextFile -Raw) -join '') | Should -Not -Match 'credential-not-saved'
            ($messages | Out-String) | Should -Not -Match 'credential-not-saved'
            Should -Invoke Start-HciEnvironmentPreparation -Times 0 -Exactly
            Should -Invoke Start-HciEnvironmentFoundation -Times 0 -Exactly
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }

            Complete-HciTestConsumer -ContextFile $contextFile -DeploymentOutcome success -CleanupStatus confirmed

            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Idle'
            $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -BeNullOrEmpty
        }

        It 'Leaves the cluster under test separate from the shared foundation' {
            $consumerInput.ModulePath = 'avm/res/azure-stack-hci/cluster'
            $script:consumerDefinitions.Remove('preparedHciEnvironment')
            Add-Registry -State Idle
            Add-ReadyImage

            Initialize-HciTestConsumer @consumerInput

            $data = Get-ModuleDeploymentData -FilePath (Join-Path $runnerTemp 'avm-module-deployment-data.json')
            $data.ParameterOverrides.ContainsKey('preparedHciEnvironment') | Should -BeFalse
            $data.ParameterOverrides.hciHostImageReferenceId | Should -Be $context.ImageVersionResourceId
            Should -Invoke Start-HciEnvironmentFoundation -Times 0 -Exactly
        }

        It 'Fails a <state> environment without provisioning or acquiring ownership' -ForEach @(
            @{ state = 'Missing' }, @{ state = 'Preparing' }, @{ state = 'InUse' }, @{ state = 'Recreating' }, @{ state = 'Unready' }
        ) {
            if ($state -ne 'Missing') {
                if ($state -eq 'Unready') { Add-Registry -State Idle -ImageState Running -FoundationState Ready }
                else { Add-Registry -State $state -FoundationState Ready }
            }
            { Initialize-HciTestConsumer @consumerInput } | Should -Throw '*dedicated setup workflow*'
            Should -Invoke Update-AzTag -Times 0 -Exactly
            Should -Invoke Start-HciEnvironmentPreparation -Times 0 -Exactly
            Should -Invoke Start-HciEnvironmentFoundation -Times 0 -Exactly
            Should -Invoke New-AzResourceGroup -Times 0 -Exactly
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Test-Path (Join-Path $runnerTemp 'avm-module-deployment-data.json') | Should -BeFalse
        }

        It 'Retains ownership for <case>' -ForEach @(
            @{ case = 'failed deployment despite confirmed cleanup'; outcome = 'failure'; cleanup = 'confirmed' }
            @{ case = 'skipped deployment'; outcome = 'skipped'; cleanup = 'confirmed' }
            @{ case = 'cancelled deployment'; outcome = 'cancelled'; cleanup = 'confirmed' }
            @{ case = 'failed cleanup'; outcome = 'failure'; cleanup = 'unknown' }
            @{ case = 'best-effort cleanup'; outcome = 'success'; cleanup = 'unconfirmed' }
            @{ case = 'unknown cleanup'; outcome = 'success'; cleanup = 'unknown' }
            @{ case = 'zero submissions'; outcome = 'failure'; cleanup = 'not-submitted' }
            @{ case = 'missing cleanup output'; outcome = 'success'; cleanup = '' }
        ) {
            Add-Registry -State Idle -FoundationState Ready
            Add-ReadyImage
            Add-ReadyFoundation
            Initialize-HciTestConsumer @consumerInput

            { Complete-HciTestConsumer -ContextFile (Join-Path $runnerTemp 'avm-hci-test-context.json') `
                    -DeploymentOutcome $outcome -CleanupStatus $cleanup } | Should -Throw '*ownership is retained*'

            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'InUse'
            Should -Invoke Update-AzTag -Times 1 -Exactly
        }

        It 'Retains ownership when the exact disposable group remains after reported cleanup' {
            Add-Registry -State Idle -FoundationState Ready
            Add-ReadyImage
            Add-ReadyFoundation
            Initialize-HciTestConsumer @consumerInput
            $contextFile = Join-Path $runnerTemp 'avm-hci-test-context.json'
            $savedContext = Get-Content $contextFile -Raw | ConvertFrom-Json -AsHashtable
            Add-Group $savedContext.TestResourceGroupId @{}

            { Complete-HciTestConsumer -ContextFile $contextFile -DeploymentOutcome success -CleanupStatus confirmed } |
                Should -Throw '*not confirmed absent*'

            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'InUse'
            Should -Invoke Update-AzTag -Times 1 -Exactly
        }

        It 'Rejects per-run group overrides and incorrect shared locks before acquisition' {
            $consumerInput.GitHubVariables = '{"CI_RESOURCEGROUPNAME":"some-other-group"}'
            { Initialize-HciTestConsumer @consumerInput } | Should -Throw '*cannot override their per-run disposable resource group*'
            $consumerInput.GitHubVariables = '{}'
            $consumerInput.TestCase.environmentConcurrencyGroup = 'not-the-shared-lock'
            { Initialize-HciTestConsumer @consumerInput } | Should -Throw '*canonical shared-environment lock*'
            Should -Invoke Update-AzTag -Times 0 -Exactly
        }
    }

    Context 'Reserved deployment history ownership' {
        BeforeEach {
            $key = Get-HciEnvironmentKey -Value $context.SubscriptionId
            $historyInput = @{
                RepoRootPath = $RepoRootPath
                TestCase = @{ subscriptionIndex = 0; subscriptionKey = $key; environmentConcurrencyGroup = "avm-hci-$key" }
                TestSubscriptionIds = ConvertTo-Json -InputObject @(@{ id = $context.SubscriptionId; name = 'reserved'; tag = 'Azure Local' }) -Compress
                TenantId = $context.TenantId
                RunIdentity = 'offline/repository|history|1'
            }
            $script:historyRequested = $false
            $script:historyRecordId = "/subscriptions/$($context.SubscriptionId)/providers/Microsoft.Resources/deployments/recent-success"
            Mock Get-AzAccessToken { @{ Token = ConvertTo-SecureString 'offline-history-token' -AsPlainText -Force } }
            Mock Invoke-RestMethod {
                if ($Method -eq 'GET') {
                    return [pscustomobject] @{
                        value = @([pscustomobject] @{
                            name = 'recent-success'
                            properties = @{ provisioningState = 'Succeeded'; timestamp = [datetime]::UtcNow.ToString('o') }
                        })
                    }
                }
                if ($Method -eq 'POST') {
                    if ($script:resources.ContainsKey($context.GroupIds.control)) {
                        if ($script:resources[$context.GroupIds.control].tags['avm-state'] -cne 'Down') {
                            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Preparing'
                            $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -Not -BeNullOrEmpty
                        }
                    }
                    $script:historyRequested = $true
                    return [pscustomobject] @{ responses = @() }
                }
                throw 'Unexpected offline history request.'
            }
            Mock Invoke-AzRestMethod {
                $script:historyRequested | Should -BeTrue
                @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }
            } -ParameterFilter { $Method -eq 'GET' -and $Path -like "$($script:historyRecordId)?*" }
        }

        It 'Still cleans recent successful history when the environment is idle and releases only after confirmed deletion' {
            Add-Registry -State Idle -FoundationState Ready

            Invoke-HciDeploymentHistoryCleanup @historyInput

            $script:historyRequested | Should -BeTrue
            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Idle'
            $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -BeNullOrEmpty
            Should -Invoke Update-AzTag -Times 2 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path -like "$($script:historyRecordId)?*" }
        }

        It 'Cleans history in Down state without reacquiring or deleting fixture ownership' {
            Add-Registry -State Down -ImageState None -FoundationState None
            foreach ($id in $context.OwnedGroupIds) { $script:resources.Remove($id) }

            Invoke-HciDeploymentHistoryCleanup @historyInput

            $script:historyRequested | Should -BeTrue
            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Down'
            $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -BeNullOrEmpty
            Should -Invoke Update-AzTag -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path -like "$($script:historyRecordId)?*" }
        }

        It 'Keeps a subscription without a registered environment or owned groups eligible without creating a registry' {
            Invoke-HciDeploymentHistoryCleanup @historyInput
            $script:historyRequested | Should -BeTrue
            Should -Invoke New-AzResourceGroup -Times 0 -Exactly
            Should -Invoke Update-AzTag -Times 0 -Exactly
        }

        It 'Preserves successful deployment evidence while state is <state>' -ForEach @(
            @{ state = 'Preparing' }, @{ state = 'InUse' }, @{ state = 'Recreating' }, @{ state = 'Unknown' }
        ) {
            Add-Registry -State $state -FoundationState Ready
            { Invoke-HciDeploymentHistoryCleanup @historyInput } | Should -Throw '*teardown evidence is preserved*'
            $script:historyRequested | Should -BeFalse
            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
            Should -Invoke Update-AzTag -Times 0 -Exactly
        }

        It 'Preserves evidence for an idle-looking registry with an outstanding owner' {
            Add-Registry -State Idle -FoundationState Ready
            $script:resources[$context.GroupIds.control].tags['avm-active-owner'] = 'failed-cleanup-owner'
            { Invoke-HciDeploymentHistoryCleanup @historyInput } | Should -Throw '*teardown evidence is preserved*'
            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        }

        It 'Preserves unregistered resource evidence instead of treating missing control state as idle' {
            Add-Group $context.GroupIds.foundation $context.Tags
            { Invoke-HciDeploymentHistoryCleanup @historyInput } | Should -Throw '*Unregistered shared resources*'
            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        }

        It 'Retains maintenance ownership when accepted history deletion is still unconfirmed' {
            Add-Registry -State Idle -FoundationState Ready
            Mock Invoke-AzRestMethod {
                @{ StatusCode = 200; Content = (@{ id = $script:historyRecordId; properties = @{ provisioningState = 'Deleting' } } | ConvertTo-Json -Compress) }
            } -ParameterFilter { $Method -eq 'GET' -and $Path -like "$($script:historyRecordId)?*" }

            { Invoke-HciDeploymentHistoryCleanup @historyInput } | Should -Throw '*still exists after cleanup*'

            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Preparing'
            $script:resources[$context.GroupIds.control].tags['avm-active-owner'] | Should -Not -BeNullOrEmpty
            Should -Invoke Update-AzTag -Times 1 -Exactly
        }

        It 'Retains maintenance ownership when the history response cannot prove its inventory' {
            Add-Registry -State Idle -FoundationState Ready
            Mock Invoke-RestMethod { [pscustomobject] @{ value = $null } } -ParameterFilter { $Method -eq 'GET' }

            { Invoke-HciDeploymentHistoryCleanup @historyInput } | Should -Throw '*completion is unconfirmed*'

            $script:historyRequested | Should -BeFalse
            $script:resources[$context.GroupIds.control].tags['avm-state'] | Should -Be 'Preparing'
            Should -Invoke Update-AzTag -Times 1 -Exactly
        }
    }

    It 'Submits one foundation with a recorded correlation ID and reuses it after readiness' {
        Add-Registry
        Add-ReadyImage
        Mock bicep {
            $global:LASTEXITCODE = 0
            '{"$schema":"https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#","contentVersion":"1.0.0.0","resources":[]}'
        }
        $parameters = @{
            arbLocalAdminAndDeploymentUserPass = ConvertTo-SecureString 'offline-password-placeholder' -AsPlainText -Force
            arbDeploymentAppId = '66666666-6666-6666-6666-666666666666'
            arbDeploymentSPObjectId = '77777777-7777-7777-7777-777777777777'
            arbDeploymentServicePrincipalSecret = ConvertTo-SecureString 'offline-secret-placeholder' -AsPlainText -Force
            builtInServicePrincipalObjectId = '88888888-8888-8888-8888-888888888888'
        }
        Mock Invoke-AzRestMethod {
            $payloadObject = $Payload | ConvertFrom-Json -AsHashtable
            $payloadObject.properties.parameters.location.value | Should -BeExactly $context.Config.location
            $payloadObject.properties.parameters.hciHostImageReferenceId.value | Should -Be $context.ImageVersionResourceId
            $payloadObject.properties.parameters.generation.value | Should -Be 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
            $payloadObject.properties.parameters.arbDeploymentAppId.value | Should -BeExactly '66666666-6666-6666-6666-666666666666'
            $payloadObject.properties.parameters.arbDeploymentServicePrincipalSecret.value | Should -BeExactly 'offline-secret-placeholder'
            Add-ReadyFoundation
            $script:resources[$context.DeploymentResourceId].properties.provisioningState = 'Running'
            [pscustomobject] @{ StatusCode = 201; Content = $script:resources[$context.DeploymentResourceId] | ConvertTo-Json -Depth 20 }
        } -ParameterFilter { $Method -eq 'PUT' }

        Start-HciEnvironmentFoundation -Context $context -Parameters $parameters

        $tags = $script:resources[$context.GroupIds.control].tags
        $tags['avm-foundation-state'] | Should -Be 'Running'
        $tags['avm-foundation-operation'] | Should -Be '44444444-4444-4444-4444-444444444444'
        $deadline = $tags['avm-foundation-deadline']
        Mock Get-AzResourceGroupDeployment {
            # Matches PSResourceGroupDeployment, which has no Id property.
            [pscustomobject] @{
                ResourceGroupName = $script:hciContext.Config.foundationResourceGroupName
                DeploymentName = $script:hciContext.Config.deploymentName
                ProvisioningState = 'Succeeded'
                CorrelationId = '44444444-4444-4444-4444-444444444444'
                Error = $null
                Outputs = @{}
            }
        }
        Wait-HciEnvironmentFoundation -Context $context
        $tags['avm-foundation-state'] | Should -Be 'Provisioned'
        $tags['avm-foundation-deadline'] | Should -Be $deadline
        Start-HciEnvironmentFoundation -Context $context -Parameters @{}
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Submits a foundation without the optional resource-bridge service principal' {
        Add-Registry
        Add-ReadyImage
        Mock bicep {
            $global:LASTEXITCODE = 0
            '{"$schema":"https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#","contentVersion":"1.0.0.0","resources":[]}'
        }
        Mock Invoke-AzRestMethod {
            $script:foundationParameters = ($Payload | ConvertFrom-Json -AsHashtable).properties.parameters
            Add-ReadyFoundation
            $script:resources[$context.DeploymentResourceId].properties.provisioningState = 'Running'
            [pscustomobject] @{ StatusCode = 201; Content = $script:resources[$context.DeploymentResourceId] | ConvertTo-Json -Depth 20 }
        } -ParameterFilter { $Method -eq 'PUT' }

        Start-HciEnvironmentFoundation -Context $context -Parameters @{
            arbLocalAdminAndDeploymentUserPass = ConvertTo-SecureString 'offline-password-placeholder' -AsPlainText -Force
            builtInServicePrincipalObjectId    = '88888888-8888-8888-8888-888888888888'
        }

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'PUT' }
        $script:foundationParameters.arbLocalAdminAndDeploymentUserPass.value | Should -BeExactly 'offline-password-placeholder'
        @($script:foundationParameters.Keys | Where-Object { $_ -like 'arbDeployment*' }) | Should -BeNullOrEmpty
    }

    It 'Rejects <case> before submitting a foundation' -ForEach @(
        @{ case = 'a partial resource-bridge service principal'; name = 'arbDeploymentAppId'; value = $null; expectedError = '*all three resource-bridge service principal parameters*' }
        @{ case = 'a blank resource-bridge secret'; name = 'arbDeploymentServicePrincipalSecret'; value = [securestring]::new(); expectedError = '*all three resource-bridge service principal parameters*' }
        @{ case = 'a missing built-in service principal object ID'; name = 'builtInServicePrincipalObjectId'; value = $null; expectedError = '*builtInServicePrincipalObjectId*is missing*' }
    ) {
        Add-Registry
        Add-ReadyImage
        Mock bicep { throw 'The foundation compiled before its parameters were checked.' }
        $parameters = @{
            arbLocalAdminAndDeploymentUserPass  = ConvertTo-SecureString 'offline-password-placeholder' -AsPlainText -Force
            arbDeploymentAppId                  = '66666666-6666-6666-6666-666666666666'
            arbDeploymentSPObjectId             = '77777777-7777-7777-7777-777777777777'
            arbDeploymentServicePrincipalSecret = ConvertTo-SecureString 'offline-secret-placeholder' -AsPlainText -Force
            builtInServicePrincipalObjectId     = '88888888-8888-8888-8888-888888888888'
        }
        $parameters[$name] = $value

        { Start-HciEnvironmentFoundation -Context $context -Parameters $parameters } | Should -Throw $expectedError

        Should -Invoke bicep -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    Context 'Cluster deployment identity grants' {
        BeforeEach {
            $foundationId = $context.GroupIds.foundation
            $identityId = "$foundationId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/temp-$($context.Config.clusterName)"
            $principalId = '55555555-5555-5555-5555-555555555555'
            $assignmentRoot = "$foundationId/providers/Microsoft.Authorization/roleAssignments"
            function New-OfflineAssignment([string] $Name, [string] $Role, [string] $Scope = $foundationId) {
                $id = "$Scope/providers/Microsoft.Authorization/roleAssignments/$Name"
                $script:resources[$id] = @{
                    id = $id
                    properties = @{
                        principalId = $principalId
                        scope = $Scope
                        roleDefinitionId = "/subscriptions/$($context.SubscriptionId)/providers/Microsoft.Authorization/roleDefinitions/$Role"
                    }
                }
                return $script:resources[$id]
            }
        }

        It 'Removes only the module identity''s Contributor, Reader and RBAC Administrator grants on the foundation group' {
            $script:resources[$identityId] = @{ id = $identityId; properties = @{ principalId = $principalId } }
            $removed = @(
                New-OfflineAssignment '00000000-0000-0000-0000-00000000c001' 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                New-OfflineAssignment '00000000-0000-0000-0000-00000000c002' 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
                New-OfflineAssignment '00000000-0000-0000-0000-00000000c003' 'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
            )
            $kept = @(
                New-OfflineAssignment '00000000-0000-0000-0000-00000000c004' '4633458b-17de-408a-b874-0445c86b69e6'
                New-OfflineAssignment '00000000-0000-0000-0000-00000000c005' 'b24988ac-6180-42a0-ab88-20f7382dd24c' "/subscriptions/$($context.SubscriptionId)"
            )
            $script:resources[$assignmentRoot] = @{ value = @($removed + $kept) }

            Remove-HciClusterDeploymentAccess -Context $context

            @($script:deleted | Sort-Object) | Should -Be @($removed.id | Sort-Object)
        }

        It 'Changes nothing when the module identity doesn''t exist' {
            Remove-HciClusterDeploymentAccess -Context $context

            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Path -like '*/roleAssignments*' }
            $script:deleted.Count | Should -Be 0
        }

        It 'Removes nothing when the grants can''t be listed completely (<case>)' -ForEach @(
            @{ case = 'paged response'; paged = $true }
            @{ case = 'failed lookup'; paged = $false }
        ) {
            $script:resources[$identityId] = @{ id = $identityId; properties = @{ principalId = $principalId } }
            $assignment = New-OfflineAssignment '00000000-0000-0000-0000-00000000c001' 'b24988ac-6180-42a0-ab88-20f7382dd24c'
            if ($paged) { $script:resources[$assignmentRoot] = @{ value = @($assignment); nextLink = 'https://example.test/next' } }

            { Remove-HciClusterDeploymentAccess -Context $context } | Should -Throw '*could not be listed completely*'
            $script:deleted.Count | Should -Be 0
        }

        It 'Removes the grants after readiness and before releasing setup ownership' {
            $script:order = [System.Collections.Generic.List[string]]::new()
            Mock Get-HciEnvironmentReadiness { $script:order.Add('readiness'); @{ OwnedResourceIds = @() } }
            Mock Remove-HciClusterDeploymentAccess { $script:order.Add('remove') }
            Mock Exit-HciEnvironment { $script:order.Add('release') }
            $key = Get-HciEnvironmentKey -Value $context.SubscriptionId
            $pool = ConvertTo-Json -InputObject @(@{ id = $context.SubscriptionId; name = 'offline-reserved'; tag = 'Azure Local' }) -Compress

            $null = Invoke-HciPreparationStep -Stage Ready -RepoRootPath $RepoRootPath -ModulePath 'avm/res/azure-stack-hci/logical-network' `
                -TestCase @{ path = 'tests/e2e/defaults'; subscriptionIndex = 0; subscriptionKey = $key; environmentConcurrencyGroup = "avm-hci-$key" } `
                -TestSubscriptionIds $pool -TenantId $context.TenantId -RunIdentity 'offline' -SourceCommit ('b' * 40) -Maintenance:$true

            @($script:order) | Should -Be @('readiness', 'remove', 'release')
        }
    }
}

Describe 'Persistent resource cleanup guard and exact operation observation' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'Initialize-DeploymentRemoval.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'New-TemplateDeployment.ps1')
        function Get-AzContext {}
    }
    BeforeEach {
        Mock Get-AzContext { @{ Subscription = @{ Id = '11111111-1111-1111-1111-111111111111' }; Tenant = @{ Id = '22222222-2222-2222-2222-222222222222' } } }
    }
    It 'Rejects a cleanup target that is a protected <relationship> before any removal' -ForEach @(
        @{ relationship = 'resource group'; suffix = '/resourceGroups/foundation' }
        @{ relationship = 'descendant'; suffix = '/resourceGroups/foundation/providers/Microsoft.Compute/virtualMachines/host' }
        @{ relationship = 'ancestor'; suffix = '' }
    ) {
        $subscriptionRoot = '/subscriptions/11111111-1111-1111-1111-111111111111'
        { Initialize-DeploymentRemoval -ResourceIds "$subscriptionRoot$suffix" -ProtectedResourceIds "$subscriptionRoot/resourceGroups/foundation" } |
            Should -Throw '*protected persistent resource*nothing will be removed*'
    }

    It 'Protects externally supplied resource IDs regardless of ARM path casing' {
        $groupId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/external'
        { Initialize-DeploymentRemoval -ResourceIds $groupId -ProtectedResourceIds $groupId.ToUpperInvariant() } |
            Should -Throw '*protected persistent resource*nothing will be removed*'
    }

    It 'Rejects a replaced operation even when deployment name and resource ID match' {
        $id = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/foundation/providers/Microsoft.Resources/deployments/foundation'
        Mock Get-TemplateDeployment {
            [pscustomobject] @{
                Id = $id
                DeploymentName = 'foundation'
                ProvisioningState = 'Running'
                CorrelationId = '44444444-4444-4444-4444-444444444444'
                Error = $null
                Outputs = @{}
            }
        }
        { Wait-TemplateDeployment -DeploymentScope resourcegroup -DeploymentName foundation -ExpectedDeploymentId $id `
                -ExpectedCorrelationId '33333333-3333-3333-3333-333333333333' } |
            Should -Throw '*replaced deployment operation*'
        Should -Invoke Get-TemplateDeployment -Times 1 -Exactly
    }

    It 'Rejects a resource-group deployment without an Id from another resource group' {
        $id = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/foundation/providers/Microsoft.Resources/deployments/foundation'
        Mock Get-TemplateDeployment {
            [pscustomobject] @{
                ResourceGroupName = 'other'
                DeploymentName = 'foundation'
                ProvisioningState = 'Succeeded'
                CorrelationId = '44444444-4444-4444-4444-444444444444'
                Outputs = @{}
            }
        }
        { Wait-TemplateDeployment -DeploymentScope resourcegroup -DeploymentName foundation -ResourceGroupName foundation `
                -ExpectedDeploymentId $id -ExpectedCorrelationId '44444444-4444-4444-4444-444444444444' } |
            Should -Throw '*unambiguous original deployment*'
    }
}
