// ========== main.bicep ========== //
targetScope = 'resourceGroup'

@minLength(3)
@maxLength(20)
@description('Required. A unique prefix for all resources in this deployment. This should be 3-20 characters long:')
param solutionName string = 'clientadvisor'

@description('Optional. CosmosDB Location')
param cosmosLocation string = 'eastus2'

@minLength(1)
@description('Optional. GPT model deployment type:')
@allowed([
  'Standard'
  'GlobalStandard'
])
param gptModelDeploymentType string = 'GlobalStandard'

@minLength(1)
@description('Optional. Name of the GPT model to deploy:')
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
@description('Optional. Capacity of the GPT deployment:')
// You can increase this, but capacity is limited per model/region, so you will get errors if you go over
// https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits
param gptModelCapacity int = 200

@minLength(1)
@description('Optional. Name of the Text Embedding model to deploy:')
@allowed([
  'text-embedding-ada-002'
])
param embeddingModel string = 'text-embedding-ada-002'

@minValue(10)
@description('Optional. Capacity of the Embedding Model deployment')
param embeddingDeploymentCapacity int = 80

//restricting to these regions because assistants api for gpt-4o-mini is available only in these regions
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

@allowed([
  'australiaeast'
  'centralus'
  'eastasia'
  'eastus2'
  'japaneast'
  'northeurope'
  'southeastasia'
  'uksouth'
])
@metadata({ azd: { type: 'location' } })
@description('Required. Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions).')
param location string = 'eastus2'
var solutionLocation = empty(location) ? resourceGroup().location : location

@maxLength(5)
@description('Optional. A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
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
param imageTag string = 'latest_waf_2025-09-18_794'

@description('Optional. Resource ID of an existing Foundry project')
param existingFoundryProjectResourceId string = ''

@description('Optional. Enable purge protection for the Key Vault')
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
  You have access to the client’s past meeting call transcripts.
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

// Region pairs list based on article in [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions) for supported high availability regions for CosmosDB.
var cosmosDbZoneRedundantHaRegionPairs = {
  australiaeast: 'uksouth' //'southeastasia'
  centralus: 'eastus2'
  eastasia: 'southeastasia'
  eastus: 'centralus'
  eastus2: 'centralus'
  japaneast: 'australiaeast'
  northeurope: 'westeurope'
  southeastasia: 'eastasia'
  uksouth: 'westeurope'
  westeurope: 'northeurope'
}

var allTags = union(
  {
    'azd-env-name': solutionName
  },
  tags
)

// Paired location calculated based on 'location' parameter. This location will be used by applicable resources if `enableScalability` is set to `true`
var cosmosDbHaLocation = cosmosDbZoneRedundantHaRegionPairs[resourceGroup().location]

@description('Optional. Tag, Created by user name')
param createdBy string = contains(deployer(), 'userPrincipalName')
  ? split(deployer().userPrincipalName, '@')[0]
  : deployer().objectId

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags: {
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
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.12.0' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: tags
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
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    tags: tags
    location: solutionLocation
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

// ========== User Assigned Identity ========== //
// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: solutionLocation
    tags: tags
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
    tags: tags
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
    diagnosticSettings: [
      {
        name: 'bastionDiagnostics'
        //workspaceResourceId: logAnalyticsWorkspaceResourceId
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

// Jumpbox Virtual Machine
var jumpboxVmName = take('vm-jumpbox-${solutionSuffix}', 15)
module jumpboxVM 'br/public:avm/res/compute/virtual-machine:0.20.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${jumpboxVmName}', 64)
  params: {
    name: take(jumpboxVmName, 15) // Shorten VM name to 15 characters to avoid Azure limits
    vmSize: vmSize ?? 'Standard_DS2_v2'
    location: solutionLocation
    adminUsername: vmAdminUsername ?? 'JumpboxAdminUser'
    adminPassword: vmAdminPassword ?? 'JumpboxAdminP@ssw0rd1234!'
    tags: tags
    availabilityZone: -1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
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
  'privatelink.azurewebsites.net'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
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
  appService: 3
  storageBlob: 4
  storageQueue: 5
  storageFile: 6
  cosmosDB: 7
  keyVault: 8
  sqlServer: 9
  searchService: 10
}

// List of DNS zone indices that correspond to AI-related services.
var aiRelatedDnsZoneIndices = [
  dnsZoneIndex.cognitiveServices
  dnsZoneIndex.openAI
  dnsZoneIndex.aiServices
]

// ===================================================
// DEPLOY PRIVATE DNS ZONES
// - Deploys all zones if no existing Foundry project is used
// - Excludes AI-related zones when using with an existing Foundry project
// ===================================================
@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.8.0' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking && (!contains(aiRelatedDnsZoneIndices, i))) {
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

// ==========Key Vault Module ========== //
var keyVaultName = 'KV-${solutionSuffix}'
module keyvault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('avm.res.key-vault.vault.${keyVaultName}', 64)
  params: {
    name: keyVaultName
    location: solutionLocation
    tags: tags
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
    //diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : []
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
        value: aiFoundryAiServices.outputs.endpoints['OpenAI Language Model Instance API']
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
    ]
    enableTelemetry: enableTelemetry
  }
}

// ========== AI Foundry: AI Services ========== //
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai

var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'
// AI Project resource id: /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.CognitiveServices/accounts/<ai-services-name>/projects/<project-name>

// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM

var aiFoundryAiServicesAiProjectResourceName = 'proj-${solutionSuffix}'
var aiFoundryAIservicesEnabled = true
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

module aiFoundryAiServices 'modules/ai-services.bicep' = if (aiFoundryAIservicesEnabled) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: azureAiServiceLocation
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
    privateEndpoints: (enablePrivateNetworking && empty(existingFoundryProjectResourceId))
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
module cosmosDb 'br/public:avm/res/document-db/database-account:0.17.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: cosmosDbResourceName
    location: cosmosLocation
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
    dataPlaneRoleDefinitions: [
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
            locationName: solutionLocation
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: cosmosDbHaLocation
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
  dependsOn: [keyvault, avmStorageAccount]
}

// ========== AVM WAF ========== //
// ========== Storage account module ========== //
var storageAccountName = 'st${solutionSuffix}'
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.27.1' = {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  params: {
    name: storageAccountName
    location: solutionLocation
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    tags: tags
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
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
      deleteRetentionPolicyEnabled: false
      containers: [
        {
          name: 'data'
          publicAccess: 'None'
          denyEncryptionScopeOverride: false
          defaultEncryptionScope: '$account-encryption-key'
        }
      ]
    }
  }
  dependsOn: [keyvault]
}

