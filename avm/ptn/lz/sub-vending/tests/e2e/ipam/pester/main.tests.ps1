param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Bicep Landing Zone (Sub) Vending IPAM Tests' {

    BeforeAll {
        $subscriptionId = $TestInputData.DeploymentOutputs.createdSubId.Value
        $namePrefix = $TestInputData.DeploymentOutputs.namePrefix.Value
        $serviceShort = $TestInputData.DeploymentOutputs.serviceShort.Value
        $location = $TestInputData.DeploymentOutputs.resourceLocation.Value
        $ipamPoolResourceId = $TestInputData.DeploymentOutputs.ipamPoolResourceId.Value
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

    Context 'Networking - IPAM Tests' {
        BeforeAll {
            $vnetIpam = Get-AzVirtualNetwork -ResourceGroupName "rsg-$location-net-ipam-$namePrefix-$serviceShort" -Name "vnet-$location-ipam-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
            $subnet1 = $vnetIpam.Subnets[0]
            $subnet2 = $vnetIpam.Subnets[1]
        }

        It "Should have a Virtual Network in the correct Resource Group (rsg-$location-net-ipam-$namePrefix-$serviceShort)" {
            $vnetIpam.ResourceGroupName | Should -Be "rsg-$location-net-ipam-$namePrefix-$serviceShort"
        }

        It "Should have a Virtual Network with the correct name (vnet-$location-ipam-$namePrefix-$serviceShort)" {
            $vnetIpam.Name | Should -Be "vnet-$location-ipam-$namePrefix-$serviceShort"
        }

        It 'Should have a Virtual Network with the correct location' {
            $vnetIpam.Location | Should -Be $location
        }

        It 'Should have a Virtual Network with address prefixes allocated from IPAM' {
            # When IPAM is used, Azure allocates address prefixes
            $vnetIpam.AddressSpace.AddressPrefixes | Should -Not -BeNullOrEmpty
        }

        It 'Should have a Virtual Network with the allocated address prefix within the expected IPAM pool range' {
            # Verify the allocated address is within the expected range (10.120.x.x/24)
            $allocatedPrefix = $vnetIpam.AddressSpace.AddressPrefixes[0]
            $allocatedPrefix | Should -Not -BeNullOrEmpty
            $allocatedPrefix | Should -Match '^10\.120\.\d+\.\d+/24$'
        }

        It 'Should have a Virtual Network with address space allocated with the expected size (256 IPs = /24)' {
            # Verify the allocated CIDR is a /24 (256 IP addresses)
            $allocatedPrefix = $vnetIpam.AddressSpace.AddressPrefixes[0]
            $allocatedPrefix | Should -Match '/24$'
        }

        It 'Should have a Virtual Network with DDoS protection disabled' {
            $vnetIpam.EnableDdosProtection | Should -Be $false
            $vnetIpam.DdosProtectionPlan | Should -BeNullOrEmpty
        }

        It 'Should have a Virtual Network with two subnets' {
            $vnetIpam.Subnets.Count | Should -Be 2
        }

        It "Should have a Virtual Network with a subnet named 'Subnet1'" {
            $subnet1.Name | Should -Be 'Subnet1'
        }

        It "Should have a subnet 'Subnet1' with an address prefix allocated from IPAM" {
            # When IPAM is used, Azure allocates an address prefix to the subnet
            $subnet1.AddressPrefix | Should -Not -BeNullOrEmpty
        }

        It "Should have a subnet 'Subnet1' with the expected size (64 IPs = /26)" {
            # The subnet should be a /26 (64 IPs)
            $subnet1.AddressPrefix | Should -Not -BeNullOrEmpty
            # AddressPrefix can be an array, get the first element if it is
            $prefix = if ($subnet1.AddressPrefix -is [array]) { $subnet1.AddressPrefix[0] } else { $subnet1.AddressPrefix }
            $prefix | Should -Match '/26$'
        }

        It "Should have a Virtual Network with a subnet named 'Subnet2'" {
            $subnet2.Name | Should -Be 'Subnet2'
        }

        It "Should have a subnet 'Subnet2' with an address prefix allocated from IPAM" {
            # When IPAM is used, Azure allocates an address prefix to the subnet
            $subnet2.AddressPrefix | Should -Not -BeNullOrEmpty
        }

        It "Should have a subnet 'Subnet2' with the expected size (32 IPs = /27)" {
            # The subnet should be a /27 (32 IPs)
            $subnet2.AddressPrefix | Should -Not -BeNullOrEmpty
            # AddressPrefix can be an array, get the first element if it is
            $prefix = if ($subnet2.AddressPrefix -is [array]) { $subnet2.AddressPrefix[0] } else { $subnet2.AddressPrefix }
            $prefix | Should -Match '/27$'
        }
    }
}
