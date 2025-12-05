// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Build Your Own Copilot Solution Accelerator'
metadata description = '''This module deploys a comprehensive Build Your Own Copilot solution accelerator with Azure AI Services, CosmosDB, SQL Database, Key Vault, Storage Account, Azure AI Search, and a containerized web application. The solution includes AI Foundry services for GPT and embedding models, supporting both private and public networking configurations with optional WAF-aligned features for monitoring, scalability, and redundancy.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Build-your-own-copilot-Solution-Accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

@minLength(3)
@maxLength(20)
@description('Optional. A unique prefix for all resources in this deployment. This should be 3-20 characters long.')
param solutionName string = 'clientadvisor'

@description('Optional. CosmosDB Location.')
param cosmosLocation string = 'eastus2'

@description('Optional. CosmosDB Replica Location.')
param cosmosReplicaLocation string = 'canadacentral'

@minLength(1)
@description('Optional. GPT model deployment type.')
@allowed([
  'Standard'
  'GlobalStandard'
])
param gptModelDeploymentType string = 'GlobalStandard'

@minLength(1)
@description('Optional. Name of the GPT model to deploy.')
@allowed([
  'gpt-4o-mini'
])
param gptModelName string = 'gpt-4o-mini'

@description('Optional. Version of the GPT model to deploy.')
param gptModelVersion string = '2024-07-18'

@description('Optional. Version of the GPT model to deploy.')
param embeddingModelVersion string = '2'

@description('Optional. API version for the Azure OpenAI service.')
param azureOpenaiAPIVersion string = '2025-04-01-preview'

@minValue(10)
@description('Optional. Capacity of the GPT deployment.')
param gptModelCapacity int = 200

@minLength(1)
@description('Optional. Name of the Text Embedding model to deploy.')
@allowed([
  'text-embedding-ada-002'
])
param embeddingModel string = 'text-embedding-ada-002'

@minValue(10)
@description('Optional. Capacity of the Embedding Model deployment.')
param embeddingDeploymentCapacity int = 80

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
      'OpenAI.GlobalStandard.gpt-4o-mini,200'
      'OpenAI.GlobalStandard.text-embedding-ada-002,80'
    ]
  }
})
@description('Required. Location for AI Foundry deployment. This is the location where the AI Foundry resources will be deployed.')
param azureAiServiceLocation string

@description('Optional. Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions).')
param location string = resourceGroup().location
var solutionLocation = empty(location) ? resourceGroup().location : location

@maxLength(5)
@description('Optional. A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
@secure()
param solutionUniqueToken string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueToken}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))

@description('Optional. Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enablePrivateNetworking bool = false

@description('Optional. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. The Container Registry hostname where the docker images for the frontend are located.')
param containerRegistryHostname string = 'bycwacontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the webapp.')
param containerImageName string = 'byc-wa-app'

@description('Optional. The Container Image Tag to deploy on the webapp.')
param imageTag string = 'latest_waf_2025-11-03_914'

@description('Optional. Enable purge protection for the Key Vault.')
param enablePurgeProtection bool = false

var appEnvironment = 'Prod'
var azureSearchIndex = 'transcripts_index'
var azureSearchUseSemanticSearch = 'True'
var azureSearchSemanticSearchConfig = 'my-semantic-config'
var azureSearchTopK = '5'
var azureSearchContentColumns = 'content'
var azureSearchFilenameColumn = 'chunk_id'
var azureSearchTitleColumn = 'client_id'
var azureSearchUrlColumn = 'sourceurl'
var azureOpenAITemperature = '0'
var azureOpenAITopP = '1'
var azureOpenAIMaxTokens = '1000'
var azureOpenAIStopSequence = '\n'
var azureOpenAISystemMessage = '''You are a helpful Wealth Advisor assistant'''
var azureOpenAIStream = 'True'
var azureSearchQueryType = 'simple'
var azureSearchVectorFields = 'contentVector'
var azureSearchPermittedGroupsField = ''
var azureSearchStrictness = '3'
var azureSearchEnableInDomain = 'False' // Set to 'True' if you want to enable in-domain search
var azureCosmosDbEnableFeedback = 'True'
var useInternalStream = 'True'
var useAIProjectClientFlag = 'False'
var sqlServerFqdn = 'sql-${solutionSuffix}${environment().suffixes.sqlServerHostname}'

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.')
param vmSize string?

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminUsername string?

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminPassword string?

var functionAppSqlPrompt = '''Generate a valid T-SQL query to find {query} for tables and columns provided below:
   1. Table: Clients
   Columns: ClientId, Client, Email, Occupation, MaritalStatus, Dependents
   2. Table: InvestmentGoals
   Columns: ClientId, InvestmentGoal
   3. Table: Assets
   Columns: ClientId, AssetDate, Investment, ROI, Revenue, AssetType
   4. Table: ClientSummaries
   Columns: ClientId, ClientSummary
   5. Table: InvestmentGoalsDetails
   Columns: ClientId, InvestmentGoal, TargetAmount, Contribution
   6. Table: Retirement
   Columns: ClientId, StatusDate, RetirementGoalProgress, EducationGoalProgress
   7. Table: ClientMeetings
   Columns: ClientId, ConversationId, Title, StartTime, EndTime, Advisor, ClientEmail
   Always use the Investment column from the Assets table as the value.
   Assets table has snapshots of values by date. Do not add numbers across different dates for total values.
   Do not use client name in filters.
   Do not include assets values unless asked for.
   ALWAYS use ClientId = {clientid} in the query filter.
   ALWAYS select Client Name (Column: Client) in the query.
   Query filters are IMPORTANT. Add filters like AssetType, AssetDate, etc. if needed.
   When answering scheduling or time-based meeting questions, always use the StartTime column from ClientMeetings table. Use correct logic to return the most recent past meeting (last/previous) or the nearest future meeting (next/upcoming), and ensure only StartTime column is used for meeting timing comparisons.
   For asset values: If the question is about "asset value", "total asset value", "portfolio value", or "AUM" → ALWAYS return the SUM of the latest investments (do not return individual rows). If the question is about "current asset value" or "current investment value" → return all latest investments without SUM.
   For trend queries: If the question contains "how did change", "over the last", "trend", or "progression" → return time series data for the requested period with SUM for each time period and show chronological progression.
   Only return the generated SQL query. Do not return anything else.'''

var functionAppCallTranscriptSystemPrompt = '''You are an assistant who supports wealth advisors in preparing for client meetings.
  You have access to the client's past meeting call transcripts.
  When answering questions, especially summary requests, provide a detailed and structured response that includes key topics, concerns, decisions, and trends.
  If no data is available, state 'No relevant data found for previous meetings.'''

