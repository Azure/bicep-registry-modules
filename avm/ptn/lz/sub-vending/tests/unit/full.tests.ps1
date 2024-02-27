[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [string]
  $prNumber,

  [Parameter(Mandatory)]
  [string]
  $subId,

  [Parameter(Mandatory)]
  [string]
  $location
)

Describe "Bicep Landing Zone (Sub) Vending Tests" {

  BeforeAll {
    Update-AzConfig -DisplayBreakingChangeWarning $false
    Select-AzSubscription -subscriptionId $subId
  }

  Context "Subscription Tests" {
    BeforeAll {
      $sub = Get-AzSubscription -SubscriptionId $subId -ErrorAction SilentlyContinue
    }

    It "Should have a Subscription with the correct name" {
      $sub.Name | Should -Be "sub-blzv-tests-pr-$prNumber"
    }

    It "Should have a Subscription that is enabled" {
      $sub.State | Should -Be "Enabled"
    }

    It "Should have a Subscription with a tag key of 'prNumber'" {
      $sub.Tags.Keys | Should -Contain "prNumber"
    }

    It "Should have a Subscription with a tag key of 'prNumber' with a value of '$prNumber'" {
      $sub.Tags.prNumber | Should -Be $prNumber
    }

    It "Should have a Subscription that is a child of the Management Group with the ID of 'bicep-lz-vending-automation-child'" {
      $mgAssociation = Get-AzManagementGroupSubscription -SubscriptionId $subId -GroupId "bicep-lz-vending-automation-child" -ErrorAction SilentlyContinue
      $mgAssociation.Id | Should -Be "/providers/Microsoft.Management/managementGroups/bicep-lz-vending-automation-child/subscriptions/$subId"
    }

    It "Should have the 'Microsoft.HybridCompute', 'Microsoft.AVS' resource providers and the 'AzureServicesVm', 'ArcServerPrivateLinkPreview' resource providers features registered" {
      $resourceProviders = @( "Microsoft.HybridCompute", "Microsoft.AVS" )
      $resourceProvidersFeatures = @( "AzureServicesVm", "ArcServerPrivateLinkPreview" )
      ForEach ($provider in $resourceProviders) {
        $providerStatus = (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq $provider).registrationState
        $providerStatus | Should -BeIn @('Registered', 'Registering')
      }

      ForEach ($feature in $resourceProvidersFeatures) {
        $providerFeatureStatus = (Get-AzProviderFeature -ListAvailable | Where-Object FeatureName -eq $feature).registrationState
        $providerFeatureStatus | Should -BeIn @('Registered', 'Registering', 'Pending')
      }
    }
  }

  Context "Role-Based Access Control Assignment Tests" {
    It "Should Have a Role Assignment for an known AAD Group with the Reader role directly upon the Subscription" {
      $iterationCount = 0
      do {
        $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subId" -RoleDefinitionName "Reader" -ObjectId "7eca0dca-6701-46f1-b7b6-8b424dab50b3" -ErrorAction SilentlyContinue
        if ($null -eq $roleAssignment) {
          Write-Host "Waiting for Subscription Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
          Start-Sleep -Seconds 40
          $iterationCount++
        }
      } until (
        $roleAssignment -ne $null -or $iterationCount -ge 10
      )

      $roleAssignment.ObjectId | Should -Be "7eca0dca-6701-46f1-b7b6-8b424dab50b3"
      $roleAssignment.RoleDefinitionName | Should -Be "Reader"
      $roleAssignment.scope | Should -Be "/subscriptions/$subId"
    }

    It "Should Have a Role Assignment for an known AAD Group with the Network Contributor role directly upon the Resource Group" {
      $iterationCount = 0
      do {
        $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subId/resourceGroups/rsg-$location-net-hs-pr-$prNumber" -RoleDefinitionName "Network Contributor" -ObjectId "7eca0dca-6701-46f1-b7b6-8b424dab50b3" -ErrorAction SilentlyContinue
        if ($null -eq $roleAssignment) {
          Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
          Start-Sleep -Seconds 40
          $iterationCount++
        }
      } until (
        $roleAssignment -ne $null -or $iterationCount -ge 10
      )

      $roleAssignment.ObjectId | Should -Be "7eca0dca-6701-46f1-b7b6-8b424dab50b3"
      $roleAssignment.RoleDefinitionName | Should -Be "Network Contributor"
      $roleAssignment.scope | Should -Be "/subscriptions/$subId/resourceGroups/rsg-$location-net-hs-pr-$prNumber"
    }
  }

  Context "Hub Spoke - Resource Group Tests" {
    BeforeAll {
      $rsg = Get-AzResourceGroup -Name "rsg-$location-net-hs-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Resource Group with the correct name" {
      $rsg.ResourceGroupName | Should -Be "rsg-$location-net-hs-pr-$prNumber"
    }

    It "Should have a Resource Group with the correct location" {
      $rsg.Location | Should -Be $location
    }
  }

  Context "Virtual WAN - Resource Group Tests" {
    BeforeAll {
      $rsg = Get-AzResourceGroup -Name "rsg-$location-net-vwan-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Resource Group with the correct name" {
      $rsg.ResourceGroupName | Should -Be "rsg-$location-net-vwan-pr-$prNumber"
    }

    It "Should have a Resource Group with the correct location" {
      $rsg.Location | Should -Be $location
    }
  }

  Context "Networking - Hub Spoke Tests" {
    BeforeAll {
      $vnetHs = Get-AzVirtualNetwork -ResourceGroupName "rsg-$location-net-hs-pr-$prNumber" -Name "vnet-$location-hs-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Virtual Network in the correct Resource Group (rsg-$location-net-hs-pr-$prNumber)" {
      $vnetHs.ResourceGroupName | Should -Be "rsg-$location-net-hs-pr-$prNumber"
    }

    It "Should have a Virtual Network with the correct name (vnet-$location-hs-pr-$prNumber)" {
      $vnetHs.Name | Should -Be "vnet-$location-hs-pr-$prNumber"
    }

    It "Should have a Virtual Network with the correct location" {
      $vnetHs.Location | Should -Be $location
    }

    It "Should have a Virtual Network with the correct address space (10.100.0.0/16)" {
      $vnetHs.AddressSpace.AddressPrefixes | Should -Be "10.100.0.0/16"
    }

    It "Should have a Virtual Network with DDoS protection disabled" {
      $vnetHs.EnableDdosProtection | Should -Be $false
      $vnetHs.ddosProtectionPlan | Should -BeNullOrEmpty
    }

    It "Should have a Virtual Network with a single Virtual Network Peer" {
      $vnetHs.VirtualNetworkPeerings.Count | Should -Be 1
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv'" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that is in the Connected state and FullyInSync" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].PeeringState | Should -Be "Connected"
      $vnetHs.VirtualNetworkPeerings[0].PeeringSyncLevel | Should -Be "FullyInSync"
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowForwardedTraffic set to $true" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].AllowForwardedTraffic | Should -Be $true
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowVirtualNetworkAccess set to $true" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].AllowVirtualNetworkAccess | Should -Be $true
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that has AllowGatewayTransit set to $false" {
      $vnetHs.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/e4e7395f-dc45-411e-b425-95f75e470e16/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/virtualNetworks/vnet-uksouth-hub-blzv"
      $vnetHs.VirtualNetworkPeerings[0].AllowGatewayTransit | Should -Be $false
    }
  }

  Context "Networking - Virtual WAN Spoke Tests" {
    BeforeAll {
      $vnetVwan = Get-AzVirtualNetwork -ResourceGroupName "rsg-$location-net-vwan-pr-$prNumber" -Name "vnet-$location-vwan-pr-$prNumber" -ErrorAction SilentlyContinue
    }

    It "Should have a Virtual Network in the correct Resource Group (rsg-$location-net-vwan-pr-$prNumber)" {
      $vnetVwan.ResourceGroupName | Should -Be "rsg-$location-net-vwan-pr-$prNumber"
    }

    It "Should have a Virtual Network with the correct name (vnet-$location-vwan-pr-$prNumber)" {
      $vnetVwan.Name | Should -Be "vnet-$location-vwan-pr-$prNumber"
    }

    It "Should have a Virtual Network with the correct location" {
      $vnetVwan.Location | Should -Be $location
    }

    It "Should have a Virtual Network with the correct address space (10.200.0.0/16)" {
      $vnetVwan.AddressSpace.AddressPrefixes | Should -Be "10.200.0.0/16"
    }

    It "Should have a Virtual Network with DDoS protection disabled" {
      $vnetVwan.EnableDdosProtection | Should -Be $false
      $vnetVwan.ddosProtectionPlan | Should -BeNullOrEmpty
    }

    It "Should have a Virtual Network with a single Virtual Network Peer" {
      $vnetVwan.VirtualNetworkPeerings.Count | Should -Be 1
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv'" {
      $vnetVwan.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/2b8681e7-7c7f-474a-b649-6377f4c1b74d/resourceGroups/RG_vhub-uksouth-blzv_73df07af-62ce-4aed-b15e-832d49d4984f/providers/Microsoft.Network/virtualNetworks/HV_vhub-uksouth-blzv_ed0b8a35-0235-4ada-9405-39530ef6c722"
    }

    It "Should have a Virtual Network with a Virtual Network Peering to the Hub Virtual Network called 'vnet-uksouth-hub-blzv' that is in the Connected state and FullyInSync" {
      $vnetVwan.VirtualNetworkPeerings[0].RemoteVirtualNetwork.id | Should -Be "/subscriptions/2b8681e7-7c7f-474a-b649-6377f4c1b74d/resourceGroups/RG_vhub-uksouth-blzv_73df07af-62ce-4aed-b15e-832d49d4984f/providers/Microsoft.Network/virtualNetworks/HV_vhub-uksouth-blzv_ed0b8a35-0235-4ada-9405-39530ef6c722"
      $vnetVwan.VirtualNetworkPeerings[0].PeeringState | Should -Be "Connected"
      $vnetVwan.VirtualNetworkPeerings[0].PeeringSyncLevel | Should -Be "FullyInSync"
    }
  }

  Context "Networking - Virtual WAN Hub Tests" {
    BeforeAll {
      Select-AzSubscription -SubscriptionId "e4e7395f-dc45-411e-b425-95f75e470e16" -ErrorAction Stop
      $vwanHub = $vwanHub = Get-AzVirtualHub -ResourceGroupName "rsg-blzv-perm-hubs-001" -Name "vhub-uksouth-blzv" -ErrorAction SilentlyContinue
      $vwanHubVhc = Get-AzVirtualHubVnetConnection -ResourceGroupName "rsg-blzv-perm-hubs-001" -VirtualHubName "vhub-uksouth-blzv" -Name *
    }

    It "The Virtual WAN Hub should be in the succeeded state" {
      $vwanHub.ProvisioningState | Should -Be "Succeeded"
    }

    It "Should have a Virtual Hub Connection to the newly created spoke Virtual Network (vnet-$location-vwan-pr-$prNumber)" {
      $vwanHubVhc.RemoteVirtualNetwork.Id | Should -Contain "/subscriptions/$subId/resourceGroups/rsg-$location-net-vwan-pr-$prNumber/providers/Microsoft.Network/virtualNetworks/vnet-$location-vwan-pr-$prNumber"
    }

    It "All Virtual Hub Connection should have the EnableInternetSecurity property set to $true" -ForEach $vwanHubVhc {
      Write-Host "       Checking Virtual Hub Connection $($_.Name)..." -ForegroundColor Yellow
      $_.EnableInternetSecurity | Should -Be $true
    }
  }
}
