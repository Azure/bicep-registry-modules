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

        It "Should have the 'Microsoft.HybridCompute', 'Microsoft.AVS' resource providers and the 'AzureServicesVm', 'ArcServerPrivateLinkPreview' resource providers features registered" {
            $resourceProviders = @( 'Microsoft.HybridCompute', 'Microsoft.AVS' )
            $resourceProvidersFeatures = @( 'AzureServicesVm', 'ArcServerPrivateLinkPreview' )
            ForEach ($provider in $resourceProviders) {
                $providerStatus = (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -EQ $provider).registrationState
                $providerStatus | Should -BeIn @('Registered', 'Registering')
            }

            ForEach ($feature in $resourceProvidersFeatures) {
                $providerFeatureStatus = (Get-AzProviderFeature -ListAvailable | Where-Object FeatureName -EQ $feature).registrationState
                $providerFeatureStatus | Should -BeIn @('Registered', 'Registering', 'Pending')
            }
        }
    }

    Context 'Role-Based Access Control Assignment Tests' {
        It 'Should Have a Role Assignment for an known AAD Group with the Network Contributor role directly upon the Resource Group' {
            $iterationCount = 0
            do {
                $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-hs-$namePrefix-$serviceShort" -RoleDefinitionName 'Network Contributor' -ObjectId '896b1162-be44-4b28-888a-d01acc1b4271' -ErrorAction SilentlyContinue
                if ($null -eq $roleAssignment) {
                    Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
                    Start-Sleep -Seconds 40
                    $iterationCount++
                }
            } until (
                $roleAssignment -ne $null -or $iterationCount -ge 10
            )

            $roleAssignment.ObjectId | Should -Be '896b1162-be44-4b28-888a-d01acc1b4271'
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

        It 'Should have a Virtual Network with the correct address space (10.110.0.0/16)' {
            $vnetHs.AddressSpace.AddressPrefixes | Should -Be '10.110.0.0/16'
        }

        It 'Should have a Virtual Network with DDoS protection disabled' {
            $vnetHs.EnableDdosProtection | Should -Be $false
            $vnetHs.ddosProtectionPlan | Should -BeNullOrEmpty
        }

        It 'Should have a Virtual Network with a single Virtual Network Peer' {
            $vnetHs.VirtualNetworkPeerings.Count | Should -Be 1
        }

        It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv'" {
            $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be $TestInputData.DeploymentOutputs.hubNetworkResourceId.Value
        }

        It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that is in the Connected state and FullyInSync" {
            $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be $TestInputData.DeploymentOutputs.hubNetworkResourceId.Value
            $vnetHs.VirtualNetworkPeerings[0].PeeringState | Should -Be 'Connected'
            $vnetHs.VirtualNetworkPeerings[0].PeeringSyncLevel | Should -Be 'FullyInSync'
        }

        It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowForwardedTraffic set to $true" {
            $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be $TestInputData.DeploymentOutputs.hubNetworkResourceId.Value
            $vnetHs.VirtualNetworkPeerings[0].AllowForwardedTraffic | Should -Be $true
        }

        It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowVirtualNetworkAccess set to $true" {
            $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be $TestInputData.DeploymentOutputs.hubNetworkResourceId.Value
            $vnetHs.VirtualNetworkPeerings[0].AllowVirtualNetworkAccess | Should -Be $true
        }

        It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowGatewayTransit set to $false" {
            $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be $TestInputData.DeploymentOutputs.hubNetworkResourceId.Value
            $vnetHs.VirtualNetworkPeerings[0].AllowGatewayTransit | Should -Be $false
        }
    }
}
