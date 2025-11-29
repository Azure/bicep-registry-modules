metadata name = 'Virtual Networks'
metadata description = 'This module deploys a Virtual Network (vNet).'

@description('Required. The name of the Virtual Network (vNet).')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The address space configuration for the Virtual Network. Use `by: \'addressPrefixes\'` with an array of CIDR ranges for manual allocation, or `by: \'ipam\'` with IPAM pool resource IDs and CIDR prefix sizes for dynamic IPAM-based allocation.')
param addressPrefixes ipAddressesType

@description('Optional. The BGP community associated with the virtual network.')
param virtualNetworkBgpCommunity string?

@description('Optional. An Array of subnets to deploy to the Virtual Network.')
param subnets subnetType[]?

@description('Optional. DNS Servers associated to the Virtual Network.')
param dnsServers string[]?

@description('Optional. Resource ID of the DDoS protection plan to assign the VNET to. If it\'s left blank, DDoS protection will not be configured. If it\'s provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription.')
param ddosProtectionPlanResourceId string?

@description('Optional. Virtual Network Peering configurations.')
param peerings peeringType[]?

@description('Optional. Indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. Requires the EnableVNetEncryption feature to be registered for the subscription and a supported region to use this property.')
param vnetEncryption bool = false

@allowed([
  'AllowUnencrypted'
  'DropUnencrypted'
])
@description('Optional. If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled.')
param vnetEncryptionEnforcement string = 'AllowUnencrypted'

@maxValue(30)
@description('Optional. The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. Default value 0 will set the property to null.')
param flowTimeoutInMinutes int = 0

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Indicates if VM protection is enabled for all the subnets in the virtual network.')
param enableVmProtection bool?

var enableReferencedModulesTelemetry = false

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

var formattedVirtualNetworkAddressSpace = addressPrefixes.by == 'ipam'
  ? {
      ipamPoolPrefixAllocations: map(addressPrefixes.ipamPoolPrefixAllocations, ipamPoolPrefixAllocation => {
        pool: {
          id: ipamPoolPrefixAllocation.ipamPoolResourceId
        }
        numberOfIpAddresses: getCidrHostCount(ipamPoolPrefixAllocation.cidr)
      })
    }
  : {
      addressPrefixes: addressPrefixes.addressPrefixes
    }

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-virtualnetwork.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: formattedVirtualNetworkAddressSpace
    bgpCommunities: !empty(virtualNetworkBgpCommunity)
      ? {
          virtualNetworkCommunity: virtualNetworkBgpCommunity!
        }
      : null
    ddosProtectionPlan: !empty(ddosProtectionPlanResourceId)
      ? {
          id: ddosProtectionPlanResourceId
        }
      : null
    dhcpOptions: !empty(dnsServers)
      ? {
          dnsServers: array(dnsServers)
        }
      : null
    enableDdosProtection: !empty(ddosProtectionPlanResourceId)
    encryption: vnetEncryption == true
      ? {
          enabled: vnetEncryption
          enforcement: vnetEncryptionEnforcement
        }
      : null
    flowTimeoutInMinutes: flowTimeoutInMinutes != 0 ? flowTimeoutInMinutes : null
    enableVmProtection: enableVmProtection
  }
}

