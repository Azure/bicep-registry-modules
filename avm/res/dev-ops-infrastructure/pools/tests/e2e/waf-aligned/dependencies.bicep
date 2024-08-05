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

var addressPrefix = '192.168.1.0'

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
        cidrSubnet(addressPrefix, 24, 0)
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          delegations: [
            {
              name: 'Microsoft.DevOpsInfrastructure/pools'
              properties: {
                serviceName: 'Microsoft.DevOpsInfrastructure/pools'
              }
            }
          ]
        }
      }
    ]
  }
}

// Reader and Network Contributor role assignment
resource roleAssignments 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [
  for role in ['acdd72a7-3385-48ef-bd42-f606fba81ae7', '4d97b98b-1d4f-4787-a291-c67834d212e7']: {
    name: guid(subscription().subscriptionId, 'DevOpsInfrastructure', role)
    properties: {
      principalId: 'b12c02d0-bcd5-449f-80ae-31af16139058' // DevOpsInfrastructure service principal
      #disable-next-line use-resource-id-functions
      roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
      principalType: 'ServicePrincipal'
    }
    scope: virtualNetwork
  }
]

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

@description('The resource ID of the created DevCenter Project.')
output devCenterProjectResourceId string = devCenterProject.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created subnet.')
output subnetResourceId string = first(virtualNetwork.properties.subnets)!.id
