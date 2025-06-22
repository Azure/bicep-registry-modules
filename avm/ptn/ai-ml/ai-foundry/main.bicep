metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services.'

targetScope = 'resourceGroup'

import { sqlDatabaseType, deploymentsType } from 'modules/customTypes.bicep'

@minLength(3)
@maxLength(12)
@description('Required. Name of the resource to create.')
param name string

@description('Optional. Name of the AI Foundry project.')
param projectName string = '${name}proj'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentsType[] = []

@description('Optional. List of Cosmos DB databases to create.')
param cosmosDatabases sqlDatabaseType[] = []

@description('Optional. Specifies the size of the jump-box Virtual Machine.')
param vmSize string = 'Standard_DS4_v2'

@minLength(3)
@maxLength(20)
@description('Optional. Specifies the name of the administrator account for the jump-box virtual machine. Defaults to "[name]vmuser". This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion.')
param vmAdminUsername string = take('${name}vmuser', 20)

@minLength(4)
@maxLength(70)
@description('Required. Specifies the password for the jump-box virtual machine. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. Value should be meet 3 of the following: uppercase character, lowercase character, numberic digit, special character, and NO control characters.')
@secure()
param vmAdminPasswordOrKey string

@description('Optional. Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.')
param tags object = {}

@description('Optional. Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string = deployer().objectId

@description('Optional. IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed.')
param allowedIpAddress string = ''

@description('Required. Specifies whether network isolation is enabled. When true, Foundry and related components will be deployed, network access parameters will be set to Disabled. This is automatically set based on aiFoundryType.')
var networkIsolation = toLower(aiFoundryType) == 'StandardPrivate'

@allowed([
  'Basic'
  'StandardPublic'
  'StandardPrivate'
])
@description('Required. Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.')
param aiFoundryType string

@description('Required. Whether to include Azure AI Content Safety in the deployment.')
param contentSafetyEnabled bool

@description('Optional. A collection of rules governing the accessibility from specific network locations.')
param networkAcls object = {
  defaultAction: 'Deny'
  bypass: 'AzureServices' // ✅ Allows trusted Microsoft services
  // virtualNetworkRules: [
  //   {
  //     id: networkIsolation ? network.outputs.vmSubnetName : ''
  //     ignoreMissingVnetServiceEndpoint: true
  //   }
  // ]
}

var defaultTags = {
  'azd-env-name': name
}
var allTags = union(defaultTags, tags)

var resourceToken = substring(uniqueString(subscription().id, location, name), 0, 5)
var servicesUsername = take(replace(vmAdminUsername, '.', ''), 20)

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

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = if (toLower(aiFoundryType) != 'basic') {
  name: take('${name}-log-analytics-deployment', 64)
  params: {
    name: toLower('log-${name}')
    location: location
    tags: allTags
    skuName: 'PerGB2018' // Updated to current supported SKU
    dataRetention: 90 // Standard retention for compliance
    enableTelemetry: enableTelemetry
  }
}

// module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (toLower(aiFoundryType) != 'basic') {
//   name: take('${name}-app-insights-deployment', 64)
//   params: {
//     name: toLower('appi-${name}')
//     location: location
//     tags: allTags
//     workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
//   }
// }

module network 'modules/virtualNetwork.bicep' = if (toLower(aiFoundryType) == 'standardprivate') {
  name: take('${name}-network-deployment', 64)
  params: {
    virtualNetworkName: toLower('vnet-${name}')
    virtualNetworkAddressPrefixes: '10.0.0.0/8'
    vmSubnetName: toLower('snet-${name}-vm')
    vmSubnetAddressPrefix: '10.3.1.0/24'
    vmSubnetNsgName: toLower('nsg-snet-${name}-vm')
    bastionHostEnabled: true
    bastionSubnetAddressPrefix: '10.3.2.0/24'
    bastionSubnetNsgName: 'nsg-AzureBastionSubnet'
    bastionHostName: toLower('bas-${name}')
    bastionHostDisableCopyPaste: false
    bastionHostEnableFileCopy: true
    bastionHostEnableIpConnect: true
    bastionHostEnableShareableLink: true
    bastionHostEnableTunneling: true
    bastionPublicIpAddressName: toLower('pip-bas-${name}')
    bastionHostSkuName: 'Standard'
    natGatewayName: toLower('nat-${name}')
    natGatewayPublicIps: 1
    natGatewayIdleTimeoutMins: 30
    allowedIpAddress: allowedIpAddress
    location: location
    tags: allTags
  }
}

module keyvault 'modules/keyvault.bicep' = if (toLower(aiFoundryType) != 'basic') {
  name: take('${name}-keyvault-deployment', 64)
  params: {
    name: 'kv${name}${resourceToken}'
    aiFoundryType: aiFoundryType
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    userObjectId: userObjectId
    logAnalyticsWorkspaceResourceId: toLower(aiFoundryType) != 'basic' ? logAnalyticsWorkspace.outputs.resourceId : ''
    enableTelemetry: enableTelemetry
    tags: allTags
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = if (toLower(aiFoundryType) != 'basic') {
  name: take('${name}-container-registry-deployment', 64)
  params: {
    name: 'cr${name}${resourceToken}'
    aiFoundryType: aiFoundryType
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    enableTelemetry: enableTelemetry
    tags: allTags
  }
}

module cognitiveServices 'modules/ai-foundry-account/aifoundryaccount.bicep' = {
  name: '${name}-cognitive-services-deployment'
  params: {
    aiFoundryType: aiFoundryType
    name: name
    resourceToken: resourceToken
    location: location
    networkIsolation: networkIsolation
    networkAcls: networkAcls
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    aiModelDeployments: aiModelDeployments
    userObjectId: userObjectId
    contentSafetyEnabled: contentSafetyEnabled
    tags: allTags
  }
}

module aiSearch 'modules/aisearch.bicep' = if (toLower(aiFoundryType) != 'basic') {
  name: take('${name}-ai-search-deployment', 64)
  params: {
    name: 'srch${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    userObjectId: userObjectId
    enableTelemetry: enableTelemetry
    roleAssignments: union(
      empty(userObjectId)
        ? []
        : [
            {
              principalId: userObjectId
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Search Index Data Contributor'
            }
          ],
      [
        {
          principalId: cognitiveServices.outputs.aiServicesSystemAssignedMIPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Search Index Data Contributor'
        }
        {
          principalId: cognitiveServices.outputs.aiServicesSystemAssignedMIPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Search Service Contributor'
        }
      ]
    )
    tags: allTags
  }
}

module storageAccount 'modules/storageAccount.bicep' = if (toLower(aiFoundryType) != 'basic') {
  name: take('${name}-storage-account-deployment', 64)
  params: {
    aiFoundryType: aiFoundryType
    storageName: 'st${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    enableTelemetry: enableTelemetry
    roleAssignments: concat(
      empty(userObjectId)
        ? []
        : [
            {
              principalId: userObjectId
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
          principalId: aiSearch.outputs.systemAssignedMIPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        }
      ]
    )
    tags: allTags
  }
}

module cosmosDb 'modules/cosmosDb.bicep' = if (toLower(aiFoundryType) != 'basic') {
  name: take('${name}-cosmosdb-deployment', 64)
  params: {
    name: 'cos${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    enableTelemetry: enableTelemetry
    databases: cosmosDatabases
    tags: allTags
  }
}

// Add the new FDP cognitive services module
module project 'modules/aifoundryproject.bicep' = {
  name: take('${name}-project-deployment', 64)
  params: {
    aiFoundryType: aiFoundryType
    cosmosDBName: toLower(aiFoundryType) != 'basic' ? cosmosDb.outputs.cosmosDBname : ''
    name: projectName
    location: location
    storageName: toLower(aiFoundryType) != 'basic' ? storageAccount.outputs.storageName : ''
    aiServicesName: cognitiveServices.outputs.aiServicesName
    nameFormatted: toLower(aiFoundryType) != 'basic' ? aiSearch.outputs.searchName : ''
    projUploadsContainerName: toLower(aiFoundryType) != 'basic' ? storageAccount.outputs.projUploadsContainerName : ''
    sysDataContainerName: toLower(aiFoundryType) != 'basic' ? storageAccount.outputs.sysDataContainerName : ''
  }
  dependsOn: toLower(aiFoundryType) != 'basic'
    ? [
        storageAccount
        aiSearch
        cosmosDb
      ]
    : []
}

// Only deploy the VM if we're doing a StandardPrivate deployment and need a jumpbox in the VNET
var shouldDeployVM = (toLower(aiFoundryType) == 'standardprivate')

module virtualMachine './modules/virtualMachine.bicep' = if (shouldDeployVM) {
  name: take('${name}-virtual-machine-deployment', 64)
  params: {
    vmName: toLower('vm-${name}-jump')
    vmNicName: toLower('nic-vm-${name}-jump')
    vmSize: vmSize
    vmSubnetId: network.outputs.vmSubnetId
    storageAccountName: storageAccount.outputs.storageName
    storageAccountResourceGroup: resourceGroup().name
    imagePublisher: 'MicrosoftWindowsDesktop'
    imageOffer: 'Windows-11'
    imageSku: 'win11-23h2-ent'
    authenticationType: 'password'
    vmAdminUsername: servicesUsername
    vmAdminPasswordOrKey: vmAdminPasswordOrKey
    diskStorageAccountType: 'Premium_LRS'
    numDataDisks: 1
    osDiskSize: 128
    dataDiskSize: 50
    dataDiskCaching: 'ReadOnly'
    enableAcceleratedNetworking: true
    enableMicrosoftEntraIdAuth: true
    userObjectId: userObjectId
    location: location
    tags: allTags
  }
}

@description('Name of the deployed Azure Resource Group.')
output resourceGroupName string = resourceGroup().name

@description('Name of the deployed Azure Key Vault.')
output azureKeyVaultName string = toLower(aiFoundryType) != 'basic' ? keyvault.outputs.name : ''

@description('Name of the deployed Azure AI Services account.')
output azureAiServicesName string = cognitiveServices.outputs.aiServicesName

@description('Name of the deployed Azure AI Search service.')
output azureAiSearchName string = toLower(aiFoundryType) != 'basic' ? aiSearch.outputs.searchName : ''

@description('Name of the deployed Azure AI Project.')
output azureAiProjectName string = project.outputs.projectName

@description('Name of the deployed Azure Bastion host.')
output azureBastionName string = networkIsolation ? network.outputs.bastionName : ''

@description('Resource ID of the deployed Azure VM.')
output azureVmResourceId string = shouldDeployVM ? virtualMachine.outputs.id : ''

@description('Username for the deployed Azure VM.')
output azureVmUsername string = toLower(aiFoundryType) != 'basic' ? servicesUsername : ''

@description('Name of the deployed Azure Container Registry.')
output azureContainerRegistryName string = toLower(aiFoundryType) != 'basic' ? containerRegistry.outputs.name : ''

@description('Name of the deployed Azure Storage Account.')
output azureStorageAccountName string = toLower(aiFoundryType) != 'basic' ? storageAccount.outputs.storageName : ''

@description('Name of the deployed Azure Virtual Network.')
output azureVirtualNetworkName string = networkIsolation ? network.outputs.virtualNetworkName : ''

@description('Name of the deployed Azure Virtual Network Subnet.')
output azureVirtualNetworkSubnetName string = networkIsolation ? network.outputs.vmSubnetName : ''

@description('Name of the deployed Azure Cosmos DB account.')
output azureCosmosAccountName string = toLower(aiFoundryType) != 'basic' ? cosmosDb.outputs.cosmosDBname : ''
