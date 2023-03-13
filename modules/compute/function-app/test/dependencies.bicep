param location string
param name string
param tags object

module virutalNetwork 'br:nuanceenterpriseinfra.azurecr.io/bicep/vnet:1.0.02075.60-ca80d9a' = {
  name: 'network-${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    vnetLockEnabled: false
    addressSpace: [
      '172.16.3.0/24'
    ]
    subnets: [
      {
        name: 'fn-subnet'
        subnetPrefix: '172.16.3.0/26'
        privateEndpointNetworkPolicies: 'Disabled'
        subnetDelegations: [
          {
            name: 'delegation-1'
            properties: {
              serviceName: 'Microsoft.Web/serverfarms'
            }
          }
        ]
      }
    ]
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
output subnets array = virutalNetwork.outputs.subnets

@description('Name of the storage account used by function app.')
output saAccountName string = storageAccount.outputs.name

@description('Resource Group of storage account used by function app.')
output saResourceGroupName string = storageAccount.outputs.resourcegroupName

