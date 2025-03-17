metadata name = 'API Management Service Products Groups'
metadata description = 'This module deploys an API Management Service Product Group.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Product. Required if the template is used in a standalone deployment.')
param productName string

@description('Required. Name of the product group.')
param name string

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName

  resource product 'products@2021-04-01-preview' existing = {
    name: productName
  }
}

resource group 'Microsoft.ApiManagement/service/products/groups@2022-08-01' = {
  name: name
  parent: service::product
}

@description('The resource ID of the product group.')
output resourceId string = group.id

@description('The name of the product group.')
output name string = group.name

@description('The resource group the product group was deployed into.')
output resourceGroupName string = resourceGroup().name
