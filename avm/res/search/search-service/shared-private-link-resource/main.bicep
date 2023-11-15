metadata name = 'Search Services Private Link Resources'
metadata description = 'This module deploys a Search Service Private Link Resource.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent searchServices. Required if the template is used in a standalone deployment.')
param searchServiceName string

@description('Required. The name of the shared private link resource managed by the Azure Cognitive Search service within the specified resource group.')
param name string

@description('Required. The resource ID of the resource the shared private link resource is for.')
param privateLinkResourceId string

@description('Required. The group ID from the provider of resource the shared private link resource is for.')
param groupId string

@description('Required. The request message for requesting approval of the shared private link resource.')
param requestMessage string

@description('Optional. Can be used to specify the Azure Resource Manager location of the resource to which a shared private link is to be created. This is only required for those resources whose DNS configuration are regional (such as Azure Kubernetes Service).')
param resourceRegion string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

// =============== //
//   Deployments   //
// =============== //

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

resource searchService 'Microsoft.Search/searchServices@2022-09-01' existing = {
  name: searchServiceName
}

resource sharedPrivateLinkResource 'Microsoft.Search/searchServices/sharedPrivateLinkResources@2022-09-01' = {
  parent: searchService
  name: name
  properties: {
    privateLinkResourceId: privateLinkResourceId
    groupId: !empty(groupId) ? groupId : null
    requestMessage: !empty(requestMessage) ? requestMessage : null
    resourceRegion: !empty(resourceRegion) ? resourceRegion : null
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the shared private link resource.')
output name string = sharedPrivateLinkResource.name

@description('The resource ID of the shared private link resource.')
output resourceId string = sharedPrivateLinkResource.id

@description('The name of the resource group the shared private link resource was created in.')
output resourceGroupName string = resourceGroup().name
