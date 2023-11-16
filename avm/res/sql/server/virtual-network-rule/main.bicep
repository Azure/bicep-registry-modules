metadata name = 'Azure SQL Server Virtual Network Rules'
metadata description = 'This module deploys an Azure SQL Server Virtual Network Rule.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Server Virtual Network Rule.')
param name string

@description('Optional. Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.')
param ignoreMissingVnetServiceEndpoint bool = false

@description('Required. The resource ID of the virtual network subnet.')
param virtualNetworkSubnetId string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource server 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource virtualNetworkRule 'Microsoft.Sql/servers/virtualNetworkRules@2022-05-01-preview' = {
  name: name
  parent: server
  properties: {
    ignoreMissingVnetServiceEndpoint: ignoreMissingVnetServiceEndpoint
    virtualNetworkSubnetId: virtualNetworkSubnetId
  }
}

@description('The name of the deployed virtual network rule.')
output name string = virtualNetworkRule.name

@description('The resource ID of the deployed virtual network rule.')
output resourceId string = virtualNetworkRule.id

@description('The resource group of the deployed virtual network rule.')
output resourceGroupName string = resourceGroup().name
