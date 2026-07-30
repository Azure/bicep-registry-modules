metadata name = 'Azure SQL Server Virtual Network Rules'
metadata description = 'This module deploys an Azure SQL Server Virtual Network Rule.'

@description('Required. The name of the Server Virtual Network Rule.')
param name string

@description('Optional. Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.')
param ignoreMissingVnetServiceEndpoint bool = false

@description('Required. The resource ID of the virtual network subnet.')
param virtualNetworkSubnetResourceId string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-server-virtualnetworkrule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource server 'Microsoft.Sql/servers@2025-01-01' existing = {
  name: serverName
}

resource virtualNetworkRule 'Microsoft.Sql/servers/virtualNetworkRules@2025-01-01' = {
  name: name
  parent: server
  properties: {
    ignoreMissingVnetServiceEndpoint: ignoreMissingVnetServiceEndpoint
    virtualNetworkSubnetId: virtualNetworkSubnetResourceId
  }
}

@description('The name of the deployed virtual network rule.')
output name string = virtualNetworkRule.name

@description('The resource ID of the deployed virtual network rule.')
output resourceId string = virtualNetworkRule.id

@description('The resource group of the deployed virtual network rule.')
output resourceGroupName string = resourceGroup().name
