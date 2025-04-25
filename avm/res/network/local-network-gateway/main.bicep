metadata name = 'Local Network Gateways'
metadata description = 'This module deploys a Local Network Gateway.'

@description('Required. Name of the Local Network Gateway.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. List of the local (on-premises) IP address ranges.')
param localAddressPrefixes array

@description('Required. Public IP of the local gateway.')
param localGatewayPublicIpAddress string

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. FQDN of local network gateway.')
param fqdn string = ''

@description('Optional. Local network gateway\'s BGP speaker settings.')
param bgpSettings bgpSettingsType?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-localnetworkgateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localAddressPrefixes
    }
    fqdn: !empty(fqdn) ? fqdn : null
    gatewayIpAddress: localGatewayPublicIpAddress
    bgpSettings: !empty(bgpSettings)
      ? {
          asn: bgpSettings!.localAsn
          bgpPeeringAddress: bgpSettings!.localBgpPeeringAddress
          peerWeight: bgpSettings.?peerWeight ?? 0
        }
      : null
  }
}

resource localNetworkGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: localNetworkGateway
}

resource localNetworkGateway_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      localNetworkGateway.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: localNetworkGateway
  }
]

@description('The resource ID of the local network gateway.')
output resourceId string = localNetworkGateway.id

@description('The resource group the local network gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the local network gateway.')
output name string = localNetworkGateway.name

@description('The location the resource was deployed into.')
output location string = localNetworkGateway.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of BGP settings.')
type bgpSettingsType = {
  @description('Required. The BGP speaker\'s ASN.')
  @minValue(0)
  @maxValue(4294967295)
  localAsn: int

  @description('Required. The BGP peering address and BGP identifier of this BGP speaker.')
  localBgpPeeringAddress: string

  @description('Optional. The weight added to routes learned from this BGP speaker.')
  peerWeight: int?
}