// working version of saving storage account secrets in key vault using AVM module
module saveStorageAccountSecretsInKeyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('saveStorageAccountSecretsInKeyVault.${keyVaultName}', 64)
  params: {
    name: keyVaultName
    enablePurgeProtection: enablePurgeProtection
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    secrets: [
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
        value: avmStorageAccount.outputs.primaryAccessKey
      }
    ]
  }
}

// ========== AVM WAF ========== //
// ========== SQL module ========== //
var sqlDbName = 'sqldb-${solutionSuffix}'
module sqlDBModule 'br/public:avm/res/sql/server:0.20.3' = {
  name: take('avm.res.sql.server.${sqlDbName}', 64)
  params: {
    // Required parameters
    name: 'sql-${solutionSuffix}'
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
}

// ========== Frontend server farm ========== //
// WAF best practices for Web Application Services: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service
var webServerFarmResourceName = 'asp-${solutionSuffix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.5.0' = {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: tags
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

//NOTE: AVM module adds 1 MB of overhead to the template. Keeping vanilla resource to save template size.
var webSiteResourceName = 'app-${solutionSuffix}'
module webSite 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteResourceName}', 64)
  params: {
    name: webSiteResourceName
    tags: tags
    location: solutionLocation
    managedIdentities: {
      userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId, sqlUserAssignedIdentity!.outputs.resourceId]
    }
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryHostname}/${containerImageName}:${imageTag}'
      minTlsVersion: '1.2'
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
          AZURE_OPENAI_ENDPOINT: aiFoundryAiServices.outputs.endpoints['OpenAI Language Model Instance API']
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
          AZURE_OPENAI_EMBEDDING_ENDPOINT: aiFoundryAiServices.outputs.endpoints['OpenAI Language Model Instance API']
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
    // Authentication options
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
    replicaCount: 1
    sku: 'standard'
    semanticSearch: 'free'
    // Use the deployment tags provided to the template
    tags: tags
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

// ========== Outputs ========== //
@description('URL of the deployed web application.')
output WEB_APP_URL string = 'https://${webSite.outputs.name}.azurewebsites.net'

