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
        if ( $Location ) {
            $Location | Should -Not -BeNullOrEmpty
        } else {
            $Location | Should -BeNullOrEmpty
        }
        $ResourceGroupName | Should -Not -BeNullOrEmpty

        $r = Get-AzResource -ResourceId $ResourceId
        $r | Should -Not -BeNullOrEmpty
        $r.Name | Should -Be $Name
        if ( $Location ) {
            $r.Location | Should -Be $Location
        } else {
            $r.Location | Should -BeNullOrEmpty
        }
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

function Test-VerifyElasticSANVolumeSnapshot($ResourceId, $ElasticSanName, $ResourceGroupName, $VolumeGroupName, $VolumeName, $Name, $VolumeResourceId, $SourceVolumeSizeGiB) {

    $s = Get-AzElasticSanVolumeSnapshot -ElasticSanName $ElasticSanName -ResourceGroupName $ResourceGroupName -VolumeGroupName $VolumeGroupName -Name $Name
    $s | Should -Not -BeNullOrEmpty
    $s.ProvisioningState | Should -Be 'Succeeded'

    $s.CreationDataSourceId | Should -Be $VolumeResourceId
    $s.Id | Should -Be $ResourceId
    $s.Name | Should -Be $Name
    $s.ResourceGroupName | Should -Be $ResourceGroupName
    $s.SourceVolumeSizeGiB | Should -Be $SourceVolumeSizeGiB
    #Skip $s.SystemData**
    $s.Type | Should -Be 'Microsoft.ElasticSan/elasticSans/volumeGroups/snapshots'
    $s.VolumeName | Should -Be $VolumeName
}

function Test-VerifyElasticSANVolume($ResourceId, $ElasticSanName, $ResourceGroupName, $VolumeGroupName, $Name, $TargetIqn, $TargetPortalHostname, $TargetPortalPort, $VolumeId, $SizeGiB) {

    $v = Get-AzElasticSanVolume -ElasticSanName $ElasticSanName -ResourceGroupName $ResourceGroupName -VolumeGroupName $VolumeGroupName -Name $Name
    $v | Should -Not -BeNullOrEmpty
    $v.ProvisioningState | Should -Be 'Succeeded'

    $v.CreationDataCreateSource | Should -Be 'None'
    $v.CreationDataSourceId | Should -BeNullOrEmpty
    $v.Id | Should -Be $ResourceId
    $v.ManagedByResourceId | Should -Be 'None'
    $v.Name | Should -Be $Name
    $v.ResourceGroupName | Should -Be $ResourceGroupName
    $v.SizeGiB | Should -Be $SizeGiB
    $v.StorageTargetIqn | Should -Be $TargetIqn
    $v.StorageTargetPortalHostname | Should -Be $TargetPortalHostname
    $v.StorageTargetPortalPort | Should -Be $TargetPortalPort
    $v.StorageTargetProvisioningState | Should -Be 'Succeeded'
    $v.StorageTargetStatus | Should -Be 'Running'
    #Skip $v.SystemData**
    $v.Type | Should -Be 'Microsoft.ElasticSan/elasticSans/volumeGroups/volumes'
    $v.VolumeId | Should -Be $VolumeId
}

function Test-VerifyElasticSANVolumeGroup($ResourceId, $ElasticSanName, $ResourceGroupName, $Name, $SystemAssignedMI, $UserAssignedMI, $SystemAssignedMIPrincipalId, $NetworkAclsVirtualNetworkRuleCount, $PrivateEndpointConnection) {

    $vg = Get-AzElasticSanVolumeGroup -ElasticSanName $ElasticSanName -ResourceGroupName $ResourceGroupName -Name $Name
    $vg | Should -Not -BeNullOrEmpty
    $vg.ProvisioningState | Should -Be 'Succeeded'

    $vg.Encryption | Should -Be 'EncryptionAtRestWithPlatformKey'
    $vg.EncryptionIdentityEncryptionUserAssignedIdentity | Should -BeNullOrEmpty


    $vg.EnforceDataIntegrityCheckForIscsi | Should -BeNullOrEmpty
    $vg.Id | Should -Be $ResourceId



    if ( $SystemAssignedMI -and $UserAssignedMI ) {

        $vg.IdentityPrincipalId | Should -BeNullOrEmpty                             # ??
        $vg.IdentityTenantId | Should -BeNullOrEmpty                                # ??
        $vg.IdentityType | Should -Be 'SystemAssigned, UserAssigned'
        $vg.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty # ??

    } elseif ($SystemAssignedMI) {

        $vg.IdentityPrincipalId | Should -Be $SystemAssignedMIPrincipalId
        $vg.IdentityTenantId | Should -Not -BeNullOrEmpty
        $vg.IdentityType | Should -Be 'SystemAssigned'
        $vg.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty

    } elseif ($UserAssignedMI) {

        $vg.IdentityPrincipalId | Should -BeNullOrEmpty
        $vg.IdentityTenantId | Should -BeNullOrEmpty                                # ??
        $vg.IdentityType | Should -Be 'UserAssigned'
        $($vg.IdentityUserAssignedIdentity | ConvertFrom-Json).PSObject.Properties.Count | Should -Be 1

    } else {

        # None Identity Specified
        $vg.IdentityPrincipalId | Should -BeNullOrEmpty
        $vg.IdentityTenantId | Should -BeNullOrEmpty
        $vg.IdentityType | Should -BeNullOrEmpty
        $vg.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty

    }









    $vg.KeyVaultPropertyCurrentVersionedKeyExpirationTimestamp | Should -BeNullOrEmpty
    $vg.KeyVaultPropertyCurrentVersionedKeyIdentifier | Should -BeNullOrEmpty
    $vg.KeyVaultPropertyKeyName | Should -BeNullOrEmpty
    $vg.KeyVaultPropertyKeyVaultUri | Should -BeNullOrEmpty
    $vg.KeyVaultPropertyKeyVersion | Should -BeNullOrEmpty
    $vg.KeyVaultPropertyLastKeyRotationTimestamp | Should -BeNullOrEmpty


    $vg.Name | Should -Be $Name


    $vg.NetworkAclsVirtualNetworkRule.Count | Should -Be $NetworkAclsVirtualNetworkRuleCount
    if ( $PrivateEndpointConnection ) {
        $vg.PrivateEndpointConnection | Should -Be $PrivateEndpointConnection
    } else {
        $vg.PrivateEndpointConnection | Should -BeNullOrEmpty
    }




    $vg.ProtocolType | Should -Be 'iSCSI'
    $vg.ResourceGroupName | Should -Be $ResourceGroupName
    #Skip $vg.SystemData**
    $vg.Type | Should -Be 'Microsoft.ElasticSan/elasticSans/volumeGroups'
}










