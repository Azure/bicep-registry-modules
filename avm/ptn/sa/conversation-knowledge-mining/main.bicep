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
@description('Optional. Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions).')
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
@description('Optional. Location for the Content Understanding service deployment.')
@allowed(['swedencentral', 'australiaeast'])
@metadata({
  azd: {
    type: 'location'
  }
})
param contentUnderstandingLocation string = 'swedencentral'

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

@description('Optional. Version of the OpenAI.')
param azureOpenAIApiVersion string = '2025-01-01-preview'

@description('Optional. Version of AI Agent API.')
param azureAiAgentApiVersion string = '2025-05-01'

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
param backendContainerImageTag string = 'latest_waf_2025-11-10_1006'

@description('Optional. The Container Registry hostname where the docker images for the frontend are located.')
param frontendContainerRegistryHostname string = 'kmcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the frontend.')
param frontendContainerImageName string = 'km-app'

@description('Optional. The Container Image Tag to deploy on the frontend.')
param frontendContainerImageTag string = 'latest_waf_2025-11-10_1006'

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

@description('Optional. Enable purge protection for the Key Vault.')
param enablePurgeProtection bool = false

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminUsername string = ''

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminPassword string = ''

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.')
param vmSize string = 'Standard_DS2_v2'

@description('Optional. created by user name.')
param createdBy string = contains(deployer(), 'userPrincipalName')
  ? split(deployer().userPrincipalName, '@')[0]
  : deployer().objectId

@maxLength(5)
@description('Optional. A unique text value for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
param solutionUniqueText string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)
var solutionLocation = empty(location) ? resourceGroup().location : location
var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueText}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))

var baseUrl = 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/main/'

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

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2024-07-01' = {
  name: 'default'
  properties: {
    tags: union(
      reference(resourceGroup().id, '2021-04-01', 'Full').tags ?? {},
      {
        ...resourceGroup().tags
        TemplateName: 'KM-Generic'
        Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
        CreatedBy: createdBy
        DeploymentName: deployment().name
      },
      tags
    )
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
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.14.0' = if (enableMonitoring) {
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
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspace!.outputs.resourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
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
    logAnalyticsWorkspaceId: logAnalyticsWorkspace!.outputs.resourceId
    resourceSuffix: solutionSuffix
    enableTelemetry: enableTelemetry
  }
}

// ========== Bastion Host and Jumpbox VM ========== //
// Azure Bastion Host
var bastionHostName = 'bas-${solutionSuffix}'
module bastionHost 'br/public:avm/res/network/bastion-host:0.8.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionHostName}', 64)
  params: {
    name: bastionHostName
    skuName: 'Standard'
    location: location
    virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
    diagnosticSettings: [
      {
        name: 'bastionDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
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
    adminUsername: empty(vmAdminUsername) ? 'JumpboxAdminUser' : vmAdminUsername
    adminPassword: empty(vmAdminPassword) ? 'JumpboxAdminP@ssw0rd1234!' : vmAdminPassword
    tags: tags
    availabilityZone: 1
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
        storageAccountType: 'Standard_LRS'
      }
    }
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
            workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
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
  'privatelink.vaultcore.azure.net'
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
  keyVault: 8
  sqlServer: 9
  search: 10
}

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

