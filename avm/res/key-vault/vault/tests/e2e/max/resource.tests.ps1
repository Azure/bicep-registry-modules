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

Describe 'Validate Key Vault' {

    It 'Public endpoint should be disabled' {

        $keyVaultResourceId = $TestInputData.DeploymentOutputs.resourceId.Value

        $deployedResource = Get-AzResource -ResourceId $keyVaultResourceId

        $deployedResource.Properties.publicNetworkAccess | Should -Be 'Disabled'
    }
}