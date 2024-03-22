metadata name = 'Private Link Scope Scoped Resources'
metadata description = 'This module deploys a Private Link Scope Scoped Resource.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the private link scoped resource.')
@minLength(1)
param name string

@description('Conditional. The name of the parent private link scope. Required if the template is used in a standalone deployment.')
@minLength(1)
param privateLinkScopeName string

@description('Required. The resource ID of the scoped Azure monitor resource.')
param linkedResourceId string

resource privateLinkScope 'Microsoft.Insights/privateLinkScopes@2021-07-01-preview' existing = {
  name: privateLinkScopeName
}

resource scopedResource 'Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview' = {
  name: name
  parent: privateLinkScope
  properties: {
    linkedResourceId: linkedResourceId
  }
}

@description('The name of the resource group where the resource has been deployed.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed scopedResource.')
output resourceId string = scopedResource.id

@description('The full name of the deployed Scoped Resource.')
output name string = scopedResource.name
