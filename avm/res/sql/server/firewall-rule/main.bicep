metadata name = 'Azure SQL Server Firewall Rule'
metadata description = 'This module deploys an Azure SQL Server Firewall Rule.'

@description('Required. The name of the Server Firewall Rule.')
param name string

@description('Optional. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
param endIpAddress string = '0.0.0.0'

@description('Optional. The start IP address of the firewall rule. Must be IPv4 format. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
param startIpAddress string = '0.0.0.0'

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

resource firewallRule 'Microsoft.Sql/servers/firewallRules@2023-08-01-preview' = {
  name: name
  parent: server
  properties: {
    endIpAddress: endIpAddress
    startIpAddress: startIpAddress
  }
}

@description('The name of the deployed firewall rule.')
output name string = firewallRule.name

@description('The resource ID of the deployed firewall rule.')
output resourceId string = firewallRule.id

@description('The resource group of the deployed firewall rule.')
output resourceGroupName string = resourceGroup().name
