metadata name = 'Azure Cosmos DB MongoDB vCore Cluster Config FireWall Rules'
metadata description = 'This module config firewall rules for the Azure Cosmos DB MongoDB vCore cluster.'

@description('Conditional. The name of the parent Azure Cosmos DB MongoDB vCore cluster. Required if the template is used in a standalone deployment.')
param mongoClusterName string

@description('Required. The name of the firewall rule.')
param name string

@description('Required. The start IP address of the Azure Cosmos DB MongoDB vCore cluster firewall rule. Must be IPv4 format.')
param startIpAddress string

@description('Required. The end IP address of the Azure Cosmos DB MongoDB vCore cluster firewall rule. Must be IPv4 format.')
param endIpAddress string

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2024-02-15-preview' existing = {
  name: mongoClusterName
}

resource firewallRule 'Microsoft.DocumentDB/mongoClusters/firewallRules@2024-02-15-preview' = {
  name: name
  parent: mongoCluster
  properties: {
    startIpAddress: startIpAddress
    endIpAddress: endIpAddress
  }
}

@description('The name of the resource group the Azure Cosmos DB MongoDB vCore cluster was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the firewall rule.')
output name string = firewallRule.name

@description('The resource ID of the firewall rule.')
output resourceId string = firewallRule.id
