function Test-VerifyLock($ResourceId) {
    # TODO: Not Implemented Yet - How to test it?
}

function Test-VerifyRoleAssignment($ResourceId) {
    # TODO: Not Implemented Yet - How to test it?
}

function Test-VerifyOutputVariables($MustBeNullOrEmpty, $ResourceId, $Name, $Location, $ResourceGroupName) {

    if ( $MustBeNullOrEmpty -eq $true ) {
        $ResourceId | Should -BeNullOrEmpty
        $Name | Should -BeNullOrEmpty
        $Location | Should -BeNullOrEmpty
        $ResourceGroupName | Should -BeNullOrEmpty
    } else {
        $ResourceId | Should -Not -BeNullOrEmpty
        $Name | Should -Not -BeNullOrEmpty
        $Location | Should -Not -BeNullOrEmpty
        $ResourceGroupName | Should -Not -BeNullOrEmpty

        $r = Get-AzResource -ResourceId $ResourceId
        $r | Should -Not -BeNullOrEmpty
        $r.Name | Should -Be $Name
        $r.Location | Should -Be $Location
        $r.ResourceGroupName | Should -Be $ResourceGroupName
    }
}

function Test-VerifyTagsForResource($ResourceId, $Tags) {
    $t = Get-AzTag -ResourceId $ResourceId
    $t | Should -Not -BeNullOrEmpty
    foreach ($key in $Tags.Keys) {
        $t.Properties.TagsProperty[$key] | Should -Be $Tags[$key]
    }
}

function Test-VerifyDiagSettings($ResourceId, $LogAnalyticsWorkspaceResourceId, $Logs) {
    $diag = Get-AzDiagnosticSetting -ResourceId $ResourceId -Name avm-diagnostic-settings
    $diag | Should -Not -BeNullOrEmpty
    #$diag.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $diag.Type | Should -Be 'Microsoft.Insights/diagnosticSettings'
    $diag.WorkspaceId | Should -Be $LogAnalyticsWorkspaceResourceId

    $diagCat = Get-AzDiagnosticSettingCategory -ResourceId $ResourceId
    $diagCat | Should -Not -BeNullOrEmpty
    #$diagCat.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $diagCat.Count | Should -Be $Logs.Count
    for ($i = 0; $i -lt $diagCat.Count; $i++) { $diagCat[$i].Name | Should -BeIn $Logs }
}

function Test-VerifyVirtualNetwork($VirtualNetworkResourceGroupName, $VirtualNetworkName, $Tags, $LogAnalyticsWorkspaceResourceId, $AddressPrefix, $NumberOfSubnets) {
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $VirtualNetworkResourceGroupName -Name $VirtualNetworkName
    $vnet | Should -Not -BeNullOrEmpty
    $vnet.ProvisioningState | Should -Be 'Succeeded'
    $vnet.AddressSpace.Count | Should -Be 1
    $vnet.AddressSpace[0].AddressPrefixes.Count | Should -Be 1
    $vnet.AddressSpace[0].AddressPrefixes[0] | Should -Be $AddressPrefix
    $vnet.EnableDdosProtection | Should -Be $false
    $vnet.VirtualNetworkPeerings.Count | Should -Be 0
    $vnet.Subnets.Count | Should -Be $NumberOfSubnets
    $vnet.IpAllocations.Count | Should -Be 0
    $vnet.DhcpOptions.DnsServers | Should -BeNullOrEmpty
    $vnet.FlowTimeoutInMinutes | Should -BeNullOrEmpty
    $vnet.BgpCommunities | Should -BeNullOrEmpty
    $vnet.Encryption | Should -BeNullOrEmpty
    $vnet.DdosProtectionPlan | Should -BeNullOrEmpty
    $vnet.ExtendedLocation | Should -BeNullOrEmpty

    Test-VerifyTagsForResource -ResourceId $vnet.Id -Tags $Tags

    $logs = @('VMProtectionAlerts', 'AllMetrics')
    Test-VerifyDiagSettings -ResourceId $vnet.Id -LogAnalyticsWorkspaceResourceId $LogAnalyticsWorkspaceResourceId -Logs $logs

    Test-VerifyLock -ResourceId $vnet.Id
    Test-VerifyRoleAssignment -ResourceId $vnet.Id

    return $vnet
}

