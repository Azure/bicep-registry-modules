param name string
param location string
param logAnalyticsResourceName string
param virtualNetworkConfiguration object
param tags object
param publicNetworkAccess string
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
    vnetConfiguration: virtualNetworkConfiguration
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

output resourceId string = containerAppEnvironment.id
output location string = containerAppEnvironment.location
