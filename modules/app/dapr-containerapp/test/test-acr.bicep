param location string = resourceGroup().location
param nodeAppImage string = 'ghcr.io/dapr/samples/hello-k8s-node:latest'
param nodeAppName string = 'nodeappacr'
param pyAppImage string = 'ghcr.io/dapr/samples/hello-k8s-python:latest'
param pyAppName string = 'pythonappacr'

@description('If your Acr is already seeded with the images, you can opt-out of the import')
param importImagesToAcr bool = true

module test3Env 'daprContainerAppEnv101/main.bicep' = {
    name: '${deployment().name}-env'
    params: {
      location: location
      nameseed: 'stateAcr'
      applicationEntityName: 'appdata'
      daprComponentType: 'state.azure.blobstorage'
      daprComponentScopes: [
        nodeAppName
      ]
    }
  }

module acr 'containerRegistry.bicep' = {
  name: '${deployment().name}-acr'
  params: {
    location: location
    nameseed: 'stateAcr'
  }
}

@description('This module seeds the ACR with the public version of the app')
module acrImportImages 'br/public:deployment-scripts/import-acr:2.1.1' = if(importImagesToAcr) {
  name: '${deployment().name}-importImages'
  params: {
    acrName: acr.outputs.name
    location: location
    images: [
      nodeAppImage
      pyAppImage
    ]
  }
}

module appNodeStateAcr '../main.bicep' = {
  name: '${deployment().name}-stateNodeApp'
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

module appPythonClient '../main.bicep' = {
  name: '${deployment().name}-stateNodePyApp'
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
