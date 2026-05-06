// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Container Migration Solution Accelerator'
metadata description = '''This module contains the resources required to deploy the [Container Migration Solution Accelerator](https://github.com/microsoft/Container-Migration-Solution-Accelerator) for both Sandbox environments and WAF aligned environments.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Container-Migration-Solution-Accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ============== //
// Parameters     //
// ============== //
@minLength(3)
@maxLength(16)
@description('Required. A unique application/solution name for all resources in this deployment. This should be 3-16 characters long.')
param solutionName string

@maxLength(5)
@description('Optional. A unique text/token for the solution. Used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name and solution name.')
param solutionUniqueText string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

@minLength(3)
@metadata({ azd: { type: 'location' } })
@description('Optional. Azure region for container apps, storage and other services. Choose a region close to your users. Defaults to the resource group location.')
param location string = resourceGroup().location

@minLength(1)
@allowed([
  'australiaeast'
  'eastus'
  'eastus2'
  'francecentral'
  'japaneast'
  'norwayeast'
  'southindia'
  'swedencentral'
  'uksouth'
  'westus'
  'westus3'
])
@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-5.1, 500'
    ]
  }
})
@description('Required. Azure region for AI services (OpenAI/AI Foundry). Must be a region that supports the gpt-5.1 model deployment.')
param azureAiServiceLocation string

@description('Optional. The host (excluding https://) of an existing container registry. This is the loginServer when using Azure Container Registry.')
param containerRegistryHost string = 'containermigrationacr.azurecr.io'

@description('Optional. The image tag to use for container images. Defaults to "latest_v2".')
param imageTag string = 'latest_v2'

@minLength(1)
@allowed(['Standard', 'GlobalStandard'])
@description('Optional. AI model deployment type. Defaults to GlobalStandard.')
param aiDeploymentType string = 'GlobalStandard'

@minLength(1)
@description('Optional. Name of the AI model to deploy. Recommend using gpt-5.1. Defaults to gpt-5.1.')
param aiModelName string = 'gpt-5.1'

@minLength(1)
@description('Optional. Version of AI model. Review available version numbers per model before setting. Defaults to 2025-11-13.')
param aiModelVersion string = '2025-11-13'

@minValue(1)
@description('Optional. AI model deployment token capacity. Lower this if initial provisioning fails due to capacity. Defaults to 500.')
param aiModelCapacity int = 500

@minLength(1)
@description('Optional. Name of the embedding model to deploy. Defaults to text-embedding-3-large.')
param aiEmbeddingModelName string = 'text-embedding-3-large'

@minLength(1)
@description('Optional. Version of the embedding model. Defaults to 1.')
param aiEmbeddingModelVersion string = '1'

@minLength(1)
@allowed(['Standard', 'GlobalStandard'])
@description('Optional. Embedding model deployment type. Defaults to GlobalStandard.')
param aiEmbeddingDeploymentType string = 'GlobalStandard'

@minValue(1)
@description('Optional. Embedding model deployment token capacity. Defaults to 500.')
param aiEmbeddingModelCapacity int = 500

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enablePrivateNetworking bool = false

@description('Optional. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

#disable-next-line no-hardcoded-location
@description('Optional. Azure region used for the Cosmos DB account. Defaults to eastus2.')
param cosmosLocation string = 'eastus2'

@description('Optional. Resource ID of an existing Log Analytics workspace to reuse. When empty, a new workspace is created if monitoring or private networking is enabled.')
param existingLogAnalyticsWorkspaceId string = ''

@description('Optional. Override for the CreatedBy tag. If not provided, will auto-detect from deployment context.')
param createdBy string = ''

@description('Optional. Resource ID of an existing AI Foundry project. When provided, the pattern reuses the parent Cognitive Services account instead of creating a new one.')
param existingFoundryProjectResourceId string = ''

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to a custom value when enablePrivateNetworking is true.')
@secure()
param vmAdminUsername string?

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to a custom value when enablePrivateNetworking is true.')
@secure()
param vmAdminPassword string?

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to a custom value when enablePrivateNetworking is true.')
param vmSize string?

// ============== //
// Variables      //
// ============== //
var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueText}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))

var allTags = union(
  {
    'azd-env-name': solutionName
    TemplateName: 'Container Migration'
  },
  tags
)

// Deployer information for tagging and local debugging permissions.
var deployerInfo = deployer()
var deployingUserPrincipalId = deployerInfo.objectId
var deployingUserType = contains(deployerInfo, 'userPrincipalName') ? 'User' : 'ServicePrincipal'

var deployerIdentityName = !empty(createdBy)
  ? createdBy
  : deployerInfo.?userPrincipalName != null
      ? split(deployerInfo.userPrincipalName, '@')[0]
      : 'Identity-${deployerInfo.objectId}'

// Existing Log Analytics workspace handling.
var useExistingLogAnalytics = !empty(existingLogAnalyticsWorkspaceId)
var existingLawSubscription = useExistingLogAnalytics ? split(existingLogAnalyticsWorkspaceId, '/')[2] : ''
var existingLawResourceGroup = useExistingLogAnalytics ? split(existingLogAnalyticsWorkspaceId, '/')[4] : ''
var existingLawName = useExistingLogAnalytics ? split(existingLogAnalyticsWorkspaceId, '/')[8] : ''

resource existingLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = if (useExistingLogAnalytics) {
  name: existingLawName
  scope: resourceGroup(existingLawSubscription, existingLawResourceGroup)
}

// Replica regions used for cross-region Log Analytics replication when enableRedundancy is true.
// See https://learn.microsoft.com/azure/azure-monitor/logs/workspace-replication#supported-regions
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
  westus3: 'eastus'
}
var replicaLocation = replicaRegionPairs[?location]

// HA failover region pairs for zone-redundant Cosmos DB accounts.
var cosmosDbZoneRedundantHaRegionPairs = {
  australiaeast: 'uksouth'
  centralus: 'eastus2'
  eastasia: 'southeastasia'
  eastus: 'centralus'
  eastus2: 'centralus'
  japaneast: 'australiaeast'
  northeurope: 'westeurope'
  southeastasia: 'eastasia'
  uksouth: 'westeurope'
  westeurope: 'northeurope'
  westus3: 'eastus'
}
var cosmosDbHaLocation = cosmosDbZoneRedundantHaRegionPairs[?cosmosLocation]

// Common workload constants.
var processBlobContainerName = 'processes'
var processQueueName = 'processes-queue'
var cosmosDatabaseName = 'migration_db'
var processCosmosContainerName = 'processes'
var agentTelemetryCosmosContainerName = 'agent_telemetry'
var processControlCosmosContainerName = 'processcontrol'

// AI Foundry existing-project handling.
var useExistingAiFoundryAiProject = !empty(existingFoundryProjectResourceId)
var aiFoundryAiServicesResourceGroupName = useExistingAiFoundryAiProject
  ? split(existingFoundryProjectResourceId, '/')[4]
  : resourceGroup().name
var aiFoundryAiServicesSubscriptionId = useExistingAiFoundryAiProject
  ? split(existingFoundryProjectResourceId, '/')[2]
  : subscription().subscriptionId
var aiFoundryAiServicesResourceName = useExistingAiFoundryAiProject
  ? split(existingFoundryProjectResourceId, '/')[8]
  : 'aif-${solutionSuffix}'
var aiFoundryAiProjectResourceName = useExistingAiFoundryAiProject
  ? last(split(existingFoundryProjectResourceId, '/'))
  : 'proj-${solutionSuffix}'
var aiFoundryAiProjectDescription = 'AI Foundry project for ${solutionName}'

// Container app names (truncated to the 32-char Azure limit).
var backendContainerAppName = take('ca-backend-api-${solutionSuffix}', 32)
var frontEndContainerAppName = take('ca-frontend-${solutionSuffix}', 32)
var processorContainerAppName = take('ca-processor-${solutionSuffix}', 32)
var backendContainerPort = 80

var storageAccountName = 'st${solutionSuffix}'
var cosmosDbResourceName = 'cosmos-${solutionSuffix}'

// ============== //
// Resources      //
// ============== //

// ========== AVM Telemetry ========== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-containermigration.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

// ========== Resource Group Tagging ========== //
var existingTags = resourceGroup().tags ?? {}

resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags: union(
      existingTags,
      tags,
      {
        TemplateName: 'Container Migration'
        Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
        CreatedBy: deployerIdentityName
      }
    )
  }
}

// ========== User-Assigned Managed Identity ========== //
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module appIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: location
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ========== Log Analytics Workspace ========== //
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.12.0' = if ((enableMonitoring || enablePrivateNetworking) && !useExistingLogAnalytics) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    location: location
    skuName: 'PerGB2018'
    dataRetention: 30
    diagnosticSettings: [{ useThisWorkspace: true }]
    tags: allTags
    enableTelemetry: enableTelemetry
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    dailyQuotaGb: enableRedundancy ? 10 : null
    replication: enableRedundancy && replicaLocation != null
      ? {
          enabled: true
          location: replicaLocation!
        }
      : null
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

var logAnalyticsWorkspaceResourceId = useExistingLogAnalytics
  ? existingLogAnalyticsWorkspaceId
  : ((enableMonitoring || enablePrivateNetworking) ? logAnalyticsWorkspace!.outputs.resourceId : '')

// Reference the workspace via an existing resource so we can read its customerId/sharedKey without
// dereferencing the AVM module's @secure() outputs through a conditional/null-assertion (BCP426).
resource newLawForContainerApps 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = if ((enableMonitoring || enablePrivateNetworking) && !useExistingLogAnalytics) {
  name: logAnalyticsWorkspaceResourceName
}

// ========== Application Insights ========== //
var applicationInsightsResourceName = 'appi-${solutionSuffix}'
module applicationInsights 'br/public:avm/res/insights/component:0.6.1' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    location: location
    tags: allTags
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    workspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
  }
}

// ========== Virtual Network ========== //
module virtualNetwork './modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtual-network.${solutionSuffix}', 64)
  params: {
    name: 'vnet-${solutionSuffix}'
    addressPrefixes: ['10.0.0.0/20']
    location: location
    tags: allTags
    logAnalyticsWorkspaceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    resourceSuffix: solutionSuffix
    enableTelemetry: enableTelemetry
  }
}

// ========== Bastion Host ========== //
var bastionHostName = 'bas-${solutionSuffix}'
module bastionHost 'br/public:avm/res/network/bastion-host:0.8.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionHostName}', 64)
  params: {
    name: bastionHostName
    skuName: 'Standard'
    location: location
    virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
    diagnosticSettings: enableMonitoring
      ? [
          {
            name: 'bastionDiagnostics'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
          }
        ]
      : null
    tags: allTags
    enableTelemetry: enableTelemetry
    publicIPAddressObject: {
      name: 'pip-${bastionHostName}'
    }
  }
}

// ========== Jumpbox Maintenance Configuration (waf-aligned) ========== //
resource jumpboxMaintenanceConfig 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = if (enablePrivateNetworking) {
  name: take('mc-jumpbox-${solutionSuffix}', 64)
  location: location
  tags: allTags
  properties: {
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2025-01-01 00:00'
      duration: '03:55'
      timeZone: 'UTC'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: ['Critical', 'Security']
      }
    }
  }
}

// ========== Jumpbox Virtual Machine ========== //
var jumpboxVmName = take('vm-jumpbox-${solutionSuffix}', 15)
module jumpboxVM 'br/public:avm/res/compute/virtual-machine:0.20.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${jumpboxVmName}', 64)
  params: {
    name: jumpboxVmName
    vmSize: vmSize ?? 'Standard_D2s_v5'
    location: location
    adminUsername: vmAdminUsername ?? 'JumpboxAdminUser'
    adminPassword: vmAdminPassword ?? 'JumpboxAdminP@ssw0rd1234!'
    tags: allTags
    availabilityZone: 1
    maintenanceConfigurationResourceId: jumpboxMaintenanceConfig!.id
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    osDisk: {
      name: 'osdisk-${jumpboxVmName}'
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    encryptionAtHost: false
    nicConfigurations: [
      {
        name: 'nic-${jumpboxVmName}'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork!.outputs.jumpboxSubnetResourceId
          }
        ]
        diagnosticSettings: enableMonitoring
          ? [
              {
                name: 'jumpboxDiagnostics'
                workspaceResourceId: logAnalyticsWorkspaceResourceId
                logCategoriesAndGroups: [
                  {
                    categoryGroup: 'allLogs'
                    enabled: true
                  }
                ]
                metricCategories: [
                  {
                    category: 'AllMetrics'
                    enabled: true
                  }
                ]
              }
            ]
          : null
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// ========== Private DNS Zones ========== //
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.documents.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.azconfig.io'
]

var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  cosmosDB: 3
  storageBlob: 4
  storageQueue: 5
  appConfig: 6
}

var aiRelatedDnsZoneIndices = [
  dnsZoneIndex.cognitiveServices
  dnsZoneIndex.openAI
  dnsZoneIndex.aiServices
]

@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.8.0' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking && (empty(existingFoundryProjectResourceId) || !contains(
    aiRelatedDnsZoneIndices,
    i
  ))) {
    name: take('avm.res.network.private-dns-zone.${i}-${solutionSuffix}', 64)
    params: {
      name: zone
      tags: allTags
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

// ========== Storage Account ========== //
module storageAccount 'br/public:avm/res/storage/storage-account:0.28.0' = {
  name: take('avm.res.storage.storage-account.${storageAccountName}', 64)
  params: {
    name: storageAccountName
    location: location
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    tags: allTags
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: (enablePrivateNetworking || enableRedundancy) ? 'Deny' : 'Allow'
    }
    allowBlobPublicAccess: false
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-blob-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-blob-${solutionSuffix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-blob'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob]!.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            service: 'blob'
          }
          {
            name: 'pep-queue-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-queue-${solutionSuffix}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'storage-dns-zone-group-queue'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageQueue]!.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
            service: 'queue'
          }
        ]
      : []
    blobServices: {
      corsRules: []
      deleteRetentionPolicyEnabled: true
      deleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: true
      containerDeleteRetentionPolicyDays: 7
      containers: [
        {
          name: processBlobContainerName
          publicAccess: 'None'
          denyEncryptionScopeOverride: false
          defaultEncryptionScope: '$account-encryption-key'
        }
      ]
    }
    queueServices: {
      queues: [
        {
          name: processQueueName
        }
        {
          name: '${processQueueName}-dead-letter'
        }
      ]
    }
  }
}

// ========== Cosmos DB ========== //
module cosmosDb 'br/public:avm/res/document-db/database-account:0.18.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    name: cosmosDbResourceName
    location: cosmosLocation
    tags: allTags
    enableTelemetry: enableTelemetry
    sqlDatabases: [
      {
        name: cosmosDatabaseName
        containers: [
          {
            name: processCosmosContainerName
            paths: ['/_partitionKey']
          }
          {
            name: agentTelemetryCosmosContainerName
            paths: ['/_partitionKey']
          }
          {
            name: processControlCosmosContainerName
            paths: ['/_partitionKey']
          }
          {
            name: 'files'
            paths: ['/_partitionKey']
          }
          {
            name: 'process_statuses'
            paths: ['/_partitionKey']
          }
        ]
      }
    ]
    diagnosticSettings: enableMonitoring
      ? [
          {
            workspaceResourceId: logAnalyticsWorkspaceResourceId
          }
        ]
      : null
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    }
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${cosmosDbResourceName}'
            customNetworkInterfaceName: 'nic-${cosmosDbResourceName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'cosmos-dns-zone-group-sql'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB]!.outputs.resourceId
                }
              ]
            }
            service: 'Sql'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
          }
        ]
      : []
    zoneRedundant: enableRedundancy
    capabilitiesToAdd: enableRedundancy
      ? null
      : ['EnableServerless']
    enableAutomaticFailover: enableRedundancy
    failoverLocations: enableRedundancy && cosmosDbHaLocation != null
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: cosmosLocation
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: cosmosDbHaLocation!
          }
        ]
      : [
          {
            locationName: cosmosLocation
            failoverPriority: 0
            isZoneRedundant: false
          }
        ]
    roleAssignments: [
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'DocumentDB Account Contributor'
      }
      {
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
        roleDefinitionIdOrName: 'DocumentDB Account Contributor'
      }
    ]
  }
  dependsOn: [storageAccount]
}

// Reference to the deployed Cosmos DB account so we can attach data-plane (SQL) role definitions and assignments.
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: cosmosDbResourceName
  dependsOn: [cosmosDb]
}

resource cosmosDbDataContributorRoleDef 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-11-15' = {
  parent: cosmosDbAccount
  name: guid(cosmosDbResourceName, 'CosmosDB Data Contributor Custom')
  properties: {
    roleName: 'CosmosDB Data Contributor Custom'
    type: 'CustomRole'
    assignableScopes: [
      cosmosDbAccount.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
        ]
      }
    ]
  }
}

resource cosmosDbDataContributorAssignmentApp 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-11-15' = {
  parent: cosmosDbAccount
  name: guid(cosmosDbResourceName, 'app-data-contributor')
  properties: {
    roleDefinitionId: cosmosDbDataContributorRoleDef.id
    principalId: appIdentity.outputs.principalId
    scope: cosmosDbAccount.id
  }
}

resource cosmosDbDataContributorAssignmentDeployer 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-11-15' = {
  parent: cosmosDbAccount
  name: guid(cosmosDbResourceName, 'deployer-data-contributor')
  properties: {
    roleDefinitionId: cosmosDbDataContributorRoleDef.id
    principalId: deployingUserPrincipalId
    scope: cosmosDbAccount.id
  }
}

// ========== AI Foundry: existing project flow (model deployments only) ========== //
module existingAiFoundryAiServicesDeployments './modules/ai-services-deployments.bicep' = if (useExistingAiFoundryAiProject) {
  name: take('module.ai-services-model-deployments.${aiFoundryAiServicesResourceName}', 64)
  scope: resourceGroup(aiFoundryAiServicesSubscriptionId, aiFoundryAiServicesResourceGroupName)
  params: {
    name: aiFoundryAiServicesResourceName
    deployments: [
      {
        name: aiModelName
        model: {
          format: 'OpenAI'
          name: aiModelName
          version: aiModelVersion
        }
        sku: {
          name: aiDeploymentType
          capacity: aiModelCapacity
        }
      }
      {
        name: aiEmbeddingModelName
        model: {
          format: 'OpenAI'
          name: aiEmbeddingModelName
          version: aiEmbeddingModelVersion
        }
        sku: {
          name: aiEmbeddingDeploymentType
          capacity: aiEmbeddingModelCapacity
        }
      }
    ]
    roleAssignments: [
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
      }
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee'
      }
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
      }
      {
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
      }
      {
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
        roleDefinitionIdOrName: 'Cognitive Services User'
      }
    ]
  }
}

// ========== AI Foundry AI Services (new account flow) ========== //
module aiFoundryAiServices 'br/public:avm/res/cognitive-services/account:0.13.2' = if (!useExistingAiFoundryAiProject) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: azureAiServiceLocation
    tags: allTags
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    allowProjectManagement: true
    customSubDomainName: aiFoundryAiServicesResourceName
    deployments: [
      {
        name: aiModelName
        model: {
          format: 'OpenAI'
          name: aiModelName
          version: aiModelVersion
        }
        sku: {
          name: aiDeploymentType
          capacity: aiModelCapacity
        }
      }
      {
        name: aiEmbeddingModelName
        model: {
          format: 'OpenAI'
          name: aiEmbeddingModelName
          version: aiEmbeddingModelVersion
        }
        sku: {
          name: aiEmbeddingDeploymentType
          capacity: aiEmbeddingModelCapacity
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [appIdentity.outputs.resourceId]
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee'
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
      }
      {
        roleDefinitionIdOrName: 'Cognitive Services User'
        principalId: deployingUserPrincipalId
        principalType: deployingUserType
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: []
    enableTelemetry: enableTelemetry
  }
}

// ========== AI Foundry Private Endpoint (new account flow) ========== //
module aiFoundryPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.1' = if (enablePrivateNetworking && !useExistingAiFoundryAiProject) {
  name: take('pep-${aiFoundryAiServicesResourceName}-deployment', 64)
  params: {
    name: 'pep-${aiFoundryAiServicesResourceName}'
    customNetworkInterfaceName: 'nic-${aiFoundryAiServicesResourceName}'
    location: location
    tags: allTags
    enableTelemetry: enableTelemetry
    privateLinkServiceConnections: [
      {
        name: 'pep-${aiFoundryAiServicesResourceName}-connection'
        properties: {
          privateLinkServiceId: aiFoundryAiServices!.outputs.resourceId
          groupIds: ['account']
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'ai-services-dns-zone-cognitiveservices'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
        }
        {
          name: 'ai-services-dns-zone-openai'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.openAI]!.outputs.resourceId
        }
        {
          name: 'ai-services-dns-zone-aiservices'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.aiServices]!.outputs.resourceId
        }
      ]
    }
    subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
  }
}

// ========== AI Foundry Project (new account flow) ========== //
module aiFoundryProject './modules/ai-project.bicep' = if (!useExistingAiFoundryAiProject) {
  name: take('module.ai-project.${aiFoundryAiProjectResourceName}', 64)
  dependsOn: enablePrivateNetworking ? [aiFoundryPrivateEndpoint] : []
  params: {
    name: aiFoundryAiProjectResourceName
    location: azureAiServiceLocation
    tags: allTags
    desc: aiFoundryAiProjectDescription
    aiServicesName: aiFoundryAiServicesResourceName
  }
}

// ========== App Configuration (initial deploy with key values) ========== //
module appConfiguration 'br/public:avm/res/app-configuration/configuration-store:0.9.2' = {
  name: take('avm.res.app-configuration.configuration-store.${solutionSuffix}', 64)
  params: {
    location: location
    name: 'appcs-${solutionSuffix}'
    disableLocalAuth: false
    tags: allTags
    keyValues: [
      { name: 'APP_LOGGING_ENABLE', value: 'true' }
      { name: 'APP_LOGGING_LEVEL', value: 'INFO' }
      { name: 'AZURE_PACKAGE_LOGGING_LEVEL', value: 'INFO' }
      { name: 'AZURE_LOGGING_PACKAGES', value: '' }
      { name: 'AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME', value: '' }
      { name: 'AZURE_AI_AGENT_PROJECT_CONNECTION_STRING', value: '' }
      { name: 'AZURE_OPENAI_API_VERSION', value: '2025-03-01-preview' }
      { name: 'AZURE_OPENAI_CHAT_DEPLOYMENT_NAME', value: aiModelName }
      { name: 'AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME', value: aiEmbeddingModelName }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://${aiFoundryAiServicesResourceName}.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT_BASE'
        value: 'https://${aiFoundryAiServicesResourceName}.cognitiveservices.azure.com/'
      }
      { name: 'AZURE_TRACING_ENABLED', value: 'True' }
      {
        name: 'STORAGE_ACCOUNT_BLOB_URL'
        value: 'https://${storageAccountName}.blob.${environment().suffixes.storage}'
      }
      { name: 'STORAGE_ACCOUNT_NAME', value: storageAccount.outputs.name }
      { name: 'STORAGE_ACCOUNT_PROCESS_CONTAINER', value: processBlobContainerName }
      { name: 'STORAGE_ACCOUNT_PROCESS_QUEUE', value: processQueueName }
      {
        name: 'STORAGE_ACCOUNT_QUEUE_URL'
        value: 'https://${storageAccountName}.queue.${environment().suffixes.storage}'
      }
      { name: 'COSMOS_DB_CONTAINER_NAME', value: agentTelemetryCosmosContainerName }
      { name: 'COSMOS_DB_CONTROL_CONTAINER_NAME', value: processControlCosmosContainerName }
      { name: 'COSMOS_DB_DATABASE_NAME', value: cosmosDatabaseName }
      { name: 'COSMOS_DB_ACCOUNT_URL', value: cosmosDb.outputs.endpoint }
      { name: 'COSMOS_DB_PROCESS_CONTAINER', value: processCosmosContainerName }
      { name: 'COSMOS_DB_PROCESS_LOG_CONTAINER', value: agentTelemetryCosmosContainerName }
      { name: 'GLOBAL_LLM_SERVICE', value: 'AzureOpenAI' }
      { name: 'STORAGE_QUEUE_ACCOUNT', value: storageAccount.outputs.name }
    ]
    roleAssignments: [
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'App Configuration Data Reader'
      }
    ]
    enableTelemetry: enableTelemetry
    managedIdentities: { systemAssigned: true }
    sku: 'Standard'
    publicNetworkAccess: 'Enabled'
    replicaLocations: enableRedundancy && replicaLocation != null
      ? [
          {
            name: 'replica1'
            replicaLocation: replicaLocation!
          }
        ]
      : []
  }
}

// ========== App Configuration Update (private endpoint + disableLocalAuth) ========== //
module appConfigurationUpdate 'br/public:avm/res/app-configuration/configuration-store:0.9.2' = if (enablePrivateNetworking) {
  name: take('avm.res.app-configuration.configuration-store-update.${solutionSuffix}', 64)
  params: {
    name: 'appcs-${solutionSuffix}'
    location: location
    managedIdentities: { systemAssigned: true }
    sku: 'Standard'
    enableTelemetry: enableTelemetry
    tags: allTags
    disableLocalAuth: true
    publicNetworkAccess: 'Enabled'
    replicaLocations: enableRedundancy && replicaLocation != null
      ? [
          {
            name: 'replica1'
            replicaLocation: replicaLocation!
          }
        ]
      : []
    privateEndpoints: [
      {
        name: 'pep-appconfig-${solutionSuffix}'
        customNetworkInterfaceName: 'nic-appconfig-${solutionSuffix}'
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              name: 'appconfig-dns-zone-group'
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.appConfig]!.outputs.resourceId
            }
          ]
        }
        subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
      }
    ]
  }
  dependsOn: [appConfiguration]
}

// ========== Container Apps Environment ========== //
module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.11.3' = {
  name: take('avm.res.app.managed-environment.${solutionSuffix}', 64)
  params: {
    name: 'cae-${solutionSuffix}'
    location: location
    tags: allTags
    managedIdentities: { systemAssigned: true }
    appLogsConfiguration: enableMonitoring
      ? {
          destination: 'log-analytics'
          logAnalyticsConfiguration: {
            customerId: useExistingLogAnalytics
              ? existingLogAnalyticsWorkspace!.properties.customerId
              : newLawForContainerApps!.properties.customerId
            sharedKey: useExistingLogAnalytics
              ? existingLogAnalyticsWorkspace!.listKeys().primarySharedKey
              : newLawForContainerApps!.listKeys().primarySharedKey
          }
        }
      : null
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    enableTelemetry: enableTelemetry
    publicNetworkAccess: 'Enabled'
    platformReservedCidr: enablePrivateNetworking ? '172.17.17.0/24' : null
    platformReservedDnsIP: enablePrivateNetworking ? '172.17.17.17' : null
    zoneRedundant: enableRedundancy
    infrastructureSubnetResourceId: enablePrivateNetworking ? virtualNetwork!.outputs.containersSubnetResourceId : null
  }
  dependsOn: [
    #disable-next-line no-unnecessary-dependson
    logAnalyticsWorkspace
  ]
}
module containerAppBackend 'br/public:avm/res/app/container-app:0.19.0' = {
  name: take('avm.res.app.container-app.${backendContainerAppName}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [appConfiguration]
  params: {
    name: backendContainerAppName
    location: location
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        appIdentity.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'backend-api'
        image: '${containerRegistryHost}/backend-api:${imageTag}'
        env: concat(
          [
            {
              name: 'APP_CONFIGURATION_URL'
              value: appConfiguration.outputs.endpoint
            }
            {
              name: 'AZURE_CLIENT_ID'
              value: appIdentity.outputs.clientId
            }
            {
              name: 'PROCESSOR_CONTROL_URL'
              value: 'https://${processorContainerAppName}.internal.${containerAppsEnvironment.outputs.defaultDomain}'
            }
          ],
          enableMonitoring
            ? [
                {
                  name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
                  value: applicationInsights!.outputs.connectionString
                }
              ]
            : []
        )
        resources: {
          cpu: 1
          memory: '2.0Gi'
        }
      }
    ]
    ingressTargetPort: backendContainerPort
    ingressExternal: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 1
      minReplicas: enableRedundancy ? 2 : 1
      rules: enableScalability
        ? [
            {
              name: 'http-scaler'
              http: {
                metadata: {
                  concurrentRequests: 100
                }
              }
            }
          ]
        : []
    }
    corsPolicy: {
      allowedOrigins: ['*']
      allowedMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
      allowedHeaders: ['Authorization', 'Content-Type', '*']
    }
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ========== Container App: Frontend ========== //
module containerAppFrontend 'br/public:avm/res/app/container-app:0.19.0' = {
  name: take('avm.res.app.container-app.${frontEndContainerAppName}', 64)
  params: {
    name: frontEndContainerAppName
    location: location
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        appIdentity.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'frontend'
        image: '${containerRegistryHost}/frontend:${imageTag}'
        env: [
          {
            name: 'API_URL'
            value: 'https://${containerAppBackend.outputs.fqdn}'
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
          {
            name: 'REACT_APP_MSAL_POST_REDIRECT_URL'
            value: '/'
          }
          {
            name: 'REACT_APP_MSAL_REDIRECT_URL'
            value: '/'
          }
          {
            name: 'ALLOWED_ORIGINS'
            value: 'https://${frontEndContainerAppName}.${containerAppsEnvironment.outputs.defaultDomain}'
          }
        ]
        resources: {
          cpu: 1
          memory: '2.0Gi'
        }
      }
    ]
    ingressTargetPort: 3000
    ingressExternal: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 1
      minReplicas: enableRedundancy ? 2 : 1
      rules: enableScalability
        ? [
            {
              name: 'http-scaler'
              http: {
                metadata: {
                  concurrentRequests: 100
                }
              }
            }
          ]
        : []
    }
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ========== Container App: Processor (internal ingress) ========== //
module containerAppProcessor 'br/public:avm/res/app/container-app:0.19.0' = {
  name: take('avm.res.app.container-app.${processorContainerAppName}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [appConfiguration]
  params: {
    name: processorContainerAppName
    location: location
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        appIdentity.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'processor'
        image: '${containerRegistryHost}/processor:${imageTag}'
        env: concat(
          [
            {
              name: 'APP_CONFIGURATION_URL'
              value: appConfiguration.outputs.endpoint
            }
            {
              name: 'AZURE_CLIENT_ID'
              value: appIdentity.outputs.clientId
            }
            {
              name: 'AZURE_STORAGE_ACCOUNT_NAME'
              value: storageAccount.outputs.name
            }
            {
              name: 'STORAGE_ACCOUNT_NAME'
              value: storageAccount.outputs.name
            }
            {
              name: 'CONTROL_API_ENABLED'
              value: '1'
            }
            {
              name: 'CONTROL_API_PORT'
              value: '8080'
            }
          ],
          enableMonitoring
            ? [
                {
                  name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
                  value: applicationInsights!.outputs.connectionString
                }
              ]
            : []
        )
        resources: {
          cpu: 2
          memory: '4.0Gi'
        }
      }
    ]
    ingressTargetPort: 8080
    ingressExternal: false
    ingressAllowInsecure: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 1
      minReplicas: enableRedundancy ? 2 : 1
    }
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ============== //
// Outputs        //
// ============== //
@description('The name of the resource group.')
output resourceGroupName string = resourceGroup().name

@description('The name of the frontend (web) container app.')
output containerWebAppName string = containerAppFrontend.outputs.name

@description('The FQDN of the frontend (web) container app.')
output containerWebAppFqdn string = containerAppFrontend.outputs.fqdn

@description('The name of the backend (API) container app.')
output containerApiAppName string = containerAppBackend.outputs.name

@description('The FQDN of the backend (API) container app.')
output containerApiAppFqdn string = containerAppBackend.outputs.fqdn

@description('The Azure subscription ID.')
output azureSubscriptionId string = subscription().subscriptionId

@description('The Azure resource group name.')
output azureResourceGroup string = resourceGroup().name

@description('Preview of the CreatedBy tag value derived from the deployer.')
output previewCreatedByTag string = deployerIdentityName

@description('The name of the user-assigned managed identity for the workload.')
output name string = appIdentity.outputs.name

@description('The resource ID of the user-assigned managed identity for the workload.')
output resourceId string = appIdentity.outputs.resourceId

@description('The resource ID of the deployed Cosmos DB account.')
output cosmosDbResourceId string = cosmosDb.outputs.resourceId

@description('The resource ID of the deployed storage account.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('The resource ID of the deployed Container Apps environment.')
output containerAppsEnvironmentResourceId string = containerAppsEnvironment.outputs.resourceId
