metadata name = 'API Management Workspace Product Policies'
metadata description = 'This module deploys a Policy for a Product in an API Management Workspace.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Conditional. The name of the parent product. Required if the template is used in a standalone deployment.')
param productName string

@description('Optional. The name of the policy.')
param name string = 'policy'

@description('Optional. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName

    resource product 'products@2024-05-01' existing = {
      name: productName
    }
  }
}

resource policy 'Microsoft.ApiManagement/service/workspaces/products/policies@2024-05-01' = {
  name: name
  parent: service::workspace::product
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the workspace product policy.')
output resourceId string = policy.id

@description('The name of the workspace product policy.')
output name string = policy.name

@description('The resource group the workspace product policy was deployed into.')
output resourceGroupName string = resourceGroup().name
