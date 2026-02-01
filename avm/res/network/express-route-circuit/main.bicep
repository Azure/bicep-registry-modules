metadata name = 'ExpressRoute Circuits'
metadata description = 'This module deploys an Express Route Circuit.'

@description('Required. This is the name of the ExpressRoute circuit.')
param name string

@description('Conditional. Required if \'expressRoutePortResourceId\' is not set. This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call.')
param serviceProviderName string?

@description('Conditional. Required if \'expressRoutePortResourceId\' is not set. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.')
param peeringLocation string?

@description('Conditional. Required if \'expressRoutePortResourceId\' is not set. This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.')
param bandwidthInMbps int?

@description('Optional. Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers.')
@allowed([
  'Local'
  'Standard'
  'Premium'
])
param skuTier string = 'Standard'

@description('Optional. Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.')
@allowed([
  'MeteredData'
  'UnlimitedData'
])
param skuFamily string = 'MeteredData'

@description('Optional. Array of peering configurations for the ExpressRoute circuit.')
param peerings resourceInput<'Microsoft.Network/expressRouteCircuits@2024-07-01'>.properties.peerings?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true.')
param allowClassicOperations bool = false

@description('Optional. List of names for ExpressRoute circuit authorizations to create. To fetch the `authorizationKey` for the authorization, use the `existing` resource reference for `Microsoft.Network/expressRouteCircuits/authorizations`.')
param authorizationNames string[] = []

@description('Conditional. Required if \'serviceProviderName\', \'peeringLocation\', and \'bandwidthInMbps\' are not set. The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null.')
param bandwidthInGbps int = 0

@description('Optional. Array of Global Reach connection configurations for peerings.')
param connections connectionType[]?

@description('Conditional. Required if \'serviceProviderName\', \'peeringLocation\', and \'bandwidthInMbps\' are not set. The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct.')
param expressRoutePortResourceId string = ''

@description('Optional. Flag denoting rate-limiting status of the ExpressRoute direct-port circuit.')
param enableDirectPortRateLimit bool = false

@description('Optional. Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU.')
param globalReachEnabled bool = false

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/expressRouteCircuits@2024-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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
  name: '46d3xbcp.res.network-expressroutecircuit.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource expressRouteCircuit 'Microsoft.Network/expressRouteCircuits@2024-10-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: '${skuTier}_${skuFamily}'
    tier: skuTier
    family: skuTier == 'Local' ? 'UnlimitedData' : skuFamily
  }
  properties: {
    allowClassicOperations: allowClassicOperations
    authorizations: [
      for authorizationName in authorizationNames: {
        name: authorizationName
      }
    ]
    globalReachEnabled: globalReachEnabled
    bandwidthInGbps: bandwidthInGbps != 0 ? bandwidthInGbps : null
    enableDirectPortRateLimit: enableDirectPortRateLimit
    expressRoutePort: !empty(expressRoutePortResourceId)
      ? {
          id: expressRoutePortResourceId
        }
      : null
    serviceProviderProperties: empty(expressRoutePortResourceId)
      ? {
          serviceProviderName: serviceProviderName
          peeringLocation: peeringLocation
          bandwidthInMbps: bandwidthInMbps
        }
      : null
    peerings: [
      for peering in (peerings ?? []): {
        name: peering.name
        properties: {
          peeringType: peering.properties.?peeringType
          sharedKey: peering.properties.?sharedKey
          azureASN: peering.properties.?azureASN ?? 12076
          peerASN: peering.properties.?peerASN
          primaryPeerAddressPrefix: peering.properties.?primaryPeerAddressPrefix
          secondaryPeerAddressPrefix: peering.properties.?secondaryPeerAddressPrefix
          vlanId: peering.properties.?vlanId
          ipv6PeeringConfig: peering.properties.?ipv6PeeringConfig
          microsoftPeeringConfig: peering.properties.?microsoftPeeringConfig
          routeFilter: peering.properties.?routeFilter
          state: peering.properties.?state
        }
      }
    ]
  }
}

resource expressRouteCircuit_peering_connections 'Microsoft.Network/expressRouteCircuits/peerings/connections@2024-10-01' = [
  for connection in (connections ?? []): {
    name: '${name}/${connection.peeringName}/${connection.name}'
    properties: {
      peerExpressRouteCircuitPeering: {
        id: '${connection.peerExpressRouteCircuitPeeringId}/peerings/${connection.peeringName}'
      }
      expressRouteCircuitPeering: {
        id: '${expressRouteCircuit.id}/peerings/${connection.peeringName}'
      }
      addressPrefix: connection.?addressPrefix
      authorizationKey: connection.?authorizationKey
      ipv6CircuitConnectionConfig: connection.?ipv6CircuitConnectionConfig
    }
  }
]

resource expressRouteCircuit_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: expressRouteCircuit
}

resource expressRouteCircuit_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: expressRouteCircuit
  }
]

resource expressRouteCircuit_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      expressRouteCircuit.id,
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
    scope: expressRouteCircuit
  }
]

@description('The resource ID of express route circuit.')
output resourceId string = expressRouteCircuit.id

@description('The resource group the express route circuit was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of express route circuit.')
output name string = expressRouteCircuit.name

@description('The service key of the express route circuit.')
output serviceKey string = expressRouteCircuit.properties.serviceKey

@description('The service provider provisioning state of the express route circuit.')
output serviceProviderProvisioningState string = expressRouteCircuit.properties.serviceProviderProvisioningState

@description('The location the resource was deployed into.')
output location string = expressRouteCircuit.location

@description('The authorizations of the express route circuit.')
output authorizations array = expressRouteCircuit.properties.authorizations

@export()
type connectionType = {
  @description('Required. The name of the connection.')
  name: string

  @description('Required. The name of the peering this connection belongs to.')
  peeringName: string

  @description('Required. The resource ID of the peer ExpressRoute circuit peering.')
  peerExpressRouteCircuitPeeringId: string

  @description('Optional. The IPv4 address space (/29) to carve out customer addresses for tunnels.')
  addressPrefix: string?

  @description('Optional. The authorization key for the connection.')
  authorizationKey: string?

  @description('Optional. IPv6 circuit connection configuration.')
  ipv6CircuitConnectionConfig: {
    @description('Optional. The IPv6 address space (/125) to carve out customer addresses for global reach.')
    addressPrefix: string?
  }?
}
