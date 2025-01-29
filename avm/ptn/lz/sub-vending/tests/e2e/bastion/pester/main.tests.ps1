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
            $bastionHost = Get-AzBastion -ResourceGroupName "rsg-$location-net-hs-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
        }

        It "Should have a Virtual Network in the correct Resource Group (rsg-$location-net-hs-$namePrefix-$serviceShort)" {
            $vnetHs.ResourceGroupName | Should -Be "rsg-$location-net-hs-$namePrefix-$serviceShort"
        }

        It "Should have a Virtual Network with the correct name (vnet-$location-hs-$namePrefix-$serviceShort)" {
            $vnetHs.Name | Should -Be "vnet-$location-hs-$namePrefix-$serviceShort"
        }

        It 'Should have a Virtual Network with the correct location' {
            $vnetHs.Location | Should -Be $location
        }

        It 'Should have a Virtual Network with the correct address space (10.130.0.0/16)' {
            $vnetHs.AddressSpace.AddressPrefixes | Should -Be '10.130.0.0/16'
        }

        It 'Should have a Bastion Host deployed with the correct name and sku' {
            $bastionHost | Should -Not -BeNullOrEmpty
            $bastionHost.Name | Should -Be "bastion-$location-hs-$namePrefix-$serviceShort"
            $bastionHost.Sku.Name | Should -Be 'Standard'
        }

        It "Should have a Virtual Network with a subnet with the correct name with addressPrefix '10.130.1.0/24'" {
            $vnetHs.Subnets.Name | Should -Contain 'Subnet1'
            $vnetHs.Subnets.AddressPrefix | Should -Contain '10.130.1.0/24'
        }
    }
}
