metadata name = 'Redis Cache Access Policy Assignment'
metadata description = 'This module deploys an access policy assignment for Redis Cache.'

@description('Required. The name of the Redis cache.')
param redisCacheName string

@description('Required. Object ID to which the access policy will be assigned.')
param objectId string

@description('Optional. The name of the assignment. By default uses the Object ID to which the access policy will be assigned.')
param name string = objectId

@description('Required. Alias for the target object ID.')
param objectIdAlias string

@description('Required. Name of the access policy to be assigned.')
param accessPolicyName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cache-redis-accesspolicyassignment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource policyAssignment 'Microsoft.Cache/redis/accessPolicyAssignments@2024-11-01' = {
  name: name
  parent: redisCache
  properties: {
    objectId: objectId
    objectIdAlias: objectIdAlias
    accessPolicyName: accessPolicyName
  }
}

@description('The name of the access policy assignment.')
output name string = policyAssignment.name

@description('The resource ID of the access policy assignment.')
output resourceId string = policyAssignment.id

@description('The name of the resource group the access policy assignment was created in.')
output resourceGroupName string = resourceGroup().name
