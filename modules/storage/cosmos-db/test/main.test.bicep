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

//Test 1. - Deploy with name
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    location: location
    name: name
  }
}

//Test 2. - Deploy Cassandra
module test2 '../main.bicep' = {
  name: 'test3'
  params: {
    location: location
    name: cassandra_name
    enableCassandra: true
  }
}
