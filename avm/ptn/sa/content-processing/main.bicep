// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Content Processing Solution Accelerator'
metadata description = 'Bicep template to deploy the Content Processing Solution Accelerator with AVM compliance.'

// ========== get up parameters from parameter file ========== //
@description('Required. Name of the environment to deploy the solution into.')
param environmentName string
@description('Optional. Location for all Resources.')
param location string = resourceGroup().location
@description('Required. Location for the content understanding service: WestUS | SwedenCentral | AustraliaEast.')
param contentUnderstandingLocation string
@description('Optional. Type of GPT deployment to use: Standard | GlobalStandard.')
param deploymentType string = 'GlobalStandard'
@description('Optional. Name of the GPT model to deploy: gpt-4o-mini | gpt-4o | gpt-4.')
param gptModelName string = 'gpt-4o'
@minLength(1)
@description('Optional. Version of the GPT model to deploy:.')
@allowed([
  '2024-08-06'
])
param gptModelVersion string = '2024-08-06'
@minValue(10)
@description('Required. Capacity of the GPT deployment: (minimum 10).')
param gptDeploymentCapacity int
@description('Optional. Location used for Azure Cosmos DB, Azure Container App deployment.')
param secondaryLocation string = 'EastUs2'
@description('Optional. The public container image endpoint.')
param publicContainerImageEndpoint string = 'cpscontainerreg.azurecr.io'
@description('Optional. The resource group location.')
param resourceGroupLocation string = resourceGroup().location
@description('Optional. The resource name format string.')
param resourceNameFormatString string = '{0}avm-cps'
@description('Optional. Enable WAF for the deployment.')
param enablePrivateNetworking bool = true
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true
//@description('Resource naming abbreviations')
//param namingAbbrs object
@description('Optional. Tags to be applied to the resources.')
param tags object = {
  app: 'Content Processing Solution Accelerator'
  location: resourceGroup().location
}
@description('Optional. Set to true to use local build for container app images, otherwise use container registry images.')
param useLocalBuild bool = false

@description('Optional. Enable scaling for the container apps. Defaults to false.')
param enableScaling bool = false

// ========== Solution Prefix Variable ========== //
var solutionPrefix = 'cps-${padLeft(take(toLower(uniqueString(subscription().id, environmentName, resourceGroup().location)), 12), 12, '0')}'
// ========== Resource Naming Abbreviations ========== //
@description('Resource naming abbreviations.')
var namingAbbrs = loadJsonContent('abbreviations.json')

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

// ========== AVM Telemetry ========== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  //name: '46d3xbcp.ptn.sa-contentprocessing-${replace(replace(deployment().name, ' ', '-'), '_', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  name: take(
    '46d3xbcp.ptn.sa-contentprocessing.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

// ============== //
// WAF Resources      //
// ============== //

// ========== WAF Aligned ========== //
// When default_deployment_param.enable_waf is true, the WAF related module(virtual network, private network endpoints) will be deployed
//

