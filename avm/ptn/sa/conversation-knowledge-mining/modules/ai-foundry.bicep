// NOTE: This module is designed to be replaced in the future with an AVM patter module with AI Foundry services

param aiHubLocation string
param aiHubResourceName string
param aiHubSkuName string
param aiProjectLocation string
param aiProjectResourceName string
param aiProjectSkuName string
param aiServicesContentUnderstandingLocation string
param aiServicesContentUnderstandingResourceName string
param aiServicesContentUnderstandingSkuName string
param aiServicesLocation string
param aiServicesModelDeployments array
param aiServicesResourceName string
param aiServicesSkuName string
param applicationInsightsLocation string
param applicationInsightsResourceName string
param applicationInsightsRetentionInDays int
param avmDeploymentNameFormat string
param containerRegistryLocation string
param containerRegistryResourceName string
param containerRegistrySkuName string
param enableTelemetry bool = true
param keyVaultResourceName string
param localModuleDeploymentNameFormat string
param logAnalyticsWorkspaceResourceId string
param managedIdentityPrincipalId string
param searchServiceLocation string
param searchServiceResourceName string
param searchServiceSkuName string
param storageAccountLocation string
param storageAccountResourceName string
param storageAccountSkuName string
param tags object

// VARIABLES
var varKvSecretNameAzureOpenaiKey = 'AZURE-OPENAI-KEY'
var varKvSecretNameAzureSearchKey = 'AZURE-SEARCH-KEY'

// Existing resources

resource existingKeyVaultResource 'Microsoft.keyvault/vaults@2024-04-01-preview' existing = {
  name: keyVaultResourceName
}

// AI Foundry: storage account

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: format(avmDeploymentNameFormat, storageAccountResourceName)
  params: {
    name: storageAccountResourceName
    location: storageAccountLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    skuName: storageAccountSkuName
    kind: 'StorageV2'
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    requireInfrastructureEncryption: true
    enableHierarchicalNamespace: false
    largeFileSharesState: 'Disabled'
    enableNfsV3: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    blobServices: {
      automaticSnapshotPolicyEnabled: false
      deleteRetentionPolicyAllowPermanentDelete: false
      deleteRetentionPolicyDays: 7
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyAllowPermanentDelete: false
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
    }
    roleAssignments: [
      {
        principalId: managedIdentityPrincipalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
    ]
  }
}

// AI Foundry: Application Insights
module avmInsightsComponent 'br/public:avm/res/insights/component:0.6.0' = {
  name: format(avmDeploymentNameFormat, applicationInsightsResourceName)
  params: {
    name: applicationInsightsResourceName
    workspaceResourceId: logAnalyticsWorkspaceResourceId //NOTE: Adding this due to AVM requirement
    tags: tags
    location: applicationInsightsLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    kind: 'web'
    applicationType: 'web'
    disableIpMasking: false
    disableLocalAuth: false
    flowType: 'Bluefield'
    forceCustomerStorageForProfiler: false
    retentionInDays: applicationInsightsRetentionInDays
    // MISSING: ImmediatePurgeDataOn30Days: true
    // MISSING: IngestionMode: 'ApplicationInsights'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Disabled'
    requestSource: 'rest'
  }
}

// AI Foundry: Container Registry
module avmContainerRegistryRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: format(avmDeploymentNameFormat, containerRegistryResourceName)
  params: {
    name: containerRegistryResourceName
    tags: tags
    location: containerRegistryLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    acrSku: containerRegistrySkuName
    acrAdminUserEnabled: false
    dataEndpointEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSetDefaultAction: 'Deny'
    quarantinePolicyStatus: 'enabled'
    retentionPolicyStatus: 'enabled'
    retentionPolicyDays: 7
    trustPolicyStatus: 'disabled'
    publicNetworkAccess: 'Disabled'
    zoneRedundancy: 'Disabled'
  }
}

