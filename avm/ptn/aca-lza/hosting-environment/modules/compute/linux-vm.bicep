targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

param vmName string
param vmSize string

param vmVnetName string
param vmSubnetName string
param vmSubnetAddressPrefix string
param vmNetworkSecurityGroupName string
param vmNetworkInterfaceName string

param vmAdminUsername string

@secure()
param vmAdminPassword string

@secure()
param vmSshPublicKey string

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

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
    osType: 'Linux'
    computerName: vmName
    adminUsername: vmAdminUsername
    adminPassword: ((vmAuthenticationType == 'password') ? vmAdminPassword : null)
    disablePasswordAuthentication: ((vmAuthenticationType == 'password') ? false : true)
    encryptionAtHost: false
    publicKeys: ((vmAuthenticationType == 'sshPublicKey')
      ? [
          {
            keyData: vmSshPublicKey
            path: '/home/localAdminUser/.ssh/authorized_keys'
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
      publisher: 'canonical'
      offer: '0001-com-ubuntu-server-focal'
      sku: '20_04-lts-gen2'
      version: 'latest'
    }
  }
}
