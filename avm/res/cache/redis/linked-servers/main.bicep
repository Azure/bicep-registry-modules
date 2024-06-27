metadata name = 'Redis Cache Linked Servers'
metadata description = 'This module connects a primary and secondary Redis Cache together for geo-replication.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Primary Redis cache name.')
param primaryRedisCacheName string

@description('Required. The name of the secondary Redis cache. If not provided, the primary Redis cache name is used.')
param secondaryRedisCacheName string

@description('Required. The resource ID of the linked server. If not provided, the resource ID of the primary Redis cache is used.')
param linkedRedisCacheId string

@description('Required. The location of the linked server. If not provided, the location of the primary Redis cache is used.')
param linkedRedisCacheLocation string

@description('Optional. The role of the linked server. Possible values include: "Primary", "Secondary". Default value is "Secondary".')
param serverRole string = 'Secondary'

resource redisLinkedServer 'Microsoft.Cache/redis/linkedServers@2024-03-01' = {
  name: '${primaryRedisCacheName}/${secondaryRedisCacheName}'
  properties: {
    linkedRedisCacheId: linkedRedisCacheId
    linkedRedisCacheLocation: linkedRedisCacheLocation
    serverRole: serverRole
  }
}

@description('The hostname of the linked server.')
output geoReplicatedPrimaryHostName string = redisLinkedServer.properties.geoReplicatedPrimaryHostName
