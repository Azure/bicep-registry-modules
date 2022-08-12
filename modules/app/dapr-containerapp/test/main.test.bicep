/*
This test is a representation of the microservices sample in the Azure Docs 
https://docs.microsoft.com/en-us/azure/container-apps/microservices-dapr-azure-resource-manager

It deploys 2 container apps, and the corresponding LogAnalytics workspace can be queried for successful orders with;
ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'nodeapp' and (Log_s contains 'persisted' or Log_s contains 'order') | project ContainerAppName_s, Log_s, TimeGenerated | take 5
*/

param location string = resourceGroup().location

var nodeAppName='nodeapp'

module test2Env 'daprContainerAppEnv101/main.bicep' = {
  name: 'test-state'
  params: {
    location: location
    nameseed: 'stateSt1'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
    daprComponentScopes: [
      nodeAppName
    ]
  }
}

module appNodeService '../main.bicep' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: nodeAppName
    containerAppEnvName: test2Env.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-node:latest'
    targetPort: 3000
    externalIngress: false
    createUserManagedId: false
    environmentVariables: [
      {
        name: 'APP_PORT'
        value: '3000'
      }
    ]
  }
}

module appPythonClient '../main.bicep' = {
  name: 'statePyApp'
  params: {
    location: location
    containerAppName: 'pythonapp'
    containerAppEnvName: test2Env.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-python:latest'
    enableIngress: false
    createUserManagedId: false
    daprAppProtocol: ''
  }
}

output containerAppEnvironmentName string =  test2Env.outputs.containerAppEnvironmentName



@description('This module tests the same state app as this file, but through an Azure Container Registry')
module acrTest 'test-acr.bicep' =  {
  name: 'acrapp'
  params: {
    location: location
  }
}
