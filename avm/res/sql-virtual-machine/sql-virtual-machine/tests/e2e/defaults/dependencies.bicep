@description('Required. The name of the virtual machine to create.')
param virtualMachineName string

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string

@description('Required. The name of the network security group to create.')
param networkSecurityGroupName string

@description('Required. The administrator password for the virtual machine.')
@secure()
param adminPassword string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: networkSecurityGroupName
  location: location
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.22.3' = {
  name: '${uniqueString(deployment().name, location)}-vm'
  params: {
    name: virtualMachineName
    computerName: take(virtualMachineName, 15)
    location: location
    adminUsername: 'localAdminUser'
    adminPassword: adminPassword
    availabilityZone: -1
    imageReference: {
      publisher: 'MicrosoftSQLServer'
      offer: 'SQL2022-WS2022'
      sku: 'sqldev-gen2'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: virtualNetwork.properties.subnets[0].id
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: 128
      caching: 'ReadWrite'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D4s_v7'
  }
}

@description('The resource ID of the created virtual machine.')
output virtualMachineResourceId string = virtualMachine.outputs.resourceId
