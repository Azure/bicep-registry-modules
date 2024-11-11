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

        $expectedVolumeGroupsCount = 8
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
                -PublicNetworkAccess 'Enabled' `
                -SkuName 'Premium_ZRS' `
                -VolumeGroupCount $expectedVolumeGroupsCount
        }

        It 'Check Azure Elastic SAN Volume Groups' {

            # Volume Groups
            $expectedData = @(
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$false;UserAssignedMI=$false;CMK=$false }   # vol-grp-01
                @{ VolumeCounts=2;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$false;UserAssignedMI=$false;CMK=$false }   # vol-grp-02
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=1;SystemAssignedMI=$false;UserAssignedMI=$false;CMK=$false }   # vol-grp-03
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$true;UserAssignedMI=$false;CMK=$false }    # vol-grp-04
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$false;UserAssignedMI=$true;CMK=$false }    # vol-grp-05
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$true;UserAssignedMI=$true;CMK=$false }     # vol-grp-06
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$false;UserAssignedMI=$true;CMK=$true }     # vol-grp-07 - CMK
                @{ VolumeCounts=0;NetworkAclsVirtualNetworkRuleCount=0;SystemAssignedMI=$false;UserAssignedMI=$true;CMK=$true }     # vol-grp-08 - CMK
            )

            $volumeGroups.Count | Should -Be $expectedData.Count # Sanity Check

            foreach ($item in $expectedData) {

                $vgrpidx = $expectedData.IndexOf($item)

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
                    -SystemAssignedMI $item.SystemAssignedMI `
                    -UserAssignedMI $item.UserAssignedMI `
                    -SystemAssignedMIPrincipalId $volumeGroups[$vgrpidx].systemAssignedMIPrincipalId `
                    -NetworkAclsVirtualNetworkRuleCount $item.NetworkAclsVirtualNetworkRuleCount `
                    -CMK $item.CMK `
                    -PrivateEndpointConnection $null

                if ($item.VolumeCounts -eq 0) {
                    $volumeGroups[$vgrpidx].volumes | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes.Count | Should -Be 0
                }
                else {
                    $volumeGroups[$vgrpidx].volumes | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes.Count | Should -Be $item.VolumeCounts
                }

                # TODO: $volumeGroups[$vgrpidx].privateEndpoints | Should -Not -BeNullOrEmpty
                # TODO: $volumeGroups[$vgrpidx].privateEndpoints.Count | Should -Be 2
            }
        }

        It 'Check Azure Elastic SAN Volumes' {

            # Volumes
            $expectedData = @(
                @{ SizeGiB=1;SnapshotCount=0 }  # vol-grp-02-vol-01
                @{ SizeGiB=2;SnapshotCount=2 }  # vol-grp-02-vol-02
            )

            $vgrpidx = 1
            $volumeGroups[$vgrpidx].volumes.Count | Should -Be $expectedData.Count # Sanity Check

            foreach ($item in $expectedData) {

                $volidx = $expectedData.IndexOf($item)

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
                    -SizeGiB $item.SizeGiB

                if ($item.SnapshotCount -eq 0) {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be 0
                }
                else {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $item.SnapshotCount
                }
            }
        }

        It 'Check Azure Elastic SAN Volume Snapshots' {

            # Snapshots
            $expectedData = @(
                @{ SourceVolumeSizeGiB=2 }  # vol-grp-02-vol-02-snap-01
                @{ SourceVolumeSizeGiB=2 }  # vol-grp-02-vol-02-snap-02
            )

            $vgrpidx = 1
            $volidx = 1

            $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $expectedData.Count # Sanity Check

            foreach ($item in $expectedData) {

                $snapidx = $expectedData.IndexOf($item)

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
                    -SourceVolumeSizeGiB $item.SourceVolumeSizeGiB
            }
        }
    }
}
