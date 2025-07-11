param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{Owner = 'Contoso'; CostCenter = '123-456-789' }
        $expectedVolumeGroupsCount = 6

        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $name = $TestInputData.DeploymentOutputs.name.Value
        $location = $TestInputData.DeploymentOutputs.location.Value
        $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
        $volumeGroups = $TestInputData.DeploymentOutputs.volumeGroups.Value
    }

    Context 'Basic Tests' {

        BeforeAll {
        }

        It 'Check Output Variables' {

            Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                -ResourceId $resourceId `
                -Name $name `
                -Location $location `
                -ResourceGroupName $resourceGroupName
            $volumeGroups | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Azure Elastic SAN Tests' {

        BeforeAll {
        }

        It 'Check Azure Elastic SAN' {

            $expectedRoleAssignments = @(
                @{ RoleDefinitionName = 'Owner' }
                @{ RoleDefinitionName = 'Contributor' }
                @{ RoleDefinitionName = 'Reader' }
                @{ RoleDefinitionName = 'Role Based Access Control Administrator' }
                @{ RoleDefinitionName = 'User Access Administrator' }
                @{ RoleDefinitionName = 'Elastic SAN Network Admin' }
                @{ RoleDefinitionName = 'Elastic SAN Owner' }
                @{ RoleDefinitionName = 'Elastic SAN Reader' }
                @{ RoleDefinitionName = 'Elastic SAN Volume Group Owner' }
            )

            Test-VerifyElasticSAN `
                -ResourceId $resourceId `
                -ResourceGroupName $resourceGroupName `
                -Name $name `
                -Location $location `
                -Tags $expectedTags  `
                -AvailabilityZone 3 `
                -BaseSizeTiB 2 `
                -ExtendedCapacitySizeTiB 1 `
                -PublicNetworkAccess 'Enabled' `
                -SkuName 'Premium_LRS' `
                -VolumeGroupCount $expectedVolumeGroupsCount `
                -GroupIds $null `
                -ExpectedRoleAssignments $expectedRoleAssignments `
                -LogAnalyticsWorkspaceResourceId $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceId.Value `
                -Locks $false
        }

        It 'Check Azure Elastic SAN Volume Groups' {

            # Volume Groups
            $VNR = $TestInputData.DeploymentOutputs.virtualNetworkRule.Value
            $expectedData = @(
                @{ VolumeCounts = 0; VirtualNetworkRule = $null; SystemAssignedMI = $false; UserAssignedMI = $false }  # vol-grp-01
                @{ VolumeCounts = 2; VirtualNetworkRule = $null; SystemAssignedMI = $false; UserAssignedMI = $false }  # vol-grp-02
                @{ VolumeCounts = 0; VirtualNetworkRule = $VNR; SystemAssignedMI = $false; UserAssignedMI = $false }   # vol-grp-03
                @{ VolumeCounts = 0; VirtualNetworkRule = $null; SystemAssignedMI = $true; UserAssignedMI = $false }   # vol-grp-04
                @{ VolumeCounts = 0; VirtualNetworkRule = $null; SystemAssignedMI = $false; UserAssignedMI = $true }   # vol-grp-05
                @{ VolumeCounts = 0; VirtualNetworkRule = $null; SystemAssignedMI = $true; UserAssignedMI = $true }    # vol-grp-06
            )

            $volumeGroups.Count | Should -Be $expectedData.Count # Sanity Check

            foreach ($item in $expectedData) {

                $vgrpidx = $expectedData.IndexOf($item)

                Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                    -ResourceId $volumeGroups[$vgrpidx].resourceId `
                    -Name $volumeGroups[$vgrpidx].name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].resourceGroupName `
                    -Location $null # Location is NOT Supported on this resource

                Test-VerifyElasticSANVolumeGroup `
                    -ResourceId $volumeGroups[$vgrpidx].resourceId `
                    -ElasticSanName $name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].resourceGroupName `
                    -Name $volumeGroups[$vgrpidx].name `
                    -ExpectedLocation $location `
                    -Location $volumeGroups[$vgrpidx].location `
                    -SystemAssignedMI $item.SystemAssignedMI `
                    -UserAssignedMI $item.UserAssignedMI `
                    -TenantId $TestInputData.DeploymentOutputs.tenantId.Value `
                    -UserAssignedMIResourceId $TestInputData.DeploymentOutputs.managedIdentityResourceId.Value `
                    -SystemAssignedMIPrincipalId $volumeGroups[$vgrpidx].systemAssignedMIPrincipalId `
                    -NetworkAclsVirtualNetworkRule $item.VirtualNetworkRule `
                    -CMK $false `
                    -CMKUMIResourceId $null `
                    -CMKKeyVaultKeyUrl $null `
                    -CMKKeyVaultEncryptionKeyName $null `
                    -CMKKeyVaultUrl $null `
                    -CMKKeyVaultEncryptionKeyVersion $null `
                    -GroupIds $null `
                    -PrivateEndpointCounts 0 `
                    -PrivateEndpoints $null `
                    -Tags $expectedTags `
                    -Locks $false

                if ($item.VolumeCounts -eq 0) {
                    $volumeGroups[$vgrpidx].volumes | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes.Count | Should -Be 0
                } else {
                    $volumeGroups[$vgrpidx].volumes | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes.Count | Should -Be $item.VolumeCounts
                }
            }
        }

        It 'Check Azure Elastic SAN Volumes' {

            # Volumes
            $expectedData = @(
                @{ SizeGiB = 1; SnapshotCount = 0 }  # vol-grp-02-vol-01
                @{ SizeGiB = 2; SnapshotCount = 2 }  # vol-grp-02-vol-02
            )

            $vgrpidx = 1
            $volumeGroups[$vgrpidx].volumes.Count | Should -Be $expectedData.Count # Sanity Check

            foreach ($item in $expectedData) {

                $volidx = $expectedData.IndexOf($item)

                Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].resourceId `
                    -Name $volumeGroups[$vgrpidx].volumes[$volidx].name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].resourceGroupName`
                    -Location $null # Location is NOT Supported on this resource

                Test-VerifyElasticSANVolume `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].resourceId `
                    -ElasticSanName $name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].resourceGroupName `
                    -VolumeGroupName $volumeGroups[$vgrpidx].name `
                    -Name $volumeGroups[$vgrpidx].volumes[$volidx].name `
                    -ExpectedLocation $location `
                    -Location $volumeGroups[$vgrpidx].volumes[$volidx].location `
                    -TargetIqn $volumeGroups[$vgrpidx].volumes[$volidx].targetIqn `
                    -TargetPortalHostname $volumeGroups[$vgrpidx].volumes[$volidx].targetPortalHostname `
                    -TargetPortalPort $volumeGroups[$vgrpidx].volumes[$volidx].targetPortalPort `
                    -VolumeId $volumeGroups[$vgrpidx].volumes[$volidx].volumeId `
                    -SizeGiB $item.SizeGiB

                if ($item.SnapshotCount -eq 0) {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be 0
                } else {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $item.SnapshotCount
                }
            }
        }

        It 'Check Azure Elastic SAN Volume Snapshots' {

            # Snapshots
            $expectedData = @(
                @{ SourceVolumeSizeGiB = 2 }  # vol-grp-02-vol-02-snap-01
                @{ SourceVolumeSizeGiB = 2 }  # vol-grp-02-vol-02-snap-02
            )

            $vgrpidx = 1
            $volidx = 1

            $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $expectedData.Count # Sanity Check

            foreach ($item in $expectedData) {

                $snapidx = $expectedData.IndexOf($item)

                Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceId `
                    -Name $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceGroupName `
                    -Location $null # Location is NOT Supported on this resource

                Test-VerifyElasticSANVolumeSnapshot `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceId `
                    -ElasticSanName $name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceGroupName `
                    -VolumeGroupName $volumeGroups[$vgrpidx].name `
                    -VolumeName $volumeGroups[$vgrpidx].volumes[$volidx].name `
                    -Name $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].name `
                    -ExpectedLocation $location `
                    -Location $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].location `
                    -VolumeResourceId $volumeGroups[$vgrpidx].volumes[$volidx].resourceId `
                    -SourceVolumeSizeGiB $item.SourceVolumeSizeGiB
            }
        }
    }
}
