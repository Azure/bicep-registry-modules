param location string
param name string
param tags object


@description('Virtual network')
resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name:  'network-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  resource kvSubnet 'subnets' = {
    name: 'kv'
    properties: {
      addressPrefix: '10.0.1.0/24'
    }
  }
  resource funcSubnet 'subnets' = {
    name: 'function-app'
    properties: {
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
  }

  resource storageSubnet 'subnets' = {
    name: 'storage'
    dependsOn: [
      funcSubnet
    ]
    properties: {
      addressPrefix: '10.0.4.0/24'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
        }
      ]
    }
  }
}



var maxNameLength = 20
var uniqueStoragename = length(uniqueString(name)) > maxNameLength ? substring(uniqueString(name), 0, maxNameLength) : uniqueString(name)
var storgeAccountName = 'iep${uniqueStoragename}'


module storageAccount 'br:nuanceenterpriseinfra.azurecr.io/bicep/storage-account:1.0.02024.18-2bf217a' = {
  name: storgeAccountName
  params: {
    name: storgeAccountName
    location: location
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Cool'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAclsBypass: 'AzureServices'
    networkAclsDefaultAction: 'Allow'
    publicNetworkAccess: 'Enabled'
    containers: [
      {
        name: 'app'
        publicAccess: 'Blob'
      }
    ]
  }
}



resource userAssignedIdentities 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'test2-${uniqueString(resourceGroup().id)}'
  location: location
}

resource workspaces 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'workspace-${name}'
  location: location
  tags: tags
  properties: {
    sku: {
      //'CapacityReservation' | 'Free' | 'LACluster' | 'PerGB2018' | 'PerNode' | 'Premium' | 'Standalone' | 'Standard'
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
output subnets string = vnet::funcSubnet.id

@description('Name of the storage account used by function app.')
output saAccountName string = storageAccount.name

