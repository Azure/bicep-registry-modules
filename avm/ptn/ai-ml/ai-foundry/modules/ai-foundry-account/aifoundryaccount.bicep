@description('Required. Name used for Cognitivive Services resources.')
param resourcesName string

@description('Required. Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.11.0'
@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentType[] = []

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Required. Whether to include Azure AI Content Safety in the deployment.')
param contentSafetyEnabled bool

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Configuration for private networking of AI Services. If not provided, public access will be enabled.')
param privateNetworking aiServicesPrivateNetworkingType?

var networkIsolation = !empty(privateNetworking) && !empty(privateNetworking!.privateEndpointSubnetId) && !empty(privateNetworking!.cogServicesPrivateDnsZoneId) && !empty(privateNetworking!.openAIPrivateDnsZoneId) && !empty(privateNetworking!.aiServicesPrivateDnsZoneId)

module aiServices 'service.bicep' = {
  name: take('${resourcesName}-ai-services', 64)
  params: {
    name: take('ai${resourcesName}', 12)
    location: location
    lock: lock
    kind: 'AIServices'
    category: 'AIServices'
    privateEndpointSubnetId: networkIsolation ? privateNetworking!.privateEndpointSubnetId : ''
    privateDnsZonesIds: networkIsolation
      ? [
          privateNetworking!.cogServicesPrivateDnsZoneId
          privateNetworking!.openAIPrivateDnsZoneId
          privateNetworking!.aiServicesPrivateDnsZoneId
        ]
      : []
    aiModelDeployments: aiModelDeployments
    roleAssignments: roleAssignments
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module contentSafety 'service.bicep' = if (contentSafetyEnabled) {
  name: take('${resourcesName}-content-safety', 64)
  params: {
    name: take('sf${resourcesName}', 12)
    location: location
    lock: lock
    kind: 'ContentSafety'
    privateEndpointSubnetId: networkIsolation ? privateNetworking!.privateEndpointSubnetId : ''
    privateDnsZonesIds: networkIsolation
      ? [
          privateNetworking!.cogServicesPrivateDnsZoneId
          privateNetworking!.openAIPrivateDnsZoneId
          privateNetworking!.aiServicesPrivateDnsZoneId
        ]
      : []
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output aiServicesResourceId string = aiServices.outputs.resourceId
output aiServicesName string = aiServices.outputs.name
output aiServicesEndpoint string = aiServices.outputs.endpoint
output aiServicesSystemAssignedMIPrincipalId string = aiServices.outputs.systemAssignedMIPrincipalId!

output connections array = union(
  [aiServices.outputs.foundryConnection],
  contentSafetyEnabled ? [contentSafety!.outputs.foundryConnection] : []
)

@export()
@description('Values to establish private networking for resources that support creating private endpoints.')
type aiServicesPrivateNetworkingType = {
  @description('Required. The Resource ID of the subnet to establish the Private Endpoint(s).')
  privateEndpointSubnetId: string

  @description('Required. The Resource ID of an existing "cognitiveservices" Private DNS Zone Resource to link to the virtual network.')
  cogServicesPrivateDnsZoneId: string

  @description('Required. The Resource ID of an existing "openai" Private DNS Zone Resource to link to the virtual network.')
  openAIPrivateDnsZoneId: string

  @description('Required. The Resource ID of an existing "services.ai" Private DNS Zone Resource to link to the virtual network.')
  aiServicesPrivateDnsZoneId: string
}
