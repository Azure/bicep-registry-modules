// REMOVE_BEFORE_UPSTREAM_MERGE [psl-container-migration]:
// This local wrapper around the public AVM Log Analytics workspace module exists to
// re-expose the secure `primarySharedKey` output via this module so that the parent
// (`main.bicep`) can read it without invoking `listKeys()` on an outer-scope `existing`
// resource (which fails ARM template validation when the workspace does not yet exist).
// Pattern mirrors `psl-conprov2` (commit cd0ba612a) — see content-processing/modules/log-analytics-workspace.bicep.

@description('Required. The name of Log Analytics Workspace.')
param name string

@description('Optional. Location for the resource.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Enable Private Networking for Log Analytics Workspace.')
param enablePrivateNetworking bool = false

@description('Optional. Enable Redundancy for Log Analytics Workspace.')
param enableRedundancy bool = false

@description('Optional. The replica location for Log Analytics Workspace, if redundancy is enabled.')
param replicaLocation string = ''

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.12.0' = {
  name: take('avm.res.operational-insights.workspace.${name}', 64)
  params: {
    name: name
    location: location
    skuName: 'PerGB2018'
    dataRetention: 30
    diagnosticSettings: [{ useThisWorkspace: true }]
    tags: tags
    enableTelemetry: enableTelemetry
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    dailyQuotaGb: enableRedundancy ? 10 : null
    replication: enableRedundancy && !empty(replicaLocation)
      ? {
          enabled: true
          location: replicaLocation
        }
      : null
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

@description('The resource ID of the deployed Log Analytics workspace.')
output resourceId string = logAnalyticsWorkspace.outputs.resourceId

@description('The customer (workspace) ID of the deployed Log Analytics workspace.')
output customerId string = logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId

@description('The name of the deployed Log Analytics workspace.')
output name string = logAnalyticsWorkspace.outputs.name

@description('The location of the deployed Log Analytics workspace.')
output location string = logAnalyticsWorkspace.outputs.location

@secure()
@description('The primary shared key of the deployed Log Analytics workspace.')
output primarySharedKey string = logAnalyticsWorkspace.outputs.primarySharedKey
