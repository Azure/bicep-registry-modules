// NOTE: This module is required to pass keys from previously deployed resources leveraging the existing keyword
// This behavior will be updated in future versions to leverage more secure solutions such as Key Vault or managed identities
@description('Required. The deployment name of the AI Hub resource.')
param deploymentName string
@description('Required. The name of the AI Services resource whose keys will be used to connect to the AI Hub.')
param aiServicesName string
@description('Required. The name of the Search Services resource whose keys will be used to connect to the AI Hub.')
param searchServiceName string
@description('Required. The name of the AI Hub resource to be created.')
param aiHubName string
@description('Required. The SKU of the AI Hub resource to be created.')
param sku string
@description('Required. The location of the AI Hub resource to be created.')
param location string
@description('Required. The tags to be applied to the AI Hub resource.')
param tags object
@description('Required. The resource ID of the Key Vault resource to be associated with the AI Hub.')
param keyVaultResourceId string
@description('Required. The resource ID of the container registry to be associated with the AI Hub.')
param containerRegistryResourceId string
@description('Required. The resource ID of the Application Insights resource to be associated with the AI Hub.')
param applicationInsightsResourceId string
@description('Required. The resource ID of the storage account to be associated with the AI Hub.')
param storageAccountResourceId string
@description('Required. The endpoint of the Cognitive Service to be associated with the AI Hub.')
param cognitiveServicesEndpoint string
@description('Required. The resource ID of the Cognitive Service to be associated with the AI Hub.')
param cognitiveServicesResourceId string
@description('Required. The endpoint of the Search Services to be associated with the AI Hub.')
param searchServicesEndpoint string
@description('Required. The resource ID of the Search Services to be associated with the AI Hub.')
param searchServicesResourceId string
@description('Required. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true
@description('Required. The resource ID of the Log Analytics workspace used to capture diagnostic logs of the AI Hub.')
param logAnalyticsWorkspaceResourceId string

resource existingAiServicesResource 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiServicesName
}

resource existingSearchServiceResource 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: searchServiceName
}

module avmMachineLearningServicesWorkspacesAiHub 'br/public:avm/res/machine-learning-services/workspace:0.10.1' = {
  name: deploymentName
  params: {
    name: aiHubName
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    // friendlyName: aiHubFriendlyName    // Missing in AVM:
    managedIdentities: { systemAssigned: true }
    kind: 'Hub'
    sku: sku
    publicNetworkAccess: 'Enabled' // Not in original script, check this
    description: 'AI Hub for Conversation Knowledge Mining template'
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
            key: existingAiServicesResource.listKeys().key1
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
            key: existingSearchServiceResource.listAdminKeys().primaryKey
          }
        }
      }
    ]
  }
}

@description('The resource ID of the AI Hub resource created by this module.')
output resourceId string = avmMachineLearningServicesWorkspacesAiHub.outputs.resourceId
