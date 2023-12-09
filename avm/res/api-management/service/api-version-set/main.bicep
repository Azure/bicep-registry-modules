metadata name = 'API Management Service API Version Sets'
metadata description = 'This module deploys an API Management Service API Version Set.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. API Version set name.')
param name string = 'default'

@description('Optional. API Version set properties.')
param properties object = {}

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

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2021-08-01' = {
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
