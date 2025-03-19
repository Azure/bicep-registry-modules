@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Route Table to create.')
param routeTableName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The secondary location, the Azure region paired with the primary location.')
param secondaryLocation string

var addressPrefix = '10.0.0.0/16'
var addressPrefixString = replace(replace(addressPrefix, '.', '-'), '/', '-')

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      // {
      //   name: 'Microsoft.Sql-managedInstances_UseOnly_mi-sqlmgmt-in-${addressPrefixString}-v10'
      //   properties: {
      //     description: 'Allow MI provisioning Control Plane Deployment and Authentication Service'
      //     protocol: 'Tcp'
      //     sourcePortRange: '*'
      //     sourceAddressPrefix: 'SqlManagement'
      //     destinationAddressPrefix: addressPrefix
      //     access: 'Allow'
      //     priority: 100
      //     direction: 'Inbound'
      //     destinationPortRanges: [
      //       '9000'
      //       '9003'
      //       '1438'
      //       '1440'
      //       '1452'
      //     ]
      //   }
      // }
      // {
      //   name: 'Microsoft.Sql-managedInstances_UseOnly_mi-corpsaw-in-${addressPrefixString}-v10'
      //   properties: {
      //     description: 'Allow MI Supportability'
      //     protocol: 'Tcp'
      //     sourcePortRange: '*'
      //     sourceAddressPrefix: 'CorpNetSaw'
      //     destinationAddressPrefix: addressPrefix
      //     access: 'Allow'
      //     priority: 101
      //     direction: 'Inbound'
      //     destinationPortRanges: [
      //       '9000'
      //       '9003'
      //       '1440'
      //     ]
      //   }
      // }
      // {
      //   name: 'Microsoft.Sql-managedInstances_UseOnly_mi-corppublic-in-${addressPrefixString}-v10'
      //   properties: {
      //     description: 'Allow MI Supportability through Corpnet ranges'
      //     protocol: 'Tcp'
      //     sourcePortRange: '*'
      //     sourceAddressPrefix: 'CorpNetPublic'
      //     destinationAddressPrefix: addressPrefix
      //     access: 'Allow'
      //     priority: 102
      //     direction: 'Inbound'
      //     destinationPortRanges: [
      //       '9000'
      //       '9003'
      //     ]
      //   }
      // }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-healthprobe-in-${addressPrefixString}-v11'
        properties: {
          description: 'Allow Azure Load Balancer inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-internal-in-${addressPrefixString}-v11'
        properties: {
          description: 'Allow MI internal inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-aad-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow communication with Azure Active Directory over https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'AzureActiveDirectory'
          access: 'Allow'
          priority: 102
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-onedsc-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow communication with the One DS Collector over https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'OneDsCollector'
          access: 'Allow'
          priority: 103
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-internal-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow MI internal outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 104
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-strg-p-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow outbound communication with storage over HTTPS'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'Storage.${location}'
          access: 'Allow'
          priority: 105
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-strg-s-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow outbound communication with storage over HTTPS'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'Storage.${secondaryLocation}'
          access: 'Allow'
          priority: 106
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-optional-azure-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow AzureCloud outbound https traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 107
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
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-AzureActiveDirectory'
        properties: {
          addressPrefix: 'AzureActiveDirectory'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-OneDsCollector'
        properties: {
          addressPrefix: 'OneDsCollector'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-Storage.${location}'
        properties: {
          addressPrefix: 'Storage.${location}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-Storage.${secondaryLocation}'
        properties: {
          addressPrefix: 'Storage.${secondaryLocation}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_optional-AzureCloud.${location}'
        properties: {
          addressPrefix: 'AzureCloud.${location}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_optional-AzureCloud.${secondaryLocation}'
        properties: {
          addressPrefix: 'AzureCloud.${secondaryLocation}'
          nextHopType: 'Internet'
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
