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

            # Volume - vol-grp-01-vol-01
            $vgrpidx = 0
            $volidx = 0
            $SizeGiB = 1
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
                -SizeGiB $SizeGiB
            $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -BeNullOrEmpty
            #$volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be 0

            # Volume - vol-grp-01-vol-02
            $vgrpidx = 0
            $volidx = 1
            $SizeGiB = 2
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
                -SizeGiB $SizeGiB
            $volumeGroups[$vgrpidx].volumes[$volidx].snapshots | Should -Not -BeNullOrEmpty
            $volumeGroups[$vgrpidx].volumes[$volidx].snapshots.Count | Should -Be 2
        }

        It 'Check Azure Elastic SAN Volume Snapshots' {

            # Snapshot - vol-grp-01-vol-02-snap-01
            $vgrpidx = 0
            $volidx = 1
            $snapidx = 0
            $SourceVolumeSizeGiB = 2

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

            # Snapshot - vol-grp-01-vol-02-snap-02
            $vgrpidx = 0
            $volidx = 1
            $snapidx = 1
            $SourceVolumeSizeGiB = 2

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
