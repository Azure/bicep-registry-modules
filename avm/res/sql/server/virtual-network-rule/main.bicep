metadata name = 'Azure SQL Server Virtual Network Rules'
metadata description = 'This module deploys an Azure SQL Server Virtual Network Rule.'

@description('Required. The name of the Server Virtual Network Rule.')
param name string

@description('Optional. Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.')
param ignoreMissingVnetServiceEndpoint bool = false

@description('Required. The resource ID of the virtual network subnet.')
param virtualNetworkSubnetId string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

resource virtualNetworkRule 'Microsoft.Sql/servers/virtualNetworkRules@2023-08-01-preview' = {
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
