param name string
param location string
param logAnalyticsResourceName string
param tags object
param publicNetworkAccess string
param vnetConfiguration object
param zoneRedundant bool
param aspireDashboardEnabled bool

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsResourceName
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2024-08-02-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    //daprAIConnectionString: appInsights.properties.ConnectionString
    //daprAIConnectionString: applicationInsights.outputs.connectionString
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        #disable-next-line use-secure-value-for-secure-inputs
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
    workloadProfiles: [
      //THIS IS REQUIRED TO ADD PRIVATE ENDPOINTS
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    publicNetworkAccess: publicNetworkAccess
    vnetConfiguration: vnetConfiguration
    zoneRedundant: zoneRedundant
  }
}

// TODO: FIX when deployed to vnet. This needs access to Azure to work
resource aspireDashboard 'Microsoft.App/managedEnvironments/dotNetComponents@2024-10-02-preview' = if (aspireDashboardEnabled) {
  parent: containerAppEnvironment
  name: 'aspire-dashboard'
  properties: {
    componentType: 'AspireDashboard'
  }
}

// module containerAppEnvironment 'br/public:avm/res/app/managed-environment:0.11.0' = {
//   name: 'container-app-environment'
//   params: {
//     name: '${solutionPrefix}cenv'
//     location: solutionLocation
//     tags: tags
//     enableTelemetry: enableTelemetry
//     //daprAIConnectionString: applicationInsights.outputs.connectionString //Troubleshoot: ContainerAppsConfiguration.DaprAIConnectionString is invalid.  DaprAIConnectionString can not be set when AppInsightsConfiguration has been set, please set DaprAIConnectionString to null. (Code:InvalidRequestParameterWithDetails
//     appLogsConfiguration: {
//       destination: 'log-analytics'
//       logAnalyticsConfiguration: {
//         customerId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
//         sharedKey: listKeys(
//           '${resourceGroup().id}/providers/Microsoft.OperationalInsights/workspaces/${logAnalyticsWorkspaceName}',
//           '2023-09-01'
//         ).primarySharedKey
//       }
//     }
//     appInsightsConnectionString: applicationInsights.outputs.connectionString
//     publicNetworkAccess: virtualNetworkEnabled ? 'Disabled' : 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
//     zoneRedundant: true //TODO: make it zone redundant for waf aligned
//     infrastructureSubnetResourceId: virtualNetworkEnabled
//       ? virtualNetwork.outputs.subnetResourceIds[1]
//       : null
//     internal: false
//   }
// }

output resourceId string = containerAppEnvironment.id
output location string = containerAppEnvironment.location
