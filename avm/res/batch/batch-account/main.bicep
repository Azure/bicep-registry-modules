metadata name = 'Batch Accounts'
metadata description = 'This module deploys a Batch Account.'

@description('Required. Name of the Azure Batch.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The resource ID of the storage account to be used for auto-storage account.')
param storageAccountId string

@allowed([
  'BatchAccountManagedIdentity'
  'StorageKeys'
])
@description('Optional. The authentication mode which the Batch service will use to manage the auto-storage account.')
param storageAuthenticationMode string = 'StorageKeys'

@description('Optional. The resource ID of a user assigned identity assigned to pools which have compute nodes that need access to auto-storage.')
param storageAccessIdentityResourceId string?

@allowed([
  'BatchService'
  'UserSubscription'
])
@description('Optional. The allocation mode for creating pools in the Batch account. Determines which quota will be used.')
param poolAllocationMode string = 'BatchService'

@description('Conditional. The key vault to associate with the Batch account. Required if the \'poolAllocationMode\' is set to \'UserSubscription\' and requires the service principal \'Microsoft Azure Batch\' to be granted contributor permissions on this key vault.')
param keyVaultReferenceResourceId string?

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkProfile is not set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Network access profile. It is only applicable when publicNetworkAccess is not explicitly disabled.')
param networkProfile networkProfileType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@allowed([
  'AAD'
  'SharedKey'
  'TaskAuthenticationToken'
])
@description('Optional. List of allowed authentication modes for the Batch account that can be used to authenticate with the data plane.')
param allowedAuthenticationModes array?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var accountAccessNetworkProfileIpRules = [
  for allowedIpRule in networkProfile.?accountAccess.?allowedIpRules ?? []: {
    action: 'Allow'
    value: allowedIpRule
  }
]

var nodeManagementAccessNetworkProfileIpRules = [
  for allowedIpRule in networkProfile.?nodeManagementAccess.?allowedIpRules ?? []: {
    action: 'Allow'
    value: allowedIpRule
  }
]

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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
  name: '46d3xbcp.res.batch-batchaccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource batchKeyVaultReference 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (poolAllocationMode == 'UserSubscription') {
  name: last(split((keyVaultReferenceResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((keyVaultReferenceResourceId ?? '//'), '/')[2],
    split((keyVaultReferenceResourceId ?? '////'), '/')[4]
  )
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource batchAccount 'Microsoft.Batch/batchAccounts@2022-06-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    allowedAuthenticationModes: allowedAuthenticationModes
    autoStorage: {
      authenticationMode: storageAuthenticationMode
      nodeIdentityReference: null != storageAccessIdentityResourceId
        ? {
            resourceId: storageAccessIdentityResourceId
          }
        : null
      storageAccountId: storageAccountId
    }
    encryption: !empty(customerManagedKey)
      ? {
          keySource: 'Microsoft.KeyVault'
          keyVaultProperties: {
            keyIdentifier: !empty(customerManagedKey.?keyVersion)
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
              : (customerManagedKey.?autoRotationEnabled ?? true)
                  ? cMKKeyVault::cMKKey.properties.keyUri
                  : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          }
        }
      : null
    keyVaultReference: poolAllocationMode == 'UserSubscription'
      ? {
          id: batchKeyVaultReference.id
          url: batchKeyVaultReference.properties.vaultUri
        }
      : null
    networkProfile: !empty(networkProfile ?? {})
      ? {
          accountAccess: !empty(accountAccessNetworkProfileIpRules)
            ? {
                defaultAction: networkProfile.?accountAccess.?defaultAction ?? 'Deny'
                ipRules: accountAccessNetworkProfileIpRules
              }
            : null
          nodeManagementAccess: !empty(nodeManagementAccessNetworkProfileIpRules)
            ? {
                defaultAction: networkProfile.?nodeManagementAccess.?defaultAction ?? 'Deny'
                ipRules: nodeManagementAccessNetworkProfileIpRules
              }
            : null
        }
      : null
    poolAllocationMode: poolAllocationMode
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : ((!empty(privateEndpoints ?? []) && empty(networkProfile ?? [])) ? 'Disabled' : null)
  }
}

resource batchAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: batchAccount
}

resource batchAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: batchAccount
  }
]

module batchAccount_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-batchAccount-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(batchAccount.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(batchAccount.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: batchAccount.id
                groupIds: [
                  privateEndpoint.service
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(batchAccount.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: batchAccount.id
                groupIds: [
                  privateEndpoint.service
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource batchAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(batchAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: batchAccount
  }
]

@description('The name of the batch account.')
output name string = batchAccount.name

@description('The resource ID of the batch account.')
output resourceId string = batchAccount.id

@description('The resource group the batch account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = batchAccount.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = batchAccount.?identity.?principalId

@description('The private endpoints of the batch account.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: batchAccount_privateEndpoints[i].outputs.name
    resourceId: batchAccount_privateEndpoints[i].outputs.resourceId
    groupId: batchAccount_privateEndpoints[i].outputs.groupId
    customDnsConfig: batchAccount_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: batchAccount_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
type networkProfileType = {
  @description('Optional. Network access profile for batchAccount endpoint (Batch account data plane API).')
  accountAccess: endpointAccessProfileType?

  @description('Optional. Network access profile for nodeManagement endpoint (Batch service managing compute nodes for Batch pools).')
  nodeManagementAccess: endpointAccessProfileType?
}

@export()
type endpointAccessProfileType = {
  @description('Optional. Default action for endpoint access. If not specified, defaults to Deny.')
  defaultAction: ('Allow' | 'Deny')?

  @description('Optional. Array of IP ranges to filter client IP address.')
  allowedIpRules: array?
}