// AI Foundry: AI Services
// NOTE: Required version 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' not available in AVM
// module avmCognitiveServicesAccounts 'br/public:avm/res/cognitive-services/account:0.10.1' = {
//   name: format(avmDeploymentNameFormat, aiServicesResourceName)
//   params: {
//     name: aiServicesResourceName
//     disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
//     location: location
//     tags: tags
//     sku: 'S0'
//     kind: 'AIServices'
//     customSubDomainName: aiServicesResourceName
//     apiProperties: {
//       staticsEnabled: false
//     }
//     publicNetworkAccess: 'Enabled' //Not in original script, check this
//     deployments: [
//       for aiModelDeployment in aiServicesModelDeployments: {
//         name: aiModelDeployment.name
//         model: aiModelDeployment.model
//         sku: aiModelDeployment.sku
//         raiPolicyName: aiModelDeployment.raiPolicyName
//       }
//     ]
//     secretsExportConfiguration: {
//       keyVaultResourceId: existingKeyVaultResource.id
//       accessKey1Name: varKvSecretNameAzureOpenaiKey
//     }
//   }
// }
resource avmCognitiveServicesAccounts 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' = {
  name: aiServicesResourceName
  tags: tags
  location: aiServicesLocation
  sku: {
    name: aiServicesSkuName
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: aiServicesResourceName
    apiProperties: {
      statisticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' // Not in original script, it failing otherwise
  }
}
@batchSize(1)
resource aiServicesDeployments 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [
  for aiModeldeployment in aiServicesModelDeployments: {
    parent: avmCognitiveServicesAccounts //aiServices_m
    name: aiModeldeployment.name
    properties: {
      model: {
        format: 'OpenAI'
        name: aiModeldeployment.model.name
      }
      raiPolicyName: aiModeldeployment.raiPolicyName
    }
    sku: {
      name: aiModeldeployment.sku.name
      capacity: aiModeldeployment.sku.capacity
    }
  }
]
resource cognitiveServicesAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${avmCognitiveServicesAccounts.name}-diagnosticSettings'
  scope: avmCognitiveServicesAccounts
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        timeGrain: null
      }
    ]
    logs: [
      {
        categoryGroup: 'audit'
        category: null
        enabled: true
      }
      {
        categoryGroup: 'allLogs'
        category: null
        enabled: true
      }
    ]
  }
}
resource azureOpenAIKeyEntry 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: varKvSecretNameAzureOpenaiKey
  properties: {
    value: avmCognitiveServicesAccounts.listKeys().key1
  }
}

// AI Foundry: AI Services Content Understanding
// NOTE: Required version 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' not available in AVM
// module avmCognitiveServicesAccountsContentUnderstanding 'br/public:avm/res/cognitive-services/account:0.10.1' = {
//   name: format(avmDeploymentNameFormat, aiServicesContentUnderstandingResourceName)
//   params: {
//     name: aiServicesContentUnderstandingResourceName
//     location: aiServices_cu_location
//     tags: tags
//     disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
//     customSubDomainName: aiServicesContentUnderstandingResourceName
//     sku: 'S0'
//     kind: 'AIServices'
//     apiProperties: {
//       staticsEnabled: false
//     }
//     publicNetworkAccess: 'Enabled' // Not in original script, check this
//     secretsExportConfiguration: {
//       keyVaultResourceId: existingKeyVaultResource.id
//       accessKey1Name: 'AZURE-OPENAI-CU-KEY'
//     }
//   }
// }
resource avmCognitiveServicesAccountsContentUnderstanding 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' = {
  name: aiServicesContentUnderstandingResourceName
  tags: tags
  location: aiServicesContentUnderstandingLocation
  sku: {
    name: aiServicesContentUnderstandingSkuName
  }
  kind: 'AIServices'
  properties: {
    customSubDomainName: aiServicesContentUnderstandingResourceName
    apiProperties: {
      statisticsEnabled: false
    }
    publicNetworkAccess: 'Enabled'
  }
}
resource cognitiveServicesAccountsContentUnderstanding_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${avmCognitiveServicesAccountsContentUnderstanding.name}-diagnosticSettings'
  scope: avmCognitiveServicesAccountsContentUnderstanding
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        timeGrain: null
      }
    ]
    logs: [
      {
        categoryGroup: 'audit'
        category: null
        enabled: true
      }
      {
        categoryGroup: 'allLogs'
        category: null
        enabled: true
      }
    ]
  }
}
resource azureOpenAICuKeyEntry 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-CU-KEY'
  properties: {
    value: avmCognitiveServicesAccountsContentUnderstanding.listKeys().key1 //'2024-02-15-preview'
  }
}

resource azureOpenAICUEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-CU-ENDPOINT'
  properties: {
    value: avmCognitiveServicesAccountsContentUnderstanding.properties.endpoint //deployed_avmCognitiveServicesAccountsContentUnderstanding.properties.endpoint
  }
}

