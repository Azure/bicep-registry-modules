metadata name = 'Log Analytics Dedicated Clusters'
metadata description = '''This module deploys Log Analytics Dedicated Clusters.

> NOTE
> - There is a limit of seven clusters per subscription and region, five active, plus two that were deleted in past two weeks.
> - A cluster's name remains reserved two weeks after deletion, and can't be used for creating a new cluster.'''

@description('Required. Name of the Log Analytics cluster. Can contain only 63 letters, numbers and \'-\'.')
@maxLength(63)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The sku properties.')
param sku skuType

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.OperationalInsights/clusters@2025-02-01'>.tags?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
param managedIdentities managedIdentityAllType?

@description('Optional. The cluster\'s billing type. Defaults to \'Cluster\'.')
param billingType ('Cluster' | 'Workspaces') = 'Cluster'

@description('Optional. The Capacity Reservation properties.')
param capacityReservationProperties resourceInput<'Microsoft.OperationalInsights/clusters@2025-02-01'>.properties.capacityReservationProperties?

@description('Optional. Sets whether the cluster will support availability zones. This can be set as true only in regions where Azure Data Explorer support Availability Zones. This Property can not be modified after cluster creation.')
param isAvailabilityZonesEnabled bool = true

@description('Optional. Configures whether cluster will use double encryption. This Property can not be modified after cluster creation.')
param isDoubleEncryptionEnabled bool = true

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. Cluster\'s replication properties.')
param replication resourceInput<'Microsoft.OperationalInsights/clusters@2025-02-01'>.properties.replication?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

// Null is not allowed, so always assigning a value (even if it's just "type: 'None'")
var identity = {
  type: (managedIdentities.?systemAssigned ?? false)
    ? 'SystemAssigned'
    : (!empty(formattedUserAssignedIdentities) ? 'UserAssigned' : 'None')
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.operationalinsights-cluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

var isHSMManagedCMK = split(customerManagedKey.?keyVaultResourceId ?? '', '/')[?7] == 'managedHSMs'
resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
    name: customerManagedKey.?keyName!
  }
}

resource cluster 'Microsoft.OperationalInsights/clusters@2025-02-01' = {
  name: name
  location: location
  sku: {
    name: sku.?name ?? 'CapacityReservation'
    capacity: sku.capacity
  }
  tags: tags
  identity: identity
  properties: {
    billingType: billingType
    capacityReservationProperties: capacityReservationProperties
    isAvailabilityZonesEnabled: isAvailabilityZonesEnabled
    isDoubleEncryptionEnabled: isDoubleEncryptionEnabled
    keyVaultProperties: !empty(customerManagedKey)
      ? {
          keyName: customerManagedKey!.keyName
          keyVaultUri: !isHSMManagedCMK
            ? cMKKeyVault!.properties.vaultUri
            : 'https://${last(split((customerManagedKey!.keyVaultResourceId), '/'))}.managedhsm.azure.net/'
          keyVersion: !empty(customerManagedKey.?keyVersion)
            ? customerManagedKey!.keyVersion!
            : (customerManagedKey.?autoRotationEnabled ?? true)
                ? ''
                : (!isHSMManagedCMK
                    ? last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
                    : fail('Managed HSM CMK encryption requires either specifying the \'keyVersion\' or omitting the \'autoRotationEnabled\' property. Setting \'autoRotationEnabled\' to false without a \'keyVersion\' is not allowed.'))
        }
      : null
    replication: replication
  }
}

resource cluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: cluster
}

resource cluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(cluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: cluster
  }
]

@description('The name of the Log Analytics Cluster.')
output name string = cluster.name

@description('The resource ID of the Log Analytics Cluster.')
output resourceId string = cluster.id

@description('The resource group the Log Analytics Cluster was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = cluster.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = cluster.location

// ================ //
// Definitions      //
// ================ //
@export()
@description('The type of a SKU.')
type skuType = {
  @description('Required. The capacity reservation level in Gigabytes for this cluster (GB/day).')
  capacity: (100 | 200 | 300 | 400 | 500 | 1000 | 2000 | 5000 | 10000 | 25000 | 50000)

  @description('Optional. The SKU (tier) of a cluster. Defaults to \'CapacityReservation\'.')
  name: 'CapacityReservation'?
}