@description('Name of the storage account.')
output STORAGE_ACCOUNT_NAME string = avmStorageAccount.outputs.name

@description('Name of the storage container.')
output STORAGE_CONTAINER_NAME string = 'data'

@description('Name of the Key Vault.')
output KEY_VAULT_NAME string = keyvault.outputs.name

@description('Name of the Cosmos DB account.')
output COSMOSDB_ACCOUNT_NAME string = cosmosDb.outputs.name

@description('Name of the resource group.')
output RESOURCE_GROUP_NAME string = resourceGroup().name

@description('The resource ID of the AI Foundry instance.')
output AI_FOUNDRY_RESOURCE_ID string = aiFoundryAiServices.outputs.resourceId

@description('Name of the SQL Database server.')
output SQLDB_SERVER_NAME string = sqlDBModule.outputs.name

@description('Name of the SQL Database.')
output SQLDB_DATABASE string = sqlDbName

@description('Name of the managed identity used by the web app.')
output MANAGEDIDENTITY_WEBAPP_NAME string = userAssignedIdentity.outputs.name

@description('Client ID of the managed identity used by the web app.')
output MANAGEDIDENTITY_WEBAPP_CLIENTID string = userAssignedIdentity.outputs.clientId

@description('Name of the managed identity used for SQL database operations.')
output MANAGEDIDENTITY_SQL_NAME string = sqlUserAssignedIdentity.outputs.name

@description('Client ID of the managed identity used for SQL database operations.')
output MANAGEDIDENTITY_SQL_CLIENTID string = sqlUserAssignedIdentity.outputs.clientId
@description('Name of the AI Search service.')
output AI_SEARCH_SERVICE_NAME string = aiSearchName

@description('Name of the deployed web application.')
output WEB_APP_NAME string = webSite.outputs.name
@description('Specifies the current application environment.')
output APP_ENV string = appEnvironment

@description('The Application Insights instrumentation key.')
output APPINSIGHTS_INSTRUMENTATIONKEY string = enableMonitoring ? applicationInsights!.outputs.instrumentationKey : ''

@description('The Application Insights connection string.')
output APPLICATIONINSIGHTS_CONNECTION_STRING string = enableMonitoring
  ? applicationInsights!.outputs.connectionString
  : ''

@description('The API version used for the Azure AI Agent service.')
output AZURE_AI_AGENT_API_VERSION string = azureOpenaiAPIVersion

@description('The endpoint URL of the Azure AI Agent project.')
output AZURE_AI_AGENT_ENDPOINT string = aiFoundryAiServices.outputs.aiProjectInfo.apiEndpoint

@description('The deployment name of the GPT model for the Azure AI Agent.')
output AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME string = gptModelName

@description('The endpoint URL of the Azure AI Search service.')
output AZURE_AI_SEARCH_ENDPOINT string = 'https://${aiSearchName}.search.windows.net'

@description('The system prompt used for call transcript processing in Azure Functions.')
output AZURE_CALL_TRANSCRIPT_SYSTEM_PROMPT string = functionAppCallTranscriptSystemPrompt

@description('The name of the Azure Cosmos DB account.')
output AZURE_COSMOSDB_ACCOUNT string = cosmosDb.outputs.name

@description('The name of the Azure Cosmos DB container for storing conversations.')
output AZURE_COSMOSDB_CONVERSATIONS_CONTAINER string = collectionName

@description('The name of the Azure Cosmos DB database.')
output AZURE_COSMOSDB_DATABASE string = cosmosDbDatabaseName

@description('Indicates whether feedback is enabled in Azure Cosmos DB.')
output AZURE_COSMOSDB_ENABLE_FEEDBACK string = azureCosmosDbEnableFeedback

@description('The endpoint URL for the Azure OpenAI Embedding model.')
output AZURE_OPENAI_EMBEDDING_ENDPOINT string = aiFoundryAiServices.outputs.endpoints['OpenAI Language Model Instance API']

@description('The name of the Azure OpenAI Embedding model.')
output AZURE_OPENAI_EMBEDDING_NAME string = embeddingModel

@description('The endpoint URL for the Azure OpenAI service.')
output AZURE_OPENAI_ENDPOINT string = aiFoundryAiServices.outputs.endpoints['OpenAI Language Model Instance API']

