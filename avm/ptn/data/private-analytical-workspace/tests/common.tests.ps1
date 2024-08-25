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

function Test-VerifyDnsZone($Name, $ResourceGroupName, $Tags, $NumberOfRecordSets)
{
    $z = Get-AzPrivateDnsZone -ResourceGroupName $ResourceGroupName -Name $Name
    $z | Should -Not -BeNullOrEmpty
    #$z.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $z.NumberOfRecordSets | Should -Be $NumberOfRecordSets
    $z.NumberOfVirtualNetworkLinks | Should -Be 1

    Test-VerifyTagsForResource -ResourceId $z.ResourceId -Tags $Tags
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
}

function Test-VerifySubnet($Subnet, $SubnetName, $SubnetAddressPrefix, $NumberOfSecurityGroups, $NumberOfPrivateEndpoints, $NumberOfIpConfigurations, $DelegationServiceName)
{
    $Subnet.ProvisioningState | Should -Be "Succeeded"
    $Subnet.Name | Should -Be SubnetName
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
}
