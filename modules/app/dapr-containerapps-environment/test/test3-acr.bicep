/*
This test extends the application from test2-state.bicep into an ACR image hosted scenario

It deploys the same 2 containers apps, but instead of being sourced from ghcr.io,
they come from an Azure Container Registry.  

The test deploys 2 container apps, and the corresponding LogAnalytics workspace can be queried for successful orders with;
ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'nodeappacr' and (Log_s contains 'persisted' or Log_s contains 'order') | project ContainerAppName_s, Log_s, TimeGenerated | take 5
*/

param location string
param nodeAppImage string = 'ghcr.io/dapr/samples/hello-k8s-node:latest'
param nodeAppName string = 'nodeappacr'
param pyAppImage string = 'ghcr.io/dapr/samples/hello-k8s-python:latest'
param pyAppName string = 'pythonappacr'

@description('If your Acr is already seeded with the images, you can opt-out of the import')
param importImagesToAcr bool = true

module test3Env '../main.bicep' = {
  name: 'test3-acr-state'
  params: {
    location: location
    nameseed: 'stateSt1Acr'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
    daprComponentScopes: [
      nodeAppName
    ]
  }
}

module acr 'containerRegistry.bicep' = {
  name: 'test3-acr'
  params: {
    location: location
    nameseed: 'stateSt1'
  }
}

@description('This module seeds the ACR with the public version of the app')
module acrImportImages 'br/public:deployment-scripts/import-acr:2.1.1' = if(importImagesToAcr) {
  name: 'test3-importImages'
  params: {
    acrName: acr.outputs.name
    location: location
    images: [
      nodeAppImage
      pyAppImage
    ]
  }
}

module appNodeStateAcr 'containerAppAcr.bicep' = {
  name: 'stateNodeAppAcr'
  params: {
    location: location
    containerAppName: nodeAppName
    containerAppEnvName: test3Env.outputs.containerAppEnvironmentName
    azureContainerRegistry: acr.outputs.name
    containerImage: acrImportImages.outputs.images[0].acrHostedImageUri
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

module appPythonClient 'containerAppAcr.bicep' = {
  name: 'stateNodePyAppAcr'
  params: {
    location: location
    containerAppName: pyAppName
    containerAppEnvName: test3Env.outputs.containerAppEnvironmentName
    azureContainerRegistry: acr.outputs.name
    containerImage: acrImportImages.outputs.images[1].acrHostedImageUri
    enableIngress: false
    daprAppProtocol: ''
  }
}
