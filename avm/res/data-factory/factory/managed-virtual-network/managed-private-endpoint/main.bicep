metadata name = 'Data Factory Managed Virtual Network Managed PrivateEndpoints'
metadata description = 'This module deploys a Data Factory Managed Virtual Network Managed Private Endpoint.'

@description('Conditional. The name of the parent data factory. Required if the template is used in a standalone deployment.')
param dataFactoryName string

@description('Required. The name of the parent managed virtual network.')
param managedVirtualNetworkName string

@description('Required. The managed private endpoint resource name.')
param name string

@description('Required. The groupId to which the managed private endpoint is created.')
param groupId string

@description('Required. Fully qualified domain names.')
param fqdns array

@description('Required. The ARM resource ID of the resource to which the managed private endpoint is created.')
param privateLinkResourceId string

resource datafactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName

  resource managedVirtualNetwork 'managedVirtualNetworks@2018-06-01' existing = {
    name: managedVirtualNetworkName
  }
}

resource managedPrivateEndpoint 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  name: name
  parent: datafactory::managedVirtualNetwork
  properties: {
    fqdns: fqdns
    groupId: groupId
    privateLinkResourceId: privateLinkResourceId
  }
}

@description('The name of the deployed managed private endpoint.')
output name string = managedPrivateEndpoint.name

@description('The resource ID of the deployed managed private endpoint.')
output resourceId string = managedPrivateEndpoint.id

@description('The resource group of the deployed managed private endpoint.')
output resourceGroupName string = resourceGroup().name