var functionAppStreamTextSystemPrompt = '''The currently selected client's name is '{SelectedClientName}'. Treat any case-insensitive or partial mention as referring to this client.
  If the user mentions no name, assume they are asking about '{SelectedClientName}'.
  If the user references a name that clearly differs from '{SelectedClientName}' or comparing with other clients, respond only with: 'Please only ask questions about the selected client or select another client.' Otherwise, provide thorough answers for every question using only data from SQL or call transcripts.'
  If no data is found, respond with 'No data found for that client.' Remove any client identifiers from the final response.
  Always send clientId as '{client_id}'.'''

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

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

var allTags = union(
  {
    'azd-env-name': solutionName
  },
  tags
)

@description('Optional. Tag, Created by user name.')
param createdBy string = contains(deployer(), 'userPrincipalName')
  ? split(deployer().userPrincipalName, '@')[0]
  : deployer().objectId

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags: {
      ...resourceGroup().tags
      ...tags
      TemplateName: 'Client Advisor'
      Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
      CreatedBy: createdBy
      DeploymentName: deployment().name
    }
  }
}

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// WAF PSRules for Log Analytics: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#azure-monitor-logs
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.13.0' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: allTags
    location: solutionLocation
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
            tags: allTags
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
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    tags: allTags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    // WAF aligned configuration - Disable local authentication to enforce Azure AD authentication
    disableLocalAuth: true
    flowType: 'Bluefield'
    // WAF aligned configuration for Monitoring
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspace!.outputs.resourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
  }
}

// ========== User Assigned Identity ========== //
// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: solutionLocation
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ========== SQL Operations User Assigned Identity ========== //
// Dedicated identity for backend SQL operations with limited permissions (db_datareader, db_datawriter)
var sqlUserAssignedIdentityResourceName = 'id-sql-${solutionSuffix}'
module sqlUserAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${sqlUserAssignedIdentityResourceName}', 64)
  params: {
    name: sqlUserAssignedIdentityResourceName
    location: solutionLocation
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ========== Virtual Network and Networking Components ========== //

// Virtual Network with NSGs and Subnets
module virtualNetwork 'modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtualNetwork.${solutionSuffix}', 64)
  params: {
    name: 'vnet-${solutionSuffix}'
    addressPrefixes: ['10.0.0.0/20'] // 4096 addresses (enough for 8 /23 subnets or 16 /24)
    location: solutionLocation
    tags: allTags
    logAnalyticsWorkspaceId: logAnalyticsWorkspace!.outputs.resourceId
    resourceSuffix: solutionSuffix
    enableTelemetry: enableTelemetry
  }
}

