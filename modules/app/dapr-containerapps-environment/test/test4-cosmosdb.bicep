/*
This test is a representation of the microservices sample
https://review.docs.microsoft.com/en-us/azure/container-apps/dapr-github-actions?branch=pr-en-us-198450&tabs=bash
https://github.com/Azure-Samples/container-apps-store-api-microservice

It deploys 3 container apps, leveraging a CosmosDb for state;
*/

param location string = resourceGroup().location

var nameseed = 'state-cos'
var pythonServiceAppName = 'python-app'
var goServiceAppName = 'go-app'

module test4Env '../main.bicep' = {
  name: 'test4-cosmosdb-env'
  params: {
    location: location
    nameseed: nameseed
    applicationEntityName: 'orders'
    daprComponentName: 'orders'
    daprComponentType: 'state.azure.cosmosdb'
    daprComponentScopes: [
      pythonServiceAppName
    ]
  }
}

// Python App
module pythonService 'containerApp.bicep' = {
  name: 'test4-pythonapp'
  params: {
    location: location
    containerAppEnvName: test4Env.outputs.containerAppEnvironmentName
    externalIngress: false
    containerAppName: pythonServiceAppName
    containerImage: 'ghcr.io/gordonby/container-apps-store-api-microservice/python-service:sha-6db92e9'
    minReplicas: 0
    targetPort: 5000
  }
}

// Go App
module goService 'containerApp.bicep' = {
  name: 'test4-goService'
  params: {
    location: location
    containerAppEnvName: test4Env.outputs.containerAppEnvironmentName
    externalIngress: false
    containerAppName: goServiceAppName
    containerImage: 'ghcr.io/gordonby/container-apps-store-api-microservice/go-service:sha-6db92e9'
    minReplicas: 0
    targetPort: 8050
  }
}

// Node App
var nodeAppEnvVars = [
  {
    name: 'ORDER_SERVICE_NAME'
    value: pythonServiceAppName
  }
  {
    name: 'INVENTORY_SERVICE_NAME'
    value: goServiceAppName
  }
]

module nodeService 'containerApp.bicep' = {
  name: 'test4-nodeService'
  params: {
    location: location
    containerAppEnvName: test4Env.outputs.containerAppEnvironmentName
    containerAppName: 'node-app'
    containerImage: 'ghcr.io/gordonby/container-apps-store-api-microservice/node-service:sha-6db92e9'
    targetPort: 3000
    environmentVariables: nodeAppEnvVars
  }
}

output nodeFqdn string = nodeService.outputs.containerAppFQDN
output pythonFqdn string = pythonService.outputs.containerAppFQDN
output goFqdn string = goService.outputs.containerAppFQDN