// ========== Network Security Group definition ========== //
module avmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, '${namingAbbrs.networking.networkSecurityGroup}backend')
  params: {
    name: '${namingAbbrs.networking.networkSecurityGroup}${solutionPrefix}-backend'
    location: resourceGroupLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [
      { workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }
    ]
    securityRules: [
      {
        name: 'Deny-hop-outbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 200
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: ['3389', '22']
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Securing a custom VNET in Azure Container Apps with Network Security Groups
// https://learn.microsoft.com/en-us/azure/container-apps/firewall-integration?tabs=workload-profiles
module avmNetworkSecurityGroup_Containers 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, '${namingAbbrs.networking.networkSecurityGroup}containers')
  params: {
    name: '${namingAbbrs.networking.networkSecurityGroup}${solutionPrefix}-containers'
    location: resourceGroupLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [
      { workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }
    ]
    securityRules: [
      //Inbound Rules
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationPortRanges: ['443', '80']
          destinationAddressPrefixes: ['10.0.2.0/24']
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 102
          protocol: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationPortRanges: ['30000-32767']
          destinationAddressPrefixes: ['10.0.2.0/24']
        }
      }
      {
        name: 'AllowSideCarsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 103
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefixes: ['10.0.2.0/24']
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      //Outbound Rules
      {
        name: 'AllowOutboundToAzureServices'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 200
          protocol: '*'
          sourceAddressPrefixes: ['10.0.2.0/24']
          sourcePortRange: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'deny-hop-outbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 100
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: ['3389', '22']
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

module avmNetworkSecurityGroup_Bastion 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, '${namingAbbrs.networking.networkSecurityGroup}bastion')
  params: {
    name: '${namingAbbrs.networking.networkSecurityGroup}${solutionPrefix}-bastion'
    location: resourceGroupLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [
      { workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }
    ]
    securityRules: [
      {
        name: 'Deny-hop-outbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 200
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: ['3389', '22']
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

module avmNetworkSecurityGroup_Admin 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, '${namingAbbrs.networking.networkSecurityGroup}admin')
  params: {
    name: '${namingAbbrs.networking.networkSecurityGroup}${solutionPrefix}-admin'
    location: resourceGroupLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [
      { workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }
    ]
    securityRules: [
      {
        name: 'Deny-hop-outbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 200
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: ['3389', '22']
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// ========== Virtual Network definition ========== //
// Azure Resources(Backend) : 10.0.0.0/24 - 10.0.0.255
// Containers :  10.0.2.0/24 - 10.0.2.255
// Admin : 10.0.1.0/27 - 10.0.1.31
// Bastion Hosts : 10.0.1.32/27 - 10.0.1.63
// VM(s) :

module avmVirtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, namingAbbrs.networking.virtualNetwork)
  params: {
    // name: '${namingAbbrs.networking.virtualNetwork}${solutionPrefix}'
    name: 'vnet-cps'
    location: resourceGroupLocation
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/8']
    diagnosticSettings: [
      { workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }
    ]
    subnets: [
      {
        name: 'snet-backend'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupResourceId: avmNetworkSecurityGroup.outputs.resourceId
      }
      {
        name: 'snet-containers'
        addressPrefix: '10.0.2.0/24'
        networkSecurityGroupResourceId: avmNetworkSecurityGroup_Containers.outputs.resourceId
        delegation: 'Microsoft.App/environments'
        // privateEndpointNetworkPolicies: 'Disabled'
        // privateLinkServiceNetworkPolicies: 'Enabled'
      }
      {
        name: 'snet-admin'
        addressPrefix: '10.0.1.0/27'
        networkSecurityGroupResourceId: avmNetworkSecurityGroup_Admin.outputs.resourceId
      }
      {
        name: 'snet-bastion'
        addressPrefix: '10.0.1.32/27'
        networkSecurityGroupResourceId: avmNetworkSecurityGroup_Bastion.outputs.resourceId
      }
    ]
  }
}

// ========== Private DNS Zones ========== //

// Private DNS Zones for AI Services
var openAiPrivateDnsZones = {
  'privatelink.cognitiveservices.azure.com': 'account'
  'privatelink.openai.azure.com': 'account'
  'privatelink.services.ai.azure.com': 'account'
  'privatelink.contentunderstanding.ai.azure.com': 'account'
}

@batchSize(1)
module avmPrivateDnsZoneAiServices 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in items(openAiPrivateDnsZones): if (enablePrivateNetworking) {
    name: zone.key
    params: {
      name: zone.key
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
    }
  }
]

// Private DNS Zone for AI foundry Storage Blob
var storagePrivateDnsZones = {
  'privatelink.blob.${environment().suffixes.storage}': 'blob'
  'privatelink.queue.${environment().suffixes.storage}': 'queue'
  'privatelink.file.${environment().suffixes.storage}': 'file'
}

@batchSize(1)
module avmPrivateDnsZoneStorages 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in items(storagePrivateDnsZones): if (enablePrivateNetworking) {
    name: 'private-dns-zone-storage-${zone.value}'
    params: {
      name: zone.key
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
    }
  }
]

// Private DNS Zone for AI Foundry Workspace
var aiHubPrivateDnsZones = {
  'privatelink.api.azureml.ms': 'amlworkspace'
  'privatelink.notebooks.azure.net': 'amlworkspace'
}

@batchSize(1)
module avmPrivateDnsZoneAiFoundryWorkspace 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for (zone, i) in items(aiHubPrivateDnsZones): if (enablePrivateNetworking) {
    name: 'private-dns-zone-aifoundry-workspace-${zone.value}-${i}'
    params: {
      name: zone.key
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
    }
  }
]

// Private DNS Zone for Azure Cosmos DB
var cosmosdbMongoPrivateDnsZones = {
  'privatelink.mongo.cosmos.azure.com': 'cosmosdb'
}
module avmPrivateDnsZoneCosmosMongoDB 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (enablePrivateNetworking) {
  name: 'private-dns-zone-cosmos-mongo'
  params: {
    name: items(cosmosdbMongoPrivateDnsZones)[0].key
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
  }
}

// Private DNS Zone for Application Storage Account
var appStoragePrivateDnsZones = {
  'privatelink.blob.${environment().suffixes.storage}': 'blob'
  'privatelink.queue.${environment().suffixes.storage}': 'queue'
}

module avmPrivateDnsZonesAppStorage 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for (zone, i) in items(appStoragePrivateDnsZones): if (enablePrivateNetworking) {
    name: 'private-dns-zone-app-storage-${zone.value}-${i}'
    params: {
      name: zone.key
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
    }
  }
]

// Private DNS Zone for App Configuration
var appConfigPrivateDnsZones = {
  'privatelink.azconfig.io': 'appconfig'
}

module avmPrivateDnsZoneAppConfig 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (enablePrivateNetworking) {
  name: 'private-dns-zone-app-config'
  params: {
    name: items(appConfigPrivateDnsZones)[0].key
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
  }
}

// private DNS Zone for Key Vault
var keyVaultPrivateDnsZones = {
  'privatelink.vaultcore.azure.net': 'keyvault'
}

module avmPrivateDnsZoneKeyVault 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (enablePrivateNetworking) {
  name: 'private-dns-zone-key-vault'
  params: {
    name: items(keyVaultPrivateDnsZones)[0].key
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
  }
}

// private DNS Zone for Container Registry
var containerRegistryPrivateDnsZones = {
  'privatelink.azurecr.io': 'containerregistry'
}

module avmPrivateDnsZoneContainerRegistry 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (enablePrivateNetworking) {
  name: 'private-dns-zone-container-registry'
  params: {
    name: items(containerRegistryPrivateDnsZones)[0].key
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
  }
}

// ============== //
// Resources      //
// ============== //

// ========== Application insights ========== //
// module avmAppInsightsLogAnalyticsWorkspace './modules/app-insights.bicep' = {
//   //name: format(deployment_param.resource_name_format_string, abbrs.managementGovernance.logAnalyticsWorkspace)
//   params: {
//     appInsightsName: '${namingAbbrs.managementGovernance.applicationInsights}${solutionPrefix}'
//     location: resourceGroupLocation
//     //diagnosticSettings: [{ useThisWorkspace: true }]
//     skuName: 'PerGB2018'
//     applicationType: 'web'
//     disableIpMasking: false
//     disableLocalAuth: true
//     flowType: 'Bluefield'
//     kind: 'web'
//     logAnalyticsWorkspaceName: '${namingAbbrs.managementGovernance.logAnalyticsWorkspace}${solutionPrefix}'
//     publicNetworkAccessForQuery: 'Enabled'
//     requestSource: 'rest'
//     retentionInDays: 30
//     enableTelemetry: enableTelemetry
//     tags: tags
//   }
// }

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  name: 'deploy_log_analytics_workspace'
  params: {
    name: '${namingAbbrs.managementGovernance.logAnalyticsWorkspace}${solutionPrefix}'
    location: location
    skuName: 'PerGB2018'
    dataRetention: 30
    diagnosticSettings: [{ useThisWorkspace: true }]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'deploy_application_insights'
  params: {
    name: '${namingAbbrs.managementGovernance.applicationInsights}${solutionPrefix}'
    location: location
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    tags: tags
    enableTelemetry: enableTelemetry
    disableLocalAuth: true
  }
}

// ========== Managed Identity ========== //
module avmManagedIdentity './modules/managed-identity.bicep' = {
  //name: format(resourceNameFormatString, namingAbbrs.security.managedIdentity)
  params: {
    name: '${namingAbbrs.security.managedIdentity}${solutionPrefix}'
    location: resourceGroupLocation
    tags: tags
  }
}

// Assign Owner role to the managed identity in the resource group
module avmRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-owner')
  params: {
    resourceId: avmManagedIdentity.outputs.resourceId
    principalId: avmManagedIdentity.outputs.principalId
    roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
  scope: resourceGroup(resourceGroup().name)
}

// ========== Key Vault Module ========== //
module avmKeyVault './modules/key-vault.bicep' = {
  //name: format(resourceNameFormatString, namingAbbrs.security.keyVault)
  params: {
    keyvaultName: '${namingAbbrs.security.keyVault}${solutionPrefix}'
    location: resourceGroupLocation
    tags: tags
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Key Vault Administrator'
      }
    ]
    enablePurgeProtection: false
    enableSoftDelete: true
    keyvaultsku: 'standard'
    enableRbacAuthorization: true
    createMode: 'default'
    enableTelemetry: enableTelemetry
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    softDeleteRetentionInDays: 7
    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    // privateEndpoints omitted for now, as not in strongly-typed params
  }
  scope: resourceGroup(resourceGroup().name)
}

