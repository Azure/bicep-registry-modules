@description('Specifies the name of the container app.')
param containerAppName string = 'containerapp-${uniqueString(resourceGroup().id)}'

@description('Specifies the name of the container app environment.')
param containerAppEnvName string

@description('Specifies the location for all resources.')
@allowed([
  'northcentralusstage'
  'eastus'
  'northeurope'
  'canadacentral'
])
param location string //cannot use resourceGroup().location since it's not available in most of regions

@description('Specifies the docker container image to deploy.')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Specifies the container port.')
param targetPort int = 80

@description('Specifies the dapr app port.')
param daprAppPort int = targetPort

@description('Number of CPU cores the container can use. Can be with a maximum of two decimals.')
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

param revisionSuffix string = uniqueString(utcNow())

param environmentVariables array = []

@description('An ACR name can be optionally passed if thats where the container app image is homed')
param azureContainerRegistry string = ''

var acrPullRole = resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

@description('If ACR is being used, the instruct the container app to use the managed identity')
var containerAppRegistries = !empty(azureContainerRegistry) ? [{
  identity: 'system'
  server: !empty(azureContainerRegistry) ? acr.properties.loginServer : ''
}] : []

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: containerAppEnvName
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: containerAppEnv.id
    configuration: {
      ingress: {
        external: externalIngress
        targetPort: targetPort
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      dapr: {
        appId: containerAppName
        appProtocol: 'http'
        appPort: daprAppPort
        enabled: true
      }
      activeRevisionsMode: 'Single'
      registries: containerAppRegistries
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
}

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = if(!empty(azureContainerRegistry)) {
  name: azureContainerRegistry
}

@description('This allows the managed identity of the container app to access the registry')
resource acrRbac 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = if(!empty(azureContainerRegistry)) {
  name: 'app-acr-rbac'
  scope: acr
  properties: {
    roleDefinitionId: acrPullRole
    principalId: containerApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output containerAppFQDN string = containerApp.properties.configuration.ingress.fqdn