// Azure Bastion Host
var bastionHostName = 'bas-${solutionSuffix}'
module bastionHost 'br/public:avm/res/network/bastion-host:0.8.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionHostName}', 64)
  params: {
    name: bastionHostName
    skuName: 'Standard'
    location: solutionLocation
    virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
    diagnosticSettings: enableMonitoring
      ? [
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
      : []
    tags: allTags
    enableTelemetry: enableTelemetry
    publicIPAddressObject: {
      name: 'pip-${bastionHostName}'
    }
  }
}

// ========== VM Maintenance Configuration Mapping ========== //

// Jumpbox Virtual Machine
var jumpboxVmName = take('vm-jumpbox-${solutionSuffix}', 15)
module jumpboxVM 'br/public:avm/res/compute/virtual-machine:0.21.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${jumpboxVmName}', 64)
  params: {
    name: take(jumpboxVmName, 15) // Shorten VM name to 15 characters to avoid Azure limits
    vmSize: vmSize ?? 'Standard_DS2_v2'
    location: solutionLocation
    adminUsername: vmAdminUsername ?? 'JumpboxAdminUser'
    // WAF aligned configuration - Use provided password or generate a secure unique password
    adminPassword: vmAdminPassword
    tags: allTags
    // WAF aligned configuration for Redundancy - use availability zone when redundancy is enabled
    availabilityZone: enableRedundancy ? 1 : -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    // WAF aligned configuration - Enable automatic patching with platform management
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    osDisk: {
      name: 'osdisk-${jumpboxVmName}'
      managedDisk: {
        // WAF aligned configuration - use Premium storage for better SLA when redundancy is enabled
        storageAccountType: enableRedundancy ? 'Premium_LRS' : 'Standard_LRS'
      }
    }
    encryptionAtHost: false // Some Azure subscriptions do not support encryption at host
    // WAF aligned configuration - VM maintenance configuration for reduced unplanned disruptions
    maintenanceConfigurationResourceId: maintenanceConfiguration.outputs.resourceId

    nicConfigurations: [
      {
        name: 'nic-${jumpboxVmName}'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork!.outputs.jumpboxSubnetResourceId
          }
        ]
        diagnosticSettings: enableMonitoring
          ? [
              {
                name: 'jumpboxNicDiagnostics'
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
          : []
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.3.2' = if (enablePrivateNetworking) {
  name: take('${jumpboxVmName}-jumpbox-maintenance-config', 64)
  params: {
    name: 'mc-${jumpboxVmName}'
    location: solutionLocation
    tags: allTags
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

// ========== Private DNS Zones ========== //
var privateDnsZones = [
  'privatelink.documents.azure.com'
  'privatelink.search.windows.net'
  'privatelink${environment().suffixes.sqlServerHostname}'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.azurewebsites.net'
]

// DNS Zone Index Constants
var dnsZoneIndex = {
  cosmosDB: 0
  searchService: 1
  sqlServer: 2
  storageBlob: 3
  storageQueue: 4
  storageFile: 5
  cognitiveServices: 6
  openAI: 7
  aiServices: 8
  keyVault: 9
  appService: 10
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
      tags: allTags
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

// ==========Key Vault Module ========== //
var keyVaultName = 'KV-${solutionSuffix}'
module keyvault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('avm.res.key-vault.vault.${keyVaultName}', 64)
  params: {
    name: keyVaultName
    location: solutionLocation
    tags: allTags
    sku: 'standard'
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: enablePurgeProtection
    softDeleteRetentionInDays: 7
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
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
        principalId: sqlUserAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Key Vault Secrets User'
      }
    ]
    secrets: [
      {
        name: 'SQLDB-SERVER'
        value: sqlServerFqdn
      }
      {
        name: 'SQLDB-DATABASE'
        value: sqlDbName
      }
      {
        name: 'AZURE-OPENAI-PREVIEW-API-VERSION'
        value: azureOpenaiAPIVersion
      }
      {
        name: 'AZURE-OPENAI-ENDPOINT'
        value: aiFoundryAiServices.outputs.openaiEndpoint
      }
      {
        name: 'AZURE-OPENAI-EMBEDDING-MODEL'
        value: embeddingModel
      }
      {
        name: 'AZURE-SEARCH-INDEX'
        value: azureSearchIndex
      }
      {
        name: 'AZURE-SEARCH-ENDPOINT'
        value: 'https://${aiSearchName}.search.windows.net'
      }
      {
        name: 'AZURE-AI-AGENT-ENDPOINT'
        value: aiFoundryAiServices.outputs.aiProjectInfo.?apiEndpoint ?? 'https://${aiFoundryAiServicesResourceName}.cognitiveservices.azure.com/'
      }
    ]
    enableTelemetry: enableTelemetry
  }
  dependsOn: enableMonitoring
    ? [
        aiFoundryAiServices
        logAnalyticsWorkspace
      ]
    : [
        aiFoundryAiServices
      ]
}

// ========== AI Foundry: AI Services ========== //
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai

var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'
// AI Project resource id: /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.CognitiveServices/accounts/<ai-services-name>/projects/<project-name>

// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM

var aiFoundryAiServicesAiProjectResourceName = 'proj-${solutionSuffix}'
var aiFoundryAiServicesModelDeployment = {
  format: 'OpenAI'
  name: gptModelName
  version: gptModelVersion
  sku: {
    name: gptModelDeploymentType
    capacity: gptModelCapacity
  }
  raiPolicyName: 'Microsoft.Default'
}

var aiFoundryAiServicesEmbeddingModel = {
  name: embeddingModel
  version: embeddingModelVersion
  sku: {
    name: 'GlobalStandard'
    capacity: embeddingDeploymentCapacity
  }
  raiPolicyName: 'Microsoft.Default'
}

module aiFoundryAiServices 'modules/ai-services.bicep' = {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: azureAiServiceLocation
    tags: allTags
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
    }
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] } //To create accounts or projects, you must enable a managed identity on your resource
    roleAssignments: [
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
        principalId: userAssignedIdentity.outputs.principalId
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
      {
        name: aiFoundryAiServicesModelDeployment.name
        model: {
          format: aiFoundryAiServicesModelDeployment.format
          name: aiFoundryAiServicesModelDeployment.name
          version: aiFoundryAiServicesModelDeployment.version
        }
        raiPolicyName: aiFoundryAiServicesModelDeployment.raiPolicyName
        sku: {
          name: aiFoundryAiServicesModelDeployment.sku.name
          capacity: aiFoundryAiServicesModelDeployment.sku.capacity
        }
      }
      {
        name: aiFoundryAiServicesEmbeddingModel.name
        model: {
          format: 'OpenAI'
          name: aiFoundryAiServicesEmbeddingModel.name
          version: aiFoundryAiServicesEmbeddingModel.version
        }
        raiPolicyName: aiFoundryAiServicesEmbeddingModel.raiPolicyName
        sku: {
          name: aiFoundryAiServicesEmbeddingModel.sku.name
          capacity: aiFoundryAiServicesEmbeddingModel.sku.capacity
        }
      }
    ]
  }
}

