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
param fqdns string[]

@description('Required. The ARM resource ID of the resource to which the managed private endpoint is created.')
param privateLinkResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.datafactory-factory-managedvnetmgdpe.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

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
