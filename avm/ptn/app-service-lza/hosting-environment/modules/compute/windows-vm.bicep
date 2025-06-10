targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

param vmName string
param vmSize string
param vmWindowsOSVersion string = '2016-Datacenter'
param vmZone int = 0
param vmVnetName string
param vmSubnetName string
param vmSubnetAddressPrefix string
param vmNetworkSecurityGroupName string
param vmNetworkInterfaceName string
param logAnalyticsWorkspaceResourceId string
param bastionResourceId string
param vmAdminUsername string

@secure()
param vmAdminPassword string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

param location string = resourceGroup().location

module vmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.0' = {
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
module vmSubnet 'br/public:avm/res/network/virtual-network/subnet:0.1.1' = {
  params: {
    name: vmSubnetName
    virtualNetworkName: vmVnetName
    addressPrefix: vmSubnetAddressPrefix
    networkSecurityGroupResourceId: vmNetworkSecurityGroup.outputs.resourceId
  }
}

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: 'win-mc-${vmName}'
  location: location
  properties: {
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
    }
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.12.1' = {
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
    encryptionAtHost: false
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.id
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
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    zone: vmZone
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
          dataCollectionRuleResourceId: dcr.id
        }
      ]
    }
  }
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2023-03-11' = {
  name: 'dcr-${vmName}'
  location: location
  kind: 'Windows'
  tags: tags
  properties: {
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