function Test-VerifySubnet($Subnet, $SubnetName, $SubnetAddressPrefix, $NumberOfSecurityGroups, $NumberOfPrivateEndpoints, $NumberOfIpConfigurations, $DelegationServiceName) {
    $Subnet.ProvisioningState | Should -Be 'Succeeded'
    $Subnet.Name | Should -Be $SubnetName
    $Subnet.PrivateEndpointNetworkPolicies | Should -Be 'Disabled'
    $Subnet.PrivateLinkServiceNetworkPolicies | Should -Be 'Enabled'
    $Subnet.AddressPrefix.Count | Should -Be 1
    $Subnet.AddressPrefix[0] | Should -Be $SubnetAddressPrefix
    $Subnet.NetworkSecurityGroup.Count | Should -Be $NumberOfSecurityGroups

    if ( $NumberOfPrivateEndpoints -eq $null ) { $Subnet.PrivateEndpoints | Should -BeNullOrEmpty }
    else { $Subnet.PrivateEndpoints.Count | Should -Be $NumberOfPrivateEndpoints }

    if ( $NumberOfIpConfigurations -eq $null ) { $Subnet.IpConfigurations | Should -BeNullOrEmpty }
    else { $Subnet.IpConfigurations.Count | Should -Be $NumberOfIpConfigurations }

    $Subnet.ServiceAssociationLinks | Should -BeNullOrEmpty
    $Subnet.ResourceNavigationLinks | Should -BeNullOrEmpty
    $Subnet.ServiceEndpoints | Should -BeNullOrEmpty
    $Subnet.ServiceEndpointPolicies | Should -BeNullOrEmpty

    if ( $DelegationServiceName -eq $null ) { $Subnet.Delegations | Should -BeNullOrEmpty }
    else {
        $Subnet.Delegations.Count | Should -Be 1
        $Subnet.Delegations[0].ProvisioningState | Should -Be 'Succeeded'
        $Subnet.Delegations[0].ServiceName | Should -Be $DelegationServiceName
    }

    $Subnet.IpAllocations | Should -BeNullOrEmpty
    $Subnet.RouteTable | Should -BeNullOrEmpty
    $Subnet.NatGateway | Should -BeNullOrEmpty
    $Subnet.DefaultOutboundAccess | Should -BeNullOrEmpty

    return $Subnet
}

function Test-VerifyNetworkSecurityGroup($NetworkSecurityGroupResourceId, $Tags, $VirtualNetworkResourceId, $SubnetName, $NumberOfSecurityRules, $NumberOfDefaultSecurityRules, $LogAnalyticsWorkspaceResourceId, $Logs) {
    # TODO: Do we have to check for specific rules?
    $nsg = Get-AzResource -ResourceId $NetworkSecurityGroupResourceId | Get-AzNetworkSecurityGroup
    $nsg | Should -Not -BeNullOrEmpty
    $nsg.ProvisioningState | Should -Be 'Succeeded'
    $nsg.FlushConnection | Should -Be $false
    $nsg.NetworkInterfaces | Should -BeNullOrEmpty
    $nsg.SecurityRules.Count | Should -Be $NumberOfSecurityRules
    $nsg.DefaultSecurityRules.Count | Should -Be $NumberOfDefaultSecurityRules
    $nsg.Subnets.Count | Should -Be 1
    $nsg.Subnets[0].Id | Should -Be "$($VirtualNetworkResourceId)/subnets/$($SubnetName)"

    Test-VerifyTagsForResource -ResourceId $NetworkSecurityGroupResourceId -Tags $Tags
    Test-VerifyDiagSettings -ResourceId $NetworkSecurityGroupResourceId -LogAnalyticsWorkspaceResourceId $LogAnalyticsWorkspaceResourceId -Logs $Logs

    Test-VerifyLock -ResourceId $NetworkSecurityGroupResourceId
    Test-VerifyRoleAssignment -ResourceId $NetworkSecurityGroupResourceId

    return $nsg
}

function Test-VerifyDnsZone($Name, $ResourceGroupName, $Tags, $NumberOfRecordSets) {
    $z = Get-AzPrivateDnsZone -ResourceGroupName $ResourceGroupName -Name $Name
    $z | Should -Not -BeNullOrEmpty
    #$z.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $z.NumberOfRecordSets | Should -Be $NumberOfRecordSets
    $z.NumberOfVirtualNetworkLinks | Should -Be 1

    Test-VerifyTagsForResource -ResourceId $z.ResourceId -Tags $Tags

    Test-VerifyLock -ResourceId $z.ResourceId
    Test-VerifyRoleAssignment -ResourceId $z.ResourceId

    return $z
}

