// // ========== main.bicep ========== //
// targetScope = 'resourceGroup'

param location string
param tags object
param managedIdentity_name string
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
param storageAccount_name string
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

resource avm_managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentity_name
}

resource existing_keyvault_vaults 'Microsoft.keyvault/vaults@2024-04-01-preview' existing = {
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
  }
}

// AI Foundry: AI Services. NOTE: Why this m version?
// module avm_cognitive_services_accounts_m 'br/public:avm/res/cognitive-services/account:0.9.2' = {
//   name: format(deploymentNameFormat, aiServices_m_name)
//   params: {
//     name: aiServices_m_name
//     location: location
//     tags: tags
//     sku: 'S0'
//     kind: 'AIServices'
//     apiProperties: {
//       staticsEnabled: false
//     }
//   }
// }

// AI Foundry: AI Services. NOTE: Why this?
module avm_cognitive_services_accounts_cu 'br/public:avm/res/cognitive-services/account:0.9.2' = {
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
  }
}

resource deployed_avm_cognitive_services_accounts_cu 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiServices_cu_name
  dependsOn: [
    avm_cognitive_services_accounts_cu
  ]
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
  }
}

// AI Foundry: Storage account
module avm_storage_storage_account 'br/public:avm/res/storage/storage-account:0.9.0' = {
  name: format(deploymentNameFormat, storageAccount_name)
  params: {
    name: storageAccount_name
    location: location
    tags: tags
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    requireInfrastructureEncryption: true
    enableHierarchicalNamespace: false
    enableNfsV3: false
    // NOTE: Missing in AVM
    // keyPolicy: {
    //   keyExpirationPeriodInDays: 7
    // }
    largeFileSharesState: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    roleAssignments: [
      {
        principalId: avm_managed_identity.properties.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
    ]
  }
}

// AI Foundry: AI Hub
// NOTE: Evaluate if this is an appropriate solution or if we should manage keys through KV
resource deployed_avm_cognitive_services_accounts 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiServices_name
  scope: resourceGroup()
  dependsOn: [
    avm_cognitive_services_accounts
  ]
}

resource deployed_avm_search_search_services 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: searchService_name
  dependsOn: [
    avm_search_search_services
  ]
}

module avm_machine_learning_services_workspaces_aihub 'br/public:avm/res/machine-learning-services/workspace:0.10.0' = {
  name: format(deploymentNameFormat, machineLearningServicesWorkspaces_aihub_name)
  params: {
    name: machineLearningServicesWorkspaces_aihub_name
    location: location
    tags: tags
    // Missing in AVM:
    // friendlyName: aiHubFriendlyName
    managedIdentities: { systemAssigned: true }
    kind: 'Hub'
    sku: 'Basic' // Double check this
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    description: 'AI Hub for KM template'
    associatedKeyVaultResourceId: existing_keyvault_vaults.id
    associatedStorageAccountResourceId: avm_storage_storage_account.outputs.resourceId
    associatedContainerRegistryResourceId: avm_container_registry_registry.outputs.resourceId
    associatedApplicationInsightsResourceId: avm_insights_component.outputs.resourceId
    connections: [
      {
        name: 'connection-AzureOpenAI'
        category: 'AIServices'
        target: avm_cognitive_services_accounts.outputs.endpoint
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: avm_cognitive_services_accounts.outputs.resourceId
        }
        connectionProperties: {
          authType: 'ApiKey'
          credentials: {
            key: deployed_avm_cognitive_services_accounts.listKeys().key1
          }
        }
      }
      {
        name: 'connection-AzureAISearch'
        category: 'CognitiveSearch'
        target: 'https://${avm_search_search_services.outputs.name}.search.windows.net'
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: avm_search_search_services.outputs.resourceId
        }
        connectionProperties: {
          authType: 'ApiKey'
          credentials: {
            key: deployed_avm_search_search_services.listAdminKeys().primaryKey
          }
        }
      }
    ]
  }
}

module avm_machine_learning_services_workspaces_project 'br/public:avm/res/machine-learning-services/workspace:0.10.0' = {
  name: format(deploymentNameFormat, machineLearningServicesWorkspaces_project_name)
  params: {
    name: machineLearningServicesWorkspaces_project_name
    location: location
    sku: 'Basic' //NOTE: Confirm this
    kind: 'Project'
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    hubResourceId: avm_machine_learning_services_workspaces_aihub.outputs.resourceId
    managedIdentities: {
      systemAssigned: true
    }
  }
}

resource machine_learning_services_workspaces_project 'Microsoft.MachineLearningServices/workspaces@2024-10-01' existing = {
  name: machineLearningServicesWorkspaces_project_name
  dependsOn: [
    avm_machine_learning_services_workspaces_project
  ]
}

//TODO: Not deploying in available region - review why
//Model deployment guide: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/deploy-models-serverless?tabs=bicep
//Region availability: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/deploy-models-serverless-availability


resource machine_learning_services_workspaces_serverless_endpoint_phiModel 'Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01' = if (isInPhiList) {
  parent: machine_learning_services_workspaces_project
  location: location
  name: machineLearningServicesWorkspaces_phiServerless_name
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
}

// AI FOUNDRY: exported secrets

