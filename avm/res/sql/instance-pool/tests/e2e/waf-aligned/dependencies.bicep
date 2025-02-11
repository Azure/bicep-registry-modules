@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create to get the paired region name.')
param pairedRegionScriptName string

@description('Required. The name of the SQL Instance Pool.')
param sqlInstancePoolName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The name of the Subnet to create.')
param subnetName string = 'sql-instancepool-subnet'

@description('Required. The name of the NSG to create.')
param nsgName string

@description('Required. The name of the route table to create.')
param routeTableName string

var addressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = cidrSubnet(addressPrefix, 24, 0)

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
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

resource getPairedRegionScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
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
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    arguments: '-Location \\"${location}\\"'
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Get-PairedRegion.ps1')
  }
  dependsOn: [
    roleAssignment
  ]
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'sqlmi-healthprobe-in'
        properties: {
          description: 'Allow Azure Load Balancer inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: subnetAddressPrefix
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'sqlmi-internal-in'
        properties: {
          description: 'Allow MI internal inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: subnetAddressPrefix
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
        }
      }
      {
        name: 'sqlmi-aad-out'
        properties: {
          description: 'Allow communication with Azure Active Directory over https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: 'AzureActiveDirectory'
          access: 'Allow'
          priority: 101
          direction: 'Outbound'
        }
      }
      {
        name: 'sqlmi-onedsc-out'
        properties: {
          description: 'Allow communication with the One DS Collector over https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: 'OneDsCollector'
          access: 'Allow'
          priority: 102
          direction: 'Outbound'
        }
      }
      {
        name: 'sqlmi-internal-out'
        properties: {
          description: 'Allow MI internal outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: subnetAddressPrefix
          access: 'Allow'
          priority: 103
          direction: 'Outbound'
        }
      }
      {
        name: 'sqlmi-strg-p-out'
        properties: {
          description: 'Allow outbound communication with storage over HTTPS'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: 'Storage.${location}'
          access: 'Allow'
          priority: 104
          direction: 'Outbound'
        }
      }
      {
        name: 'sqlmi-strg-s-out'
        properties: {
          description: 'Allow outbound communication with storage over HTTPS'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: 'Storage.${getPairedRegionScript.properties.outputs.pairedRegionName}'
          access: 'Allow'
          priority: 105
          direction: 'Outbound'
        }
      }
      {
        name: 'sqlmi-optional-azure-out'
        properties: {
          description: 'Allow AzureCloud outbound https traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: subnetAddressPrefix
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource routeTable 'Microsoft.Network/routeTables@2020-06-01' = {
  name: routeTableName
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'sqlmi_subnet-to-vnetlocal'
        properties: {
          addressPrefix: subnetAddressPrefix
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'sqlmi-aad'
        properties: {
          addressPrefix: 'AzureActiveDirectory'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'sqlmi-odscollector'
        properties: {
          addressPrefix: 'OneDsCollector'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'sqlmi-stg-p'
        properties: {
          addressPrefix: 'Storage.${location}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'sqlmi-stg-s'
        properties: {
          addressPrefix: 'Storage.${getPairedRegionScript.properties.outputs.pairedRegionName}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'sqlmi-optional-azure-p'
        properties: {
          addressPrefix: 'AzureCloud.${location}'
          nextHopType: 'Internet'
        }
      }
      {
        name: 'sqlmi-optional-azurecloud-s'
        properties: {
          addressPrefix: 'AzureCloud.${getPairedRegionScript.properties.outputs.pairedRegionName}'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
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
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: nsg.id
          }
          routeTable: {
            id: routeTable.id
          }
          delegations: [
            {
              name: 'ip-delegations-${sqlInstancePoolName}'
              properties: {
                serviceName: 'Microsoft.Sql/managedInstances'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

@description('The subnetId required for the instance pool creation.')
output subnetId string = virtualNetwork.properties.subnets[0].id

@description('The name of the sql instnce pool to be created.')
output sqlInstancePoolName string = sqlInstancePoolName
