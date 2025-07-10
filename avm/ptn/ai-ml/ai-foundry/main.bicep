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

@description('Optional. Specifies the princpal id of a Microsoft Entra ID managed identity (principalType: ServicePrincipal) that should be granted basic, appropriate, and applicable access to resources created.')
param identityPrincipalId string?

@description('Optional. IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed.')
param allowedIpAddress string = ''

@description('Optional. Resource ID of an existing Log Analytics workspace for VM monitoring. If provided, data collection rules will be created for the VM.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. Enable VM monitoring with data collection rules. Only effective if logAnalyticsWorkspaceResourceId is provided.')
param enableVmMonitoring bool = false

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

var networkIsolation = toLower(aiFoundryType) == 'standardprivate'
var basicDeployment = toLower(aiFoundryType) == 'basic'
var servicesUsername = take(replace(vmAdminUsername, '.', ''), 20)

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

module network 'modules/virtualNetwork.bicep' = if (networkIsolation) {
  name: take('${name}-network-deployment', 64)
  params: {
    virtualNetworkName: toLower('vnet-${resourcesName}')
    virtualNetworkAddressPrefixes: '10.0.0.0/8'
    vmSubnetName: toLower('snet-${resourcesName}-vm')
    vmSubnetAddressPrefix: '10.3.1.0/24'
    vmSubnetNsgName: toLower('nsg-snet-${resourcesName}-vm')
    bastionHostEnabled: true
    bastionSubnetAddressPrefix: '10.3.2.0/24'
    bastionSubnetNsgName: 'nsg-AzureBastionSubnet'
    bastionHostName: toLower('bas-${resourcesName}')
    bastionHostDisableCopyPaste: false
    bastionHostEnableFileCopy: true
    bastionHostEnableIpConnect: true
    bastionHostEnableShareableLink: true
    bastionHostEnableTunneling: true
    bastionPublicIpAddressName: toLower('pip-bas-${resourcesName}')
    bastionHostSkuName: 'Standard'
    natGatewayName: toLower('nat-${resourcesName}')
    natGatewayPublicIps: 1
    natGatewayIdleTimeoutMins: 30
    allowedIpAddress: allowedIpAddress
    location: location
    tags: tags
  }
}

