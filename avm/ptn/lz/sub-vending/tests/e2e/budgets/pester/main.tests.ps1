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

        It "Should have a Subscription with a tag key of 'namePrefix'" {
            $sub.Tags.Keys | Should -Contain 'namePrefix'
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

    Context 'Budgets' {
        BeforeAll {
            $budgetName = "budget-$namePrefix-$serviceShort"
            $token = (Get-AzAccessToken -AsSecureString).Token
            $budget = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.Consumption/budgets/$budgetName`?api-version=2025-04-01" -Authentication 'Bearer' -Token $token
        }

        It 'Should have amount default to 100' {
            $budget.properties.amount | Should -Be 100
        }

        It 'Should have category default to Cost' {
            $budget.properties.category | Should -Be 'Cost'
        }

        It 'Should have notifications correctly configured' {
            $notificationProperties = $budget.properties.notifications.PSObject.Properties.Name -split '_'
            $notificationProperties[0] | Should -Be 'actual'
            $notificationProperties[1] | Should -Be 'GreaterThan'
            $notificationProperties[2] | Should -Be '90'
            $notificationProperties[3] | Should -Be 'Percentage'
        }

        It 'Should have Owner set as part of Contact Roles' {
            $budget.properties.notifications.actual_GreaterThan_90_Percentage.contactRoles | Should -Contain 'Owner'
        }

    }
}
