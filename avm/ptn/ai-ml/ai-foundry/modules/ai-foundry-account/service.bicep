@description('Required. Name of the Cognitive Services resource. Must be unique in the resource group. Maximum 12 characters.')
@maxLength(12)
param name string

@description('Required. The location of the Cognitive Services resource.')
param location string

@description('Required. Kind of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'AIServices'
  'AnomalyDetector'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'ContentSafety'
  'ConversationalLanguageUnderstanding'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Face'
  'FormRecognizer'
  'HealthInsights'
  'ImmersiveReader'
  'Internal.AllInOne'
  'LUIS'
  'LUIS.Authoring'
  'LanguageAuthoring'
  'MetricsAdvisor'
  'OpenAI'
  'Personalizer'
  'QnAMaker.v2'
  'SpeechServices'
  'TextAnalytics'
  'TextTranslation'
])
param kind string

@description('Required. The SKU of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'S'
  'S0'
  'S1'
  'S2'
  'S3'
  'S4'
  'S5'
  'S6'
  'S7'
  'S8'
])
param sku string = 'S0'

@description('Category of the Cognitive Services account.')
param category string = 'CognitiveService'

@description('Optional. Existing resource ID of the private DNS zone for the private endpoint.')
param privateDnsZonesIds string[] = []

@description('Optional. Resource ID of the subnet for the private endpoints.')
param privateEndpointSubnetId string?

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.11.0'
@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentType[] = []

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var privateDnsZones = [
  for id in privateDnsZonesIds: {
    privateDnsZoneResourceId: id
  }
]

var networkIsolation = !empty(privateDnsZonesIds) && !empty(privateEndpointSubnetId)

module cognitiveService 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: take('cog-${kind}-${name}-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    sku: sku
    kind: kind
    lock: lock
    allowProjectManagement: true
    managedIdentities: {
      systemAssigned: true
    }
    deployments: aiModelDeployments
    customSubDomainName: name
    disableLocalAuth: networkIsolation
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    roleAssignments: roleAssignments
    networkAcls: {
      defaultAction: networkIsolation ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: privateDnsZones
            }
            subnetResourceId: privateEndpointSubnetId!
          }
        ]
      : []
    enableTelemetry: enableTelemetry
  }
}

output resourceId string = cognitiveService.outputs.resourceId
output name string = cognitiveService.outputs.name
output systemAssignedMIPrincipalId string? = cognitiveService.outputs.?systemAssignedMIPrincipalId
output endpoint string = cognitiveService.outputs.endpoint

output foundryConnection object = {
  name: cognitiveService.outputs.name
  value: null
  category: category
  target: cognitiveService.outputs.endpoint
  kind: kind
  connectionProperties: {
    authType: 'AAD'
  }
  isSharedToAll: true
  metadata: {
    apiType: 'Azure'
    Kind: kind
    ResourceId: cognitiveService.outputs.resourceId
  }
}
