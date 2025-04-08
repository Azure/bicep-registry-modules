metadata name = 'Load Balancers'
metadata description = 'This module deploys a Load Balancer.'

// ================ //
// Parameters       //
// ================ //

@description('Required. The Proximity Placement Groups Name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of a load balancer SKU.')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Required. Array of objects containing all frontend IP configurations.')
@minLength(1)
param frontendIPConfigurations array

@description('Optional. Collection of backend address pools used by a load balancer.')
param backendAddressPools array?

@description('Optional. Array of objects containing all load balancing rules.')
param loadBalancingRules array?

@description('Optional. Array of objects containing all probes, these are references in the load balancing rules.')
param probes array?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

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

@description('Optional. Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules.')
param inboundNatRules array = []

@description('Optional. The outbound rules.')
param outboundRules array = []

// =========== //
// Variables   //
// =========== //

var frontendIPConfigurationsVar = [
  for (frontendIPConfiguration, index) in frontendIPConfigurations: {
    name: frontendIPConfiguration.name
    properties: {
      subnet: contains(frontendIPConfiguration, 'subnetId') && !empty(frontendIPConfiguration.subnetId)
        ? {
            id: frontendIPConfiguration.subnetId
          }
        : null
      publicIPAddress: contains(frontendIPConfiguration, 'publicIPAddressId') && !empty(frontendIPConfiguration.publicIPAddressId)
        ? {
            id: frontendIPConfiguration.publicIPAddressId
          }
        : null
      privateIPAddress: contains(frontendIPConfiguration, 'privateIPAddress') && !empty(frontendIPConfiguration.privateIPAddress)
        ? frontendIPConfiguration.privateIPAddress
        : null
      privateIPAddressVersion: contains(frontendIPConfiguration, 'privateIPAddressVersion')
        ? frontendIPConfiguration.privateIPAddressVersion
        : 'IPv4'
      privateIPAllocationMethod: contains(frontendIPConfiguration, 'subnetId') && !empty(frontendIPConfiguration.subnetId)
        ? (contains(frontendIPConfiguration, 'privateIPAddress') ? 'Static' : 'Dynamic')
        : null
      gatewayLoadBalancer: contains(frontendIPConfiguration, 'gatewayLoadBalancer') && !empty(frontendIPConfiguration.gatewayLoadBalancer)
        ? {
            id: frontendIPConfiguration.gatewayLoadBalancer
          }
        : null
      publicIPPrefix: contains(frontendIPConfiguration, 'publicIPPrefix') && !empty(frontendIPConfiguration.publicIPPrefix)
        ? {
            id: frontendIPConfiguration.publicIPPrefix
          }
        : null
    }
    zones: contains(frontendIPConfiguration, 'zones')
      ? map(frontendIPConfiguration.zones, zone => string(zone))
      : !empty(frontendIPConfiguration.?subnetResourceId)
          ? [
              '1'
              '2'
              '3'
            ]
          : null
  }
]

var loadBalancingRulesVar = [
  for loadBalancingRule in (loadBalancingRules ?? []): {
    name: loadBalancingRule.name
    properties: {
      backendAddressPool: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/backendAddressPools',
          name,
          loadBalancingRule.backendAddressPoolName
        )
      }
      backendPort: loadBalancingRule.backendPort
      disableOutboundSnat: contains(loadBalancingRule, 'disableOutboundSnat')
        ? loadBalancingRule.disableOutboundSnat
        : true
      enableFloatingIP: contains(loadBalancingRule, 'enableFloatingIP') ? loadBalancingRule.enableFloatingIP : false
      enableTcpReset: contains(loadBalancingRule, 'enableTcpReset') ? loadBalancingRule.enableTcpReset : false
      frontendIPConfiguration: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/frontendIPConfigurations',
          name,
          loadBalancingRule.frontendIPConfigurationName
        )
      }
      frontendPort: loadBalancingRule.frontendPort
      idleTimeoutInMinutes: contains(loadBalancingRule, 'idleTimeoutInMinutes')
        ? loadBalancingRule.idleTimeoutInMinutes
        : 4
      loadDistribution: contains(loadBalancingRule, 'loadDistribution') ? loadBalancingRule.loadDistribution : 'Default'
      probe: {
        id: '${az.resourceId('Microsoft.Network/loadBalancers', name)}/probes/${loadBalancingRule.probeName}'
      }
      protocol: contains(loadBalancingRule, 'protocol') ? loadBalancingRule.protocol : 'Tcp'
    }
  }
]

