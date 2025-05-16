metadata name = 'Azure Cosmos DB for MongoDB (vCore) cluster Config FireWall Rules'
metadata description = 'This module config firewall rules for the Azure Cosmos DB for MongoDB (vCore) cluster.'

@description('Conditional. The name of the parent Azure Cosmos DB for MongoDB (vCore) cluster. Required if the template is used in a standalone deployment.')
param mongoClusterName string

@description('Required. The name of the firewall rule. Must match the pattern `^[a-zA-Z0-9][-_a-zA-Z0-9]*`.')
param name string

@description('Required. The start IP address of the Azure Cosmos DB for MongoDB (vCore) cluster firewall rule. Must be IPv4 format.')
param startIpAddress string

@description('Required. The end IP address of the Azure Cosmos DB for MongoDB (vCore) cluster firewall rule. Must be IPv4 format.')
param endIpAddress string

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2024-10-01-preview' existing = {
  name: mongoClusterName
}

resource firewallRule 'Microsoft.DocumentDB/mongoClusters/firewallRules@2024-10-01-preview' = {
  name: !contains(name, '.') // Custom validation as documented regex is incorrect and does fail with an 'InternalServerError'
    ? name
    : fail('The firewall rule name must match the pattern `^[a-zA-Z0-9][-_a-zA-Z0-9]*`. A `.` is **not** allowed.')
  parent: mongoCluster
  properties: {
    startIpAddress: startIpAddress
    endIpAddress: endIpAddress
  }
}

@description('The name of the resource group the Azure Cosmos DB for MongoDB (vCore) cluster was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the firewall rule.')
output name string = firewallRule.name

@description('The resource ID of the firewall rule.')
output resourceId string = firewallRule.id
