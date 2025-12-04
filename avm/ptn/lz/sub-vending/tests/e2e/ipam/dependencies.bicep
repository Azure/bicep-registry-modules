@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Optional. The name of the virtual network manager to create.')
param networkManagerName string

@description('Optional. The name of the IPAM pool to create.')
param ipamPoolName string

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' = {
  name: networkManagerName
  location: location
  properties: {
    networkManagerScopes: {
      managementGroups: [
        '/providers/Microsoft.Management/managementGroups/#_managementGroupId_#'
      ]
    }
    networkManagerScopeAccesses: [
      'Connectivity'
    ]
  }
}

resource ipamPool 'Microsoft.Network/networkManagers/ipamPools@2024-05-01' = {
  name: ipamPoolName
  location: location
  parent: networkManager
  properties: {
    description: 'Test IPAM pool for sub-vending module testing'
    addressPrefixes: [
      '10.120.0.0/16'
    ]
  }
}

@description('The resource ID of the created IPAM pool.')
output ipamPoolResourceId string = ipamPool.id

@description('The resource ID of the created network manager.')
output networkManagerResourceId string = networkManager.id
