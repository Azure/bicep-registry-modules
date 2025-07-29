metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services.'

@minLength(3)
@maxLength(12)
@description('Required. A friendly application/environment name to serve as the "base" when using the default naming for all resources in this deployment.')
param baseName string

@maxLength(5)
@description('Optional. A unique text value for the application/environment. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and base name.')
param baseUniqueName string = substring(uniqueString(subscription().id, resourceGroup().name, baseName), 0, 5)

@description('Optional. Location for all Resources. Defaults to the location of the resource group.')
param location string = resourceGroup().location

@description('Optional. SKU of the AI Foundry / Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'C2'
  'C3'
  'C4'
  'F0'
  'F1'
  'S'
  'S0'
  'S1'
  'S10'
  'S2'
  'S3'
  'S4'
  'S5'
  'S6'
  'S7'
  'S8'
  'S9'
  'DC0'
])
param sku string = 'S0'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.12.0'
@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentType[] = []

@description('Optional. Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the AI resources.')
param lock lockType?

@description('Optional. Whether to include associated resources: Key Vault, AI Search, Storage Account, and Cosmos DB. If true, these resources will be created. Optionally, existing resources of these types can be supplied in their respective parameters. Defaults to false.')
param includeAssociatedResources bool = false

@description('Optional. The Resource ID of the subnet to establish Private Endpoint(s). If provided, private endpoints will be created for the AI Foundry account and associated resources when creating those resource. Each resource will also require supplied private DNS zone resource ID(s) to establish those private endpoints.')
param privateEndpointSubnetId string?

@description('Optional. Custom configuration for the AI Foundry.')
param aiFoundryConfiguration foundryConfigurationType?

@description('Optional. Custom configuration for the Key Vault.')
param keyVaultConfiguration resourceConfigurationType?

@description('Optional. Custom configuration for the AI Search resource.')
param aiSearchConfiguration resourceConfigurationType?

@description('Optional. Custom configuration for the Storage Account.')
param storageAccountConfiguration storageAccountConfigurationType?

@description('Optional. Custom configuration for the Cosmos DB Account.')
param cosmosDbConfiguration resourceConfigurationType?

var enablePrivateNetworking = !empty(privateEndpointSubnetId)

var resourcesName = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${baseName}${baseUniqueName}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))

// set proj name here to also be used for a default storage container name
var projectName = !empty(aiFoundryConfiguration.?project.?name)
  ? aiFoundryConfiguration!.project!.name!
  : 'proj-${resourcesName}'

// set a default storage container name so that connection to project can be established in default state
var storageAccountContainerName = empty(storageAccountConfiguration.?containerName)
  ? projectName
  : storageAccountConfiguration!.containerName!

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

var foundryAccountName = !empty(aiFoundryConfiguration.?accountName)
  ? aiFoundryConfiguration!.accountName!
  : 'ai${resourcesName}'
var foundryAccountPrivateNetworking = enablePrivateNetworking && !empty(aiFoundryConfiguration.?networking.?cognitiveServicesPrivateDnsZoneId) && !empty(aiFoundryConfiguration.?networking.?openAiPrivateDnsZoneId) && !empty(aiFoundryConfiguration.?networking.?aiServicesPrivateDnsZoneId)
module foundryAccount 'br/public:avm/res/cognitive-services/account:0.12.0' = {
  name: take('avm.res.cognitive-services.account.${foundryAccountName}', 64)
  params: {
    name: foundryAccountName
    location: !empty(aiFoundryConfiguration.?location) ? aiFoundryConfiguration!.location! : location
    tags: tags
    sku: sku
    kind: 'AIServices'
    lock: lock
    allowProjectManagement: aiFoundryConfiguration.?allowProjectManagement ?? true
    managedIdentities: {
      systemAssigned: true
    }
    deployments: aiModelDeployments
    customSubDomainName: foundryAccountName
    disableLocalAuth: foundryAccountPrivateNetworking
    publicNetworkAccess: foundryAccountPrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: foundryAccountPrivateNetworking ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }
    privateEndpoints: foundryAccountPrivateNetworking
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: aiFoundryConfiguration!.networking!.cognitiveServicesPrivateDnsZoneId!
                }
                {
                  privateDnsZoneResourceId: aiFoundryConfiguration!.networking!.openAiPrivateDnsZoneId!
                }
                {
                  privateDnsZoneResourceId: aiFoundryConfiguration!.networking!.aiServicesPrivateDnsZoneId!
                }
              ]
            }
            subnetResourceId: privateEndpointSubnetId!
          }
        ]
      : []
    enableTelemetry: enableTelemetry
  }
}

