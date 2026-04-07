@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Route Table to create.')
param routeTableName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'
var addressPrefixString = replace(replace(addressPrefix, '.', '-'), '/', '-')

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-healthprobe-in-${addressPrefixString}-v10'
        properties: {
          description: 'Allow Azure Load Balancer inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 103
          direction: 'Inbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-internal-in-${addressPrefixString}-v10'
        properties: {
          description: 'Allow MI internal inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 104
          direction: 'Inbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-internal-out-${addressPrefixString}-v10'
        properties: {
          description: 'Allow MI internal outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 101
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource routeTable 'Microsoft.Network/routeTables@2024-05-01' = {
  name: routeTableName
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_subnet-${addressPrefixString}-to-vnetlocal'
        properties: {
          addressPrefix: addressPrefix
          nextHopType: 'VnetLocal'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
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
        name: 'ManagedInstance'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
          routeTable: {
            id: routeTable.id
          }
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
          delegations: [
            {
              name: 'managedInstanceDelegation'
              properties: {
                serviceName: 'Microsoft.Sql/managedInstances'
              }
            }
          ]
        }
      }
    ]
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name
