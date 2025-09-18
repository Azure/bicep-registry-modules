// ========== main.bicep ========== //
metadata name = 'Document Knowledge Mining Solution'
metadata description = '''This module contains the resources required to deploy the [Document Knowledge Mining Solution](https://github.com/microsoft/Document-knowledge-mining-solution) for both Sandbox environments and enterprise-grade environments.'''

targetScope = 'resourceGroup'

@minLength(3)
@maxLength(20)
@description('Optional. A unique prefix for all resources in this deployment. This should be 3-20 characters long.')
param solutionName string = 'kmgs'

@description('Optional. Azure location for the solution. If not provided, it defaults to the resource group location.')
param location string = resourceGroup().location

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
  'gpt-4.1-mini'
])
param gptModelName string = 'gpt-4.1-mini'

@description('Optional. Version of the GPT model to deploy.')
param gptModelVersion string = '2025-04-14'

@description('Optional. Capacity of the GPT model deployment.')
@minValue(10)
param gptModelCapacity int = 100

@minLength(1)
@description('Optional. Name of the Text Embedding model to deploy.')
@allowed([
  'text-embedding-3-large'
])
param embeddingModelName string = 'text-embedding-3-large'

@description('Optional. Version of the Text Embedding model to deploy.')
param embeddingModelVersion string = '1'

@description('Optional. Capacity of the Text Embedding model deployment.')
@minValue(10)
param embeddingModelCapacity int = 100

// @description('Optional: Existing Log Analytics Workspace Resource ID')
// param existingLogAnalyticsWorkspaceId string = ''

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminUsername string?

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminPassword string?

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.')
param vmSize string = 'Standard_DS2_v2'

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Enable private networking for applicable resources, aligned with the WAF recommendations. Defaults to false.')
param enablePrivateNetworking bool

@description('Required. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool

@description('Required. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool

@description('Required. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool

@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt4.1-mini,150'
      'OpenAI.GlobalStandard.text-embedding-3-large,100'
    ]
  }
})
@description('Required. Location for AI Foundry deployment. This is the location where the AI Foundry resources will be deployed.')
param aiDeploymentsLocation string

@description('Optional. Created by user name.')
param createdBy string = empty(deployer().userPrincipalName) ? '' : split(deployer().userPrincipalName, '@')[0]

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2021-04-01' = {
  name: 'default'
  properties: {
    tags: {
      ...tags
      TemplateName: 'DKM'
      CreatedBy: createdBy
    }
  }
}

var solutionLocation = empty(location) ? resourceGroup().location : location

// @description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
// param secretsExportConfiguration secretsExportConfigurationType?
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

// Paired location calculated based on 'location' parameter. This location will be used by applicable resources if `enableScalability` is set to `true`
var cosmosDbHaLocation = cosmosDbZoneRedundantHaRegionPairs[resourceGroup().location]

// Extracts subscription, resource group, and workspace name from the resource ID when using an existing Log Analytics workspace
// var useExistingLogAnalytics = !empty(existingLogAnalyticsWorkspaceId)

var gptModelDeployment = {
  modelName: gptModelName
  deploymentName: gptModelName
  deploymentVersion: gptModelVersion
  deploymentCapacity: gptModelCapacity
}

var embeddingModelDeployment = {
  modelName: embeddingModelName
  deploymentName: embeddingModelName
  deploymentVersion: embeddingModelVersion
  deploymentCapacity: embeddingModelCapacity
}

var openAiDeployments = [
  {
    name: gptModelDeployment.deploymentName
    model: {
      format: 'OpenAI'
      name: gptModelDeployment.modelName
      version: gptModelDeployment.deploymentVersion
    }
    sku: {
      name: gptModelDeploymentType
      capacity: gptModelDeployment.deploymentCapacity
    }
  }
  {
    name: embeddingModelDeployment.deploymentName
    model: {
      format: 'OpenAI'
      name: embeddingModelDeployment.modelName
      version: embeddingModelDeployment.deploymentVersion
    }
    sku: {
      name: gptModelDeploymentType
      capacity: embeddingModelDeployment.deploymentCapacity
    }
  }
]