//========== AVM WAF ========== //
//========== Cosmos DB module ========== //
var cosmosDbResourceName = 'cosmos-${solutionSuffix}'
var cosmosDbDatabaseName = 'db_conversation_history'
var collectionName = 'conversations'
module cosmosDb 'br/public:avm/res/document-db/database-account:0.18.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: cosmosDbResourceName
    location: cosmosLocation
    tags: allTags
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
        assignments: [{ principalId: userAssignedIdentity.outputs.principalId }]
      }
    ]
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
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
    zoneRedundant: enableRedundancy ? true : false
    capabilitiesToAdd: enableRedundancy ? null : ['EnableServerless']
    enableAutomaticFailover: enableRedundancy ? true : false
    failoverLocations: enableRedundancy
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: cosmosLocation
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: cosmosReplicaLocation
          }
        ]
      : [
          {
            locationName: solutionLocation
            failoverPriority: 0
            isZoneRedundant: enableRedundancy
          }
        ]
  }
}

// ========== AVM WAF ========== //
// ========== Storage account module ========== //
var storageAccountName = 'st${solutionSuffix}'
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.29.0' = {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  params: {
    name: storageAccountName
    location: solutionLocation
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    tags: allTags
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    // WAF aligned configuration - Disable shared key access to enforce Azure AD authentication
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    enableHierarchicalNamespace: true
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    // WAF aligned networking
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    allowBlobPublicAccess: false
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    // Private endpoints for blob and queue
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-blob-${solutionSuffix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-blob'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob]!.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            service: 'blob'
          }
          {
            name: 'pep-queue-${solutionSuffix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-queue'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageQueue]!.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            service: 'queue'
          }
        ]
      : []
    blobServices: {
      corsRules: []
      deleteRetentionPolicyEnabled: true
      deleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
      containers: [
        {
          name: 'data'
          publicAccess: 'None'
          denyEncryptionScopeOverride: false
          defaultEncryptionScope: '$account-encryption-key'
        }
        // WAF aligned configuration - Container for SQL Vulnerability Assessment scans
        {
          name: 'sqlvascans'
          publicAccess: 'None'
          denyEncryptionScopeOverride: false
          defaultEncryptionScope: '$account-encryption-key'
        }
      ]
    }
  }
}