var outboundRulesVar = [
  for outboundRule in outboundRules: {
    name: outboundRule.name
    properties: {
      frontendIPConfigurations: [
        {
          id: az.resourceId(
            'Microsoft.Network/loadBalancers/frontendIPConfigurations',
            name,
            outboundRule.frontendIPConfigurationName
          )
        }
      ]
      backendAddressPool: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/backendAddressPools',
          name,
          outboundRule.backendAddressPoolName
        )
      }
      protocol: contains(outboundRule, 'protocol') ? outboundRule.protocol : 'All'
      allocatedOutboundPorts: contains(outboundRule, 'allocatedOutboundPorts')
        ? outboundRule.allocatedOutboundPorts
        : 63984
      enableTcpReset: contains(outboundRule, 'enableTcpReset') ? outboundRule.enableTcpReset : true
      idleTimeoutInMinutes: contains(outboundRule, 'idleTimeoutInMinutes') ? outboundRule.idleTimeoutInMinutes : 4
    }
  }
]

var probesVar = [
  for probe in (probes ?? []): {
    name: probe.name
    properties: {
      protocol: contains(probe, 'protocol') ? probe.protocol : 'Tcp'
      requestPath: toLower(probe.protocol) != 'tcp' ? probe.requestPath : null
      port: contains(probe, 'port') ? probe.port : 80
      intervalInSeconds: contains(probe, 'intervalInSeconds') ? probe.intervalInSeconds : 5
      numberOfProbes: contains(probe, 'numberOfProbes') ? probe.numberOfProbes : 2
    }
  }
]

var backendAddressPoolNames = [
  for backendAddressPool in (backendAddressPools ?? []): {
    name: backendAddressPool.name
  }
]

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

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-loadbalancer.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-11-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    frontendIPConfigurations: frontendIPConfigurationsVar
    loadBalancingRules: loadBalancingRulesVar
    backendAddressPools: backendAddressPoolNames
    outboundRules: outboundRulesVar
    probes: probesVar
  }
}

module loadBalancer_backendAddressPools 'backend-address-pool/main.bicep' = [
  for (backendAddressPool, index) in backendAddressPools ?? []: {
    name: '${uniqueString(deployment().name, location)}-loadBalancer-backendAddressPools-${index}'
    params: {
      loadBalancerName: loadBalancer.name
      name: backendAddressPool.name
      tunnelInterfaces: contains(backendAddressPool, 'tunnelInterfaces') && !empty(backendAddressPool.tunnelInterfaces)
        ? backendAddressPool.tunnelInterfaces
        : []
      loadBalancerBackendAddresses: contains(backendAddressPool, 'loadBalancerBackendAddresses') && !empty(backendAddressPool.loadBalancerBackendAddresses)
        ? backendAddressPool.loadBalancerBackendAddresses
        : []
      drainPeriodInSeconds: contains(backendAddressPool, 'drainPeriodInSeconds')
        ? backendAddressPool.drainPeriodInSeconds
        : 0
    }
  }
]

module loadBalancer_inboundNATRules 'inbound-nat-rule/main.bicep' = [
  for (inboundNATRule, index) in inboundNatRules: {
    name: '${uniqueString(deployment().name, location)}-LoadBalancer-inboundNatRules-${index}'
    params: {
      loadBalancerName: loadBalancer.name
      name: inboundNATRule.name
      frontendIPConfigurationName: inboundNATRule.frontendIPConfigurationName
      frontendPort: inboundNATRule.?frontendPort
      backendPort: inboundNATRule.backendPort
      backendAddressPoolName: inboundNATRule.?backendAddressPoolName
      enableFloatingIP: inboundNATRule.?enableFloatingIP
      enableTcpReset: inboundNATRule.?enableTcpReset
      frontendPortRangeEnd: inboundNATRule.?frontendPortRangeEnd
      frontendPortRangeStart: inboundNATRule.?frontendPortRangeStart
      idleTimeoutInMinutes: inboundNATRule.?idleTimeoutInMinutes
      protocol: inboundNATRule.?protocol
    }
    dependsOn: [
      loadBalancer_backendAddressPools
    ]
  }
]

resource loadBalancer_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: loadBalancer
}

resource loadBalancer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: loadBalancer
  }
]

resource loadBalancer_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(loadBalancer.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: loadBalancer
  }
]

// =========== //
// Outputs     //
// =========== //

@description('The name of the load balancer.')
output name string = loadBalancer.name

@description('The resource ID of the load balancer.')
output resourceId string = loadBalancer.id

@description('The resource group the load balancer was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The backend address pools available in the load balancer.')
output backendpools array = loadBalancer.properties.backendAddressPools

@description('The location the resource was deployed into.')
output location string = loadBalancer.location
