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

@description('Optional. Tier of a load balancer SKU.')
@allowed([
  'Regional'
  'Global'
])
param skuTier string = 'Regional'

@description('Required. Array of objects containing all frontend IP configurations.')
@minLength(1)
param frontendIPConfigurations frontendIPConfigurationType[]

@description('Optional. Collection of backend address pools used by a load balancer.')
param backendAddressPools array?

@description('Optional. Array of objects containing all load balancing rules.')
param loadBalancingRules array?

@description('Optional. Array of objects containing all probes, these are references in the load balancing rules.')
param probes array?

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
param tags resourceInput<'Microsoft.Network/loadBalancers@2024-10-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules.')
param inboundNatRules array = []

@description('Optional. The outbound rules.')
param outboundRules array = []

// =========== //
// Variables   //
// =========== //

var enableReferencedModulesTelemetry = false

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
      disableOutboundSnat: loadBalancingRule.?disableOutboundSnat ?? true
      enableFloatingIP: loadBalancingRule.?enableFloatingIP ?? false
      enableTcpReset: loadBalancingRule.?enableTcpReset ?? false
      frontendIPConfiguration: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/frontendIPConfigurations',
          name,
          loadBalancingRule.frontendIPConfigurationName
        )
      }
      frontendPort: loadBalancingRule.frontendPort
      idleTimeoutInMinutes: loadBalancingRule.?idleTimeoutInMinutes ?? 4
      loadDistribution: loadBalancingRule.?loadDistribution ?? 'Default'
      probe: {
        id: '${az.resourceId('Microsoft.Network/loadBalancers', name)}/probes/${loadBalancingRule.probeName}'
      }
      protocol: loadBalancingRule.?protocol ?? 'Tcp'
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
      protocol: outboundRule.?protocol ?? 'All'
      allocatedOutboundPorts: outboundRule.?allocatedOutboundPorts ?? 63984
      enableTcpReset: outboundRule.?enableTcpReset ?? true
      idleTimeoutInMinutes: outboundRule.?idleTimeoutInMinutes ?? 4
    }
  }
]

