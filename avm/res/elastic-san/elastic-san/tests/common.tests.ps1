function Test-VerifyLock($LockName, $ResourceId) {

    if ( $LockName ) {

        $r = Get-AzResource -ResourceId $ResourceId
        $r | Should -Not -BeNullOrEmpty

        $l = Get-AzResourceLock -LockName $LockName -Scope $ResourceId
        $l | Should -Not -BeNullOrEmpty

        $l.Name | Should -Be $LockName
        $l.ResourceId | Should -Not -BeNullOrEmpty # ****/Microsoft.Authorization/locks/myCustomLockName
        $l.ResourceName | Should -Be $r.Name
        $l.ResourceType | Should -Be $r.ResourceType
        $l.ExtensionResourceName | Should -Be $LockName
        $l.ExtensionResourceType | Should -Be 'Microsoft.Authorization/locks'
        $l.ResourceGroupName | Should -Be $r.ResourceGroupName
        $l.SubscriptionId | Should -Not -BeNullOrEmpty
        $l.Properties | Should -Not -BeNullOrEmpty
        $l.LockId | Should -Not -BeNullOrEmpty
    }
}

function Test-VerifyRoleAssignment($ResourceId, $ExpectedRoleAssignments) {

    if ( $ExpectedRoleAssignments ) {

        $r = Get-AzRoleAssignment -Scope $ResourceId
        $r | Should -Not -BeNullOrEmpty

        # Convert received role assignments to a dictionary for easy lookup
        $assignedRoles = @{}
        foreach ($item in $r) {

            # We are only interested in the roles assigned to the resource directly
            if ($item.Scope -ne $ResourceId) {
                continue
            }

            $assignedRoles.add( $item.RoleDefinitionName, $item)
        }

        $assignedRoles.Count | Should -Be $ExpectedRoleAssignments.Count

        foreach ($item in $ExpectedRoleAssignments) {

            $a = $assignedRoles[$item.RoleDefinitionName]
            $a | Should -Not -BeNullOrEmpty

            $a.RoleAssignmentName | Should -Not -BeNullOrEmpty
            $a.RoleAssignmentId | Should -Not -BeNullOrEmpty
            $a.Scope | Should -Be $ResourceId
            # $a.DisplayName | Should -Not -BeNullOrEmpty
            $a.SignInName | Should -Be $null
            $a.RoleDefinitionName | Should -Be $item.RoleDefinitionName
            $a.RoleDefinitionId | Should -Not -BeNullOrEmpty
            $a.ObjectId | Should -Not -BeNullOrEmpty
            #$a.ObjectType | Should -Be 'ServicePrincipal'
            $a.CanDelegate | Should -Be $false
            $a.Description | Should -BeNullOrEmpty
            $a.ConditionVersion | Should -BeNullOrEmpty
            $a.Condition | Should -BeNullOrEmpty
        }
    }
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

function Test-VerifyDiagSettings($ResourceId, $DiagName, $LogAnalyticsWorkspaceResourceId) {
    $diag = Get-AzDiagnosticSetting -ResourceId $ResourceId -Name $DiagName
    $diag | Should -Not -BeNullOrEmpty
    #$diag.ProvisioningState | Should -Be "Succeeded"     # Not available in the output

    $diag.EventHubAuthorizationRuleId | Should -Not -BeNullOrEmpty
    $diag.EventHubName | Should -Not -BeNullOrEmpty
    $diag.Id | Should -Not -BeNullOrEmpty
    $diag.Log | ConvertFrom-Json | Should -BeNullOrEmpty
    $diag.LogAnalyticsDestinationType | Should -BeNullOrEmpty
    $diag.MarketplacePartnerId | Should -BeNullOrEmpty

    $diag.Metric.Count | Should -Be 1
    $diag.Metric[0] | Should -Not -BeNullOrEmpty
    $diag.Metric[0].Category | Should -Be 'Transaction'
    $diag.Metric[0].Enabled | Should -Be $true
    # $diag.Metric[0].RetentionPolicy.Enabled | Should -Be $false
    # $diag.Metric[0].RetentionPolicy.Days | Should -Be 0

    $diag.Name | Should -Be $DiagName
    $diag.ServiceBusRuleId | Should -BeNullOrEmpty
    $diag.StorageAccountId | Should -Not -BeNullOrEmpty
    #Skip $diag.SystemData**
    $diag.Type | Should -Be 'Microsoft.Insights/diagnosticSettings'
    $diag.WorkspaceId | Should -Be $LogAnalyticsWorkspaceResourceId

    # ===

    $diagCat = Get-AzDiagnosticSettingCategory -ResourceId $ResourceId
    $diagCat | Should -Not -BeNullOrEmpty
    #$diagCat.ProvisioningState | Should -Be "Succeeded"     # Not available in the output

    $diagCat.CategoryGroup | Should -BeNullOrEmpty
    $diagCat.CategoryType | Should -Be 'Metrics'
    $diagCat.Id | Should -Not -BeNullOrEmpty
    $diagCat.Name | Should -Be 'Transaction'
    #Skip $diagCat.SystemData**
    $diagCat.Type | Should -Be 'microsoft.insights/diagnosticSettingsCategories'
}

function Test-VerifyElasticSANPrivateEndpoints($GroupIds, $PrivateEndpointConnections, $PrivateEndpointCounts, $PrivateEndpoints, $Tags, $Lock) {

    if ( $GroupIds ) {

        $PrivateEndpointConnections | Should -Not -BeNullOrEmpty
        $PrivateEndpointConnections | ConvertFrom-Json | Should -Not -BeNullOrEmpty
        $PrivateEndpointConnections.Count | Should -Be $GroupIds.Count

        if ($PrivateEndpointCounts -eq 0) {
            $PrivateEndpoints | Should -BeNullOrEmpty
        } else {
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

                # TODO: Some PEPs don't have customDnsConfig some do. Need to check why
                if ( $PrivateEndpoints[$i].customDnsConfig ) {
                    $PrivateEndpoints[$i].customDnsConfig | Should -Not -BeNullOrEmpty
                    $PrivateEndpoints[$i].customDnsConfig.fqdn | Should -Not -BeNullOrEmpty
                    $PrivateEndpoints[$i].customDnsConfig.ipAddresses | Should -Not -BeNullOrEmpty
                    $PrivateEndpoints[$i].customDnsConfig.ipAddresses[0] | Should -Not -BeNullOrEmpty
                }

                $PrivateEndpoints[$i].networkInterfaceResourceIds | Should -Not -BeNullOrEmpty

                Test-VerifyTagsForResource -ResourceId $PrivateEndpoints[$i].resourceId -Tags $Tags
                if ($Lock) {
                    Test-VerifyLock -LockName 'myCustomLockName' -ResourceId $PrivateEndpoints[$i].resourceId
                }
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

function Test-VerifyElasticSANVolumeGroup($ResourceId, $ElasticSanName, $ResourceGroupName, $Name, $ExpectedLocation, $Location, $SystemAssignedMI, $UserAssignedMI, $TenantId, $UserAssignedMIResourceId, $SystemAssignedMIPrincipalId, $NetworkAclsVirtualNetworkRule, $CMK, $CMKUMIResourceId, $CMKKeyVaultKeyUrl, $CMKKeyVaultEncryptionKeyName, $CMKKeyVaultUrl, $CMKKeyVaultEncryptionKeyVersion, $GroupIds, $PrivateEndpointCounts, $PrivateEndpoints, $Tags, $Lock) {

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
    } else {
        $PrivateEndpoints | Should -Not -BeNullOrEmpty
        $PrivateEndpoints.Count | Should -Be $PrivateEndpointCounts
    }

    Test-VerifyElasticSANPrivateEndpoints -GroupIds $GroupIds -PrivateEndpointConnections $vg.PrivateEndpointConnection -PrivateEndpointCounts $PrivateEndpointCounts -PrivateEndpoints $PrivateEndpoints -Tags $Tags -Lock $Lock

    $vg.ProtocolType | Should -Be 'iSCSI'
    $vg.ResourceGroupName | Should -Be $ResourceGroupName
    #Skip $vg.SystemData**
    $vg.Type | Should -Be 'Microsoft.ElasticSan/elasticSans/volumeGroups'
}

function Test-VerifyElasticSAN($ResourceId, $ResourceGroupName, $Name, $Location, $Tags, $AvailabilityZone, $BaseSizeTiB, $ExtendedCapacitySizeTiB, $PublicNetworkAccess, $SkuName, $VolumeGroupCount, $GroupIds, $ExpectedRoleAssignments, $LogAnalyticsWorkspaceResourceId, $Lock) {

    $esan = Get-AzElasticSan -ResourceGroupName $ResourceGroupName -Name $Name
    $esan | Should -Not -BeNullOrEmpty
    $esan.ProvisioningState | Should -Be 'Succeeded'

    if ( $AvailabilityZone ) {

        $esan.AvailabilityZone | Should -Not -BeNullOrEmpty
        $esan.AvailabilityZone[0] | Should -Be $AvailabilityZone
        $esan.SkuName | Should -Be 'Premium_LRS'

    } else {

        $esan.AvailabilityZone | Should -BeNullOrEmpty
        $esan.SkuName | Should -Be 'Premium_ZRS'

    }

    $esan.BaseSizeTiB | Should -Be $BaseSizeTiB
    $esan.ExtendedCapacitySizeTiB | Should -Be $ExtendedCapacitySizeTiB
    $esan.Id | Should -Be $ResourceId
    $esan.Location | Should -Be $Location
    $esan.Name | Should -Be $Name

    Test-VerifyElasticSANPrivateEndpoints -GroupIds $GroupIds -PrivateEndpointConnections $esan.PrivateEndpointConnection -PrivateEndpointCounts 0 -PrivateEndpoints $null -Tags $null -Lock $Lock

    $esan.PublicNetworkAccess | Should -Be $PublicNetworkAccess
    $esan.ResourceGroupName | Should -Be $ResourceGroupName
    $esan.SkuName | Should -Be $SkuName
    $esan.SkuTier | Should -Be 'Premium'
    #Skip $esan.SystemData**
    #Skip $esan.Tag - It is tested below
    #Skip $esan.TotalIops
    #Skip $esan.TotalMBps
    #Skip $esan.TotalSizeTiB | Should -Be $TotalSizeTiB
    #Skip $esan.TotalVolumeSizeGiB | Should -Be $TotalVolumeSizeGiB
    $esan.Type | Should -Be 'Microsoft.ElasticSan/ElasticSans'
    $esan.VolumeGroupCount | Should -Be $VolumeGroupCount

    Test-VerifyTagsForResource -ResourceId $esan.Id -Tags $Tags

    Test-VerifyLock -LockName $null -ResourceId $esan.Id # ESAN Doesn't have Locks
    Test-VerifyRoleAssignment -ResourceId $esan.Id -ExpectedRoleAssignments $ExpectedRoleAssignments

    if ($LogAnalyticsWorkspaceResourceId) {
        Test-VerifyDiagSettings -ResourceId $esan.Id -DiagName 'customSetting' -LogAnalyticsWorkspaceResourceId $LogAnalyticsWorkspaceResourceId
    }

    return $esan
}