// ========== User Assigned Identity ========== //
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
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
module backendUserAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${backendUserAssignedIdentityResourceName}', 64)
  params: {
    name: backendUserAssignedIdentityResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== Key Vault Module ========== //
var keyVaultName = 'kv-${solutionSuffix}'
module keyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('avm.res.key-vault.vault.${keyVaultName}', 64)
  params: {
    name: keyVaultName
    location: location
    tags: tags
    sku: 'premium'
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
    enablePurgeProtection: enablePurgeProtection
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : []
    // WAF aligned configuration for Private Networking
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${keyVaultName}'
            customNetworkInterfaceName: 'nic-${keyVaultName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.keyVault]!.outputs.resourceId }
              ]
            }
            service: 'vault'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
          }
        ]
      : []
    // WAF aligned configuration for Role-based Access Control
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Key Vault Administrator'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
      }
    ]
    secrets: [
      {
        name: 'AZURE-COSMOSDB-ACCOUNT'
        value: cosmosDb.outputs.name
      }
      {
        name: 'AZURE-COSMOSDB-ACCOUNT-KEY'
        value: cosmosDb.outputs.primaryReadWriteKey
      }
      {
        name: 'AZURE-COSMOSDB-DATABASE'
        value: cosmosDbDatabaseName
      }
      {
        name: 'AZURE-COSMOSDB-CONVERSATIONS-CONTAINER'
        value: collectionName
      }
      {
        name: 'AZURE-COSMOSDB-ENABLE-FEEDBACK'
        value: 'True'
      }
      {
        name: 'ADLS-ACCOUNT-NAME'
        value: storageAccountName
      }
      {
        name: 'ADLS-ACCOUNT-CONTAINER'
        value: 'data'
      }
      {
        name: 'ADLS-ACCOUNT-KEY'
        value: storageAccount.outputs.primaryAccessKey
      }
      {
        name: 'AZURE-SEARCH-ENDPOINT'
        value: 'https://${searchSearchServices.outputs.name}.search.windows.net'
      }
      {
        name: 'AZURE-SEARCH-SERVICE'
        value: searchSearchServices.outputs.name
      }
      {
        name: 'AZURE-OPENAI-ENDPOINT'
        value: 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'
      }
      {
        name: 'AZURE-AI-AGENT-ENDPOINT'
        value: 'https://${aiFoundryAiServicesResourceName}.services.ai.azure.com/api/projects/${aiFoundryAiProjectResourceName}'
      }
      {
        name: 'COG-SERVICES-ENDPOINT'
        value: aiFoundryAiServices.outputs.endpoint
      }
      {
        name: 'AZURE-OPENAI-SEARCH-PROJECT'
        value: aiFoundryAiProjectResourceName
      }
      {
        name: 'AZURE-OPENAI-INFERENCE-ENDPOINT'
        value: ''
      }
      {
        name: 'AZURE-OPENAI-DEPLOYMENT-MODEL'
        value: gptModelName
      }
      {
        name: 'AZURE-OPENAI-PREVIEW-API-VERSION'
        value: azureOpenAIApiVersion
      }
      {
        name: 'AZURE-OPENAI-CU-ENDPOINT'
        value: 'https://${aiServicesNameCu}.openai.azure.com/'
      }
      {
        name: 'AZURE-OPENAI-CU-VERSION'
        value: '?api-version=2024-12-01-preview'
      }
      {
        name: 'AZURE-SEARCH-INDEX'
        value: 'transcripts_index'
      }
      {
        name: 'COG-SERVICES-NAME'
        value: aiFoundryAiServicesResourceName
      }
      {
        name: 'AZURE-OPENAI-INFERENCE-ENDPOINT'
        value: ''
      }
      {
        name: 'AZURE-OPENAI-INFERENCE-ENDPOINT'
        value: ''
      }
      {
        name: 'AZURE-OPENAI-EMBEDDING-MODEL'
        value: embeddingModel
      }
      {
        name: 'SQLDB-SERVER'
        value: 'sql-${solutionSuffix}${environment().suffixes.sqlServerHostname}'
      }
      {
        name: 'SQLDB-DATABASE'
        value: 'sqldb-${solutionSuffix}'
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// ==========AI Foundry and related resources ========== //
var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'
var aiFoundryAiProjectResourceName = 'proj-${solutionSuffix}'
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

module aiFoundryAiServices 'modules/ai-services.bicep' = {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: aiServiceLocation
    tags: tags
    projectName: aiFoundryAiProjectResourceName
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
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
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
module cognitiveServicesCu 'br/public:avm/res/cognitive-services/account:0.14.0' = {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesCUResourceName}', 64)
  params: {
    name: aiServicesNameCu
    location: contentUnderstandingLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    sku: 'S0'
    kind: 'AIServices'
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] } //To create accounts or projects, you must enable a managed identity on your resource
    disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
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

// ========== AI Foundry: AI Search ========== //
var aiSearchName = 'srch-${solutionSuffix}'
module searchSearchServices 'br/public:avm/res/search/search-service:0.11.1' = {
  name: take('avm.res.search.search-service.${aiSearchName}', 64)
  params: {
    name: aiSearchName
    enableTelemetry: enableTelemetry
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    diagnosticSettings: enableMonitoring
      ? [
          {
            workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
          }
        ]
      : null
    disableLocalAuth: false
    hostingMode: 'default'
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
        principalId: aiFoundryAiServices.outputs.aiProjectInfo.?aiprojectSystemAssignedMIPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0' // Search Service Contributor
        principalId: aiFoundryAiServices.outputs.aiProjectInfo.?aiprojectSystemAssignedMIPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    partitionCount: 1
    replicaCount: enableScalability ? 3 : 1
    sku: enableScalability ? 'standard' : 'basic'
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
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
    ) // Cognitive Services OpenAI User
    principalId: searchSearchServices.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
  }
}

resource projectAISearchConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-07-01-preview' = {
  name: '${aiFoundryAiServicesResourceName}/${aiFoundryAiProjectResourceName}/${aiSearchName}'
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
module storageAccount 'br/public:avm/res/storage/storage-account:0.29.0' = {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  params: {
    name: storageAccountName
    location: location
    // Use only user-assigned identities
    managedIdentities: { systemAssigned: false, userAssignedResourceIds: [] }
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
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
      containers: [
        {
          name: 'data'
        }
        // WAF aligned configuration - Container for SQL Vulnerability Assessment scans
        {
          name: 'sqlvascans'
          publicAccess: 'None'
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
        roleName: 'Cosmos DB SQL Data Contributor'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        assignments: [{ principalId: backendUserAssignedIdentity.outputs.principalId }]
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
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
    zoneRedundant: enableRedundancy ? true : false
    capabilitiesToAdd: enableRedundancy ? null : ['EnableServerless']
    enableAutomaticFailover: enableRedundancy ? true : false
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

// Determine the maintenance configuration name to use - use solutionLocation and consider WAF alignment
var defaultMaintenanceConfigName = sqlMaintenanceConfigMapping[?solutionLocation] ?? ''
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
    name: sqlServerResourceName
    enableTelemetry: enableTelemetry
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
          ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }]
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
        zoneRedundant: enableRedundancy
        maintenanceConfigurationId: shouldConfigureMaintenance ? maintenanceWindow.id : null
      }
    ]
    location: solutionLocation
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
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.sqlServer]!.outputs.resourceId
                }
              ]
            }
            service: 'sqlServer'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            tags: tags
          }
        ]
      : []
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
  dependsOn: [
    keyVault
    maintenanceWindow
  ]
}

