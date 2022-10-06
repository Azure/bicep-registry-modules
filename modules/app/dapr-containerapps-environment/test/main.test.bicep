param location string = resourceGroup().location

var locationZoneRedundant = 'eastus' //Needing to hardcode for the moment ManagedEnvironmentZoneRedundantNotSupportedInRegion
module prereqVnet 'vnet.bicep' = {
  name: 'vnet'
  params: {
    location: locationZoneRedundant
  }
}

module zoneRedundantEnv '../main.bicep' = {
  name: 'zoneRedundantEnv'
  params: {
    location: locationZoneRedundant
    nameseed: 'zoneRed'
    daprComponentType: 'state.azure.blobstorage'
    infrastructureSubnetId: prereqVnet.outputs.subnetId
    zoneRedundant: true
  }
}

@description('test1 creates a public pub sub container dapr app')
module test1PubSub 'test1-pubsub.bicep' = {
  name: 'test1-pubsub'
  params: {
    location: location
  }
}


/* Commenting these 2 out as it's going overboard on the tests. Getting MaxNumberOfRegionalEnvironmentsInSubExceeded erorr.
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
*/


module multiComponentTestComponent1 '../main.bicep' = {
  name: 'multicomponentEnvPlusCosmos'
  params: {
    location: location
    daprComponentType: 'state.azure.cosmosdb'
    nameseed: 'myapp44'
  }
}
module multiComponentTestComponent2 '../main.bicep' = {
  name: 'multicomponentBlobAddToEnv'
  params: {
    location: location
    daprComponentType: 'state.azure.blobstorage'
    nameseed: 'myapp48'
    
    environmentAlreadyExists: true
    containerAppEnvName: multiComponentTestComponent1.outputs.containerAppEnvironmentName
  }
}

