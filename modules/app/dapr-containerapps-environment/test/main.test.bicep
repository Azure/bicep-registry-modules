/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

module justAnEnv '../main.bicep' = {
  name: 'simplesEnv'
  params: {
    location: location
    nameseed: 'simples'
    daprComponentType: 'state.azure.blobstorage'
  }
}

@description('test1 creates a public pub sub container dapr app')
module test1PubSub 'test1-pubsub.bicep' = {
  name: 'test1-pubsub'
  params: {
    location: location
  }
}

@description('test2 creates a public container dapr app  that uses azure storage for state')
module test2State 'test2-state.bicep' = {
  name: 'test2-state'
  params: {
    location: location
  }
}

@description('test3 extends the test2 scenario, but with a container registry for private image hosting')
module test3 'test3-acr.bicep' = {
  name: 'test3-state-acr'
  params: {
    location: location
  }
}
