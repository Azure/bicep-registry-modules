param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{Owner = 'Contoso'; CostCenter = '123-456-789' }
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
                -Name $name `
                -Location $location `
                -Tags $expectedTags  `
                -AvailabilityZone $null `
                -BaseSizeTiB 1 `
                -ExtendedCapacitySizeTiB 0 `
                -PublicNetworkAccess 'Disabled' `
                -SkuName 'Premium_ZRS' `
                -VolumeGroupCount $expectedVolumeGroupsCount `
                -GroupIds $groupIds `
                -ExpectedRoleAssignments $null `
                -LogAnalyticsWorkspaceResourceId $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceId.Value `
                -Locks $false
        }

        It 'Check Azure Elastic SAN Volume Groups' {

            # Volume Groups
            $expectedData = @(
                @{ PrivateEndpointCounts = 1; CMK = $true }  # vol-grp-01
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
                    -SystemAssignedMI $false `
                    -UserAssignedMI $true `
                    -TenantId $TestInputData.DeploymentOutputs.tenantId.Value `
                    -UserAssignedMIResourceId $TestInputData.DeploymentOutputs.managedIdentityResourceId.Value `
                    -SystemAssignedMIPrincipalId $null `
                    -NetworkAclsVirtualNetworkRule $null `
                    -CMK $item.CMK `
                    -CMKUMIResourceId $TestInputData.DeploymentOutputs.managedIdentityResourceId.Value `
                    -CMKKeyVaultKeyUrl $TestInputData.DeploymentOutputs.cmkKeyVaultKeyUrl.Value `
                    -CMKKeyVaultEncryptionKeyName $TestInputData.DeploymentOutputs.cmkKeyVaultEncryptionKeyName.Value `
                    -CMKKeyVaultUrl $TestInputData.DeploymentOutputs.cmkKeyVaultUrl.Value `
                    -CMKKeyVaultEncryptionKeyVersion $TestInputData.DeploymentOutputs.cmkKeyVaultEncryptionKeyVersion.Value `
                    -GroupIds $groupIds `
                    -PrivateEndpointCounts $item.PrivateEndpointCounts `
                    -PrivateEndpoints $volumeGroups[$vgrpidx].privateEndpoints `
                    -Tags $expectedTags `
                    -Locks $false
            }
        }
    }
}
