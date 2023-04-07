/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

// Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    // location: location
  }
}

//Test 0.
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

//Test 1.
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    location: 'eastus'
    newOrExistingEventHub: 'new'
  }
}

//Test 2.
// module test2 '../main.bicep' = {
//   name: 'test2'
//   params: {
//     location: 'eastus'
//     newOrExistingEventHub: 'existing'
//     eventHubNamespaceName: prereq.outputs.eventHubNamespaceName
//     eventHubName: prereq.outputs.eventHubName
//   }
// }

//Test 3.
module test3 '../main.bicep' = {
  name: 'test3'
  params: {
    location: 'eastus'
    newOrExistingCosmosDB: 'new'
  }
}

//Test 4.
// module test4 '../main.bicep' = {
//   name: 'test4'
//   params: {
//     location: 'eastus'
//     newOrExistingCosmosDB: 'existing'
//     cosmosDBAccountName: prereq.outputs.cosmosDBAccountName
//   }
// }

// Test 5.
module test5 '../main.bicep' = {
  name: 'test5'
  params: {
    location: 'eastus'
    newOrExistingEventHub: 'new'
    newOrExistingCosmosDB: 'new'
    enableAutoScale: true
    autoScaleMin: 2
    autoScaleMax: 4
    enableDiskEncryption: true
    enableZoneRedundant: true
    unlimitedSoftDelete: true
    unlimitedHotCache: true
    enableAutoStop: false
    enablePurge: true
    enableManagedIdentity: true
    enableDoubleEncryption: true
    enableStreamingIngest: true
  }
}