@batchSize(1)
module virtualNetwork_subnets 'subnet/main.bicep' = [
  for (subnet, index) in (subnets ?? []): {
    name: '${uniqueString(deployment().name, location)}-subnet-${index}'
    params: {
      virtualNetworkName: virtualNetwork.name
      name: subnet.name
      addressPrefix: subnet.addressSpace.by == 'addressPrefix' ? subnet.addressSpace.addressPrefix : null
      addressPrefixes: subnet.addressSpace.by == 'addressPrefixes' ? subnet.addressSpace.addressPrefixes : null
      ipamPoolPrefixAllocations: subnet.addressSpace.by == 'ipam'
        ? map(subnet.addressSpace.ipamPoolPrefixAllocations, allocation => {
            pool: {
              id: allocation.ipamPoolResourceId
            }
            numberOfIpAddresses: getCidrHostCount(allocation.cidr)
          })
        : null
      applicationGatewayIPConfigurations: subnet.?applicationGatewayIPConfigurations
      delegation: subnet.?delegation
      natGatewayResourceId: subnet.?natGatewayResourceId
      networkSecurityGroupResourceId: subnet.?networkSecurityGroupResourceId
      privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies
      privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies
      roleAssignments: subnet.?roleAssignments
      routeTableResourceId: subnet.?routeTableResourceId
      serviceEndpointPolicies: subnet.?serviceEndpointPolicies
      serviceEndpoints: subnet.?serviceEndpoints
      defaultOutboundAccess: subnet.?defaultOutboundAccess
      sharingScope: subnet.?sharingScope
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

// Local to Remote peering
module virtualNetwork_peering_local 'virtual-network-peering/main.bicep' = [
  for (peering, index) in (peerings ?? []): {
    name: '${uniqueString(deployment().name, location)}-virtualNetworkPeering-local-${index}'
    // This is a workaround for an error in which the peering is deployed whilst the subnet creation is still taking place
    // TODO: https://github.com/Azure/bicep/issues/1013 would be a better solution
    dependsOn: [
      virtualNetwork_subnets
    ]
    params: {
      localVnetName: virtualNetwork.name
      remoteVirtualNetworkResourceId: peering.remoteVirtualNetworkResourceId
      name: peering.?name
      allowForwardedTraffic: peering.?allowForwardedTraffic
      allowGatewayTransit: peering.?allowGatewayTransit
      allowVirtualNetworkAccess: peering.?allowVirtualNetworkAccess
      doNotVerifyRemoteGateways: peering.?doNotVerifyRemoteGateways
      useRemoteGateways: peering.?useRemoteGateways
    }
  }
]

// Remote to local peering (reverse)
module virtualNetwork_peering_remote 'virtual-network-peering/main.bicep' = [
  for (peering, index) in (peerings ?? []): if (peering.?remotePeeringEnabled ?? false) {
    name: '${uniqueString(deployment().name, location)}-virtualNetworkPeering-remote-${index}'
    // This is a workaround for an error in which the peering is deployed whilst the subnet creation is still taking place
    // TODO: https://github.com/Azure/bicep/issues/1013 would be a better solution
    dependsOn: [
      virtualNetwork_subnets
    ]
    scope: resourceGroup(
      split(peering.remoteVirtualNetworkResourceId, '/')[2],
      split(peering.remoteVirtualNetworkResourceId, '/')[4]
    )
    params: {
      localVnetName: last(split(peering.remoteVirtualNetworkResourceId, '/'))
      remoteVirtualNetworkResourceId: virtualNetwork.id
      name: peering.?remotePeeringName
      allowForwardedTraffic: peering.?remotePeeringAllowForwardedTraffic
      allowGatewayTransit: peering.?remotePeeringAllowGatewayTransit
      allowVirtualNetworkAccess: peering.?remotePeeringAllowVirtualNetworkAccess
      doNotVerifyRemoteGateways: peering.?remotePeeringDoNotVerifyRemoteGateways
      useRemoteGateways: peering.?remotePeeringUseRemoteGateways
    }
  }
]

resource virtualNetwork_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: virtualNetwork
}

resource virtualNetwork_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: virtualNetwork
  }
]

resource virtualNetwork_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(virtualNetwork.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: virtualNetwork
  }
]

@description('The resource group the virtual network was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the virtual network.')
output resourceId string = virtualNetwork.id

@description('The name of the virtual network.')
output name string = virtualNetwork.name

@description('The names of the deployed subnets.')
output subnetNames array = [for (subnet, index) in (subnets ?? []): virtualNetwork_subnets[index].outputs.name]

@description('The resource IDs of the deployed subnets.')
output subnetResourceIds array = [
  for (subnet, index) in (subnets ?? []): virtualNetwork_subnets[index].outputs.resourceId
]

@description('The location the resource was deployed into.')
output location string = virtualNetwork.location

// =============== //
//   Definitions   //
// =============== //