// ========== Private DNS Zones ========== //
var privateDnsZones = [
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.search.windows.net'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.api.azureml.ms'
  'privatelink.azconfig.io'
  'privatelink.azurecr.io' // Todo: to be deleted
]
// DNS Zone Index Constants
var dnsZoneIndex = {
  cosmosDB: 0
  search: 1
  cognitiveServices: 2
  openAI: 3
  storageBlob: 4
  storageQueue: 5
  aiFoundry: 6
  appConfig: 7
  containerRegistry: 8
}
@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: 'dns-zone-${i}'
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: network!.outputs.vnetResourceId }]
    }
  }
]

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
    // Always enable replication for improved service availability (PSRule Azure.Log.Replication)
    replication: {
      enabled: true
      location: replicaLocation
    }
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
var logAnalyticsWorkspaceResourceId = logAnalyticsWorkspace!.outputs.resourceId

// ========== Network Module ========== //
module network 'modules/network.bicep' = if (enablePrivateNetworking) {
  name: take('network-${solutionSuffix}-deployment', 64)
  params: {
    resourcesName: solutionSuffix
    logAnalyticsWorkSpaceResourceId: logAnalyticsWorkspaceResourceId
    vmAdminUsername: vmAdminUsername ?? 'JumpboxAdminUser'
    vmAdminPassword: vmAdminPassword ?? 'JumpboxAdminP@ssw0rd1234!'
    vmSize: vmSize ?? 'Standard_DS2_v2' // Default VM size
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== User Assigned Identity ========== //
// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== Container Registry ========== //
module avmContainerRegistry './modules/container-registry.bicep' = {
  //name: format(deployment_param.resource_name_format_string, abbrs.containers.containerRegistry)
  params: {
    acrName: 'cr${replace(solutionSuffix, '-', '')}'
    location: solutionLocation
    acrSku: 'Standard'
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Disabled'
    roleAssignments: [
      {
        principalId: managedCluster.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'AcrPull'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
  }
}

// ========== Cosmos Database for Mongo DB ========== //
module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: take('avm.res.cosmos-${solutionSuffix}', 64)
  params: {
    name: 'cosmos-${solutionSuffix}'
    location: solutionLocation
    mongodbDatabases: [
      {
        name: 'default'
        tag: 'default database'
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
    databaseAccountOfferType: 'Standard'
    serverVersion: '7.0'
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
            name: 'cosmosdb-private-endpoint-${solutionSuffix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB].outputs.resourceId
                }
              ]
            }
            service: 'MongoDB'
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId // Use the backend subnet
          }
        ]
      : []
    // WAF aligned configuration for Redundancy
    zoneRedundant: enableRedundancy ? true : false
    capabilitiesToAdd: [
      'EnableMongo'
    ]
    //capabilitiesToAdd: enableRedundancy ? null : ['EnableServerless']
    automaticFailover: enableRedundancy ? true : false
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
}

// ========== App Configuration store ========== //
var appConfigName = 'appcs-${solutionSuffix}'
module avmAppConfig 'br/public:avm/res/app-configuration/configuration-store:0.6.3' = {
  name: take('avm.res.app-configuration.configuration-store.${appConfigName}', 64)
  params: {
    name: appConfigName
    location: solutionLocation
    managedIdentities: { systemAssigned: true }
    sku: 'Standard'
    enableTelemetry: enableTelemetry
    tags: tags
    disableLocalAuth: false
    replicaLocations: [
      {
        replicaLocation: replicaLocation
      }
    ]
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalType: 'ServicePrincipal'
      }
    ]

