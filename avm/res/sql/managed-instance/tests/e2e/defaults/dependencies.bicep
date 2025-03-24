@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Route Table to create.')
param routeTableName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'
var addressPrefixString = replace(replace(addressPrefix, '.', '-'), '/', '-')

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
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

resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
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