// working version of saving storage account secrets in key vault using AVM module
module saveStorageAccountSecretsInKeyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('saveStorageAccountSecretsInKeyVault.${keyVaultName}', 64)
  params: {
    name: keyvault.outputs.name
    enablePurgeProtection: enablePurgeProtection
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enableTelemetry: enableTelemetry
    secrets: [
      {
        name: 'ADLS-ACCOUNT-NAME'
        value: avmStorageAccount.outputs.name
      }
      {
        name: 'ADLS-ACCOUNT-CONTAINER'
        value: 'data'
      }
      // WAF aligned configuration - Removed ADLS-ACCOUNT-KEY since allowSharedKeyAccess is disabled
      // The application will use managed identity for storage authentication instead
    ]
  }
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

// ========== AVM WAF ========== //
// ========== SQL module ========== //
var sqlDbName = 'sqldb-${solutionSuffix}'
module sqlDBModule 'br/public:avm/res/sql/server:0.21.1' = {
  name: take('avm.res.sql.server.${sqlDbName}', 64)
  params: {
    // Required parameters
    name: 'sql-${solutionSuffix}'
    // Non-required parameters
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
        // WAF aligned configuration - always configure maintenance window when available
        maintenanceConfigurationId: shouldConfigureMaintenance ? maintenanceWindow.id : null
        zoneRedundant: enableRedundancy
        // When enableRedundancy is true (zoneRedundant=true), set availabilityZone to -1
        // to let Azure automatically manage zone placement across multiple zones.
        // When enableRedundancy is false, also use -1 (no specific zone assignment).
        availabilityZone: -1
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        diagnosticSettings: enableMonitoring
          ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }]
          : null
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: 'sqldb-${solutionSuffix}'
        minCapacity: '1'
        sku: {
          name: 'GP_S_Gen5'
          tier: 'GeneralPurpose'
          family: 'Gen5'
          capacity: 2
        }
      }
    ]
    location: solutionLocation
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    primaryUserAssignedIdentityResourceId: userAssignedIdentity.outputs.resourceId
    // WAF aligned configuration - Microsoft Defender for SQL (required for Vulnerability Assessment)
    securityAlertPolicies: [
      {
        name: 'Default'
        state: 'Enabled'
        emailAccountAdmins: false
      }
    ]
    // WAF aligned configuration - SQL Vulnerability Assessment for security monitoring
    vulnerabilityAssessmentsObj: {
      name: 'default'
      storageAccountResourceId: avmStorageAccount.outputs.resourceId
      storageContainerName: 'sqlvascans'
      storageContainerPath: 'https://${storageAccountName}.blob.${environment().suffixes.storage}/sqlvascans'
      recurringScansIsEnabled: true
      recurringScansEmailSubscriptionAdmins: false
      recurringScansEmails: []
      useStorageAccountAccessKey: false
      createStorageRoleAssignment: true
    }
    privateEndpoints: []
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
    tags: allTags
  }
  dependsOn: [avmPrivateDnsZones]
}

module sqlDbPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.private-endpoint.sql-${solutionSuffix}', 64)
  params: {
    name: 'pep-sql-${solutionSuffix}'
    location: solutionLocation
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
  dependsOn: [aiFoundryAiServices, searchService, cosmosDb, keyvault]
}

// ========== Frontend server farm ========== //
// WAF best practices for Web Application Services: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service
var webServerFarmResourceName = 'asp-${solutionSuffix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.5.0' = {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: allTags
    enableTelemetry: enableTelemetry
    location: solutionLocation
    reserved: true
    kind: 'linux'
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    // WAF aligned configuration for Scalability
    skuName: enableScalability || enableRedundancy ? 'P1v3' : 'B3'
    skuCapacity: enableScalability ? 3 : 1
    // WAF aligned configuration for Redundancy
    zoneRedundant: enableRedundancy ? true : false
  }
}

// ========== Frontend web site ========== //
// WAF best practices for web app service: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service

