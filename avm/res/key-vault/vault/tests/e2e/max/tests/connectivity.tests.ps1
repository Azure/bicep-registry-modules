######################################
## Additional post-deployment tests ##
######################################
##
## You can add any custom post-deployment validation tests you want here, or add them spread accross multiple test files in the test case folder.
##
###########################

param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate private endpoint deployment' {

    Context 'Validate sucessful deployment' {

        It 'Private endpoints should be deployed in resource group' {

            $keyVaultResourceId = $TestInputData.DeploymentOutputs.resourceId.Value
            $testResourceGroup = ($keyVaultResourceId -split '\/')[4]
            $deployedPrivateEndpoints = Get-AzPrivateEndpoint -ResourceGroupName $testResourceGroup
            $deployedPrivateEndpoints.Count | Should -BeGreaterThan 0
        }

        It 'Private endpoint should have role assignment' {

            $keyVaultResourceId = $TestInputData.DeploymentOutputs.resourceId.Value
            $testResourceGroup = ($keyVaultResourceId -split '\/')[4]
            $deployedPrivateEndpoints = Get-AzPrivateEndpoint -ResourceGroupName $testResourceGroup

            $firstPrivateEndpointResourceId = $deployedPrivateEndpoints[0].Id
            $firstPrivateEndpointName = ($firstPrivateEndpointResourceId -split '\/')[-1]

            $roleAssignments = Get-AzRoleAssignment -ResourceName $firstPrivateEndpointName -ResourceType 'Microsoft.Network/privateEndpoints' -ResourceGroupName $testResourceGroup
            $roleAssignments.Count | Should -BeGreaterThan 0
        }
    }
}
