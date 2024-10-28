param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Deployment' {

    BeforeAll {

        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $name = $TestInputData.DeploymentOutputs.name.Value
        $location = $TestInputData.DeploymentOutputs.location.Value
        $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
        $systemAssignedMIPrincipalId = $TestInputData.DeploymentOutputs.systemAssignedMIPrincipalId.Value

        # TODO: Add additional outputs as needed
    }

    Context 'Basic Tests' {

        BeforeAll {
        }

        It 'Check Output Variables' {

            $resourceId | Should -Not -BeNullOrEmpty
            $name | Should -Not -BeNullOrEmpty
            $location | Should -Not -BeNullOrEmpty
            $resourceGroupName | Should -Not -BeNullOrEmpty
            $systemAssignedMIPrincipalId | Should -Not -BeNullOrEmpty

            # TODO: Add additional outputs as needed
        }

        # TODO: Add additional Basic Checks as needed
    }

    # TODO: Add additional Context Checks as needed
}
