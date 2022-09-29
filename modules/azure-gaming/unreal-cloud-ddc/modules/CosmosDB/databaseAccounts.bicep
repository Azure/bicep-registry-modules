@description('Deployment Location')
param location string

param name string = 'cosmos-${uniqueString(resourceGroup().id, location)}'

@allowed([
  'new'
  'existing'
])
param newOrExisting string = 'new'

@description('Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.')
@minValue(10)
@maxValue(2147483647)
param maxStalenessPrefix int = 100000

@description('Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
@minValue(5)
@maxValue(86400)
param maxIntervalInSeconds int = 300

@allowed([
  'Eventual'
  'ConsistentPrefix'
  'Session'
  'BoundedStaleness'
  'Strong'
])
@description('The default consistency level of the Cosmos DB account.')
param defaultConsistencyLevel string = 'Session'

@description('Enable system managed failover for regions')
param systemManagedFailover bool = true

@description('array of region objects or regions: [{locationName: string, failoverPriority: int, isZoneRedundant: bool}] or [region: string]')
param secondaryLocations array = []

@description('Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.')
param enableMultipleWriteLocations bool = true

@description('Enable Serverless for consumption-based usage.')
param EnableServerless bool = false

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

var unwind = [for location in locations: ',${toLower(name)}-${location.locationName}.cassandra.cosmos.azure.com']
var locationString = replace(substring(string(unwind), 1, length(string(unwind)) - 1), '"', '')

var connectionStrings = newOrExisting == 'new' ? newAccount.listConnectionStrings() : account.listConnectionStrings()
var keys = newOrExisting == 'new' ? newAccount.listKeys() : account.listKeys()
var cassandraConnectionString = 'Contact Points=${toLower(name)}.cassandra.cosmos.azure.com${locationString};Username=${toLower(name)};Password=${keys.primaryMasterKey};Port=10350'

resource newAccount 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = if (newOrExisting == 'new') {
  name: toLower(name)
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: consistencyPolicy[defaultConsistencyLevel]
    locations: locations
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: systemManagedFailover
    enableMultipleWriteLocations: enableMultipleWriteLocations
    capabilities: union([ { name: 'EnableCassandra' } ], EnableServerless ? [ { name: 'EnableServerless' } ] : [])
  }
}
resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = { name: toLower(name) }

@description('Key to connect with Cosmos DB')
output connectionString string = connectionStrings.connectionStrings[0].connectionString

@description('Key to connect with Cosmos DB')
output cassandraConnectionString string = cassandraConnectionString
