@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the disk to create.')
param sharedDiskName string

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

resource sharedDataDisk 'Microsoft.Compute/disks@2024-03-02' = {
  location: location
  name: sharedDiskName
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    diskSizeGB: 1024
    creationData: {
      createOption: 'Empty'
    }
    maxShares: 2
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
  }
  zones: ['1'] // Should be set to the same zone as the VM
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created data disk.')
output sharedDataDiskResourceId string = sharedDataDisk.id

@description('The name of the created data disk.')
output sharedDataDiskName string = sharedDataDisk.name