// NOTE: AVM module adds 1 MB of overhead to the template. Keeping vanilla resource to save template size.
var webSiteResourceName = 'app-${solutionSuffix}'
module webSite 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteResourceName}', 64)
  params: {
    name: webSiteResourceName
    tags: allTags
    location: solutionLocation
    clientAffinityEnabled: false
    managedIdentities: {
      userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId, sqlUserAssignedIdentity!.outputs.resourceId]
    }
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryHostname}/${containerImageName}:${imageTag}'
      minTlsVersion: '1.2'
      // WAF aligned configuration - Enable HTTP/2 for improved protocol efficiency
      http20Enabled: true
      // Preserve default values from module
      alwaysOn: true
      ftpsState: 'FtpsOnly'
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          APP_ENV: appEnvironment
          APPINSIGHTS_INSTRUMENTATIONKEY: enableMonitoring ? applicationInsights!.outputs.instrumentationKey : ''
          APPLICATIONINSIGHTS_CONNECTION_STRING: enableMonitoring ? applicationInsights!.outputs.connectionString : ''
          AZURE_SEARCH_SERVICE: aiSearchName
          AZURE_SEARCH_INDEX: azureSearchIndex
          AZURE_SEARCH_USE_SEMANTIC_SEARCH: azureSearchUseSemanticSearch
          AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG: azureSearchSemanticSearchConfig
          AZURE_SEARCH_TOP_K: azureSearchTopK
          AZURE_SEARCH_ENABLE_IN_DOMAIN: azureSearchEnableInDomain
          AZURE_SEARCH_CONTENT_COLUMNS: azureSearchContentColumns
          AZURE_SEARCH_FILENAME_COLUMN: azureSearchFilenameColumn
          AZURE_SEARCH_TITLE_COLUMN: azureSearchTitleColumn
          AZURE_SEARCH_URL_COLUMN: azureSearchUrlColumn
          AZURE_OPENAI_RESOURCE: aiFoundryAiServices.outputs.name
          AZURE_OPENAI_MODEL: gptModelName
          AZURE_OPENAI_ENDPOINT: aiFoundryAiServices.outputs.openaiEndpoint
          AZURE_OPENAI_TEMPERATURE: azureOpenAITemperature
          AZURE_OPENAI_TOP_P: azureOpenAITopP
          AZURE_OPENAI_MAX_TOKENS: azureOpenAIMaxTokens
          AZURE_OPENAI_STOP_SEQUENCE: azureOpenAIStopSequence
          AZURE_OPENAI_SYSTEM_MESSAGE: azureOpenAISystemMessage
          AZURE_OPENAI_PREVIEW_API_VERSION: azureOpenaiAPIVersion
          AZURE_OPENAI_STREAM: azureOpenAIStream
          AZURE_SEARCH_QUERY_TYPE: azureSearchQueryType
          AZURE_SEARCH_VECTOR_COLUMNS: azureSearchVectorFields
          AZURE_SEARCH_PERMITTED_GROUPS_COLUMN: azureSearchPermittedGroupsField
          AZURE_SEARCH_STRICTNESS: azureSearchStrictness
          AZURE_OPENAI_EMBEDDING_NAME: embeddingModel
          AZURE_OPENAI_EMBEDDING_ENDPOINT: aiFoundryAiServices.outputs.openaiEndpoint
          SQLDB_SERVER: sqlServerFqdn
          SQLDB_DATABASE: sqlDbName
          USE_INTERNAL_STREAM: useInternalStream
          AZURE_COSMOSDB_ACCOUNT: cosmosDb.outputs.name
          AZURE_COSMOSDB_CONVERSATIONS_CONTAINER: collectionName
          AZURE_COSMOSDB_DATABASE: cosmosDbDatabaseName
          AZURE_COSMOSDB_ENABLE_FEEDBACK: azureCosmosDbEnableFeedback
          SQLDB_USER_MID: sqlUserAssignedIdentity.outputs.clientId
          AZURE_AI_SEARCH_ENDPOINT: 'https://${aiSearchName}.search.windows.net'
          AZURE_SQL_SYSTEM_PROMPT: functionAppSqlPrompt
          AZURE_CALL_TRANSCRIPT_SYSTEM_PROMPT: functionAppCallTranscriptSystemPrompt
          AZURE_OPENAI_STREAM_TEXT_SYSTEM_PROMPT: functionAppStreamTextSystemPrompt
          USE_AI_PROJECT_CLIENT: useAIProjectClientFlag
          AZURE_AI_AGENT_ENDPOINT: aiFoundryAiServices.outputs.aiProjectInfo.apiEndpoint
          AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME: gptModelName
          AZURE_AI_AGENT_API_VERSION: azureOpenaiAPIVersion
          AZURE_SEARCH_CONNECTION_NAME: aiSearchName
          AZURE_CLIENT_ID: userAssignedIdentity.outputs.clientId
        }
        // WAF aligned configuration for Monitoring
        applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    // WAF aligned configuration for Private Networking
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    vnetImagePullEnabled: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webSubnetResourceId : null
    publicNetworkAccess: 'Enabled'
  }
}

