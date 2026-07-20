metadata name = 'Container Registries scope maps'
metadata description = 'This module deploys an Azure Container Registry (ACR) scope map.'

@sys.description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@sys.description('Optional. The name of the scope map.')
param name string = '${registryName}-scopemaps'

@sys.description('Required. The list of scoped permissions for registry artifacts.')
param actions string[]

@sys.description('Optional. The user friendly description of the scope map.')
param description string?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerregistry-registry-scopemap.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource scopeMap 'Microsoft.ContainerRegistry/registries/scopeMaps@2025-11-01' = {
  name: name
  parent: registry
  properties: {
    actions: actions
    description: description
  }
}

@sys.description('The name of the scope map.')
output name string = scopeMap.name

@sys.description('The name of the resource group the scope map was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the scope map.')
output resourceId string = scopeMap.id
