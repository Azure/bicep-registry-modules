metadata name = 'Dev Center'
metadata description = 'This module deploys an Azure Dev Center.'

@description('Required. Name of the Dev Center.')
@minLength(3)
@maxLength(26)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. The display name of the Dev Center.')
param displayName string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Settings to be used in the provisioning of all Dev Boxes that belong to this dev center.')
param devBoxProvisioningSettings devBoxProvisioningSettingsType?

@description('Optional. Network settings that will be enforced on network resources associated with the Dev Center.')
param networkSettings networkSettingsType?

@description('Optional. Dev Center settings to be used when associating a project with a catalog.')
param projectCatalogSettings projectCatalogSettingsType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DevCenter Project Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '331c37c6-af14-46d9-b9f4-e1909e1b95a0'
  )
  'DevCenter Dev Box User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '45d50f46-0b78-4001-a660-4198cbe8cd05'
  )
  'DevTest Labs User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '76283e04-6283-4c54-8f91-bcf1374a3c64'
  )
  'Deployment Environments User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18e40d4e-8d2e-438d-97e1-9528336e149c'
  )
  'Deployment Environments Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'eb960402-bf75-4cc3-8d68-35b34f960f72'
  )
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

// ============== //
// Resources      //
// ============== //

//#disable-next-line no-deployments-resources
//resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
//  name: '46d3xbcp.res-devcenter-devcenter.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
//  properties: {
//    mode: 'Incremental'
//    template: {
//      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
//      contentVersion: '1.0.0.0'
//      resources: []
//      outputs: {
//        telemetry: {
//          type: 'String'
//          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
//        }
//      }
//    }
//  }
//}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource devCenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    devBoxProvisioningSettings: devBoxProvisioningSettings
    displayName: displayName
    encryption: {}
    //encryption: !empty(customerManagedKey)
    //  ? {
    //      customerManagedKeyEncryption: {
    //        keyEncryptionKeyIdentity: {
    //          userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //            ? cMKUserAssignedIdentity.id
    //            : null
    //          identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
    //            ? 'userAssignedIdentity'
    //            : 'systemAssignedIdentity'
    //        }
    //        keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
    //          ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
    //          : (customerManagedKey.?autoRotationEnabled ?? true)
    //              ? cMKKeyVault::cMKKey.properties.keyUri
    //              : cMKKeyVault::cMKKey.properties.keyUriWithVersion
    //      }
    //    }
    //  : {}
    networkSettings: networkSettings
    projectCatalogSettings: projectCatalogSettings
  }
}

resource devCenter_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: devCenter
}

resource devCenter_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(devCenter.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: devCenter
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Dev Center.')
output resourceId string = devCenter.id

@description('The name of the Dev Center.')
output name string = devCenter.name

@description('The resource group the Dev Center was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the Dev Center was deployed into.')
output location string = devCenter.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = devCenter.?identity.?principalId

@description('The URI of the Dev Center.')
output devCenterUri string = devCenter.properties.devCenterUri

// ================ //
// Definitions      //
// ================ //

@description('The type for Dev Box provisioning settings.')
type devBoxProvisioningSettingsType = {
  @description('Optional. Whether project catalogs associated with projects in this dev center can be configured to sync catalog items.')
  installAzureMonitorAgentEnableStatus: ('Enabled' | 'Disabled')?
}

@description('The type for network settings.')
type networkSettingsType = {
  @description('Optional. Indicates whether pools in this Dev Center can use Microsoft Hosted Networks. Defaults to Enabled if not set.')
  microsoftHostedNetworkEnableStatus: ('Enabled' | 'Disabled')?
}

@description('The type for project catalog settings.')
type projectCatalogSettingsType = {
  @description('Optional. Whether project catalogs associated with projects in this dev center can be configured to sync catalog items.')
  catalogItemSyncEnableStatus: ('Enabled' | 'Disabled')?
}
