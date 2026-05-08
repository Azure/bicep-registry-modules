metadata name = 'Redis Cache Access Policy'
metadata description = 'This module deploys an access policy for Redis Cache.'

@description('Required. The name of the Redis cache.')
param redisCacheName string

@description('Required. The name of the access policy.')
param name string

@description('Required. Permissions associated with the access policy.')
param permissions string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cache-redis-accesspolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource accessPolicy 'Microsoft.Cache/redis/accessPolicies@2024-11-01' = {
  name: name
  parent: redisCache
  properties: {
    permissions: permissions
  }
}

@description('The name of the access policy.')
output name string = accessPolicy.name

@description('The resource ID of the access policy.')
output resourceId string = accessPolicy.id

@description('The name of the resource group the access policy was created in.')
output resourceGroupName string = resourceGroup().name
