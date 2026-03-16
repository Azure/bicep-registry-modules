metadata name = 'Container Registries Tokens'
metadata description = 'This module deploys an Azure Container Registry (ACR) Token.'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the token.')
@minLength(5)
@maxLength(50)
param name string

@description('Required. The resource ID of the scope map to which the token will be associated with.')
param scopeMapResourceId string

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The status of the token. Default is enabled.')
param status string = 'enabled'

@description('Optional. The credentials associated with the token for authentication.')
param credentials resourceInput<'Microsoft.ContainerRegistry/registries/tokens@2025-11-01'>.properties.credentials?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerregistry-registry-token.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: registryName
}

resource token 'Microsoft.ContainerRegistry/registries/tokens@2025-11-01' = {
  name: name
  parent: registry
  properties: {
    scopeMapId: scopeMapResourceId
    status: status
    credentials: !empty(credentials ?? [])
      ? {
          certificates: credentials.?certificates
          passwords: credentials.?passwords
        }
      : null
  }
}

@description('The name of the token.')
output name string = token.name

@description('The name of the resource group the token was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the token.')
output resourceId string = token.id
