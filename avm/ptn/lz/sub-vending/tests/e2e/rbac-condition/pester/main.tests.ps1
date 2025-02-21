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

        It "Should have a Subscription with a tag key of 'namePrefix' with a value of '$namePrefix'" {
            $sub.Tags.namePrefix | Should -Be $namePrefix
        }

        It "Should have a Subscription with a tag key of 'serviceShort' with a value of '$serviceShort'" {
            $sub.Tags.serviceShort | Should -Be $serviceShort
        }

        It "Should have a Subscription that is a child of the Management Group with the ID of 'bicep-lz-vending-automation-child'" {
            $mgAssociation = Get-AzManagementGroupSubscription -SubscriptionId $subscriptionId -GroupId 'bicep-lz-vending-automation-child' -ErrorAction SilentlyContinue
            $mgAssociation.Id | Should -Be "/providers/Microsoft.Management/managementGroups/bicep-lz-vending-automation-child/subscriptions/$subscriptionId"
        }
    }

    Context 'Role-Based Access Control Assignment Tests' {
        It 'Should Have a Role Assignment for an known AAD Group with the Role based access control administrator role directly upon the Subscription' {
            $iterationCount = 0
            do {
                $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId" -RoleDefinitionName 'Role Based Access Control Administrator' -ObjectId '896b1162-be44-4b28-888a-d01acc1b4271' -ErrorAction SilentlyContinue
                if ($null -eq $roleAssignment) {
                    Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
                    Start-Sleep -Seconds 40
                    $iterationCount++
                }
            } until (
                $roleAssignment -ne $null -or $iterationCount -ge 10
            )

            $roleAssignment.ObjectId | Should -Be '896b1162-be44-4b28-888a-d01acc1b4271'
            $roleAssignment.RoleDefinitionName | Should -Be 'Role Based Access Control Administrator'
            $roleAssignment.scope | Should -Be "/subscriptions/$subscriptionId"
            $roleAssignment.Condition | Should -Not -BeNullOrEmpty
        }
    }
}
