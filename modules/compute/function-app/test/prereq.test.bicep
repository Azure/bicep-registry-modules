param location string
param name string
param tags object

var maxNameLength = 24
var uniqueStoragename = length(uniqueString(name)) > maxNameLength ? substring(replace(guid(name, resourceGroup().name, subscription().id), '-', ''), 0, maxNameLength) : substring(replace(guid(name, resourceGroup().name, subscription().id), '-', ''), 0, maxNameLength)

module vnet 'br/public:network/virtual-network:1.1.2' = {
  name: 'vnet-network-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'vnet-${uniqueString(resourceGroup().id)}'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'function-app'
        addressPrefix: '10.0.3.0/24'
        delegations: [
          {
            name: 'Delegation'
            properties: {
              serviceName: 'Microsoft.Web/serverfarms'
            }
          }
        ]
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
        ]
      }
      {
        name: 'storage'
        addressPrefix: '10.0.4.0/24'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
        ]
      }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: uniqueStoragename
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource userAssignedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'test2-${uniqueString(resourceGroup().id)}'
  location: location
}

resource workspaces 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'functionapp-workspace'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

@description('get Identity id.')
output userAssignedIdentitiesId string = userAssignedIdentities.id

@description('get Identity name.')
output userAssignedIdentitiesName string = userAssignedIdentities.name

@description('get OperationalInsights workspaces id.')
output workspacesId string = workspaces.id

@description('get the subnets associated with the virtual network.')
output subnetResourceIds string = vnet.outputs.subnetResourceIds[0]

@description('Name of the storage account used by function app.')
output saAccountName string = storageAccount.name
