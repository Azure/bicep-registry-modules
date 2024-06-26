targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

param vmName string
param vmSize string

param vmWindowsOSVersion string = '2016-Datacenter'

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
// RESOURCES
// ------------------

module vmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.2.0' = {
  name: 'vmNetworkSecurityDeployment'
  params: {
    name: vmNetworkSecurityGroupName
    location: location
    tags: tags
    securityRules: []
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

module vm 'br/public:avm/res/compute/virtual-machine:0.5.0' = {
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
        storageAccountType: 'Standard_LRS'
      }
    }
    zone: 0
    vmSize: vmSize
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: vmWindowsOSVersion
      version: 'latest'
    }
  }
}
