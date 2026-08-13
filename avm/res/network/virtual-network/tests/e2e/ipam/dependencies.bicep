@description('. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Network Manager to create.')
param networkManagerName string

@description('Required. List of IP address prefixes to be used for the IPAM pool.')
param addressPrefixes array

@description('Required. The name of the pre-existing Virtual Network to link to the IPAM pool.')
param virtualNetworkName string

@description('Required. The classical address prefix to assign to the pre-existing Virtual Network. Must fall within the IPAM pool range.')
param virtualNetworkAddressPrefix string

resource networkManager 'Microsoft.Network/networkManagers@2025-05-01' = {
  name: networkManagerName
  location: location
  properties: {
    networkManagerScopes: {
      subscriptions: [
        subscription().id
      ]
    }
  }
}

resource networkManagerIpamPool 'Microsoft.Network/networkManagers/ipamPools@2025-05-01' = {
  name: '${networkManagerName}-ipamPool'
  parent: networkManager
  location: location
  properties: {
    displayName: '${networkManagerName}-ipamPool'
    addressPrefixes: addressPrefixes
  }
}

// Pre-existing Virtual Network created with a classical address prefix. The module under test later links it to the IPAM pool.
resource existingVirtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
  }
}

@description('The resource ID of the Network Manager.')
output networkManagerId string = networkManager.id

@description('The resource ID of the Network Manager IPAM Pool.')
output networkManagerIpamPoolId string = networkManagerIpamPool.id

@description('The name of the pre-existing Virtual Network.')
output virtualNetworkName string = existingVirtualNetwork.name
