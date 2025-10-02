metadata name = 'Redis Cache Firewall Rules'
metadata description = 'This module creates a firewall rule for Redis Cache.'

@description('Required. Redis cache name.')
param redisCacheName string

@description('Required. The name of the Redis Cache Firewall Rule.')
param name string

@description('Required. The start IP address of the firewall rule. Must be IPv4 format. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
param startIP string

@description('Required. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
param endIP string

resource redisCache 'Microsoft.Cache/redis@2024-11-01' existing = {
  name: redisCacheName
}

resource firewallRule 'Microsoft.Cache/redis/firewallRules@2024-11-01' = {
  parent: redisCache
  name: name
  properties: {
    startIP: startIP
    endIP: endIP
  }
}

@description('The name of the deployed firewall rule.')
output name string = firewallRule.name

@description('The resource ID of the deployed firewall rule.')
output resourceId string = firewallRule.id

@description('The resource group of the deployed firewall rule.')
output resourceGroupName string = resourceGroup().name
