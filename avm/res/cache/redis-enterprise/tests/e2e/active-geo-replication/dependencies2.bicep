@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Cache to create.')
param redisName string

@description('Required. The name of the geo-replication group.')
param geoReplicationGroupName string

@description('Optional. The zones to deploy resources to.')
param zones array = [
  1
  2
  3
]

module redis '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-redisEnterprise'
  scope: resourceGroup()
  params: {
    name: redisName
    location: location
    geoReplication: {
      groupNickname: geoReplicationGroupName
      linkedDatabases: [
        {
          id: '${resourceGroup().id}/providers/Microsoft.Cache/redisEnterprise/${redisName}/databases/default'
        }
      ]
    }
    zones: zones
  }
}

@description('The resource ID of the created Redis database')
output redisDbResourceId string = redis.outputs.dbResourceId

@description('The location of the created Redis Cache')
output redisLocation string = redis.outputs.location

@description('The name of the created Redis Cache')
output redisName string = redis.outputs.name
