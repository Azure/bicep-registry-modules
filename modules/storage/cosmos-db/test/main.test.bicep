/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param location string = resourceGroup().location
@minLength(3)
@maxLength(64)
param name string = take('mycosmosdb${uniqueString(resourceGroup().id, location)}', 64)
@minLength(3)
@maxLength(64)
param cassandra_name string = take('mycassandradb${uniqueString(resourceGroup().id, location)}', 64)

// Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//     name: 'test-prereqs'
//   }
// }

//Test 0. Basic Deployment
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

//Test 1. Deploy with name
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    location: location
    name: name
  }
}

//Test with Cassandra Enabled
module test2 '../main.bicep' = {
  name: 'cosmosDBWithCassandra'
  params: {
    location: location
    name: cassandra_name
    enableCassandra: true
  }
}

// Test with Gremlin API enabled
module cosmosDBWithGremlin '../main.bicep' = {
  name: 'cosmosDBWithGremlin'
  params: {
    location: location
    name: take('gremlinCosmos${uniqueString(resourceGroup().id, location)}', 64)
    enableGremlin: true
  }
}

// Test with Table API enabled
module cosmosDBWithTable '../main.bicep' = {
  name: 'cosmosDBWithTable'
  params: {
    location: location
    name: take('tableCosmos${uniqueString(resourceGroup().id, location)}', 64)
    enableTable: true
  }
}

// Test with Mongo API enabled and server version set to 4.0
module cosmosDBWithMongo '../main.bicep' = {
  name: 'cosmosDBWithMongo'
  params: {
    location: location
    name: take('mongoCosmos${uniqueString(resourceGroup().id, location)}', 64)
    enableMongo: true
    serverVersion: '4.0'
  }
}

// Test with disableLocalAuth set to true and enableAnalyticalStorage set to true
module cosmosDBDisableLocalAuthAndEnableAnalyticalStorage '../main.bicep' = {
  name: 'cosmosDBDisableLocalAuthAndEnableAnalyticalStorage'
  params: {
    location: location
    name: take('disableLocalAuthCosmos${uniqueString(resourceGroup().id, location)}', 64)
    disableLocalAuth : true
    enableAnalyticalStorage : true
  }
}
