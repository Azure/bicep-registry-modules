@description('Required. Location to deploy resources to.')
param resourceLocation string

@description('Required. The name of the Virtual Machine to create.')
param virtualMachineName string

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
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
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.5.3' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${virtualMachineName}'
  params: {
    location: resourceLocation
    name: virtualMachineName
    adminUsername: 'localAdminUser'
    encryptionAtHost: false
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    zone: 0
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
    vmSize: 'Standard_DS2_v2'
    adminPassword: password
  }
}

@description('The resource ID of the created Virtual Machine.')
output virtualMachineResourceId string = vm.outputs.resourceId
