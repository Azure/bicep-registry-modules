param name string
param location string
param logAnalyticsResourceName string
param tags object
param publicNetworkAccess string
param isInternal bool
param zoneRedundant bool
param aspireDashboardEnabled bool
param virtualNetworkEnabled bool
param enableTelemetry bool
param virtualNetworkResourceId string
param virtualNetworkContainersResourceId string
param virtualNetworkPrivateEndpointSubnetResourceId string

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
    vnetConfiguration: (virtualNetworkEnabled)
      ? {
          internal: isInternal
          infrastructureSubnetId: virtualNetworkContainersResourceId
        }
      : {}
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
// ========== DNS zone for Container App Environment ========== //
module privateDnsZonesContainerAppEnvironment 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (virtualNetworkEnabled) {
  name: 'network-dns-zone-containers'
  params: {
    //name: 'privatelink.${toLower(replace(containerAppEnvironment.outputs.location,' ',''))}.azurecontainerapps.io'
    name: 'privatelink.${toLower(replace(location,' ',''))}.azurecontainerapps.io'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetworkResourceId }]
    tags: tags
  }
}

var privateEndpointContainerAppEnvironmentService = 'managedEnvironments'
module privateEndpointContainerAppEnvironment 'br/public:avm/res/network/private-endpoint:0.10.1' = if (virtualNetworkEnabled) {
  name: 'avm.ptn.sa.macae.network-pep-container-app-environment'
  params: {
    name: 'pep-container-app-environment'
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        { privateDnsZoneResourceId: privateDnsZonesContainerAppEnvironment.outputs.resourceId }
      ]
    }
    privateLinkServiceConnections: [
      {
        name: '${last(split(containerAppEnvironment.id, '/'))}-${privateEndpointContainerAppEnvironmentService}-0'
        properties: {
          privateLinkServiceId: containerAppEnvironment.id
          groupIds: [
            privateEndpointContainerAppEnvironmentService
          ]
        }
      }
    ]
    subnetResourceId: virtualNetworkPrivateEndpointSubnetResourceId
    enableTelemetry: enableTelemetry
    location: location
    tags: tags
  }
}

output resourceId string = containerAppEnvironment.id
output location string = containerAppEnvironment.location
