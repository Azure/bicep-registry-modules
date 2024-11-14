param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{}
        $groupIds = @( 'vol-grp-01' )
        $expectedVolumeGroupsCount = 1

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

            Test-VerifyElasticSAN `
                -ResourceId $resourceId `
                -ResourceGroupName $resourceGroupName `
                -name $name `
                -Location $location `
                -Tags $expectedTags  `
                -AvailabilityZone 2 `
                -BaseSizeTiB 1 `
                -ExtendedCapacitySizeTiB 0 `
                -PublicNetworkAccess 'Disabled' `
                -SkuName 'Premium_LRS' `
                -VolumeGroupCount $expectedVolumeGroupsCount `
                -GroupIds $groupIds
        }

        It 'Check Azure Elastic SAN Volume Groups' {

            # Volume Groups
            $expectedData = @(
                @{ PrivateEndpoint=$true }  # vol-grp-01
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
                    -SystemAssignedMI $false `
                    -UserAssignedMI $false `
                    -TenantId $null `
                    -UserAssignedMIResourceId $null `
                    -SystemAssignedMIPrincipalId $null `
                    -NetworkAclsVirtualNetworkRule $null `
                    -CMK $false `
                    -CMKUMIResourceId $null `
                    -CMKKeyVaultKeyUrl $null `
                    -CMKKeyVaultEncryptionKeyName $null `
                    -CMKKeyVaultUrl $null `
                    -CMKKeyVaultEncryptionKeyVersion $null `
                    -GroupIds $groupIds
            }
        }
    }
}
