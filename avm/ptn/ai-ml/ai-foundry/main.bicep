metadata name = 'ai-foundry'
metadata description = 'Creates an AI Foundry account and project with Standard Agent Services.'

targetScope = 'resourceGroup'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Specifies the connections to be created for the Azure AI Hub workspace. The connections are used to connect to other Azure resources and services.')
param connections connectionType[] = []

@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentsType[] = []

@description('Specifies whether creating an Azure Container Registry.')
param acrEnabled bool

@description('Specifies the size of the jump-box Virtual Machine.')
param vmSize string = 'Standard_DS4_v2'

@minLength(3)
@maxLength(20)
@description('Specifies the name of the administrator account for the jump-box virtual machine. Defaults to "[name]vmuser". This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion.')
param vmAdminUsername string = '${name}vmuser'

@minLength(4)
@maxLength(70)
@description('Specifies the password for the jump-box virtual machine. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. Value should be meet 3 of the following: uppercase character, lowercase character, numberic digit, special character, and NO control characters.')
@secure()
param vmAdminPasswordOrKey string

@description('Optional. Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.')
param tags object = {}

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string = deployer().objectId

@description('Optional IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed.')
param allowedIpAddress string = ''

@description('Specifies whether network isolation is enabled. When true, Foundry and related components will be deployed, network access parameters will be set to Disabled.')
param networkIsolation bool = true

@description('Whether to include Cosmos DB in the deployment.')
param cosmosDbEnabled bool = true

@description('Optional. List of Cosmos DB databases to deploy.')
param cosmosDatabases sqlDatabaseType[] = []

@description('Whether to include Azure AI Search in the deployment.')
param searchEnabled bool = true

@description('Whether to include Azure AI Content Safety in the deployment.')
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

@description('Name of the AI Foundry project')
param projectName string = '${name}proj'

var defaultTags = {
  'azd-env-name': name
}
var allTags = union(defaultTags, tags)

var resourceToken = substring(uniqueString(subscription().id, location, name), 0, 5)
var servicesUsername = take(replace(vmAdminUsername, '.', ''), 20)

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  name: take('${name}-log-analytics-deployment', 64)
  params: {
    name: toLower('log-${name}')
    location: location
    tags: allTags
    skuName: 'PerNode'
    dataRetention: 60
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: take('${name}-app-insights-deployment', 64)
  params: {
    name: toLower('appi-${name}')
    location: location
    tags: allTags
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

module network 'modules/virtualNetwork.bicep' = if (networkIsolation) {
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
    workspaceId: logAnalyticsWorkspace.outputs.resourceId
    location: location
    tags: allTags
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: take('${name}-keyvault-deployment', 64)
  params: {
    name: 'kv${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    userObjectId: userObjectId
    tags: allTags
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = if (acrEnabled) {
  name: take('${name}-container-registry-deployment', 64)
  params: {
    name: 'cr${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    tags: allTags
  }
}

module storageAccount 'modules/storageAccount.bicep' = {
  name: take('${name}-storage-account-deployment', 64)
  params: {
    storageName: 'st${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    roleAssignments: concat(
      empty(userObjectId)
        ? []
        : [
            {
              principalId: userObjectId
              principalType: 'User'
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
      searchEnabled
        ? [
            {
              principalId: searchEnabled ? aiSearch.outputs.systemAssignedMIPrincipalId : ''
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Storage Blob Data Contributor'
            }
          ]
        : []
    )
    tags: allTags
  }
}

module cognitiveServices 'modules/cognitive-services/main.bicep' = {
  name: '${name}-cognitive-services-deployment'
  params: {
    name: name
    resourceToken: resourceToken
    location: location
    networkIsolation: networkIsolation
    networkAcls: networkAcls
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    aiModelDeployments: aiModelDeployments
    userObjectId: userObjectId
    contentSafetyEnabled: contentSafetyEnabled
    visionEnabled: visionEnabled
    languageEnabled: languageEnabled
    speechEnabled: speechEnabled
    translatorEnabled: translatorEnabled
    documentIntelligenceEnabled: documentIntelligenceEnabled
    tags: allTags
  }
}

// // Add the new FDP cognitive services module
module project 'modules/ai-foundry-project/main.bicep' = {
  name: '${name}prj'
  params: {
    cosmosDBname: cosmosDbEnabled ? cosmosDb.outputs.cosmosDBname : ''
    cosmosDbEnabled: cosmosDbEnabled
    searchEnabled: searchEnabled
    name: projectName
    location: location
    storageName: storageAccount.outputs.storageName
    aiServicesName: cognitiveServices.outputs.aiServicesName
    nameFormatted: searchEnabled ? aiSearch.outputs.name : ''
  }
}

module aiSearch 'modules/aisearch.bicep' = if (searchEnabled) {
  name: take('${name}-ai-search-deployment', 64)
  params: {
    name: 'srch${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    userObjectId: userObjectId
    roleAssignments: union(
      empty(userObjectId)
        ? []
        : [
            {
              principalId: userObjectId
              principalType: 'User'
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

module virtualMachine './modules/virtualMachine.bicep' = if (networkIsolation) {
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
    dataDiskCaching: 'ReadWrite'
    enableAcceleratedNetworking: true
    enableMicrosoftEntraIdAuth: true
    userObjectId: userObjectId
    workspaceId: logAnalyticsWorkspace.outputs.resourceId
    location: location
    tags: allTags
  }
  dependsOn: networkIsolation ? [storageAccount] : []
}

module cosmosDb 'modules/cosmosDb.bicep' = if (cosmosDbEnabled) {
  name: take('${name}-cosmosdb-deployment', 64)
  params: {
    name: 'cos${name}${resourceToken}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network.outputs.vmSubnetId : ''
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    databases: cosmosDatabases
    tags: allTags
  }
}

import { sqlDatabaseType, databasePropertyType, deploymentsType } from 'modules/customTypes.bicep'
import { connectionType } from 'br/public:avm/res/machine-learning-services/workspace:0.10.1'

output AZURE_KEY_VAULT_NAME string = keyvault.outputs.name
output AZURE_AI_SERVICES_NAME string = cognitiveServices.outputs.aiServicesName
output AZURE_AI_SEARCH_NAME string = searchEnabled ? aiSearch.outputs.name : ''
output AZURE_AI_HUB_NAME string = cognitiveServices.outputs.aiServicesName
output AZURE_AI_PROJECT_NAME string = project.outputs.projectName
output AZURE_BASTION_NAME string = networkIsolation ? network.outputs.bastionName : ''
output AZURE_VM_RESOURCE_ID string = networkIsolation ? virtualMachine.outputs.id : ''
output AZURE_VM_USERNAME string = servicesUsername
output AZURE_APP_INSIGHTS_NAME string = applicationInsights.outputs.name
output AZURE_CONTAINER_REGISTRY_NAME string = acrEnabled ? containerRegistry.outputs.name : ''
output AZURE_LOG_ANALYTICS_WORKSPACE_NAME string = logAnalyticsWorkspace.outputs.name
output AZURE_STORAGE_ACCOUNT_NAME string = storageAccount.outputs.storageName
output AZURE_VIRTUAL_NETWORK_NAME string = networkIsolation ? network.outputs.virtualNetworkName : ''
output AZURE_VIRTUAL_NETWORK_SUBNET_NAME string = networkIsolation ? network.outputs.vmSubnetName : ''
output AZURE_SQL_SERVER_USERNAME string = sqlServerEnabled ? servicesUsername : ''
output AZURE_COSMOS_ACCOUNT_NAME string = cosmosDbEnabled ? cosmosDb.outputs.cosmosDBname : ''
