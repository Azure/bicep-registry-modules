@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Route Table to create.')
param routeTableName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create to get the paired region name.')
param pairedRegionScriptName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

var addressPrefix = '10.0.0.0/16'
var addressPrefixString = replace(replace(addressPrefix, '.', '-'), '/', '-')

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${location}-${managedIdentity.id}-Reader-RoleAssignment')
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    ) // Reader
    principalType: 'ServicePrincipal'
  }
}

resource getPairedRegionScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: pairedRegionScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    retentionInterval: 'P1D'
    arguments: '-Location \\"${location}\\"'
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Get-PairedRegion.ps1')
  }
  dependsOn: [
    roleAssignment
  ]
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-sqlmgmt-in-${addressPrefixString}-v10'
        properties: {
          description: 'Allow MI provisioning Control Plane Deployment and Authentication Service'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'SqlManagement'
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          destinationPortRanges: [
            '9000'
            '9003'
            '1438'
            '1440'
            '1452'
          ]
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-corpsaw-in-${addressPrefixString}-v10'
        properties: {
          description: 'Allow MI Supportability'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
          destinationPortRanges: [
            '9000'
            '9003'
            '1440'
          ]
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-corppublic-in-${addressPrefixString}-v10'
        properties: {
          description: 'Allow MI Supportability through Corpnet ranges'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          destinationAddressPrefix: addressPrefix
          access: 'Allow'
          priority: 102
          direction: 'Inbound'
          destinationPortRanges: [
            '9000'
            '9003'
          ]
        }
      }
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
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-aad-out-${addressPrefixString}-v11'
        properties: {
          description: 'Allow communication with Azure Active Directory over https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'AzureActiveDirectory'
          access: 'Allow'
          priority: 100
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
          priority: 101
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-services-out-${addressPrefixString}-v10'
        properties: {
          description: 'Allow MI services outbound traffic over https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: addressPrefix
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 102
          direction: 'Outbound'
          destinationPortRanges: [
            '443'
            '12000'
          ]
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
          priority: 103
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
          priority: 104
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
          destinationAddressPrefix: 'Storage.${getPairedRegionScript.properties.outputs.pairedRegionName}'
          access: 'Allow'
          priority: 105
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
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-Storage'
        properties: {
          addressPrefix: 'Storage'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-SqlManagement'
        properties: {
          addressPrefix: 'SqlManagement'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-AzureMonitor'
        properties: {
          addressPrefix: 'AzureMonitor'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-CorpNetSaw'
        properties: {
          addressPrefix: 'CorpNetSaw'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-CorpNetPublic'
        properties: {
          addressPrefix: 'CorpNetPublic'
          nextHopType: 'Internet'
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
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-AzureCloud.${location}'
        properties: {
          addressPrefix: 'AzureCloud.${location}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-AzureCloud.${getPairedRegionScript.properties.outputs.pairedRegionName}'
        properties: {
          addressPrefix: 'AzureCloud.${getPairedRegionScript.properties.outputs.pairedRegionName}'
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
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-Storage.${getPairedRegionScript.properties.outputs.pairedRegionName}'
        properties: {
          addressPrefix: 'Storage.${getPairedRegionScript.properties.outputs.pairedRegionName}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-EventHub.${location}'
        properties: {
          addressPrefix: 'EventHub.${location}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'Microsoft.Sql-managedInstances_UseOnly_mi-EventHub.${getPairedRegionScript.properties.outputs.pairedRegionName}'
        properties: {
          addressPrefix: 'EventHub.${getPairedRegionScript.properties.outputs.pairedRegionName}'
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
  }
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id
