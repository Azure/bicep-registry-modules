metadata name = 'AI Services and Project Module'
metadata description = 'This module creates an AI Services resource and an AI Foundry project within it. It supports private networking, OpenAI deployments, and role assignments.'

@description('Required. Name of the Cognitive Services resource. Must be unique in the resource group.')
param name string

@description('Optional. The location of the Cognitive Services resource.')
param location string = resourceGroup().location

@description('Optional. Kind of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
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
param kind string = 'AIServices'

@description('Optional. The SKU of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
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

@description('Required. The name of the AI Foundry project to create.')
param projectName string

@description('Optional. The description of the AI Foundry project to create.')
param projectDescription string = projectName

@secure() // marked secure to meet AVM validation requirements
@description('Optional. The resource ID of the Log Analytics workspace to use for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string?

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.10.2'
@description('Optional. Specifies the OpenAI deployments to create.')
param deployments deploymentType[] = []

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[] = []

@description('Optional. Values to establish private networking for the AI Services resource.')
param privateNetworking aiServicesPrivateNetworkingType?

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module cognitiveServicesPrivateDnsZone '../privateDnsZone.bicep' = if (privateNetworking != null && empty(privateNetworking.?cogServicesPrivateDnsZoneResourceId)) {
  name: take('${name}-cognitiveservices-pdns-deployment', 64)
  params: {
    name: 'privatelink.cognitiveservices.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: privateNetworking.?virtualNetworkResourceId ?? ''
    tags: tags
  }
}

module openAiPrivateDnsZone '../privateDnsZone.bicep' = if (privateNetworking != null && empty(privateNetworking.?openAIPrivateDnsZoneResourceId)) {
  name: take('${name}-openai-pdns-deployment', 64)
  params: {
    name: 'privatelink.openai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: privateNetworking.?virtualNetworkResourceId ?? ''
    tags: tags
  }
}

module aiServicesPrivateDnsZone '../privateDnsZone.bicep' = if (privateNetworking != null && empty(privateNetworking.?aiServicesPrivateDnsZoneResourceId)) {
  name: take('${name}-ai-services-pdns-deployment', 64)
  params: {
    name: 'privatelink.services.ai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkResourceId: privateNetworking.?virtualNetworkResourceId ?? ''
    tags: tags
  }
}

var cogServicesPrivateDnsZoneResourceId = privateNetworking != null
  ? (empty(privateNetworking.?cogServicesPrivateDnsZoneResourceId)
      ? cognitiveServicesPrivateDnsZone.outputs.resourceId ?? ''
      : privateNetworking.?cogServicesPrivateDnsZoneResourceId)
  : ''
var openAIPrivateDnsZoneResourceId = privateNetworking != null
  ? (empty(privateNetworking.?openAIPrivateDnsZoneResourceId)
      ? openAiPrivateDnsZone.outputs.resourceId ?? ''
      : privateNetworking.?openAIPrivateDnsZoneResourceId)
  : ''

var aiServicesPrivateDnsZoneResourceId = privateNetworking != null
  ? (empty(privateNetworking.?aiServicesPrivateDnsZoneResourceId)
      ? aiServicesPrivateDnsZone.outputs.resourceId ?? ''
      : privateNetworking.?aiServicesPrivateDnsZoneResourceId)
  : ''

module cognitiveService 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: take('${name}-aiservices-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [cognitiveServicesPrivateDnsZone, openAiPrivateDnsZone] // required due to optional flags that could change dependency
  params: {
    name: name
    location: location
    tags: tags
    sku: sku
    kind: kind
    allowProjectManagement: true
    managedIdentities: {
      systemAssigned: true
    }
    deployments: deployments
    customSubDomainName: name
    disableLocalAuth: privateNetworking != null
    publicNetworkAccess: privateNetworking != null ? 'Disabled' : 'Enabled'
    diagnosticSettings: !empty(logAnalyticsWorkspaceResourceId)
      ? [
          {
            workspaceResourceId: logAnalyticsWorkspaceResourceId
          }
        ]
      : []
    roleAssignments: roleAssignments
    privateEndpoints: privateNetworking != null
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: cogServicesPrivateDnsZoneResourceId
                }
                {
                  privateDnsZoneResourceId: openAIPrivateDnsZoneResourceId
                }
                {
                  privateDnsZoneResourceId: aiServicesPrivateDnsZoneResourceId
                }
              ]
            }
            subnetResourceId: privateNetworking.?subnetResourceId ?? ''
          }
        ]
      : []
    enableTelemetry: enableTelemetry
  }
}

module aiProject 'project.bicep' = {
  name: take('${name}-ai-project-${projectName}-deployment', 64)
  params: {
    name: projectName
    desc: projectDescription
    aiServicesName: cognitiveService.outputs.name
    location: location
    roleAssignments: roleAssignments
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('Name of the Cognitive Services resource.')
output name string = cognitiveService.outputs.name

@secure() // marked secure to meet AVM validation requirements
@description('Resource ID of the Cognitive Services resource.')
output resourceId string = cognitiveService.outputs.resourceId

@description('Principal ID of the system assigned managed identity for the Cognitive Services resource. This is only available if the resource has a system assigned managed identity.')
output systemAssignedMIPrincipalId string? = cognitiveService.outputs.?systemAssignedMIPrincipalId

@description('The endpoint of the Cognitive Services resource.')
output endpoint string = cognitiveService.outputs.endpoint

import { aiProjectOutputType } from 'project.bicep'
@description('AI Foundry Project information.')
output project aiProjectOutputType = {
  name: aiProject.name
  resourceId: aiProject.outputs.resourceId
  apiEndpoint: aiProject.outputs.apiEndpoint
}

@export()
@description('A custom AVM-aligned type for a role assignment for AI Services and Project.')
type aiServicesRoleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the role definition GUID or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionId: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?
}

@export()
@description('Values to establish private networking for resources that support createing private endpoints.')
type aiServicesPrivateNetworkingType = {
  @description('Required. The Resource ID of the virtual network.')
  virtualNetworkResourceId: string

  @description('Required. The Resource ID of the subnet to establish the Private Endpoint(s).')
  subnetResourceId: string

  @description('Optional. The Resource ID of an existing "cognitiveservices" Private DNS Zone Resource to link to the virtual network. If not provided, a new "cognitiveservices" Private DNS Zone(s) will be created.')
  cogServicesPrivateDnsZoneResourceId: string?

  @description('Optional. The Resource ID of an existing "openai" Private DNS Zone Resource to link to the virtual network. If not provided, a new "openai" Private DNS Zone(s) will be created.')
  openAIPrivateDnsZoneResourceId: string?

  @description('Optional. The Resource ID of an existing "services.ai" Private DNS Zone Resource to link to the virtual network. If not provided, a new "services.ai" Private DNS Zone(s) will be created.')
  aiServicesPrivateDnsZoneResourceId: string?
}
