@description('Name of the Application Insights component.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Resource ID of the Log Analytics workspace to link the Application Insights component.')
param workspaceResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Application type of the Application Insights component.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Optional. Kind of the Application Insights component.')
param kind string = 'web'

// Deploy the AVM Application Insights module
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: take('${name}-app-insights-component-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    workspaceResourceId: workspaceResourceId
    applicationType: applicationType
    kind: kind
    enableTelemetry: enableTelemetry
  }
}

output resourceId string = applicationInsights.outputs.resourceId
output name string = applicationInsights.outputs.name
output instrumentationKey string = applicationInsights.outputs.instrumentationKey
output connectionString string = applicationInsights.outputs.connectionString
