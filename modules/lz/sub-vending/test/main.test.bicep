/*
Tests for the Bicep LZ Vending Module
*/

targetScope = 'managementGroup'

@description('Specifies the location for resources.')
param location string = 'uksouth'

// Test - Sub Creation & Management Group Placement Only, No Networking
module testSubCreateAndMgPlacementNoNetworking '../main.bicep' = {
  name: 'test-SubCreateAndMgPlacementNoNetworking'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-001'
    subscriptionDisplayName: 'sub-test-001'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkLocation: location
  }
}

// Test - Sub Creation & Management Group Placement And Create Virtual Network, No Peering
module testSubCreateAndMgPlacementCreateVnetNoPeering '../main.bicep' = {
  name: 'test-testSubCreateAndMgPlacementCreateVnetNoPeering'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-002'
    subscriptionDisplayName: 'sub-test-002'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.2.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false
  }
}

// Test - Sub Creation & Management Group Placement And Create Virtual Network And Peering to Virtual Network
module testSubCreateAndMgPlacementCreateVnetWithPeering '../main.bicep' = {
  name: 'test-testSubCreateAndMgPlacementCreateVnetWithPeering'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-003'
    subscriptionDisplayName: 'sub-test-003'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.3.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-hub-001/providers/Microsoft.Network/virtualNetworks/vnet-uks-hub-001'
  }
}

// Test - Sub Creation & Management Group Placement And Create Virtual Network And Peering to Virtual WAN Hub
module testSubCreateAndMgPlacementCreateVnetWithPeeringVwan '../main.bicep' = {
  name: 'test-testSubCreateAndMgPlacementCreateVnetWithPeeringVwan'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: '/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456'
    subscriptionAliasName: 'sub-test-004'
    subscriptionDisplayName: 'sub-test-004'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.4.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rsg-uks-net-vwan-001/providers/Microsoft.Network/virtualHubs/vhub-uks-001'
  }
}
