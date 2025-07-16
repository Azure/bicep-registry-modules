metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services.'

@minLength(3)
@maxLength(12)
@description('Required. A friendly application/environment name for all resources in this deployment.')
param name string

@maxLength(5)
@description('Optional. A unique text value for the application/environment. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and name.')
param uniqueNameText string = substring(uniqueString(subscription().id, resourceGroup().name, name), 0, 5)

@description('Optional. Name of the AI Foundry project..')
param projectName string?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.11.0'
@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentType[] = []

@description('Optional. Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.')
param tags object = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Whether to include Azure AI Content Safety in the deployment.')
param contentSafetyEnabled bool = false

@description('Optional. Whether to include associated resources: Key Vault, AI Search, Storage Account, and Cosmos DB. If true, these resources will be created. Optionally, existing resources of these types can be supplied in their respective parameters. Defaults to false.')
param includeAssociatedResources bool = false

@description('Optional. Values to establish private networking for the AI Foundry account and project. If not specified, public endpoints will be used.')
param networking networkConfigurationType?

@description('Optional. Custom configuration for the Key Vault.')
param keyVaultConfiguration resourceConfigurationType?

@description('Optional. Custom configuration for the AI Search resource.')
param aiSearchConfiguration resourceConfigurationType?

@description('Optional. Custom configuration for the Storage Account.')
param storageAccountConfiguration resourceConfigurationType?

@description('Optional. Custom configuration for the Cosmos DB Account.')
param cosmosDbConfiguration resourceConfigurationType?

var enablePrivateNetworking = !empty(networking) && !empty(networking!.privateEndpointSubnetId)