function Test-VerifyPrivateEndpoint($Name, $ResourceGroupName, $Tags, $SubnetName, $ServiceId, $GroupId) {
    $pep = Get-AzPrivateEndpoint -ResourceGroupName $ResourceGroupName -Name $Name
    $pep | Should -Not -BeNullOrEmpty
    $pep.ProvisioningState | Should -Be 'Succeeded'
    $pep.Subnet.Id | Should -Be "$($virtualNetworkResourceId)/subnets/$($SubnetName)"
    $pep.NetworkInterfaces.Count | Should -Be 1
    $pep.PrivateLinkServiceConnections.ProvisioningState | Should -Be 'Succeeded'

    if ( $ServiceId -eq $null ) {
        # For some services I have no Id - but must be no empty
        $pep.PrivateLinkServiceConnections.PrivateLinkServiceId | Should -Not -BeNullOrEmpty
    } else {
        $pep.PrivateLinkServiceConnections.PrivateLinkServiceId | Should -Be $ServiceId
    }

    $pep.PrivateLinkServiceConnections.GroupIds.Count | Should -Be 1
    $pep.PrivateLinkServiceConnections.GroupIds | Should -Be $GroupId
    $pep.PrivateLinkServiceConnections.PrivateLinkServiceConnectionState.Status | Should -Be 'Approved'

    Test-VerifyTagsForResource -ResourceId $pep.Id -Tags $Tags

    Test-VerifyLock -ResourceId $pep.Id
    Test-VerifyRoleAssignment -ResourceId $pep.Id

    return $pep
}

function Test-VerifyLogAnalyticsWorkspace($LogAnalyticsWorkspaceResourceGroupName, $LogAnalyticsWorkspaceName, $Tags, $Sku, $RetentionInDays, $DailyQuotaGb) {
    $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $LogAnalyticsWorkspaceResourceGroupName -name $LogAnalyticsWorkspaceName
    $log | Should -Not -BeNullOrEmpty
    $log.ProvisioningState | Should -Be 'Succeeded'
    $log.Sku | Should -Be $Sku
    $log.RetentionInDays | Should -Be $RetentionInDays
    $log.WorkspaceCapping.DailyQuotaGb | Should -Be $DailyQuotaGb
    $log.WorkspaceCapping.DataIngestionStatus | Should -Be 'RespectQuota'
    $log.CapacityReservationLevel | Should -BeNullOrEmpty
    $log.PublicNetworkAccessForIngestion | Should -Be 'Enabled'
    $log.PublicNetworkAccessForQuery | Should -Be 'Enabled'
    $log.ForceCmkForQuery | Should -Be $true
    $log.PrivateLinkScopedResources | Should -BeNullOrEmpty
    $log.DefaultDataCollectionRuleResourceId | Should -BeNullOrEmpty
    $log.WorkspaceFeatures.EnableLogAccessUsingOnlyResourcePermissions | Should -Be $false

    Test-VerifyTagsForResource -ResourceId $log.ResourceId -Tags $Tags

    # No DIAG for LAW itself

    Test-VerifyLock -ResourceId $log.ResourceId
    Test-VerifyRoleAssignment -ResourceId $log.ResourceId

    return $log
}

