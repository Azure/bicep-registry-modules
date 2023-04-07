param location string
param serviceShort string = 'vnet'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'dep-${serviceShort}-az-msi-x-01'
  location: location
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'dep-${serviceShort}-az-nsg-x-01'
  location: location
}

resource routeTable 'Microsoft.Network/routeTables@2021-05-01' = {
  name: 'dep-${serviceShort}-az-rt-x-01'
  location: location
}

module genvnet 'br/public:network/virtual-network:1.0.1' = {
  name: '${uniqueString(deployment().name, location)}-genvnet'
  params: {
    name: '${serviceShort}-az-vnet-gen-01'
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.255.0/24'
      }
      {
        name: '${serviceShort}-az-subnet-x-001'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupId: networkSecurityGroup.id
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
        ]
        routeTableId: routeTable.id
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          managedIdentity.properties.principalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

output subnetID string = genvnet.outputs.subnetResourceIds[0]
