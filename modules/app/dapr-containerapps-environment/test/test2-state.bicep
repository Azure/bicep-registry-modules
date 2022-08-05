/*
This test is a representation of the microservices sample in the Azure Docs 
https://docs.microsoft.com/en-us/azure/container-apps/microservices-dapr-azure-resource-manager

It deploys 2 container apps, and the corresponding LogAnalytics workspace can be queried for successful orders with;
ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'nodeapp' and (Log_s contains 'persisted' or Log_s contains 'order') | project ContainerAppName_s, Log_s, TimeGenerated | take 5
*/

param location string

var nodeAppName='nodeapp'

module test2Env '../main.bicep' = {
  name: 'test2-acr-state'
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

module appNodeService 'containerApp.bicep' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: nodeAppName
    containerAppEnvName: test2Env.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-node:latest'
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

module appPythonClient 'containerApp.bicep' = {
  name: 'statePyApp'
  params: {
    location: location
    containerAppName: 'pythonapp'
    containerAppEnvName: test2Env.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-python:latest'
    enableIngress: false
    daprAppProtocol: ''
  }
}

output containerAppEnvironmentName string =  test2Env.outputs.containerAppEnvironmentName
