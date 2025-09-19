metadata name = 'API Management Service Products APIs'
metadata description = 'This module deploys an API Management Service Product API.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Product. Required if the template is used in a standalone deployment.')
param productName string

@description('Required. Name of the product API.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource product 'products@2024-05-01' existing = {
    name: productName
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-productapi.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource api 'Microsoft.ApiManagement/service/products/apis@2024-05-01' = {
  name: name
  parent: service::product
}

@description('The resource ID of the product API.')
output resourceId string = api.id

@description('The name of the product API.')
output name string = api.name

@description('The resource group the product API was deployed into.')
output resourceGroupName string = resourceGroup().name
