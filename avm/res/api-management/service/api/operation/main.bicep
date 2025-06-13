metadata name = 'API Management Service APIs Operations'
metadata description = 'This module deploys an API Management Service API Operation.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@sys.description('Required. The name of the operation.')
param name string

@sys.description('Required. The display name of the operation.')
param displayName string

@sys.description('Optional. The policies to apply to the operation.')
param policies policyType[]?

@sys.description('Required. A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.')
param method string

@sys.description('Required. Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}.')
param urlTemplate string

@sys.description('Optional. Description of the operation. May include HTML formatting tags. Must not be longer than 1.000 characters.')
param description string?

@sys.description('Optional. An entity containing request details.')
param request resourceInput<'Microsoft.ApiManagement/service/apis/operations@2024-05-01'>.properties.request?

@sys.description('Optional. An entity containing request details.')
param responses resourceInput<'Microsoft.ApiManagement/service/apis/operations@2024-05-01'>.properties.responses?

@sys.description('Optional. Collection of URL template parameters.')
param templateParameters resourceInput<'Microsoft.ApiManagement/service/apis/operations@2024-05-01'>.properties.templateParameters?

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName

  resource api 'apis@2022-08-01' existing = {
    name: apiName
  }
}

resource operation 'Microsoft.ApiManagement/service/apis/operations@2024-05-01' = {
  name: name
  parent: service::api
  properties: {
    displayName: displayName
    method: method
    urlTemplate: urlTemplate
    description: description
    request: request
    responses: responses
    templateParameters: templateParameters
  }
}

module policy 'policy/main.bicep' = [
  for (policy, index) in policies ?? []: {
    name: '${deployment().name}-Policy-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      apiName: apiName
      operationName: operation.name
      name: policy.name
      format: policy.format
      value: policy.value
    }
  }
]

@sys.description('The resource ID of the operation.')
output resourceId string = operation.id

@sys.description('The name of the operation.')
output name string = operation.name

@sys.description('The resource group the operation was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@sys.description('The type of a policy.')
type policyType = {
  @sys.description('Required. The name of the policy.')
  name: string

  @sys.description('Required. Format of the policyContent.')
  format: ('rawxml' | 'rawxml-link' | 'xml' | 'xml-link')

  @sys.description('Required. Contents of the Policy as defined by the format.')
  value: string
}
