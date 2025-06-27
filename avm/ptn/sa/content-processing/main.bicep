// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Content Processing Solution Accelerator'
metadata description = '''This module contains the resources required to deploy the [Content Processing solution accelerator](https://github.com/microsoft/content-processing-solution-accelerator) for both Sandbox environments and WAF aligned environments.
> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

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
@minValue(1)
@description('Required. Capacity of the GPT deployment: (minimum 10).')
param gptDeploymentCapacity int
@description('Optional. Location used for Azure Cosmos DB, Azure Container App deployment.')
param secondaryLocation string = (location == 'eastus2') ? 'westus2' : 'eastus2'
@description('Optional. The resource group location.')
param resourceGroupLocation string = resourceGroup().location
@description('Optional. The resource name format string.')
param resourceNameFormatString string = '{0}avm-cps'
@description('Optional. Enable WAF for the deployment.')
param enablePrivateNetworking bool = true
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true
@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {
  app: 'Content Processing Solution Accelerator'
  location: resourceGroup().location
}
@description('Optional. Set to true to use local build for container app images, otherwise use container registry images.')
param useLocalBuild bool = false

@description('Optional. Enable scaling for the container apps. Defaults to false.')
param enableScaling bool = false

@description('Optional. The public container image endpoint.')
param publicContainerImageEndpoint string = 'cpscontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the Web Container App.')
param webContainerImageName string = 'contentprocessorweb'

@description('Optional. The Container Image Tag to deploy on the Web Container App.')
param webContainerImageTag string = 'latest'

@description('Optional. The Container Image Name to deploy on the App Container App.')
param appContainerImageName string = 'contentprocessor'

@description('Optional. The Container Image Tag to deploy on the backend.')
param appContainerImageTag string = 'latest'

@description('Optional. The Container Image Name to deploy on the Api Container App.')
param apiContainerImageName string = 'contentprocessorapi'

@description('Optional. The Container Image Tag to deploy on the backend.')
param apiContainerImageTag string = 'latest'

// ========== Solution Prefix Variable ========== //
@description('Optional. A unique deployment timestamp for solution prefix generation.')
param deploymentTimestamp string = utcNow()

var solutionPrefix = 'cps-${padLeft(take(toLower(uniqueString(subscription().id, environmentName, resourceGroup().location, deploymentTimestamp)), 12), 12, '0')}'

// ============== //
// Resources      //
// ============== //

// ========== AVM Telemetry ========== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
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

// ========== Network Security Group definition ========== //
module avmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: format(resourceNameFormatString, 'nsg-backend')
  params: {
    name: 'nsg-${solutionPrefix}-backend'
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
  name: format(resourceNameFormatString, 'nsg-containers')
  params: {
    name: 'nsg-${solutionPrefix}-containers'
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
  name: format(resourceNameFormatString, 'nsg-bastion')
  params: {
    name: 'nsg-${solutionPrefix}-bastion'
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
  name: format(resourceNameFormatString, 'nsg-admin')
  params: {
    name: 'nsg-${solutionPrefix}-admin'
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
  name: format(resourceNameFormatString, 'vnet-')
  params: {
    name: 'vnet-cps-${solutionPrefix}'
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
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.contentunderstanding.ai.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.azconfig.io'
  'privatelink.vaultcore.azure.net'
  'privatelink.azurecr.io'
]

// DNS Zone Index Constants
var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  contentUnderstanding: 3
  storageBlob: 4
  storageQueue: 5
  storageFile: 6
  aiFoundry: 7
  notebooks: 8
  cosmosDB: 9
  appConfig: 10
  keyVault: 11
  containerRegistry: 12
}

@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: 'dns-zone-${i}'
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: avmVirtualNetwork.outputs.resourceId }]
    }
  }
]

// ============== //
// Resources      //
// ============== //

// ========== Log Analytics and Application insights ========== //

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  name: 'deploy_log_analytics_workspace'
  params: {
    name: 'log-${solutionPrefix}'
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
    name: 'appi-${solutionPrefix}'
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
  params: {
    name: 'id-${solutionPrefix}'
    location: resourceGroupLocation
    tags: tags
  }
}

// ========== Key Vault Module ========== //

module avmKeyVault './modules/key-vault.bicep' = {
  params: {
    keyvaultName: 'kv-${solutionPrefix}'
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

module avmContainerRegistry 'modules/container-registry.bicep' = {
  //name: format(deployment_param.resource_name_format_string, abbrs.containers.containerRegistry)
  params: {
    acrName: 'cr${replace(solutionPrefix, '-', '')}'
    location: resourceGroupLocation
    acrSku: 'Standard'
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Disabled'
    tags: tags
  }
}

// // ========== Storage Account ========== //
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: format(resourceNameFormatString, 'st')
  params: {
    name: 'st${replace(solutionPrefix, '-', '')}'
    location: resourceGroupLocation
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: avmContainerApp_API.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: avmContainerApp_API.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: (enablePrivateNetworking) ? 'Deny' : 'Allow'
      ipRules: []
    }
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    tags: tags

    //<======================= WAF related parameters
    allowBlobPublicAccess: (enablePrivateNetworking) ? true : false // Disable public access when WAF is enabled
    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'storage-private-endpoint-blob-${solutionPrefix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-blob'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
            service: 'blob'
          }
          {
            name: 'storage-private-endpoint-queue-${solutionPrefix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-queue'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageQueue].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
            service: 'queue'
          }
        ]
      : []
  }
  dependsOn: [
    avmContainerApp
    avmContainerApp_API
  ]
}

// // ========== AI Foundry and related resources ========== //
module avmAiServices 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: format(resourceNameFormatString, 'aisa-')
  params: {
    name: 'aisa-${solutionPrefix}'
    location: resourceGroupLocation
    sku: 'S0'
    managedIdentities: { systemAssigned: true }
    kind: 'AIServices'
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    customSubDomainName: 'aisa-${solutionPrefix}'
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' // Owner role
      }
      {
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow' // Always allow for AI Services
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
    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'ai-services-private-endpoint-${solutionPrefix}'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'ai-services-dns-zone-cognitiveservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices].outputs.resourceId
                }
                {
                  name: 'ai-services-dns-zone-openai'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.openAI].outputs.resourceId
                }
                {
                  name: 'ai-services-dns-zone-aiservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.aiServices].outputs.resourceId
                }
                {
                  name: 'ai-services-dns-zone-contentunderstanding'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.contentUnderstanding].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
          }
        ]
      : []
  }
}

module avmAiServices_cu 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: format(resourceNameFormatString, 'aicu-')

  params: {
    name: 'aicu-${solutionPrefix}'
    location: contentUnderstandingLocation
    sku: 'S0'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId // Use the managed identity created above
      ]
    }
    kind: 'AIServices'
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    customSubDomainName: 'aicu-${solutionPrefix}'
    disableLocalAuth: true
    enableTelemetry: enableTelemetry
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow' // Always allow for AI Services
    }
    roleAssignments: [
      {
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'a97b65f3-24c7-4388-baec-2e87135dc908'
        principalType: 'ServicePrincipal'
      }
    ]

    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled' // Always enabled for AI Services
    // WAF related parameters
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'aicu-private-endpoint-${solutionPrefix}'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'aicu-dns-zone-cognitiveservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices].outputs.resourceId
                }
                {
                  name: 'aicu-dns-zone-contentunderstanding'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.contentUnderstanding].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
          }
        ]
      : []
  }
}

module avmAiServices_storage_hub 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: format(resourceNameFormatString, 'aistoragehub-')
  params: {
    name: 'aisthub${replace(solutionPrefix, '-', '')}'
    location: resourceGroupLocation
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

    publicNetworkAccess: 'Disabled' // Always enabled for AI Storage Hub
    // WAF related parameters
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'aistoragehub-private-endpoint-blob-${solutionPrefix}'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            service: 'blob'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'aistoragehub-dns-zone-blob'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
          }
          {
            name: 'aistoragehub-private-endpoint-file-${solutionPrefix}'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            service: 'file'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'aistoragehub-dns-zone-file'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageFile].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
          }
        ]
      : []
  }
}

var aiHubStorageResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Storage/storageAccounts/${avmAiServices_storage_hub.outputs.name}'

module avmAiHub 'br/public:avm/res/machine-learning-services/workspace:0.12.1' = {
  name: format(resourceNameFormatString, 'aih-')
  params: {
    name: 'aih-${solutionPrefix}'
    friendlyName: 'aih-${solutionPrefix}'
    description: 'AI Hub for CPS template'
    location: resourceGroupLocation
    sku: 'Basic'
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    tags: {
      app: solutionPrefix
      location: resourceGroupLocation
    }
    // dependent resources
    associatedKeyVaultResourceId: avmKeyVault.outputs.resourceId
    primaryUserAssignedIdentity: avmManagedIdentity.outputs.resourceId
    associatedStorageAccountResourceId: aiHubStorageResourceId //avmAiServices_storage_hub.outputs.resourceId
    associatedContainerRegistryResourceId: avmContainerRegistry.outputs.resourceId
    associatedApplicationInsightsResourceId: applicationInsights.outputs.resourceId
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

    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled' // Always enabled for AI Hub
    //<======================= WAF related parameters
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'ai-hub-private-endpoint-${solutionPrefix}'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'ai-hub-dns-zone-amlworkspace'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.aiFoundry].outputs.resourceId
                }
                {
                  name: 'ai-hub-dns-zone-notebooks'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.notebooks].outputs.resourceId
                }
              ]
            }
            subnetResourceId: avmVirtualNetwork.outputs.subnetResourceIds[0] // Use the backend subnet
          }
        ]
      : []
  }
}

module avmAiProject 'br/public:avm/res/machine-learning-services/workspace:0.12.1' = {
  name: format(resourceNameFormatString, 'aihp-')
  params: {
    name: 'aihp-${solutionPrefix}'
    location: resourceGroupLocation
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    kind: 'Project'
    sku: 'Basic'
    friendlyName: 'aihp-${solutionPrefix}'
    primaryUserAssignedIdentity: avmManagedIdentity.outputs.resourceId
    hubResourceId: avmAiHub.outputs.resourceId
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

// ========== Container App Environment ========== //
module avmContainerAppEnv 'br/public:avm/res/app/managed-environment:0.11.2' = {
  name: format(resourceNameFormatString, 'cae-')
  params: {
    name: 'cae-${solutionPrefix}'
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

    // <========== WAF related parameters

    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    zoneRedundant: (enablePrivateNetworking) ? true : false // Enable zone redundancy if private networking is enabled
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

// ========== Container App  ========== //
module avmContainerApp 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapp-')
  params: {
    name: 'ca-${solutionPrefix}-app'
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
        name: 'ca-${solutionPrefix}'
        image: '${publicContainerImageEndpoint}/${appContainerImageName}:${appContainerImageTag}'

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
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: enableScaling ? 2 : 1
    }
    tags: tags
  }
}

// ========== Container App API ========== //
module avmContainerApp_API 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapi-')
  params: {
    name: 'ca-${solutionPrefix}-api'
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
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: 'ca-${solutionPrefix}-api'
        image: (useLocalBuild != 'localbuild')
          ? '${publicContainerImageEndpoint}/${apiContainerImageName}:${apiContainerImageTag}'
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
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: enableScaling ? 2 : 1
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
    name: 'ca-${solutionPrefix}-web'
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
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: enableScaling ? 2 : 1
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
    containers: [
      {
        name: 'ca-${solutionPrefix}-web'
        image: (useLocalBuild != 'localbuild')
          ? '${publicContainerImageEndpoint}/${webContainerImageName}:${webContainerImageTag}'
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
  name: format(resourceNameFormatString, 'cosmos-')
  params: {
    name: 'cosmos-${solutionPrefix}'
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

    // WAF related parameters
    networkRestrictions: {
      publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
      ipRules: []
      virtualNetworkRules: []
    }

    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'cosmosdb-private-endpoint-${solutionPrefix}'
            privateEndpointResourceId: avmVirtualNetwork.outputs.resourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'cosmosdb-dns-zone-group'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB].outputs.resourceId
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
  name: format(resourceNameFormatString, 'appcs-')
  params: {
    name: 'appcs-${solutionPrefix}'
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
    disableLocalAuth: false
    replicaLocations: (resourceGroupLocation != secondaryLocation) ? [secondaryLocation] : []
    roleAssignments: [
      {
        principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
      }
      {
        principalId: avmContainerApp_API.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
      }
      {
        principalId: avmContainerApp_Web.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
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
        value: avmStorageAccount.outputs.serviceEndpoints.blob
      }
      {
        name: 'APP_STORAGE_QUEUE_URL'
        value: avmStorageAccount.outputs.serviceEndpoints.queue
      }
      {
        name: 'APP_AI_PROJECT_CONN_STR'
        value: '${resourceGroupLocation}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${avmAiProject.name}'
      }
      {
        name: 'APP_COSMOS_CONNSTR'
        value: avmCosmosDB.outputs.primaryReadWriteConnectionString
      }
    ]

    publicNetworkAccess: 'Enabled'
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
  name: format(resourceNameFormatString, 'appcs-update')
  params: {
    name: 'appcs-${solutionPrefix}'
    location: resourceGroupLocation
    enableTelemetry: enableTelemetry
    tags: tags
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'appconfig-private-endpoint-${solutionPrefix}'
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              name: 'appconfig-dns-zone-group'
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.appConfig].outputs.resourceId
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

// ========== Container App Update Modules ========== //
module avmContainerApp_update 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapp-update-')
  params: {
    name: 'ca-${solutionPrefix}-app'
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
        name: 'ca-${solutionPrefix}'
        image: '${publicContainerImageEndpoint}/${appContainerImageName}:${appContainerImageTag}'

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
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: enableScaling ? 2 : 1
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
    avmAppConfig
  ]
}

module avmContainerApp_API_update 'br/public:avm/res/app/container-app:0.17.0' = {
  name: format(resourceNameFormatString, 'caapi-update-')
  params: {
    name: 'ca-${solutionPrefix}-api'
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
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: 'ca-${solutionPrefix}-api'
        image: (useLocalBuild != 'localbuild')
          ? '${publicContainerImageEndpoint}/${apiContainerImageName}:${apiContainerImageTag}'
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
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: enableScaling ? 2 : 1
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
    avmAppConfig
  ]
}

// ============ //
// Outputs      //
// ============ //

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
