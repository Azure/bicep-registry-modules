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

    Context 'User-assigned managed identity Tests' {
        BeforeAll {
            $userAssignedIdentity = (Get-AzUserAssignedIdentity -ResourceGroupName "rg-identity-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue)[0]
        }

        It 'Should have a User-assigned managed identity with the correct name' {
            $userAssignedIdentity.Name | Should -BeLike "test-identity-$namePrefix-$serviceShort"
        }

        It 'Should have a User-assigned managed identity with the correct federated credentials configured' {
            $federatedCredentials = (Get-AzFederatedIdentityCredential -ResourceGroupName "rg-identity-$namePrefix-$serviceShort" -IdentityName $userAssignedIdentity.Name)
            $federatedCredentials | Should -Not -BeNullOrEmpty
        }
    }
}