var keyVaultName = take(
  !empty(keyVaultConfiguration) && !empty(keyVaultConfiguration.?name)
    ? keyVaultConfiguration!.name!
    : 'kv${resourcesName}',
  24
)
var keyVaultPrivateNetworking = enablePrivateNetworking && !empty(keyVaultConfiguration.?privateDnsZoneId)
module keyVault 'br/public:avm/res/key-vault/vault:0.13.0' = if (includeAssociatedResources && empty(keyVaultConfiguration.?existingResource)) {
  name: take('avm.res.key-vault.vault.${keyVaultName}', 64)
  params: {
    name: keyVaultName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: keyVaultPrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: keyVaultPrivateNetworking ? 'Deny' : 'Allow'
    }
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enablePurgeProtection: false
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    privateEndpoints: keyVaultPrivateNetworking
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: keyVaultConfiguration!.privateDnsZoneId!
                }
              ]
            }
            service: 'vault'
            subnetResourceId: privateEndpointSubnetId!
          }
        ]
      : []
    roleAssignments: keyVaultConfiguration.?roleAssignments
  }
}

var aiSearchName = take(!empty(aiSearchConfiguration.?name) ? aiSearchConfiguration!.name! : 'srch${resourcesName}', 60)
var aiSearchPrivateNetworking = enablePrivateNetworking && !empty(aiSearchConfiguration.?privateDnsZoneId)
module aiSearch 'br/public:avm/res/search/search-service:0.11.0' = if (includeAssociatedResources && empty(aiSearchConfiguration.?existingResource)) {
  name: take('avm.res.search.search-service.${aiSearchName}', 64)
  params: {
    name: aiSearchName
    location: location
    enableTelemetry: enableTelemetry
    cmkEnforcement: 'Unspecified'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: aiSearchPrivateNetworking ? 'Disabled' : 'Enabled'
    disableLocalAuth: aiSearchPrivateNetworking
    authOptions: aiSearchPrivateNetworking
      ? null
      : {
          aadOrApiKey: {
            aadAuthFailureMode: 'http401WithBearerChallenge'
          }
        }
    sku: 'standard'
    partitionCount: 1
    replicaCount: 3
    roleAssignments: aiSearchConfiguration.?roleAssignments
    privateEndpoints: aiSearchPrivateNetworking
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: aiSearchConfiguration!.privateDnsZoneId!
                }
              ]
            }
            subnetResourceId: privateEndpointSubnetId!
          }
        ]
      : []
    tags: tags
  }
}

var storageAccountName = take(
  !empty(storageAccountConfiguration.?name) ? storageAccountConfiguration!.name! : 'st${resourcesName}',
  24
)
var storageAccountPrivateNetworking = enablePrivateNetworking && !empty(storageAccountConfiguration.?blobPrivateDnsZoneId)
module storageAccount 'br/public:avm/res/storage/storage-account:0.25.1' = if (includeAssociatedResources && empty(storageAccountConfiguration.?existingResource)) {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [aiSearch]
  params: {
    name: storageAccountName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: storageAccountPrivateNetworking ? 'Disabled' : 'Enabled'
    accessTier: 'Hot'
    allowBlobPublicAccess: !storageAccountPrivateNetworking
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    blobServices: {
      deleteRetentionPolicyEnabled: true
      deleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
      containers: [{ name: storageAccountContainerName }]
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: storageAccountPrivateNetworking ? 'Deny' : 'Allow'
      bypass: 'AzureServices'
    }
    supportsHttpsTrafficOnly: true
    privateEndpoints: storageAccountPrivateNetworking
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: storageAccountConfiguration!.blobPrivateDnsZoneId!
                }
              ]
            }
            service: 'blob'
            subnetResourceId: privateEndpointSubnetId!
          }
        ]
      : []
    roleAssignments: concat(
      !empty(storageAccountConfiguration) && !empty(storageAccountConfiguration.?roleAssignments)
        ? storageAccountConfiguration!.roleAssignments!
        : [],
      [
        {
          principalId: foundryAccount.outputs.systemAssignedMIPrincipalId!
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        }
      ],
      empty(aiSearchConfiguration.?existingResource)
        ? [
            {
              principalId: aiSearch!.outputs.systemAssignedMIPrincipalId!
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Storage Blob Data Contributor'
            }
          ]
        : []
    )
  }
}

