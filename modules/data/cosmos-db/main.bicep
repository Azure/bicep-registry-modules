@description('Deployment Location')
param location string

@description('Name of Cosmos DB')
param name string = '$prefix-${uniqueString(resourceGroup().id, location)}'

@allowed([ 'new', 'existing' ])
@description('Specifies whether to create a new Cosmos DB account or use an existing one. Use "new" to create a new account or "existing" to use an existing one.')
param newOrExisting string = 'new'

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

@description('array of region objects or regions: [{locationName: string, failoverPriority: int, isZoneRedundant: bool}] or [region: string]')
param secondaryLocations array = []

@description('Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.')
param enableMultipleWriteLocations bool = true

@description('Enable Cassandra Backend.')
param enableCassandra bool = false

@description('Enable Serverless for consumption-based usage.')
param enableServerless bool = false

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = false

@description('The ID of the virtual network to which the Cosmos DB account should be attached. If not specified, the Cosmos DB account will not be attached to a virtual network.')
param vnetId string = ''

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
var vnetResource = vnetId != '' ? az.resourceId(subscription().id, 'Microsoft.Network/virtualNetworks', vnetId) : null

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
    capabilities: capabilities
    virtualNetworkRules: [
      {
        id: vnetResource
        ignoreMissingVNetServiceEndpoint: false
      }
    ]
  }
}

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: toLower(name)
}

@description('The resource ID of the Cosmos DB account.')
output resourceId string = account.id
