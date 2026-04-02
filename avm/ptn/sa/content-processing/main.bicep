// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Content Processing Solution Accelerator'
metadata description = 'Bicep template to deploy the Content Processing Solution Accelerator with AVM compliance.'

// ========== Parameters ========== //
@minLength(3)
@maxLength(20)
@description('Optional. Name of the solution to deploy. This should be 3-20 characters long.')
param solutionName string = 'cps'

@metadata({ azd: { type: 'location' } })
@description('Required. Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions).')
@allowed([
  'australiaeast'
  'centralus'
  'eastasia'
  'eastus2'
  'japaneast'
  'northeurope'
  'southeastasia'
  'uksouth'
])
param location string

@minLength(1)
@description('Optional. Location for the Azure AI Content Understanding service deployment.')
@allowed(['WestUS', 'SwedenCentral', 'AustraliaEast'])
@metadata({
  azd: {
    type: 'location'
  }
})
param contentUnderstandingLocation string = 'WestUS'

@allowed([
  'australiaeast'
  'centralus'
  'eastasia'
  'eastus2'
  'japaneast'
  'northeurope'
  'southeastasia'
  'uksouth'
])
@description('Required. Location for the Azure AI Services deployment.')
@metadata({
  azd: {
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-5.1,300'
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

@description('Optional. Name of the GPT model to deploy: gpt-5.1')
param gptModelName string = 'gpt-5.1'

@minLength(1)
@description('Optional. Version of the GPT model to deploy:.')
@allowed([
  '2025-11-13'
])
param gptModelVersion string = '2025-11-13'

@minValue(1)
@description('Optional. Capacity of the GPT deployment: (minimum 10).')
param gptDeploymentCapacity int = 300

@description('Optional. The public container image endpoint.')
param publicContainerImageEndpoint string = 'cpscontainerreg.azurecr.io'

@description('Optional. The image tag for the container images.')
param imageTag string = 'latest_v2'

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

@description('Optional. Existing Log Analytics Workspace Resource ID.')
param existingLogAnalyticsWorkspaceId string = ''

@description('Optional. Use this parameter to use an existing AI project resource ID.')
param existingFoundryProjectResourceId string = ''

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

var existingProjectResourceId = trim(existingFoundryProjectResourceId)

// ========== AVM Telemetry ========== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
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
var jumpboxVmName = take('vm-${solutionSuffix}', 15)
module jumpboxVM 'br/public:avm/res/compute/virtual-machine:0.22.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${jumpboxVmName}', 64)
  params: {
    name: jumpboxVmName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    computerName: take(jumpboxVmName, 15)
    osType: 'Windows'
    vmSize: empty(vmSize) ? 'Standard_D2s_v5' : vmSize
    adminUsername: empty(vmAdminUsername) ? 'JumpboxAdminUser' : vmAdminUsername
    adminPassword: empty(vmAdminPassword) ? 'JumpboxAdminP@ssw0rd1234!' : vmAdminPassword
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
      name: 'osdisk-${jumpboxVmName}'
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
        name: 'nic-${jumpboxVmName}'
        tags: tags
        deleteOption: 'Delete'
        diagnosticSettings: enableMonitoring //WAF aligned configuration for Monitoring
          ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }]
          : null
        ipConfigurations: [
          {
            name: '${jumpboxVmName}-nic01-ipconfig01'
            subnetResourceId: virtualNetwork!.outputs.adminSubnetResourceId
            diagnosticSettings: enableMonitoring //WAF aligned configuration for Monitoring
              ? [{ workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId }]
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
              name: 'send-${logAnalyticsWorkspace!.outputs.name}'
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

module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.4.0' = if (enablePrivateNetworking) {
  name: take('avm.res.maintenance-configuration.${jumpboxVmName}', 64)
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
        windowsEventLogs: [
          {
            name: 'SecurityAuditEvents'
            streams: [
              'Microsoft-WindowsEvent'
            ]
            xPathQueries: [
              'Security!*[System[(EventID=4624 or EventID=4625)]]'
            ]
          }
        ]
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace!.outputs.resourceId
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
          transformKql: 'source'
          outputStream: 'Microsoft-Perf'
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

// ========== Log Analytics & Application Insights ========== //
module logAnalyticsWorkspace 'modules/log-analytics-workspace.bicep' = if (enableMonitoring) {
  name: take('module.log-analytics-workspace.${solutionSuffix}', 64)
  params: {
    name: 'log-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    existingLogAnalyticsWorkspaceId: existingLogAnalyticsWorkspaceId
    enablePrivateNetworking: enablePrivateNetworking
    enableRedundancy: enableRedundancy
    replicaLocation: replicaLocation
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.7.1' = if (enableMonitoring) {
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
    replicaLocation: replicaLocation
    enablePrivateNetworking: enablePrivateNetworking
    backendSubnetResourceId: enablePrivateNetworking ? virtualNetwork!.outputs.backendSubnetResourceId : ''
    privateDnsZoneResourceId: enablePrivateNetworking
      ? avmPrivateDnsZones[dnsZoneIndex.containerRegistry]!.outputs.resourceId
      : ''
  }
}

// // ========== Storage Account ========== //
module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.32.0' = {
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
    existingFoundryProjectResourceId: existingProjectResourceId
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
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' // Owner role
        principalType: 'ServicePrincipal'
      }
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
    //publicNetworkAccess: 'Enabled' // Always enabled for AI Services
  }
}

module cognitiveServicePrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.12.0' = if (enablePrivateNetworking && empty(existingProjectResourceId)) {
  name: take('avm.res.network.private-endpoint.${solutionSuffix}', 64)
  params: {
    name: 'pep-aiservices-${solutionSuffix}'
    location: location
    tags: tags
    customNetworkInterfaceName: 'nic-aiservices-${solutionSuffix}'
    privateLinkServiceConnections: [
      {
        name: 'pep-aiservices-${solutionSuffix}-cognitiveservices-connection'
        properties: {
          privateLinkServiceId: avmAiServices.outputs.resourceId
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
        {
          name: 'ai-services-dns-zone-contentunderstanding'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.contentUnderstanding]!.outputs.resourceId
        }
      ]
    }
    subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
  }
}

module avmAiServices_cu 'br/public:avm/res/cognitive-services/account:0.14.2' = {
  name: take('avm.res.cognitive-services.account.content-understanding.${solutionSuffix}', 64)

  params: {
    name: 'aicu-${solutionSuffix}'
    location: contentUnderstandingLocation
    sku: 'S0'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId // Use the managed identity created above
      ]
    }
    kind: 'AIServices'
    tags: {
      app: solutionSuffix
      location: location
    }
    customSubDomainName: 'aicu-${solutionSuffix}'
    disableLocalAuth: true
    enableTelemetry: enableTelemetry
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow' // Always allow for AI Services
    }
    roleAssignments: [
      {
        principalId: avmContainerApp.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'a97b65f3-24c7-4388-baec-2e87135dc908'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: avmContainerApp_Workflow.outputs.systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'a97b65f3-24c7-4388-baec-2e87135dc908'
        principalType: 'ServicePrincipal'
      }
    ]

    publicNetworkAccess: (enablePrivateNetworking) ? 'Disabled' : 'Enabled'
  }
}

module contentUnderstandingPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.12.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.private-endpoint.aicu-${solutionSuffix}', 64)
  params: {
    name: 'pep-aicu-${solutionSuffix}'
    location: location
    tags: tags
    customNetworkInterfaceName: 'nic-aicu-${solutionSuffix}'
    privateLinkServiceConnections: [
      {
        name: 'pep-aicu-${solutionSuffix}-cognitiveservices-connection'
        properties: {
          privateLinkServiceId: avmAiServices_cu.outputs.resourceId
          groupIds: ['account']
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'aicu-dns-zone-cognitiveservices'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cognitiveServices]!.outputs.resourceId
        }
        {
          name: 'ai-services-dns-zone-aiservices'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.aiServices]!.outputs.resourceId
        }
        {
          name: 'aicu-dns-zone-contentunderstanding'
          privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.contentUnderstanding]!.outputs.resourceId
        }
      ]
    }
    subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
  }
}

