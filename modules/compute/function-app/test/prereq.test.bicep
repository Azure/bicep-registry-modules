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
var storageAccountName = 'iep${uniqueStoragename}'



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
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
    //networkAclsDefaultAction: 'Allow'
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

resource workspaces 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'functionapp-workspace'
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

