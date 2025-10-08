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

Describe 'Validate resource deployment' {

    Context 'Origins' {

        It 'Should have all expected origins deployed' {

            Write-Verbose ($TestInputData | ConvertTo-Json) -Verbose

            $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
            $cdnProfileName = $TestInputData.DeploymentOutputs.name.Value
            $moduleTestFolderPath = $TestInputData.ModuleTestFolderPath
            $templateData = bicep build (Join-Path $moduleTestFolderPath 'main.test.bicep') --stdout | ConvertFrom-Json -AsHashtable
            $templateParameters = ($templateData.resources | Where-Object { $_.name -like '*-test-*' }).properties.parameters
            $expectedOriginGroups = $templateParameters.originGroups.Value

            foreach ($originGroup in $expectedOriginGroups) {
                $fetchedOriginGroup = Get-AzFrontDoorCdnOriginGroup -ResourceGroupName $resourceGroupName -ProfileName $cdnProfileName -OriginGroupName $originGroup.name
                $fetchedOriginGroup | Should -Not -BeNullOrEmpty

                foreach ($origin in $originGroup.origins) {
                    $fetchedOrigin = Get-AzFrontDoorCdnOrigin -ResourceGroupName $resourceGroupName -ProfileName $cdnProfileName -OriginGroupName $originGroup.name -OriginName $origin.name
                    $fetchedOrigin | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
