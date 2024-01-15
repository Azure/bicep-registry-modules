metadata name = 'Container Registries Cache'
metadata description = 'Cache for Azure Container Registry (Preview) feature allows users to cache container images in a private container registry. Cache for ACR, is a preview feature available in Basic, Standard, and Premium service tiers ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache)).'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Optional. The name of the cache rule. Will be dereived from the source repository name if not defined.')
param name string = replace(replace(sourceRepository, '/', '-'), '.', '-')

@description('Required. Source repository pulled from upstream.')
param sourceRepository string

@description('Optional. Target repository specified in docker pull command. E.g.: docker pull myregistry.azurecr.io/{targetRepository}:{tag}.')
param targetRepository string = sourceRepository

@description('Optional. The resource ID of the credential store which is associated with the cache rule.')
param credentialSetResourceId string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}

resource cacheRule 'Microsoft.ContainerRegistry/registries/cacheRules@2023-06-01-preview' = {
  name: name
  parent: registry
  properties: {
    sourceRepository: sourceRepository
    targetRepository: targetRepository
    credentialSetResourceId: !empty(credentialSetResourceId) ? credentialSetResourceId : null
  }
}

@description('The Name of the Cache Rule.')
output name string = cacheRule.name

@description('The name of the Cache Rule.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Cache Rule.')
output resourceId string = cacheRule.id
