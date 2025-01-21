metadata name = 'Redis Cache Linked Servers'
metadata description = 'This module connects a primary and secondary Redis Cache together for geo-replication.'

@description('Required. Primary Redis cache name.')
param redisCacheName string

@description('Optional. The name of the secondary Redis cache. If not provided, the primary Redis cache name is used.')
param name string = redisCacheName

@description('Required. The resource ID of the linked server.')
param linkedRedisCacheResourceId string

@description('Optional. The location of the linked server. If not provided, the location of the primary Redis cache is used.')
param linkedRedisCacheLocation string?

@description('Optional. The role of the linked server. Possible values include: "Primary", "Secondary". Default value is "Secondary".')
param serverRole string = 'Secondary'

resource redisCache 'Microsoft.Cache/redis@2024-03-01' existing = {
  name: redisCacheName
}

resource redisLinkedServer 'Microsoft.Cache/redis/linkedServers@2024-03-01' = {
  name: name
  properties: {
    linkedRedisCacheId: linkedRedisCacheResourceId
    linkedRedisCacheLocation: linkedRedisCacheLocation ?? redisCache.location
    serverRole: serverRole
  }
  parent: redisCache
}

@description('The name of the linkedServer resource.')
output name string = redisLinkedServer.name

@description('The resource ID of the linkedServer.')
output resourceId string = redisLinkedServer.id

@description('The hostname of the linkedServer.')
output geoReplicatedPrimaryHostName string = redisLinkedServer.properties.geoReplicatedPrimaryHostName

@description('The resource group of the deployed linkedServer.')
output resourceGroupName string = resourceGroup().name