var cosmosDbName = take(!empty(cosmosDbConfiguration.?name) ? cosmosDbConfiguration!.name! : 'cos${resourcesName}', 44)
var cosmosDbPrivateNetworking = enablePrivateNetworking && !empty(cosmosDbConfiguration.?privateDnsZoneId)
module cosmosDb 'br/public:avm/res/document-db/database-account:0.15.0' = if (includeAssociatedResources && empty(cosmosDbConfiguration.?existingResource)) {
  name: take('avm.res.document-db.database-account.${cosmosDbName}', 64)
  params: {
    name: cosmosDbName
    enableTelemetry: enableTelemetry
    automaticFailover: true
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuthentication: true
    location: location
    minimumTlsVersion: 'Tls12'
    defaultConsistencyLevel: 'Session'
    networkRestrictions: {
      networkAclBypass: 'AzureServices'
      publicNetworkAccess: cosmosDbPrivateNetworking ? 'Disabled' : 'Enabled'
    }
    privateEndpoints: cosmosDbPrivateNetworking
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: cosmosDbConfiguration!.privateDnsZoneId!
                }
              ]
            }
            service: 'Sql'
            subnetResourceId: privateEndpointSubnetId!
          }
        ]
      : []
    roleAssignments: cosmosDbConfiguration.?roleAssignments
    tags: tags
  }
}

module foundryProject 'modules/project/main.bicep' = {
  name: take('module.project.main.${projectName}', 64)
  dependsOn: [storageAccount, aiSearch, cosmosDb, keyVault]
  params: {
    name: projectName
    desc: !empty(aiFoundryConfiguration.?project.?desc)
      ? aiFoundryConfiguration!.project!.desc!
      : 'This is the default project for AI Foundry.'
    displayName: !empty(aiFoundryConfiguration.?project.?displayName)
      ? aiFoundryConfiguration!.project!.displayName!
      : '${baseName} Default Project'
    accountName: foundryAccount.outputs.name
    location: foundryAccount.outputs.location
    includeCapabilityHost: aiFoundryConfiguration.?createAIAgentService ?? false
    storageAccountConnection: includeAssociatedResources
      ? {
          storageAccountName: empty(storageAccountConfiguration.?existingResource.?name)
            ? storageAccountName
            : storageAccountConfiguration!.existingResource!.name!
          subscriptionId: empty(storageAccountConfiguration.?existingResource.?subscriptionId)
            ? subscription().subscriptionId
            : storageAccountConfiguration!.existingResource!.subscriptionId!
          resourceGroupName: empty(storageAccountConfiguration.?existingResource.?resourceGroupName)
            ? resourceGroup().name
            : storageAccountConfiguration!.existingResource!.resourceGroupName!
          containerName: storageAccountContainerName
        }
      : null
    aiSearchConnection: includeAssociatedResources
      ? {
          resourceName: empty(aiSearchConfiguration.?existingResource.?name)
            ? aiSearchName
            : aiSearchConfiguration!.existingResource!.name!
          subscriptionId: empty(aiSearchConfiguration.?existingResource.?subscriptionId)
            ? subscription().subscriptionId
            : aiSearchConfiguration!.existingResource!.subscriptionId!
          resourceGroupName: empty(aiSearchConfiguration.?existingResource.?resourceGroupName)
            ? resourceGroup().name
            : aiSearchConfiguration!.existingResource!.resourceGroupName!
        }
      : null
    cosmosDbConnection: includeAssociatedResources
      ? {
          resourceName: empty(cosmosDbConfiguration.?existingResource.?name)
            ? cosmosDbName
            : cosmosDbConfiguration!.existingResource!.name!
          subscriptionId: empty(cosmosDbConfiguration.?existingResource.?subscriptionId)
            ? subscription().subscriptionId
            : cosmosDbConfiguration!.existingResource!.subscriptionId!
          resourceGroupName: empty(cosmosDbConfiguration.?existingResource.?resourceGroupName)
            ? resourceGroup().name
            : cosmosDbConfiguration!.existingResource!.resourceGroupName!
        }
      : null
    tags: tags
    lock: lock
  }
}

@description('Name of the deployed Azure Resource Group.')
output resourceGroupName string = resourceGroup().name

@description('Name of the deployed Azure Key Vault.')
output keyVaultName string = includeAssociatedResources ? 'keyVault!.outputs.name' : '' // TODO

@description('Name of the deployed Azure AI Services account.')
output aiServicesName string = foundryAccount.outputs.name

@description('Name of the deployed Azure AI Search service.')
output aiSearchName string = includeAssociatedResources ? 'aiSearch!.outputs.name' : '' // TODO

@description('Name of the deployed Azure AI Project.')
output aiProjectName string = foundryProject.outputs.name

