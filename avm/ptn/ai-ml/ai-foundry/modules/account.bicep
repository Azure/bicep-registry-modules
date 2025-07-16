@description('Required. Name of the Cognitive Services resource. Must be unique in the resource group. Maximum 64 characters.')
@maxLength(64)
param name string

@description('Required. The location of the Cognitive Services resource. Defaults to the location of the resource group.')
param location string = resourceGroup().location

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

@description('Optional. Configuration for private networking of AI Services. If not provided, public access will be enabled.')
param privateNetworking aiServicesPrivateNetworkingType?

@description('Required. Include the capability host for the Cognitive Services account.')
param includeCapabilityHost bool

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var networkIsolation = !empty(privateNetworking) && !empty(privateNetworking!.privateEndpointSubnetId) && !empty(privateNetworking!.cogServicesPrivateDnsZoneId) && !empty(privateNetworking!.openAIPrivateDnsZoneId) && !empty(privateNetworking!.aiServicesPrivateDnsZoneId)

module cognitiveService 'br/public:avm/res/cognitive-services/account:0.11.0' = {
  name: take('cog-account-${name}-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    sku: sku
    kind: 'AIServices'
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
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateNetworking!.cogServicesPrivateDnsZoneId!
                }
                {
                  privateDnsZoneResourceId: privateNetworking!.openAIPrivateDnsZoneId!
                }
                {
                  privateDnsZoneResourceId: privateNetworking!.aiServicesPrivateDnsZoneId!
                }
              ]
            }
            subnetResourceId: privateNetworking!.privateEndpointSubnetId
          }
        ]
      : []
    enableTelemetry: enableTelemetry
  }
}

resource cognitiveServiceReference 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  dependsOn: [cognitiveService]
  name: name
}

resource capabilityHost 'Microsoft.CognitiveServices/accounts/capabilityHosts@2025-06-01' = if (includeCapabilityHost) {
  name: '${cognitiveService.name}-cap-host'
  parent: cognitiveServiceReference
  properties: {
    capabilityHostKind: 'Agents'
    tags: tags
  }
}

// @batchSize(1)
// module projectResources 'project.bicep' = [
//   for project in projects ?? []: {
//     name: take('${name}-project-${project.name}', 64)
//     dependsOn: [capabilityHost]
//     params: {
//       name: project.name
//       accountName: cognitiveService.outputs.name
//       displayName: project.displayName
//       desc: project.desc
//       location: location
//       lock: lock
//       tags: tags
//       cosmosDbConnections: project.cosmosDbConnections
//       aiSearchConnections: project.aiSearchConnections
//       storageAccountConnections: project.storageAccountConnections
//       aiServicesConnections: project.aiServicesConnections
//     }
//   }
// ]

@description('Resource ID of the Cognitive Services account.')
output resourceId string = cognitiveService.outputs.resourceId

@description('Name of the Cognitive Services account.')
output name string = cognitiveService.outputs.name

@description('The System Assigned Managed Identity Principal ID of the Cognitive Services account.')
output systemAssignedMIPrincipalId string = cognitiveService.outputs.systemAssignedMIPrincipalId!

@description('The endpoint of the Cognitive Services account.')
output endpoint string = cognitiveService.outputs.endpoint

@description('The location of the Cognitive Services account.')
output location string = cognitiveService.outputs.location

// @description('Projects created in the Cognitive Services account.')
// output projects projectOutputType[] = [
//   for i in range(0, max(length(projects ?? []), 1) - 1): {
//     name: projectResources[i].outputs.name
//     resourceId: projectResources[i].outputs.resourceId
//     displayName: projectResources[i].outputs.displayName
//     desc: projectResources[i].outputs.desc
//     aiServicesConnections: projectResources[i].outputs.aiServicesConnections
//     cosmosDbConnections: projectResources[i].outputs.cosmosDbConnections
//     aiSearchConnections: projectResources[i].outputs.aiSearchConnections
//     storageAccountConnections: projectResources[i].outputs.storageAccountConnections
//   }
// ]

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

// import { azureConnectionType, storageAccountConnectionType, connectionOutputType } from 'project.bicep'

// @export()
// @description('Type representing an AI Foundry project details.')
// type projectType = {
//   @description('Required. The name of the AI Foundry project.')
//   name: string

//   @description('Optional. The display name of the AI Foundry project.')
//   displayName: string?

//   @description('Optional. The description of the AI Foundry project.')
//   desc: string?

//   @description('Optional. List of Azure AI Services connections for the project.')
//   aiServicesConnections: azureConnectionType[]?

//   @description('Optional. List of Azure Cosmos DB connections for the project.')
//   cosmosDbConnections: azureConnectionType[]?

//   @description('Optional. List of Azure Cognitive Search connections for the project.')
//   aiSearchConnections: azureConnectionType[]?

//   @description('Optional. List of Azure Storage Account connections for the project.')
//   storageAccountConnections: storageAccountConnectionType[]?
// }

// type projectOutputType = {
//   @description('Required. The name of the AI Foundry project.')
//   name: string

//   @description('Required. The resource ID of the AI Foundry project.')
//   resourceId: string

//   @description('Required. The display name of the AI Foundry project.')
//   displayName: string

//   @description('Required. The description of the AI Foundry project.')
//   desc: string

//   @description('Optional. List of Azure AI Services connections for the project.')
//   aiServicesConnections: connectionOutputType[]

//   @description('Optional. List of Azure Cosmos DB connections for the project.')
//   cosmosDbConnections: connectionOutputType[]

//   @description('Optional. List of Azure Cognitive Search connections for the project.')
//   aiSearchConnections: connectionOutputType[]

//   @description('Optional. List of Azure Storage Account connections for the project.')
//   storageAccountConnections: connectionOutputType[]
// }
