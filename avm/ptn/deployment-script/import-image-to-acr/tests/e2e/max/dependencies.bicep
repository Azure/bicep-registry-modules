@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

param managedIdentityName string

param acrName string

param storageAccountName string

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: managedIdentityName
  params: {
    name: managedIdentityName
    location: location
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.6' = {
  name: virtualNetworkName
  params: {
    name: virtualNetworkName
    location: location
    addressPrefixes: ['10.0.0.0/16']
    subnets: [
      {
        name: 'default'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'private-endpoints'
        addressPrefix: '10.0.1.0/24'
      }
    ]
  }
}

module storage 'br/public:avm/res/storage/storage-account:0.9.0' = {
  name: storageAccountName
  params: {
    name: storageAccountName
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'private-endpoint'
        subnetResourceId: vnet.outputs.subnetNames[1].id
        service: 'Blob'
      }
    ]
  }
}

module acr 'br/public:avm/res/container-registry/registry:0.2.0' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSetDefaultAction: 'Deny'
    privateEndpoints: [
      {
        name: 'private-endpoint'
        subnetResourceId: vnet.outputs.subnetNames[1].id
      }
    ]
  }
}

output managedIdentityName string = identity.outputs.name
output acrName string = acr.outputs.name
