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
