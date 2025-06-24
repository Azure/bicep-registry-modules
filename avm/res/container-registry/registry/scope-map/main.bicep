metadata name = 'Container Registries scopeMaps'
metadata description = 'This module deploys an Azure Container Registry (ACR) scopeMap.'

@sys.description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@sys.description('Optional. The name of the scope map.')
param name string = '${registryName}-scopemaps'

@sys.description('Required. The list of scoped permissions for registry artifacts.')
param actions string[]

@sys.description('Optional. The user friendly description of the scope map.')
param description string?

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}

resource scopeMap 'Microsoft.ContainerRegistry/registries/scopeMaps@2023-06-01-preview' = {
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
