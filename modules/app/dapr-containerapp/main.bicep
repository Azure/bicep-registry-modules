

/*
I'm not entirely happy with this module design, as it's proxying parameters to 2 (near identical) files based on the value of one parameter
This is because of the provider bug identified : https://github.com/Azure/bicep/issues/7836
Once resovled, we can simplify this module greatly.

                                 Uses ACR: Yes           ┌────────────────────────────┐
                                                         │                            │
                             ┌───────────────────────────►  containerapp-acr.bicep    │
                             │                           │                            │
                             │                           └────────────────────────────┘
┌──────────────────────────┐ │
│                          │ │
│ mcr app/dapr-containerapp│ │
│                          │ │
└──────────────────────────┘ │
                             │
                             │
                             │                           ┌────────────────────────────┐
                             │                           │                            │
                             └──────────────────────────►│  containerapp.bicep        │
                                 Uses ACR: No            │                            │
                                                         └────────────────────────────┘
 */

@description('Specifies the name of the container app.')
param containerAppName string = 'containerapp-${uniqueString(resourceGroup().id)}'

@description('Specifies the name of the container app environment to target, must be in the same resourceGroup.')
param containerAppEnvName string

@description('Specifies the location for all resources.')
param location string = resourceGroup().location

@description('Specifies the docker container image to deploy.')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Specifies the container port.')
param targetPort int = 80

@description('Specifies the dapr app port.')
param daprAppPort int = targetPort

@allowed([
  'http'
  'grpc'
  ''
])
@description('Tells Dapr which protocol your application is using. Valid options are http and grpc. Default is http')
param daprAppProtocol string = 'http'

@allowed([
  'Single'
  'Multiple'
])
@description('Controls how active revisions are handled for the Container app')
param revisionMode string = 'Single'

@description('Number of CPU cores the container can use. Can be with a maximum of two decimals places. Max of 2.0. Valid values include, 0.5 1.25 1.4')
param cpuCore string = '0.5'

@description('Amount of memory (in gibibytes, GiB) allocated to the container up to 4GiB. Can be with a maximum of two decimals. Ratio with CPU cores must be equal to 2.')
param memorySize string = '1'

@description('Minimum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param minReplicas int = 1

@description('Maximum number of replicas that will be deployed')
@minValue(0)
@maxValue(25)
param maxReplicas int = 3

@description('Should the app be exposed on an external endpoint')
param externalIngress bool = true

@description('Does the app expect traffic, or should it operate headless')
param enableIngress bool = true

@description('Revisions to the container app need to be unique')
param revisionSuffix string = uniqueString(utcNow())

@description('Any environment variables that your container needs')
param environmentVariables array = []

@description('An ACR name can be optionally passed if thats where the container app image is homed')
param azureContainerRegistry string = ''

@description('Will create a user managed identity for the application to access other Azure resoruces as')
param createUserManagedId bool = true

@description('Any tags that are to be applied to the Container App')
param tags object = {}


module containerAppsNoACR 'containerapp.bicep' = if (empty(azureContainerRegistry)) {
 name: containerAppName 
 params: {
  location: location
  containerAppEnvName: containerAppEnvName
  //azureContainerRegistry: ''
  containerAppName: containerAppName
  containerImage: containerImage
  cpuCore: cpuCore
  createUserManagedId: createUserManagedId
  daprAppPort: daprAppPort
  daprAppProtocol: daprAppProtocol
  enableIngress: enableIngress
  environmentVariables: environmentVariables
  externalIngress: externalIngress
  maxReplicas: maxReplicas
  memorySize: memorySize
  minReplicas: minReplicas
  revisionMode: revisionMode
  revisionSuffix: revisionSuffix
  tags: tags
  targetPort: targetPort
 }
}

module containerAppsACR 'containerapp-acr.bicep' = if (!empty(azureContainerRegistry)) {
  name: '${containerAppName}-acr'
  params: {
   location: location
   containerAppEnvName: containerAppEnvName
   azureContainerRegistry: azureContainerRegistry
   containerAppName: containerAppName
   containerImage: containerImage
   cpuCore: cpuCore
   createUserManagedId: createUserManagedId
   daprAppPort: daprAppPort
   daprAppProtocol: daprAppProtocol
   enableIngress: enableIngress
   environmentVariables: environmentVariables
   externalIngress: externalIngress
   maxReplicas: maxReplicas
   memorySize: memorySize
   minReplicas: minReplicas
   revisionMode: revisionMode
   revisionSuffix: revisionSuffix
   tags: tags
   targetPort: targetPort
  }
 }
 
@description('If ingress is enabled, this is the FQDN that the Container App is exposed on')
output containerAppFQDN string = enableIngress ? empty(azureContainerRegistry) ? containerAppsNoACR.outputs.containerAppFQDN : containerAppsACR.outputs.containerAppFQDN : ''

@description('The PrinicpalId of the Container Apps Managed Identity')
output userAssignedIdPrincipalId string = empty(azureContainerRegistry) ? containerAppsNoACR.outputs.userAssignedIdPrincipalId : containerAppsACR.outputs.userAssignedIdPrincipalId
