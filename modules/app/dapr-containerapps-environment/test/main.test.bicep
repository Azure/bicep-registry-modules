/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = 'canadacentral'

module test1 '../main.bicep' = {
  name: 'test1-public-vnet-servicebus'
  params: {
    location: location
    nameseed: 'pubsub-sb1'
    applicationEntityName: 'orders'
    daprComponentType: 'pubsub.azure.servicebus'
  }
}

module test2 '../main.bicep' = {
  name: 'test1-public-vnet-state'
  params: {
    location: location
    nameseed: 'state-st1'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
  }
}
