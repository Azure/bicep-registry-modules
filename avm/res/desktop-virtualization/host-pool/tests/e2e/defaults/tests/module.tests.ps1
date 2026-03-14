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

Describe 'Validate Host pool deployment' {

    Context 'Validate sucessful deployment' {

        It 'Registration token should be successfully returned' {
            $obscuredRegistrationToken = $TestInputData.DeploymentOutputs.obscuredRegistrationToken.Value
            $obscuredRegistrationToken | Should -Not -BeNullOrEmpty
        }
    }
}
