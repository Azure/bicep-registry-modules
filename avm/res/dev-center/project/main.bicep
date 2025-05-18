metadata name = 'Dev Center Project'
metadata description = 'This module deploys a Dev Center Project.'

@description('Required. The name of the project.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags to apply to the project.')
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

resource project 'Microsoft.DevCenter/projects@2025-02-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  //properties: properties
}

resource project_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: project
}

resource project_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.name ?? guid(project.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.description
      principalType: roleAssignment.principalType
      condition: roleAssignment.condition
      conditionVersion: !empty(roleAssignment.condition) ? (roleAssignment.conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.delegatedManagedIdentityResourceId
    }
    scope: project
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
@description('Managed identity properties for the project.')
type managedServiceIdentityType = {
  @description('Required. Type of managed service identity. Allowed values: None, SystemAssigned, UserAssigned, SystemAssigned, UserAssigned.')
  type: 'None' | 'SystemAssigned' | 'UserAssigned' | 'SystemAssigned, UserAssigned'
  @description('Optional. The set of user assigned identities associated with the resource. The dictionary keys will be ARM resource ids.')
  userAssignedIdentities: object
}

@export()
@description('Properties of a Dev Center Project.')
type projectPropertiesType = {
  @description('Optional. Indicates whether Azure AI services are enabled for a project.')
  azureAiServicesSettings: azureAiServicesSettingsType?

  @description('Optional. Settings to be used when associating a project with a catalog.')
  catalogSettings: projectCatalogSettingsType?

  @description('Optional. Settings to be used for customizations.')
  customizationSettings: projectCustomizationSettingsType?

  @description('Optional. Description of the project.')
  description: string?

  @description('Optional. Dev Box Auto Delete settings.')
  devBoxAutoDeleteSettings: devBoxAutoDeleteSettingsType?

  @description('Required. Resource Id of an associated DevCenter.')
  devCenterId: string

  @description('Optional. The display name of the project.')
  displayName: string?

  @description('Optional. When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. Min value: 0.')
  maxDevBoxesPerUser: int?

  @description('Optional. Settings to be used for serverless GPU.')
  serverlessGpuSessionsSettings: serverlessGpuSessionsSettingsType?

  @description('Optional. Settings to be used for workspace storage.')
  workspaceStorageSettings: workspaceStorageSettingsType?
}

@export()
@description('Indicates whether Azure AI services are enabled for a project.')
type azureAiServicesSettingsType = {
  @description('Required. The property indicates whether Azure AI services is enabled. Allowed values: AutoDeploy, Disabled.')
  azureAiServicesMode: 'AutoDeploy' | 'Disabled'
}

@export()
@description('Settings to be used when associating a project with a catalog.')
type projectCatalogSettingsType = {
  @description('Optional. Indicates catalog item types that can be synced. Allowed values: EnvironmentDefinition, ImageDefinition.')
  catalogItemSyncTypes: ('EnvironmentDefinition' | 'ImageDefinition')[]?
}

@export()
@description('Settings to be used for customizations.')
type projectCustomizationSettingsType = {
  @description('Optional. The identities that can be used in customization scenarios; e.g., to clone a repository.')
  identities: projectCustomizationManagedIdentityType[]?
  @description('Optional. Indicates whether user customizations are enabled. Allowed values: Enabled, Disabled.')
  userCustomizationsEnableStatus: 'Enabled' | 'Disabled'?
}

@export()
@description('A managed identity for project customization.')
type projectCustomizationManagedIdentityType = {
  @description('Required. Resource ID of the managed identity.')
  identityResourceId: string
  @description('Required. Type of the managed identity. Allowed values: systemAssignedIdentity, userAssignedIdentity.')
  identityType: 'systemAssignedIdentity' | 'userAssignedIdentity'
}

@export()
@description('Dev Box Auto Delete settings.')
type devBoxAutoDeleteSettingsType = {
  @description('Required. Indicates the delete mode for Dev Boxes within this project. Allowed values: Auto, Manual.')
  deleteMode: 'Auto' | 'Manual'
  @description('Required. ISO8601 duration required for the dev box to be marked for deletion prior to it being deleted. Format: PT[n]H[n]M[n]S.')
  gracePeriod: string
  @description('Required. ISO8601 duration required for the dev box to not be inactive prior to it being scheduled for deletion. Format: PT[n]H[n]M[n]S.')
  inactiveThreshold: string
}

@export()
@description('Settings to be used for serverless GPU.')
type serverlessGpuSessionsSettingsType = {
  @description('Optional. When specified, limits the maximum number of concurrent sessions across all pools in the project. Min value: 1.')
  maxConcurrentSessionsPerProject: int?
  @description('Required. The property indicates whether serverless GPU access is enabled on the project. Allowed values: AutoDeploy, Disabled.')
  serverlessGpuSessionsMode: 'AutoDeploy' | 'Disabled'
}

@export()
@description('Settings to be used for workspace storage.')
type workspaceStorageSettingsType = {
  @description('Required. Indicates whether workspace storage is enabled. Allowed values: AutoDeploy, Disabled.')
  workspaceStorageMode: 'AutoDeploy' | 'Disabled'
}
