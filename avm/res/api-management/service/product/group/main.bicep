metadata name = 'API Management Service Products Groups'
metadata description = 'This module deploys an API Management Service Product Group.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Product. Required if the template is used in a standalone deployment.')
param productName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Name of the product group.')
param name string

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

  resource product 'products@2021-04-01-preview' existing = {
    name: productName
  }
}

resource group 'Microsoft.ApiManagement/service/products/groups@2021-08-01' = {
  name: name
  parent: service::product
}

@description('The resource ID of the product group.')
output resourceId string = group.id

@description('The name of the product group.')
output name string = group.name

@description('The resource group the product group was deployed into.')
output resourceGroupName string = resourceGroup().name
