// // ========== main.bicep ========== //
// targetScope = 'resourceGroup'

param location string
param tags object
//param managedIdentity_name string
param avm_operational_insights_workspace_resourceId string
param applicationInsights_name string
param containerRegistry_name string
param keyVault_name string
param aiServices_name string
param aiServices_deployments array
param aiServices_cu_name string
param aiServices_cu_location string
//param aiServices_m_name string
param searchService_name string
param storageAccount_resource_id string
param machineLearningServicesWorkspaces_aihub_name string
param machineLearningServicesWorkspaces_project_name string
param machineLearningServicesWorkspaces_phiServerless_name string
param gptModelVersionPreview string
param deploymentVersion string = utcNow()

// VARIABLES
var deploymentNameFormat = '${deploymentVersion}-deploy-{0}'
var phiModelRegions = [
  'East US'
  'East US 2'
  'North Central US'
  'South Central US'
  'Sweden Central'
  'West US'
  'West US 3'
  'eastus'
  'eastus2'
  'northcentralus'
  'southcentralus'
  'swedencentral'
  'westus'
  'westus3'
]
var isInPhiList = contains(phiModelRegions, location)
var varPhiModelUrl = 'azureml://registries/azureml/models/Phi-4'
var varKvSecretNameAzureOpenaiKey = 'AZURE-OPENAI-KEY'
var varKvSecretNameAzureSearchKey = 'AZURE-SEARCH-KEY'
var azureAiProjectConnString = '${toLower(replace(avmMLServicesWorkspacesProject.outputs.location, ' ', ''))}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${avmMLServicesWorkspacesProject.outputs.name}'

resource existingKeyVaultResource 'Microsoft.keyvault/vaults@2024-04-01-preview' existing = {
  name: keyVault_name
}

// AI Foundry: Application Insights
module avm_insights_component 'br/public:avm/res/insights/component:0.5.0' = {
  name: format(deploymentNameFormat, applicationInsights_name)
  params: {
    name: applicationInsights_name
    workspaceResourceId: avm_operational_insights_workspace_resourceId //NOTE: Adding this due to AVM requirement
    location: location
    tags: tags
    kind: 'web'
    applicationType: 'web'
    disableIpMasking: false
    disableLocalAuth: false
    // MISSING: Flow_Type: 'Bluefield'
    forceCustomerStorageForProfiler: false
    // MISSING: ImmediatePurgeDataOn30Days: true
    // MISSING: IngestionMode: 'ApplicationInsights'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Disabled'
    // MISSING: Request_Source: 'rest'
  }
}