var aiSearchName = 'srch-${solutionSuffix}'
module searchService 'br/public:avm/res/search/search-service:0.11.1' = {
  name: take('avm.res.search.search-service.${aiSearchName}', 64)
  params: {
    // Required parameters
    name: aiSearchName
    enableTelemetry: enableTelemetry
    // Authentication options
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    diagnosticSettings: enableMonitoring
      ? [
          {
            name: 'searchServiceDiagnostics'
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
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f' // Search Index Data Reader
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0' // Search Service Contributor
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f' // Search Index Data Reader
        principalId: aiFoundryAiServices.outputs.aiProjectInfo!.aiprojectSystemAssignedMIPrincipalId
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
    tags: allTags
    publicNetworkAccess: 'Enabled'
    privateEndpoints: false
      ? [
          {
            name: 'pep-${aiSearchName}'
            customNetworkInterfaceName: 'nic-${aiSearchName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.searchService]!.outputs.resourceId }
              ]
            }
            service: 'searchService'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
          }
        ]
      : []
  }
}

resource projectAISearchConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2025-07-01-preview' = {
  name: '${aiFoundryAiServicesResourceName}/${aiFoundryAiServicesAiProjectResourceName}/${aiSearchName}'
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${aiSearchName}.search.windows.net'
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiType: 'Azure'
      ResourceId: searchService.outputs.resourceId
      location: searchService.outputs.location
    }
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
    principalId: searchService.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
  }
}

// ========== AVM Telemetry ========== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-buildyourowncopilot.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, solutionLocation), 0, 4)}',
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

// ========== Outputs ========== //

@description('The URL of the deployed web application.')
output webAppUrl string = 'https://${webSite.outputs.name}.azurewebsites.net'

@description('The name of the deployed Storage Account.')
output storageAccountName string = avmStorageAccount.outputs.name

@description('The name of the Storage Container.')
output storageContainerName string = 'data'

@description('The name of the deployed Key Vault.')
output keyVaultName string = keyvault.outputs.name

@description('The name of the deployed CosmosDB Account.')
output cosmosDbAccountName string = cosmosDb.outputs.name

@description('The name of the Resource Group.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the AI Foundry service.')
output aiFoundryResourceId string = aiFoundryAiServices.outputs.resourceId

@description('The name of the SQL Database server.')
output sqlDbServerName string = sqlDBModule.outputs.name

@description('The name of the SQL Database.')
output sqlDbDatabase string = sqlDbName

@description('The name of the managed identity for the web application.')
output managedIdentityWebAppName string = userAssignedIdentity.outputs.name

@description('The client ID of the managed identity for the web application.')
output managedIdentityWebAppClientId string = userAssignedIdentity.outputs.clientId

@description('The name of the managed identity for SQL Server.')
output managedIdentitySqlName string = sqlUserAssignedIdentity.outputs.name

@description('The client ID of the managed identity for SQL Server.')
output managedIdentitySqlClientId string = sqlUserAssignedIdentity.outputs.clientId

@description('The name of the Azure AI Search service.')
output aiSearchServiceName string = aiSearchName

@description('The name of the deployed web application.')
output webAppName string = webSite.outputs.name

@description('The application environment.')
output appEnv string = appEnvironment

@description('The Application Insights instrumentation key.')
output appInsightsInstrumentationKey string = enableMonitoring ? applicationInsights!.outputs.instrumentationKey : ''

@description('The Application Insights connection string.')
output applicationInsightsConnectionString string = enableMonitoring
  ? applicationInsights!.outputs.connectionString
  : ''

@description('The API version for the Azure AI Agent.')
output azureAiAgentApiVersion string = azureOpenaiAPIVersion

@description('The endpoint for the Azure AI Agent.')
output azureAiAgentEndpoint string = aiFoundryAiServices.outputs.aiProjectInfo.apiEndpoint

@description('The model deployment name for the Azure AI Agent.')
output azureAiAgentModelDeploymentName string = gptModelName

@description('The endpoint for the Azure AI Search service.')
output azureAiSearchEndpoint string = 'https://${aiSearchName}.search.windows.net'

@description('The system prompt for call transcript processing in Azure Functions.')
output azureCallTranscriptSystemPrompt string = functionAppCallTranscriptSystemPrompt

