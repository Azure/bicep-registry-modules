// /****************************************************************************************************************************/
// Create Jumpbox NSG and Jumpbox Subnet, then create Jumpbox VM
// /****************************************************************************************************************************/

@description('Required. Name of the Jumpbox Virtual Machine.')
param name string

@description('Optional. Azure region to deploy resources.')
param location string = resourceGroup().location

@description('Required. Name of the Virtual Network where the Jumpbox VM will be deployed.')
param vnetName string

@description('Required. Size of the Jumpbox Virtual Machine.')
param size string

import { subnetType } from 'virtualNetwork.bicep'
@description('Optional. Subnet configuration for the Jumpbox VM.')
param subnet subnetType?

@secure()
@description('Required. Username to access the Jumpbox VM.')
param username string

@secure()
@description('Required. Password to access the Jumpbox VM.')
param password string

@description('Optional. Tags to apply to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Required. Log Analytics Workspace Resource ID for VM diagnostics.')
param logAnalyticsWorkspaceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// 1. Create Jumpbox NSG
// using AVM Network Security Group module
// https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/network-security-group
module nsg 'br/public:avm/res/network/network-security-group:0.5.1' = if (!empty(subnet)) {
  name: '${vnetName}-${subnet.?networkSecurityGroup.name}'
  params: {
    name: '${vnetName}-${subnet.?networkSecurityGroup.name}'
    location: location
    securityRules: subnet.?networkSecurityGroup.securityRules
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// 2. Create Jumpbox subnet as part of the existing VNet
// using AVM Virtual Network Subnet module
// https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/virtual-network/subnet
module subnetResource 'br/public:avm/res/network/virtual-network/subnet:0.1.2' = if (!empty(subnet)) {
  name: subnet.?name ?? '${vnetName}-jumpbox-subnet'
  params: {
    virtualNetworkName: vnetName
    name: subnet.?name ?? ''
    addressPrefixes: subnet.?addressPrefixes
    networkSecurityGroupResourceId: nsg.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

// 3. Create Jumpbox VM
// using AVM Virtual Machine module
// https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/compute/virtual-machine
var vmName = take(name, 15) // Shorten VM name to 15 characters to avoid Azure limits

module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.3.1' = {
  name: take('${vmName}-jumpbox-maintenance-config', 64)
  params: {
    name: 'mc-${vmName}'
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

module windowsVmDataCollectionRules 'br/public:avm/res/insights/data-collection-rule:0.6.0' = {
  name: take('${vmName}-jumpbox-data-collection-rule', 64)
  params: {
    name: 'dcr-${vmName}'
    tags: tags
    enableTelemetry: enableTelemetry
    location: location
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
            workspaceResourceId: logAnalyticsWorkspaceId
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

module proximityPlacementGroup 'br/public:avm/res/compute/proximity-placement-group:0.3.2' = {
  name: take('${vmName}-jumpbox-prox-place-group', 64)
  params: {
    name: 'ppg-${vmName}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.15.0' = {
  name: take('${vmName}-jumpbox', 64)
  params: {
    name: vmName
    vmSize: size
    location: location
    computerName: vmName
    adminUsername: username
    adminPassword: password
    tags: tags
    zone: 2
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    osDisk: {
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    enableAutomaticUpdates: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.outputs.resourceId
    proximityPlacementGroupResourceId: proximityPlacementGroup.outputs.resourceId
    encryptionAtHost: false // Some Azure subscriptions do not support encryption at host
    nicConfigurations: [
      {
        name: '${vmName}-nic'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: subnetResource.outputs.resourceId
          }
        ]
        networkSecurityGroupResourceId: nsg.outputs.resourceId
        diagnosticSettings: [
          {
            name: 'jumpboxDiagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
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
    extensionNetworkWatcherAgentConfig: {
      enabled: true
      tags: tags
    }
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the Jumpbox Virtual Machine.')
output name string = vm.outputs.name

@description('Resource ID of the Jumpbox Virtual Machine.')
output resourceId string = vm.outputs.resourceId

@description('Location of the Jumpbox Virtual Machine.')
output location string = vm.outputs.location

@description('Resource ID of the Jumpbox Subnet.')
output subnetId string = subnetResource.outputs.resourceId

@description('Name of the Jumpbox Subnet.')
output subnetName string = subnetResource.outputs.name

@description('Resource ID of the Jumpbox Network Security Group.')
output nsgId string = nsg.outputs.resourceId

@description('Name of the Jumpbox Network Security Group.')
output nsgName string = nsg.outputs.name

@export()
@secure()
@description('Custom type definition for establishing Jumpbox Virtual Machine and its associated resources.')
type jumpBoxConfigurationType = {
  @description('Required. The name of the Virtual Machine.')
  name: string

  @description('Optional. The size of the VM.')
  size: string?

  @secure()
  @description('Required. Username to access VM.')
  username: string

  @secure()
  @description('Required. Password to access VM.')
  password: string

  @description('Optional. Subnet configuration for the Jumpbox VM.')
  subnet: subnetType?
}
