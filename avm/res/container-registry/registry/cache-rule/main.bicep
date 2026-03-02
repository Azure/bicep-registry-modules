metadata name = 'Container Registries Cache'
metadata description = 'Cache for Azure Container Registry (Preview) feature allows users to cache container images in a private container registry. Cache for ACR, is a preview feature available in Basic, Standard, and Premium service tiers ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache)).'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Optional. The name of the cache rule. Will be derived from the source repository name if not defined.')
param name string = replace(replace(replace(sourceRepository, '/', '-'), '.', '-'), '*', '')

@description('Required. Source repository pulled from upstream.')
param sourceRepository string

@description('Optional. Target repository specified in docker pull command. E.g.: docker pull myregistry.azurecr.io/{targetRepository}:{tag}.')
param targetRepository string = sourceRepository

@description('Optional. The resource ID of the credential store which is associated with the cache rule. Required only when pulling from authenticated upstream registries (e.g., Docker Hub). Omit for anonymous public registries such as MCR (mcr.microsoft.com).')
param credentialSetResourceId string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerregistry-registry-cacherule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource cacheRule 'Microsoft.ContainerRegistry/registries/cacheRules@2025-11-01' = {
  name: name
  parent: registry
  properties: {
    sourceRepository: sourceRepository
    targetRepository: targetRepository
    credentialSetResourceId: credentialSetResourceId
  }
}

@description('The Name of the Cache Rule.')
output name string = cacheRule.name

@description('The name of the Cache Rule.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Cache Rule.')
output resourceId string = cacheRule.id
