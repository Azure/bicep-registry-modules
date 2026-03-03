targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('Required. The name of the virtual machine.')
param vmName string

@description('Required. The size of the virtual machine (e.g. "Standard_B2s").')
param vmSize string

@description('Optional. The Windows OS version for the virtual machine image.')
param vmWindowsOSVersion string = '2025-datacenter-g2'

@description('Optional. Enable encryption at host for the VM. Defaults to true for WAF alignment.')
param encryptionAtHost bool = true

@description('Optional. The OS disk size in GB for the VM.')
param osDiskSizeGB int = 128

@description('Optional. The storage account type for the OS disk.')
param osDiskStorageAccountType ('PremiumV2_LRS' | 'Premium_LRS' | 'Premium_ZRS' | 'StandardSSD_LRS' | 'StandardSSD_ZRS' | 'Standard_LRS' | 'UltraSSD_LRS') = 'Premium_LRS'

@description('Optional. The availability zone for the virtual machine. Set to 0 for no zone.')
param vmZone int = 0

@description('Optional. The start date and time for the maintenance window (e.g. "2026-06-16 00:00").')
param maintenanceWindowStartDateTime string = '2026-06-16 00:00'

@description('Optional. The duration of the maintenance window (e.g. "03:55").')
param maintenanceWindowDuration string = '03:55'

@description('Optional. The timezone for the maintenance window.')
param maintenanceWindowTimeZone string = 'UTC'

@description('Optional. The recurrence of the maintenance window (e.g. "1Day", "1Week Saturday").')
param maintenanceWindowRecurrence string = '1Day'

@description('Required. The name of the virtual network containing the VM subnet.')
param vmVnetName string

@description('Required. The name of the subnet for the virtual machine.')
param vmSubnetName string

@description('Required. The address prefix for the VM subnet.')
param vmSubnetAddressPrefix string

@description('Required. The name of the network security group for the virtual machine.')
param vmNetworkSecurityGroupName string

@description('Required. The name of the network interface for the virtual machine.')
param vmNetworkInterfaceName string

@description('Required. The resource ID of the Log Analytics workspace for monitoring.')
param logAnalyticsWorkspaceResourceId string

@description('Required. The resource ID of the Bastion host. If empty, Bastion-specific NSG rules are not created.')
param bastionResourceId string

@description('Required. The admin username for the virtual machine.')
param vmAdminUsername string

@secure()
@description('Required. The admin password for the virtual machine.')
param vmAdminPassword string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Optional. The location for the resources.')
param location string = resourceGroup().location

module vmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: '${uniqueString(deployment().name, location)}-vm-nsg'
  params: {
    name: vmNetworkSecurityGroupName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: !empty(bastionResourceId)
      ? [
          {
            name: 'allow-bastion-inbound'
            properties: {
              description: 'Allow inbound traffic from Bastion to the JumpBox'
              protocol: '*'
              sourceAddressPrefix: 'Bastion'
              sourcePortRange: '*'
              destinationAddressPrefix: '*'
              destinationPortRange: '*'
              access: 'Allow'
              priority: 100
              direction: 'Inbound'
            }
          }
          {
            name: 'deny-hop-outbound'
            properties: {
              priority: 200
              access: 'Deny'
              protocol: 'Tcp'
              direction: 'Outbound'
              sourcePortRange: '*'
              sourceAddressPrefix: 'VirtualNetwork'
              destinationAddressPrefix: '*'
              destinationPortRanges: [
                '3389'
                '22'
              ]
            }
          }
        ]
      : [
          {
            name: 'deny-hop-outbound'
            properties: {
              priority: 200
              access: 'Deny'
              protocol: 'Tcp'
              direction: 'Outbound'
              sourcePortRange: '*'
              sourceAddressPrefix: 'VirtualNetwork'
              destinationAddressPrefix: '*'
              destinationPortRanges: [
                '3389'
                '22'
              ]
            }
          }
        ]
  }
}

//TODO: Subnet deployment needs to be updated with AVM module once it is available
module vmSubnet 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  params: {
    name: vmSubnetName
    virtualNetworkName: vmVnetName
    addressPrefix: vmSubnetAddressPrefix
    networkSecurityGroupResourceId: vmNetworkSecurityGroup.outputs.resourceId
  }
}

module maintenanceConfiguration 'br/public:avm/res/maintenance/maintenance-configuration:0.3.2' = {
  name: '${uniqueString(deployment().name, location)}-win-mc'
  params: {
    name: 'win-mc-${vmName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    maintenanceScope: 'InGuestPatch'
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceWindow: {
      startDateTime: maintenanceWindowStartDateTime
      duration: maintenanceWindowDuration
      timeZone: maintenanceWindowTimeZone
      recurEvery: maintenanceWindowRecurrence
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
    }
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: '${uniqueString(deployment().name, location)}-win-vm'
  params: {
    name: vmName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    osType: 'Windows'
    computerName: vmName
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    encryptionAtHost: encryptionAtHost
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.outputs.resourceId
    nicConfigurations: [
      {
        name: vmNetworkInterfaceName
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipconfig1'
            privateIPAllocationMethod: 'Dynamic'
            subnetResourceId: vmSubnet.outputs.resourceId
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: osDiskSizeGB
      managedDisk: {
        storageAccountType: osDiskStorageAccountType
      }
    }
    availabilityZone: vmZone
    vmSize: vmSize
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: vmWindowsOSVersion
      version: 'latest'
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      tags: tags
      dataCollectionRuleAssociations: [
        {
          name: 'SendMetricsToLAW'
          dataCollectionRuleResourceId: dcr.outputs.resourceId
        }
      ]
    }
  }
}

module dcr 'br/public:avm/res/insights/data-collection-rule:0.10.0' = {
  name: '${uniqueString(deployment().name, location)}-win-dcr'
  params: {
    name: 'dcr-${vmName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
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
