param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate DevTest Lab deployment' {

    BeforeAll {
        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $resourceId | Should -Not -BeNullOrEmpty
        $lab = Get-AzResource -ResourceId $resourceId -ExpandProperties -ErrorAction Stop
    }

    It 'Returns a lab in the selected test subscription' {
        $lab.ResourceType | Should -Be 'Microsoft.DevTestLab/labs'
        $lab.ResourceId | Should -Be $resourceId
        ($resourceId -split '/')[2] | Should -Be (Get-AzContext -ErrorAction Stop).Subscription.Id
    }

    It 'Finishes provisioning successfully' {
        $lab.Properties.provisioningState | Should -Be 'Succeeded'
    }

    It 'Preserves the default lab settings' {
        $lab.Properties.labStorageType | Should -Be 'Premium'
        $lab.Properties.environmentPermission | Should -Be 'Reader'
    }
}
