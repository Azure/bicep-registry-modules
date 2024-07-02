targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

param vmName string
param vmSize string
param storageAccountType string = 'Standard_LRS'
param vmWindowsOSVersion string = '2016-Datacenter'
param vmZone int = 0
param vmVnetName string
param vmSubnetName string
param vmSubnetAddressPrefix string
param vmNetworkSecurityGroupName string
param vmNetworkInterfaceName string

param vmAdminUsername string

@secure()
param vmAdminPassword string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

param location string = resourceGroup().location

// ------------------
// VARIABLES
// ------------------
var nsgVmRules = loadJsonContent('./nsgJumpBox.jsonc', 'securityRules')

// ------------------
// RESOURCES
// ------------------

module vmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.2.0' = {
  name: 'vmNetworkSecurityDeployment'
  params: {
    name: vmNetworkSecurityGroupName
    location: location
    tags: tags
    securityRules: nsgVmRules
  }
}

//TODO: Subnet deployment needs to be updated with AVM module once it is available
resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  name: '${vmVnetName}/${vmSubnetName}'
  properties: {
    addressPrefix: vmSubnetAddressPrefix
    networkSecurityGroup: {
      id: vmNetworkSecurityGroup.outputs.resourceId
    }
  }
}

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: 'dep-mc-${vmName}'
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

module vm 'br/public:avm/res/compute/virtual-machine:0.5.1' = {
  name: 'vmDeployment'
  params: {
    name: vmName
    location: location
    tags: tags
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
            subnetResourceId: vmSubnet.id
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
        storageAccountType: storageAccountType
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
  }
}
