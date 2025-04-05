metadata name = 'Azd Container App Upsert'
metadata description = '''Creates or updates an existing Azure Container App.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case'''

@description('Required. The name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Name of the environment for container apps.')
param containerAppsEnvironmentName string

@description('Optional. The number of CPU cores allocated to a single container instance, e.g., 0.5.')
param containerCpuCoreCount string = '0.5'

@description('Optional. The maximum number of replicas to run. Must be at least 1.')
@minValue(1)
param containerMaxReplicas int = 10

@description('Optional. The amount of memory allocated to a single container instance, e.g., 1Gi.')
param containerMemory string = '1.0Gi'

@description('Optional. The minimum number of replicas to run. Must be at least 2.')
@minValue(1)
param containerMinReplicas int = 2

@description('Optional. The name of the container.')
param containerName string = 'main'

@description('Optional. The name of the container registry.')
param containerRegistryName string = ''

@description('Optional. Hostname suffix for container registry. Set when deploying to sovereign clouds.')
param containerRegistryHostSuffix string = 'azurecr.io'

@allowed(['http', 'grpc'])
@description('Optional. The protocol used by Dapr to connect to the app, e.g., HTTP or gRPC.')
param daprAppProtocol string = 'http'

@description('Optional. Enable or disable Dapr for the container app.')
param daprEnabled bool = false

@description('Optional. The Dapr app ID.')
param daprAppId string = containerName

@description('Optional. Specifies if the resource already exists.')
param exists bool = false

@description('Optional. Specifies if Ingress is enabled for the container app.')
param ingressEnabled bool = true

@description('Optional. The type of identity for the resource.')
@allowed(['None', 'SystemAssigned', 'UserAssigned'])
param identityType string = 'None'

@description('Optional. The name of the user-assigned identity.')
param identityName string = ''

@description('Optional. The name of the container image.')
param imageName string = ''

@description('Optional. The secrets required for the container.')
@secure()
param secrets object = {}

@description('Optional. The environment variables for the container.')
param env environmentType[]?

@description('Optional. Specifies if the resource ingress is exposed externally.')
param external bool = true

@description('Optional. The service binds associated with the container.')
param serviceBinds array = []

@description('Optional. The target port for the container.')
param targetPort int = 80

@description('Optional. The principal ID of the principal to assign the role to.')
param identityPrincipalId string = ''

@description('Optional. The resource id of the user-assigned identity.')
param userAssignedIdentityResourceId string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-containerappupsert.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource existingApp 'Microsoft.App/containerApps@2023-05-02-preview' existing = if (exists) {
  name: name
}

module app 'br/public:avm/ptn/azd/acr-container-app:0.1.1' = {
  name: '${uniqueString(deployment().name, location)}-container-app-update'
  params: {
    name: name
    location: location
    tags: tags
    identityType: identityType
    identityName: identityName
    ingressEnabled: ingressEnabled
    containerName: containerName
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    containerRegistryHostSuffix: containerRegistryHostSuffix
    containerCpuCoreCount: containerCpuCoreCount
    containerMemory: containerMemory
    containerMinReplicas: containerMinReplicas
    containerMaxReplicas: containerMaxReplicas
    daprEnabled: daprEnabled
    daprAppId: daprAppId
    daprAppProtocol: daprAppProtocol
    secrets: secrets
    external: external
    env: env
    imageName: !empty(imageName) ? imageName : exists ? existingApp.properties.template.containers[0].image : ''
    targetPort: targetPort
    serviceBinds: serviceBinds
    principalId: !empty(identityName) && !empty(containerRegistryName) ? identityPrincipalId : ''
    userAssignedIdentityResourceId: !empty(identityName) && !empty(containerRegistryName)
      ? userAssignedIdentityResourceId
      : ''
    enableTelemetry: enableTelemetry
  }
}

@description('The Default domain of the Container App.')
output defaultDomain string = app.outputs.defaultDomain

@description('The name of the container image.')
output imageName string = app.outputs.imageName

@description('The name of the Container App.')
output name string = app.outputs.name

@description('The uri of the Container App.')
output uri string = app.outputs.uri

@description('The resource ID of the Container App.')
output resourceId string = app.outputs.resourceId

@description('The name of the resource group the Container App was deployed into.')
output resourceGroupName string = resourceGroup().name

type environmentType = {
  @description('Required. Environment variable name.')
  name: string

  @description('Optional. Name of the Container App secret from which to pull the environment variable value.')
  secretRef: string?

  @description('Optional. Non-secret environment variable value.')
  value: string?
}
