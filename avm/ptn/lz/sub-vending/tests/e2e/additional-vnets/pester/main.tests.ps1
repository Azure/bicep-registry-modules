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

    Context 'Hub Spoke - Resource Group Tests' {
        BeforeAll {
            $rsg = Get-AzResourceGroup -Name "rsg-$location-net-hs-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
        }

        It 'Should have a Resource Group with the correct name' {
            $rsg.ResourceGroupName | Should -Be "rsg-$location-net-hs-$namePrefix-$serviceShort"
        }

        It 'Should have a Resource Group with the correct location' {
            $rsg.Location | Should -Be $location
        }
    }
    Context 'Networking - Hub Spoke Tests' {
        BeforeAll {
            $vnetHs = Get-AzVirtualNetwork -ResourceGroupName "rsg-$location-net-hs-$namePrefix-$serviceShort" -Name "vnet-$location-hs-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
            $additionalVnet1 = Get-AzVirtualNetwork -Name "vnet-$location-hs-$namePrefix-$serviceShort-1" -ErrorAction SilentlyContinue
            $additionalVnet2 = Get-AzVirtualNetwork -Name "vnet-$location-hs-$namePrefix-$serviceShort-2" -ErrorAction SilentlyContinue
        }

        It "Should have a Virtual Network in the correct Resource Group (rsg-$location-net-hs-$namePrefix-$serviceShort)" {
            $vnetHs.ResourceGroupName | Should -Be "rsg-$location-net-hs-$namePrefix-$serviceShort"
        }

        It "Should have a Virtual Network with the correct name (vnet-$location-hs-$namePrefix-$serviceShort)" {
            $vnetHs.Name | Should -Be "vnet-$location-hs-$namePrefix-$serviceShort"
            $additionalVnet1.Name | Should -Be "vnet-$location-hs-$namePrefix-$serviceShort-1"
            $additionalVnet2.Name | Should -Be "vnet-$location-hs-$namePrefix-$serviceShort-2"
        }

        It 'Should have a Virtual Network with the correct location' {
            $vnetHs.Location | Should -Be $location
        }

        It 'Should have a Virtual Network with the correct address space (10.110.0.0/16)' {
            $vnetHs.AddressSpace.AddressPrefixes | Should -Be '10.110.0.0/16'
            $additionalVnet1.AddressSpace.AddressPrefixes | Should -Be '10.120.0.0/16'
            $additionalVnet2.AddressSpace.AddressPrefixes | Should -Be '10.90.0.0/16'
        }

        It 'Should have a Virtual Network with DDoS protection disabled' {
            $vnetHs.EnableDdosProtection | Should -Be $false
            $vnetHs.ddosProtectionPlan | Should -BeNullOrEmpty
        }

        It "Should have a Virtual Network with a subnet created named 'Subnet1' with addressPrefix '10.110.1.0/24'" {
            $vnetHs.Subnets[0].Name | Should -Be 'Subnet1'
            $vnetHs.Subnets[0].AddressPrefix | Should -Be '10.110.1.0/24'
        }
    }
}
