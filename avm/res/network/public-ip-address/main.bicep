metadata name = 'Public IP Addresses'
metadata description = 'This module deploys a Public IP Address.'

@description('Required. The name of the Public IP Address.')
param name string

@description('Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIpPrefixResourceId string?

@description('Optional. The public IP address allocation method.')
param publicIPAllocationMethod resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.properties.publicIPAllocationMethod = 'Static'

@description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from.')
@allowed([
  1
  2
  3
])
param availabilityZones int[] = [
  1
  2
  3
]

@description('Optional. IP address version.')
param publicIPAddressVersion resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.properties.publicIPAddressVersion = 'IPv4'

@description('Optional. The DNS settings of the public IP address.')
param dnsSettings resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.properties.dnsSettings?

@description('Optional. The list of tags associated with the public IP address.')
param ipTags resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.properties.ipTags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Name of a public IP address SKU.')
param skuName resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.sku.name = 'Standard'

@description('Optional. Tier of a public IP address SKU.')
param skuTier resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.sku.tier = 'Regional'

@description('Optional. The DDoS protection plan configuration associated with the public IP address.')
param ddosSettings resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.properties.ddosSettings?

@description('Optional. The delete option for the public IP address.')
param deleteOption resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.properties.deleteOption?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The idle timeout of the public IP address.')
param idleTimeoutInMinutes int = 4

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/publicIPAddresses@2025-01-01'>.tags?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DNS Resolver Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d'
  )
  'DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'befefa01-2a29-4197-83a8-272ff33ce314'
  )
  'Domain Services Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'eeaeda52-9324-47f6-8069-5d5bade478b2'
  )
  'Domain Services Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '361898ef-9ed1-48c2-849c-a832951106bb'
  )
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
  )
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-publicipaddress.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2025-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  zones: map(availabilityZones, zone => string(zone))
  properties: {
    ddosSettings: ddosSettings
    dnsSettings: dnsSettings
    publicIPAddressVersion: publicIPAddressVersion
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPPrefix: !empty(publicIpPrefixResourceId)
      ? {
          id: publicIpPrefixResourceId
        }
      : null
    idleTimeoutInMinutes: idleTimeoutInMinutes
    ipTags: ipTags
    deleteOption: deleteOption
  }
}

resource publicIpAddress_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: publicIpAddress
}

resource publicIpAddress_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(publicIpAddress.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: publicIpAddress
  }
]

resource publicIpAddress_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: publicIpAddress
  }
]

@description('The resource group the public IP address was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the public IP address.')
output name string = publicIpAddress.name

@description('The resource ID of the public IP address.')
output resourceId string = publicIpAddress.id

@description('The public IP address of the public IP address resource.')
output ipAddress string = publicIpAddress.properties.?ipAddress ?? ''

@description('The location the resource was deployed into.')
output location string = publicIpAddress.location
