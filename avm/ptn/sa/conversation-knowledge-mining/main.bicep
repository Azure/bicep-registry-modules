// ============================================================================
// main.bicep — Orchestrator
// Description: Pure orchestrator for Conversation Knowledge Mining solution. Calls modules to deploy resources.
//              All resource names are derived from params — no hardcoded names.
//              This file only calls modules; no inline resource definitions.
//              Supports WAF-aligned deployment via feature flags.
// ============================================================================
targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = '''This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/blob/main/documents/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ============================================================================
// Parameters — Core
// ============================================================================

@minLength(3)
@maxLength(16)
@description('Optional. A unique application/solution name used as base for all resource naming.')
param solutionName string = 'kmgen'

@maxLength(5)
@description('Optional. A unique text suffix appended to resource names for uniqueness.')
param solutionUniqueText string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

@metadata({ azd: { type: 'location' } })
@description('Optional. Primary Azure region for resource deployment.')
param location string = resourceGroup().location

@allowed(['australiaeast', 'swedencentral', 'southeastasia'])
@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-4.1-mini,10'
      'OpenAI.GlobalStandard.text-embedding-3-small,10'
    ]
  }
})
@description('Required. Location for AI Foundry and model deployments.')
param azureAiServiceLocation string

// ============================================================================
// Parameters — WAF Feature Flags
// ============================================================================

@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for AVM modules.')
param enableTelemetry bool = true

@description('Optional. Enable monitoring for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enablePrivateNetworking bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

// ============================================================================
// Parameters — VM (applicable when enablePrivateNetworking = true)
// ============================================================================

@secure()
@description('Optional. The user name for the administrator account of the virtual machine. Required by Azure at provisioning time but not used for login when Entra ID is enabled.')
param vmAdminUsername string?

@secure()
@description('Optional. The password for the administrator account of the virtual machine. Auto-generated if not provided. Not used for login when Entra ID is enabled.')
param vmAdminPassword string?

@description('Optional. The size of the virtual machine. Defaults to Standard_D2s_v5.')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. Set to true to also deploy Cosmos DB (not required — SQL is the primary database).')
param deployCosmos bool = false

// ============================================================================
// Parameters — AI Configuration
// ============================================================================

@allowed(['Standard', 'GlobalStandard'])
@description('Optional. GPT model deployment type.')
param deploymentType string = 'GlobalStandard'

@description('Optional. Name of the GPT model to deploy.')
param gptModelName string = 'gpt-4.1-mini'

@description('Optional. Version of the GPT model to deploy.')
param gptModelVersion string = '2025-04-14'

@minValue(10)
@description('Optional. Capacity of the GPT deployment (TPM in thousands).')
param gptDeploymentCapacity int = 10

@description('Optional. Name of the embedding model to deploy.')
@allowed(['text-embedding-3-small'])
param embeddingModel string = 'text-embedding-3-small'

@minValue(10)
@description('Optional. Capacity of the embedding model deployment.')
param embeddingDeploymentCapacity int = 10

// ============================================================================
// Parameters — Compute
// ============================================================================

@description('Optional. Name of the Azure Container Registry. Leave empty to auto-generate a globally unique name (cr<suffix>).')
param containerRegistryName string = ''

@description('Optional. Backend container image name.')
param backendContainerImageName string = 'km-api'

@description('Optional. Backend container image tag.')
param backendContainerImageTag string = 'latest'

@description('Optional. Frontend container image name.')
param frontendContainerImageName string = 'km-app'

@description('Optional. Frontend container image tag.')
param frontendContainerImageTag string = 'latest'

@allowed(['F1', 'D1', 'B1', 'B2', 'B3', 'S1', 'S2', 'S3', 'P1', 'P2', 'P3', 'P1v3', 'P1v4'])
@description('Optional. App Service Plan SKU.')
param appServicePlanSku string = 'B3'

@description('Optional. Kind of web app.')
param kind string = 'app,linux,container'

// ============================================================================
// Parameters — Authentication (matches infra_old/main.bicep)
// ============================================================================

@description('Optional. Azure AD tenant ID for authentication.')
param azureAdTenantId string = ''

@description('Optional. Azure AD client ID for authentication.')
param azureAdClientId string = ''

@description('Optional. Admin API key for script-based authentication (setup-data, post-deploy scripts). Leave empty to disable.')
@secure()
param adminApiKey string = ''

// ============================================================================
// Parameters — Existing Resources
// ============================================================================

@description('Optional. Resource ID of an existing Log Analytics workspace (empty = create new).')
param existingLogAnalyticsWorkspaceId string = ''

@description('Optional. Resource ID of an existing AI Foundry project (empty = create new).')
param existingFoundryProjectResourceId string = ''

// ============================================================================
// Parameters — Identity
// ============================================================================

@allowed(['User', 'ServicePrincipal'])
@description('Optional. Principal type of the deploying user.')
param deployingUserPrincipalType string = 'User'

// ============================================================================
// Variables
// ============================================================================

var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueText}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))
// ACR names are globally unique — default to a suffixed name so multiple deployments don't collide.
var containerRegistryResourceName = !empty(containerRegistryName) ? containerRegistryName : 'acrkm${solutionSuffix}'
var deployerInfo = deployer()
var deployingUserPrincipalId = deployerInfo.objectId
var createdBy = contains(deployerInfo, 'userPrincipalName')
  ? split(deployerInfo.userPrincipalName, '@')[0]
  : deployerInfo.objectId
var useExistingAIProject = !empty(existingFoundryProjectResourceId)

// ========== Tags: merge caller-supplied tags with standard metadata (matching old infra) ========== //
var existingTags = resourceGroup().tags ?? {}
var resourceTags = union(existingTags, tags, {
  TemplateName: 'KM-Generic'
  CreatedBy: createdBy
  DeploymentName: deployment().name
  Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
  SecurityControl: 'Ignore'
})

// ========== WAF: Region pairs for redundancy (Log Analytics replication) ========== //
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
  westeurope: 'northeurope'
}
var replicaLocation = replicaRegionPairs[location]

// ========== WAF: Region pairs for Cosmos DB zone-redundant HA ========== //
var cosmosDbHaRegionPairs = {
  australiaeast: 'uksouth' //'southeastasia'
  centralus: 'eastus2'
  eastasia: 'southeastasia'
  eastus: 'centralus'
  eastus2: 'centralus'
  japaneast: 'australiaeast'
  northeurope: 'westeurope'
  southeastasia: 'eastasia'
  uksouth: 'westeurope'
  westeurope: 'northeurope'
}
var cosmosDbHaLocation = cosmosDbHaRegionPairs[location]

// ========== WAF: Diagnostic settings helper — reused across modules ========== //
var monitoringDiagnosticSettings = enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : []

// ========== WAF: Private DNS zones for private endpoints ========== //
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.dfs.${environment().suffixes.storage}'
  'privatelink.documents.azure.com'
  'privatelink${environment().suffixes.sqlServerHostname}'
  'privatelink.search.windows.net'
  'privatelink.azurewebsites.net'
  'privatelink.azurecr.io'
]
var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  storageBlob: 3
  storageQueue: 4
  storageFile: 5
  storageDfs: 6
  cosmosDB: 7
  sqlServer: 8
  search: 9
  webApp: 10
  containerRegistry: 11
}

// ========== Model deployments configuration ========== //
var aiModelDeployments = [
  {
    name: gptModelName
    model: gptModelName
    sku: { name: deploymentType, capacity: gptDeploymentCapacity }
    version: gptModelVersion
    raiPolicyName: 'Microsoft.Default'
  }
  {
    name: embeddingModel
    model: embeddingModel
    sku: { name: 'GlobalStandard', capacity: embeddingDeploymentCapacity }
    version: '1'
    raiPolicyName: 'Microsoft.Default'
  }
]

// ============================================================================
// Resource Group Tags (matching old infra)
// ============================================================================

resource resourceGroupTags 'Microsoft.Resources/tags@2024-11-01' = {
  name: 'default'
  properties: {
    tags: resourceTags
  }
}

// ============================================================================
// Module: Monitoring
// ============================================================================

var useExistingLogAnalytics = !empty(existingLogAnalyticsWorkspaceId)

// Existing workspace reference (for cross-subscription support)
resource existingLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = if (useExistingLogAnalytics) {
  name: split(existingLogAnalyticsWorkspaceId, '/')[8]
  scope: resourceGroup(split(existingLogAnalyticsWorkspaceId, '/')[2], split(existingLogAnalyticsWorkspaceId, '/')[4])
}

//  ========== Log Analytics Workspace module ========== //
module log_analytics './modules/monitoring/log-analytics.bicep' = if (enableMonitoring && !useExistingLogAnalytics) {
  name: take('module.log-analytics.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    enableReplication: enableRedundancy
    replicationLocation: enableRedundancy ? replicaLocation : ''
    dailyQuotaGb: enableRedundancy ? '150' : ''
    dataSources: enablePrivateNetworking
      ? [
          {
            tags: tags
            eventLogName: 'Application'
            eventTypes: [{ eventType: 'Error' }, { eventType: 'Warning' }, { eventType: 'Information' }]
            kind: 'WindowsEvent'
            name: 'applicationEvent'
          }
          {
            counterName: '% Processor Time'
            instanceName: '*'
            intervalSeconds: 60
            kind: 'WindowsPerformanceCounter'
            name: 'windowsPerfCounter1'
            objectName: 'Processor'
          }
        ]
      : []
  }
}

// ========== Resolve workspace resource ID and name — existing or new ========== //
var logAnalyticsWorkspaceResourceId = useExistingLogAnalytics
  ? existingLogAnalyticsWorkspace.id
  : (enableMonitoring ? log_analytics!.outputs.resourceId : '')
var logAnalyticsWorkspaceName = useExistingLogAnalytics
  ? split(existingLogAnalyticsWorkspaceId, '/')[8]
  : (enableMonitoring ? log_analytics!.outputs.name : '')

// ========== App Insights module ========== //
module app_insights './modules/monitoring/app-insights.bicep' = if (enableMonitoring) {
  name: take('module.app-insights.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    workspaceResourceId: logAnalyticsWorkspaceResourceId
    retentionInDays: 365
    disableIpMasking: false
  }
}

// ============================================================================
// Module: Networking (WAF — conditional on enablePrivateNetworking)
// ============================================================================

module virtualNetwork './modules/networking/virtual-network.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtual-network.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/20'] // 4096 addresses (enough for 8 /23 subnets or 16 /24)
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    resourceSuffix: solutionSuffix
  }
}

// ========== Bastion Host — secure access to jumpbox VM ========== //
module bastionHost './modules/networking/bastion-host.bicep' = if (enablePrivateNetworking) {
  name: take('module.bastion-host.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
    publicIPDiagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
  }
}

// ========== WAF: Maintenance Configuration for VM patching ========== //
module maintenanceConfiguration './modules/compute/maintenance-configuration.bicep' = if (enablePrivateNetworking) {
  name: take('module.maintenance-configuration.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== WAF: Data Collection Rules for VM monitoring ========== //
var dataCollectionRulesLocation = useExistingLogAnalytics
  ? existingLogAnalyticsWorkspace!.location
  : (enableMonitoring ? log_analytics!.outputs.location : location)
module windowsVmDataCollectionRules './modules/monitoring/data-collection-rule.bicep' = if (enablePrivateNetworking && enableMonitoring) {
  name: take('module.data-collection-rule.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: dataCollectionRulesLocation
    tags: tags
    enableTelemetry: enableTelemetry
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
  }
}

// ========== WAF: Proximity Placement Group for VM ========== //
var virtualMachineAvailabilityZone = 1
module proximityPlacementGroup './modules/compute/proximity-placement-group.bicep' = if (enablePrivateNetworking) {
  name: take('module.proximity-placement-group.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    availabilityZone: virtualMachineAvailabilityZone
    vmSizes: [vmSize]
  }
}

// ========== Jumpbox VM — administration access when private networking is enabled ========== //
// ========== Login is via Microsoft Entra ID through Azure Bastion (not local credentials) ========== //
module virtualMachine './modules/compute/virtual-machine.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtual-machine.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmSize: vmSize
    availabilityZone: virtualMachineAvailabilityZone
    adminUsername: vmAdminUsername ?? 'testvmuser'
    adminPassword: vmAdminPassword ?? 'Vm!${uniqueString(subscription().subscriptionId, solutionName)}${guid(subscription().subscriptionId, solutionName, 'vm-admin-password')}'
    subnetResourceId: virtualNetwork!.outputs.administrationSubnetResourceId
    deployingUserPrincipalId: deployingUserPrincipalId
    deployingUserPrincipalType: deployingUserPrincipalType
    roleAssignments: [
      {
        roleDefinitionIdOrName: '1c0163c0-47e6-4577-8991-ea5c82e286e4' // Virtual Machine Administrator Login
        principalId: deployingUserPrincipalId
        principalType: deployingUserPrincipalType
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    maintenanceConfigurationResourceId: maintenanceConfiguration!.outputs.resourceId
    proximityPlacementGroupResourceId: proximityPlacementGroup!.outputs.resourceId
    extensionMonitoringAgentConfig: enableMonitoring
      ? {
          dataCollectionRuleAssociations: [
            {
              dataCollectionRuleResourceId: windowsVmDataCollectionRules!.outputs.resourceId
              name: 'send-${logAnalyticsWorkspaceName}'
            }
          ]
          enabled: true
          tags: tags
        }
      : null
  }
}

// ========== Private DNS Zones — one per service, linked to VNet ========== //
@batchSize(5)
module privateDnsZoneDeployments './modules/networking/private-dns-zone.bicep' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: take('module.private-dns-zone.${split(zone, '.')[1]}.${solutionName}', 64)
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetwork!.outputs.name}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
        }
      ]
    }
  }
]

// ============================================================================
// Module: AI Services (conditional — skip if using existing project)
// ============================================================================

// ========== Existing AI Foundry reference (for cross-subscription support when using existing project) ========== //
var aiFoundryResourceGroupName = useExistingAIProject
  ? split(existingFoundryProjectResourceId, '/')[4]
  : resourceGroup().name
var aiFoundrySubscriptionId = useExistingAIProject
  ? split(existingFoundryProjectResourceId, '/')[2]
  : subscription().subscriptionId
var aiFoundryResourceName = useExistingAIProject
  ? split(existingFoundryProjectResourceId, '/')[8]
  : ai_foundry_project!.outputs.name
var aiProjectResourceName = useExistingAIProject
  ? (length(split(existingFoundryProjectResourceId, '/')) > 10 ? split(existingFoundryProjectResourceId, '/')[10] : '')
  : ai_foundry_project!.outputs.projectName

// ========== Reference existing AI Foundry project (identity only) ========== //
module existing_project_setup './modules/ai/existing-project-setup.bicep' = if (useExistingAIProject) {
  name: take('module.existing-project-setup.${solutionName}', 64)
  scope: resourceGroup(aiFoundrySubscriptionId, aiFoundryResourceGroupName)
  params: {
    name: aiFoundryResourceName
    projectName: aiProjectResourceName
  }
}

// ========== Deploy new AI Services account + AI Foundry project (no connections, no deployments) ========== //
module ai_foundry_project './modules/ai/ai-foundry-project.bicep' = if (!useExistingAIProject) {
  name: take('module.ai-foundry-project.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: azureAiServiceLocation
    tags: tags
    enableTelemetry: enableTelemetry
    // Temporarily public — AI Search Knowledge Base needs to call the AI Services model endpoint for answer synthesis.
    publicNetworkAccess: 'Enabled'
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'a97b65f3-24c7-4388-baec-2e87135dc908' // Cognitive Services User
        principalId: deployingUserPrincipalId
        principalType: deployingUserPrincipalType
      }
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Foundry User
        principalId: deployingUserPrincipalId
        principalType: deployingUserPrincipalType
      }
    ]
  }
}

// ========== AI outputs (ternary: existing vs new) ========== //
var aiFoundryEndpoint = useExistingAIProject
  ? existing_project_setup!.outputs.endpoint
  : ai_foundry_project!.outputs.endpoint
var azureOpenAiCuEndpoint = useExistingAIProject
  ? existing_project_setup!.outputs.azureOpenAiCuEndpoint
  : ai_foundry_project!.outputs.azureOpenAiCuEndpoint
var projectEndpoint = useExistingAIProject
  ? existing_project_setup!.outputs.projectEndpoint
  : ai_foundry_project!.outputs.projectEndpoint
var aiFoundryResourceId = useExistingAIProject
  ? existing_project_setup!.outputs.resourceId
  : ai_foundry_project!.outputs.resourceId
var aiProjectPrincipalId = useExistingAIProject
  ? existing_project_setup!.outputs.projectIdentityPrincipalId
  : ai_foundry_project!.outputs.projectIdentityPrincipalId

// ========== AI Search connection (single call for both existing and new paths) ========== //
module foundry_search_connection './modules/ai/ai-foundry-connection.bicep' = {
  name: take('module.foundry-search-conn.${solutionName}', 64)
  scope: resourceGroup(aiFoundrySubscriptionId, aiFoundryResourceGroupName)
  params: {
    solutionName: solutionSuffix
    aiServicesAccountName: aiFoundryResourceName
    projectName: aiProjectResourceName
    category: 'CognitiveSearch'
    target: ai_search!.outputs.endpoint
    authType: 'AAD'
    metadata: {
      ApiType: 'Azure'
      ResourceId: ai_search!.outputs.resourceId
    }
  }
}

// ========== Model deployments (single loop for both existing and new paths) ========== //
@batchSize(1)
module model_deployments './modules/ai/ai-foundry-model-deployment.bicep' = [
  for (deployment, i) in aiModelDeployments: {
    name: take('module.model-deployment-${i}.${solutionName}', 64)
    scope: resourceGroup(aiFoundrySubscriptionId, aiFoundryResourceGroupName)
    params: {
      aiServicesAccountName: aiFoundryResourceName
      deploymentName: deployment.name
      modelName: deployment.model
      modelVersion: deployment.version
      raiPolicyName: deployment.raiPolicyName
      skuName: deployment.sku.name
      skuCapacity: deployment.sku.capacity
    }
  }
]

// ========== Separate PE for AI Foundry to avoid AccountProvisioningStateInvalid race condition ========== //
module aifoundry_private_endpoint './modules/networking/private-endpoint.bicep' = if (!useExistingAIProject && enablePrivateNetworking) {
  name: take('module.pe-ai-foundry.${solutionName}', 64)
  dependsOn: [model_deployments, foundry_search_connection, privateDnsZoneDeployments]
  params: {
    name: 'pep-aif-${solutionSuffix}'
    location: location
    tags: tags
    subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
    customNetworkInterfaceName: 'nic-aif-${solutionSuffix}'
    privateLinkServiceConnections: [
      {
        name: 'pep-aif-${solutionSuffix}-connection'
        properties: {
          privateLinkServiceId: ai_foundry_project!.outputs.resourceId
          groupIds: ['account']
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'ai-services-dns-zone-cognitiveservices'
          privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
        }
        {
          name: 'ai-services-dns-zone-openai'
          privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.openAI]!.outputs.resourceId
        }
        {
          name: 'ai-services-dns-zone-aiservices'
          privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.aiServices]!.outputs.resourceId
        }
      ]
    }
  }
}

// ========== AI Search service (called by Foundry connection module, so deployed after the project) ========== //
module ai_search './modules/ai/ai-search.bicep' = {
  name: take('module.ai-search.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    skuName: 'standard'
    tags: tags
    enableTelemetry: enableTelemetry
    // Temporarily public — Foundry Agent runtime runs outside the VNET and cannot resolve private DNS for AI Search.
    publicNetworkAccess: 'Enabled'
    diagnosticSettings: monitoringDiagnosticSettings
    roleAssignments: [
      {
        roleDefinitionIdOrName: '8ebe5a00-799e-43f5-93ac-243d3dce84a7' // Search Index Data Contributor
        principalId: deployingUserPrincipalId
        principalType: deployingUserPrincipalType
      }
      {
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0' // Search Service Contributor
        principalId: deployingUserPrincipalId
        principalType: deployingUserPrincipalType
      }
    ]
    // Temporarily no private endpoint — Foundry Agent cannot resolve private DNS for AI Search.
    privateEndpoints: []
  }
}

// ============================================================================
// Module: Data
// ============================================================================

module storage_account './modules/data/storage-account.bicep' = {
  name: take('module.storage-account.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableHierarchicalNamespace: true
    enableTelemetry: enableTelemetry
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    diagnosticSettings: monitoringDiagnosticSettings
    containers: [
      { name: 'data', publicAccess: 'None' }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Contributor
        principalId: deployingUserPrincipalId
        principalType: deployingUserPrincipalType
      }
    ]
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-blob-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-blob-${solutionSuffix}'
            service: 'blob'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.storageBlob]!.outputs.resourceId }
              ]
            }
          }
          {
            name: 'pep-queue-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-queue-${solutionSuffix}'
            service: 'queue'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.storageQueue]!.outputs.resourceId }
              ]
            }
          }
          {
            name: 'pep-file-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-file-${solutionSuffix}'
            service: 'file'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.storageFile]!.outputs.resourceId }
              ]
            }
          }
          {
            name: 'pep-dfs-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-dfs-${solutionSuffix}'
            service: 'dfs'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.storageDfs]!.outputs.resourceId }
              ]
            }
          }
        ]
      : []
    networkAcls: {
      bypass: 'AzureServices, Logging, Metrics'
      defaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
      virtualNetworkRules: []
    }
  }
}

// ========== Cosmos DB module (optional — not required, SQL is the primary database) ========== //
module cosmosDBModule './modules/data/cosmos-db-nosql.bicep' = if (deployCosmos) {
  name: take('module.cosmos-db-nosql.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    databaseName: 'km-db'
    containers: [
      { name: 'chat_sessions', partitionKeyPath: '/user_id' }
      { name: 'chat_messages', partitionKeyPath: '/session_id' }
      { name: 'document_insights', partitionKeyPath: '/dataset_id' }
      { name: 'enrichment_cache', partitionKeyPath: '/doc_hash' }
    ]
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    diagnosticSettings: monitoringDiagnosticSettings
    zoneRedundant: enableRedundancy
    enableAutomaticFailover: enableRedundancy
    haLocation: cosmosDbHaLocation
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-cosmos-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-cosmos-${solutionSuffix}'
            service: 'Sql'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.cosmosDB]!.outputs.resourceId }
              ]
            }
          }
        ]
      : []
  }
}

// ========== SQL Database module ========== //
module sqlDBModule './modules/data/sql-database.bicep' = {
  name: take('module.sql-db.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    name: 'sql-${solutionSuffix}'
    databaseName: 'sqldb-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    deployerPrincipalId: deployingUserPrincipalId
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-sql-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-sql-${solutionSuffix}'
            service: 'sqlServer'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.sqlServer]!.outputs.resourceId }
              ]
            }
          }
        ]
      : []
  }
}

// ============================================================================
// Module: Compute
// ============================================================================

module hostingplan './modules/compute/app-service-plan.bicep' = {
  name: take('module.app-service-plan.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    skuName: (enableScalability || enableRedundancy) ? 'P1v3' : appServicePlanSku
    skuCapacity: enableScalability ? 3 : 1
    zoneRedundant: enableRedundancy
    diagnosticSettings: monitoringDiagnosticSettings
  }
}

// ========== Container Registry module (dedicated ACR for application images) ========== //
module container_registry './modules/compute/container-registry.bicep' = {
  name: take('module.container-registry.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    name: containerRegistryResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    sku: enablePrivateNetworking ? 'Premium' : 'Standard'
    // App Services pull images with their system-assigned managed identity (AcrPull granted in
    // the role-assignments module). Grant the deployer AcrPush so the post-provision build/push
    // step needs no manual RBAC.
    adminUserEnabled: false
    acrPushPrincipalIds: [deployingUserPrincipalId]
    acrPushPrincipalType: deployingUserPrincipalType == 'User' ? 'User' : 'ServicePrincipal'
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    networkRuleSetDefaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${containerRegistryResourceName}'
            customNetworkInterfaceName: 'nic-${containerRegistryResourceName}'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            service: 'registry'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.containerRegistry]!.outputs.resourceId
                }
              ]
            }
          }
        ]
      : []
  }
}

var placeholderImageName = 'DOCKER|mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

// ========== Backend Deployment ========== //
module backend_docker './modules/compute/app-service.bicep' = {
  name: take('module.app-service-backend.${solutionName}', 64)
  params: {
    solutionName: 'api-${solutionSuffix}'
    location: location
    tags: union(tags, { 'azd-service-name': 'api' })
    enableTelemetry: enableTelemetry
    serverFarmResourceId: hostingplan!.outputs.resourceId
    kind: kind
    linuxFxVersion: placeholderImageName
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webserverfarmSubnetResourceId : ''
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    imagePullTraffic: enablePrivateNetworking ? true : false
    contentShareTraffic: enablePrivateNetworking ? true : false
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-api-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-api-${solutionSuffix}'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            service: 'sites'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                { privateDnsZoneResourceId: privateDnsZoneDeployments[dnsZoneIndex.webApp]!.outputs.resourceId }
              ]
            }
          }
        ]
      : []
    diagnosticSettings: monitoringDiagnosticSettings
    managedIdentities: { systemAssigned: true }
    acrUseManagedIdentityCreds: true
    appSettings: {
      WEBSITES_PORT: '8000'
      AZURE_OPENAI_ENDPOINT: aiFoundryEndpoint
      AZURE_OPENAI_CHAT_DEPLOYMENT: gptModelName
      AZURE_OPENAI_EMBEDDING_DEPLOYMENT: embeddingModel
      AZURE_SEARCH_ENDPOINT: ai_search.outputs.endpoint
      AZURE_SEARCH_INDEX_NAME: 'knowledge-mining-index'
      AZURE_CONTENT_UNDERSTANDING_ENDPOINT: azureOpenAiCuEndpoint
      AZURE_STORAGE_ACCOUNT: storage_account.outputs.name
      AZURE_SQL_SERVER: sqlDBModule!.outputs.serverFqdn
      AZURE_SQL_DATABASE: sqlDBModule!.outputs.databaseName
      AZURE_COSMOS_ENDPOINT: deployCosmos ? cosmosDBModule!.outputs.endpoint : ''
      AZURE_COSMOS_DATABASE: deployCosmos ? 'km-db' : ''
      AZURE_AD_TENANT_ID: azureAdTenantId
      AZURE_AD_CLIENT_ID: azureAdClientId
      AZURE_AI_AGENT_ENDPOINT: projectEndpoint
      AZURE_AI_SEARCH_CONNECTION_NAME: foundry_search_connection.outputs.connectionName
      API_APP_NAME: 'api-${solutionSuffix}'
      APP_FRONTEND_HOSTNAME: 'https://app-${solutionSuffix}.azurewebsites.net'
      APP_ENV: 'Prod'
      ADMIN_API_KEY: adminApiKey
      SOLUTION_SUFFIX: solutionSuffix
      APPLICATIONINSIGHTS_CONNECTION_STRING: enableMonitoring ? app_insights!.outputs.connectionString : ''
    }
  }
}

// Frontend
module frontend_docker './modules/compute/app-service.bicep' = {
  name: take('module.app-service-frontend.${solutionName}', 64)
  params: {
    solutionName: 'app-${solutionSuffix}'
    location: location
    tags: union(tags, { 'azd-service-name': 'webapp' })
    enableTelemetry: enableTelemetry
    serverFarmResourceId: hostingplan!.outputs.resourceId
    kind: kind
    linuxFxVersion: placeholderImageName
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    imagePullTraffic: enablePrivateNetworking ? true : false
    contentShareTraffic: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webserverfarmSubnetResourceId : ''
    publicNetworkAccess: 'Enabled'
    diagnosticSettings: monitoringDiagnosticSettings
    managedIdentities: { systemAssigned: true }
    acrUseManagedIdentityCreds: true
    appSettings: {
      WEBSITES_PORT: '80'
      APPLICATIONINSIGHTS_CONNECTION_STRING: enableMonitoring ? app_insights!.outputs.connectionString : ''
      APP_API_BASE_URL: enablePrivateNetworking ? '' : 'https://api-${solutionSuffix}.azurewebsites.net'
      BACKEND_API_HOST: enablePrivateNetworking ? 'api-${solutionSuffix}.azurewebsites.net' : ''
    }
  }
}

// ============================================================================
// Module: Role Assignments (centralized)
// ============================================================================

module role_assignments './modules/identity/role-assignments.bicep' = {
  name: take('module.role-assignments.${solutionName}', 64)
  params: {
    solutionName: solutionSuffix
    useExistingAIProject: useExistingAIProject
    existingFoundryProjectResourceId: existingFoundryProjectResourceId
    aiFoundryResourceId: !useExistingAIProject ? aiFoundryResourceId : ''
    aiSearchResourceId: ai_search.outputs.resourceId
    storageAccountResourceId: storage_account.outputs.resourceId
    aiProjectPrincipalId: aiProjectPrincipalId
    aiSearchPrincipalId: ai_search.outputs.identityPrincipalId
    backendAppServicePrincipalId: backend_docker!.outputs.identityPrincipalId
    cosmosDbAccountName: deployCosmos ? cosmosDBModule!.outputs.name : ''
    containerRegistryResourceId: container_registry.outputs.resourceId
    acrPullPrincipals: [
      { principalId: backend_docker!.outputs.identityPrincipalId, principalType: 'ServicePrincipal' }
      { principalId: frontend_docker!.outputs.identityPrincipalId, principalType: 'ServicePrincipal' }
    ]
  }
}

// ============================================================================
// Outputs (matches infra_old/main.bicep output list)
// ============================================================================

@description('Azure OpenAI endpoint URL.')
output AZURE_OPENAI_ENDPOINT string = aiFoundryEndpoint

@description('Azure AI Search endpoint URL.')
output AZURE_SEARCH_ENDPOINT string = ai_search.outputs.endpoint

@description('Azure Content Understanding endpoint URL.')
output AZURE_CONTENT_UNDERSTANDING_ENDPOINT string = azureOpenAiCuEndpoint

@description('Azure Storage account name.')
output AZURE_STORAGE_ACCOUNT string = storage_account.outputs.name

@description('Azure SQL Server FQDN.')
output AZURE_SQL_SERVER string = sqlDBModule!.outputs.serverFqdn

@description('Azure SQL Database name.')
output AZURE_SQL_DATABASE string = sqlDBModule!.outputs.databaseName

@description('Backend API application (and SQL contained user) name.')
output API_APP_NAME string = backend_docker!.outputs.name

@description('Backend API system-assigned managed identity principal ID.')
output AZURE_API_PRINCIPAL_ID string = backend_docker!.outputs.identityPrincipalId

@description('Azure Cosmos DB endpoint.')
output AZURE_COSMOS_ENDPOINT string = deployCosmos ? cosmosDBModule!.outputs.endpoint : ''

@description('Azure AI Agent endpoint URL.')
output AZURE_AI_AGENT_ENDPOINT string = projectEndpoint

@description('Backend API application URL.')
output API_APP_URL string = backend_docker!.outputs.appUrl

@description('Frontend web application URL.')
output WEB_APP_URL string = frontend_docker!.outputs.appUrl

@description('Backend service URI (used by azd).')
output SERVICE_BACKEND_URI string = backend_docker!.outputs.appUrl

@description('Frontend service URI (used by azd).')
output SERVICE_FRONTEND_URI string = frontend_docker!.outputs.appUrl

@description('AI Search connection name in AI Foundry.')
output AZURE_AI_SEARCH_CONNECTION_NAME string = foundry_search_connection.outputs.connectionName

@description('Azure Container Registry name.')
output ACR_NAME string = container_registry.outputs.name

@description('Azure Container Registry login server URL.')
output ACR_LOGIN_SERVER string = container_registry.outputs.loginServer

@description('Backend container image repository name to build and push to ACR.')
output BACKEND_CONTAINER_IMAGE_NAME string = backendContainerImageName

@description('Backend container image tag to build and push to ACR.')
output BACKEND_CONTAINER_IMAGE_TAG string = backendContainerImageTag

@description('Frontend container image repository name to build and push to ACR.')
output FRONTEND_CONTAINER_IMAGE_NAME string = frontendContainerImageName

@description('Frontend container image tag to build and push to ACR.')
output FRONTEND_CONTAINER_IMAGE_TAG string = frontendContainerImageTag

@description('Frontend web application (App Service) name.')
output FRONTEND_APP_NAME string = frontend_docker!.outputs.name

@description('Resource group name.')
output RESOURCE_GROUP_NAME string = resourceGroup().name

@description('Solution resource token suffix used in resource names.')
output SOLUTION_SUFFIX string = solutionSuffix
