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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cache-redis-linkedserver.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource redisCache 'Microsoft.Cache/redis@2024-11-01' existing = {
  name: redisCacheName
}

resource redisLinkedServer 'Microsoft.Cache/redis/linkedServers@2024-11-01' = {
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
