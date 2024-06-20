metadata name = 'API Management Service Loggers'
metadata description = 'This module deploys an API Management Service Logger.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Resource Name.')
param name string

@description('Optional. Logger description.')
param loggerDescription string

@description('Optional. Whether records are buffered in the logger before publishing. Default is assumed to be true.')
param isBuffered bool

@description('Required. Logger type.')
@allowed([
  'applicationInsights'
  'azureEventHub'
  'azureMonitor'
])
param loggerType string

@description('Conditional. Required if loggerType = applicationInsights or azureEventHub. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource).')
param targetResourceId string

@description('Conditional. Required if loggerType = applicationInsights or azureEventHub. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger.')
param credentials object

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource loggers 'Microsoft.ApiManagement/service/loggers@2022-08-01' = {
  name: name
  parent: service
  properties: {
    credentials: credentials
    description: loggerDescription
    isBuffered: isBuffered
    loggerType: loggerType
    resourceId: targetResourceId
  }
}

@description('The resource ID of the logger.')
output resourceId string = loggers.id

@description('The name of the logger.')
output name string = loggers.name

@description('The resource group the named value was deployed into.')
output resourceGroupName string = resourceGroup().name
