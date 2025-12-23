// ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Customer Chat bot'
metadata description = '''This module contains the resources required to deploy the [Customer Chat bot solution accelerator](https://github.com/microsoft/Customer-Chat-bot-Solution-Accelerator) for both Sandbox environments and WAF aligned environments.

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

@description('Optional. A unique application/solution name for all resources in this deployment. This should be 3-16 characters long.')
@minLength(3)
@maxLength(16)
param solutionName string = 'ccsa'

@maxLength(5)
@description('Optional. A unique text value for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.')
param solutionUniqueText string = take(uniqueString(subscription().id, resourceGroup().name, solutionName), 5)

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

// Restricting deployment to only supported Azure OpenAI regions validated with GPT-4o model
@allowed(['australiaeast', 'eastus2', 'francecentral', 'japaneast', 'norwayeast', 'swedencentral', 'uksouth', 'westus'])
@metadata({
  azd:{
    type: 'location'
    usageName: [
      'OpenAI.GlobalStandard.gpt-4o-mini,150'
    ]
  }
})
@description('Required. Location for all AI service resources. This should be one of the supported Azure AI Service locations.')
param azureAiServiceLocation string

@minLength(1)
@description('Optional. Name of the GPT model to deploy:')
param gptModelName string = 'gpt-4o-mini'

@description('Optional. Version of the GPT model to deploy. Defaults to 2024-07-18.')
param gptModelVersion string = '2024-07-18'

@description('Optional. Version of the OpenAI.')
param azureOpenAIApiVersion string = '2025-01-01-preview'

@description('Optional. Version of AI Agent API.')
param azureAiAgentApiVersion string = '2025-05-01'

@minLength(1)
@allowed([
  'Standard'
  'GlobalStandard'
])
@description('Optional. GPT model deployment type. Defaults to GlobalStandard.')
param gptModelDeploymentType string = 'GlobalStandard'

@description('Optional. AI model deployment token capacity. Defaults to 10 for optimal performance.')
param gptModelCapacity int = 10

@minLength(1)
@description('Name of the Text Embedding model to deploy:')
@allowed([
  'text-embedding-ada-002'
])
param embeddingModel string = 'text-embedding-ada-002'

@minValue(10)
@description('Capacity of the Embedding Model deployment')
param embeddingDeploymentCapacity int = 10

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enablePrivateNetworking bool = false

@secure()
@description('Optional. The user name for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.')
param virtualMachineAdminUsername string?

@description('Optional. The password for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.')
@secure()
param virtualMachineAdminPassword string?

// These parameters are changed for testing - please reset as part of publication
@description('Optional. The Container Registry hostname where the docker images for the backend are located.')
param backendContainerRegistryHostname string = 'ccbcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the backend.')
param backendContainerImageName string = 'backend'

@description('Optional. The Container Image Tag to deploy on the backend.')
param backendContainerImageTag string = 'latest'

@description('Optional. The Container Registry hostname where the docker images for the frontend are located.')
param frontendContainerRegistryHostname string = 'ccbcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the frontend.')
param frontendContainerImageName string = 'frontend'

@description('Optional. The Container Image Tag to deploy on the frontend.')
param frontendContainerImageTag string = 'latest'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Resource ID of an existing Log Analytics Workspace.')
param existingLogAnalyticsWorkspaceId string = ''

@description('Optional. Resource ID of an existing Ai Foundry AI Services resource.')
param existingAiFoundryAiProjectResourceId string = ''

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

// Region pairs list based on article in [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions) for supported high availability regions for CosmosDB.
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
}
// Paired location calculated based on 'location' parameter. This location will be used by applicable resources if `enableScalability` is set to `true`
var cosmosDbHaLocation = cosmosDbZoneRedundantHaRegionPairs[location]

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
var replicaLocation = replicaRegionPairs[location]
var allTags = union(
  {
    'azd-env-name': solutionName
  },
  tags
)
@description('Tag, Created by user name')
param createdBy string = contains(deployer(), 'userPrincipalName')? split(deployer().userPrincipalName, '@')[0]: deployer().objectId
var deployerPrincipalType = contains(deployer(), 'userPrincipalName')? 'User' : 'ServicePrincipal'

//Get the current deployer's information
var deployerInfo = deployer()
var deployingUserPrincipalId = deployerInfo.objectId

// ============== //
// Resources      //
// ============== //

// ========== Resource Group Tag ========== //
resource resourceGroupTags 'Microsoft.Resources/tags@2021-04-01' = {
  name: 'default'
  properties: {
    tags: {
      ...resourceGroup().tags
      ...allTags
      TemplateName: 'Customer Chat bot'
      Type: enablePrivateNetworking ? 'WAF' : 'Non-WAF'
      CreatedBy: createdBy
      DeploymentName: deployment().name
    }
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.sa-multiagentcustauteng.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// Extracts subscription, resource group, and workspace name from the resource ID when using an existing Log Analytics workspace
var useExistingLogAnalytics = !empty(existingLogAnalyticsWorkspaceId)

var existingLawSubscription = useExistingLogAnalytics ? split(existingLogAnalyticsWorkspaceId, '/')[2] : ''
var existingLawResourceGroup = useExistingLogAnalytics ? split(existingLogAnalyticsWorkspaceId, '/')[4] : ''
var existingLawName = useExistingLogAnalytics ? split(existingLogAnalyticsWorkspaceId, '/')[8] : ''

resource existingLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = if (useExistingLogAnalytics) {
  name: existingLawName
  scope: resourceGroup(existingLawSubscription, existingLawResourceGroup)
}

// ========== Log Analytics Workspace ========== //
var logAnalyticsWorkspaceResourceName = 'log-${solutionSuffix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.12.0' = if (enableMonitoring && !useExistingLogAnalytics) {
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
    dailyQuotaGb: enableRedundancy ? 150 : null //WAF recommendation: 150 GB per day is a good starting point for most workloads
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

// Log Analytics Name, workspace ID, customer ID, and shared key (existing or new) 
var logAnalyticsWorkspaceName = useExistingLogAnalytics
  ? existingLogAnalyticsWorkspace!.name
  : logAnalyticsWorkspace!.outputs.name
var logAnalyticsWorkspaceResourceId = useExistingLogAnalytics
  ? existingLogAnalyticsWorkspaceId
  : logAnalyticsWorkspace!.outputs.resourceId

// ========== Application Insights ========== //
var applicationInsightsResourceName = 'appi-${solutionSuffix}'
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    tags: tags
    location: location
    enableTelemetry: enableTelemetry
    retentionInDays: 365
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    // WAF aligned configuration for Monitoring
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspaceResourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
  }
}

// ========== User Assigned Identity ========== //
var userAssignedIdentityResourceName = 'id-${solutionSuffix}'
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedIdentityResourceName}', 64)
  params: {
    name: userAssignedIdentityResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// ========== Virtual Network ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
var virtualNetworkResourceName = 'vnet-${solutionSuffix}'
module virtualNetwork 'modules/virtualNetwork.bicep' = if (enablePrivateNetworking) {
  name: take('module.virtualNetwork.${solutionSuffix}', 64)
  params: {
    name: 'vnet-${solutionSuffix}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/8']
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    resourceSuffix: solutionSuffix
  }
}

var bastionResourceName = 'bas-${solutionSuffix}'
// ========== Bastion host ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
module bastionHost 'br/public:avm/res/network/bastion-host:0.7.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionResourceName}', 64)
  params: {
    name: bastionResourceName
    location: location
    skuName: 'Standard'
    enableTelemetry: enableTelemetry
    tags: tags
    virtualNetworkResourceId: virtualNetwork!.?outputs.?resourceId
    availabilityZones:[]
    publicIPAddressObject: {
      name: 'pip-bas${solutionSuffix}'
      diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
      tags: tags
    }
    disableCopyPaste: true
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
    scaleUnits: 4
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
  }
}

// ========== Virtual machine ========== //
// WAF best practices for virtual machines: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-machines
var maintenanceConfigurationResourceName = 'mc-${solutionSuffix}'
module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.3.1' = if (enablePrivateNetworking) {
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
var dataCollectionRulesLocation = useExistingLogAnalytics
  ? existingLogAnalyticsWorkspace!.location
  : logAnalyticsWorkspace!.outputs.location
module windowsVmDataCollectionRules 'br/public:avm/res/insights/data-collection-rule:0.6.1' = if (enablePrivateNetworking && enableMonitoring) {
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
            eventLogName: 'Security'
            eventTypes: [
              {
                eventType: 'Audit Success'
              }
              {
                eventType: 'Audit Failure'
              }
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
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            name: 'la--1264800308'
          }
        ]
      }
      dataFlows: [
        {
          streams: [
            'Microsoft-Perf'
          ]
          destinations: [
            'la--1264800308'
          ]
          transformKql: 'source'
          outputStream: 'Microsoft-Perf'
        }
      ]
    }
  }
}

var proximityPlacementGroupResourceName = 'ppg-${solutionSuffix}'
module proximityPlacementGroup 'br/public:avm/res/compute/proximity-placement-group:0.4.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.proximity-placement-group.${proximityPlacementGroupResourceName}', 64)
  params: {
    name: proximityPlacementGroupResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    availabilityZone: virtualMachineAvailabilityZone
    intent: { vmSizes: [virtualMachineSize] }
  }
}

var virtualMachineResourceName = 'vm-${solutionSuffix}'
var virtualMachineAvailabilityZone = 1
var virtualMachineSize = 'Standard_D2s_v3'
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.17.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${virtualMachineResourceName}', 64)
  params: {
    name: virtualMachineResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    computerName: take(virtualMachineResourceName, 15)
    osType: 'Windows'
    vmSize: virtualMachineSize
    adminUsername: virtualMachineAdminUsername ?? 'JumpboxAdminUser'
    adminPassword: virtualMachineAdminPassword ?? 'JumpboxAdminP@ssw0rd1234!'
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration!.outputs.resourceId
    enableAutomaticUpdates: true
    encryptionAtHost: true
    availabilityZone: virtualMachineAvailabilityZone
    proximityPlacementGroupResourceId: proximityPlacementGroup!.outputs.resourceId
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
      managedDisk: { storageAccountType: 'Premium_LRS' }
    }
    nicConfigurations: [
      {
        name: 'nic-${virtualMachineResourceName}'
        //networkSecurityGroupResourceId: virtualMachineConfiguration.?nicConfigurationConfiguration.networkSecurityGroupResourceId
        //nicSuffix: 'nic-${virtualMachineResourceName}'
        tags: tags
        deleteOption: 'Delete'
        diagnosticSettings: enableMonitoring //WAF aligned configuration for Monitoring
          ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
          : null
        ipConfigurations: [
          {
            name: '${virtualMachineResourceName}-nic01-ipconfig01'
            subnetResourceId: virtualNetwork!.outputs.administrationSubnetResourceId
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

// ========== Private DNS Zones ========== //
var keyVaultPrivateDNSZone = 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'vaultcore.usgovcloudapi.net' : 'vaultcore.azure.net'}'
var privateDnsZones = [
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.documents.azure.com'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.search.windows.net'
  keyVaultPrivateDNSZone
]

// DNS Zone Index Constants
var dnsZoneIndex = {
  cognitiveServices: 0
  openAI: 1
  aiServices: 2
  cosmosDb: 3
  blob: 4
  search: 5
  keyVault: 6
}

// List of DNS zone indices that correspond to AI-related services.
var aiRelatedDnsZoneIndices = [
  dnsZoneIndex.cognitiveServices
  dnsZoneIndex.openAI
  dnsZoneIndex.aiServices
]

// ===================================================
// DEPLOY PRIVATE DNS ZONES
// - Deploys all zones if no existing Foundry project is used
// - Excludes AI-related zones when using with an existing Foundry project
// ===================================================
@batchSize(5)
module avmPrivateDnsZones 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for (zone, i) in privateDnsZones: if (enablePrivateNetworking && (!useExistingAiFoundryAiProject || !contains(
    aiRelatedDnsZoneIndices,
    i
  ))) {
    name: 'avm.res.network.private-dns-zone.${contains(zone, 'azurecontainerapps.io') ? 'containerappenv' : split(zone, '.')[1]}'
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetworkResourceName}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork!.outputs.resourceId
        }
      ]
    }
  }
]

// ==========AI Foundry and related resources ========== //
var useExistingAiFoundryAiProject = !empty(existingAiFoundryAiProjectResourceId)
var aiFoundryAiServicesResourceGroupName = useExistingAiFoundryAiProject
  ? split(existingAiFoundryAiProjectResourceId, '/')[4]
  : resourceGroup().name
var aiFoundryAiServicesSubscriptionId = useExistingAiFoundryAiProject
  ? split(existingAiFoundryAiProjectResourceId, '/')[2]
  : subscription().subscriptionId
var aiFoundryAiServicesResourceName = useExistingAiFoundryAiProject
  ? split(existingAiFoundryAiProjectResourceId, '/')[8]
  : 'aif-${solutionSuffix}'
var aiFoundryAiProjectResourceName = useExistingAiFoundryAiProject
  ? split(existingAiFoundryAiProjectResourceId, '/')[10]
  : 'proj-${solutionSuffix}' // AI Project resource id: /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.CognitiveServices/accounts/<ai-services-name>/projects/<project-name>
var aiModelDeployments = [
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
  {
    format: 'OpenAI'
    name: embeddingModel
    model: embeddingModel
    sku: {
      name: 'GlobalStandard'
      capacity: embeddingDeploymentCapacity
    }
    version: '2'
    raiPolicyName: 'Microsoft.Default'
  }
]
var aiFoundryAiProjectDescription = 'AI Foundry Project'

resource existingAiFoundryAiServices 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = if (useExistingAiFoundryAiProject) {
  name: aiFoundryAiServicesResourceName
  scope: resourceGroup(aiFoundryAiServicesSubscriptionId, aiFoundryAiServicesResourceGroupName)
}

module existingAiFoundryAiServicesDeployments 'modules/ai-services-deployments.bicep' = if (useExistingAiFoundryAiProject) {
  name: take('module.ai-services-model-deployments.${existingAiFoundryAiServices.name}', 64)
  scope: resourceGroup(aiFoundryAiServicesSubscriptionId, aiFoundryAiServicesResourceGroupName)
  params: {
    name: existingAiFoundryAiServices.name
    // Use individual deployment objects instead of loop to prevent ETag conflicts
    deployments: [
      {
        name: aiModelDeployments[0].name
        model: {
          format: aiModelDeployments[0].format
          name: aiModelDeployments[0].name
          version: aiModelDeployments[0].version
        }
        raiPolicyName: aiModelDeployments[0].raiPolicyName
        sku: {
          name: aiModelDeployments[0].sku.name
          capacity: aiModelDeployments[0].sku.capacity
        }
      }
      {
        name: aiModelDeployments[1].name
        model: {
          format: aiModelDeployments[1].format
          name: aiModelDeployments[1].name
          version: aiModelDeployments[1].version
        }
        raiPolicyName: aiModelDeployments[1].raiPolicyName
        sku: {
          name: aiModelDeployments[1].sku.name
          capacity: aiModelDeployments[1].sku.capacity
        }
      }
    ]
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
    ]
  }
}

module aiFoundryAiServices 'br:mcr.microsoft.com/bicep/avm/res/cognitive-services/account:0.13.2' = if (!useExistingAiFoundryAiProject) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: azureAiServiceLocation
    tags: tags
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    allowProjectManagement: true
    customSubDomainName: aiFoundryAiServicesResourceName
    apiProperties: {
      //staticsEnabled: false
    }
    // Use individual deployment objects instead of loop to prevent ETag conflicts
    deployments: [
      {
        name: aiModelDeployments[0].name
        model: {
          format: aiModelDeployments[0].format
          name: aiModelDeployments[0].name
          version: aiModelDeployments[0].version
        }
        raiPolicyName: aiModelDeployments[0].raiPolicyName
        sku: {
          name: aiModelDeployments[0].sku.name
          capacity: aiModelDeployments[0].sku.capacity
        }
      }
      {
        name: aiModelDeployments[1].name
        model: {
          format: aiModelDeployments[1].format
          name: aiModelDeployments[1].name
          version: aiModelDeployments[1].version
        }
        raiPolicyName: aiModelDeployments[1].raiPolicyName
        sku: {
          name: aiModelDeployments[1].sku.name
          capacity: aiModelDeployments[1].sku.capacity
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity!.outputs.resourceId] } //To create accounts or projects, you must enable a managed identity on your resource
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
        roleDefinitionIdOrName: '53ca6127-db72-4b80-b1b0-d745d6d5456d' // Azure AI User
        principalId: deployingUserPrincipalId
        principalType: deployerPrincipalType
      }
      {
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee' // Azure AI Developer
        principalId: deployingUserPrincipalId
        principalType: deployerPrincipalType
      }
    ]
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: (enablePrivateNetworking)
      ? ([
          {
            name: 'pep-${aiFoundryAiServicesResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiServicesResourceName}'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
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
          }
        ])
      : []
  }
}

// ========== Search Service ========== //
var searchServiceName = 'srch-${solutionSuffix}'
module searchService 'br/public:avm/res/search/search-service:0.11.1' = {
  name: take('avm.res.search.search-service.${solutionSuffix}', 64)
  params: {
    name: searchServiceName
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    disableLocalAuth: false
    hostingMode: 'default'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      bypass: 'AzureServices'
    }
    partitionCount: 1
    replicaCount: 1
    sku: enableScalability ? 'standard' : 'basic'
    tags: tags
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Search Index Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: deployingUserPrincipalId
        roleDefinitionIdOrName: 'Search Index Data Contributor'
        principalType: deployerPrincipalType
      }
      {
        principalId: aiFoundryAiProjectPrincipalId
        roleDefinitionIdOrName: 'Search Index Data Reader'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: aiFoundryAiProjectPrincipalId
        roleDefinitionIdOrName: 'Search Service Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    privateEndpoints:[]
  }
}


// ========== Search Service - AI Project Connection ========== //
var aiSearchConnectionName = 'aifp-srch-connection-${solutionSuffix}'
module aiSearchFoundryConnection 'modules/aifp-connections.bicep' = {
  name: take('aifp-srch-connection.${solutionSuffix}', 64)
  scope: resourceGroup(aiFoundryAiServicesSubscriptionId, aiFoundryAiServicesResourceGroupName)
  params: {
    aiFoundryProjectName: aiFoundryAiProjectName
    aiFoundryName: aiFoundryAiServicesResourceName
    aifSearchConnectionName: aiSearchConnectionName
    searchServiceResourceId: searchService.outputs.resourceId
    searchServiceLocation: searchService.outputs.location
    searchServiceName: searchService.outputs.name
    searchApiKey: searchService.outputs.primaryKey
  }
}

resource existingAiFoundryAiServicesProject 'Microsoft.CognitiveServices/accounts/projects@2025-06-01' existing = if (useExistingAiFoundryAiProject) {
  name: aiFoundryAiProjectResourceName
  parent: existingAiFoundryAiServices
}

module aiFoundryAiServicesProject 'modules/ai-project.bicep' = if (!useExistingAiFoundryAiProject) {
  name: take('module.ai-project.${aiFoundryAiProjectResourceName}', 64)
  params: {
    name: aiFoundryAiProjectResourceName
    location: azureAiServiceLocation
    tags: tags
    desc: aiFoundryAiProjectDescription
    //Implicit dependencies below
    aiServicesName: aiFoundryAiServices!.outputs.name
  }
}

var aiFoundryAiProjectName = useExistingAiFoundryAiProject
  ? existingAiFoundryAiServicesProject.name
  : aiFoundryAiServicesProject!.outputs.name
var aiFoundryAiProjectEndpoint = useExistingAiFoundryAiProject
  ? existingAiFoundryAiServicesProject!.properties.endpoints['AI Foundry API']
  : aiFoundryAiServicesProject!.outputs.apiEndpoint
var aiFoundryAiProjectPrincipalId = useExistingAiFoundryAiProject
  ? existingAiFoundryAiServicesProject!.identity.principalId
  : aiFoundryAiServicesProject!.outputs.principalId

// ========== Search Service to Azure OpenAI Role Assignment ========== //
resource searchServiceToOpenAIRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!useExistingAiFoundryAiProject) {
  name: guid(searchServiceName, '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd', aiFoundryAiServicesResourceName)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd') // Cognitive Services OpenAI User
    principalId: searchService.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
  }
}

module searchServiceToOpenAIRoleAssignmentExisting 'modules/role-assignment.bicep' = if (useExistingAiFoundryAiProject) {
  name: 'searchToExistingAiServices-roleAssignment'
  scope: resourceGroup(aiFoundryAiServicesSubscriptionId, aiFoundryAiServicesResourceGroupName)
  params: {
    principalId: searchService.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' // Cognitive Services OpenAI User
    targetResourceName: aiFoundryAiServicesResourceName
  }
}

// ========== Cosmos DB ========== //
var cosmosDbResourceName = 'cosmos-${solutionSuffix}'
var cosmosDbDatabaseName = 'ecommerce_db'
var containers = [
  {
    name: 'carts'
    paths: ['/user_id']
  } 
  {
    name: 'chat_sessions'
    paths: ['/user_id']
  }
    {
    name: 'products'
    paths: ['/productId']
  }
    {
    name: 'transactions'
    paths: ['/user_id']
  }
    {
    name: 'users'
    paths: ['/email']
  }
]
module cosmosDb 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: cosmosDbResourceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    sqlDatabases: [
      {
        name: cosmosDbDatabaseName
        containers: containers
      }
    ]
    dataPlaneRoleDefinitions: [
      {
        // Cosmos DB Built-in Data Contributor: https://docs.azure.cn/en-us/cosmos-db/nosql/security/reference-data-plane-roles#cosmos-db-built-in-data-contributor
        roleName: 'Cosmos DB SQL Data Contributor'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        assignments: [
          { principalId: userAssignedIdentity.outputs.principalId }
          { principalId: deployingUserPrincipalId }
        ]
      }
    ]
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Private Networking
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
                { privateDnsZoneResourceId: avmPrivateDnsZones[dnsZoneIndex.cosmosDb]!.outputs.resourceId }
              ]
            }
            service: 'Sql'
            subnetResourceId: virtualNetwork!.outputs.backendSubnetResourceId
          }
        ]
      : []
    // WAF aligned configuration for Redundancy
    zoneRedundant: enableRedundancy ? true : false
    capabilitiesToAdd: enableRedundancy ? null : ['EnableServerless']
    automaticFailover: enableRedundancy ? true : false
    failoverLocations: enableRedundancy
      ? [
          {
            failoverPriority: 0
            isZoneRedundant: true
            locationName: location
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: cosmosDbHaLocation
          }
        ]
      : [
          {
            locationName: location
            failoverPriority: 0
            isZoneRedundant: enableRedundancy
          }
        ]
  }
}

// ========== Web server farm ========== //
// WAF best practices for Web Application Services: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service
var webServerFarmResourceName = 'asp-${solutionSuffix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.5.0' = {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: tags
    enableTelemetry: enableTelemetry
    location: location
    reserved: true
    kind: 'linux'
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Scalability
    skuName: enableScalability || enableRedundancy ? 'P1v3' : 'B2'
    skuCapacity: enableScalability ? 3 : 1
    // WAF aligned configuration for Redundancy
    zoneRedundant: enableRedundancy ? true : false
  }
}

// ========== Backend API Docker container ========== //
var reactAppLayoutConfig ='''{
  "appConfig": {
      "CHAT_CHATHISTORY": {
        "CHAT": 70,
        "CHATHISTORY": 30
      }
    }
  }
}'''
var backendWebSiteResourceName = 'api-${solutionSuffix}'
module webSiteBackend 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${backendWebSiteResourceName}', 64)
  params: {
    name: backendWebSiteResourceName
    tags: tags
    location: location
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    siteConfig: {
      linuxFxVersion: 'DOCKER|${backendContainerRegistryHostname}/${backendContainerImageName}:${backendContainerImageTag}'
      minTlsVersion: '1.2'
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          AZURE_OPENAI_DEPLOYMENT_MODEL: gptModelName
          AZURE_OPENAI_ENDPOINT: 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'
          AZURE_OPENAI_API_VERSION: azureOpenAIApiVersion
          AZURE_OPENAI_RESOURCE: aiFoundryAiServicesResourceName
          AZURE_AI_AGENT_ENDPOINT: aiFoundryAiProjectEndpoint
          AZURE_AI_AGENT_API_VERSION: azureAiAgentApiVersion
          AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME: gptModelName
          USE_CHAT_HISTORY_ENABLED: 'True'
          AZURE_COSMOSDB_ACCOUNT: cosmosDb.outputs.name
          // AZURE_COSMOSDB_CONVERSATIONS_CONTAINER: 'chat_sessions'
          AZURE_COSMOSDB_DATABASE: cosmosDbDatabaseName
          AZURE_COSMOSDB_ENABLE_FEEDBACK: '' //'True'
          REACT_APP_LAYOUT_CONFIG: reactAppLayoutConfig
        
          API_UID: userAssignedIdentity.outputs.clientId
          AZURE_CLIENT_ID: userAssignedIdentity.outputs.clientId
          AZURE_AI_SEARCH_ENDPOINT: 'https://${searchServiceName}.search.windows.net'
          AZURE_AI_SEARCH_INDEX: 'call_transcripts_index'
          AZURE_AI_SEARCH_CONNECTION_NAME: aiSearchConnectionName

          USE_AI_PROJECT_CLIENT: 'True'
          DISPLAY_CHART_DEFAULT: 'False'
          APPLICATIONINSIGHTS_CONNECTION_STRING: enableMonitoring ? applicationInsights!.outputs.connectionString : ''
          DUMMY_TEST: 'True'
          SOLUTION_NAME: solutionSuffix
          APP_ENV: 'Prod'

          ALLOWED_ORIGINS_STR: '*'
          AZURE_FOUNDRY_ENDPOINT: aiFoundryAiProjectEndpoint
          AZURE_SEARCH_ENDPOINT: searchService.outputs.endpoint
          AZURE_SEARCH_INDEX: 'policies'
          AZURE_SEARCH_PRODUCT_INDEX: 'products'
          COSMOS_DB_DATABASE_NAME: cosmosDbDatabaseName
          COSMOS_DB_ENDPOINT: 'https://${cosmosDb.outputs.name}.documents.azure.com:443/'
          USE_FOUNDRY_AGENTS: 'True'
          AZURE_OPENAI_DEPLOYMENT_NAME: gptModelName
          RATE_LIMIT_REQUESTS: '100'
          RATE_LIMIT_WINDOW: '60'
          // Agent IDs will be set by post-deployment script
          FOUNDRY_CHAT_AGENT_ID: ''
          FOUNDRY_CUSTOM_PRODUCT_AGENT_ID: ''
          FOUNDRY_POLICY_AGENT_ID: ''
        }
        // WAF aligned configuration for Monitoring
        applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Private Networking
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    vnetImagePullEnabled: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webserverfarmSubnetResourceId : null
    publicNetworkAccess: 'Enabled'
  }
}

// ========== Additional Cosmos DB Role Assignment for Backend App Service ========== //
// Add the backend App Service's system-assigned managed identity to Cosmos DB role
resource cosmosDbBackendRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-05-15' = {
  name: '${cosmosDbResourceName}/${guid(subscription().id, resourceGroup().id, backendWebSiteResourceName, 'CosmosDBDataContributor')}'
  properties: {
    principalId: webSiteBackend.outputs.systemAssignedMIPrincipalId!
    roleDefinitionId: '${cosmosDb.outputs.resourceId}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002'
    scope: cosmosDb.outputs.resourceId
  }
}

// ========== Frontend Web App Docker container ========== //
var webSiteResourceName = 'app-${solutionSuffix}'
module webSite 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteResourceName}', 64)
  params: {
    name: webSiteResourceName
    tags: tags
    location: location
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${frontendContainerRegistryHostname}/${frontendContainerImageName}:${frontendContainerImageTag}'
      minTlsVersion: '1.2'
    }
    configs: [
      {
        name: 'appsettings'
        properties: {
          NODE_ENV: 'production'
          VITE_API_BASE_URL: 'https://${webSiteBackend.outputs.defaultHostname}'
        }
        // WAF aligned configuration for Monitoring
        applicationInsightResourceId: enableMonitoring ? applicationInsights!.outputs.resourceId : null
      }
    ]
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }] : null
    // WAF aligned configuration for Private Networking
    vnetRouteAllEnabled: enablePrivateNetworking ? true : false
    vnetImagePullEnabled: enablePrivateNetworking ? true : false
    virtualNetworkSubnetId: enablePrivateNetworking ? virtualNetwork!.outputs.webserverfarmSubnetResourceId : null
    publicNetworkAccess: 'Enabled' // Always enabling the public network access for Web App
    e2eEncryptionEnabled: true
  }
}

output SOLUTION_NAME string = solutionSuffix
output RESOURCE_GROUP_NAME string = resourceGroup().name
output RESOURCE_GROUP_LOCATION string = location
output APPINSIGHTS_INSTRUMENTATIONKEY string = enableMonitoring ? applicationInsights!.outputs.instrumentationKey : ''
output AZURE_AI_PROJECT_CONN_STRING string = aiFoundryAiProjectEndpoint
output AZURE_AI_AGENT_API_VERSION string = azureAiAgentApiVersion
output AZURE_AI_PROJECT_NAME string = aiFoundryAiProjectName
output AZURE_COSMOSDB_ACCOUNT string = cosmosDb.outputs.name
output COSMOS_DB_ENDPOINT string = 'https://${cosmosDb.outputs.name}.documents.azure.com:443/'
output COSMOS_DB_DATABASE_NAME string = cosmosDbDatabaseName
output AZURE_COSMOSDB_CONVERSATIONS_CONTAINER string = 'chat_sessions'
output AZURE_COSMOSDB_DATABASE string = cosmosDbDatabaseName
output AZURE_OPENAI_DEPLOYMENT_MODEL string = gptModelName
output AZURE_OPENAI_EMBEDDING_MODEL string = embeddingModel
output AZURE_OPENAI_EMBEDDING_MODEL_CAPACITY int = embeddingDeploymentCapacity
output AZURE_OPENAI_ENDPOINT string = 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'
output AZURE_OPENAI_MODEL_DEPLOYMENT_TYPE string = gptModelDeploymentType

output AZURE_AI_SEARCH_ENDPOINT string = 'https://${searchServiceName}.search.windows.net'

output AZURE_OPENAI_API_VERSION string = azureOpenAIApiVersion
output AZURE_OPENAI_RESOURCE string = aiFoundryAiServicesResourceName
output REACT_APP_LAYOUT_CONFIG string = reactAppLayoutConfig

output API_UID string = userAssignedIdentity.outputs.clientId
output USE_AI_PROJECT_CLIENT string = 'False'
output USE_CHAT_HISTORY_ENABLED string = 'True'
output DISPLAY_CHART_DEFAULT string = 'False'
output AZURE_AI_AGENT_ENDPOINT string = aiFoundryAiProjectEndpoint
output AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME string = gptModelName
output ACR_NAME string = split(backendContainerRegistryHostname, '.')[0]
output AZURE_ENV_IMAGETAG string = backendContainerImageTag

output AI_SERVICE_NAME string = aiFoundryAiServicesResourceName
output API_APP_NAME string = backendWebSiteResourceName
output API_PID string = userAssignedIdentity.outputs.principalId

output API_APP_URL string = 'https://api-${solutionSuffix}.azurewebsites.net'
output WEB_APP_URL string = 'https://app-${solutionSuffix}.azurewebsites.net'
output APPLICATIONINSIGHTS_CONNECTION_STRING string = enableMonitoring ? applicationInsights!.outputs.connectionString : ''
output AGENT_ID_CHAT string = ''

output MANAGED_IDENTITY_CLIENT_ID string = userAssignedIdentity.outputs.clientId
output AI_FOUNDRY_RESOURCE_ID string = useExistingAiFoundryAiProject ? existingAiFoundryAiProjectResourceId : aiFoundryAiServices!.outputs.resourceId
output AI_SEARCH_SERVICE_RESOURCE_ID string = searchService.outputs.resourceId
output APP_ENV string = 'Prod'