module avmKeyVault_RoleAssignment_appConfig 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-keyvault-app-config')
  params: {
    resourceId: avmKeyVault.outputs.resourceId
    principalId: avmAppConfig.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7' // 'Key Vault Secrets User'
    roleName: 'Key Vault Secret User'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmContainerRegistry 'modules/container-registry.bicep' = {
  //name: format(deployment_param.resource_name_format_string, abbrs.containers.containerRegistry)
  params: {
    acrName: '${namingAbbrs.containers.containerRegistry}${replace(solutionPrefix, '-', '')}'
    location: resourceGroupLocation
    acrSku: 'Standard'
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Disabled'
    tags: tags
  }
}

// // ========== Storage Account ========== //
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: format(resourceNameFormatString, namingAbbrs.storage.storageAccount)
  params: {
    name: '${namingAbbrs.storage.storageAccount}${replace(solutionPrefix, '-', '')}'
    location: resourceGroupLocation
    //skuName: 'Standard_GRS'
    //kind: 'StorageV2'
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
    }
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    tags: tags

    //<======================= WAF related parameters
    allowBlobPublicAccess: (false) // Disable public access when WAF is enabled
    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'storage-private-endpoint-blob'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-blob'
                  privateDnsZoneResourceId: avmPrivateDnsZoneStorages[0].outputs.resourceId
                  // bicep doesn't recognize collection - avmPrivateDnsZoneStorages
                  // privateDnsZoneResourceId : filter(avmPrivateDnsZoneStorages, zone => contains(zone.outputs.name, 'blob'))[0].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
            service: 'blob'
          }
          {
            name: 'storage-private-endpoint-queue'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-queue'
                  privateDnsZoneResourceId: avmPrivateDnsZoneStorages[2].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
            service: 'queue'
          }
        ]
      : []

    // privateEndpoints: (deployment_param.enable_waf)
    //   ? map(items(appStoragePrivateDnsZones), zone => {
    //       name: 'storage-${zone.value}'
    //       privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //       service: zone.key
    //       privateDnsZoneGroup: {
    //         privateDnsZoneGroupConfigs: [
    //           {
    //             name: 'storage-dns-zone-group-${zone.value}'
    //             privateDnsZoneResourceId: zone.value
    //           }
    //         ]
    //       }
    //       subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //     })
    //   : []
  }
}

