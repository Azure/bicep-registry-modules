metadata name = 'Static Web App Site Linked Backends'
metadata description = 'This module deploys a Custom Function App into a Static Web App Site using the Linked Backends property.'

@description('Required. The resource ID of the backend linked to the static site.')
param backendResourceId string

@description('Optional. The region of the backend linked to the static site.')
param region string = resourceGroup().location

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Name of the backend to link to the static site.')
param name string = uniqueString(backendResourceId)

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource linkedBackend 'Microsoft.Web/staticSites/linkedBackends@2022-03-01' = {
  name: name
  parent: staticSite
  properties: {
    backendResourceId: backendResourceId
    region: region
  }
}

@description('The name of the static site linked backend.')
output name string = linkedBackend.name

@description('The resource ID of the static site linked backend.')
output resourceId string = linkedBackend.id

@description('The resource group the static site linked backend was deployed into.')
output resourceGroupName string = resourceGroup().name
