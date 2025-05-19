metadata name = 'Redis Cache Access Policy'
metadata description = 'This module deploys an access policy for Redis Cache.'

@description('Required. The name of the Redis cache.')
param redisCacheName string

@description('Required. The name of the access policy.')
param name string

@description('Required. Permissions associated with the access policy.')
param permissions string

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
