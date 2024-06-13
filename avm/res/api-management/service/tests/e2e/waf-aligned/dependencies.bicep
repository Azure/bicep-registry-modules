@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'applicationInsights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    // todo: change to workspace based LAW
  }
}

@description('The Application Insights Instrumentation Key')
output appInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('The Application Insights ResourceId')
output appInsightsResourceId string = applicationInsights.id