var probesVar = [
  for probe in (probes ?? []): {
    name: probe.name
    properties: {
      intervalInSeconds: probe.?intervalInSeconds ?? 5
      noHealthyBackendsBehavior: probe.?noHealthyBackendsBehavior ?? 'AllProbedDown'
      numberOfProbes: probe.?numberOfProbes ?? 2
      port: probe.?port ?? 80
      probeThreshold: probe.?probeThreshold ?? 1
      protocol: probe.?protocol ?? 'Tcp'
      requestPath: toLower(probe.protocol) != 'tcp' ? probe.requestPath : null
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

module loadBalancer_publicIPAddresses 'br/public:avm/res/network/public-ip-address:0.10.0' = [
  for (frontendIPConfiguration, index) in frontendIPConfigurations: if (!empty(frontendIPConfiguration.?publicIPAddressConfiguration) && empty(frontendIPConfiguration.?publicIPAddressResourceId)) {
    name: '${deployment().name}-publicIP-${index}'
    params: {
      name: frontendIPConfiguration.?publicIPAddressConfiguration.?name ?? '${name}-pip-${index}'
      location: location
      lock: lock
      diagnosticSettings: frontendIPConfiguration.?publicIPAddressConfiguration.?diagnosticSettings
      idleTimeoutInMinutes: frontendIPConfiguration.?publicIPAddressConfiguration.?idleTimeoutInMinutes
      ddosSettings: frontendIPConfiguration.?publicIPAddressConfiguration.?ddosSettings
      dnsSettings: frontendIPConfiguration.?publicIPAddressConfiguration.?dnsSettings
      publicIPAddressVersion: frontendIPConfiguration.?publicIPAddressConfiguration.?publicIPAddressVersion
      publicIPAllocationMethod: frontendIPConfiguration.?publicIPAddressConfiguration.?publicIPAllocationMethod
      publicIpPrefixResourceId: frontendIPConfiguration.?publicIPAddressConfiguration.?publicIpPrefixResourceId
      roleAssignments: frontendIPConfiguration.?publicIPAddressConfiguration.?roleAssignments
      skuName: frontendIPConfiguration.?publicIPAddressConfiguration.?skuName ?? skuName
      skuTier: frontendIPConfiguration.?publicIPAddressConfiguration.?skuTier
      tags: frontendIPConfiguration.?tags ?? tags
      availabilityZones: frontendIPConfiguration.?publicIPAddressConfiguration.?availabilityZones
      enableTelemetry: enableReferencedModulesTelemetry
      ipTags: frontendIPConfiguration.?publicIPAddressConfiguration.?ipTags
    }
  }
]

module loadBalancer_publicIPPrefixes 'br/public:avm/res/network/public-ip-prefix:0.7.2' = [
  for (frontendIPConfiguration, index) in frontendIPConfigurations: if (!empty(frontendIPConfiguration.?publicIPPrefixConfiguration) && empty(frontendIPConfiguration.?publicIPPrefixResourceId)) {
    name: '${uniqueString(deployment().name, location)}-LoadBalancer-PIPPrefix-${index}'
    params: {
      name: frontendIPConfiguration.?publicIPPrefixConfiguration.?name ?? '${name}-pip-prefix-${index}'
      location: location
      lock: frontendIPConfiguration.?publicIPPrefixConfiguration.?lock ?? lock
      prefixLength: frontendIPConfiguration.?publicIPPrefixConfiguration.?prefixLength ?? 28
      customIPPrefix: frontendIPConfiguration.?publicIPPrefixConfiguration.?customIPPrefix
      roleAssignments: frontendIPConfiguration.?publicIPPrefixConfiguration.?roleAssignments
      tags: frontendIPConfiguration.?publicIPPrefixConfiguration.?tags ?? tags
      enableTelemetry: enableReferencedModulesTelemetry
      availabilityZones: frontendIPConfiguration.?publicIPPrefixConfiguration.?availabilityZones
      ipTags: frontendIPConfiguration.?publicIPPrefixConfiguration.?ipTags
      publicIPAddressVersion: frontendIPConfiguration.?publicIPPrefixConfiguration.?publicIPAddressVersion
      tier: frontendIPConfiguration.?publicIPPrefixConfiguration.?tier
    }
  }
]

resource loadBalancer 'Microsoft.Network/loadBalancers@2024-07-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    frontendIPConfigurations: [
      for (frontendIPConfiguration, index) in frontendIPConfigurations: {
        name: frontendIPConfiguration.name
        properties: {
          privateIPAddress: frontendIPConfiguration.?privateIPAddress
          privateIPAddressVersion: frontendIPConfiguration.?privateIPAddressVersion ?? 'IPv4'
          privateIPAllocationMethod: !empty(frontendIPConfiguration.?subnetResourceId)
            ? (contains(frontendIPConfiguration, 'privateIPAddress') ? 'Static' : 'Dynamic')
            : null
          publicIPAddress: !empty(frontendIPConfiguration.?publicIPAddressResourceId)
            ? { id: frontendIPConfiguration.?publicIPAddressResourceId }
            : (!empty(frontendIPConfiguration.?publicIPAddressConfiguration)
                ? { id: loadBalancer_publicIPAddresses[index]!.outputs.resourceId }
                : null)
          publicIPPrefix: !empty(frontendIPConfiguration.?publicIPPrefixResourceId)
            ? { id: frontendIPConfiguration.?publicIPPrefixResourceId }
            : (!empty(frontendIPConfiguration.?publicIPPrefixConfiguration)
                ? { id: loadBalancer_publicIPPrefixes[index]!.outputs.resourceId }
                : null)
          gatewayLoadBalancer: !empty(frontendIPConfiguration.?gatewayLoadBalancerResourceId)
            ? {
                id: frontendIPConfiguration.?gatewayLoadBalancerResourceId
              }
            : null
          subnet: !empty(frontendIPConfiguration.?subnetResourceId)
            ? {
                id: frontendIPConfiguration.?subnetResourceId
              }
            : null
        }
        zones: contains(frontendIPConfiguration, 'availabilityZones')
          ? map(frontendIPConfiguration.?availabilityZones ?? [], zone => string(zone))
          : !empty(frontendIPConfiguration.?subnetResourceId)
              ? [
                  '1'
                  '2'
                  '3'
                ]
              : null
      }
    ]
    loadBalancingRules: loadBalancingRulesVar
    backendAddressPools: backendAddressPoolNames
    outboundRules: outboundRulesVar
    probes: probesVar
  }
  dependsOn: [
    loadBalancer_publicIPAddresses
    loadBalancer_publicIPPrefixes
  ]
}

