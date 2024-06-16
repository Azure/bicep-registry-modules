@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Maintenance Configuration to create.')
param maintenanceConfigurationName string

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

resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: maintenanceConfigurationName
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
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
    // configurationType: 'Regular'
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the maintenance configuration.')
output maintenanceConfigurationResourceId string = maintenanceConfiguration.id
