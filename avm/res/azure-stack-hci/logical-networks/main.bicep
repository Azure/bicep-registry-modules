metadata name = 'Azure Stack HCI Logical Networks'
metadata description = 'This module deploys an Azure Stack HCI Logical Network.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The custom location ID.')
param customLocationId string

@description('Required. The VM switch name.')
param vmSwitchName string

@description('Optional. The subnet name.')
param subnet0Name string = 'default'

@description('Optional. The IP allocation method.')
@allowed([
  'Static'
  'Dynamic'
])
param ipAllocationMethod string = 'Dynamic'

@description('Optional. The DNS servers list.')
param dnsServers array = []

@description('Optional. Tags for the logical network.')
param tags object?

@description('Optional. Address prefix for the logical network.')
param addressPrefix string?

@description('Optional. VLan Id for the logical network.')
param vlanId int?

@description('Optional. A list of IP configuration references.')
param ipConfigurationReferences array = [
  /*array of type {ID: string}*/
]

@description('Optional. The starting IP address of the IP address range.')
param startingAddress string?

@description('Optional. The ending IP address of the IP address range.')
param endingAddress string?

@description('Optional. The route name.')
param routeName string?

@description('Optional. The default gateway for the network.')
param defaultGateway string?

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.azurestackhci-logicalnetworks.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

@description('The name of the logical network.')
output name string = logicalNetwork.name

@description('The ID of the logical network.')
output resourceId string = logicalNetwork.id

@description('The resource group of the logical network.')
output resourceGroupName string = resourceGroup().name

@description('The location of the logical network.')
output location string = logicalNetwork.location

@description('The resource ID of the logical network.')
output logicalNetworkId string = logicalNetwork.id
