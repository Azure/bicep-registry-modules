@description('The name of Log analytics Workspace')
param name string

@description('Location for the Resource.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {
  app: 'Content Processing Solution Accelerator'
  location: resourceGroup().location
}

@description('Optional. Enable Private Networking for Log Analytics Workspace.')
param enablePrivateNetworking bool = false

@description('Optional. Enable Redundancy for Log Analytics Workspace.')
param enableRedundancy bool = false

@description('Optional. The replica location for Log Analytics Workspace, if redundancy is enabled.')
param replicaLocation string = ''

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.15.0' = {
  name: take('avm.res.operational-insights.workspace.${name}', 64)
  params: {
    name: name
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 365
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    diagnosticSettings: [{ useThisWorkspace: true }]
    // WAF aligned configuration for Redundancy
    dailyQuotaGb: enableRedundancy ? '150' : null //WAF recommendation: 150 GB per day is a good starting point for most workloads
    replication: enableRedundancy
      ? {
          enabled: true
          location: replicaLocation
        }
      : null
    // WAF aligned configuration for Private Networking
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    dataSources: enablePrivateNetworking
      ? [
          {
            tags: tags
            eventLogName: 'Application'
            eventTypes: [
              {
                eventType: 'Error'
              }
              {
                eventType: 'Warning'
              }
              {
                eventType: 'Information'
              }
            ]
            kind: 'WindowsEvent'
            name: 'applicationEvent'
          }
          {
            counterName: '% Processor Time'
            instanceName: '*'
            intervalSeconds: 60
            kind: 'WindowsPerformanceCounter'
            name: 'windowsPerfCounter1'
            objectName: 'Processor'
          }
          {
            kind: 'IISLogs'
            name: 'sampleIISLog1'
            state: 'OnPremiseEnabled'
          }
        ]
      : null
  }
}

output resourceId string = logAnalyticsWorkspace.outputs.resourceId
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
@secure()
output primarySharedKey string = logAnalyticsWorkspace.outputs.primarySharedKey
output location string = logAnalyticsWorkspace.outputs.location
output name string = logAnalyticsWorkspace.outputs.name
