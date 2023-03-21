// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
// Deploy Cosmos DB

//                                                    Parameters
// ********************************************************************************************************************
param location string
param name string = 'cosmos-${uniqueString(resourceGroup().id, location)}'
param systemManagedFailover bool = true
param secondaryLocations array = []
param enableMultipleWriteLocations bool = true
param EnableServerless bool = false
param isZoneRedundant bool = false

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

@allowed([ 'Eventual', 'ConsistentPrefix', 'Session', 'BoundedStaleness', 'Strong' ])
param defaultConsistencyLevel string = 'Session'

@minValue(5)
@maxValue(86400)
param maxIntervalInSeconds int = 300

@minValue(10)
@maxValue(2147483647)
param maxStalenessPrefix int = 100000
// End Parameters

//                                                    Variables
// ********************************************************************************************************************
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

var unwind = [for location in locations: '${toLower(name)}-${location.locationName}.cassandra.cosmos.azure.com']
var locationString = replace(substring(string(unwind), 1, length(string(unwind))-2), '"', '')
var connectionStrings = newOrExisting == 'new' ? newAccount.listConnectionStrings() : account.listConnectionStrings()
var keys = newOrExisting == 'new' ? newAccount.listKeys() : account.listKeys()
var cassandraConnectionString = 'Contact Points=${toLower(name)}.cassandra.cosmos.azure.com,${locationString};Username=${toLower(name)};Password=${keys.primaryMasterKey};Port=10350'
// End Variables

//                                                    Resources
// ********************************************************************************************************************
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
// End Resources

//                                                    Outputs
// ********************************************************************************************************************
output connectionString string = connectionStrings.connectionStrings[0].connectionString
output cassandraConnectionString string = cassandraConnectionString
// End Outputs