// AI Foundry: Container Registry
module avm_container_registry_registry 'br/public:avm/res/container-registry/registry:0.8.3' = {
  name: format(deploymentNameFormat, containerRegistry_name)
  params: {
    name: containerRegistry_name
    location: location
    tags: tags
    acrSku: 'Premium'
    acrAdminUserEnabled: true
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
// NOTE: Create a loop to deploy multiple accounts and models
module avm_cognitive_services_accounts 'br/public:avm/res/cognitive-services/account:0.9.2' = {
  name: format(deploymentNameFormat, aiServices_name)
  params: {
    name: aiServices_name
    disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
    location: location
    tags: tags
    sku: 'S0'
    kind: 'AIServices'
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' //Not in original script, check this
    deployments: [
      for aiModelDeployment in aiServices_deployments: {
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

// AI Foundry: AI Services. NOTE: Why this?
module avm_cognitive_services_accounts_cu 'br/public:avm/res/cognitive-services/account:0.10.1' = {
  name: format(deploymentNameFormat, aiServices_cu_name)
  params: {
    name: aiServices_cu_name
    location: aiServices_cu_location
    tags: tags
    disableLocalAuth: false //Added this in order to retrieve the keys. Evaluate alternatives
    sku: 'S0'
    kind: 'AIServices'
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    secretsExportConfiguration: {
      keyVaultResourceId: existingKeyVaultResource.id
      accessKey1Name: 'AZURE-OPENAI-CU-KEY'
    }
  }
}

resource azureOpenAICUEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-CU-ENDPOINT'
  properties: {
    //value: 'https://${avm_cognitive_services_accounts_cu.outputs.name}.cognitiveservices.azure.com/'
    value: avm_cognitive_services_accounts_cu.outputs.endpoint //deployed_avm_cognitive_services_accounts_cu.properties.endpoint
    //NOTE: Check if this is the correct endpoint
  }
}

// AI Foundry: AI Search
module avm_search_search_services 'br/public:avm/res/search/search-service:0.9.0' = {
  name: format(deploymentNameFormat, searchService_name)
  params: {
    name: searchService_name
    location: location
    tags: tags
    sku: 'basic'
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
  name: 'module-ai-foundry-ai-hub'
  params: {
    deploymentName: format(deploymentNameFormat, machineLearningServicesWorkspaces_aihub_name)
    aiServicesName: avm_cognitive_services_accounts_cu.outputs.name
    searchServiceName: avm_search_search_services.outputs.name
    aiHubName: machineLearningServicesWorkspaces_aihub_name
    location: location
    tags: tags
    keyVaultResourceId: existingKeyVaultResource.id
    containerRegistryResourceId: avm_container_registry_registry.outputs.resourceId
    applicationInsightsResourceId: avm_insights_component.outputs.resourceId
    storageAccountResourceId: storageAccount_resource_id
    cognitiveServicesEndpoint: avm_cognitive_services_accounts.outputs.endpoint
    cognitiveServicesResourceId: avm_cognitive_services_accounts.outputs.resourceId
    searchServicesEndpoint: 'https://${avm_search_search_services.outputs.name}.search.windows.net'
    searchServicesResourceId: avm_search_search_services.outputs.resourceId
  }
}

// AI Foundry: AI Workspace Project

module avmMLServicesWorkspacesProject 'br/public:avm/res/machine-learning-services/workspace:0.10.0' = {
  name: format(deploymentNameFormat, machineLearningServicesWorkspaces_project_name)
  params: {
    name: machineLearningServicesWorkspaces_project_name
    location: location
    sku: 'Basic' //NOTE: Confirm this
    kind: 'Project'
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    hubResourceId: moduleAIHub.outputs.resourceId
    managedIdentities: {
      systemAssigned: true
    }
  }
}

//TODO: Not deploying in available region - review why
//Model deployment guide: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/deploy-models-serverless?tabs=bicep
//Region availability: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/deploy-models-serverless-availability

resource machine_learning_services_workspaces_serverless_endpoint_phiModel 'Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01' = if (isInPhiList) {
  //  parent: deployedMLServicesWorkspacesProject
  location: location
  #disable-next-line use-parent-property
  name: '${machineLearningServicesWorkspaces_project_name}/${machineLearningServicesWorkspaces_phiServerless_name}'
  properties: {
    authMode: 'Key'
    contentSafety: {
      contentSafetyStatus: 'Enabled'
    }
    modelSettings: {
      #disable-next-line use-resource-id-functions
      modelId: varPhiModelUrl
    }
  }
  sku: {
    name: 'Consumption'
    tier: 'Free'
  }
  dependsOn: [
    avmMLServicesWorkspacesProject
  ]
}

// AI FOUNDRY: exported secrets

resource azureOpenAIInferenceEndpoint 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-INFERENCE-ENDPOINT'
  properties: {
    // value: machine_learning_services_workspaces_serverless_endpoint_phiModel != null
    //  ? machine_learning_services_workspaces_serverless_endpoint_phiModel.properties.inferenceEndpoint.uri
    //  : ''
    // value: phiserverless.properties.inferenceEndpoint.uri
    value: ''
  }
}

resource azureOpenAIInferenceKey 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-INFERENCE-KEY'
  properties: {
    value: machine_learning_services_workspaces_serverless_endpoint_phiModel != null
      ? machine_learning_services_workspaces_serverless_endpoint_phiModel.listKeys().primaryKey
      : ''
    // listKeys(phiserverless.id, '2024-10-01').primaryKey
  }
}

resource azureOpenAIDeploymentModel 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPEN-AI-DEPLOYMENT-MODEL'
  properties: {
    value: aiServices_deployments[0].model.name
  }
}

resource azureOpenAIApiVersionEntry 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-PREVIEW-API-VERSION'
  properties: {
    value: gptModelVersionPreview //'2024-02-15-preview'
  }
}

resource azureOpenAIEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-ENDPOINT'
  properties: {
    value: avm_cognitive_services_accounts.outputs.endpoint
  }
}

resource azureAIProjectConnectionStringEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-AI-PROJECT-CONN-STRING'
  properties: {
    //value: '${split(deployedMLServicesWorkspacesProject.properties.discoveryUrl, '/')[2]};${subscription().subscriptionId};${resourceGroup().name};${deployedMLServicesWorkspacesProject.name}'
    value: azureAiProjectConnString
  }
}

resource azureOpenAICUApiVersionEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-OPENAI-CU-VERSION'
  properties: {
    value: '?api-version=2024-12-01-preview'
  }
}

resource azureSearchServiceEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-SEARCH-ENDPOINT'
  properties: {
    value: 'https://${avm_search_search_services.outputs.name}.search.windows.net'
  }
}

resource azureSearchServiceEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-SEARCH-SERVICE'
  properties: {
    value: avm_search_search_services.outputs.name
  }
}

resource azureSearchIndexEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-SEARCH-INDEX'
  properties: {
    value: 'transcripts_index'
  }
}

resource cogServiceEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'COG-SERVICES-ENDPOINT'
  properties: {
    value: avm_cognitive_services_accounts.outputs.endpoint
  }
}

module aiFoundryKvSecretCogServicesKey './ai-foundry-kv-secret-cog-services-key.bicep' = {
  name: 'module-ai-foundry-kv-secret-cog-services-key'
  params: {
    keyVaultResourceName: keyVault_name
    cognitiveServicesAccountsResourceName: avm_cognitive_services_accounts.outputs.name
  }
}

resource cogServiceNameEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'COG-SERVICES-NAME'
  properties: {
    value: avm_cognitive_services_accounts.outputs.name
  }
}

resource azureSubscriptionIdEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-SUBSCRIPTION-ID'
  properties: {
    value: subscription().subscriptionId
  }
}

resource resourceGroupNameEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-RESOURCE-GROUP'
  properties: {
    value: resourceGroup().name
  }
}

resource azureLocatioEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existingKeyVaultResource
  name: 'AZURE-LOCATION'
  properties: {
    value: location
  }
}

output keyvault_name string = existingKeyVaultResource.name
output keyvault_id string = existingKeyVaultResource.id

output aiServices_name string = avm_cognitive_services_accounts.outputs.name //aiServicesName_m
output aiServices_endpoint string = avm_cognitive_services_accounts.outputs.endpoint //aiServices_m.properties.endpoint
output aiServices_resourceId string = avm_cognitive_services_accounts.outputs.resourceId //aiServices_m.id

output machineLearningWorkspaces_phiInfereceEndpoint string = machine_learning_services_workspaces_serverless_endpoint_phiModel.properties.inferenceEndpoint.uri

output aiSearch_name string = avm_search_search_services.outputs.name
output aiSearch_resourceId string = avm_search_search_services.outputs.resourceId
output aiSearch_connectionString string = 'https://${avm_search_search_services.outputs.name}.search.windows.net'

output aiHub_project_name string = avmMLServicesWorkspacesProject.outputs.name
output aiHub_project_resourceId string = avmMLServicesWorkspacesProject.outputs.resourceId
output aiHub_project_connectionString string = azureAiProjectConnString

output appInsights_resourceId string = avm_insights_component.outputs.resourceId
output appInsights_instrumentationKey string = avm_insights_component.outputs.instrumentationKey