// AI Foundry: AI Search
module avmSearchSearchServices 'br/public:avm/res/search/search-service:0.9.1' = {
  name: format(avmDeploymentNameFormat, searchServiceResourceName)
  params: {
    name: searchServiceResourceName
    tags: tags
    location: searchServiceLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    sku: searchServiceSkuName
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      ipRules: []
    }
    cmkEnforcement: 'Unspecified'
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
    semanticSearch: 'free'
    secretsExportConfiguration: {
      keyVaultResourceId: existingKeyVaultResource.id
      primaryAdminKeyName: varKvSecretNameAzureSearchKey
    }
  }
}

// AI Foundry: AI Hub
module moduleAIHub './ai-foundry-ai-hub.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'ai-foundry-ai-hub')
  params: {
    deploymentName: format(avmDeploymentNameFormat, aiHubResourceName)
    tags: tags
    location: aiHubLocation
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    aiServicesName: avmCognitiveServicesAccounts.name
    searchServiceName: avmSearchSearchServices.outputs.name
    aiHubName: aiHubResourceName
    sku: aiHubSkuName
    keyVaultResourceId: existingKeyVaultResource.id
    containerRegistryResourceId: avmContainerRegistryRegistry.outputs.resourceId
    applicationInsightsResourceId: avmInsightsComponent.outputs.resourceId
    storageAccountResourceId: avmStorageAccount.outputs.resourceId
    cognitiveServicesEndpoint: avmCognitiveServicesAccounts.properties.endpoint
    cognitiveServicesResourceId: avmCognitiveServicesAccounts.id
    searchServicesEndpoint: 'https://${avmSearchSearchServices.outputs.name}.search.windows.net'
    searchServicesResourceId: avmSearchSearchServices.outputs.resourceId
  }
}

// AI Foundry: AI Project

module avmMLServicesWorkspacesProject 'br/public:avm/res/machine-learning-services/workspace:0.10.1' = {
  name: format(avmDeploymentNameFormat, aiProjectResourceName)
  params: {
    name: aiProjectResourceName
    location: aiProjectLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    sku: aiProjectSkuName
    kind: 'Project'
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    hubResourceId: moduleAIHub.outputs.resourceId
    managedIdentities: {
      systemAssigned: true
    }
  }
}
// AI FOUNDRY: exported secrets

resource azureOpenAIInferenceEndpoint 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-INFERENCE-ENDPOINT'
  properties: {
    value: ''
  }
}

resource azureOpenAIInferenceKey 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-INFERENCE-KEY'
  properties: {
    value: ''
  }
}

resource azureOpenAIEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-ENDPOINT'
  properties: {
    //value: avmCognitiveServicesAccounts.outputs.endpoint
    value: avmCognitiveServicesAccounts.properties.endpoint
  }
}

resource cogServiceEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'COG-SERVICES-ENDPOINT'
  properties: {
    //value: avmCognitiveServicesAccounts.outputs.endpoint
    value: avmCognitiveServicesAccounts.properties.endpoint
  }
}

module aiFoundryKvSecretCogServicesKey './ai-foundry-kv-secret-cog-services-key.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'ai-foundry-kv-secret-cog-services-ke')
  params: {
    keyVaultResourceName: keyVaultResourceName
    //cognitiveServicesAccountsResourceName: avmCognitiveServicesAccounts.outputs.name
    cognitiveServicesAccountsResourceName: avmCognitiveServicesAccounts.name
  }
}

output aiServicesName string = avmCognitiveServicesAccounts.name //aiServicesName_m
output aiServicesEndpoint string = avmCognitiveServicesAccounts.properties.endpoint //aiServices_m.properties.endpoint
output aiServicesResourceId string = avmCognitiveServicesAccounts.id //aiServices_m.id

output aiSearchName string = avmSearchSearchServices.outputs.name
output aiSearchResourceId string = avmSearchSearchServices.outputs.resourceId
output aiSearchConnectionString string = 'https://${avmSearchSearchServices.outputs.name}.search.windows.net'

output aiProjectName string = avmMLServicesWorkspacesProject.outputs.name
output aiProjectResourceId string = avmMLServicesWorkspacesProject.outputs.resourceId

output applicationInsightsResourceId string = avmInsightsComponent.outputs.resourceId
output applicationInsightsInstrumentationKey string = avmInsightsComponent.outputs.instrumentationKey

output storageAccountName string = avmStorageAccount.outputs.name