@description('The maximum number of tokens for Azure OpenAI responses.')
output AZURE_OPENAI_MAX_TOKENS string = azureOpenAIMaxTokens

@description('The name of the Azure OpenAI GPT model.')
output AZURE_OPENAI_MODEL string = gptModelName

@description('The preview API version for Azure OpenAI.')
output AZURE_OPENAI_PREVIEW_API_VERSION string = azureOpenaiAPIVersion

@description('The Azure OpenAI resource name.')
output AZURE_OPENAI_RESOURCE string = aiFoundryAiServices.outputs.name

@description('The stop sequence(s) for Azure OpenAI responses.')
output AZURE_OPENAI_STOP_SEQUENCE string = azureOpenAIStopSequence

@description('Indicates whether streaming is enabled for Azure OpenAI responses.')
output AZURE_OPENAI_STREAM string = azureOpenAIStream

@description('The system prompt for streaming text responses in Azure Functions.')
output AZURE_OPENAI_STREAM_TEXT_SYSTEM_PROMPT string = functionAppStreamTextSystemPrompt

@description('The system message for Azure OpenAI requests.')
output AZURE_OPENAI_SYSTEM_MESSAGE string = azureOpenAISystemMessage

@description('The temperature setting for Azure OpenAI responses.')
output AZURE_OPENAI_TEMPERATURE string = azureOpenAITemperature

@description('The Top-P setting for Azure OpenAI responses.')
output AZURE_OPENAI_TOP_P string = azureOpenAITopP

@description('The name of the Azure AI Search connection.')
output AZURE_SEARCH_CONNECTION_NAME string = aiSearchName

@description('The columns in Azure AI Search that contain content.')
output AZURE_SEARCH_CONTENT_COLUMNS string = azureSearchContentColumns

@description('Indicates whether in-domain filtering is enabled for Azure AI Search.')
output AZURE_SEARCH_ENABLE_IN_DOMAIN string = azureSearchEnableInDomain

@description('The filename column used in Azure AI Search.')
output AZURE_SEARCH_FILENAME_COLUMN string = azureSearchFilenameColumn

@description('The name of the Azure AI Search index.')
output AZURE_SEARCH_INDEX string = azureSearchIndex

@description('The permitted groups field used in Azure AI Search.')
output AZURE_SEARCH_PERMITTED_GROUPS_COLUMN string = azureSearchPermittedGroupsField

@description('The query type for Azure AI Search.')
output AZURE_SEARCH_QUERY_TYPE string = azureSearchQueryType

@description('The semantic search configuration name in Azure AI Search.')
output AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG string = azureSearchSemanticSearchConfig

@description('The name of the Azure AI Search service.')
output AZURE_SEARCH_SERVICE string = aiSearchName

@description('The strictness setting for Azure AI Search semantic ranking.')
output AZURE_SEARCH_STRICTNESS string = azureSearchStrictness

@description('The title column used in Azure AI Search.')
output AZURE_SEARCH_TITLE_COLUMN string = azureSearchTitleColumn

@description('The number of top results (K) to return from Azure AI Search.')
output AZURE_SEARCH_TOP_K string = azureSearchTopK

@description('The URL column used in Azure AI Search.')
output AZURE_SEARCH_URL_COLUMN string = azureSearchUrlColumn

@description('Indicates whether semantic search is used in Azure AI Search.')
output AZURE_SEARCH_USE_SEMANTIC_SEARCH string = azureSearchUseSemanticSearch

@description('The vector fields used in Azure AI Search.')
output AZURE_SEARCH_VECTOR_COLUMNS string = azureSearchVectorFields

@description('The system prompt for SQL queries in Azure Functions.')
output AZURE_SQL_SYSTEM_PROMPT string = functionAppSqlPrompt

@description('The fully qualified domain name (FQDN) of the Azure SQL Server.')
output SQLDB_SERVER string = sqlServerFqdn

@description('The client ID of the managed identity for the web application.')
output SQLDB_USER_MID string = userAssignedIdentity.outputs.clientId

@description('Indicates whether the AI Project Client should be used.')
output USE_AI_PROJECT_CLIENT string = useAIProjectClientFlag

@description('Indicates whether the internal stream should be used.')
output USE_INTERNAL_STREAM string = useInternalStream

@description('The Azure Subscription ID where the resources are deployed.')
output AZURE_SUBSCRIPTION_ID string = subscription().subscriptionId
