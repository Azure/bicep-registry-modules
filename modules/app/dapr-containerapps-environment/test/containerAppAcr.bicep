/*
This file exists as a near identical duplicate of containerApp.bicep because of;
https://github.com/Azure/bicep/issues/7836

It's just a file used for the tests, so no big whoop... but it'll be nice to refactor it out soon.
*/

@description('Specifies the name of the container app.')
param containerAppName string = 'containerapp-${uniqueString(resourceGroup().id)}'

@description('Specifies the name of the container app environment.')
param containerAppEnvName string

@description('Specifies the location for all resources.')
param location string

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
param daprAppProtocol string = 'http'

@allowed([
  'Single'
  'Multiple'
])
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

@description('Any tags that are to be applied to the Container App')
param tags object = {}

var acrPullRole = resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: containerAppEnvName
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uai.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: enableIngress ? {
        external: externalIngress
        targetPort: targetPort
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      } : null
      dapr: {
        appId: containerAppName
        appProtocol: !empty(daprAppProtocol) ? daprAppProtocol : null
        appPort: (enableIngress == true) ? daprAppPort : null
        enabled: true
      }
      activeRevisionsMode: revisionMode
      registries: [
        {
          identity: uai.id
          server: acr.properties.loginServer
        }
      ]
    }
    template: {
      revisionSuffix: revisionSuffix
      containers: [
        {
          name: containerAppName
          image: containerImage
          resources: {
            cpu: json(cpuCore)
            memory: '${memorySize}Gi'
          }
          env: environmentVariables
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
  tags: tags
  dependsOn: [
    rbacDelay
  ]
}

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = if(!empty(azureContainerRegistry)) {
  name: azureContainerRegistry
}

resource uai 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'id-${containerAppName}'
  location: location
}

@description('This allows the managed identity of the container app to access the registry')
resource uaiRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if(!empty(azureContainerRegistry)) {
  name: guid(acr.id, uai.id, acrPullRole)
  scope: acr
  //name: guid(resourceGroup().id, uai.id, acrPullRole)
  properties: {
    roleDefinitionId: acrPullRole
    principalId: uai.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

module rbacDelay 'br/public:deployment-scripts/wait:1.0.1' = {
  name: 'wait-${containerAppName}'
  params: {
    waitSeconds: 30
    location: location
  }
  dependsOn: [
    uaiRbac
  ]
}

output containerAppFQDN string = enableIngress ? containerApp.properties.configuration.ingress.fqdn : ''
output userAssignedIdPrincipalId string = uai.properties.principalId