resource azureOpenAIInferenceEndpoint 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-INFERENCE-ENDPOINT'
  properties: {
    value: machine_learning_services_workspaces_serverless_endpoint_phiModel != null ? machine_learning_services_workspaces_serverless_endpoint_phiModel.properties.inferenceEndpoint.uri : ''
    // value: phiserverless.properties.inferenceEndpoint.uri
  }
}

resource azureOpenAIInferenceKey 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-INFERENCE-KEY'
  properties: {
    value: machine_learning_services_workspaces_serverless_endpoint_phiModel != null ? machine_learning_services_workspaces_serverless_endpoint_phiModel.listKeys().primaryKey : ''
    // listKeys(phiserverless.id, '2024-10-01').primaryKey
  }
}

resource azureOpenAIApiKeyEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-KEY'
  properties: {
    value: deployed_avm_cognitive_services_accounts.listKeys().key1 //aiServices_m.listKeys().key1
  }
}

resource azureOpenAIDeploymentModel 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPEN-AI-DEPLOYMENT-MODEL'
  properties: {
    value: aiServices_deployments[0].model.name
  }
}

resource azureOpenAIApiVersionEntry 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-PREVIEW-API-VERSION'
  properties: {
    value: gptModelVersionPreview  //'2024-02-15-preview'
  }
}

resource azureOpenAIEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-ENDPOINT'
  properties: {
    value: deployed_avm_cognitive_services_accounts.properties.endpoint //aiServices_m.properties.endpoint
  }
}

resource azureAIProjectConnectionStringEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-AI-PROJECT-CONN-STRING'
  properties: {
    value: '${split(machine_learning_services_workspaces_project.properties.discoveryUrl, '/')[2]};${subscription().subscriptionId};${resourceGroup().name};${machine_learning_services_workspaces_project.name}'
  }
}

resource azureOpenAICUEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-CU-ENDPOINT'
  properties: {
    value: deployed_avm_cognitive_services_accounts_cu.properties.endpoint
  }
}

resource azureOpenAICUApiKeyEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-CU-KEY'
  properties: {
    value: deployed_avm_cognitive_services_accounts_cu.listKeys().key1
  }
}

resource azureOpenAICUApiVersionEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-OPENAI-CU-VERSION'
  properties: {
    value: '?api-version=2024-12-01-preview'
  }
}

resource azureSearchAdminKeyEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-SEARCH-KEY'
  properties: {
    value: deployed_avm_search_search_services.listAdminKeys().primaryKey
  }
}

resource azureSearchServiceEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-SEARCH-ENDPOINT'
  properties: {
    value: 'https://${deployed_avm_search_search_services.name}.search.windows.net'
  }
}

resource azureSearchServiceEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-SEARCH-SERVICE'
  properties: {
    value: deployed_avm_search_search_services.name
  }
}

resource azureSearchIndexEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-SEARCH-INDEX'
  properties: {
    value: 'transcripts_index'
  }
}

resource cogServiceEndpointEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'COG-SERVICES-ENDPOINT'
  properties: {
    value: deployed_avm_cognitive_services_accounts.properties.endpoint
  }
}

resource cogServiceKeyEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'COG-SERVICES-KEY'
  properties: {
    value: deployed_avm_cognitive_services_accounts.listKeys().key1
  }
}

resource cogServiceNameEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'COG-SERVICES-NAME'
  properties: {
    value: deployed_avm_cognitive_services_accounts.name
  }
}

resource azureSubscriptionIdEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-SUBSCRIPTION-ID'
  properties: {
    value: subscription().subscriptionId
  }
}

resource resourceGroupNameEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-RESOURCE-GROUP'
  properties: {
    value: resourceGroup().name
  }
}

resource azureLocatioEntry 'Microsoft.keyvault/vaults/secrets@2021-11-01-preview' = {
  parent: existing_keyvault_vaults
  name: 'AZURE-LOCATION'
  properties: {
    value: location
  }
}

output keyvault_name string = existing_keyvault_vaults.name
output keyvault_id string = existing_keyvault_vaults.id

output aiServices_name string = avm_cognitive_services_accounts.outputs.name //aiServicesName_m
output aiServices_endpoint string = avm_cognitive_services_accounts.outputs.endpoint //aiServices_m.properties.endpoint
output aiServices_resourceId string = avm_cognitive_services_accounts.outputs.resourceId //aiServices_m.id

output machineLearningWorkspaces_phiInfereceEndpoint string = machine_learning_services_workspaces_serverless_endpoint_phiModel.properties.inferenceEndpoint.uri

output aiSearch_name string = avm_search_search_services.outputs.name
output aiSearch_resourceId string = avm_search_search_services.outputs.resourceId
output aiSearch_connectionString string = 'https://${avm_search_search_services.outputs.name}.search.windows.net'

output aiHub_project_name string = avm_machine_learning_services_workspaces_project.outputs.name
output aiHub_project_connectionString string = '${split(machine_learning_services_workspaces_project.properties.discoveryUrl, '/')[2]};${subscription().subscriptionId};${resourceGroup().name};${machine_learning_services_workspaces_project.name}'

output appInsights_resourceId string = avm_insights_component.outputs.resourceId
output appInsights_instrumentationKey string = avm_insights_component.outputs.instrumentationKey
