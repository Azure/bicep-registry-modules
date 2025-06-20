metadata name = 'Dev Center Project'
metadata description = 'This module deploys a Dev Center Project.'

@sys.description('Required. The name of the project.')
@minLength(3)
@maxLength(63)
param name string

@sys.description('Optional. The display name of project.')
param displayName string?

@sys.description('Optional. The description of the project.')
param description string?

@sys.description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. Resource tags to apply to the project.')
param tags resourceInput<'Microsoft.DevCenter/projects@2025-02-01'>.tags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The managed identity definition for this resource. Only one user assigned identity can be used per project.')
param managedIdentities managedIdentityAllType?

@sys.description('Required. Resource ID of an associated DevCenter.')
param devCenterResourceId string

@sys.description('Optional. The settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings.')
param catalogSettings catalogSettingsType?

@sys.description('Optional. When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced.')
@minValue(0)
param maxDevBoxesPerUser int?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. The environment types to create. Environment types must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.')
param environmentTypes environmentTypeType[]?

@sys.description('Optional. The type of pool to create in the project. A project pool is a container for dev boxes that share the same configuration, like a dev box definition and a network connection. Essentially, a project pool defines the specifications for the dev boxes that developers can create from a specific project in the Dev Box service.')
param pools poolType[]?

@sys.description('Optional. The catalogs to create in the project. Catalogs are templates from a git repository that can be used to create environments.')
param catalogs catalogType[]?

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res-devcenter-project.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource project 'Microsoft.DevCenter/projects@2025-02-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    description: description
    devCenterId: devCenterResourceId
    displayName: displayName
    catalogSettings: catalogSettings
    maxDevBoxesPerUser: maxDevBoxesPerUser
  }
}

module project_environmentType 'environment-type/main.bicep' = [
  for (environmentType, index) in (environmentTypes ?? []): {
    name: '${uniqueString(deployment().name, location)}-Project-EnvironmentTypes-${index}'
    params: {
      creatorRoleAssignmentRoles: environmentType.creatorRoleAssignmentRoles
      deploymentTargetSubscriptionResourceId: environmentType.deploymentTargetSubscriptionResourceId
      managedIdentities: environmentType.?managedIdentities
      name: environmentType.name
      projectName: project.name
      roleAssignments: environmentType.?roleAssignments
      status: environmentType.?status
      tags: environmentType.?tags
      userRoleAssignmentsRoles: environmentType.?userRoleAssignmentsRoles
      displayName: environmentType.?displayName
    }
  }
]

module project_catalog 'catalog/main.bicep' = [
  for (catalog, index) in (catalogs ?? []): {
    name: '${uniqueString(deployment().name, location)}-Project-Catalog-${index}'
    params: {
      name: catalog.name
      projectName: project.name
      gitHub: catalog.?gitHub
      adoGit: catalog.?adoGit
      syncType: catalog.?syncType
      tags: catalog.?tags
      location: location
    }
  }
]

module project_pool 'pool/main.bicep' = [
  for (pool, index) in (pools ?? []): {
    name: '${uniqueString(deployment().name, location)}-Project-Pool-${index}'
    params: {
      name: pool.name
      projectName: project.name
      displayName: pool.?displayName
      devBoxDefinitionType: pool.?devBoxDefinitionType
      devBoxDefinition: pool.?devBoxDefinition
      devBoxDefinitionName: pool.?devBoxDefinitionName
      location: pool.?location ?? location
      tags: pool.?tags
      localAdministrator: pool.localAdministrator
      virtualNetworkType: pool.virtualNetworkType
      managedVirtualNetworkRegion: pool.?managedVirtualNetworkRegion
      networkConnectionName: pool.?networkConnectionName
      singleSignOnStatus: pool.?singleSignOnStatus
      stopOnDisconnect: pool.?stopOnDisconnect
      stopOnNoConnect: pool.?stopOnNoConnect
      schedule: pool.?schedule
    }
    dependsOn: [
      project_catalog
    ]
  }
]

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
    name: roleAssignment.?name ?? guid(project.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: project
  }
]

// ============ //
// Outputs      //
// ============ //

@sys.description('The name of the Dev Center Project.')
output name string = project.name

