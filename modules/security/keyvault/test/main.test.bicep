/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param location string = resourceGroup().location

// Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    location: location
  }
}

// Test 0.
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

// Test 1
// Insert Secerts into existing Key Vault later in template
module test1InsertSecret '../main.bicep' = {
  name: 'test1-insert-secret'
  params: {
    location: location
    #disable-next-line BCP334 BCP335 // These are false positives, the output is configured with annotations
    name: prereq.outputs.name
    newOrExisting: 'existing'
    secretName: 'SampleName'
    secretValue: 'SampleValue'
  }
}

// Test 2 - Add storage account secret to Key Vault
param storageAccountName string = 'sa${uniqueString(resourceGroup().id, location, utcNow())}'
module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'mystorageaccount-${guid(storageAccountName)}'
  params: {
    location: location
    name: storageAccountName
  }
}

module test2StorageAccountSecret '../main.bicep' = {
  name: 'test2-storage-account-secret-${guid(storageAccountName)}'
  params: {
    location: location
    prefix: 'test4-keyvault'
    storageAccountName: prereq.outputs.storageAccountName
  }
}

// Test 3 - Add Cosmos DB secret to Key Vault
module cosmos 'br/public:storage/cosmos-db:1.0.1' = {
  name: 'mycosmos'
  params: {
    prefix: 'test5'
    location: location
  }
}

module test3CosmosDBSecret '../main.bicep' = {
  name: 'test3-cosmos-db-secret'
  params: {
    location: location
    prefix: 'test5'
    cosmosDBName: cosmos.outputs.name
  }
}

// Test 4 - Add Cassandra DB secret to Key Vault
param cassandraName string = 'sa${uniqueString(resourceGroup().id, location, utcNow())}'
var locations = [
  {
    locationName: location
    failoverPriority: 0
    isZoneRedundant: false
  }
]

var unwind = [for location in locations: '${toLower(cassandraName)}-${location.locationName}.cassandra.cosmos.azure.com']
var locationString = replace(substring(string(unwind), 1, length(string(unwind))-2), '"', '')

module cassandraDB 'br/public:storage/cosmos-db:1.0.1' = {
  name: 'mycassandradb'
  params: {
    location: location
    name: cassandraName
    enableCassandra: true
  }
}

module test4CassandraDBSecret '../main.bicep' = {
  name: 'testX-cassandra-db-secret'
  params: {
    location: location
    prefix: 'test4'
    cassandraDBName: cassandraName
    locationString: locationString
  }
}


// Test 5 Test Event Hub Secret

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  #disable-next-line use-stable-resource-identifier
  name: 'test5ehn${uniqueString(resourceGroup().id, location)}'
  location: location

  resource eventHub 'eventhubs' = {
    name: 'test5-event-hub'
    properties: {
      partitionCount: 2
      messageRetentionInDays: 1
    }

    resource eventHubAuthorizationRules 'authorizationRules' existing = {
      name: 'test5-event-hub-rules'
    }
  }
}

module test5EventHubSecret '../main.bicep' = {
  name: 'test5-event-hub-secret'
  params: {
    location: location
    prefix: 'test5-keyvault'
    eventHubNamespaceName: eventHubNamespace.name
    eventHubName: eventHubNamespace::eventHub.name
    eventHubAuthorizationRulesName: eventHubNamespace::eventHub::eventHubAuthorizationRules.name
  }
}
