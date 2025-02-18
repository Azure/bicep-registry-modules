metadata name = 'ExpressRoute Ports'
metadata description = 'This module deploys an Express Route Port resource used by Express Route Direct.'

@description('Required. This is the name of the ExpressRoute Port Resource.')
param name string

@description('Required. This is the bandwidth in Gbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.')
param bandwidthInGbps int

@description('Optional. Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.')
@allowed([
  'MeteredData'
  'UnlimitedData'
])
param billingType string = 'MeteredData'

@description('Optional. Encapsulation method on physical ports.')
@allowed([
  'Dot1Q'
  'QinQ'
])
param encapsulation string = 'Dot1Q'

@description('Optional. Properties of the ExpressRouteLink.')
param links linkType[]?

@description('Required. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.')
param peeringLocation string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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
  name: '46d3xbcp.res.network-expressrouteport.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource expressRoutePort_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: expressRoutePort
}

resource expressRoutePort 'Microsoft.Network/ExpressRoutePorts@2024-05-01' = {
  name: name
  location: location
  properties: {
    bandwidthInGbps: bandwidthInGbps
    billingType: billingType
    encapsulation: encapsulation
    links: links ?? []
    peeringLocation: peeringLocation
  }
}

resource expressRoutePort_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(expressRoutePort.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: expressRoutePort
  }
]

@description('The resource ID of the ExpressRoute Gateway.')
output resourceId string = expressRoutePort.id

@description('The resource group of the ExpressRoute Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the ExpressRoute Gateway.')
output name string = expressRoutePort.name

@description('The location the resource was deployed into.')
output location string = expressRoutePort.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a link.')
type linkType = {
  @description('Optional. Resource Id of the existing Link.')
  id: string?

  @description('Required. The name of the link to be created.')
  name: string

  @description('Optional. Properties of the Link.')
  properties: {
    @description('''Required. Administrative state of the physical port. Must be set to 'Disabled' for initial deployment.''')
    adminState: string

    @description('Optional. MacSec Configuration of the link.')
    macSecConfig: {
      @description('Required. Keyvault Secret Identifier URL containing Mac security CAK key.')
      cakSecretIdentifier: string

      @description('Required. Mac security cipher.')
      cipher: ('GcmAes128' | 'GcmAes256' | 'GcmAesXpn128' | 'GcmAesXpn256')

      @description('Required. Keyvault Secret Identifier URL containing Mac security CKN key.')
      cknSecretIdentifier: string

      @description('Required. Sci mode.')
      sciState: ('Enabled' | 'Disabled')
    }?
  }
}
