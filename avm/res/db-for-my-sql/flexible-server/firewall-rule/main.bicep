metadata name = 'DBforMySQL Flexible Server Firewall Rules'
metadata description = 'This module deploys a DBforMySQL Flexible Server Firewall Rule.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the MySQL flexible server Firewall Rule.')
param name string

@description('Required. The start IP address of the firewall rule. Must be IPv4 format. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
param startIpAddress string

@description('Required. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
param endIpAddress string

@description('Conditional. The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' existing = {
  name: flexibleServerName
}

resource firewallRule 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2023-06-30' = {
  name: name
  parent: flexibleServer
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
