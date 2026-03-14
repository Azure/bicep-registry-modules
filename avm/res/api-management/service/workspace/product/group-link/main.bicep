metadata name = 'API Management Workspace Product Group Links'
metadata description = 'This module deploys a Product Group Link in an API Management Workspace.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Conditional. The name of the parent Product. Required if the template is used in a standalone deployment.')
param productName string

@description('Required. The name of the Product Group link.')
param name string

@description('Required. Full resource Id of a Group.')
param groupResourceId string

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName

    resource product 'products@2024-05-01' existing = {
      name: productName
    }
  }
}

resource groupLink 'Microsoft.ApiManagement/service/workspaces/products/groupLinks@2024-05-01' = {
  name: name
  parent: service::workspace::product
  properties: {
    groupId: groupResourceId
  }
}

@description('The resource ID of the workspace product group link.')
output resourceId string = groupLink.id

@description('The name of the workspace product group link.')
output name string = groupLink.name

@description('The resource group the workspace product group link was deployed into.')
output resourceGroupName string = resourceGroup().name
