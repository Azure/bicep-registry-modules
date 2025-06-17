@description('Required. Name of the Cognitive Services resource. Must be unique in the resource group.')
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

@description('Specifies whether to enable network isolation. If true, the resource will be deployed in a private endpoint and public network access will be disabled.')
param networkIsolation bool

@description('Existing resource ID of the private DNS zone for the private endpoint.')
param privateDnsZonesResourceIds string[] = []

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentsType[] = []

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. A collection of rules governing the accessibility from specific network locations.')
param networkAcls object

var privateDnsZones = [
  for id in privateDnsZonesResourceIds: {
    privateDnsZoneResourceId: id
  }
]

var nameFormatted = take(toLower(name), 24)

module cognitiveService 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: take('cog-${kind}-${name}-deployment', 64)
  params: {
    name: nameFormatted
    location: location
    tags: tags
    sku: sku
    kind: kind
    allowProjectManagement: true
    managedIdentities: {
      systemAssigned: true
    }
    deployments: aiModelDeployments
    customSubDomainName: name
    disableLocalAuth: networkIsolation
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    roleAssignments: roleAssignments
    networkAcls: networkAcls
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: privateDnsZones
            }
            subnetResourceId: virtualNetworkSubnetResourceId
          }
        ]
      : []
  }
}

import { deploymentsType } from '../customTypes.bicep'
import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

output cognitiveResourceId string = cognitiveService.outputs.resourceId
output cognitiveName string = cognitiveService.outputs.name
output systemAssignedMIPrincipalId string? = cognitiveService.outputs.?systemAssignedMIPrincipalId
output cogntiveEndpoint string = cognitiveService.outputs.endpoint

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
    ApiType: 'Azure'
    Kind: kind
    ResourceId: cognitiveService.outputs.resourceId
  }
}
