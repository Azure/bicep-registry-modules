@description('Deployment Location')
param location string

@description('Prefix of Cosmos DB Resource Name')
param prefix string = enableCassandra ? 'coscas' : 'cosmos'

@description('Name of Cosmos DB')
param name string = '${prefix}${uniqueString(resourceGroup().id, location)}'

@description('Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.')
@minValue(10)
@maxValue(2147483647)
param maxStalenessPrefix int = 100000

@description('Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
@minValue(5)
@maxValue(86400)
param maxIntervalInSeconds int = 300

@allowed([ 'Eventual', 'ConsistentPrefix', 'Session', 'BoundedStaleness', 'Strong' ])
@description('The default consistency level of the Cosmos DB account.')
param defaultConsistencyLevel string = 'Session'

@description('Enable system managed failover for regions')
param systemManagedFailover bool = true

@description('array of region objects or regions: [region: string]')
param secondaryLocations array = []

@description('Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.')
param enableMultipleWriteLocations bool = true

@description('Enable Cassandra Backend.')
param enableCassandra bool = false

@description('Enable Serverless for consumption-based usage.')
param enableServerless bool = false

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = false

var consistencyPolicy = {
  Eventual: {
    defaultConsistencyLevel: 'Eventual'
  }
  ConsistentPrefix: {
    defaultConsistencyLevel: 'ConsistentPrefix'
  }
  Session: {
    defaultConsistencyLevel: 'Session'
  }
  BoundedStaleness: {
    defaultConsistencyLevel: 'BoundedStaleness'
    maxStalenessPrefix: maxStalenessPrefix
    maxIntervalInSeconds: maxIntervalInSeconds
  }
  Strong: {
    defaultConsistencyLevel: 'Strong'
  }
}

var secondaryRegions = [for (region, i) in secondaryLocations: {
  locationName: contains(region, 'locationName') ? region.locationName : region
  failoverPriority: contains(region, 'failoverPriority') ? region.failoverPriority : i + 1
  isZoneRedundant: contains(region, 'isZoneRedundant') ? region.isZoneRedundant : isZoneRedundant
}]

var locations = union([
    {
      locationName: location
      failoverPriority: 0
      isZoneRedundant: isZoneRedundant
    }
  ], secondaryRegions)

var capabilities = union(
  enableCassandra ? [ { name: 'EnableCassandra' } ] : [],
  enableServerless ? [ { name: 'EnableServerless' } ] : []
)

resource cosmosDB 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: toLower(name)
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: systemManagedFailover
    enableMultipleWriteLocations: enableMultipleWriteLocations
    capabilities: capabilities
  }
}

@description('Cosmos DB Resource ID')
output id string = cosmosDB.id

@description('Cosmos DB Resource Name')
output name string = cosmosDB.name
