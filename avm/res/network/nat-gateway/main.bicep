metadata name = 'NAT Gateways'
metadata description = 'This module deploys a NAT Gateway.'

@description('Required. Name of the Azure Bastion resource.')
param name string

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int

@description('Optional. The idle timeout of the NAT gateway.')
param idleTimeoutInMinutes int = 5

@description('Optional. The SKU of the NAT Gateway.')
@allowed([
  'Standard'
  'StandardV2'
])
param natGatewaySku string = 'Standard'

@description('Optional. Existing Public IP Address resource IDs to use for the NAT Gateway.')
param publicIpResourceIds string[] = []

@description('Optional. Existing Public IP Prefixes resource IDs to use for the NAT Gateway.')
param publicIPPrefixResourceIds string[] = []

@description('Optional. Specifies the properties of the Public IPs to create and be used by the NAT Gateway.')
param publicIPAddresses publicIpType[]?

@description('Optional. Specifies the properties of the Public IP Prefixes to create and be used by the NAT Gateway.')
param publicIPPrefixes publicIPPrefixType[]?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags for the resource.')
param tags resourceInput<'Microsoft.Network/natGateways@2025-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-natgateway.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
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

module natGateway_publicIPAddresses 'br/public:avm/res/network/public-ip-address:0.12.0' = [
  for (publicIPAddress, index) in (publicIPAddresses ?? []): {
    name: '${uniqueString(deployment().name, location)}-NatGw-PIP-${index}'
    params: {
      name: publicIPAddress.?name ?? '${name}-pip'
      location: location
      lock: publicIPAddress.?lock ?? lock
      diagnosticSettings: publicIPAddress.?diagnosticSettings
      publicIPAddressVersion: publicIPAddress.?publicIPAddressVersion
      publicIPAllocationMethod: 'Static'
      publicIpPrefixResourceId: publicIPAddress.?publicIPPrefixResourceId
      roleAssignments: publicIPAddress.?roleAssignments
      skuName: publicIPAddress.?skuName ?? natGatewaySku
      skuTier: publicIPAddress.?skuTier
      tags: publicIPAddress.?tags ?? tags
      availabilityZones: publicIPAddress.?availabilityZones ?? (availabilityZone != -1 ? [availabilityZone] : null)
      enableTelemetry: enableReferencedModulesTelemetry
      ddosSettings: publicIPAddress.?ddosSettings
      dnsSettings: publicIPAddress.?dnsSettings
      idleTimeoutInMinutes: publicIPAddress.?idleTimeoutInMinutes
      ipTags: publicIPAddress.?ipTags
    }
  }
]

module formattedPublicIpResourceIds 'modules/formatResourceId.bicep' = {
  name: '${uniqueString(deployment().name, location)}-formattedPublicIpResourceIds'
  params: {
    generatedResourceIds: [
      for (obj, index) in (publicIPAddresses ?? []): natGateway_publicIPAddresses[index].outputs.resourceId
    ]
    providedResourceIds: publicIpResourceIds
  }
}

module natGateway_publicIPPrefixes 'br/public:avm/res/network/public-ip-prefix:0.8.0' = [
  for (publicIPPrefix, index) in (publicIPPrefixes ?? []): {
    name: '${uniqueString(deployment().name, location)}-NatGw-Prefix-PIP-${index}'
    params: {
      name: publicIPPrefix.?name ?? '${name}-pip'
      location: location
      lock: publicIPPrefix.?lock ?? lock
      prefixLength: publicIPPrefix.prefixLength
      customIPPrefix: publicIPPrefix.?customIPPrefix
      roleAssignments: publicIPPrefix.?roleAssignments
      tags: publicIPPrefix.?tags ?? tags
      enableTelemetry: enableReferencedModulesTelemetry
      availabilityZones: publicIPPrefix.?availabilityZones ?? (availabilityZone != -1 ? [availabilityZone] : null)
      ipTags: publicIPPrefix.?ipTags
      publicIPAddressVersion: publicIPPrefix.?publicIPAddressVersion
      tier: publicIPPrefix.?tier
    }
  }
]
module formattedPublicIpPrefixResourceIds 'modules/formatResourceId.bicep' = {
  name: '${uniqueString(deployment().name, location)}-formattedPublicIpPrefixResourceIds'
  params: {
    generatedResourceIds: [
      for (obj, index) in (publicIPPrefixes ?? []): natGateway_publicIPPrefixes[index].outputs.resourceId
    ]
    providedResourceIds: publicIPPrefixResourceIds
  }
}

// NAT GATEWAY
// ===========
resource natGateway 'Microsoft.Network/natGateways@2025-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: natGatewaySku
  }
  properties: {
    idleTimeoutInMinutes: idleTimeoutInMinutes
    publicIpPrefixes: formattedPublicIpPrefixResourceIds.outputs.formattedResourceIds
    publicIpAddresses: formattedPublicIpResourceIds.outputs.formattedResourceIds
  }
  zones: availabilityZone != -1 ? [string(availabilityZone)] : null
}

resource natGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: natGateway
}

resource natGateway_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(natGateway.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: natGateway
  }
]

@description('The name of the NAT Gateway.')
output name string = natGateway.name

@description('The resource ID of the NAT Gateway.')
output resourceId string = natGateway.id

@description('The resource group the NAT Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = natGateway.location

// =============== //
//   Definitions   //
// =============== //

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
import { ddosSettingsType, dnsSettingsType, ipTagType as pipIpTagType } from 'br/public:avm/res/network/public-ip-address:0.9.0'

@export()
@description('The type of a public IP.')
type publicIpType = {
  @description('Required. The name of the Public IP Address.')
  name: string

  @description('Optional. Resource ID of the Public IP Prefix. This is only needed if you want your Public IPs created in a PIP Prefix.')
  publicIpPrefixResourceId: string?

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

  @description('Optional. The lock settings of the service.')
  lock: lockType?

  @description('Optional. Name of a public IP address SKU.')
  skuName: ('Basic' | 'Standard' | 'StandardV2')?

  @description('Optional. Tier of a public IP address SKU.')
  skuTier: ('Global' | 'Regional')?

  @description('Optional. The DDoS protection plan configuration associated with the public IP address.')
  ddosSettings: ddosSettingsType?

  @description('Optional. Location for all resources.')
  location: string?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. The idle timeout of the public IP address.')
  idleTimeoutInMinutes: int?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Network/publicIPAddresses@2024-10-01'>.tags?

  @description('Optional. The diagnostic settings of the service.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

import { ipTagType as prefixIpTagType } from 'br/public:avm/res/network/public-ip-prefix:0.7.0'

@export()
@description('The type of a public IP prefix.')
type publicIPPrefixType = {
  @description('Required. The name of the Public IP Prefix.')
  @minLength(1)
  name: string

  @description('Optional. Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty.')
  tier: ('Global' | 'Regional')?

  @description('Optional. Location for all resources.')
  location: string?

  @description('Required. Length of the Public IP Prefix.')
  @minValue(21)
  @maxValue(127)
  prefixLength: int

  @description('Optional. The public IP address version.')
  publicIPAddressVersion: ('IPv4' | 'IPv6')?

  @description('Optional. The lock settings of the service.')
  lock: lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Network/publicIPPrefixes@2024-10-01'>.tags?

  @description('Optional. The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range.')
  customIPPrefix: resourceInput<'Microsoft.Network/publicIPPrefixes@2024-10-01'>.properties.customIPPrefix?

  @description('Optional. The list of tags associated with the public IP prefix.')
  ipTags: prefixIpTagType[]?

  @description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes.')
  availabilityZones: (1 | 2 | 3)[]?
}
