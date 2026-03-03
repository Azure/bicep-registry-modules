targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('Required. The name of the virtual machine.')
param vmName string

@description('Required. The size of the virtual machine (e.g. "Standard_B2s").')
param vmSize string

@description('Optional. The availability zone for the virtual machine. Set to 0 for no zone.')
param vmZone int = 0

@description('Optional. The Linux OS image publisher.')
param vmImagePublisher string = 'canonical'

@description('Optional. The Linux OS image offer.')
param vmImageOffer string = 'ubuntu-24_04-lts'

@description('Optional. The Linux OS image SKU.')
param vmImageSku string = 'server-gen2'

@description('Optional. Enable encryption at host for the VM. Defaults to true for WAF alignment.')
param encryptionAtHost bool = true

@description('Optional. The OS disk size in GB for the VM.')
param osDiskSizeGB int = 128

@description('Optional. The storage account type for the OS disk.')
param osDiskStorageAccountType ('PremiumV2_LRS' | 'Premium_LRS' | 'Premium_ZRS' | 'StandardSSD_LRS' | 'StandardSSD_ZRS' | 'Standard_LRS' | 'UltraSSD_LRS') = 'Premium_LRS'

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
@description('Required. The admin password for the virtual machine. Used when authenticationType is "password".')
param vmAdminPassword string

@description('Optional. Name of the SSH key for the jumpbox.')
param sshKeyName string = 'jumpboxSshKey'

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Optional. The location for the resources.')
param location string = resourceGroup().location

@description('Optional. The name of the user-assigned identity used to generate the SSH key for the Linux VM.')
param sshKeyGenName string = guid(resourceGroup().id, 'userAssignedIdentity')

var roleAssignmentName = guid(resourceGroup().id, 'contributor', 'sshKeyGen')
var contributorRoleDefinitionId = resourceId(
  'Microsoft.Authorization/roleDefinitions',
  'b24988ac-6180-42a0-ab88-20f7382dd24c'
)

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
  name: '${uniqueString(deployment().name, location)}-linux-mc'
  params: {
    name: 'linux-mc-${vmName}'
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
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

@description('The User Assigned Managed Identity used to generate the SSH key for the Linux VM.')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: '${uniqueString(deployment().name, location)}-ssh-uami'
  params: {
    name: sshKeyGenName
    location: location
  }
}

@description('The role assignment granting the User Assigned Managed Identity Contributor role on the resource group.')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: resourceGroup()
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: userAssignedIdentity.outputs.principalId
    principalType: 'ServicePrincipal'
  }
}

#disable-next-line BCP081
module sshDeploymentScript 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: '${uniqueString(deployment().name, location)}-ssh-script'
  params: {
    name: 'sshDeploymentScriptName'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    kind: 'AzurePowerShell'
    managedIdentities: {
      userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId]
    }
    azPowerShellVersion: '11.0'
    retentionInterval: 'P1D'
    arguments: '-SSHKeyName "${sshKeyName}" -ResourceGroupName "${resourceGroup().name}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')
  }
  dependsOn: [
    roleAssignment
  ]
}

module sshKey 'br/public:avm/res/compute/ssh-public-key:0.4.4' = {
  name: '${uniqueString(deployment().name, location)}-ssh-key'
  params: {
    name: sshKeyName
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    publicKey: sshDeploymentScript.outputs.outputs.publicKey
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: '${uniqueString(deployment().name, location)}-linux-vm'
  params: {
    name: vmName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    osType: 'Linux'
    computerName: vmName
    adminUsername: vmAdminUsername
    adminPassword: ((vmAuthenticationType == 'password') ? vmAdminPassword : null)
    disablePasswordAuthentication: ((vmAuthenticationType == 'sshPublicKey') ? true : false)
    encryptionAtHost: encryptionAtHost
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.outputs.resourceId
    publicKeys: ((vmAuthenticationType == 'sshPublicKey')
      ? [
          {
            keyData: sshDeploymentScript.outputs.outputs.publicKey
            path: '/home/${vmAdminUsername}/.ssh/authorized_keys'
          }
        ]
      : [])
    nicConfigurations: [
      {
        name: vmNetworkInterfaceName
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipConfig01'
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
      publisher: vmImagePublisher
      offer: vmImageOffer
      sku: vmImageSku
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
  name: '${uniqueString(deployment().name, location)}-linux-dcr'
  params: {
    name: 'dcr-${vmName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    dataCollectionRuleProperties: {
      kind: 'Linux'
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
