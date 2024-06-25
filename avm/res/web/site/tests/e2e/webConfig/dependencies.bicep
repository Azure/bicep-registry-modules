@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the api management instance to create.')
param apiManagementName string

@description('Required. The name of the Application Insights instance to create.')
param applicationInsightsName string

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

resource serverFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {}
}

module apiManagement 'br/public:avm/res/api-management/service:0.2.0' = {
  name: apiManagementName
  params: {
    name: apiManagementName
    publisherEmail: 'noreply@microsoft.com'
    publisherName: 'n/a'
    location: location
    sku: 'Consumption'
    skuCount: 0
    customProperties: {}
    zones: []
    apiDiagnostics: [
      {
        apiName: 'todo-api'
        alwaysLog: 'allErrors'
        backend: {
          request: {
            body: {
              bytes: 1024
            }
          }
          response: {
            body: {
              bytes: 1024
            }
          }
        }
        frontend: {
          request: {
            body: {
              bytes: 1024
            }
          }
          response: {
            body: {
              bytes: 1024
            }
          }
        }
        httpCorrelationProtocol: 'W3C'
        logClientIp: true
        loggerName: 'app-insights-logger'
        metrics: true
        verbosity: 'verbose'
        name: 'applicationinsights'
      }
    ]
    loggers: [
      {
        name: 'app-insights-logger'
        credentials: {
          instrumentationKey: applicationInsights.properties.InstrumentationKey
        }
        loggerDescription: 'Logger to Azure Application Insights'
        isBuffered: false
        loggerType: 'applicationInsights'
        targetResourceId: applicationInsights.id
      }
    ]
    apis: [
      {
        name: 'todo-api'
        path: 'todo'
        displayName: 'Simple Todo API'
        apiDescription: 'This is a simple Todo API'
        serviceUrl: 'https://www.baidu.com'
        subscriptionRequired: false
        protocols: ['https']
        type: 'http'
        value: ''
        policies: [
          {
            value: ''
            format: 'rawxml'
          }
        ]
      }
    ]
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: ''
  properties: {}
}

@description('The resource ID of the created api management.')
output apiManagementId string = apiManagement.outputs.resourceId

@description('The resource ID of the created application insights.')
output applicationInsigtsId string = serverFarm.id

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id
