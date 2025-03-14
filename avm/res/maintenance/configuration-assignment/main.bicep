metadata name = 'Maintenance Configuration Assignments'
metadata description = 'This module deploys a Maintenance Configuration Assignment.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. Maintenance Configuration Name.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The maintenance configuration resource ID.')
param maintenanceConfigurationResourceId string

@description('Required. The unique resource ID to assign the configuration to.')
param resourceId string

// =============== //
//   Deployments   //
// =============== //

// var builtInRoleNames = {
//   Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
//   Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
//   Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
//   'Role Based Access Control Administrator': subscriptionResourceId(
//     'Microsoft.Authorization/roleDefinitions',
//     'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
//   )
//   'Scheduled Patching Contributor': subscriptionResourceId(
//     'Microsoft.Authorization/roleDefinitions',
//     'cd08ab90-6b14-449c-ad9a-8f8e549482c6'
//   )
//   'User Access Administrator': subscriptionResourceId(
//     'Microsoft.Authorization/roleDefinitions',
//     '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
//   )
// }

// var formattedRoleAssignments = [
//   for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
//     roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
//         roleAssignment.roleDefinitionIdOrName,
//         '/providers/Microsoft.Authorization/roleDefinitions/'
//       )
//       ? roleAssignment.roleDefinitionIdOrName
//       : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
//   })
// ]

// #disable-next-line no-deployments-resources
// resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
//   name: '46d3xbcp.res.maintenance-maintenanceconfiguration.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
//   properties: {
//     mode: 'Incremental'
//     template: {
//       '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
//       contentVersion: '1.0.0.0'
//       resources: []
//       outputs: {
//         telemetry: {
//           type: 'String'
//           value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
//         }
//       }
//     }
//   }
// }

resource configurationAssignment 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = {
  // scope: scope
  location: location
  name: name
  properties: {
    // filter
    maintenanceConfigurationId: maintenanceConfigurationResourceId
    resourceId: resourceId
  }
}

// resource maintenanceConfiguration_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
//   name: lock.?name ?? 'lock-${name}'
//   properties: {
//     level: lock.?kind ?? ''
//     notes: lock.?kind == 'CanNotDelete'
//       ? 'Cannot delete resource or child resources.'
//       : 'Cannot delete or modify the resource or child resources.'
//   }
//   scope: maintenanceConfiguration
// }

// resource maintenanceConfiguration_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
//   for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
//     name: roleAssignment.?name ?? guid(
//       maintenanceConfiguration.id,
//       roleAssignment.principalId,
//       roleAssignment.roleDefinitionId
//     )
//     properties: {
//       roleDefinitionId: roleAssignment.roleDefinitionId
//       principalId: roleAssignment.principalId
//       description: roleAssignment.?description
//       principalType: roleAssignment.?principalType
//       condition: roleAssignment.?condition
//       conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
//       delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
//     }
//     scope: maintenanceConfiguration
//   }
// ]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the Maintenance Configuration.')
output name string = configurationAssignment.name

@description('The resource ID of the Maintenance Configuration.')
output resourceId string = configurationAssignment.id

@description('The name of the resource group the Maintenance Configuration was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the Maintenance Configuration was created in.')
output location string = configurationAssignment.location

// =============== //
//   Definitions   //
// =============== //

// filter
