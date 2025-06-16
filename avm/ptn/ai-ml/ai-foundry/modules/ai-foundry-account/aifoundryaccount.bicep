@minLength(3)
@maxLength(12)
@description('Required. Name of the Cognitive Services resource. Must be unique in the resource group.')
param name string

@description('Required. Unique string to use when naming global resources.')
param resourceToken string

@description('Required. Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

@description('Required. Specifies whether network isolation is enabled. When true, Foundry and related components will be deployed, network access parameters will be set to Disabled.')
param networkIsolation bool

@description('Required. Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Required. Resource ID of the virtual network to link the private DNS zones. Conditional: Only required if networkIsolation is true.')
param virtualNetworkResourceId string

@description('Required. Resource ID of the subnet for the private endpoint. Conditional: Only required if networkIsolation is true.')
param virtualNetworkSubnetResourceId string

@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentsType[] = []

@description('Required. Whether to include Azure AI Content Safety in the deployment.')
param contentSafetyEnabled bool

@description('Required. A collection of rules governing the accessibility from specific network locations.')
param networkAcls object

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
  }
}

module aiServices 'service.bicep' = {
  name: take('${name}-ai-services-deployment', 64)
  params: {
    name: 'cog${name}${resourceToken}'
    location: location
    kind: 'AIServices'
    category: 'AIServices'
    networkIsolation: networkIsolation
    networkAcls: networkAcls
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
            principalType: 'User'
            roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
          }
          {
            principalId: userObjectId
            principalType: 'User'
            roleDefinitionIdOrName: 'Cognitive Services Contributor'
          }
          {
            principalId: userObjectId
            principalType: 'User'
            roleDefinitionIdOrName: 'Cognitive Services User'
          }
        ]
    tags: tags
  }
}

module contentSafety 'service.bicep' = if (contentSafetyEnabled) {
  name: take('${name}-content-safety-deployment', 64)
  params: {
    name: 'safety${name}${resourceToken}'
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
  }
}

import { deploymentsType } from '../customTypes.bicep'

output aiServicesResourceId string = aiServices.outputs.cognitiveResourceId
output aiServicesName string = aiServices.outputs.cognitiveName
output aiServicesEndpoint string = aiServices.outputs.cogntiveEndpoint
output aiServicesSystemAssignedMIPrincipalId string = aiServices.outputs.?systemAssignedMIPrincipalId ?? ''

output connections array = union(
  [aiServices.outputs.foundryConnection],
  contentSafetyEnabled ? [contentSafety.outputs.foundryConnection] : []
)