module loadBalancer_backendAddressPools 'backend-address-pool/main.bicep' = [
  for (backendAddressPool, index) in backendAddressPools ?? []: if (backendAddressPool.?backendMembershipMode != 'NIC') {
    name: '${uniqueString(deployment().name, location)}-loadBalancer-backendAddPools-${index}'
    params: {
      loadBalancerName: loadBalancer.name
      name: backendAddressPool.name
      backendMembershipMode: backendAddressPool.?backendMembershipMode
      tunnelInterfaces: backendAddressPool.?tunnelInterfaces
      loadBalancerBackendAddresses: backendAddressPool.?loadBalancerBackendAddresses
      drainPeriodInSeconds: backendAddressPool.?drainPeriodInSeconds
      virtualNetworkResourceId: backendAddressPool.?virtualNetworkResourceId
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
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
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
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
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

import { ipTagType as pipIpTagType } from 'br/public:avm/res/network/public-ip-address:0.9.1'
import { dnsSettingsType, ddosSettingsType } from 'br/public:avm/res/network/public-ip-address:0.9.1'
import { ipTagType as prefixIpTagType } from 'br/public:avm/res/network/public-ip-prefix:0.7.1'

@export()
@description('The type for a public IP address configuration within a frontend IP configuration.')
type publicIPAddressConfigurationType = {
  @description('Optional. The name of the Public IP Address. If not provided, a default name will be generated.')
  name: string?

  @description('Optional. The public IP address allocation method.')
  publicIPAllocationMethod: ('Dynamic' | 'Static')?

  @description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from.')
  availabilityZones: (1 | 2 | 3)[]?

  @description('Optional. IP address version.')
  publicIPAddressVersion: ('IPv4' | 'IPv6')?

  @description('Optional. The DNS settings of the public IP address.')
  dnsSettings: dnsSettingsType?

  @description('Optional. The list of tags associated with the public IP address.')
  ipTags: pipIpTagType[]?

  @description('Optional. Name of a public IP address SKU.')
  skuName: ('Basic' | 'Standard')?

  @description('Optional. Tier of a public IP address SKU.')
  skuTier: ('Global' | 'Regional')?

  @description('Optional. The DDoS protection plan configuration associated with the public IP address.')
  ddosSettings: ddosSettingsType?

  @description('Optional. Array of role assignments to create for the public IP address.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. The idle timeout of the public IP address.')
  idleTimeoutInMinutes: int?

  @description('Optional. Tags of the public IP address resource.')
  tags: resourceInput<'Microsoft.Network/publicIPAddresses@2024-10-01'>.tags?

  @description('Optional. The diagnostic settings of the public IP address.')
  diagnosticSettings: diagnosticSettingFullType[]?

  @description('Optional. Resource ID of the Public IP Prefix. This is only needed if you want your Public IPs created in a PIP Prefix.')
  publicIpPrefixResourceId: string?

  @description('Optional. Enable/Disable usage telemetry for the public IP address module.')
  enableTelemetry: bool?
}

@export()
@description('The type for a public IP prefix configuration within a frontend IP configuration.')
type publicIPPrefixConfigurationType = {
  @description('Optional. The name of the Public IP Prefix. If not provided, a default name will be generated.')
  name: string?

  @description('Optional. Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty.')
  tier: ('Global' | 'Regional')?

  @description('Optional. Length of the Public IP Prefix.')
  @minValue(28)
  @maxValue(127)
  prefixLength: int?

  @description('Optional. The public IP address version.')
  publicIPAddressVersion: ('IPv4' | 'IPv6')?

  @description('Optional. The lock settings of the public IP prefix.')
  lock: lockType?

  @description('Optional. Array of role assignments to create for the public IP prefix.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Tags of the public IP prefix resource.')
  tags: resourceInput<'Microsoft.Network/publicIPPrefixes@2024-10-01'>.tags?

  @description('Optional. The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range.')
  customIPPrefix: resourceInput<'Microsoft.Network/publicIPPrefixes@2024-10-01'>.properties.customIPPrefix?

  @description('Optional. The list of tags associated with the public IP prefix.')
  ipTags: prefixIpTagType[]?

  @description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes.')
  availabilityZones: (1 | 2 | 3)[]?

  @description('Optional. Enable/Disable usage telemetry for the public IP prefix module.')
  enableTelemetry: bool?
}

@export()
@description('The type for a frontend IP configuration.')
type frontendIPConfigurationType = {
  @description('Required. The name of the frontend IP configuration.')
  name: string

  @description('Optional. The resource ID of an existing public IP address to use. Cannot be used together with publicIPAddressConfiguration.')
  publicIPAddressResourceId: string?

  @description('Optional. The configuration to create a new public IP address. Cannot be used together with publicIPAddressResourceId.')
  publicIPAddressConfiguration: publicIPAddressConfigurationType?

  @description('Optional. The resource ID of an existing public IP prefix to use. Cannot be used together with publicIPPrefixConfiguration.')
  publicIPPrefixResourceId: string?

  @description('Optional. The configuration to create a new public IP prefix. Cannot be used together with publicIPPrefixResourceId.')
  publicIPPrefixConfiguration: publicIPPrefixConfigurationType?

  @description('Optional. The resource ID of the subnet to use for a private frontend IP configuration.')
  subnetResourceId: string?

  @description('Optional. The private IP address to use for a private frontend IP configuration. Requires subnetResourceId.')
  privateIPAddress: string?

  @description('Optional. The private IP address version. Only applicable for private frontend IP configurations.')
  privateIPAddressVersion: ('IPv4' | 'IPv6')?

  @description('Optional. The resource ID of the gateway load balancer.')
  gatewayLoadBalancerResourceId: string?

  @description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from.')
  availabilityZones: (1 | 2 | 3)[]?

  @description('Optional. Tags of the frontend IP configuration.')
  tags: resourceInput<'Microsoft.Network/loadBalancers@2024-10-01'>.tags?
}
