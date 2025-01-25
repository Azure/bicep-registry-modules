metadata name = 'Data Factory Managed Virtual Networks'
metadata description = 'This module deploys a Data Factory Managed Virtual Network.'

@description('Conditional. The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.')
param dataFactoryName string

@description('Required. The name of the Managed Virtual Network.')
param name string

@description('Optional. An array of managed private endpoints objects created in the Data Factory managed virtual network.')
param managedPrivateEndpoints array = []

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource managedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: name
  parent: dataFactory
  properties: {}
}

module managedVirtualNetwork_managedPrivateEndpoint 'managed-private-endpoint/main.bicep' = [
  for (managedPrivateEndpoint, index) in managedPrivateEndpoints: {
    name: '${deployment().name}-managedPrivateEndpoint-${index}'
    params: {
      dataFactoryName: dataFactoryName
      managedVirtualNetworkName: name
      name: managedPrivateEndpoint.name
      fqdns: managedPrivateEndpoint.fqdns
      groupId: managedPrivateEndpoint.groupId
      privateLinkResourceId: managedPrivateEndpoint.privateLinkResourceId
    }
  }
]

@description('The name of the Resource Group the Managed Virtual Network was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Managed Virtual Network.')
output name string = managedVirtualNetwork.name

@description('The resource ID of the Managed Virtual Network.')
output resourceId string = managedVirtualNetwork.id
