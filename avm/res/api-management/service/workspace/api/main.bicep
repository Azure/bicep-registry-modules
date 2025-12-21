metadata name = 'API Management Workspace APIs'
metadata description = 'This module deploys an API in an API Management Workspace.'

@sys.description('Required. API revision identifier.')
param name string

@sys.description('Conditional. The name of the parent API Management service.')
param apiManagementServiceName string

@sys.description('Conditional. The name of the parent Workspace.')
param workspaceName string

@sys.description('Optional. Array of Policies to apply to the Service API.')
param policies policyType[]?

@sys.description('Optional. Array of diagnostics to apply to the Service API.')
param diagnostics diagnosticType[]?

@sys.description('Optional. The operations of the api.')
param operations operationType[]?

@sys.description('Optional. Describes the Revision of the API.')
param apiRevision string?

@sys.description('Optional. Description of the API Revision.')
param apiRevisionDescription string?

@sys.description('Optional. Type of API to create.')
@allowed(['graphql', 'http', 'soap', 'websocket'])
param apiType string = 'http'

@sys.description('Optional. Indicates the Version identifier of the API if the API is versioned.')
param apiVersion string?

@sys.description('Optional. Description of the API Version.')
param apiVersionDescription string?

@sys.description('Optional. Collection of authentication settings included into this API.')
param authenticationSettings resourceInput<'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01'>.properties.authenticationSettings?

@sys.description('Optional. Description of the API. May include HTML formatting tags.')
param description string?

@sys.description('Required. API display name.')
@maxLength(300)
param displayName string

@sys.description('Optional. Format of the Content in which the API is getting imported.')
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

@sys.description('Optional. Indicates if API revision is current API revision.')
param isCurrent bool = true

@sys.description('Required. Relative URL uniquely identifying this API.')
param path string

@sys.description('Optional. Describes on which protocols the operations in this API can be invoked.')
param protocols string[] = ['https']

@sys.description('Optional. Absolute URL of the backend service implementing this API.')
@maxLength(2000)
param serviceUrl string?

@sys.description('Optional. The name of the API version set to link.')
param apiVersionSetName string?

@sys.description('Optional. API identifier of the source API.')
param sourceApiId string?

@sys.description('Optional. Protocols over which API is made available.')
param subscriptionKeyParameterNames resourceInput<'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01'>.properties.subscriptionKeyParameterNames?

@sys.description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
param subscriptionRequired bool = false

@sys.description('Optional. Type of API.')
@allowed(['graphql', 'http', 'soap', 'websocket'])
param type string = 'http'

@sys.description('Optional. Content value when Importing an API.')
param value string?

@sys.description('Optional. Criteria to limit import of WSDL to a subset of the document.')
param wsdlSelector resourceInput<'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01'>.properties.wsdlSelector?

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName

    resource apiVersionSet 'apiVersionSets@2024-05-01' existing = if (!empty(apiVersionSetName)) {
      name: apiVersionSetName!
    }
  }
}

resource api 'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01' = {
  name: name
  parent: service::workspace
  properties: {
    apiRevision: apiRevision
    apiRevisionDescription: apiRevisionDescription
    apiType: apiType
    apiVersion: apiVersion
    apiVersionDescription: apiVersionDescription
    apiVersionSetId: !empty(apiVersionSetName) ? service::workspace::apiVersionSet.id : null
    authenticationSettings: authenticationSettings ?? {}
    description: description ?? ''
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

module api_operations 'operation/main.bicep' = [
  for (operation, index) in (operations ?? []): {
    name: '${deployment().name}-api-operation-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspaceName
      apiName: api.name
      name: operation.name
      displayName: operation.displayName
      method: operation.method
      urlTemplate: operation.urlTemplate
      description: operation.?description
      policies: operation.?policies
      request: operation.?request
      responses: operation.?responses
      templateParameters: operation.?templateParameters
    }
  }
]

module api_policies 'policy/main.bicep' = [
  for (policy, index) in (policies ?? []): {
    name: '${deployment().name}-api-policy-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspaceName
      apiName: api.name
      name: policy.name
      format: policy.?format
      value: policy.value
    }
  }
]

module api_diagnostics 'diagnostics/main.bicep' = [
  for (diagnostic, index) in (diagnostics ?? []): {
    name: '${deployment().name}-api-diagnostic-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspaceName
      apiName: api.name
      name: diagnostic.?name
      loggerName: diagnostic.loggerName
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

@sys.description('The name of the workspace API.')
output name string = api.name

@sys.description('The resource ID of the workspace API.')
output resourceId string = api.id

@sys.description('The resource group the workspace API was deployed to.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@sys.description('The type of a diagnostic.')
type diagnosticType = {
  @sys.description('Required. The identifier of the Diagnostic.')
  name: ('azuremonitor' | 'applicationinsights' | 'local')?

  @sys.description('Required. Resource Id of a target logger.')
  loggerName: string

  @sys.description('Optional. Specifies for what type of messages sampling settings should not apply.')
  alwaysLog: ('allErrors')

  @sys.description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Backend.')
  backend: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis/diagnostics@2024-05-01'>.properties.backend?

  @sys.description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.')
  frontend: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis/diagnostics@2024-05-01'>.properties.frontend?

  @sys.description('Conditional. Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.')
  httpCorrelationProtocol: ('None' | 'Legacy' | 'W3C')?

  @sys.description('Optional. Log the ClientIP.')
  logClientIp: bool?

  @sys.description('Conditional. Emit custom metrics via emit-metric policy. Required if using Application Insights.')
  metrics: bool?

  @sys.description('Conditional. The format of the Operation Name for Application Insights telemetries. Required if using Application Insights.')
  operationNameFormat: ('Name' | 'Url')

  @sys.description('Optional. Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.')
  @minValue(0)
  @maxValue(100)
  samplingPercentage: int?

  @sys.description('Optional. The verbosity level applied to traces emitted by trace policies.')
  verbosity: ('verbose' | 'information' | 'error')?
}

import * as operationTypes from 'operation/main.bicep'

@export()
@sys.description('The type of an operation.')
type operationType = {
  @sys.description('Required. Operation Name.')
  name: string

  @sys.description('Required. The display name of the operation.')
  displayName: string

  @sys.description('Required. A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.')
  method: string

  @minLength(1)
  @maxLength(1000)
  @sys.description('Required. Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}.')
  urlTemplate: string

  @maxLength(1000)
  @sys.description('Optional. Description of the operation.')
  description: string?

  @sys.description('Optional. An entity containing request details.')
  request: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis/operations@2024-05-01'>.properties.request?

  @sys.description('Optional. Array of Operation responses.')
  responses: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis/operations@2024-05-01'>.properties.responses?

  @sys.description('Optional. Collection of URL template parameters.')
  templateParameters: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis/operations@2024-05-01'>.properties.templateParameters?

  @sys.description('Optional. Array of Policies to apply to the operation.')
  policies: operationTypes.policyType[]?
}

@export()
@sys.description('The type of a policy.')
type policyType = {
  @sys.description('Required. The name of the policy.')
  name: string

  @sys.description('Optional. Format of the policyContent.')
  format: ('rawxml' | 'rawxml-link' | 'xml' | 'xml-link')?

  @sys.description('Required. Contents of the Policy as defined by the format.')
  value: string
}
