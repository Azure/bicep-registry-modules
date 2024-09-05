targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------
@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string

@description('The location where the resources will be created. This needs to be the same region as the spoke.')
param location string = resourceGroup().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deplotment telemetry.')
param enableTelemetry bool

// Hub
@description('The resource ID of the existing hub virtual network.')
param hubVNetId string

// Spoke
@description('The name of the existing spoke virtual network.')
param spokeVNetName string

@description('The name of the existing spoke infrastructure subnet.')
param spokeInfraSubnetName string

// Telemetry
@description('Enable or disable the createion of Application Insights.')
param enableApplicationInsights bool

@description('Enable or disable Dapr application instrumentation using Application Insights. If enableApplicationInsights is false, this parameter is ignored.')
param enableDaprInstrumentation bool

@description('The resource id of an existing Azure Log Analytics Workspace.')
param logAnalyticsWorkspaceId string

@description('Optional, default value is true. If true, any resources that support AZ will be deployed in all three AZ. However if the selected region is not supporting AZ, this parameter needs to be set to false.')
param deployZoneRedundantResources bool = true

@description('The resource ID of the user-assigned managed identity for the Azure Container Registry to be able to pull images from it.')
param containerRegistryUserAssignedIdentityId string
// ------------------
// VARIABLES
// ------------------
var workProfileName = 'general-purpose'
var virtualNetworkLinks = concat(
  [
    {
      virtualNetworkResourceId: spokeVNet.id
      registrationEnabled: false
    }
  ],
  (!empty(hubVNetId))
    ? [
        {
          virtualNetworkResourceId: hubVNetId
          registrationEnabled: false
        }
      ]
    : []
)

// ------------------
// EXISTING RESOURCES
// ------------------

@description('The existing spoke virtual network.')
resource spokeVNet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: spokeVNetName

  resource infraSubnet 'subnets' existing = {
    name: spokeInfraSubnetName
  }
}

// ------------------
// RESOURCES
// ------------------

@description('User-configured naming rules')
module naming '../naming/naming.module.bicep' = {
  name: take('acaNamingDeployment-${deployment().name}', 64)
  params: {
    uniqueId: uniqueString(resourceGroup().id)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

@description('Azure Application Insights, the workload\' log & metric sink and APM tool')
module applicationInsights 'br/public:avm/res/insights/component:0.3.1' = if (enableApplicationInsights) {
  name: take('applicationInsights-${uniqueString(resourceGroup().id)}', 64)
  params: {
    name: naming.outputs.resourcesNames.applicationInsights
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    workspaceResourceId: logAnalyticsWorkspaceId
  }
}

@description('The Azure Container Apps (ACA) cluster.')
module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.5.1' = {
  name: take('acaenv-${uniqueString(resourceGroup().id)}', 64)
  params: {
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceId
    name: naming.outputs.resourcesNames.containerAppsEnvironment
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    internal: true
    managedIdentities: {
      userAssignedResourceIds: [
        containerRegistryUserAssignedIdentityId
      ]
    }
    daprAIInstrumentationKey: (enableDaprInstrumentation && enableApplicationInsights)
      ? applicationInsights.outputs.instrumentationKey
      : null
    infrastructureSubnetId: spokeVNet::infraSubnet.id
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: workProfileName
        workloadProfileType: 'D4'
      }
    ]
    zoneRedundant: deployZoneRedundantResources
  }
}

@description('The Private DNS zone containing the ACA load balancer IP')
module containerAppsEnvironmentPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.3.0' = {
  name: 'acaDnsZoneDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    name: containerAppsEnvironment.outputs.defaultDomain
    location: 'global'
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: virtualNetworkLinks
    a: [
      {
        name: '*'
        aRecords: [
          {
            ipv4Address: containerAppsEnvironment.outputs.staticIp
          }
        ]
      }
    ]
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the Container Apps environment.')
output containerAppsEnvironmentId string = containerAppsEnvironment.outputs.resourceId

@description('The name of the Container Apps environment.')
output containerAppsEnvironmentName string = containerAppsEnvironment.outputs.name

@description('The name of the Application Insights instance.')
output applicationInsightsName string = (enableApplicationInsights) ? applicationInsights.outputs.name : ''

@description('The name of the workload profiles provisioned in the Container Apps environment.')
output workloadProfileNames array = [workProfileName]
