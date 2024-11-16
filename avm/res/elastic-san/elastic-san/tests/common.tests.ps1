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

function Test-VerifyElasticSANPrivateEndpoints($GroupIds, $PrivateEndpointConnections, $PrivateEndpointCounts, $PrivateEndpoints, $Tags) {

    if ( $GroupIds ) {

        $PrivateEndpointConnections | Should -Not -BeNullOrEmpty
        $PrivateEndpointConnections | ConvertFrom-Json | Should -Not -BeNullOrEmpty
        $PrivateEndpointConnections.Count | Should -Be $GroupIds.Count

        if ($PrivateEndpointCounts -eq 0) {
            $PrivateEndpoints | Should -BeNullOrEmpty
        }
        else {
            $PrivateEndpoints | Should -Not -BeNullOrEmpty
            $PrivateEndpoints.Count | Should -Be $PrivateEndpointConnections.Count
        }

        foreach ($item in $PrivateEndpointConnections) {

            $i = $PrivateEndpointConnections.IndexOf($item)

            $item = $($item | ConvertFrom-Json)

            $item.id | Should -Not -BeNullOrEmpty
            $item.name | Should -Not -BeNullOrEmpty

            $item.properties.privateEndpoint.id | Should -Not -BeNullOrEmpty

            $item.properties.privateLinkServiceConnectionState.status | Should -Be 'Approved'
            $item.properties.privateLinkServiceConnectionState.description | Should -Be 'Auto-Approved'
            $item.properties.privateLinkServiceConnectionState.actionsRequired | Should -Be 'None'

            $item.properties.provisioningState | Should -Be 'Succeeded'
            $item.properties.groupIds | Should -Not -BeNullOrEmpty

            $item.properties.groupIds.Count | Should -Be 1
            $item.properties.groupIds[0] | Should -Be $GroupIds[$i]

            if ($PrivateEndpointCounts -ne 0) {
                $PrivateEndpoints[$i].name | Should -Not -BeNullOrEmpty
                $PrivateEndpoints[$i].location | Should -Not -BeNullOrEmpty
                $PrivateEndpoints[$i].resourceId | Should -Be $item.properties.privateEndpoint.id
                $PrivateEndpoints[$i].groupId | Should -Be $GroupIds[$i]
                $PrivateEndpoints[$i].customDnsConfig | Should -BeNullOrEmpty
                $PrivateEndpoints[$i].networkInterfaceResourceIds | Should -Not -BeNullOrEmpty

                Test-VerifyTagsForResource -ResourceId $PrivateEndpoints[$i].resourceId -Tags $Tags
            }
        }

    } else {

        $PrivateEndpointConnections | Should -BeNullOrEmpty

    }
}

function Test-VerifyElasticSANVolumeSnapshot($ResourceId, $ElasticSanName, $ResourceGroupName, $VolumeGroupName, $VolumeName, $Name, $ExpectedLocation, $Location, $VolumeResourceId, $SourceVolumeSizeGiB) {

    $s = Get-AzElasticSanVolumeSnapshot -ElasticSanName $ElasticSanName -ResourceGroupName $ResourceGroupName -VolumeGroupName $VolumeGroupName -Name $Name
    $s | Should -Not -BeNullOrEmpty
    $s.ProvisioningState | Should -Be 'Succeeded'

    $s.CreationDataSourceId | Should -Be $VolumeResourceId
    $s.Id | Should -Be $ResourceId
    $s.Name | Should -Be $Name
    $Location | Should -Be $ExpectedLocation
    $s.ResourceGroupName | Should -Be $ResourceGroupName
    $s.SourceVolumeSizeGiB | Should -Be $SourceVolumeSizeGiB
    #Skip $s.SystemData**
    $s.Type | Should -Be 'Microsoft.ElasticSan/elasticSans/volumeGroups/snapshots'
    $s.VolumeName | Should -Be $VolumeName
}

