@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Redis Enterprise cluster.')
param redisClusterName string

@description('Optional. The name of the geo-replication group.')
param geoReplicationGroupName string = 'geo-replication-group'

resource redisCluster 'Microsoft.Cache/redisEnterprise@2025-05-01-preview' = {
  name: redisClusterName
  location: location
  sku: {
    name: 'Balanced_B10'
  }

  resource redisDatabase 'databases@2025-05-01-preview' = {
    name: 'default'
    properties: {
      geoReplication: {
        groupNickname: geoReplicationGroupName
        linkedDatabases: [
          {
            id: '${redisCluster.id}/databases/default'
          }
        ]
      }
    }
  }
}

@description('The resource ID of the created Redis database')
output redisDbResourceId string = redisCluster::redisDatabase.id

@description('The location of the created Redis Cache')
output redisLocation string = redisCluster.location

@description('The name of the created Redis Cache')
output redisClusterName string = redisCluster.name

@description('The name of the geo-replication group')
output geoReplicationGroupName string = redisCluster::redisDatabase.properties.geoReplication.groupNickname
