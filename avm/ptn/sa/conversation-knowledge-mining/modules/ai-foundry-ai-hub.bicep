// NOTE: This module is required to pass keys from previously deployed resources leveraging the existing keyword
// This behavior will be updated in future versions to leverage more secure solutions such as Key Vault or manag

param deploymentName string
param aiServicesName string
param searchServiceName string
param aiHubName string
param location string
param tags object
param keyVaultResourceId string
param containerRegistryResourceId string
param applicationInsightsResourceId string
param storageAccountResourceId string
param cognitiveServicesEndpoint string
param cognitiveServicesResourceId string
param searchServicesEndpoint string
param searchServicesResourceId string

resource deployed_avm_cognitive_services_accounts 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiServicesName
}

resource deployed_avm_search_search_services 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: searchServiceName
}

module avmMachineLearningServicesWorkspacesAiHub 'br/public:avm/res/machine-learning-services/workspace:0.10.1' = {
  name: deploymentName
  params: {
    name: aiHubName
    location: location
    tags: tags
    // Missing in AVM:
    // friendlyName: aiHubFriendlyName
    managedIdentities: { systemAssigned: true }
    kind: 'Hub'
    sku: 'Basic' // Double check this
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    description: 'AI Hub for KM template'
    associatedKeyVaultResourceId: keyVaultResourceId
    associatedStorageAccountResourceId: storageAccountResourceId
    associatedContainerRegistryResourceId: containerRegistryResourceId
    associatedApplicationInsightsResourceId: applicationInsightsResourceId
    connections: [
      {
        name: 'connection-AzureOpenAI'
        category: 'AIServices'
        target: cognitiveServicesEndpoint
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: cognitiveServicesResourceId
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
        target: searchServicesEndpoint //'https://${SearchServicesName}.search.windows.net'
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: searchServicesResourceId
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

output resourceId string = avmMachineLearningServicesWorkspacesAiHub.outputs.resourceId
