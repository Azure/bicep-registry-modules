metadata name = 'API Management Workspace Diagnostics'
metadata description = 'This module deploys a Diagnostic at API Management Workspace scope.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. Diagnostic Name.')
param name string

@description('Required. Logger resource ID.')
param loggerResourceId string

@description('Optional. Specifies for what type of messages sampling settings should not apply.')
param alwaysLog string = 'allErrors'

@description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Backend.')
param backend resourceInput<'Microsoft.ApiManagement/service/workspaces/diagnostics@2024-05-01'>.properties.backend?

@description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.')
param frontend resourceInput<'Microsoft.ApiManagement/service/workspaces/diagnostics@2024-05-01'>.properties.frontend?

@allowed([
  'Legacy'
  'None'
  'W3C'
])
@description('Conditional. Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.')
param httpCorrelationProtocol string = 'Legacy'

@description('Optional. Log the ClientIP.')
param logClientIp bool = false

@description('Conditional. Emit custom metrics via emit-metric policy. Required if using Application Insights.')
param metrics bool = false

@allowed([
  'Name'
  'Url'
])
@description('Optional. The format of the Operation Name for Application Insights telemetries.')
param operationNameFormat string = 'Name'

@description('Optional. Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.')
param samplingPercentage int = 100

@allowed([
  'error'
  'information'
  'verbose'
])
@description('Optional. The verbosity level applied to traces emitted by trace policies.')
param verbosity string = 'information'

// ============== //
// Resources      //
// ============== //

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName
  }
}

resource diagnostic 'Microsoft.ApiManagement/service/workspaces/diagnostics@2024-05-01' = {
  name: name
  parent: service::workspace
  properties: {
    loggerId: loggerResourceId
    alwaysLog: alwaysLog
    backend: backend
    frontend: frontend
    httpCorrelationProtocol: httpCorrelationProtocol
    logClientIp: logClientIp
    metrics: metrics
    operationNameFormat: operationNameFormat
    sampling: {
      percentage: samplingPercentage
      samplingType: 'fixed'
    }
    verbosity: verbosity
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the workspace diagnostic.')
output resourceId string = diagnostic.id

@description('The name of the workspace diagnostic.')
output name string = diagnostic.name

@description('The resource group the workspace diagnostic was deployed into.')
output resourceGroupName string = resourceGroup().name
