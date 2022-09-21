@description('Deployment Location')
param location string = resourceGroup().location

@description('Name of VMSS Cluster')
param vmssName string

@description('GameDev Sku')
param vmssSku string = 'Standard_D4ds_v4'

@description('Image Publisher')
param vmssImgPublisher string = ''

@description('Image Product Id')
param vmssImgProduct string = ''

@description('Image Sku')
param vmssImgSku string = ''

@description('GameDev Image Product Id')
param vmssImgVersion string = 'latest'

@description('GameDev Disk Type')
param vmssOsDiskType string = 'Premium_LRS'

@description('VMSS Instance Count')
@maxValue(100)
@minValue(1)
param vmssInstanceCount int = 1

@description('Administrator Login for access')
param administratorLogin string

@description('Administrator Password for access')
@secure()
param passwordAdministratorLogin string

@description('Virtual Network Resource Name')
param vnetName string = 'vnet-${vmssName}'

@description('Virtual Network Subnet Name')
param subnetName string = 'subnet${vmssName}'

@description('Virtual Network Security Group Name')
param networkSecurityGroupName string = 'nsg-${vmssName}'

@description('Virtual Network Address Prefix')
param vnetAddressPrefix string = '172.17.72.0/24' //Change as needed

@description('Virtual Network Subnet Address Prefix')
param subnetAddressPrefix string = '172.17.72.0/25' // 172.17.72.[0-128] is part of this subnet

@allowed([
  'gallery'
  'marketplace'
])
@description('Parameter used for debugging with trail offer')
param imageLocation string = 'marketplace'

@description('Pointer to community gallery image. Example: /CommunityGalleries/<sharedGallery>/Images/<definition>/Versions/<imageVer>')
param communityGalleryImageId string = ''

@description('Base64 Encoded string to provide to VMSS for configuration')
param customData string = ''

var locations = {
  gallery: {
    plan: null
    imageReference: { communityGalleryImageId: communityGalleryImageId }
  }
  marketplace: {
    plan: {
      name: vmssImgSku
      publisher: vmssImgPublisher
      product: vmssImgProduct
    }
    imageReference: {
      publisher: vmssImgPublisher
      offer: vmssImgProduct
      sku: vmssImgSku
      version: vmssImgVersion
    }
  }
}

module vnet 'modules/virtualNetworks.bicep' = {
  name: '${vnetName}-${uniqueString(resourceGroup().name, location)}'
  params: {
    location: location
    vnetName: vnetName
    subnetName: subnetName
    networkSecurityGroupName: networkSecurityGroupName
    vnetAddressPrefix: vnetAddressPrefix
    subnetAddressPrefix: subnetAddressPrefix
  }
}

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2022-03-01' = {
  name: '${vmssName}-${uniqueString(resourceGroup().name, location)}'
  location: location
  sku: {
    name: vmssSku
    tier: 'Standard'
    capacity: vmssInstanceCount
  }
  plan: locations[imageLocation].plan
  properties: {
    singlePlacementGroup: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: vmssOsDiskType
          }
        }
        imageReference: locations[imageLocation].imageReference
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: '${vmssName}Nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: '${vmssName}IpConfig'
                  properties: {
                    subnet: {
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
                    }
                  }
                }
              ]
              networkSecurityGroup: {
                id: vnet.outputs.nsgID
              }
            }
          }
        ]
      }
      osProfile: {
        computerNamePrefix: vmssName
        adminUsername: administratorLogin
        adminPassword: passwordAdministratorLogin
        customData: customData
      }
      priority: 'Regular'
    }
    overprovision: false
  }
}

@description('Resource Id of Virtual Machine Scale Set')
output id string = vmss.id

@description('Resource Name of Virtual Machine Scale Set')
output name string = vmss.name
