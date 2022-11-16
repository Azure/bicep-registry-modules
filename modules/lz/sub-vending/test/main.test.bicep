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
    subscriptionBillingScope: ''
    subscriptionAliasName: 'sub-test-001'
    subscriptionDisplayName: 'sub-test-001'
    subscriptionTags: {
      test: 'true'
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'corp'
  }
}

// Test - Sub Creation & Management Group Placement And Create Virtual Network, No Peering
module testSubCreateAndMgPlacementCreateVnetNoPeering '../main.bicep' = {
  name: 'test-testSubCreateAndMgPlacementCreateVnetNoPeering'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: ''
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
    virtualNetworkResourceGroupName: 'rsg-net-001'
    virtualNetworkName: 'vnet-${location}-001'
    virtualNetworkAddressSpace: [
      '10.0.0.0/24'
    ]
    virtualNetworkResourceGroupLockEnabled: false    
  }
}
