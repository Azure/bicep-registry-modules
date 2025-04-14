targetScope = 'subscription'

//*****Parameter Section*****
@minLength(3)
@maxLength(12)
@description('The name of the environment/application. This will be used to create the resource group and other resources.')
param name string

@description('Optional tags to apply to the resources')
param tags object

@secure()
@description('The password for the local admin user on the Virtual Machine')
param adminPassword string

@secure()
@description('The name for the local admin user on the Virtual Machine')
param adminUsername string

@description('The name of the managed identity')
param managedIdentityName string

@description('The name of the Hub managed identity')
param hubManagedIdentityName string

@description('The Azure resource group where main resources will be deployed')
param resourceGroupName string

@description('The Azure region where resources will be deployed')
param location string

@description('Name of the Azure Cognitive Search service')
param searchServiceName string

//**** Add the Foundry Hub AI dependencies parameters****
@description('Name of the Cognitive Services Account')
param cognitiveAccountName string

@description('Required. Kind of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'AIServices'
  'AnomalyDetector'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'ContentSafety'
  'ConversationalLanguageUnderstanding'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Face'
  'FormRecognizer'
  'HealthInsights'
  'ImmersiveReader'
  'Internal.AllInOne'
  'LUIS'
  'LUIS.Authoring'
  'LanguageAuthoring'
  'MetricsAdvisor'
  'OpenAI'
  'Personalizer'
  'QnAMaker.v2'
  'SpeechServices'
  'TextAnalytics'
  'TextTranslation'
])
param cognitiveKind string

@description('Azure AI Search SKU')
@allowed([
  'standard'
  'standard2'
  'standard3'
]
)
param searchSKU string = 'standard'

@description('Name of Storage Account')
param storageAccountName string

@description('Whether to deploy the GPT model')
param deployGPTModel bool = true

@allowed([
  'gpt-4'
  'gpt-4o'
  'gpt-4o-mini'
  'gpt-4-32k'
  'gpt-35-turbo'
  'gpt-35-turbo-16k'
  'gpt-35-turbo-instruct'
])
@description('GPT Model Name')
param gptModelName string = 'gpt-4o'

@description('GPT Model Version')
param gptModelVersion string = '2024-05-13'

@description('GPT Model Capacity')
param gptModelCapacity int = 10

@allowed([
  'bastion'
  'vpn'
  'none'
])
@description('Method to connect to private resources')
param privateConnectionMethod string = 'vpn'

@allowed([
  'certificate'
  'entra'
])
@description('VPN Authentication Type, only used when \'privateConnectionMethod\' is \'vpn\'')
param vpnAuthenticationType string = 'entra'

@description('VPN Gateway AAD Tenant ID, only used when privateConnectionMethod is \'vpn\' and \'vpnAuthenticationType\' is \'entra\'')
param vpnAadTenant string = '${environment().authentication.loginEndpoint}${tenant().tenantId}'

@description('VPN Gateway AAD Audience, only used when privateConnectionMethod is \'vpn\' and \'vpnAuthenticationType\' is \'entra\'')
param vpnAadAudience string = 'c632b3df-fb67-4d84-bdcf-b95ad541b5c8' // Azure Public

@description('VPN Gateway AAD Issuer, only used when privateConnectionMethod is \'vpn\' and \'vpnAuthenticationType\' is \'entra\'')
param vpnAadIssuer string = 'https://sts.windows.net/${tenant().tenantId}/'

@description('VPN Gateway Root Certificate Public Key, required when privateConnectionMethod is \'vpn\' and \'vpnAuthenticationType\' is \'certificate\'')
param vpnRootCertificatePublicKey string?

@allowed([
  'Basic'
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
  'VpnGw4'
  'VpnGw5'
  'VpnGw1AZ'
  'VpnGw2AZ'
  'VpnGw3AZ'
  'VpnGw4AZ'
  'VpnGw5AZ'
])
@description('VPN Gateway SKU, only used when privateConnectionMethod is \'vpn\'. Choose a SKU that is appropriate for the expected use case and requirements. A complete comparison of all gateway SKUs can be found at https://learn.microsoft.com/en-us/azure/vpn-gateway/about-gateway-skus.')
param vpnSku string = 'VpnGw2AZ'

@description('VPN Gateway Public IP Name')
param publicIpName string = 'pip-${name}'

@description('VPN Gateway public IP zones, an empty array will disable zone redundancy')
param publicIpZones int[] = [
  1
  2
  3
]

@description('Whether to deploy a private DNS resolver')
param deployPrivateDnsResolver bool = privateConnectionMethod == 'vpn'

@description('Private DNS Resolver Name')
param privateDnsResolverName string = 'dns-${name}'

@description('Private DNS Resolver Subnet Name')
param privateDnsResolverSubnetName string = 'snet-dns-${name}'

param vmZone int

param vmSku string

@description('Whether to include Cosmos DB in the deployment')
param includeCosmosDb bool = true

@description('Optional list of Cosmos DB databases to deploy')
param cosmosDatabases sqlDatabaseType[] = []

@description('Whether to include SQL Server in the deployment')
param includeSqlServer bool = true

@description('Optional list of SQL Server databases to deploy')
param sqlServerDatabases databasePropertyType[] = []

