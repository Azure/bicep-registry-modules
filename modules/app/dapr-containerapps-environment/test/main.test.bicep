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

var pubSubAppEnvVars = [ {
  name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
  value: test1.outputs.appInsightsInstrumentationKey
}
{
  name: 'AZURE_KEY_VAULT_ENDPOINT'
  value:''
}
]
module appSubscriber 'containerApp.bicep' = {
  name: 'subscriber'
  params: {
    location: location
    containerAppEnvName: test1.outputs.containerAppEnvironmentName
    containerAppName: 'pubsub-sb1-subscriber'
    containerImage: 'ghcr.io/dapr/samples/pubsub-node-subscriber:latest'
    environmentVariables: pubSubAppEnvVars
  }
}

module appPublisher 'containerApp.bicep' = {
  name: 'publisher'
  params: {
    location: location
    containerAppEnvName: test1.outputs.containerAppEnvironmentName
    containerAppName: 'pubsub-sb1-publisher'
    containerImage: 'ghcr.io/dapr/samples/pubsub-node-subscriber:latest'
    environmentVariables: pubSubAppEnvVars
  }
}





//Test 2
//DAPR state store
//Uses ACR for private image hosting
var containerAppName='nodeapp'
var stateAppImage = 'ghcr.io/dapr/samples/hello-k8s-node:latest'

module test2 '../main.bicep' = {
  name: 'test2-acr-state'
  params: {
    location: location
    nameseed: 'stateSt1'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
    daprComponentScopes: [
      containerAppName
    ]
  }
}

module appState 'containerApp.bicep' = {
  name: 'stateApp'
  params: {
    location: location
    containerAppName: containerAppName
    containerAppEnvName: test2.outputs.containerAppEnvironmentName
    containerImage: stateAppImage
    targetPort: 3000
    externalIngress: false
    environmentVariables: [
      {
        name: 'APP_PORT'
        value: '3000'
      }
    ]
  }
}




// Test 3
//DAPR state store (Extends test 2)
//Uses ACR for private image hosting

module acr 'containerRegistry.bicep' = {
  name: 'acr'
  params: {
    location: location
    nameseed: 'stateSt1'
  }
}

@description('This module seeds the ACR with the public version of the app')
module acrImportImages 'br/public:deployment-scripts/import-acr:2.0.1' = {
  name: 'importStateImpact'
  params: {
    acrName: acr.outputs.name
    location: location
    images: array(stateAppImage)
  }
}

// module appState2 'containerApp.bicep' = {
//   name: 'stateAppAcr'
//   params: {
//     location: location
//     containerAppName: '${containerAppName}-acr'
//     containerAppEnvName: test2.outputs.containerAppEnvironmentName
//     containerImage: '${acr.outputs.loginServer}/dapr/samples/hello-k8s-node:latest'
//     targetPort: 3000
//     externalIngress: false
//     azureContainerRegistry: acr.outputs.name
//     environmentVariables: [
//       {
//         name: 'APP_PORT'
//         value: '3000'
//       }
//     ]
//   }
//   dependsOn: [
//     acrImportImages
//   ]
// }
