metadata name = 'API Management Service Product Policies'
metadata description = 'This module deploys an API Management Service Product Policy.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

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

  resource product 'products@2024-05-01' existing = {
    name: productName
  }
}

resource policy 'Microsoft.ApiManagement/service/products/policies@2024-05-01' = {
  name: name
  parent: service::product
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the Product policy.')
output resourceId string = policy.id

@description('The name of the Product policy.')
output name string = policy.name

@description('The resource group the Product policy was deployed into.')
output resourceGroupName string = resourceGroup().name
