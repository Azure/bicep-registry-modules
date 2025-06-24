param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Bicep Landing Zone (Sub) Vending Tests' {

    BeforeAll {
        $subscriptionId = $TestInputData.DeploymentOutputs.createdSubId.Value
        $namePrefix = $TestInputData.DeploymentOutputs.namePrefix.Value
        $serviceShort = $TestInputData.DeploymentOutputs.serviceShort.Value
        $location = $TestInputData.DeploymentOutputs.resourceLocation.Value
        $user = Get-AzADUser -DisplayName 'AVM CI Validation User 001'
        Update-AzConfig -DisplayBreakingChangeWarning $false
        Select-AzSubscription -subscriptionId $subscriptionId
    }

    Context 'Subscription Tests' {
        BeforeAll {
            $sub = Get-AzSubscription -SubscriptionId $subscriptionId -ErrorAction SilentlyContinue
        }

        It 'Should have a Subscription with the correct name' {
            $sub.Name | Should -BeLike "dep-sub-blzv-tests-$namePrefix-$serviceShort*"
        }

        It 'Should have a Subscription that is enabled' {
            $sub.State | Should -Be 'Enabled'
        }

        It "Should have a Subscription that is a child of the Management Group with the ID of 'bicep-lz-vending-automation-child'" {
            $mgAssociation = Get-AzManagementGroupSubscription -SubscriptionId $subscriptionId -GroupId 'bicep-lz-vending-automation-child' -ErrorAction SilentlyContinue
            $mgAssociation.Id | Should -Be "/providers/Microsoft.Management/managementGroups/bicep-lz-vending-automation-child/subscriptions/$subscriptionId"
        }
    }

    Context 'PIM Role-Based Access Control Assignment Tests' {
        It 'Should Have a PIM Role Assignment for an known AAD Group with an Active Role-Based Access Control Administrator role directly upon the Resource Group' {
            $iterationCount = 0
            do {
                $roleAssignment = Get-AzRoleAssignmentScheduleRequest -Scope "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-hs-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
                if ($null -eq $roleAssignment) {
                    Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
                    Start-Sleep -Seconds 40
                    $iterationCount++
                }
            } until (
                $roleAssignment -ne $null -or $iterationCount -ge 10
            )

            $roleAssignment.PrincipalId | Should -Be $user.Id
            $roleAssignment.RoleDefinitionId | Should -Be "/subscriptions/$subscriptionId/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168"
            $roleAssignment.scope | Should -Be "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-hs-$namePrefix-$serviceShort"
        }
    }
}