@description('The Azure CosmosDB account name.')
output azureCosmosDbAccount string = cosmosDb.outputs.name

@description('The Azure CosmosDB conversations container name.')
output azureCosmosDbConversationsContainer string = collectionName

@description('The Azure CosmosDB database name.')
output azureCosmosDbDatabase string = cosmosDbDatabaseName

@description('Indicates whether feedback is enabled for Azure CosmosDB.')
output azureCosmosDbEnableFeedback string = azureCosmosDbEnableFeedback

@description('The endpoint for Azure OpenAI embedding service.')
output azureOpenAiEmbeddingEndpoint string = aiFoundryAiServices.outputs.openaiEndpoint

@description('The name of the Azure OpenAI embedding model.')
output azureOpenAiEmbeddingName string = embeddingModel

@description('The endpoint for the Azure OpenAI service.')
output azureOpenAiEndpoint string = aiFoundryAiServices.outputs.openaiEndpoint

@description('The maximum number of tokens for Azure OpenAI.')
output azureOpenAiMaxTokens string = azureOpenAIMaxTokens

@description('The Azure OpenAI model name.')
output azureOpenAiModel string = gptModelName

@description('The preview API version for Azure OpenAI.')
output azureOpenAiPreviewApiVersion string = azureOpenaiAPIVersion

@description('The Azure OpenAI resource name.')
output azureOpenAiResource string = aiFoundryAiServices.outputs.name

@description('The stop sequence for Azure OpenAI.')
output azureOpenAiStopSequence string = azureOpenAIStopSequence

@description('Indicates whether streaming is enabled for Azure OpenAI.')
output azureOpenAiStream string = azureOpenAIStream

@description('The system prompt for stream text processing in Azure Functions.')
output azureOpenAiStreamTextSystemPrompt string = functionAppStreamTextSystemPrompt

@description('The system message for Azure OpenAI.')
output azureOpenAiSystemMessage string = azureOpenAISystemMessage

@description('The temperature setting for Azure OpenAI.')
output azureOpenAiTemperature string = azureOpenAITemperature

@description('The top P setting for Azure OpenAI.')
output azureOpenAiTopP string = azureOpenAITopP

@description('The connection name for Azure AI Search.')
output azureSearchConnectionName string = aiSearchName

@description('The content columns used in Azure AI Search.')
output azureSearchContentColumns string = azureSearchContentColumns

@description('Indicates whether in-domain search is enabled for Azure AI Search.')
output azureSearchEnableInDomain string = azureSearchEnableInDomain

@description('The filename column used in Azure AI Search.')
output azureSearchFilenameColumn string = azureSearchFilenameColumn

@description('The index name used in Azure AI Search.')
output azureSearchIndex string = azureSearchIndex

@description('The permitted groups column used in Azure AI Search.')
output azureSearchPermittedGroupsColumn string = azureSearchPermittedGroupsField

@description('The query type used in Azure AI Search.')
output azureSearchQueryType string = azureSearchQueryType

@description('The semantic search configuration used in Azure AI Search.')
output azureSearchSemanticSearchConfig string = azureSearchSemanticSearchConfig

@description('The Azure AI Search service name.')
output azureSearchService string = aiSearchName

@description('The strictness level used in Azure AI Search.')
output azureSearchStrictness string = azureSearchStrictness

@description('The title column used in Azure AI Search.')
output azureSearchTitleColumn string = azureSearchTitleColumn

@description('The number of top results (K) to return from Azure AI Search.')
output azureSearchTopK string = azureSearchTopK

@description('The URL column used in Azure AI Search.')
output azureSearchUrlColumn string = azureSearchUrlColumn

@description('Indicates whether semantic search is used in Azure AI Search.')
output azureSearchUseSemanticSearch string = azureSearchUseSemanticSearch

@description('The vector fields used in Azure AI Search.')
output azureSearchVectorColumns string = azureSearchVectorFields

@description('The system prompt for SQL queries in Azure Functions.')
output azureSqlSystemPrompt string = functionAppSqlPrompt

@description('The fully qualified domain name (FQDN) of the Azure SQL Server.')
output sqlDbServer string = sqlServerFqdn

@description('The client ID of the managed identity for the web application.')
output sqlDbUserMid string = userAssignedIdentity.outputs.clientId

@description('Indicates whether the AI Project Client should be used.')
output useAiProjectClient string = useAIProjectClientFlag

@description('Indicates whether the internal stream should be used.')
output useInternalStream string = useInternalStream

@description('The Azure Subscription ID where the resources are deployed.')
output azureSubscriptionId string = subscription().subscriptionId
