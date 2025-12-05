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

        It 'Should have a Virtual Network that uses IPAM for address allocation' {
            # The AddressSpace should have IpamPoolPrefixAllocations instead of AddressPrefixes
            $vnetIpam.AddressSpace.IpamPoolPrefixAllocations | Should -Not -BeNullOrEmpty
        }

        It 'Should have a Virtual Network with IPAM pool allocation referencing the correct IPAM pool' {
            $vnetIpam.AddressSpace.IpamPoolPrefixAllocations.Id | Should -Be $ipamPoolResourceId
        }

        It 'Should have a Virtual Network with IPAM pool allocation requesting 256 IP addresses' {
            $vnetIpam.AddressSpace.IpamPoolPrefixAllocations.NumberOfIpAddresses | Should -Be '256'
        }

        It 'Should have a Virtual Network with an automatically allocated address prefix from the IPAM pool' {
            # When IPAM is used, Azure automatically assigns an address prefix
            $vnetIpam.AddressSpace.IpamPoolPrefixAllocations.AllocatedAddressPrefixes | Should -Not -BeNullOrEmpty
        }

        It 'Should have a Virtual Network with the allocated address prefix within the IPAM pool range (10.120.0.0/16)' {
            $allocatedPrefix = $vnetIpam.AddressSpace.IpamPoolPrefixAllocations.AllocatedAddressPrefixes
            $allocatedPrefix | Should -Match '10.120.0.0/24'
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

        It "Should have a subnet 'Subnet1' that uses IPAM for address allocation" {
            $subnet1.IpamPoolPrefixAllocations | Should -Not -BeNullOrEmpty
        }

        It "Should have a subnet 'Subnet1' with IPAM pool allocation referencing the correct IPAM pool" {
            $subnet1.IpamPoolPrefixAllocations.Id | Should -Be $ipamPoolResourceId
        }

        It "Should have a subnet 'Subnet1' with IPAM pool allocation requesting 64 IP addresses" {
            $subnet1.IpamPoolPrefixAllocations.NumberOfIpAddresses | Should -Be '64'
        }

        It "Should have a subnet 'Subnet1' with an automatically allocated address prefix from IPAM" {
            $subnet1.IpamPoolPrefixAllocations.AllocatedAddressPrefixes | Should -Not -BeNullOrEmpty
        }

        It "Should have a Virtual Network with a subnet named 'Subnet2'" {
            $subnet2.Name | Should -Be 'Subnet2'
        }

        It "Should have a subnet 'Subnet2' that uses IPAM for address allocation" {
            $subnet2.IpamPoolPrefixAllocations | Should -Not -BeNullOrEmpty
        }

        It "Should have a subnet 'Subnet2' with IPAM pool allocation referencing the correct IPAM pool" {
            $subnet2.IpamPoolPrefixAllocations.Id | Should -Be $ipamPoolResourceId
        }

        It "Should have a subnet 'Subnet2' with IPAM pool allocation requesting 32 IP addresses" {
            $subnet2.IpamPoolPrefixAllocations.NumberOfIpAddresses | Should -Be '32'
        }

        It "Should have a subnet 'Subnet2' with an automatically allocated address prefix from IPAM" {
            $subnet2.IpamPoolPrefixAllocations.AllocatedAddressPrefixes | Should -Not -BeNullOrEmpty
        }
    }
}