module avmStorageAccount_RoleAssignment_avmContainerApp_blob 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-storage-data-contributor-container-app')
  params: {
    resourceId: avmStorageAccount.outputs.resourceId
    principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
    roleName: 'Storage Blob Data Contributor'
    roleDefinitionId: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmStorageAccount_RoleAssignment_avmContainerApp_API_blob 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-storage-data-contributor-container-api')
  params: {
    resourceId: avmStorageAccount.outputs.resourceId
    principalId: avmContainerApp_API.outputs.systemAssignedMIPrincipalId!
    roleName: 'Storage Blob Data Contributor'
    roleDefinitionId: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmStorageAccount_RoleAssignment_avmContainerApp_queue 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-storage-contributor-container-app-queue')
  params: {
    resourceId: avmStorageAccount.outputs.resourceId
    principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
    roleName: 'Storage Queue Data Contributor'
    roleDefinitionId: '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmStorageAccount_RoleAssignment_avmContainerApp_API_queue 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-storage-data-contributor-container-api-queue')
  params: {
    resourceId: avmStorageAccount.outputs.resourceId
    principalId: avmContainerApp_API.outputs.systemAssignedMIPrincipalId!
    roleName: 'Storage Queue Data Contributor'
    roleDefinitionId: '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// module avmAppInsightsLogAnalyticsWorkspace './modules/app-insights.bicep' = {
//   //name: format(deployment_param.resource_name_format_string, abbrs.managementGovernance.logAnalyticsWorkspace)
//   params: {
//       appInsightsName: '${namingAbbrs.managementGovernance.applicationInsights}${solutionPrefix}'
//       location: resourceGroupLocation
//       //diagnosticSettings: [{ useThisWorkspace: true }]
//       skuName: 'PerGB2018'
//       applicationType: 'web'
//       disableIpMasking: false
//       disableLocalAuth: false
//       flowType: 'Bluefield'
//       kind: 'web'
//       logAnalyticsWorkspaceName: '${namingAbbrs.managementGovernance.logAnalyticsWorkspace}${solutionPrefix}'
//       publicNetworkAccessForQuery: 'Enabled'
//       requestSource: 'rest'
//       retentionInDays: 30
//   }
// }

// // ========== Managed Identity ========== //
// module avmManagedIdentity './modules/managed-identity.bicep' = {
//   name: format(resourceNameFormatString, namingAbbrs.security.managedIdentity)
//   params: {
//     name: '${namingAbbrs.security.managedIdentity}${solutionPrefix}'
//     location: resourceGroupLocation
//     tags: tags
//   }
// }

// // Assign Owner role to the managed identity in the resource group
// module avmRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-owner')
//   params: {
//     resourceId: avmManagedIdentity.outputs.resourceId
//     principalId: avmManagedIdentity.outputs.principalId
//     roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
//     principalType: 'ServicePrincipal'
//   }
//   scope: resourceGroup(resourceGroup().name)
// }

// // ========== Key Vault Module ========== //
// module avmKeyVault './modules/key-vault.bicep' = {
//   name: format(resourceNameFormatString, namingAbbrs.security.keyVault)
//   params: {
//     keyvaultName: '${namingAbbrs.security.keyVault}${solutionPrefix}'
//     location: resourceGroupLocation
//     tags: tags
//     roleAssignments: [
//       {
//         principalId: avmManagedIdentity.outputs.principalId
//         roleDefinitionIdOrName: 'Key Vault Administrator'
//       }
//     ]
//     enablePurgeProtection: false
//     enableSoftDelete: true
//     keyvaultsku: 'standard'
//     enableRbacAuthorization: true
//     createMode: 'default'
//     enableTelemetry: false
//     enableVaultForDiskEncryption: true
//     enableVaultForTemplateDeployment: true
//     softDeleteRetentionInDays: 7
//     publicNetworkAccess: (enablePrivateNetworking ) ? 'Disabled' : 'Enabled'
//     // privateEndpoints omitted for now, as not in strongly-typed params
//   }
//   scope: resourceGroup(resourceGroup().name)
// }

// module avmKeyVault_RoleAssignment_appConfig 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-keyvault-app-config')
//   params: {
//     resourceId: avmKeyVault.outputs.resourceId
//     principalId: avmAppConfig.outputs.systemAssignedMIPrincipalId!
//     roleDefinitionId: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7' // 'Key Vault Secrets User'
//     roleName: 'Key Vault Secret User'
//     principalType: 'ServicePrincipal'
//   }
// }

// module avmContainerRegistry 'modules/container-registry.bicep' = {
//   name: '${namingAbbrs.containers.containerRegistry}${replace(solutionPrefix, '-', '')}'
//   params: {
//     acrName: '${namingAbbrs.containers.containerRegistry}${replace(solutionPrefix, '-', '')}'
//     location: resourceGroupLocation
//     acrSku: 'Basic'
//     publicNetworkAccess: 'Enabled'
//     zoneRedundancy: 'Disabled'
//     tags: tags
//   }
// }

// // // ========== Storage Account ========== //
// module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
//   name: format(resourceNameFormatString, namingAbbrs.storage.storageAccount)
//   params: {
//     name: '${namingAbbrs.storage.storageAccount}${replace(solutionPrefix, '-', '')}'
//     location: resourceGroupLocation
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     managedIdentities: { systemAssigned: true }
//     minimumTlsVersion: 'TLS1_2'
//     roleAssignments: [
//       {
//         principalId: avmManagedIdentity.outputs.principalId
//         roleDefinitionIdOrName: 'Storage Blob Data Contributor'
//       }
//     ]
//     networkAcls: {
//       bypass: 'AzureServices'
//       defaultAction: 'Allow'
//       ipRules: []
//     }
//     supportsHttpsTrafficOnly: true
//     accessTier: 'Hot'

//     //<======================= WAF related parameters
//     allowBlobPublicAccess: (!enablePrivateNetworking ) // Disable public access when WAF is enabled
//     publicNetworkAccess: (enablePrivateNetworking ) ? 'Disabled' : 'Enabled'
//     privateEndpoints: (enablePrivateNetworking )
//       ? [
//           {
//             name: 'storage-private-endpoint-blob'
//             privateDnsZoneGroup: {
//               privateDnsZoneGroupConfigs: [
//                 {
//                   name: 'storage-dns-zone-group-blob'
//                   privateDnsZoneResourceId: avmPrivateDnsZoneStorages[0].outputs.resourceId
//                   // bicep doesn't recognize collection - avmPrivateDnsZoneStorages
//                   // privateDnsZoneResourceId : filter(avmPrivateDnsZoneStorages, zone => contains(zone.outputs.name, 'blob'))[0].outputs.resourceId
//                 }
//               ]
//             }
//             subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
//             service: 'blob'
//           }
//           {
//             name: 'storage-private-endpoint-queue'
//             privateDnsZoneGroup: {
//               privateDnsZoneGroupConfigs: [
//                 {
//                   name: 'storage-dns-zone-group-queue'
//                   privateDnsZoneResourceId: avmPrivateDnsZoneStorages[2].outputs.resourceId
//                 }
//               ]
//             }
//             subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
//             service: 'queue'
//           }
//         ]
//       : []

//     // privateEndpoints: (deployment_param.enable_waf)
//     //   ? map(items(appStoragePrivateDnsZones), zone => {
//     //       name: 'storage-${zone.value}'
//     //       privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
//     //       service: zone.key
//     //       privateDnsZoneGroup: {
//     //         privateDnsZoneGroupConfigs: [
//     //           {
//     //             name: 'storage-dns-zone-group-${zone.value}'
//     //             privateDnsZoneResourceId: zone.value
//     //           }
//     //         ]
//     //       }
//     //       subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
//     //     })
//     //   : []
//   }
// }

// module avmStorageAccount_RoleAssignment_avmContainerApp_blob 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-storage-data-contributor-container-app')
//   params: {
//     resourceId: avmStorageAccount.outputs.resourceId
//     principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId
//     roleName: 'Storage Blob Data Contributor'
//     roleDefinitionId: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //'Storage Blob Data Contributor'
//     principalType: 'ServicePrincipal'
//   }
// }

// module avmStorageAccount_RoleAssignment_avmContainerApp_API_blob 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-storage-data-contributor-container-api')
//   params: {
//     resourceId: avmStorageAccount.outputs.resourceId
//     principalId: avmContainerApp_API.outputs.?systemAssignedMIPrincipalId
//     roleName: 'Storage Blob Data Contributor'
//     roleDefinitionId: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //'Storage Blob Data Contributor'
//     principalType: 'ServicePrincipal'
//   }
// }

// module avmStorageAccount_RoleAssignment_avmContainerApp_queue 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-storage-contributor-container-app-queue')
//   params: {
//     resourceId: avmStorageAccount.outputs.resourceId
//     principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId
//     roleName: 'Storage Queue Data Contributor'
//     roleDefinitionId: '974c5e8b-45b9-4653-ba55-5f855dd0fb88' //'Storage Queue Data Contributor'
//     principalType: 'ServicePrincipal'
//   }
// }

// module avmStorageAccount_RoleAssignment_avmContainerApp_API_queue 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-storage-data-contributor-container-api-queue')
//   params: {
//     resourceId: avmStorageAccount.outputs.resourceId
//     principalId: avmContainerApp_API.outputs.?systemAssignedMIPrincipalId
//     roleName: 'Storage Queue Data Contributor'
//     roleDefinitionId: '974c5e8b-45b9-4653-ba55-5f855dd0fb88' //'Storage Queue Data Contributor'
//     principalType: 'ServicePrincipal'
//   }
// }

// // ========== AI Foundry and related resources ========== //
module avmAiServices 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: format(resourceNameFormatString, namingAbbrs.ai.aiServices)
  params: {
    name: '${namingAbbrs.ai.aiServices}${solutionPrefix}'
    location: resourceGroupLocation
    sku: 'S0'
    managedIdentities: { systemAssigned: true }
    kind: 'AIServices'
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    customSubDomainName: '${namingAbbrs.ai.aiServices}${solutionPrefix}'
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    disableLocalAuth: true
    enableTelemetry: enableTelemetry
    deployments: [
      {
        name: gptModelName
        model: {
          format: 'OpenAI'
          name: gptModelName
          version: gptModelVersion
        }
        sku: {
          name: deploymentType
          capacity: gptDeploymentCapacity
        }
        raiPolicyName: 'Microsoft.Default'
      }
    ]

    // WAF related parameters
    //publicNetworkAccess: (deployment_param.enable_waf) ? 'Disabled' : 'Enabled'
    publicNetworkAccess: 'Enabled' // Always enabled for AI Services
    // privateEndpoints: (deployment_param.enable_waf)
    //   ? [
    //       {
    //         name: 'ai-services-private-endpoint'
    //         privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //         privateDnsZoneGroup: {
    //           privateDnsZoneGroupConfigs: [
    //             {
    //               name: 'ai-services-dns-zone-cognitiveservices'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneAiServices[0].outputs.resourceId
    //             }
    //             {
    //               name: 'ai-services-dns-zone-openai'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneAiServices[1].outputs.resourceId
    //             }
    //             {
    //               name: 'ai-services-dns-zone-azure'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneAiServices[2].outputs.resourceId
    //             }
    //             {
    //               name: 'ai-services-dns-zone-contentunderstanding'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneAiServices[3].outputs.resourceId
    //             }
    //           ]
    //         }
    //         subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //       }
    //     ]
    //   : []
  }
}

// Role Assignment
module avmAiServices_roleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-ai-services')
  params: {
    resourceId: avmAiServices.outputs.resourceId
    principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId
    roleName: 'Cognitive Services OpenAI User'
    roleDefinitionId: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' //'Cognitive Services OpenAI User'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmAiServices_cu 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: format(resourceNameFormatString, 'aicu-')

  params: {
    name: 'aicu-${solutionPrefix}'
    location: contentUnderstandingLocation
    sku: 'S0'
    managedIdentities: { systemAssigned: true }
    kind: 'AIServices'
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    customSubDomainName: 'aicu-${solutionPrefix}'
    disableLocalAuth: true
    enableTelemetry: enableTelemetry

    publicNetworkAccess: 'Enabled' // Always enabled for AI Services
    // WAF related parameters
    //   publicNetworkAccess: (deployment_param.enable_waf) ? 'Disabled' : 'Enabled'
    //   privateEndpoints: (deployment_param.enable_waf)
    //     ? [
    //         {
    //           name: 'aicu-private-endpoint'
    //           privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //           privateDnsZoneGroup: {
    //             privateDnsZoneGroupConfigs: [
    //               {
    //                 name: 'aicu-dns-zone-cognitiveservices'
    //                 privateDnsZoneResourceId: avmPrivateDnsZoneAiServices[0].outputs.resourceId
    //               }
    //               {
    //                 name: 'aicu-dns-zone-contentunderstanding'
    //                 privateDnsZoneResourceId: avmPrivateDnsZoneAiServices[3].outputs.resourceId
    //               }
    //             ]
    //           }
    //           subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //         }
    //       ]
    //     : []
  }
}

// module avmAiServices_cu_roleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rbac-ai-services-cu')
//   params: {
//     resourceId: avmAiServices_cu.outputs.resourceId
//     principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId
//     roleDefinitionId: 'a97b65f3-24c7-4388-baec-2e87135dc908' //'Cognitive Services User'
//     principalType: 'ServicePrincipal'
//     enableTelemetry: enableTelemetry
//   }
// }

module avmAiServices_storage_hub 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: format(resourceNameFormatString, 'aistoragehub-')
  params: {
    name: 'aisthub${replace(solutionPrefix, '-', '')}'
    location: resourceGroupLocation
    //skuName: 'Standard_LRS'
    //kind: 'StorageV2'
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    tags: tags
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ]

    publicNetworkAccess: 'Enabled' // Always enabled for AI Storage Hub
    // WAF related parameters
    // publicNetworkAccess: (deployment_param.enable_waf) ? 'Disabled' : 'Enabled'
    // privateEndpoints: (deployment_param.enable_waf)
    //   ? [
    //       {
    //         name: 'aistoragehub-private-endpoint-blob'
    //         privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //         service: 'blob'
    //         privateDnsZoneGroup: {
    //           privateDnsZoneGroupConfigs: [
    //             {
    //               name: 'aistoragehub-dns-zone-blob'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneStorage[0].outputs.resourceId
    //             }
    //           ]
    //         }
    //         subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //       }
    //       {
    //         name: 'aistoragehub-private-endpoint-file'
    //         privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //         service: 'file'
    //         privateDnsZoneGroup: {
    //           privateDnsZoneGroupConfigs: [
    //             {
    //               name: 'aistoragehub-dns-zone-file'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneStorage[2].outputs.resourceId
    //             }
    //           ]
    //         }
    //         subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //       }
    //     ]
    //   : []
  }
}

