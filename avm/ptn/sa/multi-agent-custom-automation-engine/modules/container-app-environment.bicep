param name string
param location string
param logAnalyticsResourceName string?
param tags object
param enablePrivateNetworking bool
param enableTelemetry bool
param enableMonitoring bool
param enableRedundancy bool
param subnetResourceId string?
param applicationInsightsConnectionString string?

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = if (enableMonitoring) {
  name: logAnalyticsResourceName!
}

module containerAppEnvironment 'br/public:avm/res/app/managed-environment:0.11.2' = {
  name: take('avm.res.app.managed-environment.${name}', 64)
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: 'Enabled'
    internal: false
    // WAF aligned configuration for Private Networking
    infrastructureSubnetResourceId: enablePrivateNetworking ? subnetResourceId : null
    // WAF aligned configuration for Monitoring
    appLogsConfiguration: enableMonitoring
      ? {
          destination: 'log-analytics'
          logAnalyticsConfiguration: {
            customerId: logAnalyticsWorkspace.properties.customerId
            sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
          }
        }
      : null
    appInsightsConnectionString: enableMonitoring ? applicationInsightsConnectionString : null
    // WAF aligned configuration for Redundancy
    zoneRedundant: enableRedundancy ? true : false
    infrastructureResourceGroupName: enableRedundancy ? '${resourceGroup().name}-infra' : null
    workloadProfiles: enableRedundancy
      ? [
          {
            maximumCount: 3
            minimumCount: 1
            name: 'CAW01'
            workloadProfileType: 'D4'
          }
        ]
      : [
          {
            name: 'Consumption'
            workloadProfileType: 'Consumption'
          }
        ]
  }
}

//TODO: FIX when deployed to vnet. This needs access to Azure to work
// resource aspireDashboard 'Microsoft.App/managedEnvironments/dotNetComponents@2024-10-02-preview' = if (aspireDashboardEnabled) {
//   parent: containerAppEnvironment
//   name: 'aspire-dashboard'
//   properties: {
//     componentType: 'AspireDashboard'
//   }
// }

output resourceId string = containerAppEnvironment.outputs.resourceId
output location string = containerAppEnvironment.outputs.location
