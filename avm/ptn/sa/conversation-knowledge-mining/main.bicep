targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = '''This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/blob/main/documents/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ========== Parameters ========== //
@minLength(3)
@maxLength(16)
@description('Optional. A unique prefix for all resources in this deployment. This should be 3-20 characters long.')
param solutionName string = 'kmgen'

@metadata({ azd: { type: 'location' } })
@description('Optional. Azure region for all services. Allowed values: australiaeast, centralus, eastasia, eastus2, japaneast, northeurope, southeastasia, uksouth. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions).')
param location string = resourceGroup().location

@allowed([
  'australiaeast'
  'eastus'
  'eastus2'
  'francecentral'
  'japaneast'
  'swedencentral'
  'uksouth'
  'westus'
  'westus3'
])
@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-4o-mini,150'
      'OpenAI.GlobalStandard.text-embedding-ada-002,80'
    ]
  }
})
@description('Required. Location for AI Foundry deployment. This is the location where the AI Foundry resources will be deployed.')
param aiServiceLocation string

@minLength(1)
@description('Required. Industry use case for deployment.')
@allowed([
  'telecom'
  'IT_helpdesk'
])
param usecase string

@minLength(1)
@description('Optional. Location for the Content Understanding service deployment.')
@allowed(['swedencentral', 'australiaeast'])
@metadata({
  azd: {
    type: 'location'
  }
})
param contentUnderstandingLocation string = 'swedencentral'

@minLength(1)
@description('Optional. Secondary location for databases creation (example: eastus2).')
param secondaryLocation string = 'eastus2'

@description('Optional. Location for the Cosmos DB replica deployment. This location is used when enableRedundancy is set to true.')
param cosmosDbReplicaLocation string = 'canadacentral'

@minLength(1)
@description('Optional. GPT model deployment type.')
@allowed([
  'Standard'
  'GlobalStandard'
])
param deploymentType string = 'GlobalStandard'

@description('Optional. Name of the GPT model to deploy.')
param gptModelName string = 'gpt-4o-mini'

@description('Optional. Version of the GPT model to deploy.')
param gptModelVersion string = '2024-07-18'

@description('Optional. Version of the Azure OpenAI API.')
param azureOpenAIApiVersion string = '2025-01-01-preview'

@description('Optional. Version of AI Agent API.')
param azureAiAgentApiVersion string = '2025-05-01'

@description('Optional. Version of Content Understanding API.')
param azureContentUnderstandingApiVersion string = '2024-12-01-preview'

// You can increase this, but capacity is limited per model/region, so you will get errors if you go over
// https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits
@minValue(10)
@description('Optional. Capacity of the GPT deployment.')
param gptDeploymentCapacity int = 150

@minLength(1)
@description('Optional. Name of the Text Embedding model to deploy.')
@allowed([
  'text-embedding-ada-002'
])
param embeddingModel string = 'text-embedding-ada-002'

@minValue(10)
@description('Optional. Capacity of the Embedding Model deployment.')
param embeddingDeploymentCapacity int = 80

@description('Optional. The Container Registry hostname where the docker images for the backend are located.')
param backendContainerRegistryHostname string = 'kmcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the backend.')
param backendContainerImageName string = 'km-api'

@description('Optional. The Container Image Tag to deploy on the backend.')
param backendContainerImageTag string = 'latest_waf_2025-12-02_1084'

@description('Optional. The Container Registry hostname where the docker images for the frontend are located.')
param frontendContainerRegistryHostname string = 'kmcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the frontend.')
param frontendContainerImageName string = 'km-app'

@description('Optional. The Container Image Tag to deploy on the frontend.')
param frontendContainerImageTag string = 'latest_waf_2025-12-02_1084'

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enablePrivateNetworking bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminUsername string?

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminPassword string?

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.')
param vmSize string = 'Standard_DS2_v2'

@description('Optional. Created by user name.')
param createdBy string = contains(deployer(), 'userPrincipalName')? split(deployer().userPrincipalName, '@')[0]: deployer().objectId

@maxLength(5)
@description('Optional. A unique text value for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
param solutionUniqueText string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueText}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))

var acrName = 'kmcontainerreg'
// Replica regions list based on article in [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Enhance resilience by replicating your Log Analytics workspace across regions](https://learn.microsoft.com/azure/azure-monitor/logs/workspace-replication#supported-regions) for supported regions for Log Analytics Workspace.
var replicaRegionPairs = {
  australiaeast: 'australiasoutheast'
  centralus: 'westus'
  eastasia: 'japaneast'
  eastus: 'centralus'
  eastus2: 'centralus'
  japaneast: 'eastasia'
  northeurope: 'westeurope'
  southeastasia: 'eastasia'
  uksouth: 'westeurope'
  westeurope: 'northeurope'
}
var replicaLocation = replicaRegionPairs[resourceGroup().location]
var logAnalyticsWorkspaceResourceId = logAnalyticsWorkspace!.outputs.resourceId

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags:{
      ...resourceGroup().tags
      TemplateName: 'KM-Generic'
      Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
      CreatedBy: createdBy
      DeploymentName: deployment().name
      UseCase: usecase
      ...tags
    }
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.sa-convknowledgemining.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// WAF PSRules for Log Analytics: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#azure-monitor-logs
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.14.2' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 365
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    diagnosticSettings: [{ useThisWorkspace: true }]
    // WAF aligned configuration for Redundancy
    dailyQuotaGb: enableRedundancy ? 10 : null //WAF recommendation: 10 GB per day is a good starting point for most workloads
    replication: enableRedundancy
      ? {
          enabled: true
          location: replicaLocation
        }
      : null
    // WAF aligned configuration for Private Networking
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    dataSources: enablePrivateNetworking
      ? [
          {
            tags: tags
            eventLogName: 'Application'
            eventTypes: [
              {
                eventType: 'Error'
              }
              {
                eventType: 'Warning'
              }
              {
                eventType: 'Information'
              }
            ]
            kind: 'WindowsEvent'
            name: 'applicationEvent'
          }
          {
            counterName: '% Processor Time'
            instanceName: '*'
            intervalSeconds: 60
            kind: 'WindowsPerformanceCounter'
            name: 'windowsPerfCounter1'
            objectName: 'Processor'
          }
          {
            kind: 'IISLogs'
            name: 'sampleIISLog1'
            state: 'OnPremiseEnabled'
          }
        ]
      : null
  }
}

// ========== Application Insights ========== //
// WAF best practices for Application Insights: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/application-insights
// WAF PSRules for  Application Insights: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#application-insights
var applicationInsightsResourceName = 'appi-${solutionSuffix}'
module applicationInsights 'br/public:avm/res/insights/component:0.7.1' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    // WAF aligned configuration for Monitoring
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
  }
}
// ========== Virtual Network and Networking Components ========== //
module virtualNetwork 'modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtualNetwork.${solutionSuffix}', 64)
  params: {
    name: 'vnet-${solutionSuffix}'
    addressPrefixes: ['10.0.0.0/20'] // 4096 addresses (enough for 8 /23 subnets or 16 /24)
    location: location
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    resourceSuffix: solutionSuffix
    enableTelemetry: enableTelemetry
  }
}
// Azure Bastion Host
var bastionHostName = 'bas-${solutionSuffix}'
module bastionHost 'br/public:avm/res/network/bastion-host:0.8.2' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionHostName}', 64)
  params: {
    name: bastionHostName
    skuName: 'Standard'
    location: location
    virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
    diagnosticSettings: [
      {
        name: 'bastionDiagnostics'
        workspaceResourceId: logAnalyticsWorkspaceResourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
    publicIPAddressObject: {
      name: 'pip-${bastionHostName}'
    }
  }
}

// ========== Maintenance Configuration ========== //
module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.3.2' = if (enablePrivateNetworking) {
  name: take('${jumpboxVmName}-jumpbox-maintenance-config', 64)
  params: {
    name: 'mc-${jumpboxVmName}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2024-06-16 00:00'
      duration: '03:55'
      timeZone: 'W. Europe Standard Time'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

// Jumpbox Virtual Machine
var jumpboxVmName = take('vm-jumpbox-${solutionSuffix}', 15)
module jumpboxVM 'br/public:avm/res/compute/virtual-machine:0.21.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${jumpboxVmName}', 64)
  params: {
    name: take(jumpboxVmName, 15) // Shorten VM name to 15 characters to avoid Azure limits
    vmSize: vmSize ?? 'Standard_DS2_v2'
    location: location
    adminUsername: vmAdminUsername ?? 'JumpboxAdminUser'
    adminPassword: vmAdminPassword ?? 'JumpboxAdminP@ssw0rd1234!'
    tags: tags
    imageReference: {
      publisher: 'microsoft-dsvm'
      offer: 'dsvm-win-2022'
      sku: 'winserver-2022'
      version: 'latest'
    }
    osType: 'Windows'
    osDisk: {
      name: 'osdisk-${jumpboxVmName}'
      managedDisk: {
        // WAF aligned configuration - Use Premium storage for improved SLA (PSRule Azure.VM.Standalone)
        storageAccountType: 'Premium_LRS'
      }
    }
    availabilityZone: -1
    encryptionAtHost: false // Some Azure subscriptions do not support encryption at host
    // WAF aligned configuration - Enable automatic patching with platform management
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    // Assign maintenance configuration for PSRule compliance
    maintenanceConfigurationResourceId: maintenanceConfiguration!.outputs.resourceId
    nicConfigurations: [
      {
        name: 'nic-${jumpboxVmName}'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork!.outputs.jumpboxSubnetResourceId
          }
        ]
        diagnosticSettings: [
          {
            name: 'jumpboxDiagnostics'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
                enabled: true
              }
            ]
          }
        ]
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// ========== Private DNS Zones ========== //
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.dfs.${environment().suffixes.storage}'
  'privatelink.documents.azure.com'
  'privatelink${environment().suffixes.sqlServerHostname}'
  'privatelink.search.windows.net'
]

// DNS Zone Index Constants
var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  storageBlob: 3
  storageQueue: 4
  storageFile: 5
  storageDfs: 6
  cosmosDB: 7
  sqlServer: 8
  search: 9
}

// ===================================================
// DEPLOY PRIVATE DNS ZONES
// - Deploys all zones if no existing Foundry project is used
// - Excludes AI-related zones when using with an existing Foundry project
// ===================================================
@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.8.0' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: 'avm.res.network.private-dns-zone.${split(zone, '.')[1]}'
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetwork!.outputs.name}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
        }
      ]
    }
  }
]

// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access

// ========== User Assigned Identity ========== //
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.3' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== SQL Operations User Assigned Identity ========== //
// Dedicated identity for backend SQL operations with limited permissions (db_datareader, db_datawriter)
var backendUserAssignedIdentityResourceName = 'id-backend-${solutionSuffix}'
module backendUserAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.3' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${backendUserAssignedIdentityResourceName}', 64)
  params: {
    name: backendUserAssignedIdentityResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== AVM WAF ========== //
// ==========AI Foundry and related resources ========== //
// ========== AI Foundry: AI Services ========== //
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai

var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'

// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
// var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'
var aiFoundryAiServicesAiProjectResourceName = 'proj-${solutionSuffix}'
var aiFoundryAIservicesEnabled = true
var aiModelDeployments = [
  {
    name: gptModelName
    format: 'OpenAI'
    model: gptModelName
    sku: {
      name: deploymentType
      capacity: gptDeploymentCapacity
    }
    version: gptModelVersion
    raiPolicyName: 'Microsoft.Default'
  }
  {
    name: embeddingModel
    format: 'OpenAI'
    model: embeddingModel
    sku: {
      name: 'GlobalStandard'
      capacity: embeddingDeploymentCapacity
    }
    version: '2'
    raiPolicyName: 'Microsoft.Default'
  }
]

module aiFoundryAiServices 'modules/ai-services.bicep' = if (aiFoundryAIservicesEnabled) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: aiServiceLocation
    tags: tags
    projectName: aiFoundryAiServicesAiProjectResourceName
    projectDescription: 'AI Foundry Project'
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    customSubDomainName: aiFoundryAiServicesResourceName
    apiProperties: {
      //staticsEnabled: false
    }
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
      bypass: 'AzureServices'
    }
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] } //To create accounts or projects, you must enable a managed identity on your resource
    roleAssignments: [
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
        principalId: backendUserAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee' // Azure AI Developer
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' // Cognitive Services OpenAI User
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee' // Azure AI Developer
        principalId: backendUserAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' // Cognitive Services OpenAI User
        principalId: backendUserAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
    ]
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? ([
          {
            name: 'pep-${aiFoundryAiServicesResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiServicesResourceName}'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'ai-services-dns-zone-cognitiveservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
                }
                {
                  name: 'ai-services-dns-zone-openai'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.openAI]!.outputs.resourceId
                }
                {
                  name: 'ai-services-dns-zone-aiservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.aiServices]!.outputs.resourceId
                }
              ]
            }
          }
        ])
      : []
    deployments: [
      for aiModelDeployment in aiModelDeployments: {
        name: aiModelDeployment.name
        model: {
          format: aiModelDeployment.format
          name: aiModelDeployment.model
          version: aiModelDeployment.version
        }
        raiPolicyName: aiModelDeployment.raiPolicyName
        sku: {
          name: aiModelDeployment.sku.name
          capacity: aiModelDeployment.sku.capacity
        }
      }
    ]
  }
}

// AI Foundry: AI Services Content Understanding
var aiFoundryAiServicesCUResourceName = 'aif-${solutionSuffix}-cu'
var aiServicesNameCu = 'aisa-${solutionSuffix}-cu'
// NOTE: Required version 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' not available in AVM
module cognitiveServicesCu 'br/public:avm/res/cognitive-services/account:0.14.1' = {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesCUResourceName}', 64)
  params: {
    name: aiServicesNameCu
    location: contentUnderstandingLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    sku: 'S0'
    kind: 'AIServices'
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: { systemAssigned: true, userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] } //To create accounts or projects, you must enable a managed identity on your resource
    disableLocalAuth: true
    customSubDomainName: aiServicesNameCu
    apiProperties: {
      // staticsEnabled: false
    }
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? ([
          {
            name: 'pep-${aiFoundryAiServicesCUResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiServicesCUResourceName}'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'ai-services-cu-dns-zone-cognitiveservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
                }
                {
                  name: 'ai-services-cu-dns-zone-openai'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.openAI]!.outputs.resourceId
                }
                {
                  name: 'ai-services-cu-dns-zone-aiservices'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.aiServices]!.outputs.resourceId
                }
              ]
            }
          }
        ])
      : []
    roleAssignments: [
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

// ========== AVM WAF ========== //
// ========== AI Foundry: AI Search ========== //
var aiSearchName = 'srch-${solutionSuffix}'
module searchSearchServices 'br/public:avm/res/search/search-service:0.12.0' = {
  name: take('avm.res.search.search-service.${aiSearchName}', 64)
  params: {
    // Required parameters
    name: aiSearchName
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [
      {
        workspaceResourceId: logAnalyticsWorkspaceResourceId
      }
    ] : null
    disableLocalAuth: true
    hostingMode: 'Default'
    managedIdentities: {
      systemAssigned: true
    }
    networkRuleSet: {
      bypass: 'AzureServices'
      ipRules: []
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '8ebe5a00-799e-43f5-93ac-243d3dce84a7' //'Search Index Data Contributor'
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
        principalId: backendUserAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f' // Search Index Data Reader
        principalId: aiFoundryAiServices.outputs.aiProjectInfo.aiprojectSystemAssignedMIPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0' // Search Service Contributor
        principalId: aiFoundryAiServices.outputs.aiProjectInfo.aiprojectSystemAssignedMIPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    partitionCount: 1
    replicaCount: 3
    sku: 'standard'
    semanticSearch: 'free'
    // Use the deployment tags provided to the template
    tags: tags
    publicNetworkAccess: 'Enabled' //enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: false //enablePrivateNetworking
    ? [
        {
          name: 'pep-${aiSearchName}'
          customNetworkInterfaceName: 'nic-${aiSearchName}'
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.search]!.outputs.resourceId }
            ]
          }
          service: 'searchService'
          subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
        }
      ]
    : []
  }
}

// ========== Search Service to AI Services Role Assignment ========== //
resource searchServiceToAiServicesRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aiSearchName, '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd', aiFoundryAiServicesResourceName)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd') // Cognitive Services OpenAI User
    principalId: searchSearchServices.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
  }
}

resource projectAISearchConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-10-01-preview' = {
  name: '${aiFoundryAiServicesResourceName}/${aiFoundryAiServicesAiProjectResourceName}/${aiSearchName}'
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${aiSearchName}.search.windows.net'
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: searchSearchServices.outputs.resourceId
      location: searchSearchServices.outputs.location
    }
  }
}

// ========== Storage account module ========== //
var storageAccountName = 'st${solutionSuffix}'
module storageAccount 'br/public:avm/res/storage/storage-account:0.31.0' = {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  params: {
    name: storageAccountName
    location: location
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [ userAssignedIdentity!.outputs.resourceId ]
    }
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    enableTelemetry: enableTelemetry
    tags: tags
    enableHierarchicalNamespace: true
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Account Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage File Data Privileged Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices, Logging, Metrics'
      defaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
      virtualNetworkRules: []
    }
    allowSharedKeyAccess: true
    allowBlobPublicAccess: false
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-blob-${solutionSuffix}'
            service: 'blob'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-blob'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob]!.outputs.resourceId
                }
              ]
            }
          }
          {
            name: 'pep-queue-${solutionSuffix}'
            service: 'queue'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-queue'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageQueue]!.outputs.resourceId
                }
              ]
            }
          }
          {
            name: 'pep-file-${solutionSuffix}'
            service: 'file'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-file'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageFile]!.outputs.resourceId
                }
              ]
            }
          }
          {
            name: 'pep-dfs-${solutionSuffix}'
            service: 'dfs'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-dfs'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageDfs]!.outputs.resourceId
                }
              ]
            }
          }
        ]
      : []
    blobServices: {
      corsRules: []
      deleteRetentionPolicyEnabled: false
      changeFeedEnabled: false
      restorePolicyEnabled: false
      isVersioningEnabled: false
      containerDeleteRetentionPolicyEnabled: false
      lastAccessTimeTrackingPolicyEnabled: false
      containers: [
        {
          name: 'data'
        }
      ]
    }
  }
}

//========== Cosmos DB module ========== //
var cosmosDbResourceName = 'cosmos-${solutionSuffix}'
var cosmosDbDatabaseName = 'db_conversation_history'
var collectionName = 'conversations'
module cosmosDb 'br/public:avm/res/document-db/database-account:0.18.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: cosmosDbResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    sqlDatabases: [
      {
        name: cosmosDbDatabaseName
        containers: [
          {
            name: collectionName
            paths: [
              '/userId'
            ]
          }
        ]
      }
    ]
    sqlRoleDefinitions: [
      {
        // Cosmos DB Built-in Data Contributor: https://docs.azure.cn/en-us/cosmos-db/nosql/security/reference-data-plane-roles#cosmos-db-built-in-data-contributor
        roleName: 'Cosmos DB SQL Data Contributor'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        assignments: [{ principalId: backendUserAssignedIdentity.outputs.principalId }]
      }
    ]
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Private Networking
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    }
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${cosmosDbResourceName}'
            customNetworkInterfaceName: 'nic-${cosmosDbResourceName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB]!.outputs.resourceId }
              ]
            }
            service: 'Sql'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
          }
        ]
      : []
    // WAF aligned configuration for Redundancy
    zoneRedundant: enableRedundancy
    capabilitiesToAdd: enableRedundancy ? null : ['EnableServerless']
    enableAutomaticFailover: enableRedundancy
    failoverLocations: enableRedundancy
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: location
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: cosmosDbReplicaLocation
          }
        ]
      : [
          {
            locationName: location
            failoverPriority: 0
            isZoneRedundant: false
          }
        ]
  }
  dependsOn: [storageAccount]
}

// ========== Maintenance Configuration Mapping ========== //
// Map Azure regions to their corresponding SQL Database maintenance configuration names
var sqlMaintenanceConfigMapping = {
  eastus: 'SQL_EastUS_DB_1'
  eastus2: 'SQL_EastUS2_DB_1'
  westus: 'SQL_WestUS_DB_1'
  westus2: 'SQL_WestUS2_DB_1'
  westus3: 'SQL_WestUS3_DB_1'
  centralus: 'SQL_CentralUS_DB_1'
  northcentralus: 'SQL_NorthCentralUS_DB_1'
  southcentralus: 'SQL_SouthCentralUS_DB_1'
  westcentralus: 'SQL_WestCentralUS_DB_1'
  canadacentral: 'SQL_CanadaCentral_DB_1'
  canadaeast: 'SQL_CanadaEast_DB_1'
  northeurope: 'SQL_NorthEurope_DB_1'
  westeurope: 'SQL_WestEurope_DB_1'
  uksouth: 'SQL_UKSouth_DB_1'
  ukwest: 'SQL_UKWest_DB_1'
  francecentral: 'SQL_FranceCentral_DB_1'
  francesouth: 'SQL_FranceSouth_DB_1'
  germanywestcentral: 'SQL_GermanyWestCentral_DB_1'
  switzerlandnorth: 'SQL_SwitzerlandNorth_DB_1'
  swedencentral: 'SQL_SwedenCentral_DB_1'
  eastasia: 'SQL_EastAsia_DB_1'
  southeastasia: 'SQL_SoutheastAsia_DB_1'
  australiaeast: 'SQL_AustraliaEast_DB_1'
  australiasoutheast: 'SQL_AustraliaSoutheast_DB_1'
  centralindia: 'SQL_CentralIndia_DB_1'
  southindia: 'SQL_SouthIndia_DB_1'
  japaneast: 'SQL_JapanEast_DB_1'
  japanwest: 'SQL_JapanWest_DB_1'
  brazilsouth: 'SQL_BrazilSouth_DB_1'
  brazilsoutheast: 'SQL_BrazilSoutheast_DB_1'
  southafricanorth: 'SQL_SouthAfricaNorth_DB_1'
  uaenorth: 'SQL_UAENorth_DB_1'
}

// Determine the maintenance configuration name to use - use location and consider WAF alignment
var defaultMaintenanceConfigName = sqlMaintenanceConfigMapping[secondaryLocation] ?? ''
var shouldConfigureMaintenance = !empty(defaultMaintenanceConfigName)

resource maintenanceWindow 'Microsoft.Maintenance/publicMaintenanceConfigurations@2023-04-01' existing = if (shouldConfigureMaintenance) {
  scope: subscription()
  name: defaultMaintenanceConfigName
}

//========== SQL Database module ========== //
var sqlServerResourceName = 'sql-${solutionSuffix}'
var sqlDbModuleName = 'sqldb-${solutionSuffix}'
module sqlDBModule 'br/public:avm/res/sql/server:0.21.1' = {
  name: take('avm.res.sql.server.${sqlServerResourceName}', 64)
  params: {
    // Required parameters
    name: sqlServerResourceName
    enableTelemetry: enableTelemetry
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: userAssignedIdentity.outputs.name
      principalType: 'Application'
      sid: userAssignedIdentity.outputs.principalId
      tenantId: subscription().tenantId
    }
    connectionPolicy: 'Redirect'
    databases: [
      {
        availabilityZone: -1
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        diagnosticSettings: enableMonitoring
          ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
          : null
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: sqlDbModuleName
        minCapacity: '1'
        sku: {
          name: 'GP_S_Gen5'
          tier: 'GeneralPurpose'
          family: 'Gen5'
          capacity: 2
        }
        // Note: Zone redundancy is not supported for serverless SKUs (GP_S_Gen5)
        zoneRedundant: enableRedundancy
        maintenanceConfigurationId: shouldConfigureMaintenance ? maintenanceWindow.id : null
      }
    ]
    location: secondaryLocation
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
        backendUserAssignedIdentity.outputs.resourceId
      ]
    }
    primaryUserAssignedIdentityResourceId: userAssignedIdentity.outputs.resourceId
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    // WAF aligned configuration - Microsoft Defender for SQL (required for Vulnerability Assessment)
    securityAlertPolicies: enableMonitoring
      ? [
          {
            name: 'Default'
            state: 'Enabled'
            emailAccountAdmins: true
          }
        ]
      : []
    // WAF aligned configuration - SQL Vulnerability Assessment for security monitoring
    vulnerabilityAssessmentsObj: enableMonitoring
      ? {
          name: 'default'
          storageAccountResourceId: storageAccount.outputs.resourceId
          recurringScans: {
            isEnabled: true
            emailSubscriptionAdmins: false
            emails: []
          }
        }
      : null
    firewallRules: (!enablePrivateNetworking)
      ? [
          {
            endIpAddress: '255.255.255.255'
            name: 'AllowSpecificRange'
            startIpAddress: '0.0.0.0'
          }
          {
            endIpAddress: '0.0.0.0'
            name: 'AllowAllWindowsAzureIps'
            startIpAddress: '0.0.0.0'
          }
        ]
      : []
    tags: tags
  }
}

// ========== SQL Server Private Endpoint (separated) ========== //
module sqlDbPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.private-endpoint.sql-${solutionSuffix}', 64)
  params: {
    name: 'pep-sql-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
    customNetworkInterfaceName: 'nic-sql-${solutionSuffix}'
    privateLinkServiceConnections: [
      {
        name: 'pl-sqlserver-${solutionSuffix}'
        properties: {
          privateLinkServiceId: sqlDBModule.outputs.resourceId
          groupIds: ['sqlServer']
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.sqlServer]!.outputs.resourceId
        }
      ]
    }
  }
}

// ========== AVM WAF server farm ========== //
// WAF best practices for Web Application Services: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service
var webServerFarmResourceName = 'asp-${solutionSuffix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.5.0' = {
  name: 'deploy_app_service_plan_serverfarm'
  params: {
    name: webServerFarmResourceName
    tags: tags
    enableTelemetry: enableTelemetry
    location: location
    reserved: true
    kind: 'linux'
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Scalability
    skuName: enableScalability || enableRedundancy ? 'P1v3' : 'B3'
    skuCapacity: 1
    // WAF aligned configuration for Redundancy
    zoneRedundant: false
  }
}

var reactAppLayoutConfig = '''{
  "appConfig": {
    "THREE_COLUMN": {
      "DASHBOARD": 50,
      "CHAT": 33,
      "CHATHISTORY": 17
    },
    "TWO_COLUMN": {
      "DASHBOARD_CHAT": {
        "DASHBOARD": 65,
        "CHAT": 35
      },
      "CHAT_CHATHISTORY": {
        "CHAT": 80,
        "CHATHISTORY": 20
      }
    }
  },
  "charts": [
    {
      "id": "SATISFIED",
      "name": "Satisfied",
      "type": "card",
      "layout": { "row": 1, "column": 1, "height": 11 }
    },
    {
      "id": "TOTAL_CALLS",
      "name": "Total Calls",
      "type": "card",
      "layout": { "row": 1, "column": 2, "span": 1 }
    },
    {
      "id": "AVG_HANDLING_TIME",
      "name": "Average Handling Time",
      "type": "card",
      "layout": { "row": 1, "column": 3, "span": 1 }
    },
    {
      "id": "SENTIMENT",
      "name": "Topics Overview",
      "type": "donutchart",
      "layout": { "row": 2, "column": 1, "width": 40, "height": 44.5 }
    },
    {
      "id": "AVG_HANDLING_TIME_BY_TOPIC",
      "name": "Average Handling Time By Topic",
      "type": "bar",
      "layout": { "row": 2, "column": 2, "row-span": 2, "width": 60 }
    },
    {
      "id": "TOPICS",
      "name": "Trending Topics",
      "type": "table",
      "layout": { "row": 3, "column": 1, "span": 2 }
    },
    {
      "id": "KEY_PHRASES",
      "name": "Key Phrases",
      "type": "wordcloud",
      "layout": { "row": 3, "column": 2, "height": 44.5 }
    }
  ]
}'''
var backendWebSiteResourceName = 'api-${solutionSuffix}'
module webSiteBackend 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${backendWebSiteResourceName}', 64)
  params: {
    name: backendWebSiteResourceName
    tags: tags
    location: location
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        backendUserAssignedIdentity.outputs.resourceId
      ]
    }
    siteConfig: {
      linuxFxVersion: 'DOCKER|${backendContainerRegistryHostname}/${backendContainerImageName}:${backendContainerImageTag}'
      minTlsVersion: '1.2'
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          REACT_APP_LAYOUT_CONFIG: reactAppLayoutConfig
          AZURE_OPENAI_DEPLOYMENT_MODEL: gptModelName
          AZURE_OPENAI_ENDPOINT: 'https://${aiFoundryAiServices.outputs.name}.openai.azure.com/'
          AZURE_OPENAI_API_VERSION: azureOpenAIApiVersion
          AZURE_OPENAI_RESOURCE: aiFoundryAiServices.outputs.name
          AZURE_AI_AGENT_ENDPOINT: aiFoundryAiServices.outputs.aiProjectInfo.apiEndpoint
          AZURE_AI_AGENT_API_VERSION: azureAiAgentApiVersion
          AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME: gptModelName
          USE_CHAT_HISTORY_ENABLED: 'True'
          AZURE_COSMOSDB_ACCOUNT: cosmosDb.outputs.name
          AZURE_COSMOSDB_CONVERSATIONS_CONTAINER: collectionName
          AZURE_COSMOSDB_DATABASE: cosmosDbDatabaseName
          AZURE_COSMOSDB_ENABLE_FEEDBACK: 'True'
          SQLDB_DATABASE: 'sqldb-${solutionSuffix}'
          SQLDB_SERVER: '${sqlDBModule.outputs.name }${environment().suffixes.sqlServerHostname}'
          SQLDB_USER_MID: backendUserAssignedIdentity.outputs.clientId
          AZURE_AI_SEARCH_ENDPOINT: 'https://${aiSearchName}.search.windows.net'
          AZURE_AI_SEARCH_INDEX: 'call_transcripts_index'
          AZURE_AI_SEARCH_CONNECTION_NAME: aiSearchName
          USE_AI_PROJECT_CLIENT: 'True'
          DISPLAY_CHART_DEFAULT: 'False'
          APPLICATIONINSIGHTS_CONNECTION_STRING: enableMonitoring ? applicationInsights!.outputs.connectionString : ''
          DUMMY_TEST: 'True'
          SOLUTION_NAME: solutionSuffix
          APP_ENV: 'Prod'
          AZURE_CLIENT_ID: backendUserAssignedIdentity.outputs.clientId
          AZURE_BASIC_LOGGING_LEVEL: 'INFO'
          AZURE_PACKAGE_LOGGING_LEVEL: 'WARNING'
          AZURE_LOGGING_PACKAGES: ''
        }
        // WAF aligned configuration for Monitoring
        applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Private Networking
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    vnetImagePullEnabled: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webSubnetResourceId : null
    publicNetworkAccess: 'Enabled'
  }
}

// ========== Web App module ========== //
// WAF best practices for Web Application Services: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
//NOTE: AVM module adds 1 MB of overhead to the template. Keeping vanilla resource to save template size.
var webSiteResourceName = 'app-${solutionSuffix}'
module webSiteFrontend 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteResourceName}', 64)
  params: {
    name: webSiteResourceName
    tags: tags
    location: location
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${frontendContainerRegistryHostname}/${frontendContainerImageName}:${frontendContainerImageTag}'
      minTlsVersion: '1.2'
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          APP_API_BASE_URL: 'https://api-${solutionSuffix}.azurewebsites.net'
        }
        applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
      }
    ]
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    vnetImagePullEnabled: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webSubnetResourceId : null
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    publicNetworkAccess: 'Enabled'
  }
}

// ========== Outputs ========== //
@description('Contains Solution Name.')
output solutionName string = solutionSuffix

@description('Contains Resource Group Name.')
output resourceGroupName string = resourceGroup().name

@description('Contains Resource Group Location.')
output resourceGroupLocation string = location

@description('Contains Azure Content Understanding Location.')
output azureContentUnderstandingLocation string = contentUnderstandingLocation

@description('Contains Application Insights Instrumentation Key.')
output appInsightsInstrumentationKey string = enableMonitoring ? applicationInsights!.outputs.instrumentationKey : ''

@description('Contains AI Project Connection String.')
output azureAIProjectConnString string = aiFoundryAiServices.outputs.endpoint

@description('Contains Azure AI Agent API Version.')
output azureAIAgentApiVersion string = azureAiAgentApiVersion

@description('Contains Azure AI Foundry service name.')
output azureAIFoundryName string = aiFoundryAiServices.outputs.name

@description('Contains Azure AI Project name.')
output azureAIProjectName string = aiFoundryAiServices.outputs.aiProjectInfo.name

@description('Contains Azure AI Search service name.')
output azureAISearchName string = aiSearchName

@description('Contains Azure AI Search endpoint URL.')
output azureAISearchEndpoint string = 'https://${aiSearchName}.search.windows.net'

@description('Contains Azure AI Search index name.')
output azureAISearchIndex string = 'call_transcripts_index'

@description('Contains Azure AI Search connection name.')
output azureAISearchConnectionName string = aiSearchName

@description('Contains Azure Cosmos DB account name.')
output azureCosmosDbAccount string = cosmosDb.outputs.name

@description('Contains Azure Cosmos DB conversations container name.')
output azureCosmosDbConversationsContainer string = 'conversations'

@description('Contains Azure Cosmos DB database name.')
output azureCosmosDbDatabase string = 'db_conversation_history'

@description('Contains Azure Cosmos DB feedback enablement setting.')
output azureCosmosDbEnableFeedback string = 'True'

@description('Contains Azure OpenAI deployment model name.')
output azureOpenAIDeploymentModel string = gptModelName

@description('Contains Azure OpenAI deployment model capacity.')
output azureOpenAIDeploymentModelCapacity int = gptDeploymentCapacity

@description('Contains Azure OpenAI endpoint URL.')
output azureOpenAIEndpoint string = 'https://${aiFoundryAiServices.outputs.name}.openai.azure.com/'

@description('Contains Azure OpenAI model deployment type.')
output azureOpenAIModelDeploymentType string = deploymentType

@description('Contains Azure OpenAI embedding model name.')
output azureOpenAIEmbeddingModel string = embeddingModel

@description('Contains Azure OpenAI embedding model capacity.')
output azureOpenAIEmbeddingModelCapacity int = embeddingDeploymentCapacity

@description('Contains Azure OpenAI API version.')
output azureOpenAIApiVersion string = azureOpenAIApiVersion

@description('Contains Content Understanding API version.')
output azureContentUnderstandingApiVersion string = azureContentUnderstandingApiVersion

@description('Contains Azure OpenAI resource name.')
output azureOpenAIResource string = aiFoundryAiServices.outputs.name

@description('Contains React app layout configuration.')
output reactAppLayoutConfig string = reactAppLayoutConfig

@description('Contains SQL database name.')
output sqlDBDatabase string = 'sqldb-${solutionSuffix}'

@description('Contains SQL server name.')
output sqlDBServer string = '${sqlDBModule.outputs.name }${environment().suffixes.sqlServerHostname}'

@description('Display name of the backend API user-assigned managed identity (also used for SQL database access).')
output backendUserMidName string = backendUserAssignedIdentity.outputs.name

@description('Client ID of the backend API user-assigned managed identity (also used for SQL database access).')
output backendUserMid string = backendUserAssignedIdentity.outputs.clientId

@description('Contains AI project client usage setting.')
output useAIProjectClient string = 'False'

@description('Contains chat history enablement setting.')
output useChatHistoryEnabled string = 'True'

@description('Contains default chart display setting.')
output displayChartDefault string = 'False'

@description('Contains Azure AI Agent endpoint URL.')
output azureAiAgentEndpoint string = aiFoundryAiServices.outputs.aiProjectInfo.apiEndpoint

@description('Contains Azure AI Agent model deployment name.')
output azureAiAgentModelDeploymentName string = gptModelName

@description('Contains Azure Container Registry name.')
output acrName string = acrName

@description('Contains Azure environment image tag.')
output azureEnvImageTag string = backendContainerImageTag

@description('Contains Application Insights connection string.')
output applicationInsightsConnectionString string = enableMonitoring ? applicationInsights!.outputs.connectionString : ''

@description('Contains API application URL.')
output apiAppUrl string = 'https://api-${solutionSuffix}.azurewebsites.net'

@description('Contains web application URL.')
output webAppUrl string = 'https://app-${solutionSuffix}.azurewebsites.net'

@description('Name of the Storage Account.')
output storageAccountName string = storageAccount.outputs.name

@description('Name of the Storage Container.')
output storageContainerName string = 'data'

@description('Resource ID of the AI Foundry Project.')
output aiFoundryResourceId string = aiFoundryAIservicesEnabled ? aiFoundryAiServices.outputs.resourceId : ''

@description('Resource ID of the Content Understanding AI Foundry.')
output cuFoundryResourceId string = cognitiveServicesCu.outputs.resourceId

@description('Azure OpenAI Content Understanding endpoint URL.')
output azureOpenAICuEndpoint string = cognitiveServicesCu.outputs.endpoint

@description('Industry Use Case.')
output useCase string = usecase