module keyvault 'modules/keyvault.bicep' = if (!basicDeployment) {
  name: take('${name}-keyvault-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [network]
  params: {
    name: 'kv${resourcesName}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network!.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network!.outputs.vmSubnetResourceId : ''
    roleAssignments: empty(identityPrincipalId)
      ? []
      : [
          {
            principalId: identityPrincipalId!
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Key Vault Secrets User'
          }
        ]
    logAnalyticsWorkspaceResourceId: ''
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = if (!basicDeployment) {
  name: take('${name}-container-registry-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [network]
  params: {
    #disable-next-line BCP334
    name: 'cr${resourcesName}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network!.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network!.outputs.vmSubnetResourceId : ''
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module cognitiveServices 'modules/ai-foundry-account/aifoundryaccount.bicep' = {
  name: take('${name}-cognitive-services-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [network]
  params: {
    name: resourcesName
    location: location
    networkIsolation: networkIsolation
    networkAcls: networkAcls
    virtualNetworkResourceId: networkIsolation ? network!.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network!.outputs.vmSubnetResourceId : ''
    aiModelDeployments: aiModelDeployments
    roleAssignments: empty(identityPrincipalId)
      ? []
      : [
          {
            principalId: identityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
          }
          {
            principalId: identityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services Contributor'
          }
          {
            principalId: identityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Cognitive Services User'
          }
        ]
    contentSafetyEnabled: contentSafetyEnabled
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module aiSearch 'modules/aisearch.bicep' = if (!basicDeployment) {
  name: take('${name}-ai-search-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [network]
  params: {
    name: 'srch${resourcesName}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network!.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network!.outputs.vmSubnetResourceId : ''
    roleAssignments: empty(identityPrincipalId)
      ? []
      : [
          {
            principalId: identityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Search Index Data Contributor'
          }
          {
            principalId: identityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Search Index Data Reader'
          }
        ]
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module storageAccount 'modules/storageAccount.bicep' = if (!basicDeployment) {
  name: take('${name}-storage-account-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [network]
  params: {
    name: 'st${resourcesName}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network!.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network!.outputs.vmSubnetResourceId : ''
    enableTelemetry: enableTelemetry
    roleAssignments: concat(
      empty(identityPrincipalId)
        ? []
        : [
            {
              principalId: identityPrincipalId
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

module cosmosDb 'modules/cosmosDb.bicep' = if (!basicDeployment) {
  name: take('${name}-cosmosdb-deployment', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [network]
  params: {
    name: 'cos${resourcesName}'
    location: location
    networkIsolation: networkIsolation
    virtualNetworkResourceId: networkIsolation ? network!.outputs.virtualNetworkId : ''
    virtualNetworkSubnetResourceId: networkIsolation ? network!.outputs.vmSubnetResourceId : ''
    enableTelemetry: enableTelemetry
    databases: cosmosDatabases
    tags: tags
  }
}

module project 'modules/aifoundryproject.bicep' = {
  name: take('${name}-foundry-project-deployment', 64)
  dependsOn: !basicDeployment
    ? [
        storageAccount
        aiSearch
        cosmosDb
      ]
    : []
  params: {
    basicDeploymentOnly: basicDeployment
    cosmosDBName: !basicDeployment ? cosmosDb!.outputs.cosmosDBname : ''
    name: empty(projectName) ? 'proj-${resourcesName}' : projectName!
    location: location
    storageName: !basicDeployment ? storageAccount!.outputs.storageName : ''
    aiServicesName: cognitiveServices.outputs.aiServicesName
    aiSearchName: !basicDeployment ? aiSearch!.outputs.searchName : ''
    projUploadsContainerName: !basicDeployment ? storageAccount!.outputs.projUploadsContainerName : ''
    sysDataContainerName: !basicDeployment ? storageAccount!.outputs.sysDataContainerName : ''
  }
}

// Only deploy the VM if we're doing a StandardPrivate deployment and have a valid password
var shouldDeployVM = networkIsolation && (length(vmAdminPasswordOrKey) >= 4)

module virtualMachine './modules/virtualMachine.bicep' = if (shouldDeployVM) {
  name: take('${name}-virtual-machine-deployment', 64)
  params: {
    name: 'vm-${resourcesName}-jump'
    nicName: 'nic-vm-${resourcesName}-jump'
    size: vmSize
    subnetResourceId: network!.outputs.vmSubnetResourceId
    storageAccountName: storageAccount!.outputs.storageName
    storageAccountResourceGroup: resourceGroup().name
    imagePublisher: 'MicrosoftWindowsServer'
    imageOffer: 'WindowsServer'
    imageSku: '2022-datacenter-azure-edition'
    authenticationType: 'password'
    adminUsername: servicesUsername
    adminPasswordOrKey: vmAdminPasswordOrKey
    diskStorageAccountType: 'Premium_LRS'
    numDataDisks: 1
    osDiskSize: 128
    dataDiskSize: 50
    dataDiskCaching: 'ReadOnly'
    enableAcceleratedNetworking: true
    enableMicrosoftEntraIdAuth: true
    location: location
    tags: tags
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    enableMonitoring: enableVmMonitoring
  }
}

@description('Name of the deployed Azure Resource Group.')
output resourceGroupName string = resourceGroup().name

@description('Name of the deployed Azure Key Vault.')
output keyVaultName string = !basicDeployment ? keyvault!.outputs.name : ''

@description('Name of the deployed Azure AI Services account.')
output aiServicesName string = cognitiveServices.outputs.aiServicesName

@description('Name of the deployed Azure AI Search service.')
output aiSearchName string = !basicDeployment ? aiSearch!.outputs.searchName : ''

@description('Name of the deployed Azure AI Project.')
output aiProjectName string = project.outputs.projectName

@description('Name of the deployed Azure Bastion host.')
output bastionName string = networkIsolation ? network!.outputs.bastionName : ''

@description('Resource ID of the deployed Azure VM.')
output vmResourceId string = shouldDeployVM ? virtualMachine!.outputs.id : ''

@description('Username for the deployed Azure VM.')
output vmUsername string = !basicDeployment ? servicesUsername : ''

@description('Name of the deployed Azure Container Registry.')
output containerRegistryName string = !basicDeployment ? containerRegistry.?outputs.name ?? '' : ''

@description('Name of the deployed Azure Storage Account.')
output storageAccountName string = !basicDeployment ? storageAccount.?outputs.storageName ?? '' : ''

@description('Name of the deployed Azure Virtual Network.')
output virtualNetworkName string = networkIsolation ? network!.outputs.virtualNetworkName : ''

@description('Name of the deployed Azure Virtual Network Subnet.')
output virtualNetworkSubnetName string = networkIsolation ? network!.outputs.vmSubnetName : ''

@description('Name of the deployed Azure Cosmos DB account.')
output cosmosAccountName string = !basicDeployment ? cosmosDb!.outputs.cosmosDBname : ''
