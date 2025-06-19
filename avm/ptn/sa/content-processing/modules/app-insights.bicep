// modules/app-insights-avm.bicep
metadata name = 'AVM Application Insights and Log Analytics Workspace Module'
// AVM-compliant Application Insights and Log Analytics Workspace deployment
// param applicationInsightsName string
// param logAnalyticsWorkspaceName string
// param location string
// param dataRetention int = 30
// param skuName string = 'PerGB2018'
// param kind string = 'web'
// param disableIpMasking bool = false
// param flowType string = 'Bluefield'

@description('The name of the Application Insights resource')
param appInsightsName string

@description('The name of the Log Analytics Workspace resource')
param logAnalyticsWorkspaceName string

@description('The location for the resources')
param location string

@description('SKU name for the Log Analytics Workspace resource')
param skuName string = 'PerGB2018'

@description('Retention period in days for the Application Insights resource')
param retentionInDays int = 30

@description('Kind of the Application Insights resource')
param kind string = 'web'

@description('Disable IP masking for the Application Insights resource')
param disableIpMasking bool = false

@description('Flow type for the Application Insights resource')
param flowType string = 'Bluefield'

@description('Application Type for the Application Insights resource')
param applicationType string = 'web'

@description('Disable local authentication for the Application Insights resource')
param disableLocalAuth bool = false

@description('Public network access for query in Application Insights resource')
param publicNetworkAccessForQuery string = 'Enabled'

@description('Request source for the Application Insights resource')
param requestSource string = 'rest'

@description('Tags to be applied to the resources')
param tags object = {}

param enableTelemetry bool = true

module avmLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  name: 'deploy_log_analytics_workspace'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    skuName: skuName
    dataRetention: retentionInDays
    diagnosticSettings: [{ useThisWorkspace: true }]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module avmApplicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'deploy_application_insights'
  params: {
    name: appInsightsName
    location: location
    workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId
    kind: kind
    applicationType: applicationType
    disableIpMasking: disableIpMasking
    disableLocalAuth: disableLocalAuth
    flowType: flowType
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    requestSource: requestSource
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output applicationInsightsId string = avmApplicationInsights.outputs.resourceId
output logAnalyticsWorkspaceId string = avmLogAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
output logAnalyticsWorkspaceResourceId string = avmLogAnalyticsWorkspace.outputs.resourceId
output logAnalyticsWorkspaceName string = avmLogAnalyticsWorkspace.outputs.name
@secure()
output logAnalyticsWorkspacePrimaryKey string = avmLogAnalyticsWorkspace.outputs.primarySharedKey
