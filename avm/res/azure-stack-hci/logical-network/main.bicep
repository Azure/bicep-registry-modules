metadata name = 'Azure Stack HCI Logical Network'
metadata description = 'This module deploys an Azure Stack HCI Logical Network.'

// ============== //
//   Parameters   //
// ============== //

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

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ============= //
//   Resources   //
// ============= //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.azurestackhci-logicalnetwork.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

resource logicalNetwork 'Microsoft.AzureStackHCI/logicalNetworks@2025-02-01-preview' = {
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

resource logicalNetwork_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(logicalNetwork.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: logicalNetwork
  }
]

@description('The name of the logical network.')
output name string = logicalNetwork.name

@description('The resource ID of the logical network.')
output resourceId string = logicalNetwork.id

@description('The resource group of the logical network.')
output resourceGroupName string = resourceGroup().name

@description('The location of the logical network.')
output location string = logicalNetwork.location
