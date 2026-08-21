// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Intelligent Content Generation Accelerator'
metadata description = '''This module deploys the [Content Generation Solution Accelerator](https://github.com/microsoft/content-generation-solution-accelerator).

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/content-generation-solution-accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

@minLength(3)
@maxLength(15)
@description('Optional. A unique application/solution name for all resources in this deployment.')
param solutionName string = 'contentgen'

@maxLength(5)
@description('Optional. A unique text value for the solution.')
param solutionUniqueText string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

@metadata({ azd: { type: 'location' } })
@description('Optional. Azure region for all services.')
param location string = resourceGroup().location

@minLength(3)
@description('Optional. Secondary location for databases creation.')
param secondaryLocation string = 'uksouth'

// NOTE: Metadata must be compile-time constants. Update usageName manually if you change model parameters.
// Format: 'OpenAI.<DeploymentType>.<ModelName>,<Capacity>'
// Allowed regions: Union of GPT-5.1, gpt-image-1-mini, and gpt-image-1.5 GlobalStandard availability
@allowed([
  'australiaeast'
  'canadaeast'
  'eastus2'
  'japaneast'
  'koreacentral'
  'polandcentral'
  'swedencentral'
  'switzerlandnorth'
  'uaenorth'
  'uksouth'
  'westus3'
])
@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-5.1,150'
      'OpenAI.GlobalStandard.gpt-image-1-mini,1'
    ]
  }
})
@description('Required. Location for AI deployments.')
param azureAiServiceLocation string

@minLength(1)
@allowed([
  'Standard'
  'GlobalStandard'
])
@description('Optional. GPT model deployment type.')
param gptModelDeploymentType string = 'GlobalStandard'

@minLength(1)
@description('Optional. Name of the GPT model to deploy.')
param gptModelName string = 'gpt-5.1'

@description('Optional. Version of the GPT model to deploy.')
param gptModelVersion string = '2025-11-13'

@description('Optional. Image model to deploy: gpt-image-1-mini, gpt-image-1.5, or none to skip.')
@allowed([
  'gpt-image-1-mini'
  'gpt-image-1.5'
  'none'
])
param imageModelChoice string = 'gpt-image-1-mini'

@description('Optional. API version for Azure OpenAI service.')
param azureOpenaiAPIVersion string = '2025-01-01-preview'

@description('Optional. API version for Azure AI Agent service.')
param azureAiAgentApiVersion string = '2025-05-01'

@minValue(10)
@description('Optional. AI model deployment token capacity.')
param gptModelCapacity int = 150

@minValue(1)
@description('Optional. Image model deployment capacity (RPM).')
param imageModelCapacity int = 1

@description('Optional. Deploy Azure Bastion and Jumpbox VM for private network administration.')
param deployBastionAndJumpbox bool = false

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {}

@description('Optional. Enable monitoring for applicable resources (WAF-aligned).')
param enableMonitoring bool = true

@description('Optional. Enable Azure AI Foundry mode for multi-agent orchestration.')
param useFoundryMode bool = true

@description('Optional. Enable scalability for applicable resources (WAF-aligned).')
param enableScalability bool = true

@description('Optional. Enable redundancy for applicable resources (WAF-aligned).')
param enableRedundancy bool = true

@description('Optional. Enable private networking for applicable resources (WAF-aligned).')
param enablePrivateNetworking bool = true

@description('Optional. The existing Container Registry name (without .azurecr.io). Must contain pre-built images: content-gen-app and content-gen-api.')
param acrName string = 'contentgencontainerreg'

@description('Optional. Image Tag.')
param imageTag string = 'latest_2026-04-28_257'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Created by user name.')
param createdBy string = contains(deployer(), 'userPrincipalName')
  ? split(deployer().userPrincipalName, '@')[0]
  : deployer().objectId

// ============== //
// Variables      //
// ============== //

var solutionLocation = empty(location) ? resourceGroup().location : location

// acrName is required - points to existing ACR with pre-built images
var acrResourceName = acrName
var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueText}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))
@description('Conditional. Location for the Cosmos DB replica deployment. Required if enableRedundancy is set to true.')
param cosmosDbReplicaLocation string?

var replicaRegionPairs = {
  australiaeast: 'australiasoutheast'
  centralus: 'westus'
  eastasia: 'japaneast'
  eastus: 'centralus'
  eastus2: 'centralus'
  japaneast: 'eastasia'
  northeurope: 'westeurope'
  southeastasia: 'eastasia'
  uksouth: 'westeurope'
  westus: 'westus3'
  westus3: 'westus'
}
var replicaLocation = replicaRegionPairs[?resourceGroup().location] ?? secondaryLocation

var azureSearchIndex = 'products'
var aiSearchName = 'srch-${solutionSuffix}'
var aiSearchConnectionName = 'foundry-search-connection-${solutionSuffix}'

var aiFoundryAiServicesResourceGroupName = 'rg-${solutionSuffix}'
var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'
var aiFoundryAiProjectResourceName = 'proj-${solutionSuffix}'

// Base model deployments (GPT only - no embeddings needed for content generation)
var baseModelDeployments = [
  {
    format: 'OpenAI'
    name: gptModelName
    model: gptModelName
    sku: {
      name: gptModelDeploymentType
      capacity: gptModelCapacity
    }
    version: gptModelVersion
    raiPolicyName: 'Microsoft.Default'
  }
]

// Image model configuration based on choice
var imageModelConfig = {
  'gpt-image-1-mini': {
    name: 'gpt-image-1-mini'
    version: '2025-10-06'
    sku: 'GlobalStandard'
  }
  'gpt-image-1.5': {
    name: 'gpt-image-1.5'
    version: '2025-12-16'
    sku: 'GlobalStandard'
  }
  none: {
    name: ''
    version: ''
    sku: ''
  }
}

// Image model deployment (optional)
var imageModelDeployment = imageModelChoice != 'none'
  ? [
      {
        format: 'OpenAI'
        name: imageModelConfig[imageModelChoice].name
        model: imageModelConfig[imageModelChoice].name
        sku: {
          name: imageModelConfig[imageModelChoice].sku
          capacity: imageModelCapacity
        }
        version: imageModelConfig[imageModelChoice].version
        raiPolicyName: 'Microsoft.Default'
      }
    ]
  : []

// Combine deployments based on imageModelChoice
var aiFoundryAiServicesModelDeployment = concat(baseModelDeployments, imageModelDeployment)

var aiFoundryAiProjectDescription = 'Content Generation AI Foundry Project'

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.sa-contentgeneration.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags: {
      ...resourceGroup().tags
      ...tags
      TemplateName: 'ContentGen'
      Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
      CreatedBy: createdBy
    }
  }
}

// ========== Log Analytics Workspace ========== //
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.15.0' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 365
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    diagnosticSettings: [{ useThisWorkspace: true }]
    dailyQuotaGb: enableRedundancy ? '10' : null
    replication: enableRedundancy
      ? {
          enabled: true
          location: replicaLocation
        }
      : null
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}
var logAnalyticsWorkspaceResourceId = enableMonitoring ? logAnalyticsWorkspace!.outputs.resourceId : ''

// ========== Application Insights ========== //
var applicationInsightsResourceName = 'appi-${solutionSuffix}'
module applicationInsights 'br/public:avm/res/insights/component:0.7.1' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    workspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
  }
}

// ========== User Assigned Identity ========== //
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== Virtual Network and Networking Components ========== //
module virtualNetwork 'modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtualNetwork.${solutionSuffix}', 64)
  params: {
    vnetName: 'vnet-${solutionSuffix}'
    vnetLocation: solutionLocation
    vnetAddressPrefixes: ['10.0.0.0/20']
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    enableTelemetry: enableTelemetry
    resourceSuffix: solutionSuffix
    deployBastionAndJumpbox: deployBastionAndJumpbox
  }
  dependsOn: enableMonitoring ? [logAnalyticsWorkspace] : []
}

// ========== Private DNS Zones ========== //
// Only create DNS zones for resources that need private endpoints:
// - Cognitive Services (for AI Services)
// - OpenAI (for Azure OpenAI endpoints)
// - Blob Storage
// - Cosmos DB (Documents)
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.documents.azure.com'
]

var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  storageBlob: 2
  cosmosDB: 3
}

@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.8.1' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: take('avm.res.network.private-dns-zone.${replace(zone, '.', '-')}', 64)
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          virtualNetworkResourceId: enablePrivateNetworking ? virtualNetwork!.outputs.resourceId : ''
          registrationEnabled: false
        }
      ]
    }
  }
]

// ========== AI Foundry: AI Services ========== //
module aiFoundryAiServices 'br/public:avm/res/cognitive-services/account:0.14.2' = {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: azureAiServiceLocation
    tags: tags
    enableTelemetry: enableTelemetry
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    allowProjectManagement: true
    customSubDomainName: aiFoundryAiServicesResourceName
    restrictOutboundNetworkAccess: false
    deployments: [
      for deployment in aiFoundryAiServicesModelDeployment: {
        name: deployment.name
        model: {
          format: deployment.format
          name: deployment.name
          version: deployment.version
        }
        raiPolicyName: deployment.raiPolicyName
        sku: {
          name: deployment.sku.name
          capacity: deployment.sku.capacity
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: {
      userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId]
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee' // Azure AI Developer
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' // Cognitive Services OpenAI User
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User for deployer
        principalId: deployer().objectId
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    // Note: Private endpoint is created separately to avoid timing issues with model deployments
  }
}

// Create private endpoint for AI Services AFTER the account is fully provisioned
module aiServicesPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.12.0' = if (enablePrivateNetworking) {
  name: take('pep-ai-services-${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: 'pep-${aiFoundryAiServicesResourceName}'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
    privateLinkServiceConnections: [
      {
        name: 'pep-${aiFoundryAiServicesResourceName}'
        properties: {
          privateLinkServiceId: aiFoundryAiServices!.outputs.resourceId
          groupIds: ['account']
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'cognitiveservices'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
        }
        {
          name: 'openai'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.openAI]!.outputs.resourceId
        }
      ]
    }
  }
}

module aiFoundryAiServicesProject 'modules/ai-project.bicep' = {
  name: take('module.ai-project.${aiFoundryAiProjectResourceName}', 64)
  params: {
    name: aiFoundryAiProjectResourceName
    location: azureAiServiceLocation
    tags: tags
    desc: aiFoundryAiProjectDescription
    aiServicesName: aiFoundryAiServicesResourceName
  }
  dependsOn: [
    aiFoundryAiServices
  ]
}

var aiFoundryAiProjectEndpoint = aiFoundryAiServicesProject.outputs.apiEndpoint

// ========== AI Search ========== //
module aiSearch 'br/public:avm/res/search/search-service:0.12.0' = {
  name: take('avm.res.search.search-service.${aiSearchName}', 64)
  params: {
    name: aiSearchName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    sku: enableScalability ? 'standard' : 'basic'
    replicaCount: enableRedundancy ? 3 : 1
    partitionCount: 1
    hostingMode: 'Default'
    semanticSearch: 'free'
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    disableLocalAuth: false
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Search Index Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Search Service Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // AI Search remains publicly accessible - accessed from ACI via managed identity
    publicNetworkAccess: 'Enabled'
  }
}

// ========== AI Search Connection to AI Services ========== //
resource aiSearchFoundryConnection 'Microsoft.CognitiveServices/accounts/projects/connections@2026-01-15-preview' = {
  name: '${aiFoundryAiServicesResourceName}/${aiFoundryAiProjectResourceName}/${aiSearchConnectionName}'
  properties: {
    category: 'CognitiveSearch'
    target: 'https://${aiSearchName}.search.windows.net'
    authType: 'AAD'
    isSharedToAll: true
    metadata: {
      ApiVersion: '2024-05-01-preview'
      ResourceId: aiSearch.outputs.resourceId
    }
  }
  dependsOn: [aiFoundryAiServicesProject]
}

// ========== Storage Account ========== //
var storageAccountName = 'st${solutionSuffix}'
var productImagesContainer = 'product-images'
var generatedImagesContainer = 'generated-images'
var dataContainer = 'data'

module storageAccount 'br/public:avm/res/storage/storage-account:0.32.0' = {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  params: {
    name: storageAccountName
    location: solutionLocation
    skuName: enableRedundancy ? 'Standard_ZRS' : 'Standard_LRS'
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    tags: tags
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    blobServices: {
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
      deleteRetentionPolicyEnabled: true
      deleteRetentionPolicyDays: 7
      containers: [
        {
          name: productImagesContainer
          publicAccess: 'None'
        }
        {
          name: generatedImagesContainer
          publicAccess: 'None'
        }
        {
          name: dataContainer
          publicAccess: 'None'
        }
      ]
    }
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
    }
    allowBlobPublicAccess: false
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            service: 'blob'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob]!.outputs.resourceId }
              ]
            }
          }
        ]
      : null
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
  }
}

// ========== Cosmos DB ========== //
var cosmosDBResourceName = 'cosmos-${solutionSuffix}'
var cosmosDBDatabaseName = 'content_generation_db'
var cosmosDBConversationsContainer = 'conversations'
var cosmosDBProductsContainer = 'products'

module cosmosDB 'br/public:avm/res/document-db/database-account:0.19.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDBResourceName}', 64)
  params: {
    name: 'cosmos-${solutionSuffix}'
    location: secondaryLocation
    tags: tags
    enableTelemetry: enableTelemetry
    sqlDatabases: [
      {
        name: cosmosDBDatabaseName
        containers: [
          {
            name: cosmosDBConversationsContainer
            paths: [
              '/userId'
            ]
          }
          {
            name: cosmosDBProductsContainer
            paths: [
              '/category'
            ]
          }
        ]
      }
    ]
    sqlRoleDefinitions: [
      {
        roleName: 'contentgen-data-contributor'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
      }
    ]
    sqlRoleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionId: '00000000-0000-0000-0000-000000000002' // Built-in Cosmos DB Data Contributor
      }
      {
        principalId: deployer().objectId
        roleDefinitionId: '00000000-0000-0000-0000-000000000002' // Built-in Cosmos DB Data Contributor to the deployer
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    networkRestrictions: {
      networkAclBypass: 'AzureServices'
      publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    }
    zoneRedundant: enableRedundancy
    capabilitiesToAdd: enableRedundancy ? null : ['EnableServerless']
    enableAutomaticFailover: enableRedundancy
    failoverLocations: enableRedundancy
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: secondaryLocation
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: cosmosDbReplicaLocation
          }
        ]
      : [
          {
            locationName: secondaryLocation
            failoverPriority: 0
            isZoneRedundant: false
          }
        ]
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            service: 'Sql'
            subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB]!.outputs.resourceId }
              ]
            }
          }
        ]
      : null
  }
}

// ========== App Service Plan ========== //
var webServerFarmResourceName = 'asp-${solutionSuffix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.7.0' = {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: tags
    enableTelemetry: enableTelemetry
    location: solutionLocation
    reserved: true
    kind: 'linux'
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    skuName: enableScalability || enableRedundancy ? 'P1v3' : 'B1'
    skuCapacity: enableRedundancy ? 2 : 1
    zoneRedundant: enableRedundancy ? true : false
  }
  scope: resourceGroup(resourceGroup().name)
}

// ========== Web App ========== //
var webSiteResourceName = 'app-${solutionSuffix}'
// Backend URL: Use ACI IP (private or public) or FQDN depending on networking mode
var aciPrivateIpFallback = '10.0.4.4'
var aciPublicFqdnFallback = '${containerInstanceName}.${solutionLocation}.azurecontainer.io'
// For private networking use IP, for public use FQDN
var aciBackendUrl = enablePrivateNetworking
  ? 'http://${aciPrivateIpFallback}:8000'
  : 'http://${aciPublicFqdnFallback}:8000'
module webSite 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteResourceName}', 64)
  params: {
    name: webSiteResourceName
    tags: tags
    location: solutionLocation
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.outputs.resourceId
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] }
    siteConfig: {
      // Frontend container - same for both modes
      linuxFxVersion: 'DOCKER|${acrResourceName}.azurecr.io/content-gen-app:${imageTag}'
      minTlsVersion: '1.2'
      alwaysOn: true
      ftpsState: 'FtpsOnly'
    }
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webSubnetResourceId : null
    configs: concat(
      [
        {
          // Frontend container proxies to ACI backend (both modes)
          name: 'appsettings'
          properties: {
            DOCKER_REGISTRY_SERVER_URL: 'https://${acrResourceName}.azurecr.io'
            BACKEND_URL: aciBackendUrl
            AZURE_CLIENT_ID: userAssignedIdentity.outputs.clientId
          }
          applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
        }
      ],
      enableMonitoring
        ? [
            {
              name: 'logs'
              properties: {}
            }
          ]
        : []
    )
    enableMonitoring: enableMonitoring
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    vnetRouteAllEnabled: enablePrivateNetworking
    vnetImagePullEnabled: enablePrivateNetworking
    publicNetworkAccess: 'Enabled'
  }
}

// ========== Container Instance (Backend API) ========== //
var containerInstanceName = 'aci-${solutionSuffix}'
module containerInstance 'modules/container-instance.bicep' = {
  name: take('module.container-instance.${containerInstanceName}', 64)
  params: {
    name: containerInstanceName
    location: solutionLocation
    tags: tags
    containerImage: '${acrResourceName}.azurecr.io/content-gen-api:${imageTag}'
    cpu: 2
    memoryInGB: 4
    port: 8000
    // Only pass subnetResourceId when private networking is enabled
    subnetResourceId: enablePrivateNetworking ? virtualNetwork!.outputs.aciSubnetResourceId : ''
    userAssignedIdentityResourceId: userAssignedIdentity.outputs.resourceId
    enableTelemetry: enableTelemetry
    environmentVariables: [
      // Azure OpenAI Settings
      { name: 'AZURE_OPENAI_ENDPOINT', value: 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/' }
      { name: 'AZURE_OPENAI_GPT_MODEL', value: gptModelName }
      { name: 'AZURE_OPENAI_IMAGE_MODEL', value: imageModelConfig[imageModelChoice].name }
      {
        name: 'AZURE_OPENAI_GPT_IMAGE_ENDPOINT'
        value: imageModelChoice != 'none' ? 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/' : ''
      }
      { name: 'AZURE_OPENAI_API_VERSION', value: azureOpenaiAPIVersion }
      // Azure Cosmos DB Settings
      { name: 'AZURE_COSMOS_ENDPOINT', value: 'https://cosmos-${solutionSuffix}.documents.azure.com:443/' }
      { name: 'AZURE_COSMOS_DATABASE_NAME', value: cosmosDBDatabaseName }
      { name: 'AZURE_COSMOS_PRODUCTS_CONTAINER', value: cosmosDBProductsContainer }
      { name: 'AZURE_COSMOS_CONVERSATIONS_CONTAINER', value: cosmosDBConversationsContainer }
      // Azure Blob Storage Settings
      { name: 'AZURE_BLOB_ACCOUNT_NAME', value: storageAccountName }
      { name: 'AZURE_BLOB_PRODUCT_IMAGES_CONTAINER', value: productImagesContainer }
      { name: 'AZURE_BLOB_GENERATED_IMAGES_CONTAINER', value: generatedImagesContainer }
      // Azure AI Search Settings
      { name: 'AZURE_AI_SEARCH_ENDPOINT', value: 'https://${aiSearchName}.search.windows.net' }
      { name: 'AZURE_AI_SEARCH_PRODUCTS_INDEX', value: azureSearchIndex }
      { name: 'AZURE_AI_SEARCH_IMAGE_INDEX', value: 'product-images' }
      // App Settings
      { name: 'AZURE_CLIENT_ID', value: userAssignedIdentity.outputs.clientId }
      { name: 'PORT', value: '8000' }
      { name: 'WORKERS', value: '4' }
      { name: 'RUNNING_IN_PRODUCTION', value: 'true' }
      // Azure AI Foundry Settings
      { name: 'USE_FOUNDRY', value: useFoundryMode ? 'true' : 'false' }
      { name: 'AZURE_AI_PROJECT_ENDPOINT', value: aiFoundryAiProjectEndpoint }
      { name: 'AZURE_AI_MODEL_DEPLOYMENT_NAME', value: gptModelName }
      { name: 'AZURE_AI_IMAGE_MODEL_DEPLOYMENT', value: imageModelConfig[imageModelChoice].name }
    ]
  }
}

// ========== Outputs ========== //
@description('The location the resource was deployed into.')
output location string = solutionLocation

@description('The name of the resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The App Service name.')
output appServiceName string = webSite.outputs.name

@description('The WebApp URL.')
output webAppUrl string = 'https://${webSite.outputs.name}.azurewebsites.net'

@description('The Storage Account name.')
output azureBlobAccountName string = storageAccount.outputs.name

@description('The Product Images Container name.')
output azureBlobProductImagesContainer string = productImagesContainer

@description('The Generated Images Container name.')
output azureBlobGeneratedImagesContainer string = generatedImagesContainer

@description('The CosmosDB Account name.')
output cosmosDbAccountName string = cosmosDB.outputs.name

@description('The CosmosDB Endpoint URL.')
output azureCosmosEndpoint string = 'https://cosmos-${solutionSuffix}.documents.azure.com:443/'

@description('The CosmosDB Database name.')
output azureCosmosDatabaseName string = cosmosDBDatabaseName

@description('The CosmosDB Products Container name.')
output azureCosmosProductsContainer string = cosmosDBProductsContainer

@description('The CosmosDB Conversations Container name.')
output azureCosmosConversationsContainer string = cosmosDBConversationsContainer

@description('The AI Foundry name.')
output aiFoundryName string = aiFoundryAiProjectResourceName

@description('The AI Foundry resource group name.')
output aiFoundryRgName string = aiFoundryAiServicesResourceGroupName

@description('The AI Foundry Resource ID.')
output aiFoundryResourceId string = aiFoundryAiServices.outputs.resourceId

@description('The AI Search Service Endpoint URL.')
output azureAiSearchEndpoint string = 'https://${aiSearch.outputs.name}.search.windows.net/'

@description('The AI Search Service name.')
output aiSearchServiceName string = aiSearch.outputs.name

@description('The AI Search Product Index name.')
output azureAiSearchProductsIndex string = azureSearchIndex

@description('The AI Search Image Index name.')
output azureAiSearchImageIndex string = 'product-images'

@description('The Azure OpenAI endpoint URL.')
output azureOpenaiEndpoint string = 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'

@description('The GPT Model name.')
output azureOpenaiGptModel string = gptModelName

@description('The Image Model name (empty if none selected).')
output azureOpenaiImageModel string = imageModelConfig[imageModelChoice].name

@description('The Azure OpenAI GPT/Image endpoint URL (empty if no image model selected).')
output azureOpenaiGptImageEndpoint string = imageModelChoice != 'none'
  ? 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'
  : ''

@description('The Azure OpenAI API Version.')
output azureOpenaiApiVersion string = azureOpenaiAPIVersion

@description('The OpenAI Resource name.')
output azureOpenaiResource string = aiFoundryAiServicesResourceName

@description('The AI Agent Endpoint URL.')
output azureAiAgentEndpoint string = aiFoundryAiProjectEndpoint

@description('The AI Agent API Version.')
output azureAiAgentApiVersion string = azureAiAgentApiVersion

@description('The Application Insights Connection String.')
output azureApplicationInsightsConnectionString string = enableMonitoring
  ? applicationInsights!.outputs.connectionString
  : ''

@description('The location used for AI Services deployment.')
output azureEnvOpenaiLocation string = azureAiServiceLocation

@description('The Container Instance name.')
output containerInstanceName string = containerInstance.outputs.name

@description('The Container Instance IP Address.')
output containerInstanceIp string = containerInstance.outputs.ipAddress

@description('The Container Instance FQDN (only for non-private networking).')
output containerInstanceFqdn string = enablePrivateNetworking ? '' : containerInstance.outputs.fqdn

@description('The ACR name.')
output acrName string = acrResourceName

@description('The flag for Azure AI Foundry usage.')
output useFoundry bool = useFoundryMode ? true : false

@description('The Azure AI Project Endpoint URL.')
output azureAiProjectEndpoint string = aiFoundryAiProjectEndpoint

@description('The Azure AI Model Deployment name.')
output azureAiModelDeploymentName string = gptModelName

@description('The Azure AI Image Model Deployment name (empty if none selected).')
output azureAiImageModelDeployment string = imageModelConfig[imageModelChoice].name
