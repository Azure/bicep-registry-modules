@description('Required. The AI Studio Hub Resource name.')
param name string

@description('Optional. The display name of the AI Studio Hub Resource.')
param displayName string = name

@description('Required. The storage account ID to use for the AI Studio Hub Resource.')
param storageAccountResourceId string

@description('Required. The key vault ID to use for the AI Studio Hub Resource.')
param keyVaultResourceId string

@description('Optional. The application insights ID to use for the AI Studio Hub Resource.')
param applicationInsightsResourceId string = ''

@description('Optional. The container registry ID to use for the AI Studio Hub Resource.')
param containerRegistryResourceId string = ''

@description('Required. The OpenAI Cognitive Services account name to use for the AI Studio Hub Resource.')
param openAiName string

@description('Optional. The Azure Cognitive Search service name to use for the AI Studio Hub Resource.')
param aiSearchName string = ''

@description('Required. The Azure Cognitive Search service connection name to use for the AI Studio Hub Resource.')
param aiSearchConnectionName string

@description('Required. The OpenAI Content Safety connection name to use for the AI Studio Hub Resource.')
param openAiContentSafetyConnectionName string

@description('Optional. The SKU name to use for the AI Studio Hub Resource.')
param skuName string = 'Basic'

@description('Optional. The SKU tier to use for the AI Studio Hub Resource.')
@allowed(['Basic', 'Free', 'Premium', 'Standard'])
param skuTier string = 'Basic'

@description('Optional. The public network access setting to use for the AI Studio Hub Resource.')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

// ================ //
// Resources        //
// ================ //

resource hub 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  kind: 'Hub'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: displayName
    storageAccount: storageAccountResourceId
    keyVault: keyVaultResourceId
    applicationInsights: !empty(applicationInsightsResourceId) ? applicationInsightsResourceId : null
    containerRegistry: !empty(containerRegistryResourceId) ? containerRegistryResourceId : null
    hbiWorkspace: false
    managedNetwork: {
      isolationMode: 'Disabled'
    }
    v1LegacyMode: false
    publicNetworkAccess: publicNetworkAccess
    discoveryUrl: 'https://${location}.api.azureml.ms/discovery'
  }

  resource openAiConnection 'connections@2024-04-01-preview' = {
    name: 'aoai-connection'
    properties: {
      category: 'AzureOpenAI'
      authType: 'ApiKey'
      isSharedToAll: true
      target: openAi.properties.endpoints['OpenAI Language Model Instance API']
      metadata: {
        ApiVersion: '2024-02-01'
        ApiType: 'azure'
        ResourceId: openAi.id
      }
      credentials: {
        key: openAi.listKeys().key1
      }
    }
  }

  resource contentSafetyConnection 'connections' = {
    name: openAiContentSafetyConnectionName
    properties: {
      category: 'AzureOpenAI'
      authType: 'ApiKey'
      isSharedToAll: true
      target: openAi.properties.endpoints['Content Safety']
      metadata: {
        ApiVersion: '2023-07-01-preview'
        ApiType: 'azure'
        ResourceId: openAi.id
      }
      credentials: {
        key: openAi.listKeys().key1
      }
    }
  }

  resource searchConnection 'connections' = if (!empty(aiSearchName)) {
    name: aiSearchConnectionName
    properties: {
      category: 'CognitiveSearch'
      authType: 'ApiKey'
      isSharedToAll: true
      target: 'https://${search.name}.search.windows.net/'
      credentials: {
        key: !empty(aiSearchName) ? search.listAdminKeys().primaryKey : ''
      }
    }
  }
}

resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: openAiName
}

resource search 'Microsoft.Search/searchServices@2021-04-01-preview' existing = if (!empty(aiSearchName)) {
  name: aiSearchName
}

// ================ //
// Outputs          //
// ================ //

output name string = hub.name
output resourceId string = hub.id
output principalId string = hub.identity.principalId