@export()
type peeringType = {
  @description('Optional. The Name of VNET Peering resource. If not provided, default value will be peer-localVnetName-remoteVnetName.')
  name: string?

  @description('Required. The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID.')
  remoteVirtualNetworkResourceId: string

  @description('Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true.')
  allowForwardedTraffic: bool?

  @description('Optional. If gateway links can be used in remote virtual networking to link to this virtual network. Default is false.')
  allowGatewayTransit: bool?

  @description('Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true.')
  allowVirtualNetworkAccess: bool?

  @description('Optional. Do not verify the provisioning state of the remote gateway. Default is true.')
  doNotVerifyRemoteGateways: bool?

  @description('Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false.')
  useRemoteGateways: bool?

  @description('Optional. Deploy the outbound and the inbound peering.')
  remotePeeringEnabled: bool?

  @description('Optional. The name of the VNET Peering resource in the remove Virtual Network. If not provided, default value will be peer-remoteVnetName-localVnetName.')
  remotePeeringName: string?

  @description('Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true.')
  remotePeeringAllowForwardedTraffic: bool?

  @description('Optional. If gateway links can be used in remote virtual networking to link to this virtual network. Default is false.')
  remotePeeringAllowGatewayTransit: bool?

  @description('Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true.')
  remotePeeringAllowVirtualNetworkAccess: bool?

  @description('Optional. Do not verify the provisioning state of the remote gateway. Default is true.')
  remotePeeringDoNotVerifyRemoteGateways: bool?

  @description('Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false.')
  remotePeeringUseRemoteGateways: bool?
}

