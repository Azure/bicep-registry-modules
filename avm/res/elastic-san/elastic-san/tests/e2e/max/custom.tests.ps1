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

        # TODO: Add additional outputs as needed
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
                -VolumeGroupCount 1
        }

        It 'Check Azure Elastic SAN Volume Groups' {

            # Volume Group - vol-grp-01
            $vgrpidx = 0
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
            $volumeGroups[$vgrpidx].volumes | Should -Not -BeNullOrEmpty
            $volumeGroups[$vgrpidx].volumes.Count | Should -Be 2
            # TODO: $volumeGroups[$vgrpidx].privateEndpoints | Should -Not -BeNullOrEmpty
            # TODO: $volumeGroups[$vgrpidx].privateEndpoints.Count | Should -Be 2
        }

        It 'Check Azure Elastic SAN Volumes' {

            # Volumes - vol-grp-01-vol-01 and vol-grp-01-vol-02
            $vgrpidx = 0
            $sizes = @(1, 2)
            $snapshotCounts = @(0, 2)

            For ($volidx=0; $volidx -lt $sizes.Count; $volidx++) {

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
                    -SizeGiB $sizes[$volidx]

                if ($snapshotCounts[$volidx] -eq 0) {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be 0
                }
                else {
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -Not -BeNullOrEmpty
                    $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be $snapshotCounts[$volidx]
                }
            }
        }

        It 'Check Azure Elastic SAN Volume Snapshots' {

            # Snapshots - vol-grp-01-vol-02-snap-01 and vol-grp-01-vol-02-snap-02
            $vgrpidx = 0
            $volidx = 1
            $SourceVolumeSizeGiB = 2

            For ($snapidx=0; $snapidx -lt 2; $snapidx++) {

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
