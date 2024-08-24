function Test-VerifyTagsForResource($ResourceId, $Tags)
{
    $t = Get-AzTag -ResourceId $ResourceId
    $t | Should -Not -BeNullOrEmpty
    foreach ($key in $Tags.Keys)
    {
        $t.Properties.TagsProperty[$key] | Should -Be $Tags[$key]
    }
}

function Test-VerifyDnsZone($Name, $ResourceGroupName, $NumberOfRecordSets)
{
    $z = Get-AzPrivateDnsZone -ResourceGroupName $ResourceGroupName -Name $Name
    $z | Should -Not -BeNullOrEmpty
    #$z.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $z.NumberOfRecordSets | Should -Be $NumberOfRecordSets
    $z.NumberOfVirtualNetworkLinks | Should -Be 1
    $z.Tags.Owner | Should -Be "Contoso"
    $z.Tags.CostCenter | Should -Be "123-456-789"
}
