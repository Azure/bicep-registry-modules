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

    Context 'Origins Groups' {

        BeforeDiscovery {
            $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
            $cdnProfileName = $TestInputData.DeploymentOutputs.name.Value
            $namePrefix = $TestInputData.DeploymentOutputs.namePrefix.Value
            $expectedOriginGroups = @("dep-$namePrefix-waf-api-origin-group")

            $originGroupTestCases = [System.Collections.ArrayList]@()
            foreach ($originGroup in $expectedOriginGroups) {

                $originGroupTestCases += @{
                    ExpectedOriginGroupName = $originGroup.name
                    ResourceGroupName       = $resourceGroupName
                    ProfileName             = $cdnProfileName
                }
            }
        }

        It 'Should have all expected origin group [<ExpectedOriginGroupName>] deployed' -TestCases $originGroupTestCases {

            param (
                [string] $ExpectedOriginGroupName,
                [string] $ResourceGroupName,
                [string] $ProfileName
            )

            foreach ($originGroup in $expectedOriginGroups) {
                $fetchedOriginGroup = Get-AzFrontDoorCdnOriginGroup -ResourceGroupName $resourceGroupName -ProfileName $ProfileName -OriginGroupName $ExpectedOriginGroupName
                $fetchedOriginGroup | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context 'Origins' {

        BeforeDiscovery {

            $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
            $cdnProfileName = $TestInputData.DeploymentOutputs.name.Value
            $namePrefix = $TestInputData.DeploymentOutputs.namePrefix.Value
            $expectedOriginGroups = @(
                @{
                    name    = "dep-$namePrefix-waf-api-origin-group"
                    origins = @(
                        "dep-$namePrefix-waf-api-origin",
                        "dep-$namePrefix-waf-api-origin-no-2",
                        "dep-$namePrefix-waf-api-origin-no-3"
                    )
                }
            )

            $originTestCases = [System.Collections.ArrayList]@()
            foreach ($originGroup in $expectedOriginGroups) {
                foreach ($origin in $originGroup.origins) {
                    $originTestCases += @{
                        ExpectedOriginName = $origin.name
                        OriginGroupName    = $originGroup.name
                        ResourceGroupName  = $resourceGroupName
                        ProfileName        = $cdnProfileName
                    }
                }
            }
        }

        It 'Origin group [<OriginGroupName>] should have expected origin [<ExpectedOriginName>] deployed' -TestCases $originTestCases {

            param (
                [string] $ExpectedOriginName,
                [string] $OriginGroupName,
                [string] $ResourceGroupName,
                [string] $ProfileName
            )

            $fetchedOrigin = Get-AzFrontDoorCdnOrigin -ResourceGroupName $resourceGroupName -ProfileName $ProfileName -OriginGroupName $OriginGroupName -OriginName $ExpectedOriginName
            $fetchedOrigin | Should -Not -BeNullOrEmpty
        }

    }
}
