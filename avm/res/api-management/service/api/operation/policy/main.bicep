metadata name = 'API Management Service API Operation Policies'
metadata description = 'This module deploys an API Management Service API Operation Policy.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Conditional. The name of the parent operation. Required if the template is used in a standalone deployment.')
param operationName string

@description('Required. The name of the policy.')
param name string

@description('Required. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string

@description('Required. Contents of the Policy as defined by the format.')
param value string

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource api 'apis@2024-05-01' existing = {
    name: apiName

    resource operation 'operations@2024-05-01' existing = {
      name: operationName
    }
  }
}

resource policy 'Microsoft.ApiManagement/service/apis/operations/policies@2022-08-01' = {
  name: name
  parent: service::api::operation
  properties: {
    value: value
    format: format
  }
}

@description('The resource ID of the policy.')
output resourceId string = policy.id

@description('The name of the policy.')
output name string = policy.name

@description('The resource group the policy was deployed into.')
output resourceGroupName string = resourceGroup().name
