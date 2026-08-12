// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Content Processing Solution Accelerator'
metadata description = '''This module contains the resources required to deploy the [Content Processing solution accelerator](https://github.com/microsoft/content-processing-solution-accelerator) for both Sandbox environments and WAF aligned environments.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/content-processing-solution-accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ========== Parameters ========== //
@description('Optional. Name of the solution to deploy.')
param solutionName string = 'cps'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@minLength(1)
@description('Optional. Location for the Azure AI Content Understanding service deployment.')
@allowed(['WestUS', 'SwedenCentral', 'AustraliaEast'])
@metadata({
  azd: {
    type: 'location'
  }
})
param contentUnderstandingLocation string = 'WestUS'

@description('Required. Location for the Azure AI Services deployment. Must support both Azure OpenAI gpt-5.1 (GlobalStandard) and Azure AI Content Understanding GA. If the deploymentType param is set to Standard, override the metadata.azd.usageName below to reference OpenAI.Standard.gpt-5.1 instead.')
@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-5.1,30'
    ]
  }
})
param aiServiceLocation string

@description('Optional. Type of GPT deployment to use: Standard | GlobalStandard.')
@minLength(1)
@allowed([
  'Standard'
  'GlobalStandard'
])
param deploymentType string = 'GlobalStandard'

@description('Optional. Name of the GPT model to deploy: gpt-5.1.')
param gptModelName string = 'gpt-5.1'

@minLength(1)
@description('Optional. Version of the GPT model to deploy:.')
@allowed([
  '2025-11-13'
])
param gptModelVersion string = '2025-11-13'

@minValue(1)
@description('Optional. Capacity of the GPT deployment: (minimum 10).')
param gptDeploymentCapacity int = 100

@description('Optional. Location used for Azure Cosmos DB, Azure Container App deployment.')
param secondaryLocation string = (location == 'eastus2') ? 'westus2' : 'eastus2'

@description('Optional. The public container image endpoint.')
param publicContainerImageEndpoint string = 'cpscontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the App Container App.')
param appContainerImageName string = 'contentprocessor'

@description('Optional. The Container Image Name to deploy on the API Container App.')
param apiContainerImageName string = 'contentprocessorapi'

@description('Optional. The Container Image Name to deploy on the Web Container App.')
param webContainerImageName string = 'contentprocessorweb'

@description('Optional. The container image tag to use for all container apps.')
param containerImageTag string = 'latest_2025-11-04_458'

@description('Optional. Enable WAF for the deployment.')
param enablePrivateNetworking bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

@description('Optional. Enable purge protection. Defaults to false.')
param enablePurgeProtection bool = false

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {
  app: 'Content Processing Solution Accelerator'
  location: resourceGroup().location
}

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.')
param vmSize string = ''

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminUsername string = ''

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
param vmAdminPassword string = ''

@maxLength(5)
@description('Optional. A unique text value for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
param solutionUniqueText string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueText}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))
// ============== //
// Resources      //
// ============== //

// ========== AVM Telemetry ========== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-contentprocessing.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

// Replica regions list based on article in [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Enhance resilience by replicating your Log Analytics workspace across regions](https://learn.microsoft.com/azure/azure-monitor/logs/workspace-replication#supported-regions) for supported regions for Log Analytics Workspace.
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
var replicaLocation = replicaRegionPairs[?location]

// ========== Virtual Network ========== //
module virtualNetwork './modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtual-network.${solutionSuffix}', 64)
  params: {
    name: 'vnet-${solutionSuffix}'
    addressPrefixes: ['10.0.0.0/8']
    location: location
    tags: tags
    logAnalyticsWorkspaceId: enableMonitoring ? logAnalyticsWorkspace!.outputs.resourceId : ''
    resourceSuffix: solutionSuffix
    enableTelemetry: enableTelemetry
  }
}

// Azure Bastion Host
var bastionHostName = 'bas-${solutionSuffix}'
module bastionHost 'br/public:avm/res/network/bastion-host:0.8.2' = if (enablePrivateNetworking) {
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
            workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
          }
        ]
      : null
    tags: tags
    enableTelemetry: enableTelemetry
    publicIPAddressObject: {
      name: 'pip-${bastionHostName}'
    }
  }
}

// ========== VM Maintenance Configuration Mapping ========== //

// Jumpbox Virtual Machine
var jumpboxVmName = take('vm-jumpbox-${solutionSuffix}', 15)
module jumpboxVM 'br/public:avm/res/compute/virtual-machine:0.22.3' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${jumpboxVmName}', 64)
  params: {
    name: take(jumpboxVmName, 15) // Shorten VM name to 15 characters to avoid Azure limits
    vmSize: empty(vmSize) ? 'Standard_DS2_v2' : vmSize
    location: location
    adminUsername: empty(vmAdminUsername) ? 'JumpboxAdminUser' : vmAdminUsername
    adminPassword: empty(vmAdminPassword) ? 'JumpboxAdminP@ssw0rd1234!' : vmAdminPassword
    tags: tags
    // WAF aligned configuration for Redundancy - use availability zone when redundancy is enabled
    availabilityZone: 1
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    // WAF aligned configuration - Enable automatic patching with platform management
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    osDisk: {
      name: 'osdisk-${jumpboxVmName}'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    encryptionAtHost: false // Some Azure subscriptions do not support encryption at host
    // WAF aligned configuration - VM maintenance configuration for reduced unplanned disruptions
    maintenanceConfigurationResourceId: maintenanceConfiguration.outputs.resourceId

    nicConfigurations: [
      {
        name: 'nic-${jumpboxVmName}'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork!.outputs.adminSubnetResourceId
          }
        ]
        diagnosticSettings: enableMonitoring
          ? [
              {
                name: 'jumpboxNicDiagnostics'
                workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
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

module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.4.0' = if (enablePrivateNetworking) {
  name: take('${jumpboxVmName}-jumpbox-maintenance-config', 64)
  params: {
    name: 'mc-${jumpboxVmName}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2024-06-16 00:00'
      duration: '03:55'
      timeZone: 'W. Europe Standard Time'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

// ========== Private DNS Zones ========== //
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.contentunderstanding.ai.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.queue.${environment().suffixes.storage}'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.azconfig.io'
  'privatelink.azurecr.io'
]

// DNS Zone Index Constants
var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  contentUnderstanding: 3
  storageBlob: 4
  storageQueue: 5
  cosmosDB: 6
  appConfig: 7
  containerRegistry: 8
}

@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.8.1' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: take('avm.res.network.private-dns-zone.${split(zone, '.')[1]}', 64)
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork!.outputs.resourceId }]
    }
  }
]

// ========== Log Analytics and Application insights ========== //

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// WAF PSRules for Log Analytics: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#azure-monitor-logs
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.16.1' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 365
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    diagnosticSettings: [{ useThisWorkspace: true }]
    // WAF aligned configuration for Redundancy
    dailyQuotaGb: enableRedundancy ? '150' : null //WAF recommendation: 150 GB per day is a good starting point for most workloads
    replication: enableRedundancy
      ? {
          enabled: true
          location: replicaLocation
        }
      : null
    // WAF aligned configuration for Private Networking
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    dataSources: enablePrivateNetworking
      ? [
          {
            tags: tags
            eventLogName: 'Application'
            eventTypes: [
              {
                eventType: 'Error'
              }
              {
                eventType: 'Warning'
              }
              {
                eventType: 'Information'
              }
            ]
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
          {
            kind: 'IISLogs'
            name: 'sampleIISLog1'
            state: 'OnPremiseEnabled'
          }
        ]
      : null
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.8.0' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${solutionSuffix}', 64)
  params: {
    name: 'appi-${solutionSuffix}'
    location: location
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    // WAF aligned configuration for Monitoring
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspace!.outputs.resourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    tags: tags
  }
}
@description('Optional. Tag, Created by user name.')
param createdBy string = contains(deployer(), 'userPrincipalName')
  ? split(deployer().userPrincipalName, '@')[0]
  : deployer().objectId

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags: {
      ...resourceGroup().tags
      ...tags
      TemplateName: 'Content Processing'
      Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
      CreatedBy: createdBy
      DeploymentName: deployment().name
    }
  }
}

// ========== Managed Identity ========== //
module avmManagedIdentity './modules/managed-identity.bicep' = {
  name: take('module.managed-identity.${solutionSuffix}', 64)
  params: {
    name: 'id-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module avmContainerRegistry 'modules/container-registry.bicep' = {
  name: take('module.container-registry.${solutionSuffix}', 64)
  params: {
    acrName: 'cr${replace(solutionSuffix, '-', '')}'
    location: location
    acrSku: enableRedundancy || enablePrivateNetworking ? 'Premium' : 'Standard'
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    zoneRedundancy: 'Disabled'
    roleAssignments: [
      {
        principalId: avmContainerRegistryReader.outputs.principalId
        roleDefinitionIdOrName: 'AcrPull'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
    enableRedundancy: enableRedundancy
    secondaryLocation: secondaryLocation
    enablePrivateNetworking: enablePrivateNetworking
    backendSubnetResourceId: enablePrivateNetworking ? virtualNetwork!.outputs.backendSubnetResourceId : ''
    privateDnsZoneResourceId: enablePrivateNetworking
      ? avmPrivateDnsZones[dnsZoneIndex.containerRegistry]!.outputs.resourceId
      : ''
  }
}

// // ========== Storage Account ========== //
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.33.0' = {
  name: take('module.storage-account.${solutionSuffix}', 64)
  params: {
    name: 'st${replace(solutionSuffix, '-', '')}'
    location: location
    managedIdentities: { systemAssigned: true }
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: avmContainerApp_API.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: avmContainerApp_API.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: avmContainerApp_Workflow.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: avmContainerApp_Workflow.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: (enablePrivateNetworking) ? 'Deny' : 'Allow'
      ipRules: []
    }
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    tags: tags

    //<======================= WAF related parameters
    allowBlobPublicAccess: false
    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
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
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId // Use the backend subnet
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
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId // Use the backend subnet
            service: 'queue'
          }
        ]
      : []
  }
}

// // ========== AI Foundry and related resources ========== //
module avmAiServices 'modules/account/aifoundry.bicep' = {
  name: take('module.ai-services.${solutionSuffix}', 64)
  params: {
    name: 'aif-${solutionSuffix}'
    projectName: 'proj-${solutionSuffix}'
    projectDescription: 'proj-${solutionSuffix}'
    location: aiServiceLocation
    sku: 'S0'
    allowProjectManagement: true
    managedIdentities: { systemAssigned: true }
    kind: 'AIServices'
    tags: {
      app: solutionSuffix
      location: aiServiceLocation
    }
    customSubDomainName: 'aif-${solutionSuffix}'
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }] : null
    roleAssignments: [
      {
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Azure AI Developer'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_Workflow.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_Workflow.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Azure AI Developer'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Cognitive Services User'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_Workflow.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Cognitive Services User'
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: (enablePrivateNetworking) ? 'Deny' : 'Allow'
    }
    disableLocalAuth: true
    enableTelemetry: enableTelemetry
    deployments: [
      {
        name: gptModelName
        model: {
          format: 'OpenAI'
          name: gptModelName
          version: gptModelVersion
        }
        sku: {
          name: deploymentType
          capacity: gptDeploymentCapacity
        }
        raiPolicyName: 'Microsoft.Default'
      }
    ]

    // WAF related parameters
    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'pep-aiservices-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-aiservices-${solutionSuffix}'
            privateEndpointResourceId: virtualNetwork!.outputs.resourceId
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
                {
                  name: 'ai-services-dns-zone-contentunderstanding'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.contentUnderstanding]!.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId // Use the backend subnet
          }
        ]
      : []
  }
}

// NOTE: Content Understanding is served from the same avmAiServices ('aif-') AIServices-kind
// account as Azure OpenAI (see APP_CONTENT_UNDERSTANDING_ENDPOINT below) - a separate
// 'aicu-' account is not required and was removed here because it was not being created/
// reachable reliably, causing PDF extraction to fail with a DNS resolution error.

// ========== Container App Environment ========== //
module avmContainerAppEnv 'br/public:avm/res/app/managed-environment:0.15.0' = {
  name: take('avm.res.app.managed-environment.${solutionSuffix}', 64)
  params: {
    name: 'cae-${solutionSuffix}'
    location: location
    tags: {
      app: solutionSuffix
      location: location
    }
    managedIdentities: { systemAssigned: true }
    appLogsConfiguration: enableMonitoring
      ? {
          destination: 'log-analytics'
          logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
        }
      : null
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    enableTelemetry: enableTelemetry
    publicNetworkAccess: 'Enabled' // Always enabled for Container Apps Environment

    // <========== WAF related parameters

    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    zoneRedundant: (enablePrivateNetworking) ? true : false // Enable zone redundancy if private networking is enabled
    infrastructureSubnetResourceId: (enablePrivateNetworking)
      ? virtualNetwork!.outputs.containersSubnetResourceId // Use the container app subnet
      : null // Use the container app subnet
  }
}

// //=========== Managed Identity for Container Registry ========== //
module avmContainerRegistryReader 'br/public:avm/res/managed-identity/user-assigned-identity:0.6.0' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${solutionSuffix}', 64)
  params: {
    name: 'id-acr-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== Container App  ========== //
module avmContainerApp 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-app'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: 'ca-${solutionSuffix}'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: ''
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
        ]
      }
    ]
    activeRevisionsMode: 'Single'
    ingressExternal: false
    disableIngress: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
    }
    tags: tags
  }
}

// ========== Container App API ========== //
module avmContainerApp_API 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app-api.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-api'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'ca-${solutionSuffix}-api'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: ''
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
        ]
        probes: [
          // Liveness Probe - Checks if the app is still running
          {
            type: 'Liveness'
            httpGet: {
              path: '/startup' // Your app must expose this endpoint
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          // Readiness Probe - Checks if the app is ready to receive traffic
          {
            type: 'Readiness'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          {
            type: 'Startup'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 20 // Wait 10s before checking
            periodSeconds: 5 // Check every 15s
            failureThreshold: 10 // Restart if it fails 5 times
          }
        ]
      }
    ]
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    ingressExternal: true
    activeRevisionsMode: 'Single'
    ingressTransport: 'auto'
    corsPolicy: {
      allowedOrigins: [
        '*'
      ]
      allowedMethods: [
        'GET'
        'POST'
        'PUT'
        'DELETE'
        'OPTIONS'
      ]
      allowedHeaders: [
        'Authorization'
        'Content-Type'
        '*'
      ]
    }
  }
}

//========== Container App Web ========== //
module avmContainerApp_Web 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app-web.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-web'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }
    ingressExternal: true
    ingressTargetPort: 3000
    activeRevisionsMode: 'Single'
    ingressTransport: 'auto'
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    containers: [
      {
        name: 'ca-${solutionSuffix}-web'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_API_BASE_URL'
            value: 'https://${avmContainerApp_API.outputs.fqdn}'
          }
          {
            name: 'APP_WEB_CLIENT_ID'
            value: '<APP_REGISTRATION_CLIENTID>'
          }
          {
            name: 'APP_WEB_AUTHORITY'
            // environment().authentication.loginEndpoint already ends with a trailing slash;
            // appending another '/' here produced a malformed double-slash authority URL
            // (e.g. https://login.microsoftonline.com//<tenantId>) which broke MSAL.js
            // initialization in the web frontend, resulting in a blank page after sign-in.
            value: '${environment().authentication.loginEndpoint}${tenant().tenantId}'
          }
          {
            name: 'APP_WEB_SCOPE'
            value: '<FRONTEND_API_SCOPE>'
          }
          {
            name: 'APP_API_SCOPE'
            value: '<BACKEND_API_SCOPE>'
          }
          {
            name: 'APP_REDIRECT_URL'
            value: '/'
          }
          {
            name: 'APP_POST_REDIRECT_URL'
            value: '/'
          }
          {
            name: 'APP_CONSOLE_LOG_ENABLED'
            value: 'false'
          }
        ]
      }
    ]
  }
}

// ========== Container App Workflow ========== //
module avmContainerApp_Workflow 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app-wkfl.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-wkfl'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'ca-${solutionSuffix}-wkfl'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: ''
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
          {
            name: 'APP_LOGGING_LEVEL'
            value: 'INFO'
          }
          {
            name: 'AZURE_PACKAGE_LOGGING_LEVEL'
            value: 'WARNING'
          }
          {
            name: 'AZURE_LOGGING_PACKAGES'
            value: ''
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: enableMonitoring ? applicationInsights!.outputs.connectionString : ''
          }
          {
            name: 'OTEL_SERVICE_NAME'
            value: 'ContentProcessorWorkflow'
          }
        ]
      }
    ]
    activeRevisionsMode: 'Single'
    ingressExternal: false
    disableIngress: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
    }
  }
}

// ========== Cosmos Database for Mongo DB ========== //
module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.21.1' = {
  name: take('avm.res.document-db.database-account.${solutionSuffix}', 64)
  params: {
    name: 'cosmos-${solutionSuffix}'
    location: location
    mongodbDatabases: [
      {
        name: 'default'
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    serverVersion: '7.0'
    capabilitiesToAdd: [
      'EnableMongo'
    ]
    enableAnalyticalStorage: true
    defaultConsistencyLevel: 'Session'
    maxIntervalInSeconds: 5
    maxStalenessPrefix: 100
    // WAF aligned configuration for Reliability: zone-redundant Cosmos DB when redundancy is enabled
    zoneRedundant: enableRedundancy
    failoverLocations: enableRedundancy
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: location
          }
        ]
      : null

    // WAF related parameters
    networkRestrictions: {
      publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
      ipRules: []
      virtualNetworkRules: []
    }

    privateEndpoints: (enablePrivateNetworking)
      ? [
          {
            name: 'pep-cosmosdb-${solutionSuffix}'
            customNetworkInterfaceName: 'nic-cosmosdb-${solutionSuffix}'
            privateEndpointResourceId: virtualNetwork!.outputs.resourceId
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  name: 'cosmosdb-dns-zone-group'
                  privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB]!.outputs.resourceId
                }
              ]
            }
            service: 'MongoDB'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId // Use the backend subnet
          }
        ]
      : []
  }
}

// ========== App Configuration ========== //
module avmAppConfig 'br/public:avm/res/app-configuration/configuration-store:0.10.0' = {
  name: take('avm.res.app.configuration-store.${solutionSuffix}', 64)
  params: {
    name: 'appcs-${solutionSuffix}'
    location: location
    enablePurgeProtection: enablePurgeProtection
    tags: {
      app: solutionSuffix
      location: location
    }
    enableTelemetry: enableTelemetry
    managedIdentities: { systemAssigned: true }
    sku: 'Standard'
    diagnosticSettings: enableMonitoring
      ? [
          {
            workspaceResourceId: enableMonitoring ? logAnalyticsWorkspace!.outputs.resourceId : ''
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
          }
        ]
      : null
    disableLocalAuth: false
    replicaLocations: (location != secondaryLocation) ? [{ replicaLocation: secondaryLocation }] : []
    roleAssignments: [
      {
        principalId: avmContainerApp.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_API.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_Web.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_Workflow.outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalType: 'ServicePrincipal'
      }
    ]
    keyValues: [
      {
        name: 'APP_AZURE_OPENAI_ENDPOINT'
        value: avmAiServices.outputs.endpoint //TODO: replace with actual endpoint
      }
      {
        name: 'APP_AZURE_OPENAI_MODEL'
        value: gptModelName
      }
      {
        name: 'APP_CONTENT_UNDERSTANDING_ENDPOINT'
        value: avmAiServices.outputs.endpoint // Content Understanding is served from the same AIServices account as Azure OpenAI
      }
      {
        name: 'APP_COSMOS_CONTAINER_PROCESS'
        value: 'Processes'
      }
      {
        name: 'APP_COSMOS_CONTAINER_SCHEMA'
        value: 'Schemas'
      }
      {
        name: 'APP_COSMOS_CONTAINER_SCHEMASET'
        value: 'SchemaSets'
      }
      {
        name: 'AZURE_PACKAGE_LOGGING_LEVEL'
        value: 'WARNING'
      }
      {
        name: 'AZURE_LOGGING_PACKAGES'
        value: ''
      }
      {
        name: 'APP_COSMOS_DATABASE'
        value: 'ContentProcess'
      }
      {
        name: 'APP_CPS_CONFIGURATION'
        value: 'cps-configuration'
      }
      {
        name: 'APP_CPS_MAX_FILESIZE_MB'
        value: '20'
      }
      {
        name: 'APP_CPS_PROCESSES'
        value: 'cps-processes'
      }
      {
        name: 'APP_LOGGING_ENABLE'
        value: 'False'
      }
      {
        name: 'APP_LOGGING_LEVEL'
        value: 'INFO'
      }
      {
        name: 'APP_MESSAGE_QUEUE_EXTRACT'
        value: 'content-pipeline-extract-queue'
      }
      {
        name: 'APP_MESSAGE_QUEUE_INTERVAL'
        value: '5'
      }
      {
        name: 'APP_MESSAGE_QUEUE_PROCESS_TIMEOUT'
        value: '180'
      }
      {
        name: 'APP_MESSAGE_QUEUE_VISIBILITY_TIMEOUT'
        value: '10'
      }
      {
        name: 'APP_PROCESS_STEPS'
        value: 'extract,map,evaluate,save'
      }
      {
        name: 'APP_STORAGE_BLOB_URL'
        value: avmStorageAccount.outputs.serviceEndpoints.blob
      }
      {
        name: 'APP_STORAGE_QUEUE_URL'
        value: avmStorageAccount.outputs.serviceEndpoints.queue
      }
      {
        name: 'APP_AI_PROJECT_ENDPOINT'
        value: avmAiServices.outputs.aiProjectInfo.?apiEndpoint ?? ''
      }
      {
        name: 'APP_COSMOS_CONNSTR'
        value: avmCosmosDB.outputs.primaryReadWriteConnectionString
      }
      // ===== v2 Workflow Keys ===== //
      {
        name: 'APP_COSMOS_CONTAINER_BATCH_PROCESS'
        value: 'claimprocesses'
      }
      {
        name: 'APP_COSMOS_CONTAINER_BATCHES'
        value: 'batches'
      }
      {
        name: 'APP_CPS_PROCESS_BATCH'
        value: 'process-batch'
      }
      {
        name: 'APP_CPS_CONTENT_PROCESS_ENDPOINT'
        value: 'http://${avmContainerApp_API.outputs.name}/'
      }
      {
        name: 'APP_CPS_POLL_INTERVAL_SECONDS'
        value: '3'
      }
      {
        name: 'APP_STORAGE_ACCOUNT_NAME'
        value: avmStorageAccount.outputs.name
      }
      {
        name: 'CLAIM_PROCESS_QUEUE_NAME'
        value: 'claim-process-queue'
      }
      {
        name: 'DEAD_LETTER_QUEUE_NAME'
        value: 'claim-process-dead-letter-queue'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: avmAiServices.outputs.endpoint
      }
      {
        name: 'AZURE_OPENAI_CHAT_DEPLOYMENT_NAME'
        value: gptModelName
      }
      {
        name: 'AZURE_OPENAI_API_VERSION'
        value: '2025-03-01-preview'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT_BASE'
        value: avmAiServices.outputs.endpoint
      }
      // ===== Agent Framework Keys ===== //
      {
        name: 'AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME'
        value: ''
      }
      {
        name: 'AZURE_AI_AGENT_PROJECT_CONNECTION_STRING'
        value: ''
      }
      {
        name: 'AZURE_TRACING_ENABLED'
        value: 'True'
      }
      {
        name: 'GLOBAL_LLM_SERVICE'
        value: 'AzureOpenAI'
      }
      // ===== GPT-5 Service Prefix Keys ===== //
      {
        name: 'GPT5_API_VERSION'
        value: '2025-03-01-preview'
      }
      {
        name: 'GPT5_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-5'
      }
      {
        name: 'GPT5_ENDPOINT'
        value: avmAiServices.outputs.endpoint
      }
      // ===== PHI-4 Service Prefix Keys ===== //
      {
        name: 'PHI4_API_VERSION'
        value: '2024-05-01-preview'
      }
      {
        name: 'PHI4_CHAT_DEPLOYMENT_NAME'
        value: 'phi-4'
      }
      {
        name: 'PHI4_ENDPOINT'
        value: avmAiServices.outputs.endpoint
      }
    ]

    publicNetworkAccess: 'Enabled'
  }
}

module avmAppConfig_update 'br/public:avm/res/app-configuration/configuration-store:0.10.0' = if (enablePrivateNetworking) {
  name: take('avm.res.app.configuration-store.update.${solutionSuffix}', 64)
  params: {
    name: 'appcs-${solutionSuffix}'
    location: location
    enablePurgeProtection: enablePurgeProtection
    enableTelemetry: enableTelemetry
    tags: tags
    publicNetworkAccess: 'Disabled'
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
        subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId // Use the backend subnet
      }
    ]
  }

  dependsOn: [
    avmAppConfig
  ]
}

// ========== Container App Update Modules ========== //
module avmContainerApp_update 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app-update.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-app'
    location: location
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: 'ca-${solutionSuffix}'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: avmAppConfig.outputs.endpoint
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
        ]
      }
    ]
    activeRevisionsMode: 'Single'
    ingressExternal: false
    disableIngress: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
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
  }
}

module avmContainerApp_API_update 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app-api.update.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-api'
    location: location
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: 'ca-${solutionSuffix}-api'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: avmAppConfig.outputs.endpoint
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
        ]
        probes: [
          // Liveness Probe - Checks if the app is still running
          {
            type: 'Liveness'
            httpGet: {
              path: '/startup' // Your app must expose this endpoint
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          // Readiness Probe - Checks if the app is ready to receive traffic
          {
            type: 'Readiness'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 5
            periodSeconds: 10
            failureThreshold: 3
          }
          {
            type: 'Startup'
            httpGet: {
              path: '/startup'
              port: 80
              scheme: 'HTTP'
            }
            initialDelaySeconds: 20 // Wait 10s before checking
            periodSeconds: 5 // Check every 15s
            failureThreshold: 10 // Restart if it fails 5 times
          }
        ]
      }
    ]
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    ingressExternal: true
    activeRevisionsMode: 'Single'
    ingressTransport: 'auto'
    corsPolicy: {
      allowedOrigins: [
        '*'
      ]
      allowedMethods: [
        'GET'
        'POST'
        'PUT'
        'DELETE'
        'OPTIONS'
      ]
      allowedHeaders: [
        'Authorization'
        'Content-Type'
        '*'
      ]
    }
  }
}

// ========== Container App Workflow (update) ========== //
// NOTE: this module is required to patch the Workflow container app with its
// real APP_CONFIG_ENDPOINT (and other settings) once App Configuration exists.
// Without it, the workflow container is stuck with an empty APP_CONFIG_ENDPOINT
// from its bootstrap deployment and crash-loops with:
//   AttributeError: 'NoneType' object has no attribute 'endpoint'
// because it cannot resolve AZURE_OPENAI settings from App Configuration.
module avmContainerApp_Workflow_update 'br/public:avm/res/app/container-app:0.23.0' = {
  name: take('avm.res.app.container-app-wkfl.update.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-wkfl'
    location: location
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: [
      {
        server: avmContainerRegistry.outputs.loginServer
        identity: avmContainerRegistryReader.outputs.resourceId
      }
    ]
    tags: tags
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'ca-${solutionSuffix}-wkfl'
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        resources: {
          cpu: 4
          memory: '8.0Gi'
        }
        env: [
          {
            name: 'APP_CONFIG_ENDPOINT'
            value: avmAppConfig.outputs.endpoint
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
          {
            name: 'APP_LOGGING_LEVEL'
            value: 'INFO'
          }
          {
            name: 'AZURE_PACKAGE_LOGGING_LEVEL'
            value: 'WARNING'
          }
          {
            name: 'AZURE_LOGGING_PACKAGES'
            value: ''
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: enableMonitoring ? applicationInsights!.outputs.connectionString : ''
          }
          {
            name: 'OTEL_SERVICE_NAME'
            value: 'ContentProcessorWorkflow'
          }
        ]
      }
    ]
    activeRevisionsMode: 'Single'
    ingressExternal: false
    disableIngress: true
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 2
      minReplicas: enableScalability ? 2 : 1
    }
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the Container App web application.')
output containerWebAppName string = avmContainerApp_Web.outputs.name

@description('The name of the Container App API application.')
output containerApiAppName string = avmContainerApp_API.outputs.name

@description('The FQDN of the Container App web application.')
output containerWebAppFqdn string = avmContainerApp_Web.outputs.fqdn

@description('The FQDN of the Container App API application.')
output containerApiAppFqdn string = avmContainerApp_API.outputs.fqdn

@description('The name of the Container App workflow application.')
output containerWorkflowAppName string = avmContainerApp_Workflow.outputs.name

@description('The FQDN of the Container App workflow application.')
output containerWorkflowAppFqdn string = avmContainerApp_Workflow.outputs.fqdn

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name