function Test-VerifyKeyVault($KeyVaultResourceGroupName, $KeyVaultName, $Tags, $LogAnalyticsWorkspaceResourceId, $Sku, $EnableSoftDelete, $RetentionInDays, $PEPName, $NumberOfRecordSets, $SubnetName, $PublicNetworkAccess, $IpAddressRanges) {
    $kv = Get-AzKeyVault -ResourceGroupName $KeyVaultResourceGroupName -VaultName $KeyVaultName
    $kv | Should -Not -BeNullOrEmpty
    #$kv.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $kv.Sku | Should -Be $Sku
    $kv.EnabledForDeployment | Should -Be $false
    $kv.EnabledForTemplateDeployment | Should -Be $false
    $kv.EnabledForDiskEncryption | Should -Be $false
    $kv.EnableRbacAuthorization | Should -Be $true
    $kv.EnableSoftDelete | Should -Be $EnableSoftDelete
    $kv.SoftDeleteRetentionInDays | Should -Be $RetentionInDays
    $kv.EnablePurgeProtection | Should -Be $true
    $kv.PublicNetworkAccess | Should -Be $PublicNetworkAccess
    $kv.AccessPolicies | Should -BeNullOrEmpty
    $kv.NetworkAcls.DefaultAction | Should -Be 'Deny'
    $kv.NetworkAcls.Bypass | Should -Be 'None'
    if ( $IpAddressRanges -eq $null ) { $kv.NetworkAcls.IpAddressRanges | Should -BeNullOrEmpty }
    else {
        $kv.NetworkAcls.IpAddressRanges.Count | Should -Be $IpAddressRanges.Count

        foreach ($ip in $IpAddressRanges) {
            $kv.NetworkAcls.IpAddressRanges[$IpAddressRanges.IndexOf($ip)] | Should -Be $ip
        }
    }

    $kv.NetworkAcls.VirtualNetworkResourceIds | Should -BeNullOrEmpty

    Test-VerifyTagsForResource -ResourceId $kv.ResourceId -Tags $Tags

    $logs = @('AuditEvent', 'AzurePolicyEvaluationDetails', 'AllMetrics')
    Test-VerifyDiagSettings -ResourceId $kv.ResourceId -LogAnalyticsWorkspaceResourceId $LogAnalyticsWorkspaceResourceId -Logs $logs

    Test-VerifyPrivateEndpoint -Name "$($kv.VaultName)$($PEPName)" -ResourceGroupName $KeyVaultResourceGroupName -Tags $Tags -SubnetName $SubnetName -ServiceId $kv.ResourceId -GroupId 'vault'

    if ( $NumberOfRecordSets -ne 0 ) {
        Test-VerifyDnsZone -Name 'privatelink.vaultcore.azure.net' -ResourceGroupName $KeyVaultResourceGroupName -Tags $Tags -NumberOfRecordSets $NumberOfRecordSets
    }

    Test-VerifyLock -ResourceId $kv.ResourceId
    Test-VerifyRoleAssignment -ResourceId $kv.ResourceId

    return $kv
}

function Test-VerifyDatabricksAccessConnector($DatabricksAcCResourceGroupName, $DatabricksAcCName, $Tags, $DatabricksResourceId) {
    $acc = Get-AzDatabricksAccessConnector -ResourceGroupName $DatabricksAcCResourceGroupName -Name $DatabricksAcCName
    $acc | Should -Not -BeNullOrEmpty
    $acc.ProvisioningState | Should -Be 'Succeeded'
    $acc.IdentityType | Should -Be 'SystemAssigned'
    $acc.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty
    $acc.ReferedBy | Should -Be $DatabricksResourceId

    Test-VerifyTagsForResource -ResourceId $acc.Id -Tags $Tags

    # No DIAG for Access Connector itself

    Test-VerifyLock -ResourceId $acc.Id
    Test-VerifyRoleAssignment -ResourceId $acc.Id

    return $acc
}

