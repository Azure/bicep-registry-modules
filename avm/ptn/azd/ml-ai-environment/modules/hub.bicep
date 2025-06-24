@description('Required. The AI Studio Hub Resource name.')
param name string

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
@allowed(['Basic', 'Free', 'Premium', 'Standard'])
param skuName string = 'Basic'

@description('Optional. The public network access setting to use for the AI Studio Hub Resource.')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

var aiSearchConnection = !empty(aiSearchName) ? [{
  name: aiSearchConnectionName
  category: 'CognitiveSearch'
  isSharedToAll: true
  target: 'https://${search.name}.search.windows.net/'
  connectionProperties: {
    authType: 'ApiKey'
    credentials: {
      key: !empty(aiSearchName) ? search.listAdminKeys().primaryKey : ''
    }
  }
}] : []

var connections = [
  {
    name: 'aoai-connection'
    category: 'AzureOpenAI'
    isSharedToAll: true
    metadata: {
      ApiVersion: '2024-02-01'
      ApiType: 'azure'
      ResourceId: openAi.id
    }
    target: openAi.properties.endpoints['OpenAI Language Model Instance API']
    connectionProperties: {
      authType: 'ApiKey'
      credentials: {
        key: openAi.listKeys().key1
      }
    }
  }
  {
    name: openAiContentSafetyConnectionName
    category: 'AzureOpenAI'
    isSharedToAll: true
    target: openAi.properties.endpoints['Content Safety']
    metadata: {
      ApiVersion: '2023-07-01-preview'
      ApiType: 'azure'
      ResourceId: openAi.id
    }
    connectionProperties: {
      authType: 'ApiKey'
      credentials: {
        key: openAi.listKeys().key1
      }
    }
  }
]

// ================ //
// Resources        //
// ================ //

resource openAi 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: openAiName
}

resource search 'Microsoft.Search/searchServices@2021-04-01-preview' existing = if (!empty(aiSearchName)) {
  name: aiSearchName
}

module hub 'br/public:avm/res/machine-learning-services/workspace:0.8.1' = {
  name: 'hub-workspace'
  params: {
    name: name
    sku: skuName
    location: location
    tags: tags
    kind: 'Hub'
    associatedKeyVaultResourceId: keyVaultResourceId
    associatedStorageAccountResourceId: storageAccountResourceId
    associatedApplicationInsightsResourceId: !empty(applicationInsightsResourceId) ? applicationInsightsResourceId : null
    associatedContainerRegistryResourceId: !empty(containerRegistryResourceId) ? containerRegistryResourceId : null
    hbiWorkspace: false
    managedNetworkSettings: {
      isolationMode: 'Disabled'
    }
    publicNetworkAccess: publicNetworkAccess
    discoveryUrl: 'https://${location}.api.azureml.ms/discovery'
    connections: union(connections, aiSearchConnection)
  }
}

// ================ //
// Outputs          //
// ================ //

output name string = hub.name
output resourceId string = hub.outputs.resourceId
output principalId string = hub.outputs.systemAssignedMIPrincipalId