var resourcesName = toLower(trim(replace(
  replace(replace(replace(replace(replace('${name}${uniqueNameText}', '-', ''), '_', ''), '.', ''), '/', ''), ' ', ''),
  '*',
  ''
)))

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.aiml-aifoundry.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module keyvault 'modules/keyvault.bicep' = if (includeAssociatedResources) {
  name: take('${resourcesName}-keyvault-deployment', 64)
  params: {
    name: take(
      !empty(keyVaultConfiguration) && !empty(keyVaultConfiguration.?name)
        ? keyVaultConfiguration!.name!
        : 'kv${resourcesName}',
      24
    )
    existingResourceId: keyVaultConfiguration.?existingResourceId
    location: location
    privateNetworking: enablePrivateNetworking && !empty(networking.?associatedResourcesPrivateDnsZones.?keyVaultPrivateDnsZoneId)
      ? {
          privateEndpointSubnetId: networking!.privateEndpointSubnetId
          privateDnsZoneId: networking!.associatedResourcesPrivateDnsZones!.keyVaultPrivateDnsZoneId
        }
      : {}
    roleAssignments: keyVaultConfiguration.?roleAssignments
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module cognitiveServices 'modules/ai-foundry-account/aifoundryaccount.bicep' = {
  name: take('${resourcesName}-cognitive-services-deployment', 64)
  params: {
    resourcesName: resourcesName
    location: location
    lock: lock
    privateNetworking: enablePrivateNetworking
      ? {
          privateEndpointSubnetId: networking!.privateEndpointSubnetId
          cogServicesPrivateDnsZoneId: networking!.cognitiveServicesPrivateDnsZoneId
          openAIPrivateDnsZoneId: networking!.openAiPrivateDnsZoneId
          aiServicesPrivateDnsZoneId: networking!.aiServicesPrivateDnsZoneId
        }
      : {}
    aiModelDeployments: aiModelDeployments
    contentSafetyEnabled: contentSafetyEnabled
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module aiSearch 'modules/aisearch.bicep' = if (includeAssociatedResources) {
  name: take('${resourcesName}-ai-search-deployment', 64)
  params: {
    #disable-next-line BCP334
    name: take(
      !empty(aiSearchConfiguration) && !empty(aiSearchConfiguration.?name)
        ? aiSearchConfiguration!.name!
        : 'srch${resourcesName}',
      60
    )
    location: location
    privateNetworking: enablePrivateNetworking && !empty(networking.?associatedResourcesPrivateDnsZones.?aiSearchPrivateDnsZoneId)
      ? {
          privateEndpointSubnetId: networking!.privateEndpointSubnetId
          privateDnsZoneId: networking!.associatedResourcesPrivateDnsZones!.aiSearchPrivateDnsZoneId
        }
      : {}
    roleAssignments: aiSearchConfiguration.?roleAssignments
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module storageAccount 'modules/storageAccount.bicep' = if (includeAssociatedResources) {
  name: take('${resourcesName}-storage-account-deployment', 64)
  params: {
    name: take(
      !empty(storageAccountConfiguration) && !empty(storageAccountConfiguration.?name)
        ? storageAccountConfiguration!.name!
        : 'st${resourcesName}',
      24
    )
    existingResourceId: storageAccountConfiguration.?existingResourceId
    location: location
    privateNetworking: enablePrivateNetworking && !empty(networking.?associatedResourcesPrivateDnsZones.?storageBlobPrivateDnsZoneId) && !empty(networking.?associatedResourcesPrivateDnsZones.?storageFilePrivateDnsZoneId)
      ? {
          privateEndpointSubnetId: networking!.privateEndpointSubnetId
          blobPrivateDnsZoneId: networking!.associatedResourcesPrivateDnsZones!.storageBlobPrivateDnsZoneId
          filePrivateDnsZoneId: networking!.associatedResourcesPrivateDnsZones!.storageFilePrivateDnsZoneId
        }
      : {}
    enableTelemetry: enableTelemetry
    roleAssignments: concat(
      !empty(storageAccountConfiguration) && !empty(storageAccountConfiguration.?roleAssignments)
        ? storageAccountConfiguration!.roleAssignments!
        : [],
      [
        {
          principalId: cognitiveServices.outputs.aiServicesSystemAssignedMIPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        }
      ],
      [
        {
          principalId: cognitiveServices.outputs.aiServicesSystemAssignedMIPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        }
      ],
      [
        {
          principalId: aiSearch!.outputs.systemAssignedMIPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        }
      ]
    )
    tags: tags
  }
}

module cosmosDb 'modules/cosmosDb.bicep' = if (includeAssociatedResources) {
  name: take('${resourcesName}-cosmosdb-deployment', 64)
  params: {
    name: take(
      !empty(cosmosDbConfiguration) && !empty(cosmosDbConfiguration.?name)
        ? cosmosDbConfiguration!.name!
        : 'cos${resourcesName}',
      44
    )
    existingResourceId: cosmosDbConfiguration.?existingResourceId
    location: location
    privateNetworking: enablePrivateNetworking && !empty(networking.?associatedResourcesPrivateDnsZones.?cosmosDbPrivateDnsZoneId)
      ? {
          privateEndpointSubnetId: networking!.privateEndpointSubnetId
          privateDnsZoneId: networking!.associatedResourcesPrivateDnsZones!.cosmosDbPrivateDnsZoneId
        }
      : {}
    enableTelemetry: enableTelemetry
    roleAssignments: cosmosDbConfiguration.?roleAssignments
    tags: tags
  }
}

module project 'modules/aifoundryproject.bicep' = {
  name: take('${name}-foundry-project-deployment', 64)
  dependsOn: includeAssociatedResources
    ? [
        storageAccount
        aiSearch
        cosmosDb
        keyvault
      ]
    : []
  params: {
    name: empty(projectName) ? 'proj-${resourcesName}' : projectName!
    location: location
    lock: lock
    includeAssociatedResources: includeAssociatedResources
    cosmosDBName: includeAssociatedResources ? cosmosDb!.outputs.name : ''
    storageName: includeAssociatedResources ? storageAccount!.outputs.name : ''
    aiServicesName: cognitiveServices.outputs.aiServicesName
    aiSearchName: includeAssociatedResources ? aiSearch!.outputs.name : ''
    projUploadsContainerName: includeAssociatedResources ? storageAccount!.outputs.projUploadsContainerName : ''
    sysDataContainerName: includeAssociatedResources ? storageAccount!.outputs.sysDataContainerName : ''
  }
}

@description('Name of the deployed Azure Resource Group.')
output resourceGroupName string = resourceGroup().name

@description('Name of the deployed Azure Key Vault.')
output keyVaultName string = includeAssociatedResources ? keyvault!.outputs.name : ''

@description('Name of the deployed Azure AI Services account.')
output aiServicesName string = cognitiveServices.outputs.aiServicesName

@description('Name of the deployed Azure AI Search service.')
output aiSearchName string = includeAssociatedResources ? aiSearch!.outputs.name : ''

@description('Name of the deployed Azure AI Project.')
output aiProjectName string = project.outputs.name

@description('Name of the deployed Azure Storage Account.')
output storageAccountName string = includeAssociatedResources ? storageAccount!.outputs.name : ''

@description('Name of the deployed Azure Cosmos DB account.')
output cosmosAccountName string = includeAssociatedResources ? cosmosDb!.outputs.name : ''

@export()
@description('Values to establish private networking for resources that support creating private endpoints.')
type networkConfigurationType = {
  @description('Required. The Resource ID of the subnet to establish the Private Endpoint(s).')
  privateEndpointSubnetId: string

  @description('Required.  The Resource ID of the subnet for the Azure AI Services account.')
  agentServiceSubnetId: string

  @description('Required. The Resource ID of the Private DNS Zone for the Azure AI Services account.')
  cognitiveServicesPrivateDnsZoneId: string

  @description('Required. The Resource ID of the Private DNS Zone for the OpenAI account.')
  openAiPrivateDnsZoneId: string

  @description('Required. The Resource ID of the Private DNS Zone for the Azure AI Services account.')
  aiServicesPrivateDnsZoneId: string

  @description('Optional. Configuration for DNS zones for associated resources. This is only required if includeAssociatedResources is true.')
  associatedResourcesPrivateDnsZones: networkResourcesDnsZonesConfigurationType?
}

@description('Values for the associated resources DNS Zone resource IDs.')
type networkResourcesDnsZonesConfigurationType = {
  @description('Required. The Resource ID of the DNS zone for the Azure AI Search service.')
  aiSearchPrivateDnsZoneId: string

  @description('Required. The Resource ID of the DNS zone for the Azure Cosmos DB account.')
  cosmosDbPrivateDnsZoneId: string

  @description('Required. The Resource ID of the DNS zone for the Azure Key Vault.')
  keyVaultPrivateDnsZoneId: string

  @description('Required. The Resource ID of the DNS zone "blob" for the Azure Storage Account.')
  storageBlobPrivateDnsZoneId: string

  @description('Required. The Resource ID of the DNS zone "file" for the Azure Storage Account.')
  storageFilePrivateDnsZoneId: string
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'

@description('Custom configuration for a resource, including optional name, existing resource ID, and role assignments.')
type resourceConfigurationType = {
  @description('Optional. Resource ID of an existing resource to use instead of creating a new one. If provided, other parameters are ignored.')
  existingResourceId: string?

  @description('Optional. Name to be used when creating the resource. This is ignored if an existingResourceId is provided.')
  name: string?

  @description('Optional. Role assignments to apply to the resource when creating it. This is ignored if an existingResourceId is provided.')
  roleAssignments: roleAssignmentType[]?
}
