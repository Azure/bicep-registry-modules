param name string
param tags object
param location string
param sku string
param storageAccountResourceId string
param logAnalyticsWorkspaceResourceId string
param applicationInsightsResourceId string
param aiFoundryAiServicesName string
param enableTelemetry bool
param virtualNetworkEnabled bool
import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
param privateEndpoints privateEndpointSingleServiceType[]

resource aiServices 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: aiFoundryAiServicesName
}

module aiFoundryAiHub 'br/public:avm/res/machine-learning-services/workspace:0.12.1' = {
  name: take('avm.res.machine-learning-services.workspace.${name}', 64)
  params: {
    name: name
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    kind: 'Hub'
    sku: sku
    description: 'AI Hub for Multi Agent Custom Automation Engine Solution Accelerator template'
    //associatedKeyVaultResourceId: keyVaultResourceId
    associatedStorageAccountResourceId: storageAccountResourceId
    systemDatastoresAuthMode: 'Identity'
    associatedApplicationInsightsResourceId: applicationInsightsResourceId
    //primaryUserAssignedIdentity: managedIdentityResourceId //Required if 'userAssignedIdentities' is not empty
    managedIdentities: {
      // userAssignedResourceIds: [
      //   managedIdentityResourceId
      // ]
      systemAssigned: true
    }
    provisionNetworkNow: virtualNetworkEnabled ? true : null
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
          authType: 'AAD'
        }
      }
    ]
    publicNetworkAccess: 'Enabled' //TODO: Connection between Container App and AI Hub not working through private endpoints //virtualNetworkEnabled ? 'Disabled' : 'Enabled'
    //publicNetworkAccess: 'Enabled' //TODO: connection via private endpoint is not working from containers network. Change this when fixed
    managedNetworkSettings: virtualNetworkEnabled
      ? {
          isolationMode: 'AllowInternetOutbound'
          outboundRules: null //TODO: Refine this
        }
      : null
    privateEndpoints: privateEndpoints
  }
}

output resourceId string = aiFoundryAiHub.outputs.resourceId
output systemAssignedMIPrincipalId string = aiFoundryAiHub.outputs.?systemAssignedMIPrincipalId!