@description('Name of the deployed Azure Storage Account.')
output storageAccountName string = includeAssociatedResources ? 'storageAccount!.outputs.name' : '' // TODO

@description('Name of the deployed Azure Cosmos DB account.')
output cosmosAccountName string = includeAssociatedResources ? 'cosmosDb!.outputs.name' : '' // TODO

@description('Custom type to represent ID for a given resource in Azure. It includes subscription ID, resource group name, and resource name.')
type resourceIdType = {
  @description('Required. The name of the resource.')
  @maxLength(64)
  @minLength(3)
  name: string

  @description('Required. The name of the resource group.')
  resourceGroupName: string

  @description('Required. The subscription ID.')
  subscriptionId: string
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'

@description('Custom configuration for a resource, including optional name, existing resource ID, and role assignments.')
type resourceConfigurationType = {
  @description('Optional. Resource identifier of an existing resource to use instead of creating a new one. If provided, other parameters are ignored.')
  existingResource: resourceIdType?

  @description('Optional. Name to be used when creating the resource. This is ignored if an existingResourceId is provided.')
  name: string?

  @description('Optional. The Resource ID of the Private DNS Zone that associates with the resource. This is required to establish a Private Endpoint and when \'privateEndpointSubnetId\' is provided.')
  privateDnsZoneId: string?

  @description('Optional. Role assignments to apply to the resource when creating it. This is ignored if an existingResourceId is provided.')
  roleAssignments: roleAssignmentType[]?
}

@description('Custom configuration for a Storage Account, including optional name, existing resource ID, containers, and role assignments.')
type storageAccountConfigurationType = {
  @description('Optional. Resource identifier of an existing Storage Account to use instead of creating a new one. If provided, other parameters are ignored.')
  existingResource: resourceIdType?

  @description('Optional. Name to be used when creating the Storage Account. This is ignored if an existingResourceId is provided.')
  name: string?

  @description('Optional. The name of the container to create in the Storage Account. If using existingResourceId, this should be an existing container in that account, by default a container named the same as the AI Foundry Project. If not provided and not using an existing Storage Account, a default container named the same as the AI Foundry Project name will be created.')
  containerName: string?

  @description('Optional. The Resource ID of the DNS zone "blob" for the Azure Storage Account. This is required to establish a Private Endpoint and when \'privateEndpointSubnetId\' is provided.')
  blobPrivateDnsZoneId: string?

  @description('Optional. Role assignments to apply to the resource when creating it. This is ignored if an existingResourceId is provided.')
  roleAssignments: roleAssignmentType[]?
}

@description('Custom configuration for a AI Foundry, including optional account name and project configuration.')
type foundryConfigurationType = {
  @description('Optional. The name of the AI Foundry account.')
  accountName: string?

  @description('Optional. The location of the AI Foundry account. Will default to the resource group location if not specified.')
  location: string?

  @description('Optional. Whether to create the AI Agent Service. If true, the AI Foundry account will be created with the capability to host AI Agents. If true, \'networking.agentServiceSubnetId\' is required. Defaults to false.')
  createAIAgentService: bool?

  @description('Optional. Whether to allow project management in the AI Foundry account. If true, users can create and manage projects within the AI Foundry account. Defaults to true.')
  allowProjectManagement: bool?

  @description('Optional. Values to establish private networking for the AI Foundry account and project.')
  networking: foundryNetworkConfigurationType?

  @description('Optional. AI Foundry default project.')
  project: foundryProjectConfigurationType?
}

@description('Values to establish private networking for the AI Foundry service.')
type foundryNetworkConfigurationType = {
  @description('Optional. The Resource ID of the subnet for the Azure AI Services account. This is required if \'createAIAgentService\' is true.')
  agentServiceSubnetId: string?

  @description('Required. The Resource ID of the Private DNS Zone for the Azure AI Services account.')
  cognitiveServicesPrivateDnsZoneId: string

  @description('Required. The Resource ID of the Private DNS Zone for the OpenAI account.')
  openAiPrivateDnsZoneId: string

  @description('Required. The Resource ID of the Private DNS Zone for the Azure AI Services account.')
  aiServicesPrivateDnsZoneId: string
}

@description('Custom configuration for an AI Foundry project, including optional name, friendly name, and description.')
type foundryProjectConfigurationType = {
  @description('Optional. The name of the AI Foundry project.')
  name: string?

  @description('Optional. The friendly/display name of the AI Foundry project.')
  displayName: string?

  @description('Optional. The description of the AI Foundry project.')
  desc: string?
}
