@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Virtual Machine Scale Set to create.')
param vmssName string

@description('Required. The name of the public IP address for the Virtual Machine Scale Set to create.')
param pipName string

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: vmssName
  location: location
  sku: {
    name: 'Standard_B12ms'
  }
  properties: {
    orchestrationMode: 'Flexible'
    platformFaultDomainCount: 1
    virtualMachineProfile: {
      osProfile: {
        adminUsername: 'localAdminUser'
        adminPassword: password
        computerNamePrefix: 'vmssvm'
      }
      storageProfile: {
        osDisk: {
          createOption: 'fromImage'
          diskSizeGB: 128
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
          osType: 'Windows'
        }
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2022-datacenter-azure-edition'
          version: 'latest'
        }
      }
      networkProfile: {
        networkApiVersion: '2020-11-01'
        networkInterfaceConfigurations: [
          {
            name: 'nicconfig1'
            properties: {
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: virtualNetwork.properties.subnets[0].id
                    }
                    publicIPAddressConfiguration: {
                      name: pipName
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Virtual Machine Scale Set.')
output vmssResourceId string = vmss.id
