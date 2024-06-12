metadata name = 'API Management Service APIs Diagnostics.'
metadata description = 'This module deploys an API Management Service API Diagnostics.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent API Management service.')
param apiManagementServiceName string

@description('Required. The name of the parent API.')
param apiName string

@description('Required. The name of the logger.')
param loggerName string

@description('Optional. The name of the diagnostic.')
param diagnosticName string

@description('Optional. Specifies for what type of messages sampling settings should not apply.')
param alwaysLog string

@description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Backend.')
param backend object

@description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.')
param frontend object

@allowed([
  'Legacy'
  'None'
  'W3C'
])
@description('Optional. Sets correlation protocol to use for Application Insights diagnostics.')
param httpCorrelationProtocol string

@description('Optional. Log the ClientIP. Default is false.')
param logClientIp bool

@description('Conditional. Emit custom metrics via emit-metric policy. Required if using Application Insights.')
param metrics bool

@allowed([
  'Name'
  'URI'
])
@description('Optional. The format of the Operation Name for Application Insights telemetries. Default is Name.')
param operationNameFormat string

@description('Optional. Rate of sampling for fixed-rate sampling.')
param samplingPercentage int

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName

  resource api 'apis@2021-08-01' existing = {
    name: apiName
  }

  resource logger 'loggers@2021-08-01' existing = {
    name: loggerName
  }
}

@allowed([
  'error'
  'information'
  'verbose'
])
@description('Optional. The verbosity level applied to traces emitted by trace policies.')
param verbosity string

resource diagnostic 'Microsoft.ApiManagement/service/apis/diagnostics@2022-08-01' = {
  name: diagnosticName
  parent: service::api
  properties: {
    alwaysLog: !empty(alwaysLog) ? alwaysLog : 'allErrors'
    backend: backend
    frontend: frontend
    httpCorrelationProtocol: httpCorrelationProtocol
    logClientIp: logClientIp
    loggerId: service::logger.id
    metrics: metrics
    operationNameFormat: operationNameFormat
    sampling: {
      percentage: samplingPercentage
      samplingType: 'fixed'
    }
    verbosity: verbosity
  }
}

@description('The resource ID of the API diagnostic.')
output resourceId string = diagnostic.id

@description('The name of the API diagnostic.')
output name string = diagnostic.name

@description('The resource group the API diagnostic was deployed into.')
output resourceGroupName string = resourceGroup().name