module avmAiHub 'br/public:avm/res/machine-learning-services/workspace:0.12.1' = {
  name: format(resourceNameFormatString, namingAbbrs.ai.aiHub)
  params: {
    name: '${namingAbbrs.ai.aiHub}${solutionPrefix}'
    friendlyName: '${namingAbbrs.ai.aiHub}${solutionPrefix}'
    description: 'AI Hub for CPS template'
    location: resourceGroupLocation
    sku: 'Basic'
    managedIdentities: { systemAssigned: true }
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    // dependent resources
    associatedKeyVaultResourceId: avmKeyVault.outputs.resourceId
    associatedStorageAccountResourceId: avmAiServices_storage_hub.outputs.resourceId
    associatedContainerRegistryResourceId: avmContainerRegistry.outputs.resourceId
    associatedApplicationInsightsResourceId: applicationInsights.outputs.applicationId
    enableTelemetry: enableTelemetry
    kind: 'Hub'
    connections: [
      {
        name: 'AzureOpenAI-Connection'
        category: 'AIServices'
        target: avmAiServices.outputs.endpoint
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true

        metadata: {
          description: 'Connection to Azure OpenAI'
          ApiType: 'Azure'
          resourceId: avmAiServices.outputs.resourceId
        }
      }
    ]

    publicNetworkAccess: 'Enabled' // Always enabled for AI Hub
    //<======================= WAF related parameters
    // publicNetworkAccess: (deployment_param.enable_waf) ? 'Disabled' : 'Enabled'
    // privateEndpoints: (deployment_param.enable_waf)
    //   ? [
    //       {
    //         name: 'ai-hub-private-endpoint'
    //         privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //         privateDnsZoneGroup: {
    //           privateDnsZoneGroupConfigs: [
    //             {
    //               name: 'ai-hub-dns-zone-amlworkspace'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneAiFoundryWorkspace[0].outputs.resourceId
    //             }
    //             {
    //               name: 'ai-hub-dns-zone-notebooks'
    //               privateDnsZoneResourceId: avmPrivateDnsZoneAiFoundryWorkspace[1].outputs.resourceId
    //             }
    //           ]
    //         }
    //         subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //       }
    //     ]
    //   : []
  }
}

