targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

param location string

param resourceGroupName string

module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: 'resourceGroupModule-Deployment1'
  params: {
    name: resourceGroupName
    location: location
  }
}

module hubNetworking 'br/public:avm/ptn/network/hub-networking:0.2.0' = {
  scope: az.resourceGroup(resourceGroupName)
  name: 'hubNetworkingDeployment'
  params: {
    location: location
    hubVirtualNetworks: {
      hub1: {
        addressPrefixes: ['10.242.0.0/20']
      }
    }
  }
}

output vnetHubResourceId string = hubNetworking.outputs.hubVirtualNetworks[0].id
