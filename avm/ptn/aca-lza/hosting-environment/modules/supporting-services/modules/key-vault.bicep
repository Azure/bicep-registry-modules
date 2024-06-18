targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The location where the resources will be created.')
param location string = resourceGroup().location

@description('The name of the Key Vault.')
param keyVaultName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('The resource ID of the Hub Virtual Network.')
param hubVNetId string

@description('The resource ID of the VNet to which the private endpoint will be connected.')
param spokeVNetId string

@description('The name of the subnet in the VNet to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetName string

@description('Optional.The name of the private endpoint to be created for Key Vault.')
param keyVaultPrivateEndpointName string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
param diagnosticWorkspaceId string = ''

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'AuditEvent'
  'AzurePolicyEvaluationDetails'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

// ------------------
// VARIABLES
// ------------------

var privateDnsZoneNames = 'privatelink.vaultcore.azure.net'
var spokeVNetIdTokens = split(spokeVNetId, '/')
var spokeSubscriptionId = spokeVNetIdTokens[2]
var spokeResourceGroupName = spokeVNetIdTokens[4]
var spokeVNetName = spokeVNetIdTokens[8]

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

module vaultdnszone 'br/public:avm/res/network/private-dns-zone:0.3.0' = {
  name: 'privateDnsZoneDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    name: privateDnsZoneNames
    location: location
    tags: tags
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: spokeVNetId
        registrationEnabled: true
      }
      (!empty(hubVNetId))
        ? {
            virtualNetworkResourceId: hubVNetId
            registrationEnabled: true
          }
        : {}
    ]
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.6.1' = {
  name: 'vault-${uniqueString(resourceGroup().id)}'
  params: {
    name: keyVaultName
    location: location
    tags: tags
    sku: 'standard'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    enableSoftDelete: false
    softDeleteRetentionInDays: 7
    enablePurgeProtection: null
    publicNetworkAccess: 'Disabled'
    enableRbacAuthorization: true
    enableVaultForDeployment: true
    privateEndpoints: [
      {
        name: keyVaultPrivateEndpointName
        privateDnsZoneResourceIds: [
          vaultdnszone.outputs.resourceId
        ]
        subnetResourceId: spokePrivateEndpointSubnet.id
      }
    ]
    diagnosticSettings: [
      {
        name: diagnosticSettingsName
        workspaceResourceId: diagnosticWorkspaceId
        logCategoriesAndGroups: diagnosticLogCategoriesToEnable
        metricCategories: diagnosticMetricsToEnable
      }
    ]
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the key vault.')
output keyVaultId string = keyvault.outputs.resourceId

@description('The name of the key vault.')
output keyVaultName string = keyvault.outputs.name
