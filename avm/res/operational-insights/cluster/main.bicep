metadata name = 'Log Analytics Clusters'
metadata description = 'This module deploys a Log Analytics Cluster.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Log Analytics Cluster.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@allowed([
  'CapacityReservation'
  'PayAsYouGo'
])
@description('Optional. The billing type of the cluster. If not specified, the default is \'CapacityReservation\'. The cluster can be used for free for the first 30 days if \'PayAsYouGo\' is selected.')
param billingType string = 'CapacityReservation'

@description('Optional. The cluster capacity in Capacity Units (CUs). A CU represents a reservation of 100 GB/day ingestion and 400 GB storage. Minimum of 1000 CUs and maximum of 2000 CUs.')
@minValue(1000)
@maxValue(2000)
param size int = 1000

@description('Optional. The managed identity definition for this resource. Enables system-assigned and/or user-assigned identities.')
param managedIdentities object = {}

@description('Optional. List of workspace resource IDs to associate with the cluster. Log Analytics workspaces in the specified list will use this cluster as their data destination.')
param associatedWorkspaces array = []

@description('Optional. Properties for capacity reservation.')
param capacityReservationProperties object = {}

@description('Optional. Whether availability zones are enabled.')
param isAvailabilityZonesEnabled bool = false

@description('Optional. Whether double encryption is enabled.')
param isDoubleEncryptionEnabled bool = false

@description('Optional. Properties for configuring key vault for double encryption.')
param keyVaultProperties object = {
  keyName: ''
  keyRsaSize: 2048
  keyVersion: ''
  keyVaultUri: ''
}

@description('Optional. Configuration for cluster replication. When enabled, the cluster can replicate data to another region.')
param replication object = {
  enabled: false
  isAvailabilityZonesEnabled: false
  location: ''
}

import { roleAssignmentType, diagnosticSettingFullType, lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. The lock settings of the service.')
param lock lockType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? []) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  )
  'Log Analytics Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c42c96-874c-492b-b04d-ab87d138a893'
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

resource cluster 'Microsoft.OperationalInsights/clusters@2025-02-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    capacity: size
  }
  properties: {
    billingType: billingType
    associatedWorkspaces: !empty(associatedWorkspaces) ? associatedWorkspaces : []
    capacityReservationProperties: !empty(capacityReservationProperties) ? capacityReservationProperties : null
    isAvailabilityZonesEnabled: isAvailabilityZonesEnabled
    isDoubleEncryptionEnabled: isDoubleEncryptionEnabled
    keyVaultProperties: !empty(keyVaultProperties) ? keyVaultProperties : null
    replication: replication
  }
}

resource cluster_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: cluster
  }
]

resource cluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot modify the resource or child resources.'
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

@description('The resource ID of the deployed cluster.')
output resourceId string = cluster.id

@description('The resource group where the cluster is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployed cluster.')
output name string = cluster.name

@description('The location the resource was deployed into.')
output location string = cluster.location

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = cluster.?identity.?principalId ?? ''
