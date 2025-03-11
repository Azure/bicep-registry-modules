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
var varKvSecretNameAzureOpenaiEndpoint = 'AZURE-OPENAI-ENDPOINT'
var varKvSecretNameCogServicesEndpoint = 'COG-SERVICES-ENDPOINT'
var varKvSecretNameAzureSearchKey = 'AZURE-SEARCH-KEY'
var varKvSecretNameAzureOpenaiCuKey = 'AZURE-OPENAI-CU-KEY'
var varKvSecretNameAzureOpenaiCuEndpoint = 'AZURE-OPENAI-CU-ENDPOINT'
var varKvSecretNameAzureOpenaiInferenceEndpoint = 'AZURE-OPENAI-INFERENCE-ENDPOINT'
var varKvSecretNameAzureOpenaiInferenceKey = 'AZURE-OPENAI-INFERENCE-KEY'

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
      diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
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
    publicNetworkAccessForQuery: 'Enabled'
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
// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
module avmCognitiveServicesAccounts 'br/public:avm/res/cognitive-services/account:0.10.1' = {
  name: format(avmDeploymentNameFormat, aiServicesResourceName)
  params: {
    name: aiServicesResourceName
    tags: tags
    location: aiServicesLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    sku: aiServicesSkuName
    kind: 'AIServices'
    disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
    customSubDomainName: aiServicesResourceName
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' //Not in original script, check this
    deployments: [
      for aiModelDeployment in aiServicesModelDeployments: {
        name: aiModelDeployment.name
        model: aiModelDeployment.model
        sku: aiModelDeployment.sku
        raiPolicyName: aiModelDeployment.raiPolicyName
      }
    ]
    secretsExportConfiguration: {
      keyVaultResourceId: existingKeyVaultResource.id
      accessKey1Name: varKvSecretNameAzureOpenaiKey
    }
  }
}

// AI Foundry: AI Services Content Understanding
// NOTE: Required version 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' not available in AVM
module avmCognitiveServicesAccountsContentUnderstanding 'br/public:avm/res/cognitive-services/account:0.10.1' = {
  name: format(avmDeploymentNameFormat, aiServicesContentUnderstandingResourceName)
  params: {
    name: aiServicesContentUnderstandingResourceName
    location: aiServicesContentUnderstandingLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    sku: aiServicesContentUnderstandingSkuName
    kind: 'AIServices'
    disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
    customSubDomainName: aiServicesContentUnderstandingResourceName
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    secretsExportConfiguration: {
      keyVaultResourceId: existingKeyVaultResource.id
      accessKey1Name: varKvSecretNameAzureOpenaiCuKey
    }
  }
}

resource azureOpenAICUEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: varKvSecretNameAzureOpenaiCuEndpoint
  properties: {
    //value: cognitiveServicesAccountsContentUnderstanding.properties.endpoint
    value: avmCognitiveServicesAccountsContentUnderstanding.outputs.endpoint
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
    //aiServicesName: cognitiveServicesAccounts.name
    aiServicesName: avmCognitiveServicesAccounts.outputs.name
    searchServiceName: avmSearchSearchServices.outputs.name
    aiHubName: aiHubResourceName
    sku: aiHubSkuName
    keyVaultResourceId: existingKeyVaultResource.id
    containerRegistryResourceId: avmContainerRegistryRegistry.outputs.resourceId
    applicationInsightsResourceId: avmInsightsComponent.outputs.resourceId
    storageAccountResourceId: avmStorageAccount.outputs.resourceId
    //cognitiveServicesEndpoint: cognitiveServicesAccounts.properties.endpoint
    cognitiveServicesEndpoint: avmCognitiveServicesAccounts.outputs.endpoint
    //cognitiveServicesResourceId: cognitiveServicesAccounts.id
    cognitiveServicesResourceId: avmCognitiveServicesAccounts.outputs.resourceId
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
  name: varKvSecretNameAzureOpenaiInferenceEndpoint
  properties: {
    value: ''
  }
}

resource azureOpenAIInferenceKey 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: varKvSecretNameAzureOpenaiInferenceKey
  properties: {
    value: ''
  }
}

resource azureOpenAIEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: varKvSecretNameAzureOpenaiEndpoint
  properties: {
    //value: avmCognitiveServicesAccounts.outputs.endpoint
    value: avmCognitiveServicesAccounts.outputs.endpoint
  }
}

resource cogServiceEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: varKvSecretNameCogServicesEndpoint
  properties: {
    //value: cognitiveServicesAccounts.properties.endpoint
    value: avmCognitiveServicesAccounts.outputs.endpoint
  }
}

module aiFoundryKvSecretCogServicesKey './ai-foundry-kv-secret-cog-services-key.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'ai-foundry-kv-secret-cog-services-ke')
  params: {
    keyVaultResourceName: keyVaultResourceName
    // cognitiveServicesAccountsResourceName: cognitiveServicesAccounts.name
    cognitiveServicesAccountsResourceName: avmCognitiveServicesAccounts.outputs.name
  }
}

//output aiServicesName string = cognitiveServicesAccounts.name
output aiServicesName string = avmCognitiveServicesAccounts.outputs.name
//output aiServicesEndpoint string = cognitiveServicesAccounts.properties.endpoint //aiServices_m.properties.endpoint
output aiServicesEndpoint string = avmCognitiveServicesAccounts.outputs.endpoint //aiServices_m.properties.endpoint
//output aiServicesResourceId string = cognitiveServicesAccounts.id
output aiServicesResourceId string = avmCognitiveServicesAccounts.outputs.resourceId

output aiSearchName string = avmSearchSearchServices.outputs.name
output aiSearchResourceId string = avmSearchSearchServices.outputs.resourceId
output aiSearchConnectionString string = 'https://${avmSearchSearchServices.outputs.name}.search.windows.net'

output aiProjectName string = avmMLServicesWorkspacesProject.outputs.name
output aiProjectResourceId string = avmMLServicesWorkspacesProject.outputs.resourceId

output applicationInsightsResourceId string = avmInsightsComponent.outputs.resourceId
output applicationInsightsInstrumentationKey string = avmInsightsComponent.outputs.instrumentationKey
output applicationInsightsConnectionString string = avmInsightsComponent.outputs.connectionString

output storageAccountName string = avmStorageAccount.outputs.name