//========== Deployment script to upload data ========== //
module uploadFiles 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: take('avm.res.resources.deployment-script.uploadFiles', 64)
  params: {
    kind: 'AzureCLI'
    name: 'copy_demo_Data-${solutionUniqueText}'
    azCliVersion: '2.52.0'
    cleanupPreference: 'Always'
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    retentionInterval: 'P1D'
    runOnce: true
    primaryScriptUri: '${baseUrl}infra/scripts/copy_kb_files.sh'
    arguments: '${storageAccount.outputs.name} ${baseUrl} ${userAssignedIdentity.outputs.clientId}'
    storageAccountResourceId: storageAccount.outputs.resourceId
    subnetResourceIds: enablePrivateNetworking
      ? [
          virtualNetwork!.outputs.deploymentScriptsSubnetResourceId
        ]
      : null
    tags: tags
    timeout: 'PT1H'
    enableTelemetry: enableTelemetry
  }
}

//========== Deployment script to create index ========== //
module createIndex 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: take('avm.res.resources.deployment-script.createIndex', 64)
  params: {
    kind: 'AzureCLI'
    name: 'create_search_indexes-${solutionUniqueText}'
    azCliVersion: '2.52.0'
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    runOnce: true
    primaryScriptUri: '${baseUrl}infra/scripts/run_create_index_scripts.sh'
    arguments: '${baseUrl} ${keyVault.outputs.name} ${userAssignedIdentity.outputs.clientId}'
    tags: tags
    timeout: 'PT1H'
    retentionInterval: 'P1D'
    cleanupPreference: 'OnSuccess'
    storageAccountResourceId: storageAccount.outputs.resourceId
    subnetResourceIds: enablePrivateNetworking
      ? [
          virtualNetwork!.outputs.deploymentScriptsSubnetResourceId
        ]
      : null
    enableTelemetry: enableTelemetry
  }
  dependsOn: [sqlDBModule, uploadFiles]
}

var databaseRoles = [
  'db_datareader'
  'db_datawriter'
]
//========== Deployment script to create Sql User and Role  ========== //
module createSqlUserAndRole 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: take('avm.res.resources.deployment-script.createSqlUserAndRole', 64)
  params: {
    kind: 'AzurePowerShell'
    name: 'create_sql_user_and_role-${solutionUniqueText}'
    azPowerShellVersion: '11.0'
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    runOnce: true
    arguments: join(
      [
        '-SqlServerName \'${sqlServerResourceName}\''
        '-SqlDatabaseName \'${sqlDbModuleName}\''
        '-ClientId \'${backendUserAssignedIdentity.outputs.clientId}\''
        '-DisplayName \'${backendUserAssignedIdentity.outputs.name}\''
        '-DatabaseRoles \'${join(databaseRoles, ',')}\''
      ],
      ' '
    )
    primaryScriptUri: '${baseUrl}infra/scripts/add_user_scripts/create-sql-user-and-role.ps1'
    tags: tags
    timeout: 'PT1H'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
    storageAccountResourceId: storageAccount.outputs.resourceId
    subnetResourceIds: enablePrivateNetworking
      ? [
          virtualNetwork!.outputs.deploymentScriptsSubnetResourceId
        ]
      : null
    enableTelemetry: enableTelemetry
  }
  dependsOn: [sqlDBModule]
}

// ========== AVM WAF server farm ========== //
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
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    skuName: enableScalability || enableRedundancy ? 'P1v3' : 'B3'
    skuCapacity: enableScalability ? 3 : 1
    zoneRedundant: enableRedundancy ? true : false
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
        }
        applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    vnetImagePullEnabled: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webSubnetResourceId : null
    publicNetworkAccess: 'Enabled'
  }
}

// ========== Web App module ========== //
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
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    publicNetworkAccess: 'Enabled'
  }
}

// ========== Outputs ========== //
@description('Contains Resource Group Name.')
output resourceGroupName string = resourceGroup().name

@description('Contains API application URL.')
output apiAppUrl string = 'https://api-${solutionSuffix}.azurewebsites.net'

@description('Contains web application URL.')
output webAppUrl string = 'https://app-${solutionSuffix}.azurewebsites.net'
