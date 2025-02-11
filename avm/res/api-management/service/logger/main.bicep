metadata name = 'API Management Service Loggers'
metadata description = 'This module deploys an API Management Service Logger.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Resource Name.')
param name string

@sys.description('Optional. Logger description.')
param description string = ''

@sys.description('Optional. Whether records are buffered in the logger before publishing.')
param isBuffered bool = true

@sys.description('Required. Logger type.')
@allowed([
  'applicationInsights'
  'azureEventHub'
  'azureMonitor'
])
param type string

@sys.description('Conditional. Required if loggerType = applicationInsights or azureEventHub. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource).')
param targetResourceId string

@secure()
@sys.description('Conditional. Required if loggerType = applicationInsights or azureEventHub. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger.')
param credentials object

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource loggers 'Microsoft.ApiManagement/service/loggers@2022-08-01' = {
  name: name
  parent: service
  properties: {
    credentials: credentials
    description: description
    isBuffered: isBuffered
    loggerType: type
    resourceId: targetResourceId
  }
}

@sys.description('The resource ID of the logger.')
output resourceId string = loggers.id

@sys.description('The name of the logger.')
output name string = loggers.name

@sys.description('The resource group the named value was deployed into.')
output resourceGroupName string = resourceGroup().name