function Test-VerifyElasticSANVolume($ResourceId, $ElasticSanName, $ResourceGroupName, $VolumeGroupName, $Name, $ExpectedLocation, $Location, $TargetIqn, $TargetPortalHostname, $TargetPortalPort, $VolumeId, $SizeGiB) {

    $v = Get-AzElasticSanVolume -ElasticSanName $ElasticSanName -ResourceGroupName $ResourceGroupName -VolumeGroupName $VolumeGroupName -Name $Name
    $v | Should -Not -BeNullOrEmpty
    $v.ProvisioningState | Should -Be 'Succeeded'

    $v.CreationDataCreateSource | Should -Be 'None'
    $v.CreationDataSourceId | Should -BeNullOrEmpty
    $v.Id | Should -Be $ResourceId
    $v.ManagedByResourceId | Should -Be 'None'
    $v.Name | Should -Be $Name
    $Location | Should -Be $ExpectedLocation
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

function Test-VerifyElasticSANVolumeGroup($ResourceId, $ElasticSanName, $ResourceGroupName, $Name, $ExpectedLocation, $Location, $SystemAssignedMI, $UserAssignedMI, $TenantId, $UserAssignedMIResourceId, $SystemAssignedMIPrincipalId, $NetworkAclsVirtualNetworkRule, $CMK, $CMKUMIResourceId, $CMKKeyVaultKeyUrl, $CMKKeyVaultEncryptionKeyName, $CMKKeyVaultUrl, $CMKKeyVaultEncryptionKeyVersion, $GroupIds, $PrivateEndpointCounts, $PrivateEndpoints,  $Tags) {

    $vg = Get-AzElasticSanVolumeGroup -ElasticSanName $ElasticSanName -ResourceGroupName $ResourceGroupName -Name $Name
    $vg | Should -Not -BeNullOrEmpty
    $vg.ProvisioningState | Should -Be 'Succeeded'

    if ($CMK) {

        $vg.Encryption | Should -Be 'EncryptionAtRestWithCustomerManagedKey'
        $vg.EncryptionIdentityEncryptionUserAssignedIdentity | Should -Be $CMKUMIResourceId

    } else {

        $vg.Encryption | Should -Be 'EncryptionAtRestWithPlatformKey'
        $vg.EncryptionIdentityEncryptionUserAssignedIdentity | Should -BeNullOrEmpty

    }

    $vg.EnforceDataIntegrityCheckForIscsi | Should -BeNullOrEmpty
    $vg.Id | Should -Be $ResourceId

    if ( $SystemAssignedMI -and $UserAssignedMI ) {

        $vg.IdentityPrincipalId | Should -BeNullOrEmpty                             # Correct?? Question to PG
        $vg.IdentityTenantId | Should -BeNullOrEmpty                                # Correct?? Question to PG
        $vg.IdentityType | Should -Be 'SystemAssigned, UserAssigned'
        $vg.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty # Correct?? Question to PG

    } elseif ($SystemAssignedMI) {

        $vg.IdentityPrincipalId | Should -Be $SystemAssignedMIPrincipalId
        $vg.IdentityTenantId | Should -Be $TenantId
        $vg.IdentityType | Should -Be 'SystemAssigned'
        $vg.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty

    } elseif ($UserAssignedMI) {

        $vg.IdentityPrincipalId | Should -BeNullOrEmpty
        $vg.IdentityTenantId | Should -BeNullOrEmpty                                # Correct?? Question to PG
        $vg.IdentityType | Should -Be 'UserAssigned'

        $vg.IdentityUserAssignedIdentity | Should -Not -BeNullOrEmpty
        $($vg.IdentityUserAssignedIdentity.ToString().Contains($UserAssignedMIResourceId)) | Should -Be $true

    } else {

        # None Identity Specified
        $vg.IdentityPrincipalId | Should -BeNullOrEmpty
        $vg.IdentityTenantId | Should -BeNullOrEmpty
        $vg.IdentityType | Should -BeNullOrEmpty
        $vg.IdentityUserAssignedIdentity | ConvertFrom-Json | Should -BeNullOrEmpty

    }

    if ($CMK) {

        $vg.KeyVaultPropertyCurrentVersionedKeyExpirationTimestamp | Should -Not -BeNullOrEmpty
        $vg.KeyVaultPropertyCurrentVersionedKeyIdentifier | Should -Be $CMKKeyVaultKeyUrl
        $vg.KeyVaultPropertyKeyName | Should -Be $CMKKeyVaultEncryptionKeyName
        $vg.KeyVaultPropertyKeyVaultUri | Should -Be $CMKKeyVaultUrl
        $vg.KeyVaultPropertyKeyVersion | Should -Be $CMKKeyVaultEncryptionKeyVersion
        $vg.KeyVaultPropertyLastKeyRotationTimestamp | Should -Not -BeNullOrEmpty

    } else {

        $vg.KeyVaultPropertyCurrentVersionedKeyExpirationTimestamp | Should -BeNullOrEmpty
        $vg.KeyVaultPropertyCurrentVersionedKeyIdentifier | Should -BeNullOrEmpty
        $vg.KeyVaultPropertyKeyName | Should -BeNullOrEmpty
        $vg.KeyVaultPropertyKeyVaultUri | Should -BeNullOrEmpty
        $vg.KeyVaultPropertyKeyVersion | Should -BeNullOrEmpty
        $vg.KeyVaultPropertyLastKeyRotationTimestamp | Should -BeNullOrEmpty

    }

    $vg.Name | Should -Be $Name
    $Location | Should -Be $ExpectedLocation

    if ( $NetworkAclsVirtualNetworkRule ) {

        $vg.NetworkAclsVirtualNetworkRule | Should -Not -BeNullOrEmpty
        $vg.NetworkAclsVirtualNetworkRule[0].VirtualNetworkResourceId | Should -Be $NetworkAclsVirtualNetworkRule

    } else {

        $vg.NetworkAclsVirtualNetworkRule | Should -BeNullOrEmpty

    }

    if ($PrivateEndpointCounts -eq 0) {
        $PrivateEndpoints | Should -BeNullOrEmpty
    }
    else {
        $PrivateEndpoints | Should -Not -BeNullOrEmpty
        $PrivateEndpoints.Count | Should -Be $PrivateEndpointCounts
    }

    Test-VerifyElasticSANPrivateEndpoints -GroupIds $GroupIds -PrivateEndpointConnections $vg.PrivateEndpointConnection -PrivateEndpointCounts $PrivateEndpointCounts -PrivateEndpoints $PrivateEndpoints -Tags $Tags

    $vg.ProtocolType | Should -Be 'iSCSI'
    $vg.ResourceGroupName | Should -Be $ResourceGroupName
    #Skip $vg.SystemData**
    $vg.Type | Should -Be 'Microsoft.ElasticSan/elasticSans/volumeGroups'
}












function Test-VerifyElasticSAN($ResourceId, $ResourceGroupName, $Name, $Location, $Tags, $AvailabilityZone, $BaseSizeTiB, $ExtendedCapacitySizeTiB, $PublicNetworkAccess, $SkuName, $VolumeGroupCount, $GroupIds) {

    $esan = Get-AzElasticSan -ResourceGroupName $ResourceGroupName -Name $Name
    $esan | Should -Not -BeNullOrEmpty
    $esan.ProvisioningState | Should -Be 'Succeeded'

    if ( $AvailabilityZone ) {

        $esan.AvailabilityZone | Should -Not -BeNullOrEmpty
        $esan.AvailabilityZone[0] | Should -Be $AvailabilityZone

    } else {

        $esan.AvailabilityZone | Should -BeNullOrEmpty

    }

    $esan.BaseSizeTiB | Should -Be $BaseSizeTiB
    $esan.ExtendedCapacitySizeTiB | Should -Be $ExtendedCapacitySizeTiB
    $esan.Id | Should -Be $ResourceId
    $esan.Location | Should -Be $Location
    $esan.Name | Should -Be $Name

    Test-VerifyElasticSANPrivateEndpoints -GroupIds $GroupIds -PrivateEndpointConnections $esan.PrivateEndpointConnection -PrivateEndpointCounts 0 -PrivateEndpoints $null -Tags $null






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














    # TODO Logs + Test-VerifyDiagSettings

    #if ( $BlobNumberOfRecordSets -ne 0 ) {
    #    Test-VerifyDnsZone -Name 'privatelink.blob.core.windows.net' -ResourceGroupName $DatabricksResourceGroupName -Tags $Tags -NumberOfRecordSets $BlobNumberOfRecordSets
    #}

    Test-VerifyLock -ResourceId $esan.Id
    Test-VerifyRoleAssignment -ResourceId $esan.Id

    return $esan
}
