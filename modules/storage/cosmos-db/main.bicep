@description('Deployment Location')
param location string

@description('Prefix of Cosmos DB Resource Name')
param prefix string = enableCassandra ? 'coscas' : 'cosmos'

@description('Name of Cosmos DB Resource')
@minLength(3)
@maxLength(64)
param name string = take('${prefix}${uniqueString(resourceGroup().id, location)}', 64)

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

@description('Enable Gremlin API.')
param enableGremlin bool = false

@description('Enable Serverless for consumption-based usage.')
param enableServerless bool = false

@description('Enable Table API.')
param enableTable bool = false

@description('Enable Mongo API.')
param enableMongo bool = false || enableMongoDBv34 || allowSelfServeUpgradeToMongo36 || enablemongoEnableDocLevelTTL

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = false

@description('Opt-out of local authentication and ensure only MSI and AAD can be used exclusively for authentication.')
param disableLocalAuth bool = false

@description('Flag to indicate enabling/disabling of Partition Merge feature on the account')
param enablePartitionMerge bool = false

@description('Enables the cassandra connector on the Cosmos DB C* account')
param enableCassandraConnector bool = false

@description('Flag to indicate whether to enable storage analytics.')
param enableAnalyticalStorage bool = false

@description('Disable rate limiting on responses.')
param disableRateLimitingResponses bool = false

@description('Analytical storage specific properties.')
@allowed([ 'FullFidelity', 'None' ])
param analyticalStorageConfiguration string = 'FullFidelity'

@allowed([ '3.2', '3.6', '4.0', '4.2'])
param serverVersion string = '4.2'

@description('Enable Aggregation Pipeline')
param enableAggregationPipeline bool = false

@description('Enable MongoDBv34')
param enableMongoDBv34 bool = false

@description('Allow Self Serve Upgrade To Mongo36')
param allowSelfServeUpgradeToMongo36 bool = false

@description('Enable mongoEnableDocLevelTTL')
param enablemongoEnableDocLevelTTL bool = false

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

#disable-next-line BCP334
var locations = union([
    {
      locationName: location
      failoverPriority: 0
      isZoneRedundant: isZoneRedundant
    }
  ], secondaryRegions)
var capabilities = union(
  disableRateLimitingResponses ? [ { name: 'DisableRateLimitingResponses' } ] : [],
  enableMongo ? [ { name: 'EnableMongo' } ] : [],
  allowSelfServeUpgradeToMongo36 ? [ { name: 'AllowSelfServeUpgradeToMongo36' } ] : [],
  enableAggregationPipeline ? [ { name: 'EnableAggregationPipeline' } ] : [],
  enableMongoDBv34 ? [ { name: 'MongoDBv34' } ] : [],
  enablemongoEnableDocLevelTTL ? [ { name: 'mongoEnableDocLevelTTL' } ] : [],
  enableTable ? [ { name: 'EnableTable' } ] : [],
  enableGremlin ? [ { name: 'EnableGremlin' } ] : [],
  enableCassandra ? [ { name: 'EnableCassandra' } ] : [],
  enableServerless ? [ { name: 'EnableServerless' } ] : []
)

module cosmosDB 'module/cosmos.bicep' = {
  name: 'deploy-cosmosdb'
  params: {
    name: name
    location: location
    properties: {
      analyticalStorageConfiguration: enableAnalyticalStorage ? {
        schemaType: analyticalStorageConfiguration
      } : null
      apiProperties: enableMongo ? {
        serverVersion: serverVersion
      }: null
      databaseAccountOfferType: 'Standard'
      locations: locations
      capabilities: capabilities
      consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
      disableLocalAuth: disableLocalAuth
      enableAnalyticalStorage: enableAnalyticalStorage
      enableAutomaticFailover: systemManagedFailover
      enableCassandraConnector: enableCassandraConnector
      enableMultipleWriteLocations: enableMultipleWriteLocations
      enablePartitionMerge: enablePartitionMerge

    }
  }
}

@description('Cosmos DB Resource ID')
output id string = cosmosDB.outputs.id

@description('Cosmos DB Resource Name')
output name string = cosmosDB.outputs.name
