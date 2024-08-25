function Test-VerifyLock($ResourceId)
{
    # TODO: Not Implemented Yet - How to test it?
}

function Test-VerifyRoleAssignment($ResourceId)
{
    # TODO: Not Implemented Yet - How to test it?
}

function Test-VerifyOutputVariables($ResourceId, $Name, $Location, $ResourceGroupName)
{
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

function Test-VerifyTagsForResource($ResourceId, $Tags)
{
    $t = Get-AzTag -ResourceId $ResourceId
    $t | Should -Not -BeNullOrEmpty
    foreach ($key in $Tags.Keys)
    {
        $t.Properties.TagsProperty[$key] | Should -Be $Tags[$key]
    }
}

function Test-VerifyDiagSettings($ResourceId, $LogAnalyticsWorkspaceResourceId, $Logs)
{
    $diag  = Get-AzDiagnosticSetting -ResourceId $ResourceId -Name avm-diagnostic-settings
    $diag | Should -Not -BeNullOrEmpty
    #$diag.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $diag.Type | Should -Be "Microsoft.Insights/diagnosticSettings"
    $diag.WorkspaceId | Should -Be $LogAnalyticsWorkspaceResourceId

    $diagCat = Get-AzDiagnosticSettingCategory -ResourceId $ResourceId
    $diagCat | Should -Not -BeNullOrEmpty
    #$diagCat.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $diagCat.Count | Should -Be $Logs.Count
    for ($i = 0; $i -lt $diagCat.Count; $i++) { $diagCat[$i].Name | Should -BeIn $Logs }
}

function Test-VerifyVirtualNetwork($VirtualNetworkResourceGroupName, $VirtualNetworkName, $Tags, $LogAnalyticsWorkspaceResourceId, $AddressPrefix, $NumberOfSubnets)
{
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $VirtualNetworkResourceGroupName -Name $VirtualNetworkName
    $vnet | Should -Not -BeNullOrEmpty
    $vnet.ProvisioningState | Should -Be "Succeeded"
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

function Test-VerifySubnet($Subnet, $SubnetName, $SubnetAddressPrefix, $NumberOfSecurityGroups, $NumberOfPrivateEndpoints, $NumberOfIpConfigurations, $DelegationServiceName)
{
    $Subnet.ProvisioningState | Should -Be "Succeeded"
    $Subnet.Name | Should -Be $SubnetName
    $Subnet.PrivateEndpointNetworkPolicies | Should -Be "Disabled"
    $Subnet.PrivateLinkServiceNetworkPolicies | Should -Be "Enabled"
    $Subnet.AddressPrefix.Count | Should -Be 1
    $Subnet.AddressPrefix[0] | Should -Be $SubnetAddressPrefix
    $Subnet.NetworkSecurityGroup.Count | Should -Be $NumberOfSecurityGroups

    if ( $NumberOfPrivateEndpoints -eq $null ) { $Subnet.PrivateEndpoints | Should -BeNullOrEmpty }
    else { $Subnet.PrivateEndpoints | Should -Be $NumberOfPrivateEndpoints }

    if ( $NumberOfIpConfigurations -eq $null ) { $Subnet.IpConfigurations | Should -BeNullOrEmpty }
    else { $Subnet.IpConfigurations | Should -Be $NumberOfIpConfigurations }

    $Subnet.ServiceAssociationLinks | Should -BeNullOrEmpty
    $Subnet.ResourceNavigationLinks | Should -BeNullOrEmpty
    $Subnet.ServiceEndpoints | Should -BeNullOrEmpty
    $Subnet.ServiceEndpointPolicies | Should -BeNullOrEmpty

    if ( $DelegationServiceName -eq $null ) { $Subnet.Delegations | Should -BeNullOrEmpty }
    else
    {
        $Subnet.Delegations.Count | Should -Be 1
        $Subnet.Delegations[0].ProvisioningState | Should -Be "Succeeded"
        $Subnet.Delegations[0].ServiceName | Should -Be $DelegationServiceName
    }

    $Subnet.IpAllocations | Should -BeNullOrEmpty
    $Subnet.RouteTable | Should -BeNullOrEmpty
    $Subnet.NatGateway | Should -BeNullOrEmpty
    $Subnet.DefaultOutboundAccess | Should -BeNullOrEmpty

    return $Subnet
}

function Test-VerifyNetworkSecurityGroup($NetworkSecurityGroupResourceId, $Tags, $VirtualNetworkResourceId, $SubnetName, $NumberOfSecurityRules, $NumberOfDefaultSecurityRules, $LogAnalyticsWorkspaceResourceId, $Logs)
{
    # TODO: Do we have to check for specific rules?
    $nsg = Get-AzResource -ResourceId $NetworkSecurityGroupResourceId | Get-AzNetworkSecurityGroup
    $nsg | Should -Not -BeNullOrEmpty
    $nsg.ProvisioningState | Should -Be "Succeeded"
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

function Test-VerifyLogAnalyticsWorkspace($LogAnalyticsWorkspaceResourceGroupName, $LogAnalyticsWorkspaceName, $Tags, $Sku, $RetentionInDays, $DailyQuotaGb)
{
    $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $LogAnalyticsWorkspaceResourceGroupName -name $LogAnalyticsWorkspaceName
    $log | Should -Not -BeNullOrEmpty
    $log.ProvisioningState | Should -Be "Succeeded"
    $log.Sku | Should -Be $Sku
    $log.RetentionInDays | Should -Be $RetentionInDays
    $log.WorkspaceCapping.DailyQuotaGb | Should -Be $DailyQuotaGb
    $log.WorkspaceCapping.DataIngestionStatus | Should -Be 'RespectQuota'
    $log.CapacityReservationLevel | Should -BeNullOrEmpty
    $log.PublicNetworkAccessForIngestion | Should -Be "Enabled"
    $log.PublicNetworkAccessForQuery | Should -Be "Enabled"
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

function Test-VerifyKeyVault($KeyVaultResourceGroupName, $KeyVaultName, $Tags, $LogAnalyticsWorkspaceResourceId, $Sku, $RetentionInDays, $PEPName, $NumberOfRecordSets, $SubnetName)
{
    $kv = Get-AzKeyVault -ResourceGroupName $KeyVaultResourceGroupName -VaultName $KeyVaultName
    $kv | Should -Not -BeNullOrEmpty
    #$kv.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $kv.Sku | Should -Be $Sku
    $kv.EnabledForDeployment | Should -Be $false
    $kv.EnabledForTemplateDeployment | Should -Be $false
    $kv.EnabledForDiskEncryption | Should -Be $false
    $kv.EnableRbacAuthorization | Should -Be $true
    $kv.EnableSoftDelete | Should -Be $true
    $kv.SoftDeleteRetentionInDays | Should -Be $RetentionInDays
    $kv.EnablePurgeProtection | Should -Be $true
    $kv.PublicNetworkAccess | Should -Be 'Disabled'
    $kv.AccessPolicies | Should -BeNullOrEmpty
    $kv.NetworkAcls.DefaultAction | Should -Be 'Deny'
    $kv.NetworkAcls.Bypass | Should -Be 'None'
    $kv.NetworkAcls.IpAddressRanges | Should -BeNullOrEmpty
    $kv.NetworkAcls.VirtualNetworkResourceIds | Should -BeNullOrEmpty

    Test-VerifyTagsForResource -ResourceId $kv.ResourceId -Tags $Tags

    $logs = @('AuditEvent', 'AzurePolicyEvaluationDetails', 'AllMetrics')
    Test-VerifyDiagSettings -ResourceId $kv.ResourceId -LogAnalyticsWorkspaceResourceId $LogAnalyticsWorkspaceResourceId -Logs $logs

    Test-VerifyPrivateEndpoint -Name "$($kv.VaultName)$($PEPName)" -ResourceGroupName $KeyVaultResourceGroupName -Tags $Tags -SubnetName $SubnetName -ServiceId $kv.ResourceId -GroupId "vault"

    Test-VerifyDnsZone -Name "privatelink.vaultcore.azure.net" -ResourceGroupName $KeyVaultResourceGroupName -Tags $Tags -NumberOfRecordSets $NumberOfRecordSets

    Test-VerifyLock -ResourceId $kv.ResourceId
    Test-VerifyRoleAssignment -ResourceId $kv.ResourceId

    return $kv
}

function Test-VerifyDnsZone($Name, $ResourceGroupName, $Tags, $NumberOfRecordSets)
{
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

function Test-VerifyPrivateEndpoint($Name, $ResourceGroupName, $Tags, $SubnetName, $ServiceId, $GroupId)
{
    $pep = Get-AzPrivateEndpoint -ResourceGroupName $ResourceGroupName -Name $Name
    $pep | Should -Not -BeNullOrEmpty
    $pep.ProvisioningState | Should -Be "Succeeded"
    $pep.Subnet.Id | Should -Be "$($virtualNetworkResourceId)/subnets/$($SubnetName)"
    $pep.NetworkInterfaces.Count | Should -Be 1
    $pep.PrivateLinkServiceConnections.ProvisioningState | Should -Be "Succeeded"
    $pep.PrivateLinkServiceConnections.PrivateLinkServiceId | Should -Be $ServiceId
    $pep.PrivateLinkServiceConnections.GroupIds.Count | Should -Be 1
    $pep.PrivateLinkServiceConnections.GroupIds | Should -Be $GroupId
    $pep.PrivateLinkServiceConnections.PrivateLinkServiceConnectionState.Status | Should -Be "Approved"

    Test-VerifyTagsForResource -ResourceId $pep.Id -Tags $Tags

    Test-VerifyLock -ResourceId $pep.Id
    Test-VerifyRoleAssignment -ResourceId $pep.Id

    return $pep
}
