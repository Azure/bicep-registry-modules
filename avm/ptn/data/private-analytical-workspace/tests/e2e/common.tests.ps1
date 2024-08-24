Function Test-VerifyDnsZone($Name, $ResourceGroupName, $NumberOfRecordSets)
{
    $z = Get-AzPrivateDnsZone -ResourceGroupName $ResourceGroupName -Name $Name
    $z | Should -Not -BeNullOrEmpty
    #$z.ProvisioningState | Should -Be "Succeeded"     # Not available in the output
    $z.NumberOfRecordSets | Should -Be $NumberOfRecordSets
    $z.NumberOfVirtualNetworkLinks | Should -Be 1
    $z.Tags.Owner | Should -Be "Contoso"
    $z.Tags.CostCenter | Should -Be "123-456-789"
}