@export()
type subnetType = {
  @description('Required. The Name of the subnet resource.')
  name: string

  @description('Required. The address space configuration for the subnet. Supports IPAM-based allocation, multiple address prefixes, or a single address prefix.')
  addressSpace: subnetIpAddressesType

  @description('Optional. Application gateway IP configurations of virtual network resource.')
  applicationGatewayIPConfigurations: object[]?

  @description('Optional. The delegation to enable on the subnet.')
  delegation: string?

  @description('Optional. The resource ID of the NAT Gateway to use for the subnet.')
  natGatewayResourceId: string?

  @description('Optional. The resource ID of the network security group to assign to the subnet.')
  networkSecurityGroupResourceId: string?

  @description('Optional. enable or disable apply network policies on private endpoint in the subnet.')
  privateEndpointNetworkPolicies: ('Disabled' | 'Enabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?

  @description('Optional. enable or disable apply network policies on private link service in the subnet.')
  privateLinkServiceNetworkPolicies: ('Disabled' | 'Enabled')?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. The resource ID of the route table to assign to the subnet.')
  routeTableResourceId: string?

  @description('Optional. An array of service endpoint policies.')
  serviceEndpointPolicies: object[]?

  @description('Optional. The service endpoints to enable on the subnet.')
  serviceEndpoints: string[]?

  @description('Optional. Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.')
  defaultOutboundAccess: bool?

  @description('Optional. Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.')
  sharingScope: ('DelegatedServices' | 'Tenant')?
}

@export()
type cidrPrefixType =
  | '/1' // 2,147,483,648 addresses
  | '/2' // 1,073,741,824 addresses
  | '/3' // 536,870,912 addresses
  | '/4' // 268,435,456 addresses
  | '/5' // 134,217,728 addresses
  | '/6' // 67,108,864 addresses
  | '/7' // 33,554,432 addresses
  | '/8' // 16,777,216 addresses
  | '/9' // 8,388,608 addresses
  | '/10' // 4,194,304 addresses
  | '/11' // 2,097,152 addresses
  | '/12' // 1,048,576 addresses
  | '/13' // 524,288 addresses
  | '/14' // 262,144 addresses
  | '/15' // 131,072 addresses
  | '/16' // 65,536 addresses
  | '/17' // 32,768 addresses
  | '/18' // 16,384 addresses
  | '/19' // 8,192 addresses
  | '/20' // 4,096 addresses
  | '/21' // 2,048 addresses
  | '/22' // 1,024 addresses
  | '/23' // 512 addresses
  | '/24' // 256 addresses
  | '/25' // 128 addresses
  | '/26' // 64 addresses
  | '/27' // 32 addresses
  | '/28' // 16 addresses
  | '/29' // 8 addresses
  | '/30' // 4 addresses
  | '/31' // 2 addresses

@sealed()
@export()
type ipamAddressPrefixesType = {
  @description('Required. The allocation method for the address prefix. Must be set to `ipam` for IPAM-based allocation.')
  by: 'ipam'

  @description('Required. Array of IPAM pool prefix allocations specifying which pools to allocate address space from.')
  ipamPoolPrefixAllocations: {
    @description('Required. The resource ID of the IPAM pool to allocate the address prefix from.')
    ipamPoolResourceId: string

    @description('Required. The CIDR prefix size to allocate from the IPAM pool (e.g., `24` for a /24 subnet with 256 addresses).')
    cidr: cidrPrefixType
  }[]
}

@sealed()
@export()
type addressPrefixesType = {
  @description('Required. The allocation method for the address prefix. Must be set to `addressPrefixes` for manually specified address prefixes.')
  by: 'addressPrefixes'

  @description('Required. Array of manually specified address prefixes in CIDR notation (e.g., `["10.0.0.0/16", "10.1.0.0/16"]`).')
  addressPrefixes: string[]
}

@sealed()
@export()
type addressPrefixType = {
  @description('Required. The allocation method for the address prefix. Must be set to `addressPrefix` for a single manually specified address prefix.')
  by: 'addressPrefix'

  @description('Required. The manually specified address prefix in CIDR notation (e.g., `10.0.0.0/24`).')
  addressPrefix: string
}

@export()
@discriminator('by')
@description('Discriminated union type for Virtual Network address space configuration. Supports either IPAM-based allocation or manually specified address prefixes.')
type ipAddressesType = ipamAddressPrefixesType | addressPrefixesType

@export()
@discriminator('by')
@description('Discriminated union type for Subnet address configuration. Supports IPAM-based allocation, multiple address prefixes, or a single address prefix.')
type subnetIpAddressesType = ipamAddressPrefixesType | addressPrefixesType | addressPrefixType

@export()
type keyValuePairType = {
  *: string
}

// Functions to get number of hosts in a CIDR prefix
@description('Returns the number of hosts available for a given CIDR prefix.')
@export()
func getCidrHostCounts() keyValuePairType => {
  '/1': '2147483648' // 2,147,483,648 addresses
  '/2': '1073741824' // 1,073,741,824 addresses
  '/3': '536870912' // 536,870,912 addresses
  '/4': '268435456' // 268,435,456 addresses
  '/5': '134217728' // 134,217,728 addresses
  '/6': '67108864' // 67,108,864 addresses
  '/7': '33554432' // 33,554,432 addresses
  '/8': '16777216' // 16,777,216 addresses
  '/9': '8388608' // 8,388,608 addresses
  '/10': '4194304' // 4,194,304 addresses
  '/11': '2097152' // 2,097,152 addresses
  '/12': '1048576' // 1,048,576 addresses
  '/13': '524288' // 524,288 addresses
  '/14': '262144' // 262,144 addresses
  '/15': '131072' // 131,072 addresses
  '/16': '65536' // 65,536 addresses
  '/17': '32768' // 32,768 addresses
  '/18': '16384' // 16,384 addresses
  '/19': '8192' // 8,192 addresses
  '/20': '4096' // 4,096 addresses
  '/21': '2048' // 2,048 addresses
  '/22': '1024' // 1,024 addresses
  '/23': '512' // 512 addresses
  '/24': '256' // 256 addresses
  '/25': '128' // 128 addresses
  '/26': '64' // 64 addresses
  '/27': '32' // 32 addresses
  '/28': '16' // 16 addresses
  '/29': '8' // 8 addresses
  '/30': '4' // 4 addresses
  '/31': '2' // 2 addresses
}

@export()
@description('Returns the number of hosts available for a given CIDR prefix.')
func getCidrHostCount(cidrPrefix cidrPrefixType) string => getCidrHostCounts()[cidrPrefix]
