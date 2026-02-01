metadata name = 'API Management Workspace API Operation Policies'
metadata description = 'This module deploys an API Operation Policy in an API Management Workspace.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Conditional. The name of the parent operation. Required if the template is used in a standalone deployment.')
param operationName string

@description('Optional. The name of the policy.')
param name string = 'policy'

@description('Optional. Format of the policyContent.')
@allowed(['rawxml', 'rawxml-link', 'xml', 'xml-link'])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName

    resource api 'apis@2024-05-01' existing = {
      name: apiName

      resource operation 'operations@2024-05-01' existing = {
        name: operationName
      }
    }
  }
}

resource policy 'Microsoft.ApiManagement/service/workspaces/apis/operations/policies@2024-05-01' = {
  name: name
  parent: service::workspace::api::operation
  properties: {
    value: value
    format: format
  }
}

@description('The resource ID of the workspace API operation policy.')
output resourceId string = policy.id

@description('The name of the workspace API operation policy.')
output name string = policy.name

@description('The resource group the workspace API operation policy was deployed into.')
output resourceGroupName string = resourceGroup().name