function Test-VerifyElasticSAN($ResourceId, $ResourceGroupName, $Name, $Location, $Tags, $BaseSizeTiB, $ExtendedCapacitySizeTiB, $PublicNetworkAccess, $SkuName, $VolumeGroupCount) {

    $esan = Get-AzElasticSan -ResourceGroupName $ResourceGroupName -Name $Name
    $esan | Should -Not -BeNullOrEmpty
    $esan.ProvisioningState | Should -Be 'Succeeded'

    #AvailabilityZone : { 2 }
    $esan.BaseSizeTiB | Should -Be $BaseSizeTiB
    $esan.ExtendedCapacitySizeTiB | Should -Be $ExtendedCapacitySizeTiB
    $esan.Id | Should -Be $ResourceId
    $esan.Location | Should -Be $Location
    $esan.Name | Should -Be $Name
    #PrivateEndpointConnection
    $esan.PublicNetworkAccess | Should -Be $PublicNetworkAccess
    $esan.ResourceGroupName | Should -Be $ResourceGroupName
    $esan.SkuName | Should -Be $SkuName
    $esan.SkuTier | Should -Be 'Premium'
    #Skip $esan.SystemData**
    #Skip $esan.Tag
    #Skip $esan.TotalIops
    #Skip $esan.TotalMBps
    #Skip $esan.TotalSizeTiB | Should -Be $TotalSizeTiB
    #Skip $esan.TotalVolumeSizeGiB | Should -Be $TotalVolumeSizeGiB
    $esan.Type | Should -Be 'Microsoft.ElasticSan/ElasticSans'
    $esan.VolumeGroupCount | Should -Be $VolumeGroupCount

    Test-VerifyTagsForResource -ResourceId $esan.Id -Tags $Tags












    #$esan.PrivateEndpointConnection.Count | Should -Be 2

    #$esan.PrivateEndpointConnection[0].GroupId.Count | Should -Be 1
    #$esan.PrivateEndpointConnection[0].GroupId[0] | Should -Be 'databricks_ui_api'
    #$esan.PrivateEndpointConnection[0].PrivateLinkServiceConnectionStateStatus | Should -Be 'Approved'
    #$esan.PrivateEndpointConnection[0].ProvisioningState | Should -Be 'Succeeded'

    #$esan.PrivateEndpointConnection[1].GroupId.Count | Should -Be 1
    #$esan.PrivateEndpointConnection[1].GroupId[0] | Should -Be 'browser_authentication'
    #$esan.PrivateEndpointConnection[1].PrivateLinkServiceConnectionStateStatus | Should -Be 'Approved'
    #$esan.PrivateEndpointConnection[1].ProvisioningState | Should -Be 'Succeeded'





    # TODO Logs + Test-VerifyDiagSettings
    # Test-VerifyPrivateEndpoint -Name "$($baseName)$($PEPName0)" -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -SubnetName $PLSubnetName -ServiceId $null -GroupId 'blob'

    #if ( $BlobNumberOfRecordSets -ne 0 ) {
    #    Test-VerifyDnsZone -Name 'privatelink.blob.core.windows.net' -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -NumberOfRecordSets $BlobNumberOfRecordSets
    #}

    Test-VerifyLock -ResourceId $esan.Id
    Test-VerifyRoleAssignment -ResourceId $esan.Id

    return $esan
}
