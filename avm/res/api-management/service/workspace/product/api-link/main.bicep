metadata name = 'API Management Workspace Product API Links'
metadata description = 'This module deploys an Product API Link in an API Management Workspace.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param productName string

@description('Required. The name of the Product API link.')
param name string

@description('Required. Full resource Id of an API.')
param apiResourceId string

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName

    resource product 'products@2024-05-01' existing = {
      name: productName
    }
  }
}

resource apiLink 'Microsoft.ApiManagement/service/workspaces/products/apiLinks@2024-05-01' = {
  name: name
  parent: service::workspace::product
  properties: {
    apiId: apiResourceId
  }
}

@description('The resource ID of the workspace product API link.')
output resourceId string = apiLink.id

@description('The name of the workspace product API link.')
output name string = apiLink.name

@description('The resource group the workspace product API link was deployed into.')
output resourceGroupName string = resourceGroup().name
