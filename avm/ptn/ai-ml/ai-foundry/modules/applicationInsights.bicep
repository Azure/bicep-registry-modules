@description('Name of the Application Insights resource.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Resource ID of an existing Application Insights resource. If provided, the existing resource will be used instead of creating a new one.')
param existingApplicationInsightsResourceId string = ''

@description('Optional. Resource ID of the Log Analytics workspace to connect Application Insights to.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Application type for Application Insights.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Optional. Retention period in days for Application Insights data.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 90

var nameFormatted = take(toLower(name), 260) // Application Insights names can be up to 260 characters

var useExistingAppInsights = !empty(existingApplicationInsightsResourceId)

// Reference existing Application Insights if provided
resource existingAppInsights 'Microsoft.Insights/components@2020-02-02' existing = if (useExistingAppInsights) {
  name: last(split(existingApplicationInsightsResourceId, '/'))
  scope: resourceGroup(
    split(existingApplicationInsightsResourceId, '/')[2],
    split(existingApplicationInsightsResourceId, '/')[4]
  )
}

// Create new Application Insights if not using existing
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (!useExistingAppInsights) {
  name: take('${nameFormatted}-appinsights-deployment', 64)
  params: {
    name: nameFormatted
    location: location
    kind: applicationType
    workspaceResourceId: logAnalyticsWorkspaceResourceId
    retentionInDays: retentionInDays
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// Outputs
output applicationInsightsResourceId string = useExistingAppInsights
  ? existingApplicationInsightsResourceId
  : applicationInsights.outputs.resourceId
output applicationInsightsName string = useExistingAppInsights
  ? existingAppInsights.name
  : applicationInsights.outputs.name
output applicationInsightsInstrumentationKey string = useExistingAppInsights
  ? existingAppInsights.properties.InstrumentationKey
  : applicationInsights.outputs.instrumentationKey
output applicationInsightsConnectionString string = useExistingAppInsights
  ? existingAppInsights.properties.ConnectionString
  : applicationInsights.outputs.connectionString