// ========== Container App Environment ========== //
module avmContainerAppEnv 'br/public:avm/res/app/managed-environment:0.13.1' = {
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
          #disable-next-line BCP318 // logAnalyticsWorkspace is conditionally deployed with enableMonitoring guard
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
module avmContainerRegistryReader 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${solutionSuffix}', 64)
  params: {
    name: 'id-acr-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== Container App  ========== //
module avmContainerApp 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-app'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: null
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        avmContainerRegistryReader.outputs.resourceId
      ]
    }

    containers: [
      {
        name: 'ca-${solutionSuffix}'
        image: '${publicContainerImageEndpoint}/contentprocessor:${imageTag}'

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
module avmContainerApp_API 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app-api.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-api'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: null
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
        image: '${publicContainerImageEndpoint}/contentprocessorapi:${imageTag}'
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
module avmContainerApp_Web 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app-web.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-web'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: null
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
        image: '${publicContainerImageEndpoint}/contentprocessorweb:${imageTag}'
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
            value: '${environment().authentication.loginEndpoint}/${tenant().tenantId}'
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
module avmContainerApp_Workflow 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app-wkfl.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-wkfl'
    location: location
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    enableTelemetry: enableTelemetry
    registries: null
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
        image: '${publicContainerImageEndpoint}/contentprocessorworkflow:${imageTag}'
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
module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.19.0' = {
  name: take('avm.res.document-db.database-account.${solutionSuffix}', 64)
  params: {
    name: 'cosmos-${solutionSuffix}'
    location: location
    mongodbDatabases: [
      {
        name: 'default'
        tags: { purpose: 'default database' }
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
    zoneRedundant: false

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
module avmAppConfig 'br/public:avm/res/app-configuration/configuration-store:0.9.2' = {
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
    replicaLocations: enableRedundancy ? [{ replicaLocation: replicaLocation }] : []
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
        value: avmAiServices_cu.outputs.endpoint //TODO: replace with actual endpoint
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
        name: 'APP_COSMOS_CONTAINER_SCHEMASET'
        value: 'Schemasets'
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

module avmAppConfig_update 'br/public:avm/res/app-configuration/configuration-store:0.9.2' = if (enablePrivateNetworking) {
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
module avmContainerApp_update 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app-update.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-app'
    location: location
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: null
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
        image: '${publicContainerImageEndpoint}/contentprocessor:${imageTag}'

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
  dependsOn: [
    cognitiveServicePrivateEndpoint
    contentUnderstandingPrivateEndpoint
  ]
}

module avmContainerApp_API_update 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app-api.update.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-api'
    location: location
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: null
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
        image: '${publicContainerImageEndpoint}/contentprocessorapi:${imageTag}'
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
  dependsOn: [
    cognitiveServicePrivateEndpoint
  ]
}

// ========== Container App Workflow Update ========== //
module avmContainerApp_Workflow_update 'br/public:avm/res/app/container-app:0.21.0' = {
  name: take('avm.res.app.container-app-wkfl.update.${solutionSuffix}', 64)
  params: {
    name: 'ca-${solutionSuffix}-wkfl'
    location: location
    enableTelemetry: enableTelemetry
    environmentResourceId: avmContainerAppEnv.outputs.resourceId
    workloadProfileName: 'Consumption'
    registries: null
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
        image: '${publicContainerImageEndpoint}/contentprocessorworkflow:${imageTag}'
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

@description('The name of the Container App used for Web App.')
output CONTAINER_WEB_APP_NAME string = avmContainerApp_Web.outputs.name

@description('The name of the Container App used for API.')
output CONTAINER_API_APP_NAME string = avmContainerApp_API.outputs.name

@description('The FQDN of the Container App.')
output CONTAINER_WEB_APP_FQDN string = avmContainerApp_Web.outputs.fqdn

@description('The FQDN of the Container App API.')
output CONTAINER_API_APP_FQDN string = avmContainerApp_API.outputs.fqdn

@description('The name of the Container App used for APP.')
output CONTAINER_APP_NAME string = avmContainerApp.outputs.name

@description('The name of the Container App used for Workflow.')
output CONTAINER_WORKFLOW_APP_NAME string = avmContainerApp_Workflow.outputs.name

@description('The user identity resource ID used fot the Container APP.')
output CONTAINER_APP_USER_IDENTITY_ID string = avmContainerRegistryReader.outputs.resourceId

@description('The user identity Principal ID used fot the Container APP.')
output CONTAINER_APP_USER_PRINCIPAL_ID string = avmContainerRegistryReader.outputs.principalId

@description('The name of the Azure Container Registry.')
output CONTAINER_REGISTRY_NAME string = avmContainerRegistry.outputs.name

@description('The login server of the Azure Container Registry.')
output CONTAINER_REGISTRY_LOGIN_SERVER string = avmContainerRegistry.outputs.loginServer

@description('The resource group the resources were deployed into.')
output AZURE_RESOURCE_GROUP string = resourceGroup().name
