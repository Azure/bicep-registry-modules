targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The location where the resources will be created.')
param location string = resourceGroup().location

@description('The name of the container registry.')
param containerRegistryName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deplotment telemetry.')
param enableTelemetry bool

@description('Optional. The resource ID of the Hub Virtual Network.')
param hubVNetId string = ''

@description('The resource ID of the VNet to which the private endpoint will be connected.')
param spokeVNetId string

@description('The name of the subnet in the VNet to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetName string

@description('Optional. The name of the private endpoint to be created for Azure Container Registry. If left empty, it defaults to "<resourceName>-pep')
param containerRegistryPrivateEndpointName string = 'acr-pep'

@description('The name of the user assigned identity to be created to pull image from Azure Container Registry.')
param containerRegistryUserAssignedIdentityName string

@description('Required. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string

@description('Optional, default value is true. If true, any resources that support AZ will be deployed in all three AZ. However if the selected region is not supporting AZ, this parameter needs to be set to false.')
param deployZoneRedundantResources bool = true

// ------------------
// VARIABLES
// ------------------

var acrDnsZoneName = 'privatelink.azurecr.io'
var spokeVNetIdTokens = split(spokeVNetId, '/')
var spokeSubscriptionId = spokeVNetIdTokens[2]
var spokeResourceGroupName = spokeVNetIdTokens[4]
var spokeVNetName = spokeVNetIdTokens[8]
var containerRegistryPullRoleGuid = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
var virtualNetworkLinks = concat(
  [
    {
      virtualNetworkResourceId: spokeVNetId
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
// RESOURCES
// ------------------
resource vnetSpoke 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  scope: resourceGroup(spokeSubscriptionId, spokeResourceGroupName)
  name: spokeVNetName
}

resource spokePrivateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  parent: vnetSpoke
  name: spokePrivateEndpointSubnetName
}

module acrUserAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: containerRegistryUserAssignedIdentityName
  params: {
    name: containerRegistryUserAssignedIdentityName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module acrdnszone 'br/public:avm/res/network/private-dns-zone:0.3.0' = {
  name: 'acrDnsZoneDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    name: acrDnsZoneName
    location: 'global'
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: virtualNetworkLinks
  }
}

module acr 'br/public:avm/res/container-registry/registry:0.3.0' = {
  name: 'containerRegistry-${uniqueString(resourceGroup().id)}'
  params: {
    name: containerRegistryName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    acrSku: 'Premium'
    publicNetworkAccess: 'Disabled'
    acrAdminUserEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: deployZoneRedundantResources ? 'Enabled' : 'Disabled'
    trustPolicyStatus: 'enabled'
    diagnosticSettings: [
      {
        name: 'acr-log-analytics'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        workspaceResourceId: diagnosticWorkspaceId
      }
    ]
    privateEndpoints: [
      {
        name: containerRegistryPrivateEndpointName
        privateDnsZoneResourceIds: [
          acrdnszone.outputs.resourceId
        ]
        subnetResourceId: spokePrivateEndpointSubnet.id
      }
    ]
    quarantinePolicyStatus: 'enabled'
    roleAssignments: [
      {
        principalId: acrUserAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: containerRegistryPullRoleGuid
      }
    ]
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the container registry.')
output containerRegistryId string = acr.outputs.resourceId

@description('The name of the container registry.')
output containerRegistryName string = acr.outputs.name

@description('The name of the container registry login server.')
output containerRegistryLoginServer string = acr.outputs.loginServer

@description('The resource ID of the user assigned managed identity for the container registry to be able to pull images from it.')
output containerRegistryUserAssignedIdentityId string = acrUserAssignedIdentity.outputs.resourceId
