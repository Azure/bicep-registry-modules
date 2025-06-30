metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services.'

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

import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.11.0'
@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentType[] = []

import { sqlDatabaseType } from 'br/public:avm/res/document-db/database-account:0.15.0'
@description('Optional. List of Cosmos DB databases to create.')
param cosmosDatabases sqlDatabaseType[] = []

@description('Optional. Specifies the size of the jump-box Virtual Machine.')
param vmSize string = 'Standard_DS4_v2'

@minLength(3)
@maxLength(20)
@description('Optional. Specifies the name of the administrator account for the jump-box virtual machine. Defaults to "[name]vmuser". This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion.')
param vmAdminUsername string = take('${name}vmuser', 20)

@maxLength(70)
@description('Optional. Specifies the password for the jump-box virtual machine. This is only required when aiFoundryType is StandardPrivate (when VM is deployed). Value should meet 3 of the following: uppercase character, lowercase character, numeric digit, special character, and NO control characters.')
@secure()
param vmAdminPasswordOrKey string = ''

@description('Optional. Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.')
param tags object = {}

@description('Optional. Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string = deployer().objectId

@description('Optional. IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed.')
param allowedIpAddress string = ''

@description('Optional. Resource ID of an existing Log Analytics workspace for VM monitoring. If provided, data collection rules will be created for the VM.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. Enable VM monitoring with data collection rules. Only effective if logAnalyticsWorkspaceResourceId is provided.')
param enableVmMonitoring bool = false

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
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetResourceId : ''
    userObjectId: userObjectId
    logAnalyticsWorkspaceResourceId: ''
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
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetResourceId : ''
    enableTelemetry: enableTelemetry
    tags: allTags
  }
}

module cognitiveServices 'modules/ai-foundry-account/aifoundryaccount.bicep' = {
  name: '${name}-cognitive-services-deployment'
  params: {
    aiFoundryType: aiFoundryType
    name: name
    location: location
    networkIsolation: networkIsolation
    networkAcls: networkAcls
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetResourceId : ''
    aiModelDeployments: aiModelDeployments
    userObjectId: userObjectId
    contentSafetyEnabled: contentSafetyEnabled
    enableTelemetry: enableTelemetry
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
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetResourceId : ''
    userObjectId: userObjectId
    enableTelemetry: enableTelemetry
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
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetResourceId : ''
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
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetResourceId : ''
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

// Only deploy the VM if we're doing a StandardPrivate deployment and have a valid password
var shouldDeployVM = (toLower(aiFoundryType) == 'standardprivate') && (length(vmAdminPasswordOrKey) >= 4)

module virtualMachine './modules/virtualMachine.bicep' = if (shouldDeployVM) {
  name: take('${name}-virtual-machine-deployment', 64)
  params: {
    vmName: toLower('vm-${name}-jump')
    vmNicName: toLower('nic-vm-${name}-jump')
    vmSize: vmSize
    vmSubnetResourceId: network.outputs.vmSubnetResourceId
    storageAccountName: storageAccount.outputs.storageName
    storageAccountResourceGroup: resourceGroup().name
    imagePublisher: 'MicrosoftWindowsServer'
    imageOffer: 'WindowsServer'
    imageSku: '2022-datacenter-azure-edition'
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
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    enableMonitoring: enableVmMonitoring
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
