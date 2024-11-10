param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{Owner = 'Contoso'; CostCenter = '123-456-789' }

        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $name = $TestInputData.DeploymentOutputs.name.Value
        $location = $TestInputData.DeploymentOutputs.location.Value
        $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
        $volumeGroups = $TestInputData.DeploymentOutputs.volumeGroups.Value

        $expectedVolumeGroupsCount = 3
    }

    Context 'Basic Tests' {

        BeforeAll {
        }

        It 'Check Output Variables' {

            Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                -ResourceId $resourceId `
                -name $name `
                -Location $location `
                -ResourceGroupName $resourceGroupName
            $volumeGroups | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Azure Elastic SAN Tests' {

        BeforeAll {
        }

        It 'Check Azure Elastic SAN' {

            Test-VerifyElasticSAN `
                -ResourceId $resourceId `
                -ResourceGroupName $resourceGroupName `
                -name $name `
                -Location $location `
                -Tags $expectedTags  `
                -BaseSizeTiB 1 `
                -ExtendedCapacitySizeTiB 0 `
                -PublicNetworkAccess $null `
                -SkuName 'Premium_ZRS' `
                -VolumeGroupCount $expectedVolumeGroupsCount
        }

        It 'Check Azure Elastic SAN Volume Groups' {

            # Volume Groups
            $expectedData = @{
                01 = @{
                    VolumeCounts = 0
                    NetworkAclsVirtualNetworkRuleCount = 0
                    PrivateEndpointConnection = $null
                }
                02 = @{
                    VolumeCounts = 2
                    NetworkAclsVirtualNetworkRuleCount = 0
                    PrivateEndpointConnection = $null
                }
                03 = @{
                    VolumeCounts = 0
                    NetworkAclsVirtualNetworkRuleCount = 1
                    PrivateEndpointConnection = 'Enabled'
                }
            }

            $volumeGroups.Count | Should -Be $expectedData.Count # Sanity Check

            For ($vgrpidx=0; $vgrpidx -le $expectedVolumeGroupsCount; $vgrpidx++) {

                Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                    -ResourceId $volumeGroups[$vgrpidx].resourceId `
                    -name $volumeGroups[$vgrpidx].name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].resourceGroupName `
                    -Location $null # Location is NOT Supported on this resource

                Test-VerifyElasticSANVolumeGroup `
                    -ResourceId $volumeGroups[$vgrpidx].resourceId `
                    -ElasticSanName $name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].resourceGroupName `
                    -Name $volumeGroups[$vgrpidx].name `
                    -SystemAssignedMIPrincipalId $volumeGroups[$vgrpidx].systemAssignedMIPrincipalId
                    -NetworkAclsVirtualNetworkRuleCount $expectedData[$vgrpidx].NetworkAclsVirtualNetworkRuleCount
                    -PrivateEndpointConnection $expectedData[$vgrpidx].PrivateEndpointConnection

                if ($expectedData[$vgrpidx].VolumeCounts -eq 0) {
                    $volumeGroups[$vgrpidx].volumes | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes.Count | Should -Be 0
                }
                else {
                    $volumeGroups[$vgrpidx].volumes | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes.Count | Should -Be $expectedData[$vgrpidx].VolumeCounts
                }

                # TODO: $volumeGroups[$vgrpidx].privateEndpoints | Should -Not -BeNullOrEmpty
                # TODO: $volumeGroups[$vgrpidx].privateEndpoints.Count | Should -Be 2
            }
        }

        It 'Check Azure Elastic SAN Volumes' {

            # Volumes
            $expectedData = @{
                01 = @{
                    SizeGiB = 1
                    SnapshotCount = 0
                }
                02 = @{
                    SizeGiB = 2
                    SnapshotCount = 2
                }
            }

            $vgrpidx = 1
            $volumeGroups[$vgrpidx].volumes.Count | Should -Be $expectedData.Count # Sanity Check

            For ($volidx=0; $volidx -le $expectedData.Count; $volidx++) {

                Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].resourceId `
                    -name $volumeGroups[$vgrpidx].volumes[$volidx].name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].resourceGroupName `
                    -Location $null # Location is NOT Supported on this resource

                Test-VerifyElasticSANVolume `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].resourceId `
                    -ElasticSanName $name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].resourceGroupName `
                    -VolumeGroupName $volumeGroups[$vgrpidx].name `
                    -Name $volumeGroups[$vgrpidx].volumes[$volidx].name `
                    -TargetIqn $volumeGroups[$vgrpidx].volumes[$volidx].targetIqn `
                    -TargetPortalHostname $volumeGroups[$vgrpidx].volumes[$volidx].targetPortalHostname `
                    -TargetPortalPort $volumeGroups[$vgrpidx].volumes[$volidx].targetPortalPort `
                    -VolumeId $volumeGroups[$vgrpidx].volumes[$volidx].volumeId `
                    -SizeGiB $expectedData[$volidx].SizeGiB

                if ($expectedData[$volidx].SnapshotCount -eq 0) {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be 0
                }
                else {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $expectedData[$volidx].SnapshotCount
                }
            }
        }

        It 'Check Azure Elastic SAN Volume Snapshots' {

            # Snapshots - vol-grp-02-vol-02-snap-01 and vol-grp-02-vol-02-snap-02
            $vgrpidx = 1
            $volidx = 1
            $SourceVolumeSizeGiB = 2

            $expectedSnapshotsCount = 2
            $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $expectedSnapshotsCount # Sanity Check

            For ($snapidx=0; $snapidx -le $expectedSnapshotsCount; $snapidx++) {

                Test-VerifyOutputVariables -MustBeNullOrEmpty $false `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceId `
                    -name $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceGroupName `
                    -Location $null # Location is NOT Supported on this resource

                Test-VerifyElasticSANVolumeSnapshot `
                    -ResourceId $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceId `
                    -ElasticSanName $name `
                    -ResourceGroupName $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].resourceGroupName `
                    -VolumeGroupName $volumeGroups[$vgrpidx].name `
                    -VolumeName $volumeGroups[$vgrpidx].volumes[$volidx].name `
                    -Name $volumeGroups[$vgrpidx].volumes[$volidx].snapshots[$snapidx].name `
                    -VolumeResourceId $volumeGroups[$vgrpidx].volumes[$volidx].resourceId `
                    -SourceVolumeSizeGiB $SourceVolumeSizeGiB
            }
        }
    }
}
