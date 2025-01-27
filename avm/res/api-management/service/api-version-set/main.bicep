metadata name = 'API Management Service API Version Sets'
metadata description = 'This module deploys an API Management Service API Version Set.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. API Version set name.')
param name string = 'default'

@description('Optional. API Version set properties.')
param properties object = {}

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2022-08-01' = {
  name: name
  parent: service
  properties: properties
}

@description('The resource ID of the API Version set.')
output resourceId string = apiVersionSet.id

@description('The name of the API Version set.')
output name string = apiVersionSet.name

@description('The resource group the API Version set was deployed into.')
output resourceGroupName string = resourceGroup().name
