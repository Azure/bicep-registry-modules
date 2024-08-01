@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Cache to create.')
param redisName string

resource redis 'Microsoft.Cache/redis@2023-08-01' = {
  name: redisName
  location: location
  properties: {
    sku: {
      capacity: 2
      family: 'P'
      name: 'Premium'
    }
    enableNonSslPort: true
    minimumTlsVersion: '1.2'
    redisVersion: '6'
    replicasPerMaster: 1
    replicasPerPrimary: 1
    shardCount: 1
  }
}

@description('The resource ID of the created Redis Cache')
output redisResourceId string = redis.id

@description('The location of the created Redis Cache')
output redisLocation string = redis.location

@description('The name of the created Redis Cache')
output redisName string = redis.name
