@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the geo-replication group.')
param geoReplicationGroupName string

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'creagr'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

resource redisCluster 'Microsoft.Cache/redisEnterprise@2024-09-01-preview' = {
  name: '${namePrefix}${serviceShort}001'
  location: location
  sku: {
    capacity: 2
    name: 'Enterprise_E5'
  }
  zones: ['1', '2', '3']

  resource redisDatabase 'databases@2024-09-01-preview' = {
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
