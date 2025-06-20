// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Multi-Agent Custom Automation Engine'
metadata description = '''This module contains the resources required to deploy the [Multi-Agent Custom Automation Engine solution accelerator](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator) for both Sandbox environments and WAF aligned environments.

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

@description('Optional. The prefix to add in the default names given to all deployed Azure resources.')
@maxLength(19)
param solutionPrefix string = 'macae${uniqueString(deployer().objectId, deployer().tenantId, subscription().subscriptionId, resourceGroup().id)}'

@description('Optional. Location for all Resources except AI Foundry.')
param solutionLocation string = 'australiaeast'

@description('Optional. Failover Location for applicable resources. This location will apply if `enableScalability` is set to `true`. Check [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) for more information on supported regions, and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions) for supported regions for CosmosDB.')
param failoverLocation string = 'uksouth'

// Restricting deployment to only supported Azure OpenAI regions validated with GPT-4o model
@allowed(['australiaeast', 'eastus2', 'francecentral', 'japaneast', 'norwayeast', 'swedencentral', 'uksouth', 'westus'])
@description('Optional. The location of OpenAI related resources. This should be one of the supported Azure OpenAI regions.')
param azureOpenAILocation string = 'westus'

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {
  app: solutionPrefix
  location: solutionLocation
}

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
param virtualMachineAdminUsername string = take(newGuid(), 20)

@description('Optional. The password for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.')
@secure()
param virtualMachineAdminPassword string = newGuid()

@description('Optional. The Container Registry hostname where the docker images for the backend are located.')
param backendContainerRegistryHostname string = 'biabcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the backend.')
param backendContainerImageName string = 'macaebackend'

@description('Optional. The Container Image Tag to deploy on the backend.')
param backendContainerImageTag string = 'hotfix_2025-06-17_704'

@description('Optional. The Container Registry hostname where the docker images for the frontend are located.')
param frontendContainerRegistryHostname string = 'biabcontainerreg.azurecr.io'

@description('Optional. The Container Image Name to deploy on the frontend.')
param frontendContainerImageName string = 'macaefrontend'

@description('Optional. The Container Image Tag to deploy on the frontend.')
param frontendContainerImageTag string = 'hotfix_2025-06-17_704'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.sa-multiagentcustauteng.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, solutionLocation), 0, 4)}'
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

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// WAF PSRules for Log Analytics: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#azure-monitor-logs
var logAnalyticsWorkspaceResourceName = 'log-${solutionPrefix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: 'log-${solutionPrefix}'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 365
    features: { enableLogAccessUsingOnlyResourcePermissions: true }
    diagnosticSettings: [{ useThisWorkspace: true }]
    // WAF aligned configuration for Redundancy
    dailyQuotaGb: enableRedundancy ? 10 : null //WAF recommendation: 10 GB per day is a good starting point for most workloads
    // WAF aligned configuration for Private Networking
    //TODO: Configure private link for Log Analytics Workspace
    //publicNetworkAccessForIngestion: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    //publicNetworkAccessForQuery: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    dataSources: enablePrivateNetworking
      ? [
          {
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

// ========== Application Insights ========== //
// WAF best practices for Application Insights: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/application-insights
// WAF PSRules for  Application Insights: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#application-insights
var applicationInsightsResourceName = 'appi-${solutionPrefix}'
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (enableMonitoring) {
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
    // WAF aligned configuration for Monitoring
    workspaceResourceId: enableMonitoring ? logAnalyticsWorkspace.outputs.resourceId : ''
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
  }
}

// ========== User assigned identity Web Site ========== //
// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access

// ========== Network Security Groups ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
var networkSecurityGroupBackendResourceName = 'nsg-backend-${solutionPrefix}'
module networkSecurityGroupBackend 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupBackendResourceName}', 64)
  params: {
    name: networkSecurityGroupBackendResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 200
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

var networkSecurityGroupContainersResourceName = 'nsg-containers-${solutionPrefix}'
module networkSecurityGroupContainers 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupContainersResourceName}', 64)
  params: {
    name: networkSecurityGroupContainersResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 200
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

var networkSecurityGroupBastionResourceName = 'nsg-bastion-${solutionPrefix}'
module networkSecurityGroupBastion 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupBastionResourceName}', 64)
  params: {
    name: networkSecurityGroupBastionResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowLoadBalancerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '443'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

var networkSecurityGroupAdministrationResourceName = 'nsg-administration-${solutionPrefix}'
module networkSecurityGroupAdministration 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupAdministrationResourceName}', 64)
  params: {
    name: networkSecurityGroupAdministrationResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 200
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

// ========== Virtual Network ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
var virtualNetworkResourceName = 'vnet-${solutionPrefix}'
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.virtual-network.${virtualNetworkResourceName}', 64)
  params: {
    name: virtualNetworkResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/8']
    subnets: [
      {
        name: 'backend'
        addressPrefix: '10.0.0.0/27'
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        networkSecurityGroupResourceId: networkSecurityGroupBackend.outputs.resourceId
      }
      {
        name: 'administration'
        addressPrefix: '10.0.0.32/27'
        networkSecurityGroupResourceId: networkSecurityGroupAdministration.outputs.resourceId
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        //natGatewayResourceId: natGateway.outputs.resourceId
      }
      {
        // For Azure Bastion resources deployed on or after November 2, 2021, the minimum AzureBastionSubnet size is /26 or larger (/25, /24, etc.).
        // https://learn.microsoft.com/en-us/azure/bastion/configuration-settings#subnet
        name: 'AzureBastionSubnet' //This exact name is required for Azure Bastion
        addressPrefix: '10.0.0.64/26'
        networkSecurityGroupResourceId: networkSecurityGroupBastion.outputs.resourceId
      }
      {
        // If you use your own vnw, you need to provide a subnet that is dedicated exclusively to the Container App environment you deploy. This subnet isn't available to other services
        // https://learn.microsoft.com/en-us/azure/container-apps/networking?tabs=workload-profiles-env%2Cazure-cli#custom-vnw-configuration
        name: 'containers'
        addressPrefix: '10.0.2.0/23' //subnet of size /23 is required for container app
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        delegation: 'Microsoft.App/environments'
        networkSecurityGroupResourceId: networkSecurityGroupContainers.outputs.resourceId
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
  }
}
var bastionResourceName = 'bas-${solutionPrefix}'

// ========== Bastion host ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
module bastionHost 'br/public:avm/res/network/bastion-host:0.6.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionResourceName}', 64)
  params: {
    name: bastionResourceName
    location: solutionLocation
    skuName: 'Standard'
    enableTelemetry: enableTelemetry
    tags: tags
    virtualNetworkResourceId: virtualNetwork.?outputs.?resourceId
    publicIPAddressObject: {
      name: 'pip-bas${solutionPrefix}'
      diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
      tags: tags
    }
    disableCopyPaste: true
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
    scaleUnits: 4
    //scaleUnits: bastionConfiguration.?scaleUnits
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
  }
}

// ========== Virtual machine ========== //
// WAF best practices for virtual machines: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-machines
var maintenanceConfigurationResourceName = 'mc-${solutionPrefix}'
module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.3.1' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${maintenanceConfigurationResourceName}', 64)
  params: {
    name: maintenanceConfigurationResourceName
    location: solutionLocation
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

var dataCollectionRulesResourceName = 'dcr-${solutionPrefix}'
module windowsVmDataCollectionRules 'br/public:avm/res/insights/data-collection-rule:0.6.0' = if (enablePrivateNetworking && enableMonitoring) {
  name: take('avm.res.insights.data-collection-rule.${dataCollectionRulesResourceName}', 64)
  params: {
    name: dataCollectionRulesResourceName
    tags: tags
    enableTelemetry: enableTelemetry
    location: solutionLocation
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
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
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

var proximityPlacementGroupResourceName = 'ppg-${solutionPrefix}'
module proximityPlacementGroup 'br/public:avm/res/compute/proximity-placement-group:0.3.2' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.proximity-placement-group.${proximityPlacementGroupResourceName}', 64)
  params: {
    name: proximityPlacementGroupResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

var virtualMachineResourceName = 'vm${solutionPrefix}'
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.15.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${virtualMachineResourceName}', 64)
  params: {
    name: virtualMachineResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    computerName: take(virtualMachineResourceName, 15)
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    adminUsername: virtualMachineAdminUsername
    adminPassword: virtualMachineAdminPassword
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.outputs.resourceId
    enableAutomaticUpdates: true
    encryptionAtHost: false
    zone: 2
    proximityPlacementGroupResourceId: proximityPlacementGroup.outputs.resourceId
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
          ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
          : null
        ipConfigurations: [
          {
            name: '${virtualMachineResourceName}-nic01-ipconfig01'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
            diagnosticSettings: enableMonitoring //WAF aligned configuration for Monitoring
              ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
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
              dataCollectionRuleResourceId: windowsVmDataCollectionRules.outputs.resourceId
              name: 'send-${logAnalyticsWorkspace.outputs.name}'
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

// ========== AI Foundry: AI Services ========== //
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai
var openAiSubResource = 'account'
var openAiPrivateDnsZones = {
  'privatelink.cognitiveservices.azure.com': openAiSubResource
  'privatelink.openai.azure.com': openAiSubResource
  'privatelink.services.ai.azure.com': openAiSubResource
}

module privateDnsZonesAiServices 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in objectKeys(openAiPrivateDnsZones): if (enablePrivateNetworking) {
    name: take(
      'avm.res.network.private-dns-zone.ai-services.${uniqueString(aiFoundryAiServicesResourceName,zone)}.${solutionPrefix}',
      64
    )
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetworkResourceName}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]

// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
var aiFoundryAiServicesResourceName = 'aisa-${solutionPrefix}'
var aiFoundryAiServicesAiProjectResourceName = 'aifp-${solutionPrefix}'
var aiFoundryAIservicesEnabled = true
var aiFoundryAiServicesModelDeployment = {
  format: 'OpenAI'
  name: 'gpt-4o'
  version: '2024-08-06'
  sku: {
    name: 'GlobalStandard'
    //Currently the capacity is set to 140 for optimal performance.
    capacity: 140
  }
  raiPolicyName: 'Microsoft.Default'
}

module aiFoundryAiServices 'modules/ai-services.bicep' = if (aiFoundryAIservicesEnabled) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    location: azureOpenAILocation
    tags: tags
    projectName: aiFoundryAiServicesAiProjectResourceName
    projectDescription: 'AI Foundry Project'
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    customSubDomainName: aiFoundryAiServicesResourceName
    apiProperties: {
      //staticsEnabled: false
    }
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: { systemAssigned: true }
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    privateEndpoints: enablePrivateNetworking
      ? ([
          {
            name: 'pep-${aiFoundryAiServicesResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiServicesResourceName}'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: map(objectKeys(openAiPrivateDnsZones), zone => {
                name: replace(zone, '.', '-')
                privateDnsZoneResourceId: resourceId('Microsoft.Network/privateDnsZones', zone)
              })
            }
          }
        ])
      : []
    deployments: [
      {
        name: aiFoundryAiServicesModelDeployment.name
        model: {
          format: aiFoundryAiServicesModelDeployment.format
          name: aiFoundryAiServicesModelDeployment.name
          version: aiFoundryAiServicesModelDeployment.version
        }
        raiPolicyName: aiFoundryAiServicesModelDeployment.raiPolicyName
        sku: {
          name: aiFoundryAiServicesModelDeployment.sku.name
          capacity: aiFoundryAiServicesModelDeployment.sku.capacity
        }
      }
    ]
  }
}
//Role assignments for AI Foundry

module resourceRoleAssignmentAiServicesAiUser 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'avm.ptn.authorization.resource-role-assignment.${uniqueString(aiFoundryAiServicesResourceName,containerAppResourceName,'Azure AI User')}'
  params: {
    roleName: 'Azure AI User'
    roleDefinitionId: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
    principalId: containerApp.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

module resourceRoleAssignmentAiServicesAiDeveloper 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'avm.ptn.authorization.resource-role-assignment.${uniqueString(aiFoundryAiServicesResourceName,containerAppResourceName,'Azure AI Developer')}'
  params: {
    roleName: 'Azure AI Developer'
    roleDefinitionId: '64702f94-c441-49e6-a78b-ef80e0188fee'
    principalId: containerApp.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

module resourceRoleAssignmentAiServicesCognitiveServicesOpenAiUser 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'avm.ptn.authorization.resource-role-assignment.${uniqueString(aiFoundryAiServicesResourceName,containerAppResourceName,'Cognitive Services OpenAI User')}'
  params: {
    roleName: 'Cognitive Services OpenAI User'
    roleDefinitionId: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
    principalId: containerApp.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

//Role assignments for AI Project

module resourceRoleAssignmentAiServicesAiProjectAiUser 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'avm.ptn.authorization.resource-role-assignment.${uniqueString(aiFoundryAiServicesAiProjectResourceName,containerAppResourceName,'Azure AI User')}'
  params: {
    roleName: 'Azure AI User'
    roleDefinitionId: '53ca6127-db72-4b80-b1b0-d745d6d5456d'
    principalId: containerApp.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.aiProjectResourceId
    enableTelemetry: enableTelemetry
  }
}

module resourceRoleAssignmentAiServicesAiProjectAiDeveloper 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'avm.ptn.authorization.resource-role-assignment.${uniqueString(aiFoundryAiServicesAiProjectResourceName,containerAppResourceName,'Azure AI Developer')}'
  params: {
    roleName: 'Azure AI Developer'
    roleDefinitionId: '64702f94-c441-49e6-a78b-ef80e0188fee'
    principalId: containerApp.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.aiProjectResourceId
    enableTelemetry: enableTelemetry
  }
}

module resourceRoleAssignmentAiServicesAiProjectCognitiveServicesOpenAiUser 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: 'avm.ptn.authorization.resource-role-assignment.${uniqueString(aiFoundryAiServicesAiProjectResourceName,containerAppResourceName,'Cognitive Services OpenAI User')}'
  params: {
    roleName: 'Cognitive Services OpenAI User'
    roleDefinitionId: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
    principalId: containerApp.outputs.systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.aiProjectResourceId
    enableTelemetry: enableTelemetry
  }
}

// ========== Cosmos DB ========== //
// WAF best practices for Cosmos DB: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/cosmos-db
module privateDnsZonesCosmosDb 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.private-dns-zone.cosmos-db.${solutionPrefix}', 64)
  params: {
    name: 'privatelink.documents.azure.com'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        name: take('vnetlink-${virtualNetworkResourceName}-documents', 80)
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
      }
    ]
    tags: tags
  }
}

var cosmosDbResourceName = 'cosmos-${solutionPrefix}'
var cosmosDbDatabaseName = 'macae'
var cosmosDbDatabaseMemoryContainerName = 'memory'

//TODO: update to latest version of AVM module
module cosmosDb 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: 'cosmos-${solutionPrefix}'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    sqlDatabases: [
      {
        name: cosmosDbDatabaseName
        containers: [
          {
            name: cosmosDbDatabaseMemoryContainerName
            paths: [
              '/session_id'
            ]
            kind: 'Hash'
            version: 2
          }
        ]
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
        assignments: [{ principalId: containerApp.outputs.systemAssignedMIPrincipalId! }]
      }
    ]
    // WAF aligned configuration for Monitoring
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
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
              privateDnsZoneGroupConfigs: [{ privateDnsZoneResourceId: privateDnsZonesCosmosDb.outputs.resourceId }]
            }
            service: 'Sql'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
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
            locationName: solutionLocation
          }
          {
            failoverPriority: 1
            isZoneRedundant: true
            locationName: failoverLocation
          }
        ]
      : [
          {
            locationName: solutionLocation
            failoverPriority: 0
          }
        ]
  }
}

// ========== Backend Container App Environment ========== //
// WAF best practices for container apps: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-container-apps
// PSRule for Container App: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#container-app
var containerAppEnvironmentResourceName = 'cae-${solutionPrefix}'
module containerAppEnvironment 'modules/container-app-environment.bicep' = {
  name: take('module.container-app-environment.${containerAppEnvironmentResourceName}', 64)
  params: {
    name: containerAppEnvironmentResourceName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    //aspireDashboardEnabled: TODO
    // WAF aligned configuration for Private Networking
    enablePrivateNetworking: enablePrivateNetworking
    subnetResourceId: enablePrivateNetworking ? virtualNetwork.?outputs.?subnetResourceIds[3] : null
    // WAF aligned configuration for Monitoring
    logAnalyticsResourceName: enableMonitoring ? logAnalyticsWorkspace.outputs.name : null
    enableMonitoring: enableMonitoring
    // WAF aligned configuration for Redundancy
    enableRedundancy: enableRedundancy
  }
}

// ========== Backend Container App Service ========== //
// WAF best practices for container apps: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-container-apps
// PSRule for Container App: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#container-app
var containerAppResourceName = 'ca-${solutionPrefix}'
module containerApp 'br/public:avm/res/app/container-app:0.17.0' = {
  name: take('avm.res.app.container-app.${containerAppResourceName}', 64)
  params: {
    name: containerAppResourceName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppEnvironment.outputs.resourceId
    managedIdentities: { systemAssigned: true }
    ingressTargetPort: 8000
    ingressExternal: true
    activeRevisionsMode: 'Single'
    corsPolicy: {
      allowedOrigins: [
        'https://${webSiteName}.azurewebsites.net'
        'http://${webSiteName}.azurewebsites.net'
      ]
    }
    // WAF aligned configuration for Scalability
    scaleSettings: {
      maxReplicas: enableScalability ? 3 : 1
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
        name: 'backend'
        image: '${backendContainerRegistryHostname}/${backendContainerImageName}:${backendContainerImageTag}'
        //TODO: configure probes for container app
        // probes: [
        //   {
        //     httpGet: {
        //       httpHeaders: [
        //         {
        //           name: 'Custom-Header'
        //           value: 'Awesome'
        //         }
        //       ]
        //       path: '/health'
        //       port: 8080
        //     }
        //     initialDelaySeconds: 3
        //     periodSeconds: 3
        //     type: 'Liveness'
        //   }
        // ]
        resources: {
          cpu: '2.0'
          memory: '4.0Gi'
        }
        env: [
          {
            name: 'COSMOSDB_ENDPOINT'
            value: 'https://${cosmosDbResourceName}.documents.azure.com:443/'
          }
          {
            name: 'COSMOSDB_DATABASE'
            value: cosmosDbDatabaseName
          }
          {
            name: 'COSMOSDB_CONTAINER'
            value: cosmosDbDatabaseMemoryContainerName
          }
          {
            name: 'AZURE_OPENAI_ENDPOINT'
            value: 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'
          }
          {
            name: 'AZURE_OPENAI_MODEL_NAME'
            value: aiFoundryAiServicesModelDeployment.name
          }
          {
            name: 'AZURE_OPENAI_DEPLOYMENT_NAME'
            value: aiFoundryAiServicesModelDeployment.name
          }
          {
            name: 'AZURE_OPENAI_API_VERSION'
            value: '2025-01-01-preview' //TODO: set parameter/variable
          }
          {
            name: 'APPLICATIONINSIGHTS_INSTRUMENTATION_KEY'
            value: enableMonitoring ? applicationInsights.outputs.instrumentationKey : ''
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: enableMonitoring ? applicationInsights.outputs.connectionString : ''
          }
          {
            name: 'AZURE_AI_SUBSCRIPTION_ID'
            value: subscription().subscriptionId
          }
          {
            name: 'AZURE_AI_RESOURCE_GROUP'
            value: resourceGroup().name
          }
          {
            name: 'AZURE_AI_PROJECT_NAME'
            value: aiFoundryAiServicesAiProjectResourceName
          }
          {
            name: 'FRONTEND_SITE_NAME'
            value: 'https://${webSiteName}.azurewebsites.net'
          }
          {
            name: 'AZURE_AI_AGENT_ENDPOINT'
            value: aiFoundryAiServices.outputs.aiProjectApiEndpoint
          }
          {
            name: 'AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME'
            value: aiFoundryAiServicesModelDeployment.name
          }
        ]
      }
    ]
  }
}

// ========== Frontend server farm ========== //
// WAF best practices for Web Application Services: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service
var webServerFarmResourceName = 'asp-${solutionPrefix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: tags
    location: solutionLocation
    skuName: enableScalability ? 'P1v3' : 'B3'
    skuCapacity: enableScalability ? 3 : 1
    reserved: true
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    kind: 'linux'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
    enableTelemetry: enableTelemetry
  }
}

// ========== Frontend web site ========== //
// WAF best practices for web app service: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
// PSRule for Web Server Farm: https://azure.github.io/PSRule.Rules.Azure/en/rules/resource/#app-service

//NOTE: AVM module adds 1 MB of overhead to the template. Keeping vanilla resource to save template size.
var webSiteName = 'app-${solutionPrefix}'
module webSite 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteName}', 64)
  params: {
    name: webSiteName
    tags: tags
    location: solutionLocation
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
    siteConfig: {
      linuxFxVersion: 'DOCKER|${frontendContainerRegistryHostname}/${frontendContainerImageName}:${frontendContainerImageTag}'
      minTlsVersion: '1.2'
    }
    configs: [
      {
        name: 'appsettings'
        applicationInsightResourceId: enableMonitoring ? applicationInsights.outputs.resourceId : null
        properties: {
          SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
          DOCKER_REGISTRY_SERVER_URL: 'https://${frontendContainerRegistryHostname}'
          WEBSITES_PORT: '3000'
          WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
          BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
          AUTH_ENABLED: 'false'
        }
      }
    ]
  }
}
// ============ //
// Outputs      //
// ============ //

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The default url of the website to connect to the Multi-Agent Custom Automation Engine solution.')
output webSiteDefaultHostname string = webSite.outputs.defaultHostname
