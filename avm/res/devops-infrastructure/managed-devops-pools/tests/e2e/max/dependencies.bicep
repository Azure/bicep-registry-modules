@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Required. The name of the Dev Center Project.')
param devCenterProjectName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource devCenter 'Microsoft.DevCenter/devcenters@2024-02-01' = {
  name: devCenterName
  location: location
}

resource devCenterProject 'Microsoft.DevCenter/projects@2024-02-01' = {
  name: devCenterProjectName
  location: location
  properties: {
    devCenterId: devCenter.id
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.1.0/24'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '192.168.1.0/24'
        }
      }
    ]
  }
}

@description('The resource ID of the created DevCenter.')
output devCenterId string = devCenter.id

@description('The resource ID of the created DevCenter Project.')
output devCenterProjectId string = devCenterProject.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created subnet.')
output subnetId string = first(virtualNetwork.properties.subnets)!.id
