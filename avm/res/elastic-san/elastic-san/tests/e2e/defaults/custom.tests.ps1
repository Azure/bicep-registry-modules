param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{} # Default has no tags

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

            Test-VerifyOutputVariables -MustBeNullOrEmpty $false -ResourceId $resourceId -name $name -Location $location -ResourceGroupName $resourceGroupName
            $volumeGroups | Should -BeNullOrEmpty
        }
    }

    Context 'Azure Elastic SAN Tests' {

        BeforeAll {
        }

        It 'Check Azure Elastic SAN' {

            Test-VerifyElasticSAN -ResourceId $resourceId -ResourceGroupName $resourceGroupName -Name $name -Location $location -Tags $expectedTags  `
                -BaseSizeTiB 1 -ExtendedCapacitySizeTiB 0 -PublicNetworkAccess 'Enabled' -SkuName 'Premium_ZRS' -VolumeGroupCount 0
    }
}
