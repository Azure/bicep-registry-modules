param name string
param tags object
param location string
param storageAccountResourceId string
param logAnalyticsWorkspaceResourceId string
param applicationInsightsResourceId string
param aiFoundryAiServicesName string
param enableTelemetry bool

resource aiServices 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: aiFoundryAiServicesName
}

module aiFoundryAiHub 'br/public:avm/res/machine-learning-services/workspace:0.10.1' = {
  name: 'avm.ptn.sa.macae.machine-learning-services-workspace-hub'
  params: {
    name: name
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    kind: 'Hub'
    sku: 'Basic'
    publicNetworkAccess: 'Enabled'
    description: 'AI Hub for Multi Agent Custom Automation Engine Solution Accelerator template'
    //associatedKeyVaultResourceId: keyVaultResourceId
    associatedStorageAccountResourceId: storageAccountResourceId
    associatedApplicationInsightsResourceId: applicationInsightsResourceId
    connections: [
      {
        name: 'connection-AzureOpenAI'
        category: 'AIServices'
        target: aiServices.properties.endpoint
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: aiServices.id
        }
        connectionProperties: {
          authType: 'ApiKey'
          credentials: {
            key: aiServices.listKeys().key1
          }
        }
      }
    ]
  }
}

output resourceId string = aiFoundryAiHub.outputs.resourceId