module avmAiProject 'br/public:avm/res/machine-learning-services/workspace:0.12.1' = {
  name: format(resourceNameFormatString, namingAbbrs.ai.aiHubProject)
  params: {
    name: '${namingAbbrs.ai.aiHubProject}${solutionPrefix}'
    location: resourceGroupLocation
    managedIdentities: { systemAssigned: true }
    kind: 'Project'
    sku: 'Basic'
    friendlyName: '${namingAbbrs.ai.aiHubProject}${solutionPrefix}'
    hubResourceId: avmAiHub.outputs.resourceId
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

// ========== Container App Environment ========== //
module avmContainerAppEnv 'br/public:avm/res/app/managed-environment:0.11.2' = {
  name: format(resourceNameFormatString, namingAbbrs.containers.containerAppsEnvironment)
  params: {
    name: '${namingAbbrs.containers.containerAppsEnvironment}${solutionPrefix}'
    location: resourceGroupLocation
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    managedIdentities: { systemAssigned: true }
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
        sharedKey: logAnalyticsWorkspace.outputs.primarySharedKey
      }
    }
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    enableTelemetry: enableTelemetry
    publicNetworkAccess: 'Enabled' // Always enabled for Container Apps Environment
    zoneRedundant: false
    // <========== WAF related parameters

    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'

    infrastructureSubnetResourceId: (enablePrivateNetworking)
      ? avmVirtualNetwork.outputs.subnetResourceIds[1] // Use the container app subnet
      : null // Use the container app subnet
  }
}

// //=========== Managed Identity for Container Registry ========== //
module avmContainerRegistryReader 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: format(resourceNameFormatString, 'acr-reader-mid-')
  params: {
    name: 'acr-reader-mid${solutionPrefix}'
    location: resourceGroupLocation
    tags: tags
    enableTelemetry: enableTelemetry
  }
  scope: resourceGroup(resourceGroup().name)
}

// module bicepAcrPullRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
//   name: format(resourceNameFormatString, 'rabc-acr-pull')
//   params: {
//     resourceId: avmContainerRegistry.outputs.resourceId
//     principalId: avmContainerRegistryReader.outputs.principalId
//     roleDefinitionId: '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull role
//     principalType: 'ServicePrincipal'
//     enableTelemetry: enableTelemetry
//   }
//   scope: resourceGroup(resourceGroup().name)
// }

// ========== Container App  ========== //
module avmContainerApp 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapp-')
  params: {
    name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-app'
    location: resourceGroupLocation
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: useLocalBuild == 'localbuild'
      ? [
          {
            server: publicContainerImageEndpoint
            identity: avmContainerRegistryReader.outputs.principalId
          }
        ]
      : null

    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: '${namingAbbrs.containers.containerApp}${solutionPrefix}'
        image: '${publicContainerImageEndpoint}/contentprocessor:latest'

        resources: {
          cpu: '4'
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: ''
          }
        ]
      }
    ]
    activeRevisionsMode: 'Single'
    ingressExternal: false
    disableIngress: true
    // scaleSettings: {
    //   minReplicas: 1
    //   maxReplicas: 1
    // }
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 1
      minReplicas: 1
      rules: enableScaling
        ? [
            {
              name: 'http-scaler'
              http: {
                metadata: {
                  concurrentRequests: 100
                }
              }
            }
          ]
        : []
    }
    tags: tags
  }
}

// ========== Container App API ========== //
module avmContainerApp_API 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapi-')
  params: {
    name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-api'
    location: resourceGroupLocation
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: useLocalBuild == 'localbuild'
      ? [
          {
            server: avmContainerRegistry.outputs.loginServer
            identity: avmContainerRegistryReader.outputs.principalId
          }
        ]
      : null
    // registries: useLocalBuild == 'localbuild'
    //   ? [
    //       {
    //         server: publicContainerImageEndpoint
    //         image: 'contentprocessorapi'
    //         imageTag: 'latest'
    //       }
    //     ]
    //   : null
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-api'
        image: (useLocalBuild != 'localbuild')
          ? '${publicContainerImageEndpoint}/contentprocessorapi:latest'
          : avmContainerRegistry.outputs.loginServer
        resources: {
          cpu: '4'
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: ''
          }
        ]
        probes: [
          // Liveness Probe - Checks if the app is still running
          {
            type: 'Liveness'
            httpGet: {
              path: '/startup' // Your app must expose this endpoint
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          // Readiness Probe - Checks if the app is ready to receive traffic
          {
            type: 'Readiness'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          {
            type: 'Startup'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 20 // Wait 10s before checking
            periodSeconds: 5 // Check every 15s
            failureThreshold: 10 // Restart if it fails 5 times
          }
        ]
      }
    ]
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 1
      minReplicas: 1
      rules: enableScaling
        ? [
            {
              name: 'http-scaler'
              http: {
                metadata: {
                  concurrentRequests: 100
                }
              }
            }
          ]
        : []
    }
    ingressExternal: true
    activeRevisionsMode: 'Single'
    ingressTransport: 'auto'
    ingressAllowInsecure: true
    corsPolicy: {
      allowedOrigins: [
        '*'
      ]
      allowedMethods: [
        'GET'
        'POST'
        'PUT'
        'DELETE'
        'OPTIONS'
      ]
      allowedHeaders: [
        'Authorization'
        'Content-Type'
        '*'
      ]
    }
  }
}

