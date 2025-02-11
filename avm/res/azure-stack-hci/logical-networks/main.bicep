metadata name = 'Azure Stack HCI Logical Networks'
metadata description = 'This module deploys an Azure Stack HCI Logical Network.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('The custom location ID.')
param customLocationId string

@description('The VM switch name.')
param vmSwitchName string

@description('The subnet name.')
param subnet0Name string = 'default'

@description('The IP allocation method.')
@allowed([
  'Static'
  'Dynamic'
])
param ipAllocationMethod string = 'Dynamic'

@description('The DNS servers list.')
param dnsServers array = []

@description('Tags for the logical network.')
param tags object = {}

param addressPrefix string?

param vlanId int?

@description('A list of IP configuration references.')
param ipConfigurationReferences array = [
  /*array of type {ID: string}*/
]

@description('The starting IP address of the IP address range.')
param startingAddress string?

@description('The ending IP address of the IP address range.')
param endingAddress string?

@description('The route name.')
param routeName string?

@description('The default gateway for the network.')
param defaultGateway string?

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.azurestackhci-logicalnetworks.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

var subnet1Pools = [
  {
    start: startingAddress
    end: endingAddress
    info: {}
  }
]

var routeTable = {
  properties: {
    routes: [
      {
        name: routeName
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: defaultGateway
        }
      }
    ]
  }
}

resource logicalNetwork 'Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview' = {
  name: name
  location: location
  tags: tags
  extendedLocation: {
    name: customLocationId
    type: 'CustomLocation'
  }
  properties: {
    dhcpOptions: {
      dnsServers: ipAllocationMethod == 'Dynamic' ? null : dnsServers
    }
    subnets: [
      {
        name: subnet0Name
        properties: {
          addressPrefix: addressPrefix
          ipAllocationMethod: ipAllocationMethod
          ipConfigurationReferences: ipConfigurationReferences
          vlan: vlanId
          ipPools: ipAllocationMethod == 'Dynamic' ? null : subnet1Pools
          routeTable: ipAllocationMethod == 'Dynamic' ? null : routeTable
        }
      }
    ]
    vmSwitchName: vmSwitchName
  }
}

@description('The resource ID of the logical network.')
output logicalNetworkId string = logicalNetwork.id
