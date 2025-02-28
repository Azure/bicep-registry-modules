targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

param location string

param resourceGroupName string

param tags object = {}

module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
  name: '${uniqueString(deployment().name, resourceGroupName)}-deployment'
  params: {
    name: resourceGroupName
    location: location
  }
}

module hubNetworking 'br/public:avm/res/network/virtual-network:0.5.4' = {
  scope: az.resourceGroup(resourceGroupName)
  dependsOn: [
    resourceGroup
  ]
  name: 'hubNetworkingDeployment'
  params: {
    name: 'hub-network'
    location: location
    addressPrefixes: [
      '10.242.0.0/20'
    ]
    tags: tags
  }
}

output vnetHubResourceId string = hubNetworking.outputs.resourceId
