metadata name = 'API Management Service Loggers'
metadata description = 'This module deploys an API Management Service Logger.'
metadata owner = 'Azure/module-maintainers'

@description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
param name string

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Reference app insights instance.')
param appInsightsName string

@description('Optional. Whether records are buffered in the logger before publishing. Default is assumed to be true.')
param isBuffered bool = true

@description('Optional. Logger description.')
param loggerDescription string = 'Logger to Azure Application Insights'

@description('Required. The logger type for API Management.')
@allowed([
  'applicationInsights'
  'azureEventHub'
  'azureMonitor'
])
param loggerType string

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource logger 'Microsoft.ApiManagement/service/loggers@2021-08-01' = {
  name: name
  parent: service
  properties: {
    credentials: {
      instrumentationKey: appInsights.properties.InstrumentationKey
    }
    description: loggerDescription
    isBuffered: isBuffered
    loggerType: loggerType
    resourceId: appInsights.id
  }
}

@description('The name of the API management service logger.')
output name string = logger.name

@description('The resource ID of the API management service logger.')
output resourceId string = logger.id

@description('The resource group the API management service API was deployed to.')
output resourceGroupName string = resourceGroup().name