var resourceToken = toLower(uniqueString(subscription().id, name, location))

var defaultTags = {
  Env: name
  'azd-env-name': name
}
var allTags = union(defaultTags, tags)

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName != null && length(resourceGroupName) > 1 ? resourceGroupName : 'rg-${name}'
  tags: allTags
}

module msi 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0'= {
  name: take('${name}-identity-deployment', 64)
  scope: resourceGroup
  params: {
    name: managedIdentityName != null && length(managedIdentityName) > 1 ? managedIdentityName : 'id-${resourceToken}'
    location: location
    tags: allTags
  }
}

module hubMsi 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: take('${name}-hub-identity-deployment', 64)
  scope: resourceGroup
  params: {
    name: hubManagedIdentityName != null && length(hubManagedIdentityName) > 1 ? hubManagedIdentityName : 'id-hub-${resourceToken}'
    location: location
    tags: allTags
  }
}

module cognitiveAccount 'br/public:avm/res/cognitive-services/account:0.9.2' =  {
  name: take('${name}-cognitiveservices-deployment', 64)
  scope: resourceGroup
  params: {
    name: cognitiveAccountName
    kind: cognitiveKind
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    sku: 'S0'
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalId: hubMsi.outputs.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: msi.outputs.principalId
        roleDefinitionIdOrName: 'Cognitive Services User'
        principalType: 'ServicePrincipal'
      }
    ]

    tags: allTags
  }
}

module searchService 'br/public:avm/res/search/search-service:0.9.0' = {
  scope: resourceGroup
  name: take('${name}-searchservices-deployment', 64)
  params: {
      name: searchServiceName != null && length(searchServiceName) > 1 ? searchServiceName : 'search${resourceToken}'
      location: location
      cmkEnforcement: 'Enabled'
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          msi.outputs.resourceId
        ]
        }
      publicNetworkAccess: 'Disabled'
      disableLocalAuth: true
      sku: searchSKU
      tags: allTags
  }
}

module baseline 'br/public:avm/ptn/ai-platform/baseline:0.6.0' = {
  name: take('${name}-ai-baseline-deployment', 64)
  scope: resourceGroup
  params: {
    name: name
    location: location
    //managedIdentityName: hubMsi.outputs.name
    tags: allTags
    
    applicationInsightsConfiguration: {
 
    }
    bastionConfiguration: {

    }
    containerRegistryConfiguration: {
    }
    keyVaultConfiguration: {
    }
    logAnalyticsConfiguration: { 
    }
    storageAccountConfiguration: { 
      name: storageAccountName != null && length(storageAccountName) > 1 ? storageAccountName : 'sa${resourceToken}'
      sku: 'Standard_GZRS'
    }
    virtualMachineConfiguration: {
      adminPassword: adminPassword
      adminUsername: adminUsername
      enableAadLoginExtension: true
      enableAzureMonitorAgent: true
      encryptionAtHost: false
      patchMode: 'AutomaticByPlatform'
      zone: vmZone
      size: vmSku
    }
    virtualNetworkConfiguration: { 
    }
    workspaceConfiguration: {
      name: '${name}hub'
      projectName: '${name}proj'
      networkOutboundRules: {
        openai:{
          category: 'UserDefined'
          type: 'PrivateEndpoint'
          destination: {
            serviceResourceId: cognitiveAccount.outputs.resourceId
            subresourceTarget: 'account'
          }
        }
        aisearch:{
          category: 'UserDefined' 
          type: 'PrivateEndpoint'
          destination:{
            serviceResourceId: searchService.outputs.resourceId
            subresourceTarget: 'searchService'
          }
        }
      }
    }
  }
} 

module cosmosdb 'modules/cosmos_db.bicep' = if (includeCosmosDb) {
  name: take('${name}-cosmosdb-deployment', 64)
  scope: resourceGroup
  params: {
    name: 'cos${resourceToken}'
    databases: cosmosDatabases
    location: location
    virtualNetworkResourceId: baseline.outputs.virtualNetworkResourceId
    virtualNetworkSubnetResourceId: baseline.outputs.virtualNetworkSubnetResourceId
    storageAccountResourceId: baseline.outputs.storageAccountResourceId
    logAnalyticsWorkspaceResourceId: baseline.outputs.logAnalyticsWorkspaceResourceId
    tags: allTags
  }
}

module sqlServer 'modules/sql_server.bicep' = if (includeSqlServer) {
  name: take('${name}-sqlserver-deployment', 64)
  scope: resourceGroup
  params: {
    name: 'sql${resourceToken}'
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    databases: sqlServerDatabases
    keyVaultUri: baseline.outputs.keyVaultUri
    managedIdentityResourceId: msi.outputs.resourceId
    virtualNetworkResourceId: baseline.outputs.virtualNetworkResourceId
    virtualNetworkSubnetResourceId: baseline.outputs.virtualNetworkSubnetResourceId
    tags: allTags
  }
}

module app 'modules/app/app.bicep'= {
  name:take('${name}-app-deployment', 64)
  scope: resourceGroup
  params: {
    name: name
  }
}

import { sqlDatabaseType, databasePropertyType } from 'modules/custom_types.bicep'
