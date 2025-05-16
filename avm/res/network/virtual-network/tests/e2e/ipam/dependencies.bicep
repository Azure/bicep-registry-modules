@description('. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Network Manager to create.')
param networkManagerName string

@description('Required. List of IP address prefixes to be used for the IPAM pool.')
param addressPrefixes array

resource networkManager 'Microsoft.Network/networkManagers@2024-05-01' = {
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

resource networkManagerIpamPool 'Microsoft.Network/networkManagers/ipamPools@2024-05-01' = {
  name: '${networkManagerName}-ipamPool'
  parent: networkManager
  location: location
  properties: {
    displayName: '${networkManagerName}-ipamPool'
    addressPrefixes: addressPrefixes
  }
}

@description('The resource ID of the Network Manager.')
output networkManagerId string = networkManager.id

@description('The resource ID of the Network Manager IPAM Pool.')
output networkManagerIpamPoolId string = networkManagerIpamPool.id
