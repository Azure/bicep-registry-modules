######################################
## Additional post-deployment tests ##
######################################
##
## You can add any custom post-deployment validation tests you want here, or add them spread accross multiple test files in the test case folder.
##
###########################

param (
    [Parameter(Mandatory)]
    [hashtable] $DeploymentOutputs
)

Describe 'Validate key vault' {

    It 'Public endpoint disabled' {

        $keyVaultResourceId = $DeploymentOutputs.resourceId.Value

        $deployedResource = Get-AzResource -ResourceId $keyVaultResourceId

        $deployedResource.Properties.publicNetworkAccess | Should -Be 'Disabled'
    }
}