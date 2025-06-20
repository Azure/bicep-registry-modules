@description('Required. Name of the Container App Environment.')
param name string
@description('Required. Location of the Container App Environment.')
param location string
@description('Required. Resource name of the log analytics workspace to send logs.')
param logAnalyticsResourceName string?
@description('Required. Tags to set for the Container App Environment.')
param tags object
@description('Required. If private networking should be enabled.')
param enablePrivateNetworking bool
@description('Required. If AVM telemetry should be enabled.')
param enableTelemetry bool
@description('Required. If monitoring should be enabled.')
param enableMonitoring bool
@description('Required. If redundancy should be enabled.')
param enableRedundancy bool
@description('Required. Resource Id of the subnet to deploy the Container App Environment.')
param subnetResourceId string?
@description('Required. Connection String of the Application Insights resource to send logs to.')
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
            minimumCount: 3
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

output resourceId string = containerAppEnvironment.outputs.resourceId
output location string = containerAppEnvironment.outputs.location
