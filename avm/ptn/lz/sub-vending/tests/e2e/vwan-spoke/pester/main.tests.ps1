param (
  [Parameter(Mandatory = $false)]
  [hashtable] $TestInputData = @{}
)

Describe "Bicep Landing Zone (Sub) Vending Tests" {

  BeforeAll {
    $subscriptionId = $TestInputData.DeploymentOutputs.createdSubId.Value
    $namePrefix = $TestInputData.DeploymentOutputs.namePrefix.Value
    $serviceShort = $TestInputData.DeploymentOutputs.serviceShort.Value
    $location = $TestInputData.DeploymentOutputs.resourceLocation.Value
    Update-AzConfig -DisplayBreakingChangeWarning $false
    Select-AzSubscription -subscriptionId $subscriptionId
  }

  Context "Subscription Tests" {
    BeforeAll {
      $sub = Get-AzSubscription -SubscriptionId $subscriptionId -ErrorAction SilentlyContinue
    }

    It "Should have a Subscription with the correct name" {
      $sub.Name | Should -Be "sub-blzv-tests-$namePrefix-$serviceShort"
    }

    It "Should have a Subscription that is enabled" {
      $sub.State | Should -Be "Enabled"
    }

    It "Should have a Subscription with a tag key of 'namePrefix'" {
      $sub.Tags.Keys | Should -Contain "namePrefix"
    }

    It "Should have a Subscription with a tag key of 'namePrefix' with a value of '$namePrefix'" {
      $sub.Tags.namePrefix | Should -Be $namePrefix
    }

    It "Should have a Subscription with a tag key of 'serviceShort' with a value of '$serviceShort'" {
      $sub.Tags.serviceShort | Should -Be $serviceShort
    }

    It "Should have a Subscription that is a child of the Management Group with the ID of 'bicep-lz-vending-automation-child'" {
      $mgAssociation = Get-AzManagementGroupSubscription -SubscriptionId $subscriptionId -GroupId "bicep-lz-vending-automation-child" -ErrorAction SilentlyContinue
      $mgAssociation.Id | Should -Be "/providers/Microsoft.Management/managementGroups/bicep-lz-vending-automation-child/subscriptions/$subscriptionId"
    }
  }

  Context "Role-Based Access Control Assignment Tests" {
    It "Should Have a Role Assignment for an known AAD Group with the Network Contributor role directly upon the Resource Group" {
      $iterationCount = 0
      do {
        $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-vwan-$namePrefix-$serviceShort" -RoleDefinitionName "Network Contributor" -ObjectId "896b1162-be44-4b28-888a-d01acc1b4271" -ErrorAction SilentlyContinue
        if ($null -eq $roleAssignment) {
          Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
          Start-Sleep -Seconds 40
          $iterationCount++
        }
      } until (
        $roleAssignment -ne $null -or $iterationCount -ge 10
      )

      $roleAssignment.ObjectId | Should -Be "896b1162-be44-4b28-888a-d01acc1b4271"
      $roleAssignment.RoleDefinitionName | Should -Be "Network Contributor"
      $roleAssignment.scope | Should -Be "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-vwan-$namePrefix-$serviceShort"
    }
  }

  Context "Virtual WAN - Resource Group Tests" {
    BeforeAll {
      $rsg = Get-AzResourceGroup -Name "rsg-$location-net-vwan-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
    }

    It "Should have a Resource Group with the correct name" {
      $rsg.ResourceGroupName | Should -Be "rsg-$location-net-vwan-$namePrefix-$serviceShort"
    }

    It "Should have a Resource Group with the correct location" {
      $rsg.Location | Should -Be $location
    }
  }

  Context "Networking - Virtual WAN Spoke Tests" {
    BeforeAll {
      $vnetVwan = Get-AzVirtualNetwork -ResourceGroupName "rsg-$location-net-vwan-$namePrefix-$serviceShort" -Name "vnet-$location-vwan-$namePrefix-$serviceShort" -ErrorAction SilentlyContinue
    }

    It "Should have a Virtual Network in the correct Resource Group (rsg-$location-net-vwan-$namePrefix-$serviceShort)" {
      $vnetVwan.ResourceGroupName | Should -Be "rsg-$location-net-vwan-$namePrefix-$serviceShort"
    }

    It "Should have a Virtual Network with the correct name (vnet-$location-vwan-$namePrefix-$serviceShort)" {
      $vnetVwan.Name | Should -Be "vnet-$location-vwan-$namePrefix-$serviceShort"
    }

    It "Should have a Virtual Network with the correct location" {
      $vnetVwan.Location | Should -Be $location
    }

    It "Should have a Virtual Network with the correct address space (10.210.0.0/16)" {
      $vnetVwan.AddressSpace.AddressPrefixes | Should -Be "10.210.0.0/16"
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

    It "Should have a Virtual Hub Connection to the newly created spoke Virtual Network (vnet-$location-vwan-$namePrefix-$serviceShort)" {
      $vwanHubVhc.RemoteVirtualNetwork.Id | Should -Contain "/subscriptions/$subscriptionId/resourceGroups/rsg-$location-net-vwan-$namePrefix-$serviceShort/providers/Microsoft.Network/virtualNetworks/vnet-$location-vwan-$namePrefix-$serviceShort"
    }

    It "All Virtual Hub Connection should have the EnableInternetSecurity property set to $true" -ForEach $vwanHubVhc {
      Write-Host "       Checking Virtual Hub Connection $($_.Name)..." -ForegroundColor Yellow
      $_.EnableInternetSecurity | Should -Be $true
    }
  }
}
