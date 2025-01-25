metadata name = 'API Management Service APIs'
metadata description = 'This module deploys an API Management Service API.'

@description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
param name string

@description('Optional. Array of Policies to apply to the Service API.')
param policies array?

@description('Optional. Array of diagnostics to apply to the Service API.')
param diagnostics array?

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created.')
param apiRevision string?

@description('Optional. Description of the API Revision.')
param apiRevisionDescription string?

@description('Optional. Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API.')
@allowed([
  'graphql'
  'http'
  'soap'
  'websocket'
])
param apiType string = 'http'

@description('Optional. Indicates the Version identifier of the API if the API is versioned.')
param apiVersion string?

@description('Optional. Indicates the Version identifier of the API version set.')
param apiVersionSetId string?

@description('Optional. Description of the API Version.')
param apiVersionDescription string?

@description('Optional. Collection of authentication settings included into this API.')
param authenticationSettings object?

@description('Optional. Description of the API. May include HTML formatting tags.')
param apiDescription string?

@description('Required. API name. Must be 1 to 300 characters long.')
@maxLength(300)
param displayName string

@description('Optional. Format of the Content in which the API is getting imported.')
@allowed([
  'wadl-xml'
  'wadl-link-json'
  'swagger-json'
  'swagger-link-json'
  'wsdl'
  'wsdl-link'
  'openapi'
  'openapi+json'
  'openapi-link'
  'openapi+json-link'
])
param format string = 'openapi'

@description('Optional. Indicates if API revision is current API revision.')
param isCurrent bool = true

@description('Conditional. The name of the API management service logger. Required if using api/diagnostics.')
param loggerName string = ''

@description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
param path string

@description('Optional. Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS.')
param protocols array = [
  'https'
]

@description('Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
@maxLength(2000)
param serviceUrl string?

@description('Optional. API identifier of the source API.')
param sourceApiId string?

@description('Optional. Protocols over which API is made available.')
param subscriptionKeyParameterNames object?

@description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
param subscriptionRequired bool = false

@description('Optional. Type of API.')
@allowed([
  'graphql'
  'http'
  'soap'
  'websocket'
])
param type string = 'http'

@description('Optional. Content value when Importing an API.')
param value string?

@description('Optional. Criteria to limit import of WSDL to a subset of the document.')
param wsdlSelector object?

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: name
  parent: service
  properties: {
    apiRevision: apiRevision
    apiRevisionDescription: apiRevisionDescription
    apiType: apiType
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: apiVersionSetId
    authenticationSettings: authenticationSettings ?? {}
    description: apiDescription ?? ''
    displayName: displayName
    format: !empty(value) ? format : null
    isCurrent: isCurrent
    path: path
    protocols: protocols
    serviceUrl: serviceUrl
    sourceApiId: sourceApiId
    subscriptionKeyParameterNames: subscriptionKeyParameterNames
    subscriptionRequired: subscriptionRequired
    type: type
    value: value
    wsdlSelector: wsdlSelector ?? {}
  }
}

module policy 'policy/main.bicep' = [
  for (policy, index) in policies ?? []: {
    name: '${deployment().name}-Policy-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      apiName: api.name
      format: policy.?format ?? 'xml'
      value: policy.value
    }
  }
]

module diagnostic 'diagnostics/main.bicep' = [
  for (diagnostic, index) in diagnostics ?? []: {
    name: '${deployment().name}-diagnostics-${index}'
    params: {
      name: diagnostic.?name
      apiManagementServiceName: apiManagementServiceName
      apiName: api.name
      loggerName: loggerName
      alwaysLog: diagnostic.?alwaysLog
      backend: diagnostic.?backend
      frontend: diagnostic.?frontend
      httpCorrelationProtocol: diagnostic.?httpCorrelationProtocol
      logClientIp: diagnostic.?logClientIp
      metrics: diagnostic.?metrics
      operationNameFormat: diagnostic.?operationNameFormat
      samplingPercentage: diagnostic.?samplingPercentage
      verbosity: diagnostic.?verbosity
    }
  }
]

@description('The name of the API management service API.')
output name string = api.name

@description('The resource ID of the API management service API.')
output resourceId string = api.id

@description('The resource group the API management service API was deployed to.')
output resourceGroupName string = resourceGroup().name
