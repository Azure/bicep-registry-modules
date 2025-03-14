// NOTE: This module is designed to be replaced in the future with an AVM patter module with AI Foundry services
@description('Required. The location of the AI Hub resource to be deployed.')
param aiHubLocation string
@description('Required. The name of the AI Hub resource to be deployed.')
param aiHubResourceName string
@description('Required. The SKU of the AI Hub resource to be deployed.')
param aiHubSkuName string
@description('Required. The location of the AI Project resource to be deployed.')
param aiProjectLocation string
@description('Required. The name of the AI Project resource to be deployed.')
param aiProjectResourceName string
@description('Required. The SKU of the AI Project resource to be deployed.')
param aiProjectSkuName string
@description('Required. The location of the AI Service Content Understanding resource to be deployed.')
param aiServicesContentUnderstandingLocation string
@description('Required. The name of the AI Service Content Understanding resource to be deployed.')
param aiServicesContentUnderstandingResourceName string
@description('Required. The SKU of the AI Service Content Understanding resource to be deployed.')
param aiServicesContentUnderstandingSkuName string
@description('Required. The location of the AI Service resource to be deployed.')
param aiServicesLocation string
@description('Required. The AI Model deployments configuration of the AI Service resource to be deployed.')
param aiServicesModelDeployments array
@description('Required. The name of the AI Service resource to be deployed.')
param aiServicesResourceName string
@description('Required. The SKU of the AI Service resource to be deployed.')
param aiServicesSkuName string
@description('Required. The location of the Application Insights resource to be deployed.')
param applicationInsightsLocation string
@description('Required. The name of the Application Insights resource to be deployed.')
param applicationInsightsResourceName string
@description('Required. The data retention configuration of the Application Insights resource to be deployed.')
param applicationInsightsRetentionInDays int
@description('Required. The format to apply to the deployment names of the AVM resource modules.')
param avmDeploymentNameFormat string
@description('Required. The location of the Container Registry resource to be deployed.')
param containerRegistryLocation string
@description('Required. The name of the Container Registry resource to be deployed.')
param containerRegistryResourceName string
@description('Required. The SKU of the Container Registry resource to be deployed.')
param containerRegistrySkuName string
@description('Required. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true
@description('Required. The name the of existing Key Vault to store Conversation Knowledge Mining related secrets.')
param keyVaultResourceName string
@description('Required. The format to apply to the deployment names of the local modules.')
param localModuleDeploymentNameFormat string
@description('Required. The resource ID of the resource log analytic workspace to send Diagnostic logs from all resources.')
param logAnalyticsWorkspaceResourceId string
@description('Required. The principal ID of the managed identity to give required RBAC permissions.')
param managedIdentityPrincipalId string
@description('Required. The location of the Search Service resource to deploy.')
param searchServiceLocation string
@description('Required. The name of the Search Service resource to deploy.')
param searchServiceResourceName string
@description('Required. The SKU of the Search Service resource to deploy.')
param searchServiceSkuName string
@description('Required. The location of the storage account resource to deploy.')
param storageAccountLocation string
@description('Required. The name of the storage account resource to deploy.')
param storageAccountResourceName string
@description('Required. The SKU of the storage account resource to deploy.')
param storageAccountSkuName string
@description('Required. The tags to apply to all deployed Azure resources.')
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
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
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

@description('The resource name of the deployed AI Services resource.')
//output aiServicesName string = cognitiveServicesAccounts.name
output aiServicesName string = avmCognitiveServicesAccounts.outputs.name
@description('The endpoint of the deployed AI Services resource.')
//output aiServicesEndpoint string = cognitiveServicesAccounts.properties.endpoint //aiServices_m.properties.endpoint
output aiServicesEndpoint string = avmCognitiveServicesAccounts.outputs.endpoint //aiServices_m.properties.endpoint
@description('The resource ID of the deployed AI Services resource.')
//output aiServicesResourceId string = cognitiveServicesAccounts.id
output aiServicesResourceId string = avmCognitiveServicesAccounts.outputs.resourceId

@description('The resource name of the deployed Search Service resource.')
output aiSearchName string = avmSearchSearchServices.outputs.name
@description('The resource ID of the deployed Search Service resource.')
output aiSearchResourceId string = avmSearchSearchServices.outputs.resourceId
@description('The connection string of the deployed Search Service resource.')
output aiSearchConnectionString string = 'https://${avmSearchSearchServices.outputs.name}.search.windows.net'

@description('The resource name of the deployed AI Project resource.')
output aiProjectName string = avmMLServicesWorkspacesProject.outputs.name
@description('The resource ID of the deployed AI Project resource.')
output aiProjectResourceId string = avmMLServicesWorkspacesProject.outputs.resourceId

@description('The resource ID of the deployed Application Insights resource.')
output applicationInsightsResourceId string = avmInsightsComponent.outputs.resourceId
@description('The instrumentation key of the deployed Application Insights resource.')
output applicationInsightsInstrumentationKey string = avmInsightsComponent.outputs.instrumentationKey
@description('The connection string of the deployed Application Insights resource.')
output applicationInsightsConnectionString string = avmInsightsComponent.outputs.connectionString

@description('The resource name of the deployed Storage Account resource.')
output storageAccountName string = avmStorageAccount.outputs.name
