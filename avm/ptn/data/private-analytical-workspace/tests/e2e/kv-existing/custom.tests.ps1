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

Describe 'Validate deployment with provided Azure Key Vault' {

    Context 'Validate sucessful deployment' {

        It 'Check Azure Key Vault' {

            $keyVaultResourceId = $TestInputData.DeploymentOutputs.keyVaultResourceId.Value
            $keyVaultName = $TestInputData.DeploymentOutputs.keyVaultName.Value
            $keyVaultLocation = $TestInputData.DeploymentOutputs.keyVaultLocation.Value
            $keyVaultResourceGroupName = $TestInputData.DeploymentOutputs.keyVaultResourceGroupName.Value
        }
    }
}