@sys.description('The resource ID of the Dev Center Project.')
output resourceId string = project.id

@sys.description('The name of the resource group the Dev Center Project resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the Dev Center Project resource was deployed into.')
output location string = project.location

@sys.description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = project.?identity.?principalId

// ================ //
// Definitions      //
// ================ //

@export()
@sys.description('Settings to be used when associating a project with a catalog.')
type catalogSettingsType = {
  @sys.description('Optional. Indicates catalog item types that can be synced.')
  catalogItemSyncTypes: ('EnvironmentDefinition' | 'ImageDefinition')[]?
}

import { userRoleAssignmentsRolesType } from 'environment-type/main.bicep'
@export()
@sys.description('The type for the environment type.')
type environmentTypeType = {
  @sys.description('Required. An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified.')
  creatorRoleAssignmentRoles: string[]

  @sys.description('Optional. The display name of the environment type.')
  displayName: string?

  @sys.description('Required. The subscription Resource ID where the environment type will be mapped to. The environment\'s resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}".')
  deploymentTargetSubscriptionResourceId: string

  @sys.description('Optional. The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity.')
  managedIdentities: managedIdentityAllType?

  @sys.description('Required. The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.')
  name: string

  @sys.description('Optional. Defines whether this Environment Type can be used in this Project. The default is "Enabled".')
  status: 'Enabled' | 'Disabled'?

  @sys.description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @sys.description('Optional. Resource tags to apply to the environment type.')
  tags: resourceInput<'Microsoft.DevCenter/projects/environmentTypes@2025-02-01'>.tags?

  @sys.description('Optional. A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions.')
  userRoleAssignmentsRoles: userRoleAssignmentsRolesType[]?
}

import { stopOnDisconnectType, stopOnNoConnectType, devBoxDefinitionTypeType, poolScheduleType } from 'pool/main.bicep'
@sys.description('The type for a Dev Center Project Pool.')
type poolType = {
  @sys.description('Required. The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes.')
  name: string

  @sys.description('Optional. The display name of the pool.')
  displayName: string?

  @sys.description('Optional. Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly. Defaults to "Reference".')
  devBoxDefinitionType: 'Reference' | 'Value'?

  @sys.description('Required. Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\\~Catalog\\~{catalogName}\\~{imagedefinition YAML name}" (e.g. "\\~Catalog\\~eshopRepo\\~frontend-dev").')
  devBoxDefinitionName: string

  @sys.description('Conditional. A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value".')
  devBoxDefinition: devBoxDefinitionTypeType?

  @sys.description('Optional. Resource tags to apply to the pool.')
  tags: resourceInput<'Microsoft.DevCenter/projects/pools@2025-02-01'>.tags?

  @sys.description('Required. Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box.')
  localAdministrator: 'Enabled' | 'Disabled'

  @sys.description('Required. Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource.')
  virtualNetworkType: 'Managed' | 'Unmanaged'

  @sys.description('Conditional. The region of the managed virtual network. Required if virtualNetworkType is "Managed".')
  managedVirtualNetworkRegion: string?

  @sys.description('Conditional. Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed".')
  networkConnectionName: string?

  @sys.description('Optional. Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes.')
  singleSignOnStatus: 'Enabled' | 'Disabled'?

  @sys.description('Optional. Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects.')
  stopOnDisconnect: stopOnDisconnectType?

  @sys.description('Optional. Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects.')
  stopOnNoConnect: stopOnNoConnectType?

  @sys.description('Optional. The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration.')
  schedule: poolScheduleType?
}

import { sourceType } from 'catalog/main.bicep'
@export()
@sys.description('The type for a Dev Center Project Catalog.')
type catalogType = {
  @sys.description('Required. The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods.')
  name: string

  @sys.description('Optional. GitHub repository configuration for the catalog.')
  gitHub: sourceType?

  @sys.description('Optional. Azure DevOps Git repository configuration for the catalog.')
  adoGit: sourceType?

  @sys.description('Optional. Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled".')
  syncType: ('Manual' | 'Scheduled')?

  @sys.description('Optional. Resource tags to apply to the catalog.')
  tags: resourceInput<'Microsoft.DevCenter/projects/catalogs@2025-02-01'>.tags?
}