    keyValues: [
      {
        name: 'Application:AIServices:GPT-4o-mini:Endpoint'
        value: avmOpenAi.outputs.endpoint
      }
      {
        name: 'Application:AIServices:GPT-4o-mini:ModelName'
        value: gptModelDeployment.modelName
      }
      {
        name: 'Application:Services:KernelMemory:Endpoint'
        value: 'http://kernelmemory-service'
      }
      {
        name: 'Application:Services:PersistentStorage:CosmosMongo:Collections:ChatHistory:Collection'
        value: 'ChatHistory'
      }
      {
        name: 'Application:Services:PersistentStorage:CosmosMongo:Collections:ChatHistory:Database'
        value: 'DPS'
      }
      {
        name: 'Application:Services:PersistentStorage:CosmosMongo:Collections:DocumentManager:Collection'
        value: 'Documents'
      }
      {
        name: 'Application:Services:PersistentStorage:CosmosMongo:Collections:DocumentManager:Database'
        value: 'DPS'
      }
      {
        name: 'Application:Services:PersistentStorage:CosmosMongo:ConnectionString'
        value: avmCosmosDB.outputs.primaryReadWriteConnectionString
      }
      {
        name: 'Application:Services:AzureAISearch:Endpoint'
        value: 'https://${avmSearchSearchServices.outputs.name}.search.windows.net'
      }
      {
        name: 'KernelMemory:Services:AzureAIDocIntel:Auth'
        value: 'AzureIdentity'
      }
      {
        name: 'KernelMemory:Services:AzureAIDocIntel:Endpoint'
        value: documentIntelligence.outputs.endpoint
      }
      {
        name: 'KernelMemory:Services:AzureAISearch:Auth'
        value: 'AzureIdentity'
      }
      {
        name: 'KernelMemory:Services:AzureAISearch:Endpoint'
        value: 'https://${avmSearchSearchServices.outputs.name}.search.windows.net'
      }
      {
        name: 'KernelMemory:Services:AzureBlobs:Account'
        value: avmStorageAccount.outputs.name
      }
      {
        name: 'KernelMemory:Services:AzureBlobs:Auth'
        value: 'AzureIdentity'
      }
      {
        name: 'KernelMemory:Services:AzureBlobs:Container'
        value: 'smemory'
      }
      {
        name: 'KernelMemory:Services:AzureOpenAIEmbedding:Auth'
        value: 'AzureIdentity'
      }
      {
        name: 'KernelMemory:Services:AzureOpenAIEmbedding:Deployment'
        value: embeddingModelDeployment.deploymentName
      }
      {
        name: 'KernelMemory:Services:AzureOpenAIEmbedding:Endpoint'
        value: avmOpenAi.outputs.endpoint
      }
      {
        name: 'KernelMemory:Services:AzureOpenAIText:Auth'
        value: 'AzureIdentity'
      }
      {
        name: 'KernelMemory:Services:AzureOpenAIText:Deployment'
        value: gptModelDeployment.deploymentName
      }
      {
        name: 'KernelMemory:Services:AzureOpenAIText:Endpoint'
        value: avmOpenAi.outputs.endpoint
      }
      {
        name: 'KernelMemory:Services:AzureQueues:Account'
        value: avmStorageAccount.outputs.name
      }
      {
        name: 'KernelMemory:Services:AzureQueues:Auth'
        value: 'AzureIdentity'
      }
    ]

    publicNetworkAccess: 'Enabled'
  }
}

module avmAppConfigUpdated 'br/public:avm/res/app-configuration/configuration-store:0.6.3' = if (enablePrivateNetworking) {
  name: take('avm.res.app-configuration.configuration-store-update.${appConfigName}', 64)
  params: {
    name: appConfigName
    location: solutionLocation
    managedIdentities: { systemAssigned: true }
    sku: 'Standard'
    enableTelemetry: enableTelemetry
    tags: tags
    disableLocalAuth: true
    replicaLocations: [
      {
        replicaLocation: replicaLocation
      }
    ]

    // WAF aligned networking
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-appconfig-${solutionSuffix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'appconfig-dns-zone-group'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.appConfig]!.outputs.resourceId
                }
              ]
            }
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId
          }
        ]
      : []
  }
  dependsOn: [
    avmAppConfig
  ]
}

// ========== Storage account module ========== //
var storageAccountName = 'st${solutionSuffix}'
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
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
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId
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
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId
            service: 'queue'
          }
        ]
      : []

    blobServices: {
      corsRules: []
      deleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
      deleteRetentionPolicyDays: 6
      containers: [
        {
          name: 'data'
          publicAccess: 'None'
        }
      ]
    }
  }
}

