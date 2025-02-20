metadata name = 'API Management Service Policies'
metadata description = 'This module deploys an API Management Service Policy.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

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

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource policy 'Microsoft.ApiManagement/service/policies@2022-08-01' = {
  name: name
  parent: service
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the API management service policy.')
output resourceId string = policy.id

@description('The name of the API management service policy.')
output name string = policy.name

@description('The resource group the API management service policy was deployed into.')
output resourceGroupName string = resourceGroup().name