//========== Container App Web ========== //
module avmContainerApp_Web 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caweb-')
  params: {
    name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-web'
    location: resourceGroupLocation
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: useLocalBuild == 'localbuild'
      ? [
          {
            server: avmContainerRegistry.outputs.loginServer
            identity: avmContainerRegistryReader.outputs.principalId
          }
        ]
      : null
    // registries: useLocalBuild == 'localbuild'
    //   ? [
    //       {
    //         server: publicContainerImageEndpoint
    //         image: 'contentprocessorweb'
    //         imageTag: 'latest'
    //       }
    //     ]
    //   : null
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }
    ingressExternal: true
    activeRevisionsMode: 'Single'
    ingressTransport: 'auto'
    ingressAllowInsecure: true
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 1
      minReplicas: 1
      rules: enableScaling
        ? [
            {
              name: 'http-scaler'
              http: {
                metadata: {
                  concurrentRequests: 100
                }
              }
            }
          ]
        : []
    }
    containers: [
      {
        name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-web'
        image: (useLocalBuild != 'localbuild')
          ? '${publicContainerImageEndpoint}/contentprocessorweb:latest'
          : avmContainerRegistry.outputs.loginServer
        resources: {
          cpu: '4'
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_API_BASE_URL'
            value: 'https://${avmContainerApp_API.outputs.fqdn}'
          }
          {
            name: 'APP_WEB_CLIENT_ID'
            value: '<APP_REGISTRATION_CLIENTID>'
          }
          {
            name: 'APP_WEB_AUTHORITY'
            value: '${environment().authentication.loginEndpoint}/${tenant().tenantId}'
          }
          {
            name: 'APP_WEB_SCOPE'
            value: '<FRONTEND_API_SCOPE>'
          }
          {
            name: 'APP_API_SCOPE'
            value: '<BACKEND_API_SCOPE>'
          }
          {
            name: 'APP_CONSOLE_LOG_ENABLED'
            value: 'false'
          }
        ]
      }
    ]
  }
}

// ========== Cosmos Database for Mongo DB ========== //
module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: format(resourceNameFormatString, namingAbbrs.databases.cosmosDBDatabase)
  params: {
    name: '${namingAbbrs.databases.cosmosDBDatabase}${solutionPrefix}'
    location: resourceGroupLocation
    mongodbDatabases: [
      {
        name: 'default'
        tag: 'default database'
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
    databaseAccountOfferType: 'Standard'
    automaticFailover: false
    serverVersion: '7.0'
    capabilitiesToAdd: [
      'EnableMongo'
    ]
    enableAnalyticalStorage: true
    defaultConsistencyLevel: 'Session'
    maxIntervalInSeconds: 5
    maxStalenessPrefix: 100
    zoneRedundant: false

    // WAF related parameters
    networkRestrictions: {
      publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
      ipRules: []
      virtualNetworkRules: []
    }

    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'cosmosdb-private-endpoint'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'cosmosdb-dns-zone-group'
                  privateDnsZoneResourceId: avmPrivateDnsZoneCosmosMongoDB.outputs.resourceId
                }
              ]
            }
            service: 'MongoDB'
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
          }
        ]
      : []
  }
}

// ========== App Configuration ========== //
module avmAppConfig 'br/public:avm/res/app-configuration/configuration-store:0.6.3' = {
  name: format(resourceNameFormatString, namingAbbrs.developerTools.appConfigurationStore)
  params: {
    name: '${namingAbbrs.developerTools.appConfigurationStore}${solutionPrefix}'
    location: resourceGroupLocation
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    enableTelemetry: enableTelemetry
    managedIdentities: { systemAssigned: true }
    sku: 'Standard'
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
      }
    ]
    disableLocalAuth: true
    replicaLocations: [
      {
        replicaLocation: secondaryLocation
        name: 'Secondary Location'
      }
    ]
    keyValues: [
      {
        name: 'APP_AZURE_OPENAI_ENDPOINT'
        value: avmAiServices.outputs.endpoint //TODO: replace with actual endpoint
      }
      {
        name: 'APP_AZURE_OPENAI_MODEL'
        value: gptModelName
      }
      {
        name: 'APP_CONTENT_UNDERSTANDING_ENDPOINT'
        value: avmAiServices_cu.outputs.endpoint //TODO: replace with actual endpoint
      }
      {
        name: 'APP_COSMOS_CONTAINER_PROCESS'
        value: 'Processes'
      }
      {
        name: 'APP_COSMOS_CONTAINER_SCHEMA'
        value: 'Schemas'
      }
      {
        name: 'APP_COSMOS_DATABASE'
        value: 'ContentProcess'
      }
      {
        name: 'APP_CPS_CONFIGURATION'
        value: 'cps-configuration'
      }
      {
        name: 'APP_CPS_MAX_FILESIZE_MB'
        value: '20'
      }
      {
        name: 'APP_CPS_PROCESSES'
        value: 'cps-processes'
      }
      {
        name: 'APP_LOGGING_ENABLE'
        value: 'False'
      }
      {
        name: 'APP_LOGGING_LEVEL'
        value: 'INFO'
      }
      {
        name: 'APP_MESSAGE_QUEUE_EXTRACT'
        value: 'content-pipeline-extract-queue'
      }
      {
        name: 'APP_MESSAGE_QUEUE_INTERVAL'
        value: '5'
      }
      {
        name: 'APP_MESSAGE_QUEUE_PROCESS_TIMEOUT'
        value: '180'
      }
      {
        name: 'APP_MESSAGE_QUEUE_VISIBILITY_TIMEOUT'
        value: '10'
      }
      {
        name: 'APP_PROCESS_STEPS'
        value: 'extract,map,evaluate,save'
      }
      {
        name: 'APP_STORAGE_BLOB_URL'
        value: 'test' //avmStorageAccount.outputs.serviceEndpoints.blob //TODO: replace with actual blob URL
      }
      {
        name: 'APP_STORAGE_QUEUE_URL'
        value: 'test' //avmStorageAccount.outputs.serviceEndpoints.queue //TODO: replace with actual queue URL
      }
      {
        name: 'APP_AI_PROJECT_CONN_STR'
        value: 'test' //'${resourceGroupLocation}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${avmAiProject.name}'
        //TODO: replace with actual AI project connection string
      }
      {
        name: 'APP_COSMOS_CONNSTR'
        value: 'test' //avmCosmosDB.outputs.primaryReadWriteConnectionString
      }
    ]

    publicNetworkAccess: 'Enabled' // Always enabled for App Configuration
    // WAF related parameters
    //   publicNetworkAccess: (deployment_param.enable_waf) ? 'Disabled' : 'Enabled'
    //   privateEndpoints: (deployment_param.enable_waf)
    //     ? [
    //         {
    //           name: 'appconfig-private-endpoint'
    //           privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
    //           privateDnsZoneGroup: {
    //             privateDnsZoneGroupConfigs: [
    //               {
    //                 name: 'appconfig-dns-zone-group'
    //                 privateDnsZoneResourceId: avmPrivateDnsZoneAppConfig.outputs.resourceId
    //               }
    //             ]
    //           }
    //           subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
    //         }
    //       ]
    //     : []
  }

  dependsOn: [
    avmAiServices
    avmAiServices_cu
    avmStorageAccount
    avmCosmosDB
    avmAiProject
  ]
}