// ========== AI Foundry: AI Search ========== //
var aiSearchName = 'srch-${solutionSuffix}'
module avmSearchSearchServices 'br/public:avm/res/search/search-service:0.9.1' = {
  name: take('avm.res.cognitive-search-services.${aiSearchName}', 64)
  params: {
    name: aiSearchName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    sku: enableScalability ? 'standard' : 'basic'
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] }
    replicaCount: 3 // Minimum 3 replicas for Azure.Search.IndexSLA and minimum 2 for Azure.Search.QuerySLA (PSRule compliance)
    partitionCount: 1
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Search Index Data Contributor' // Cognitive Search Contributor
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Search Index Data Reader' //'5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'// Cognitive Services OpenAI User
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
    ]
    semanticSearch: 'free'
    // secretsExportConfiguration: {
    //   keyVaultResourceId: keyvault.outputs.resourceId
    //   primaryAdminKeyName: varKvSecretNameAzureSearchKey
    // }
    // WAF aligned configuration for Private Networking
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${aiSearchName}'
            customNetworkInterfaceName: 'nic-${aiSearchName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.search]!.outputs.resourceId }
              ]
            }
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId
          }
        ]
      : []
  }
}

// ========== Cognitive Services - OpenAI module ========== //
var openAiAccountName = 'oai-${solutionSuffix}'
module avmOpenAi 'br/public:avm/res/cognitive-services/account:0.13.2' = {
  name: take('avm.res.cognitiveservices.account.${openAiAccountName}', 64)
  params: {
    name: openAiAccountName
    location: aiDeploymentsLocation
    kind: 'OpenAI'
    sku: 'S0'
    tags: tags
    enableTelemetry: enableTelemetry
    customSubDomainName: openAiAccountName
    managedIdentities: {
      systemAssigned: true
    }

    // WAF baseline
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }

    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-openai-${solutionSuffix}'
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId
            service: 'account'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'openai-dns-zone-group'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.openAI]!.outputs.resourceId
                }
              ]
            }
          }
        ]
      : []

    // Role assignments
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
        principalType: 'ServicePrincipal'
      }
    ]

    // OpenAI deployments (pass array from main)
    deployments: openAiDeployments
  }
}

// ========== Cognitive Services - Document Intellignece module ========== //
var docIntelAccountName = 'di-${solutionSuffix}'
module documentIntelligence 'br/public:avm/res/cognitive-services/account:0.13.2' = {
  name: take('avm.res.cognitiveservices.account.${docIntelAccountName}', 64)
  params: {
    name: docIntelAccountName
    location: solutionLocation
    kind: 'FormRecognizer'
    tags: tags
    sku: 'S0'
    customSubDomainName: docIntelAccountName
    enableTelemetry: enableTelemetry
    managedIdentities: {
      systemAssigned: true
    }

    // Networking aligned to WAF
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
    }

    // Private Endpoint for Form Recognizer
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-docintel-${solutionSuffix}'
            subnetResourceId: network!.outputs.subnetPrivateEndpointsResourceId
            service: 'account'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'docintel-dns-zone-group'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
                }
              ]
            }
          }
        ]
      : []

    // Role Assignments
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Cognitive Services User'
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

// ========== Azure Kubernetes Service (AKS) ========== //
module managedCluster 'br/public:avm/res/container-service/managed-cluster:0.10.1' = {
  name: take('avm.res.container-service.managed-cluster.aks-${solutionSuffix}', 64)
  params: {
    name: 'aks-${solutionSuffix}'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    kubernetesVersion: '1.30.4'
    dnsPrefix: 'aks-${solutionSuffix}'
    enableRBAC: true
    aadProfile: {
      aadProfileManaged: true
      aadProfileEnableAzureRBAC: true
      aadProfileTenantId: subscription().tenantId
    }
    disableLocalAccounts: false
    publicNetworkAccess: 'Enabled'
    managedIdentities: {
      systemAssigned: true
    }
    serviceCidr: '10.20.0.0/16'
    dnsServiceIP: '10.20.0.10'
    enablePrivateCluster: false
    primaryAgentPoolProfiles: [
      {
        name: 'agentpool'
        vmSize: 'Standard_D4ds_v5'
        count: 3
        osType: 'Linux'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
        minCount: 3
        maxCount: 5

        // WAF aligned configuration for Private Networking
        enableAutoScaling: true
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        vnetSubnetResourceId: enablePrivateNetworking ? network!.outputs.subnetWebResourceId : null
      }
    ]
    autoNodeOsUpgradeProfileUpgradeChannel: 'Unmanaged'
    autoUpgradeProfileUpgradeChannel: 'stable'
    enableAzureDefender: enablePrivateNetworking
    networkPlugin: 'azure'
    networkPolicy: 'azure'
    omsAgentEnabled: true
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring
      ? [
          {
            logCategoriesAndGroups: [
              {
                category: 'kube-apiserver'
              }
              {
                category: 'kube-controller-manager'
              }
              {
                category: 'kube-scheduler'
              }
              {
                category: 'cluster-autoscaler'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            name: 'customSetting'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
          }
        ]
      : []
    monitoringWorkspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : null

    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

// ========== AKS Maintenance Windows ========== //
// Configure customer-controlled maintenance windows for AKS cluster and node OS upgrades
// This addresses Azure.AKS.MaintenanceWindow PSRule requirement
resource aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-10-01' = {
  name: 'aks-${solutionSuffix}/aksManagedAutoUpgradeSchedule'
  properties: {
    maintenanceWindow: {
      schedule: {
        weekly: {
          intervalWeeks: 1
          dayOfWeek: 'Sunday'
        }
      }
      durationHours: 4
      utcOffset: '+00:00'
      startDate: '2024-07-15'
      startTime: '02:00'
    }
  }
  dependsOn: [
    managedCluster
  ]
}

resource aksManagedNodeOSUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-10-01' = {
  name: 'aks-${solutionSuffix}/aksManagedNodeOSUpgradeSchedule'
  properties: {
    maintenanceWindow: {
      schedule: {
        weekly: {
          intervalWeeks: 1
          dayOfWeek: 'Sunday'
        }
      }
      durationHours: 4
      utcOffset: '+00:00'
      startDate: '2024-07-15'
      startTime: '04:00'
    }
  }
  dependsOn: [
    managedCluster
  ]
}

// ========== Application Insights ========== //
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
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
  }
}

