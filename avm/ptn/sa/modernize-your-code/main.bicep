metadata name = 'Modernize Your Code Solution Accelerator'
metadata description = '''This module contains the resources required to deploy the [Modernize-your-code-solution-accelerator](https://github.com/microsoft/Modernize-your-code-solution-accelerator) for both Sandbox environments and WAF aligned environments.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Modernize-your-code-solution-accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''
targetScope = 'resourceGroup'

@minLength(3)
@maxLength(16)
@description('Required. A unique application/solution name for all resources in this deployment. This should be 3-16 characters long.')
param solutionName string

@maxLength(5)
@description('Optional. A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
param solutionUniqueToken string = substring(uniqueString(subscription().id, resourceGroup().name, solutionName), 0, 5)

@minLength(3)
@metadata({ azd: { type: 'location' } })
@description('Optional. Azure region for all services. Defaults to the resource group location.')
param location string = resourceGroup().location

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
      'OpenAI.GlobalStandard.gpt-4o, 150'
    ]
  }
})
@description('Required. Location for all AI service resources. This location can be different from the resource group location.')
param azureAiServiceLocation string

@description('Optional. AI model deployment token capacity. Defaults to 150K tokens per minute.')
param gptModelCapacity int = 150

@description('Optional. Enable monitoring for the resources. This will enable Application Insights and Log Analytics. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable scaling for the container apps. Defaults to false.')
param enableScaling bool = false

@description('Optional. Enable redundancy for applicable resources. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. The secondary location for the Cosmos DB account if redundancy is enabled.')
param secondaryLocation string?

@description('Optional. Enable private networking for the resources. Set to true to enable private networking. Defaults to false.')
param enablePrivateNetworking bool = false

@description('Optional. Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.')
param vmSize string?

@description('Optional. Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
//param vmAdminUsername string = take(newGuid(), 20)
param vmAdminUsername string?

@description('Optional. Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.')
@secure()
//param vmAdminPassword string = newGuid()
param vmAdminPassword string?

@description('Optional. Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@minLength(1)
@description('Optional. GPT model deployment type. Defaults to GlobalStandard.')
param gptModelDeploymentType string = 'GlobalStandard'

@minLength(1)
@description('Optional. Name of the GPT model to deploy. Defaults to gpt-4o.')
param gptModelName string = 'gpt-4o'

@minLength(1)
@description('Optional. Set the Image tag. Defaults to latest_2026-04-27_934.')
param imageVersion string = 'latest_2026-04-27_934'

@description('Optional. Azure Container Registry name. Defaults to cmsacontainerreg.azurecr.io.')
param acrName string = 'cmsacontainerreg.azurecr.io'

@minLength(1)
@description('Optional. Version of the GPT model to deploy. Defaults to 2024-08-06.')
param gptModelVersion string = '2024-08-06'

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
var replicaLocation = replicaRegionPairs[resourceGroup().location]

// @description('Optional. Use this parameter to use an existing AI project resource ID. Defaults to empty string.')
// param azureExistingAIProjectResourceId string = ''

// @description('Optional. Use this parameter to use an existing Log Analytics workspace resource ID. Defaults to empty string.')
// param existingLogAnalyticsWorkspaceId string = ''

var allTags = union(
  {
    'azd-env-name': solutionName
  },
  tags
)

var solutionSuffix = toLower(trim(replace(
  replace(
    replace(replace(replace(replace('${solutionName}${solutionUniqueToken}', '-', ''), '_', ''), '.', ''), '/', ''),
    ' ',
    ''
  ),
  '*',
  ''
)))

var modelDeployment = {
  name: gptModelName
  model: {
    name: gptModelName
    format: 'OpenAI'
    version: gptModelVersion
  }
  sku: {
    name: gptModelDeploymentType
    capacity: gptModelCapacity
  }
  raiPolicyName: 'Microsoft.Default'
}

@description('Optional. Tag, Created by user name. Defaults to user principal name or object ID.')
param createdBy string = contains(deployer(), 'userPrincipalName')
  ? split(deployer().userPrincipalName, '@')[0]
  : deployer().objectId

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2025-04-01' = {
  name: 'default'
  properties: {
    tags: {
      ...resourceGroup().tags
      ...allTags
      TemplateName: 'Code Modernization'
      Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
      CreatedBy: createdBy
      DeploymentName: deployment().name
    }
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-11-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-modernizeyourcode.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

module appIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${solutionSuffix}', 64)
  params: {
    name: 'id-${solutionSuffix}'
    location: location
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// WAF PSRules for Log Analytics: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#azure-monitor-logs
// Deploy new Log Analytics workspace only if required and not using existing
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.15.0' = if (enableMonitoring || enablePrivateNetworking) {
  name: take('avm.res.operational-insights.workspace.${solutionSuffix}', 64)
  params: {
    name: 'log-${solutionSuffix}'
    location: location
    skuName: 'PerGB2018'
    dataRetention: 365
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    diagnosticSettings: [{ useThisWorkspace: true }]
    tags: allTags
    enableTelemetry: enableTelemetry
    // WAF aligned configuration for Redundancy
    dailyQuotaGb: enableRedundancy ? '10' : null //WAF recommendation: 10 GB per day is a good starting point for most workloads
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
            tags: allTags
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

// Log Analytics workspace ID and name (existing or new)
var logAnalyticsWorkspaceResourceId = logAnalyticsWorkspace!.outputs.resourceId
var logAnalyticsWorkspaceName = logAnalyticsWorkspace!.outputs.name

// ========== Application Insights ========== //
// WAF best practices for Application Insights: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/application-insights
// WAF PSRules for  Application Insights: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#application-insights
module applicationInsights 'br/public:avm/res/insights/component:0.7.1' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${solutionSuffix}', 64)
  params: {
    name: 'appi-${solutionSuffix}'
    location: location
    workspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    tags: allTags
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    disableLocalAuth: true
    flowType: 'Bluefield'
    // WAF aligned configuration for Private Networking - block public ingestion/query
    publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
  }
}

// ========== Data Collection Endpoint (DCE) ========== //
// Required for Azure Monitor Private Link - provides private ingestion and configuration endpoints
// Per: https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-configure
module dataCollectionEndpoint 'br/public:avm/res/insights/data-collection-endpoint:0.5.1' = if (enablePrivateNetworking && enableMonitoring) {
  name: take('avm.res.insights.data-collection-endpoint.${solutionSuffix}', 64)
  params: {
    name: 'dce-${solutionSuffix}'
    location: location
    kind: 'Windows'
    publicNetworkAccess: 'Disabled'
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

// Virtual Network with NSGs and Subnets
module virtualNetwork 'modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtualNetwork.${solutionSuffix}', 64)
  params: {
    name: 'vnet-${solutionSuffix}'
    addressPrefixes: ['10.0.0.0/20'] // 4096 addresses (enough for 8 /23 subnets or 16 /24)
    location: location
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    resourceSuffix: solutionSuffix
    enableTelemetry: enableTelemetry
  }
}

// ========== Private DNS Zones ========== //
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.documents.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.monitor.azure.com' // Azure Monitor global endpoints (App Insights, DCE)
  'privatelink.oms.opinsights.azure.com' // Log Analytics OMS endpoints
  'privatelink.ods.opinsights.azure.com' // Log Analytics ODS ingestion endpoints
  'privatelink.agentsvc.azure-automation.net' // Agent service automation endpoints
]

// DNS Zone Index Constants
var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  cosmosDB: 3
  keyVault: 4
  storageBlob: 5
  storageFile: 6
  monitor: 7
  oms: 8
  ods: 9
  agentSvc: 10
}

// ===================================================
// DEPLOY PRIVATE DNS ZONES
// - Deploys all zones if no existing Foundry project is used
// - Excludes AI-related zones when using with an existing Foundry project
// ===================================================
@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.8.1' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking) {
    name: take('avm.res.network.private-dns-zone.${split(zone, '.')[1]}.${solutionSuffix}', 64)
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

// ========== Azure Monitor Private Link Scope (AMPLS) ========== //
// Step 1: Create AMPLS
// Step 2: Connect Azure Monitor resources (LAW, Application Insights, DCE) to the AMPLS
// Step 3: Connect AMPLS to a private endpoint with required DNS zones
// Per: https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-configure
module azureMonitorPrivateLinkScope 'br/public:avm/res/insights/private-link-scope:0.7.2' = if (enablePrivateNetworking) {
  name: take('avm.res.insights.private-link-scope.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [logAnalyticsWorkspace, applicationInsights, dataCollectionEndpoint, virtualNetwork]
  params: {
    name: 'ampls-${solutionSuffix}'
    location: 'global'
    // Access mode: PrivateOnly ensures all ingestion and queries go through private link
    accessModeSettings: {
      ingestionAccessMode: 'PrivateOnly'
      queryAccessMode: 'PrivateOnly'
    }
    // Step 2: Connect Azure Monitor resources to the AMPLS as scoped resources
    scopedResources: concat(
      [
        {
          name: 'scoped-law'
          linkedResourceId: logAnalyticsWorkspaceResourceId
        }
      ],
      enableMonitoring
        ? [
            {
              name: 'scoped-appi'
              linkedResourceId: applicationInsights!.outputs.resourceId
            }
            {
              name: 'scoped-dce'
              linkedResourceId: dataCollectionEndpoint!.outputs.resourceId
            }
          ]
        : []
    )
    // Step 3: Connect AMPLS to a private endpoint
    // The private endpoint requires 5 DNS zones per documentation:
    // - privatelink.monitor.azure.com (App Insights + DCE global endpoints)
    // - privatelink.oms.opinsights.azure.com (Log Analytics OMS)
    // - privatelink.ods.opinsights.azure.com (Log Analytics ODS ingestion)
    // - privatelink.agentsvc.azure-automation.net (Agent service automation)
    // - privatelink.blob.core.windows.net (Agent solution packs storage)
    privateEndpoints: [
      {
        name: 'pep-ampls-${solutionSuffix}'
        subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.monitor]!.outputs.resourceId
            }
            {
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.oms]!.outputs.resourceId
            }
            {
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.ods]!.outputs.resourceId
            }
            {
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.agentSvc]!.outputs.resourceId
            }
            {
              privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob]!.outputs.resourceId
            }
          ]
        }
      }
    ]
    tags: allTags
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
    diagnosticSettings: [
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
    tags: tags
    enableTelemetry: enableTelemetry
    publicIPAddressObject: {
      name: 'pip-${bastionHostName}'
      availabilityZones: enableRedundancy ? [1, 2, 3] : []
    }
  }
}

// ========== Jumpbox Virtual machine ========== //
var maintenanceConfigurationResourceName = 'mc-${solutionSuffix}'
module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.4.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${maintenanceConfigurationResourceName}', 64)
  params: {
    name: maintenanceConfigurationResourceName
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

var dataCollectionRulesResourceName = 'dcr-${solutionSuffix}'
var dataCollectionRulesLocation = logAnalyticsWorkspace!.outputs.location
module windowsVmDataCollectionRules 'br/public:avm/res/insights/data-collection-rule:0.11.0' = if (enablePrivateNetworking && enableMonitoring) {
  name: take('avm.res.insights.data-collection-rule.${dataCollectionRulesResourceName}', 64)
  params: {
    name: dataCollectionRulesResourceName
    tags: tags
    enableTelemetry: enableTelemetry
    location: dataCollectionRulesLocation
    dataCollectionRuleProperties: {
      kind: 'Windows'
      dataCollectionEndpointResourceId: dataCollectionEndpoint!.outputs.resourceId
      dataSources: {
        performanceCounters: [
          {
            streams: [
              'Microsoft-Perf'
            ]
            samplingFrequencyInSeconds: 60
            counterSpecifiers: [
              '\\Processor Information(_Total)\\% Processor Time'
              '\\Processor Information(_Total)\\% Privileged Time'
              '\\Processor Information(_Total)\\% User Time'
              '\\Processor Information(_Total)\\Processor Frequency'
              '\\System\\Processes'
              '\\Process(_Total)\\Thread Count'
              '\\Process(_Total)\\Handle Count'
              '\\System\\System Up Time'
              '\\System\\Context Switches/sec'
              '\\System\\Processor Queue Length'
              '\\Memory\\% Committed Bytes In Use'
              '\\Memory\\Available Bytes'
              '\\Memory\\Committed Bytes'
              '\\Memory\\Cache Bytes'
              '\\Memory\\Pool Paged Bytes'
              '\\Memory\\Pool Nonpaged Bytes'
              '\\Memory\\Pages/sec'
              '\\Memory\\Page Faults/sec'
              '\\Process(_Total)\\Working Set'
              '\\Process(_Total)\\Working Set - Private'
              '\\LogicalDisk(_Total)\\% Disk Time'
              '\\LogicalDisk(_Total)\\% Disk Read Time'
              '\\LogicalDisk(_Total)\\% Disk Write Time'
              '\\LogicalDisk(_Total)\\% Idle Time'
              '\\LogicalDisk(_Total)\\Disk Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Transfers/sec'
              '\\LogicalDisk(_Total)\\Disk Reads/sec'
              '\\LogicalDisk(_Total)\\Disk Writes/sec'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
              '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
              '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
              '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
              '\\LogicalDisk(_Total)\\% Free Space'
              '\\LogicalDisk(_Total)\\Free Megabytes'
              '\\Network Interface(*)\\Bytes Total/sec'
              '\\Network Interface(*)\\Bytes Sent/sec'
              '\\Network Interface(*)\\Bytes Received/sec'
              '\\Network Interface(*)\\Packets/sec'
              '\\Network Interface(*)\\Packets Sent/sec'
              '\\Network Interface(*)\\Packets Received/sec'
              '\\Network Interface(*)\\Packets Outbound Errors'
              '\\Network Interface(*)\\Packets Received Errors'
            ]
            name: 'perfCounterDataSource60'
          }
        ]
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            name: 'la-${dataCollectionRulesResourceName}'
          }
        ]
      }
      dataFlows: [
        {
          streams: [
            'Microsoft-Perf'
          ]
          destinations: [
            'la-${dataCollectionRulesResourceName}'
          ]
        }
      ]
    }
  }
}

var proximityPlacementGroupResourceName = 'ppg-${solutionSuffix}'
module proximityPlacementGroup 'br/public:avm/res/compute/proximity-placement-group:0.4.1' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.proximity-placement-group.${proximityPlacementGroupResourceName}', 64)
  params: {
    name: proximityPlacementGroupResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    availabilityZone: enableRedundancy ? 1 : -1
    intent: enableRedundancy
      ? {
          vmSizes: [
            vmSize ?? 'Standard_D2s_v3'
          ]
        }
      : null
  }
}

var virtualMachineResourceName = take('vm-${solutionSuffix}', 15)
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.22.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${virtualMachineResourceName}', 64)
  params: {
    name: virtualMachineResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    computerName: take(virtualMachineResourceName, 15)
    osType: 'Windows'
    vmSize: vmSize ?? 'Standard_D2s_v3'
    adminUsername: vmAdminUsername ?? 'JumpboxAdminUser'
    adminPassword: vmAdminPassword
    managedIdentities: {
      systemAssigned: true
    }
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration!.outputs.resourceId
    enableAutomaticUpdates: true
    encryptionAtHost: false
    proximityPlacementGroupResourceId: proximityPlacementGroup!.outputs.resourceId
    availabilityZone: enableRedundancy ? 1 : -1
    imageReference: {
      publisher: 'microsoft-dsvm'
      offer: 'dsvm-win-2022'
      sku: 'winserver-2022'
      version: 'latest'
    }
    osDisk: {
      name: 'osdisk-${virtualMachineResourceName}'
      caching: 'ReadWrite'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        // WAF aligned configuration - use Premium storage for better SLA when redundancy is enabled
        storageAccountType: enableRedundancy ? 'Premium_LRS' : 'Standard_LRS'
      }
    }
    nicConfigurations: [
      {
        name: 'nic-${virtualMachineResourceName}'
        tags: tags
        deleteOption: 'Delete'
        diagnosticSettings: enableMonitoring //WAF aligned configuration for Monitoring
          ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
          : null
        ipConfigurations: [
          {
            name: '${virtualMachineResourceName}-nic01-ipconfig01'
            subnetResourceId: virtualNetwork!.outputs.jumpboxSubnetResourceId
            diagnosticSettings: enableMonitoring //WAF aligned configuration for Monitoring
              ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
              : null
          }
        ]
      }
    ]
    extensionAadJoinConfig: {
      enabled: true
      tags: tags
      typeHandlerVersion: '1.0'
      settings: {
        mdmId: ''
      }
    }
    extensionAntiMalwareConfig: {
      enabled: true
      settings: {
        AntimalwareEnabled: 'true'
        Exclusions: {}
        RealtimeProtectionEnabled: 'true'
        ScheduledScanSettings: {
          day: '7'
          isEnabled: 'true'
          scanType: 'Quick'
          time: '120'
        }
      }
      tags: tags
    }
    //WAF aligned configuration for Monitoring
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
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: tags
    }
  }
}

module aiServices 'modules/ai-foundry/aifoundry.bicep' = {
  name: take('module.aifoundry.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [logAnalyticsWorkspace, virtualNetwork] // required due to optional flags that could change dependency
  params: {
    name: 'aif-${solutionSuffix}'
    location: azureAiServiceLocation
    sku: 'S0'
    kind: 'AIServices'
    deployments: [modelDeployment]
    projectName: 'proj-${solutionSuffix}'
    projectDescription: 'proj-${solutionSuffix}'
    logAnalyticsWorkspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    privateNetworking: null // Private endpoint is handled by the standalone aiFoundryPrivateEndpoint module
    disableLocalAuth: true //Should be set to true for WAF aligned configuration
    customSubDomainName: 'aif-${solutionSuffix}'
    apiProperties: {
      //staticsEnabled: false
    }
    allowProjectManagement: true
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    privateEndpoints: []
    roleAssignments: [
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
      }
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee' // Azure AI Developer
      }
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
      }
    ]
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

var aiFoundryAiServicesResourceName = 'aif-${solutionSuffix}'

module aiFoundryPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.12.0' = if (enablePrivateNetworking) {
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
          privateLinkServiceId: aiServices.outputs.resourceId
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
    subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
  }
}

var appStorageContainerName = 'appstorage'

module storageAccount 'modules/storageAccount.bicep' = {
  name: take('module.storageAccount.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [logAnalyticsWorkspace, virtualNetwork] // required due to optional flags that could change dependency
  params: {
    name: take('st${solutionSuffix}', 24)
    location: location
    tags: allTags
    skuName: enableRedundancy ? 'Standard_GZRS' : 'Standard_LRS'
    logAnalyticsWorkspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    privateNetworking: enablePrivateNetworking
      ? {
          virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
          subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
          blobPrivateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageBlob]!.outputs.resourceId
          filePrivateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.storageFile]!.outputs.resourceId
        }
      : null
    containers: [
      {
        name: appStorageContainerName
        properties: {
          publicAccess: 'None'
        }
      }
    ]
    roleAssignments: [
      {
        principalId: appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module keyVault 'modules/keyVault.bicep' = {
  name: take('module.keyVault.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [logAnalyticsWorkspace, virtualNetwork] // required due to optional flags that could change dependency
  params: {
    name: take('kv-${solutionSuffix}', 24)
    location: location
    sku: 'standard'
    logAnalyticsWorkspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    privateNetworking: enablePrivateNetworking
      ? {
          virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
          subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.keyVault]!.outputs.resourceId
        }
      : null
    roleAssignments: [
      {
        principalId: aiServices.outputs.?systemAssignedMIPrincipalId ?? appIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Key Vault Administrator'
      }
    ]
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

module cosmosDb 'modules/cosmosDb.bicep' = {
  name: take('module.cosmosDb.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [logAnalyticsWorkspace, virtualNetwork] // required due to optional flags that could change dependency
  params: {
    name: take('cosmos-${solutionSuffix}', 44)
    location: location
    dataAccessIdentityPrincipalId: appIdentity.outputs.principalId
    logAnalyticsWorkspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    zoneRedundant: enableRedundancy
    secondaryLocation: enableRedundancy && !empty(secondaryLocation) ? secondaryLocation : ''
    privateNetworking: enablePrivateNetworking
      ? {
          virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
          subnetResourceId: virtualNetwork!.outputs.pepsSubnetResourceId
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDB]!.outputs.resourceId
        }
      : null
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

var containerAppsEnvironmentName = 'cae-${solutionSuffix}'

module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.13.2' = {
  name: take('avm.res.app.managed-environment.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [applicationInsights, logAnalyticsWorkspace, virtualNetwork] // required due to optional flags that could change dependency
  params: {
    name: containerAppsEnvironmentName
    infrastructureResourceGroupName: '${resourceGroup().name}-ME-${containerAppsEnvironmentName}'
    location: location
    zoneRedundant: enableRedundancy && enablePrivateNetworking
    publicNetworkAccess: 'Enabled' // public access required for frontend
    infrastructureSubnetResourceId: enablePrivateNetworking ? virtualNetwork!.outputs.webSubnetResourceId : null
    managedIdentities: {
      userAssignedResourceIds: [
        appIdentity.outputs.resourceId
      ]
    }
    appInsightsConnectionString: enableMonitoring ? applicationInsights!.outputs.connectionString : null
    appLogsConfiguration: enableMonitoring
      ? {
          destination: 'log-analytics'
          logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
        }
      : null
    workloadProfiles: enablePrivateNetworking
      ? [
          // NOTE: workload profiles are required for private networking
          {
            name: 'Consumption'
            workloadProfileType: 'Consumption'
          }
        ]
      : []
    tags: allTags
    enableTelemetry: enableTelemetry
  }
}

module containerAppBackend 'br/public:avm/res/app/container-app:0.22.1' = {
  name: take('avm.res.app.container-app.backend.${solutionSuffix}', 64)
  #disable-next-line no-unnecessary-dependson
  dependsOn: [applicationInsights] // required due to optional flags that could change dependency
  params: {
    name: take('ca-backend-${solutionSuffix}', 32)
    location: location
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        appIdentity.outputs.resourceId
      ]
    }
    containers: [
      {
        name: 'cmsabackend'
        image: '${acrName}/cmsabackend:${imageVersion}'
        env: concat(
          [
            {
              name: 'COSMOSDB_ENDPOINT'
              value: cosmosDb.outputs.endpoint
            }
            {
              name: 'COSMOSDB_DATABASE'
              value: cosmosDb.outputs.databaseName
            }
            {
              name: 'COSMOSDB_BATCH_CONTAINER'
              value: cosmosDb.outputs.containerNames.batch
            }
            {
              name: 'COSMOSDB_FILE_CONTAINER'
              value: cosmosDb.outputs.containerNames.file
            }
            {
              name: 'COSMOSDB_LOG_CONTAINER'
              value: cosmosDb.outputs.containerNames.log
            }
            {
              name: 'AZURE_BLOB_ACCOUNT_NAME'
              value: storageAccount.outputs.name
            }
            {
              name: 'AZURE_BLOB_CONTAINER_NAME'
              value: appStorageContainerName
            }
            {
              name: 'MIGRATOR_AGENT_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'PICKER_AGENT_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'FIXER_AGENT_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'SEMANTIC_VERIFIER_AGENT_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'SYNTAX_CHECKER_AGENT_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'SELECTION_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'TERMINATION_MODEL_DEPLOY'
              value: modelDeployment.name
            }
            {
              name: 'AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME'
              value: modelDeployment.name
            }
            {
              name: 'AI_PROJECT_ENDPOINT'
              value: aiServices.outputs.aiProjectInfo.apiEndpoint // or equivalent
            }
            {
              name: 'AZURE_AI_AGENT_PROJECT_CONNECTION_STRING' // This was not really used in code.
              value: aiServices.outputs.aiProjectInfo.apiEndpoint
            }
            {
              name: 'AZURE_AI_AGENT_PROJECT_NAME'
              value: aiServices.outputs.aiProjectInfo.name
            }
            {
              name: 'AZURE_AI_AGENT_RESOURCE_GROUP_NAME'
              value: resourceGroup().name
            }
            {
              name: 'AZURE_AI_AGENT_SUBSCRIPTION_ID'
              value: subscription().subscriptionId
            }
            {
              name: 'AZURE_AI_AGENT_ENDPOINT'
              value: aiServices.outputs.aiProjectInfo.apiEndpoint
            }
            {
              name: 'AZURE_CLIENT_ID'
              value: appIdentity.outputs.clientId // NOTE: This is the client ID of the managed identity, not the Entra application, and is needed for the App Service to access the Cosmos DB account.
            }
            {
              name: 'APP_ENV'
              value: 'prod'
            }
            {
              name: 'AZURE_BASIC_LOGGING_LEVEL'
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
          ],
          enableMonitoring
            ? [
                {
                  name: 'APPLICATIONINSIGHTS_INSTRUMENTATION_KEY'
                  value: applicationInsights!.outputs.instrumentationKey
                }
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
        probes: enableMonitoring
          ? [
              {
                httpGet: {
                  path: '/health'
                  port: 8000
                }
                initialDelaySeconds: 3
                periodSeconds: 3
                type: 'Liveness'
              }
            ]
          : []
      }
    ]
    ingressTargetPort: 8000
    ingressExternal: true
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: 2
      rules: enableScaling
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

module containerAppFrontend 'br/public:avm/res/app/container-app:0.22.1' = {
  name: take('avm.res.app.container-app.frontend.${solutionSuffix}', 64)
  params: {
    name: take('ca-frontend-${solutionSuffix}', 32)
    location: location
    environmentResourceId: containerAppsEnvironment.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        appIdentity.outputs.resourceId
      ]
    }
    containers: [
      {
        env: [
          {
            name: 'API_URL'
            value: 'https://${containerAppBackend.outputs.fqdn}'
          }
          {
            name: 'APP_ENV'
            value: 'prod'
          }
        ]
        image: '${acrName}/cmsafrontend:${imageVersion}'
        name: 'cmsafrontend'
        resources: {
          cpu: 1
          memory: '2.0Gi'
        }
      }
    ]
    ingressTargetPort: 3000
    ingressExternal: true
    scaleSettings: {
      maxReplicas: enableScaling ? 3 : 2
      minReplicas: 2
      rules: enableScaling
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

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The URL of the frontend web application.')
output webAppUrl string = 'https://${containerAppFrontend.outputs.fqdn}'

@description('The endpoint of the Cosmos DB account.')
output cosmosdbEndpoint string = cosmosDb.outputs.endpoint

@description('The name of the storage account.')
output azureBlobAccountName string = storageAccount.outputs.name

@description('The blob endpoint of the storage account.')
output azureBlobEndpoint string = 'https://${storageAccount.outputs.name}.blob.${environment().suffixes.storage}/'

@description('The endpoint of the Azure OpenAI service.')
output azureOpenAIEndpoint string = 'https://${aiServices.outputs.name}.openai.azure.com/'

@description('The name of the Azure AI Agent project.')
output azureAiAgentProjectName string = aiServices.outputs.aiProjectInfo.name

@description('The API endpoint of the Azure AI Agent project.')
output azureAiAgentEndpoint string = aiServices.outputs.aiProjectInfo.apiEndpoint

@description('The connection string of the Azure AI Agent project.')
output azureAiAgentProjectConnectionString string = aiServices.outputs.aiProjectInfo.apiEndpoint

@description('The resource group name of the Azure AI Agent.')
output azureAiAgentResourceGroupName string = resourceGroup().name

@description('The subscription ID of the Azure AI Agent.')
output azureAiAgentSubscriptionId string = subscription().subscriptionId

@description('The API endpoint of the AI project.')
output aiProjectEndpoint string = aiServices.outputs.aiProjectInfo.apiEndpoint

@description('The client ID of the managed identity.')
output azureClientId string = appIdentity.outputs.clientId

@description('The name of the Azure AI Agent model deployment.')
output azureAiAgentModelDeploymentName string = modelDeployment.name

@description('The name of the blob container.')
output azureBlobContainerName string = appStorageContainerName

@description('The name of the Cosmos DB database.')
output cosmosdbDatabase string = cosmosDb.outputs.databaseName

@description('The name of the Cosmos DB batch container.')
output cosmosdbBatchContainer string = cosmosDb.outputs.containerNames.batch

@description('The name of the Cosmos DB file container.')
output cosmosdbFileContainer string = cosmosDb.outputs.containerNames.file

@description('The name of the Cosmos DB log container.')
output cosmosdbLogContainer string = cosmosDb.outputs.containerNames.log

@description('The connection string of Application Insights.')
output applicationInsightsConnectionString string = enableMonitoring
  ? applicationInsights!.outputs.connectionString
  : ''

@description('The model deployment name for the migrator agent.')
output migratorAgentModelDeploy string = modelDeployment.name

@description('The model deployment name for the picker agent.')
output pickerAgentModelDeploy string = modelDeployment.name

@description('The model deployment name for the fixer agent.')
output fixerAgentModelDeploy string = modelDeployment.name

@description('The model deployment name for the semantic verifier agent.')
output semanticVerifierAgentModelDeploy string = modelDeployment.name

@description('The model deployment name for the syntax checker agent.')
output syntaxCheckerAgentModelDeploy string = modelDeployment.name