module avmAppConfig_update 'br/public:avm/res/app-configuration/configuration-store:0.6.3' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, '${namingAbbrs.developerTools.appConfigurationStore}-update')
  params: {
    name: '${namingAbbrs.developerTools.appConfigurationStore}${solutionPrefix}'
    location: resourceGroupLocation
    enableTelemetry: enableTelemetry
    tags: tags
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'appconfig-private-endpoint'
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              name: 'appconfig-dns-zone-group'
              privateDnsZoneResourceId: avmPrivateDnsZoneAppConfig.outputs.resourceId
            }
          ]
        }
        subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
      }
    ]
  }

  dependsOn: [
    avmAppConfig
  ]
}

module avmRoleAssignment_container_app 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-app-config-data-reader')
  params: {
    resourceId: avmAppConfig.outputs.resourceId
    principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId
    roleDefinitionId: '516239f1-63e1-4d78-a4de-a74fb236a071' // Built-in
    roleName: 'App Configuration Data Reader'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmRoleAssignment_container_app_api 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-app-config-data-reader-api')
  params: {
    resourceId: avmAppConfig.outputs.resourceId
    principalId: avmContainerApp_API.outputs.?systemAssignedMIPrincipalId
    roleDefinitionId: '516239f1-63e1-4d78-a4de-a74fb236a071' // Built-in
    roleName: 'App Configuration Data Reader'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

module avmRoleAssignment_container_app_web 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: format(resourceNameFormatString, 'rbac-app-config-data-reader-web')
  params: {
    resourceId: avmAppConfig.outputs.resourceId
    principalId: avmContainerApp_Web.outputs.?systemAssignedMIPrincipalId
    roleDefinitionId: '516239f1-63e1-4d78-a4de-a74fb236a071' // Built-in
    roleName: 'App Configuration Data Reader'
    principalType: 'ServicePrincipal'
    enableTelemetry: enableTelemetry
  }
}

// ========== Container App Update Modules ========== //
module avmContainerApp_update 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapp-update-')
  params: {
    name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-app'
    location: resourceGroupLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: useLocalBuild == 'localbuild'
      ? [
          {
            server: publicContainerImageEndpoint
            identity: avmContainerRegistryReader.outputs.principalId
          }
        ]
      : null
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: '${namingAbbrs.containers.containerApp}${solutionPrefix}'
        image: '${publicContainerImageEndpoint}/contentprocessor:latest'

        resources: {
          cpu: '4'
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: avmAppConfig.outputs.endpoint
          }
        ]
      }
    ]
    activeRevisionsMode: 'Single'
    ingressExternal: false
    disableIngress: true
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 1
      minReplicas: 1
      rules: enableScaling
        ? [
            {
              name: 'http-scaler'
              http: {
                metadata: {
                  concurrentRequests: 100
                }
              }
            }
          ]
        : []
    }
  }
  dependsOn: [
    avmStorageAccount_RoleAssignment_avmContainerApp_blob
    avmStorageAccount_RoleAssignment_avmContainerApp_queue
    avmRoleAssignment_container_app
  ]
}

module avmContainerApp_API_update 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapi-update-')
  params: {
    name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-api'
    location: resourceGroupLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: useLocalBuild == 'localbuild'
      ? [
          {
            server: avmContainerRegistry.outputs.loginServer
            identity: avmContainerRegistryReader.outputs.principalId
          }
        ]
      : null
    // registries: useLocalBuild == 'localbuild'
    //   ? [
    //       {
    //         server: publicContainerImageEndpoint
    //         image: 'contentprocessorapi'
    //         imageTag: 'latest'
    //       }
    //     ]
    //   : null
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: '${namingAbbrs.containers.containerApp}${solutionPrefix}-api'
        image: (useLocalBuild != 'localbuild')
          ? '${publicContainerImageEndpoint}/contentprocessorapi:latest'
          : avmContainerRegistry.outputs.loginServer
        resources: {
          cpu: '4'
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: avmAppConfig.outputs.endpoint
          }
        ]
        probes: [
          // Liveness Probe - Checks if the app is still running
          {
            type: 'Liveness'
            httpGet: {
              path: '/startup' // Your app must expose this endpoint
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          // Readiness Probe - Checks if the app is ready to receive traffic
          {
            type: 'Readiness'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          {
            type: 'Startup'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 20 // Wait 10s before checking
            periodSeconds: 5 // Check every 15s
            failureThreshold: 10 // Restart if it fails 5 times
          }
        ]
      }
    ]
    scaleSettings: {
      minReplicas: 1
      maxReplicas: 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    ingressExternal: true
    activeRevisionsMode: 'Single'
    ingressTransport: 'auto'
    ingressAllowInsecure: true
    corsPolicy: {
      allowedOrigins: [
        '*'
      ]
      allowedMethods: [
        'GET'
        'POST'
        'PUT'
        'DELETE'
        'OPTIONS'
      ]
      allowedHeaders: [
        'Authorization'
        'Content-Type'
        '*'
      ]
    }
  }
  dependsOn: [
    avmStorageAccount_RoleAssignment_avmContainerApp_API_blob
    avmStorageAccount_RoleAssignment_avmContainerApp_API_queue
    avmRoleAssignment_container_app_api
  ]
}

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

@description('The resource ID of the Container App Environment.')
output containerWebAppName string = avmContainerApp_Web.outputs.name
@description('The resource ID of the Container App API.')
output containerApiAppName string = avmContainerApp_API.outputs.name
@description('The resource ID of the Container App Environment.')
output containerWebAppFqdn string = avmContainerApp_Web.outputs.fqdn
@description('The resource ID of the Container App API.')
output containerApiAppFqdn string = avmContainerApp_API.outputs.fqdn

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
