metadata name = 'Azd ACR Linked Container App'
metadata description = '''Creates a container app in an Azure Container App environment.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case'''

@description('Required. The name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Allowed origins.')
param allowedOrigins array = []

@description('Required. Name of the environment for container apps.')
param containerAppsEnvironmentName string

@description('Optional. CPU cores allocated to a single container instance, e.g., 0.5.')
param containerCpuCoreCount string = '0.5'

@description('Optional. The maximum number of replicas to run. Must be at least 1.')
@minValue(1)
param containerMaxReplicas int = 10

@description('Optional. Memory allocated to a single container instance, e.g., 1Gi.')
param containerMemory string = '1.0Gi'

@description('Optional. The minimum number of replicas to run. Must be at least 2.')
param containerMinReplicas int = 2

@description('Optional. The name of the container.')
param containerName string = 'main'

@description('Optional. The name of the container registry.')
param containerRegistryName string = ''

@description('Optional. Hostname suffix for container registry. Set when deploying to sovereign clouds.')
param containerRegistryHostSuffix string = 'azurecr.io'

@description('Optional. The protocol used by Dapr to connect to the app, e.g., http or grpc.')
@allowed(['http', 'grpc'])
param daprAppProtocol string = 'http'

@description('Optional. The Dapr app ID.')
param daprAppId string = containerName

@description('Optional. Enable Dapr.')
param daprEnabled bool = false

@description('Optional. The environment variables for the container.')
param env environmentType[]?

@description('Optional. Specifies if the resource ingress is exposed externally.')
param external bool = true

@description('Optional. The name of the user-assigned identity.')
param identityName string = ''

@description('Optional. The type of identity for the resource.')
@allowed(['None', 'SystemAssigned', 'UserAssigned'])
param identityType string = 'None'

@description('Optional. The name of the container image.')
param imageName string = ''

@description('Optional. Specifies if Ingress is enabled for the container app.')
param ingressEnabled bool = true

@allowed([
  'auto'
  'http'
  'http2'
  'tcp'
])
@description('Optional. Ingress transport protocol.')
param ingressTransport string = 'auto'

@description('Optional. Rules to restrict incoming IP address.')
param ipSecurityRestrictions array = []

@description('Optional. Bool indicating if HTTP connections to is allowed. If set to false HTTP connections are automatically redirected to HTTPS connections.')
param ingressAllowInsecure bool = true

@allowed([
  'Multiple'
  'Single'
])
@description('Optional. Controls how active revisions are handled for the Container app.')
param revisionMode string = 'Single'

@description('Optional. The secrets required for the container.')
@secure()
param secrets object = {}

@description('Optional. The service binds associated with the container.')
param serviceBinds array = []

@description('Optional. The name of the container apps add-on to use. e.g. redis.')
param serviceType string = ''

@description('Optional. The target port for the container.')
param targetPort int = 80

@description('Optional. Toggle to include the service configuration.')
param includeAddOns bool = false

@description('Optional. The principal ID of the principal to assign the role to.')
param principalId string = ''

@description('Optional. The resource id of the user-assigned identity.')
param userAssignedIdentityResourceId string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// Private registry support requires both an ACR name and a User Assigned managed identity
var usePrivateRegistry = !empty(identityName) && !empty(containerRegistryName)

// Automatically set to `UserAssigned` when an `identityName` has been set
var normalizedIdentityType = !empty(identityName) ? 'UserAssigned' : identityType

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-acrcontainerapp.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module containerApp 'br/public:avm/res/app/container-app:0.10.0' = {
  name: '${uniqueString(deployment().name, location)}-container-app'
  params: {
    name: name
    location: location
    tags: tags
    managedIdentities: !empty(identityName) && normalizedIdentityType == 'UserAssigned'
      ? { userAssignedResourceIds: [userAssignedIdentityResourceId] }
      : { systemAssigned: normalizedIdentityType == 'SystemAssigned' }
    environmentResourceId: containerAppsEnvironment.id
    activeRevisionsMode: revisionMode
    disableIngress: !ingressEnabled
    ingressExternal: external
    ingressTargetPort: targetPort
    ingressTransport: ingressTransport
    ipSecurityRestrictions: ipSecurityRestrictions
    ingressAllowInsecure: ingressAllowInsecure
    corsPolicy: {
      allowedOrigins: union(['https://portal.azure.com', 'https://ms.portal.azure.com'], allowedOrigins)
    }
    dapr: daprEnabled
      ? {
          enabled: true
          appId: daprAppId
          appProtocol: daprAppProtocol
          appPort: ingressEnabled ? targetPort : 0
        }
      : { enabled: false }
    secrets: secrets
    includeAddOns: includeAddOns
    service: { type: serviceType }
    registries: usePrivateRegistry
      ? [
          {
            server: '${containerRegistryName}.${containerRegistryHostSuffix}'
            identity: userAssignedIdentityResourceId
          }
        ]
      : []
    serviceBinds: serviceBinds
    containers: [
      {
        image: !empty(imageName) ? imageName : 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: containerName
        env: env
        resources: {
          cpu: json(containerCpuCoreCount)
          memory: containerMemory
        }
      }
    ]
    scaleMaxReplicas: containerMaxReplicas
    scaleMinReplicas: containerMinReplicas
    enableTelemetry: enableTelemetry
  }
  dependsOn: usePrivateRegistry ? [containerRegistryAccess] : []
}

module containerRegistryAccess 'modules/registry-access.bicep' = if (usePrivateRegistry) {
  name: '${uniqueString(deployment().name, location)}-registry-access'
  params: {
    containerRegistryName: containerRegistryName
    principalId: usePrivateRegistry ? principalId : ''
    enableTelemetry: enableTelemetry
  }
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: containerAppsEnvironmentName
}

@description('The name of the resource group the Container App was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The Default domain of the Managed Environment.')
output defaultDomain string = containerAppsEnvironment.properties.defaultDomain

@description('The principal ID of the identity.')
output identityPrincipalId string = normalizedIdentityType == 'None'
  ? ''
  : (empty(identityName) ? containerApp.outputs.systemAssignedMIPrincipalId : principalId)

@description('The name of the container image.')
output imageName string = imageName

@description('The name of the Container App.')
output name string = containerApp.outputs.name

@description('The service binds associated with the container.')
output serviceBind object = !empty(serviceType)
  ? { serviceId: containerApp.outputs.resourceId, name: containerApp.outputs.name }
  : {}

@description('The uri of the Container App.')
output uri string = ingressEnabled ? 'https://${containerApp.outputs.fqdn}' : ''

@description('The resource ID of the Container App.')
output resourceId string = containerApp.outputs.resourceId

type environmentType = {
  @description('Required. Environment variable name.')
  name: string

  @description('Optional. Name of the Container App secret from which to pull the environment variable value.')
  secretRef: string?

  @description('Optional. Non-secret environment variable value.')
  value: string?
}