function Test-VerifyDatabricks($DatabricksResourceGroupName, $DatabricksName, $Tags, $LogAnalyticsWorkspaceResourceId, $Sku, $VirtualNetworkResourceId, $PrivateSubnetName, $PublicSubnetName, $PEPName0, $PEPName1, $PEPName2, $BlobNumberOfRecordSets, $DatabricksNumberOfRecordSets, $PLSubnetName, $PublicNetworkAccess, $RequiredNsgRule) {
    $adb = Get-AzDatabricksWorkspace -ResourceGroupName $DatabricksResourceGroupName -Name $DatabricksName
    $adb | Should -Not -BeNullOrEmpty
    $adb.ProvisioningState | Should -Be 'Succeeded'
    $adb.AccessConnectorId | Should -Not -BeNullOrEmpty
    $adb.AccessConnectorIdentityType | Should -Be 'SystemAssigned'
    $adb.AccessConnectorUserAssignedIdentityId | Should -BeNullOrEmpty
    $adb.AmlWorkspaceIdType | Should -BeNullOrEmpty
    $adb.AmlWorkspaceIdValue | Should -BeNullOrEmpty
    #Skip $adb.Authorization
    $adb.AutomaticClusterUpdateValue | Should -BeNullOrEmpty
    $adb.ComplianceSecurityProfileComplianceStandard | Should -BeNullOrEmpty
    $adb.ComplianceSecurityProfileValue | Should -BeNullOrEmpty
    #Skip $adb.CreatedByApplicationId, $adb.CreatedByOid, $adb.CreatedByPuid, $adb.CreatedDateTime,
    $adb.CustomPrivateSubnetNameType | Should -Be 'String'
    $adb.CustomPrivateSubnetNameValue | Should -Be $PrivateSubnetName
    $adb.CustomPublicSubnetNameType | Should -Be 'String'
    $adb.CustomPublicSubnetNameValue | Should -Be $PublicSubnetName
    $adb.CustomVirtualNetworkIdType | Should -Be 'String'
    $adb.CustomVirtualNetworkIdValue | Should -Be $VirtualNetworkResourceId
    $adb.DefaultCatalogInitialName | Should -BeNullOrEmpty
    $adb.DefaultCatalogInitialType | Should -BeNullOrEmpty
    $adb.DefaultStorageFirewall | Should -Be 'Enabled'
    $adb.DiskEncryptionSetId | Should -BeNullOrEmpty
    $adb.EnableNoPublicIP | Should -Be $true
    $adb.EnableNoPublicIPType | Should -Be 'Bool'
    $adb.EncryptionKeyName | Should -BeNullOrEmpty
    $adb.EncryptionKeySource | Should -BeNullOrEmpty
    $adb.EncryptionKeyVaultUri | Should -BeNullOrEmpty
    $adb.EncryptionKeyVersion | Should -BeNullOrEmpty
    $adb.EncryptionType | Should -BeNullOrEmpty
    $adb.EnhancedSecurityMonitoringValue | Should -BeNullOrEmpty
    #Skip $adb.Id | Should -Be $databricksResourceId
    $adb.IsUcEnabled | Should -Be $true
    $adb.LoadBalancerBackendPoolNameType | Should -BeNullOrEmpty
    $adb.LoadBalancerBackendPoolNameValue | Should -BeNullOrEmpty
    $adb.LoadBalancerIdType | Should -BeNullOrEmpty
    $adb.LoadBalancerIdValue | Should -BeNullOrEmpty
    #Skip $adb.Location | Should -Be $databricksLocation
    $adb.ManagedDiskIdentityPrincipalId | Should -BeNullOrEmpty
    $adb.ManagedDiskIdentityTenantId | Should -BeNullOrEmpty
    $adb.ManagedDiskIdentityType | Should -BeNullOrEmpty
    $adb.ManagedDiskKeySource | Should -Be 'Microsoft.Keyvault'
    $adb.ManagedDiskKeyVaultPropertiesKeyName | Should -BeNullOrEmpty
    $adb.ManagedDiskKeyVaultPropertiesKeyVaultUri | Should -BeNullOrEmpty
    $adb.ManagedDiskKeyVaultPropertiesKeyVersion | Should -BeNullOrEmpty
    $adb.ManagedDiskRotationToLatestKeyVersionEnabled | Should -BeNullOrEmpty
    #Skip $adb.ManagedResourceGroupId
    $adb.ManagedServiceKeySource | Should -Be 'Microsoft.Keyvault'
    $adb.ManagedServicesKeyVaultPropertiesKeyName | Should -BeNullOrEmpty
    $adb.ManagedServicesKeyVaultPropertiesKeyVaultUri | Should -BeNullOrEmpty
    $adb.ManagedServicesKeyVaultPropertiesKeyVersion | Should -BeNullOrEmpty
    $adb.Name | Should -Be $DatabricksName
    $adb.NatGatewayNameType | Should -BeNullOrEmpty
    $adb.NatGatewayNameValue | Should -BeNullOrEmpty
    $adb.PrepareEncryption | Should -Be $true
    $adb.PrepareEncryptionType | Should -Be 'Bool'

    $adb.PrivateEndpointConnection.Count | Should -Be 2

    $adb.PrivateEndpointConnection[0].GroupId.Count | Should -Be 1
    $adb.PrivateEndpointConnection[0].GroupId[0] | Should -Be 'databricks_ui_api'
    $adb.PrivateEndpointConnection[0].PrivateLinkServiceConnectionStateStatus | Should -Be 'Approved'
    $adb.PrivateEndpointConnection[0].ProvisioningState | Should -Be 'Succeeded'

    $adb.PrivateEndpointConnection[1].GroupId.Count | Should -Be 1
    $adb.PrivateEndpointConnection[1].GroupId[0] | Should -Be 'browser_authentication'
    $adb.PrivateEndpointConnection[1].PrivateLinkServiceConnectionStateStatus | Should -Be 'Approved'
    $adb.PrivateEndpointConnection[1].ProvisioningState | Should -Be 'Succeeded'

    $adb.PublicIPNameType | Should -Be 'String'
    $adb.PublicIPNameValue | Should -Be 'nat-gw-public-ip'
    $adb.PublicNetworkAccess | Should -Be $PublicNetworkAccess
    $adb.RequireInfrastructureEncryption | Should -Be $false
    $adb.RequireInfrastructureEncryptionType | Should -Be 'Bool'
    $adb.RequiredNsgRule | Should -Be $RequiredNsgRule
    $adb.ResourceGroupName | Should -Be $DatabricksResourceGroupName
    #Skip $adb.ResourceTagType, $adb.ResourceTagValue
    $adb.SkuName | Should -Be $Sku
    $adb.SkuTier | Should -BeNullOrEmpty
    #Skip $adb.StorageAccount**
    #Skip $adb.SystemData**
    $adb.Type | Should -Be 'Microsoft.Databricks/workspaces'
    $adb.UiDefinitionUri | Should -BeNullOrEmpty
    #Skip $adb.UpdatedBy**
    #Skip $adb.Url
    $adb.VnetAddressPrefixType | Should -Be 'String'
    $adb.VnetAddressPrefixValue | Should -Be '10.139'
    #Skip $adb.WorkspaceId

    Test-VerifyTagsForResource -ResourceId $adb.Id -Tags $Tags

    $logs = @(
        'dbfs', 'clusters', 'accounts', 'jobs', 'notebook',
        'ssh', 'workspace', 'secrets', 'sqlPermissions', 'instancePools',
        'sqlanalytics', 'genie', 'globalInitScripts', 'iamRole', 'mlflowExperiment',
        'featureStore', 'RemoteHistoryService', 'mlflowAcledArtifact', 'databrickssql', 'deltaPipelines',
        'modelRegistry', 'repos', 'unityCatalog', 'gitCredentials', 'webTerminal',
        'serverlessRealTimeInference', 'clusterLibraries', 'partnerHub', 'clamAVScan', 'capsule8Dataplane',
        'BrickStoreHttpGateway', 'Dashboards', 'CloudStorageMetadata', 'PredictiveOptimization', 'DataMonitoring',
        'Ingestion', 'MarketplaceConsumer', 'LineageTracking'
    )
    Test-VerifyDiagSettings -ResourceId $adb.Id -LogAnalyticsWorkspaceResourceId $LogAnalyticsWorkspaceResourceId -Logs $logs

    $acc = Test-VerifyDatabricksAccessConnector -DatabricksAcCResourceGroupName $DatabricksResourceGroupName -DatabricksAcCName "$($DatabricksName)-acc" -Tags $Tags -DatabricksResourceId $adb.Id
    $acc.Id | Should -Be $adb.AccessConnectorId

    # Workaround
    $baseName = $DatabricksName -replace '-dbw' -replace ''

    Test-VerifyPrivateEndpoint -Name "$($baseName)$($PEPName0)" -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -SubnetName $PLSubnetName -ServiceId $null -GroupId 'blob'
    Test-VerifyPrivateEndpoint -Name "$($baseName)$($PEPName1)" -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -SubnetName $PLSubnetName -ServiceId $adb.Id -GroupId 'browser_authentication'
    Test-VerifyPrivateEndpoint -Name "$($baseName)$($PEPName2)" -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -SubnetName $PLSubnetName -ServiceId $adb.Id -GroupId 'databricks_ui_api'

    if ( $BlobNumberOfRecordSets -ne 0 ) {
        Test-VerifyDnsZone -Name 'privatelink.blob.core.windows.net' -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -NumberOfRecordSets $BlobNumberOfRecordSets
    }

    if ( $DatabricksNumberOfRecordSets -ne 0 ) {
        Test-VerifyDnsZone -Name 'privatelink.azuredatabricks.net' -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -NumberOfRecordSets $DatabricksNumberOfRecordSets
    }

    Test-VerifyLock -ResourceId $adb.Id
    Test-VerifyRoleAssignment -ResourceId $adb.Id

    return $adb
}
