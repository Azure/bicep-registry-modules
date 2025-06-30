@description('Required. Name of the Cognitive Services resource. Must be unique in the resource group.')
param name string

@description('Required. Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

@description('Required. Specifies whether network isolation is enabled. When true, Foundry and related components will be deployed, network access parameters will be set to Disabled.')
param networkIsolation bool

@description('Required. Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Required. Resource ID of the virtual network to link the private DNS zones only required if networkIsolation is true.')
param virtualNetworkResourceId string

@description('Required. Resource ID of the subnet for the private endpoint only required if networkIsolation is true.')
param virtualNetworkSubnetResourceId string

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.11.0'
@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentType[] = []

@description('Required. Whether to include Azure AI Content Safety in the deployment.')
param contentSafetyEnabled bool

@description('Required. A collection of rules governing the accessibility from specific network locations.')
param networkAcls object

@description('Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.')
param aiFoundryType string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module cognitiveServicesPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-cognitiveservices-deployment'
  params: {
    name: 'privatelink.cognitiveservices.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module openAiPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-openai-deployment'
  params: {
    name: 'privatelink.openai.${toLower(environment().name) == 'azureusgovernment' ? 'azure.us' : 'azure.com'}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module aiServices 'service.bicep' = {
  name: take('${name}-ais', 12)
  params: {
    name: take('ai${name}', 12)
    location: location
    kind: 'AIServices'
    category: 'AIServices'
    networkIsolation: networkIsolation
    networkAcls: toLower(aiFoundryType) == 'standardprivate'
      ? networkAcls
      : {
          defaultAction: 'Allow'
          bypass: 'AzureServices'
        }
    virtualNetworkSubnetResourceId: networkIsolation ? virtualNetworkSubnetResourceId : ''
    privateDnsZonesResourceIds: networkIsolation
      ? [
          cognitiveServicesPrivateDnsZone.outputs.resourceId
          openAiPrivateDnsZone.outputs.resourceId
        ]
      : []

    aiModelDeployments: aiModelDeployments
    roleAssignments: empty(userObjectId)
      ? []
      : [
          {
            principalId: userObjectId
            // Allow for either User or ServicePrincipal
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
          }
          {
            principalId: userObjectId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services Contributor'
          }
          {
            principalId: userObjectId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services User'
          }
        ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module contentSafety 'service.bicep' = if (contentSafetyEnabled) {
  name: take('${name}-cnt', 12)
  params: {
    name: take('sf${name}', 12)
    location: location
    kind: 'ContentSafety'
    networkIsolation: networkIsolation
    networkAcls: networkAcls
    virtualNetworkSubnetResourceId: networkIsolation ? virtualNetworkSubnetResourceId : ''
    privateDnsZonesResourceIds: networkIsolation
      ? [
          cognitiveServicesPrivateDnsZone.outputs.resourceId
        ]
      : []
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output aiServicesResourceId string = aiServices.outputs.cognitiveResourceId
output aiServicesName string = aiServices.outputs.cognitiveName
output aiServicesEndpoint string = aiServices.outputs.cogntiveEndpoint
output aiServicesSystemAssignedMIPrincipalId string = aiServices.outputs.?systemAssignedMIPrincipalId ?? ''

output connections array = union(
  [aiServices.outputs.foundryConnection],
  contentSafetyEnabled ? [contentSafety.outputs.foundryConnection] : []
)
