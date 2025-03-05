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

    Context 'Role-Based Access Control Assignment Tests' {
        It 'Should Have a Role Assignment for an known AAD Group with the Network Contributor role directly upon the Resource Group' {
            $iterationCount = 0
            do {
                $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-hs-$namePrefix-$serviceShort" -RoleDefinitionName 'Network Contributor' -ErrorAction SilentlyContinue
                if ($null -eq $roleAssignment) {
                    Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
                    Start-Sleep -Seconds 40
                    $iterationCount++
                }
            } until (
                $roleAssignment -ne $null -or $iterationCount -ge 10
            )

            $roleAssignment.ObjectId | Should -Be $user.Id
            $roleAssignment.RoleDefinitionName | Should -Be 'Network Contributor'
            $roleAssignment.scope | Should -Be "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-hs-$namePrefix-$serviceShort"
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
            $natGw = Get-AzNatGateway -ResourceGroupName "rsg-$location-net-hs-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
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

        It 'Should have a Virtual Network with the correct address space (10.120.0.0/16)' {
            $vnetHs.AddressSpace.AddressPrefixes | Should -Be '10.120.0.0/16'
        }

        It 'Should have a Virtual Network with DDoS protection disabled' {
            $vnetHs.EnableDdosProtection | Should -Be $false
            $vnetHs.ddosProtectionPlan | Should -BeNullOrEmpty
        }

        It 'Should have a NAT Gateway deployed with the correct name' {
            $natGw | Should -Not -BeNullOrEmpty
            $natGw.Name | Should -Be "natgw-$location-hs-$namePrefix-$serviceShort"
        }

        It "Should have a Virtual Network with a subnet with the correct name with addressPrefix '10.120.1.0/24' and a NAT gateway attached" {
            $vnetHs.Subnets[0].Name | Should -Be 'Subnet1'
            $vnetHs.Subnets[0].AddressPrefix | Should -Be '10.120.1.0/24'
            $vnetHs.Subnets[0].NatGateway | Should -Not -BeNullOrEmpty
        }
    }
}