// ============ AVM TELEMETRY ============
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-documentknowledgeminingsolution.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

/*
  Outputs
*/
@description('Contains Azure Tenant ID.')
output azureTenantId string = subscription().tenantId

@description('Contains Solution Name.')
output solutionName string = solutionSuffix

@description('Contains Resource Group Name.')
output resourceGroupName string = resourceGroup().name

@description('Contains Resource Group Location.')
output resourceGroupLocation string = solutionLocation

@description('Contains Resource Group ID.')
output azureResourceGroupId string = resourceGroup().id

@description('Contains Azure App Configuration Name.')
output azureAppConfigName string = avmAppConfig.outputs.name

@description('Contains Azure App Configuration Endpoint.')
output azureAppConfigEndpoint string = avmAppConfig.outputs.endpoint

@description('Contains Storage Account Name.')
output storageAccountName string = avmStorageAccount.outputs.name

@description('Contains Cosmos DB Name.')
output azureCosmosDbName string = avmCosmosDB.outputs.name

@description('Contains Cognitive Service Name.')
output azureCognitiveServiceName string = documentIntelligence.outputs.name

@description('Contains Azure Cognitive Service Endpoint.')
output azureCognitiveServiceEndpoint string = documentIntelligence.outputs.endpoint

@description('Contains Azure Search Service Name.')
output azureSearchServiceName string = avmSearchSearchServices.outputs.name

@description('Contains Azure AKS Name.')
output azureAksName string = managedCluster.outputs.name

@description('Contains Azure AKS Managed Identity ID.')
output azureAksMiId string = managedCluster.outputs.systemAssignedMIPrincipalId!

@description('Contains Azure Container Registry Name.')
output azureContainerRegistryName string = avmContainerRegistry.outputs.name

@description('Contains Azure OpenAI Service Name.')
output azureOpenAiServiceName string = avmOpenAi.outputs.name

@description('Contains Azure OpenAI Service Endpoint.')
output azureOpenAiServiceEndpoint string = avmOpenAi.outputs.endpoint

@description('Contains Azure Search Service Endpoint.')
output azSearchServiceEndpoint string = avmSearchSearchServices.outputs.name

@description('Contains Azure GPT-4o Model Deployment Name.')
output azGpt4oModelId string = gptModelDeployment.deploymentName

@description('Contains Azure GPT-4o Model Name.')
output azGpt4oModelName string = gptModelDeployment.modelName

@description('Contains Azure OpenAI Embedding Model Name.')
output azGptEmbeddingModelName string = embeddingModelDeployment.modelName

@description('Contains Azure OpenAI Embedding Model Deployment Name.')
output azGptEmbeddingModelId string = embeddingModelDeployment.deploymentName
