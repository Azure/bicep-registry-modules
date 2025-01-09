targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

param location string

param resourceGroupName string

module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: '${uniqueString(deployment().name, resourceGroupName)}-deployment'
  params: {
    name: resourceGroupName
    location: location
  }
}

module hubNetworking 'br/public:avm/res/network/virtual-network:0.5.2' = {
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
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: '10.0.0.64/26'
      }
    ]
  }
}

@description('The Azure Firewall deployment. This would normally be already provisioned by your platform team.')
module azureFirewall 'br/public:avm/res/network/azure-firewall:0.3.2' = {
  name: take('afw-${deployment().name}', 64)
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: 'afw-${deployment().name}'
    azureSkuTier: 'Standard'
    location: location
    virtualNetworkResourceId: hubNetworking.outputs.resourceId
  }
}

output vnetHubResourceId string = hubNetworking.outputs.resourceId
output firewallInternalIp string = azureFirewall.outputs.privateIp
