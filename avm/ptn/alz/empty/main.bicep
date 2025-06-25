metadata name = 'avm/ptn/alz/empty'
metadata description = '''
Azure Landing Zones - Bicep - Empty

Please review the [Usage examples](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/alz/empty#Usage-examples) section in the module's README, but please ensure for the `max` example you review the entire [directory](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/alz/empty/tests/e2e/max) to see the supplementary files that are required for the example.

Also please ensure you review the [Notes section of the module's README](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/alz/empty#Notes) for important information about the module as well as features that exist outside of parameter inputs.'''

targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. An integer that specifies the number of blank ARM deployments prior to the custom role definitions are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.')
param waitForConsistencyCounterBeforeCustomRoleDefinitions int = 5

@description('Optional. An integer that specifies the number of blank ARM deployments prior to the role assignments are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.')
param waitForConsistencyCounterBeforeRoleAssignments int = 5

@description('Optional. An integer that specifies the number of blank ARM deployments prior to the custom policy definitions are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.')
param waitForConsistencyCounterBeforeCustomPolicyDefinitions int = 5

@description('Optional. An integer that specifies the number of blank ARM deployments prior to the custom policy set definitions (initiatives) are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.')
param waitForConsistencyCounterBeforeCustomPolicySetDefinitions int = 5

@description('Optional. An integer that specifies the number of blank ARM deployments prior to the policy assignments are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.')
param waitForConsistencyCounterBeforePolicyAssignments int = 10

@description('Optional. An integer that specifies the number of blank ARM deployments prior to the subscription management group associations are deployed. This electively introduces a wait timer to allow ARM eventual consistency to become consistent and helps avoids "Not Found" error messages.')
param waitForConsistencyCounterBeforeSubPlacement int = 5

@description('Optional. Boolean to create or update the management group. If set to false, the module will only check if the management group exists and do a GET on it before it continues to deploy resources to it.')
param createOrUpdateManagementGroup bool = true

@description('Required. The name of the management group to create or update.')
param managementGroupName string

@description('Optional. The display name of the management group to create or update. If not specified, the management group name will be used.')
param managementGroupDisplayName string?

@description('Optional. The parent ID of the management group to create or update. If not specified, the management group will be created at the root level of the tenant. Just provide the management group ID, not the full resource ID.')
param managementGroupParentId string?

@description('Optional. An array of subscriptions to place in the management group. If not specified, no subscriptions will be placed in the management group.')
param subscriptionsToPlaceInManagementGroup array = []

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of custom role assignments to create on the management group.')
param managementGroupRoleAssignments roleAssignmentType[]?

@description('Optional. Array of custom role definitions to create on the management group.')
param managementGroupCustomRoleDefinitions roleDefinitionType[]?

import { policyDefinitionType } from 'modules/policy-definitions.bicep'
@description('Optional. Array of custom policy definitions to create on the management group.')
param managementGroupCustomPolicyDefinitions policyDefinitionType[]?

import { policySetDefinitionsType } from 'modules/policy-set-definitions.bicep'
@description('Optional. Array of custom policy set definitions (initiatives) to create on the management group.')
param managementGroupCustomPolicySetDefinitions policySetDefinitionsType[]?

@description('Optional. Array of policy assignments to create on the management group.')
param managementGroupPolicyAssignments policyAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  'Billing Reader': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fa23ad8b-c56e-40d8-ac0c-ce449e1d2c64'
  )
  Contributor: managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b24988ac-6180-42a0-ab88-20f7382dd24c'
  )
  'Cost Management Reader': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '72fafb9e-0641-4937-9268-a91bfd8191a3'
  )
  'Cost Management Contributor': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '434105ed-43f6-45c7-a02f-909b2ba83430'
  )
  'Hierarchy Settings Administrator': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '350f8d15-c687-4448-8ae1-157740a3936d'
  )
  'Management Group Contributor': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5d58bcaf-24a5-4b20-bdb6-eed9f69fbe4c'
  )
  'Management Group Reader': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ac63b705-f282-497d-ac71-919bf39d939d'
  )
  Owner: managementGroupResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Quota Request Operator': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0e5f05e5-9ab9-446b-b98d-1e2157c94125'
  )
  Reader: managementGroupResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'Security Admin': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  )
  'Security Reader': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '39bc4728-0917-49c7-9d2c-d95423bc2eb4'
  )
  'Support Request Contributor': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'cfd33db0-3dd1-45e3-aa9d-cdbdf3b6f24e'
  )
  'User Access Administrator': managementGroupResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (managementGroupRoleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : managementGroupResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

var deploymentNames = {
  mg: '${uniqueString(deployment().name, location)}-alz-mg-${managementGroupName}'
  mgSubPlacement: '${uniqueString(deployment().name, location)}-alz-sub-place-${managementGroupName}'
  mgSubPlacementWait: '${uniqueString(deployment().name, location)}-alz-sub-place-wait-${managementGroupName}'
  mgRoleAssignments: '${uniqueString(deployment().name, location)}-alz-mg-rbac-asi-${managementGroupName}'
  mgRoleDefinitions: '${uniqueString(deployment().name, location)}-alz-mg-rbac-def-${managementGroupName}'
  mgRoleDefinitionsWait: '${uniqueString(deployment().name, location)}-alz-rbac-def-wait-${managementGroupName}'
  mgRoleAssignmentsWait: '${uniqueString(deployment().name, location)}-alz-rbac-asi-wait-${managementGroupName}'
  mgCustomPolicyDefinitionsWait: '${uniqueString(deployment().name, location)}-alz-pol-def-wait-${managementGroupName}'
  mgCustomPolicySetDefinitionsWait: '${uniqueString(deployment().name, location)}-alz-pol-init-wait-${managementGroupName}'
  mgPolicyDefinitions: '${uniqueString(deployment().name, location)}-alz-mg-pol-def-${managementGroupName}'
  mgPolicySetDefinitions: '${uniqueString(deployment().name, location)}-alz-mg-pol-init-${managementGroupName}'
  mgPolicyAssignments: '${uniqueString(deployment().name, location)}-alz-mg-pol-asi-${managementGroupName}'
  mgPolicyAssignmentsWait: '${uniqueString(deployment().name, location)}-alz-pol-asi-wait${managementGroupName}'
}

// Modules
// Telemetry
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.alz-empty.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

// Single Management Group Creation (Optional)
module mg 'br/public:avm/res/management/management-group:0.1.2' = if (createOrUpdateManagementGroup) {
  name: deploymentNames.mg
  params: {
    name: managementGroupName
    displayName: managementGroupDisplayName ?? managementGroupName
    parentId: managementGroupParentId ?? tenant().tenantId
    enableTelemetry: enableTelemetry
  }
}

// If createOrUpdateManagementGroup is false, then the management group already exists and we need to check the management group exists and do a GET on it
resource mgExisting 'Microsoft.Management/managementGroups@2023-04-01' existing = if (!createOrUpdateManagementGroup) {
  scope: tenant()
  name: managementGroupName
}

// N x Subscription Placement in Management Group Created or Existing (Optional)
@batchSize(1)
module mgSubPlacementWait 'modules/wait.bicep' = [
  for (item, index) in range(0, waitForConsistencyCounterBeforeSubPlacement): if (waitForConsistencyCounterBeforeSubPlacement > 0 && !empty(subscriptionsToPlaceInManagementGroup)) {
    name: '${deploymentNames.mgSubPlacementWait}-${index}'
  }
]

resource mgSubPlacement 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [
  for (sub, i) in subscriptionsToPlaceInManagementGroup: {
    scope: tenant()
    name: createOrUpdateManagementGroup ? '${managementGroupName}/${sub}' : '${mgExisting.name}/${sub}'
    dependsOn: [
      mg
    ]
  }
]

// Custom Policy Definitions Created on Management Group (Optional)
@batchSize(1)
module mgCustomPolicyDefinitionsWait 'modules/wait.bicep' = [
  for (item, index) in range(0, waitForConsistencyCounterBeforeCustomPolicyDefinitions): if (waitForConsistencyCounterBeforeCustomPolicyDefinitions > 0 && !(empty(managementGroupCustomPolicyDefinitions))) {
    name: '${deploymentNames.mgCustomPolicyDefinitionsWait}-${index}'
  }
]

module mgCustomPolicyDefinitions 'modules/policy-definitions.bicep' = if (!empty(managementGroupCustomPolicyDefinitions)) {
  scope: managementGroup(managementGroupName)
  name: deploymentNames.mgPolicyDefinitions
  params: {
    managementGroupCustomPolicyDefinitions: managementGroupCustomPolicyDefinitions
  }
  dependsOn: [
    mgCustomPolicyDefinitionsWait
  ]
}

// Custom Policy Set Definitions/Initiatives Created on Management Group (Optional)
@batchSize(1)
module mgCustomPolicySetDefinitionsWait 'modules/wait.bicep' = [
  for (item, index) in range(0, waitForConsistencyCounterBeforeCustomPolicySetDefinitions): if (waitForConsistencyCounterBeforeCustomPolicySetDefinitions > 0 && !empty(managementGroupCustomPolicySetDefinitions)) {
    name: '${deploymentNames.mgCustomPolicySetDefinitionsWait}-${index}'
  }
]

module mgCustomPolicySetDefinitions 'modules/policy-set-definitions.bicep' = if (!empty(managementGroupCustomPolicySetDefinitions)) {
  scope: managementGroup(managementGroupName)
  dependsOn: [
    mgCustomPolicyDefinitions
    mgCustomPolicySetDefinitionsWait
  ]
  name: deploymentNames.mgPolicySetDefinitions
  params: {
    managementGroupCustomPolicySetDefinitions: managementGroupCustomPolicySetDefinitions
  }
}

// Policy Assignments Created on Management Group (Optional)
@batchSize(1)
module mgPolicyAssignmentsWait 'modules/wait.bicep' = [
  for (item, index) in range(0, waitForConsistencyCounterBeforePolicyAssignments): if (waitForConsistencyCounterBeforePolicyAssignments > 0 && !empty(managementGroupPolicyAssignments)) {
    name: '${deploymentNames.mgPolicyAssignmentsWait}-${index}'
  }
]

module mgPolicyAssignments 'br/public:avm/ptn/authorization/policy-assignment:0.4.0' = [
  for (polAsi, index) in (managementGroupPolicyAssignments ?? []): {
    scope: managementGroup(managementGroupName)
    dependsOn: [
      mgCustomPolicyDefinitions
      mgCustomPolicySetDefinitions
      mgPolicyAssignmentsWait
    ]
    name: take('${deploymentNames.mgPolicyAssignments}-${uniqueString(managementGroupName, polAsi.name)}', 64)
    params: {
      name: polAsi.name
      policyDefinitionId: polAsi.policyDefinitionId
      location: polAsi.?location ?? location
      description: polAsi.?description
      displayName: polAsi.?displayName
      enforcementMode: polAsi.?enforcementMode ?? 'Default'
      identity: polAsi.?identity ?? 'None'
      userAssignedIdentityId: polAsi.?userAssignedIdentityId
      roleDefinitionIds: polAsi.?roleDefinitionIds
      parameters: polAsi.?parameters
      managementGroupId: createOrUpdateManagementGroup ? mg.outputs.name : mgExisting.name
      nonComplianceMessages: polAsi.?nonComplianceMessages
      metadata: polAsi.?metadata
      overrides: polAsi.?overrides
      resourceSelectors: polAsi.?resourceSelectors
      definitionVersion: polAsi.?definitionVersion
      notScopes: polAsi.?notScopes
      additionalManagementGroupsIDsToAssignRbacTo: polAsi.?additionalManagementGroupsIDsToAssignRbacTo
      additionalSubscriptionIDsToAssignRbacTo: polAsi.?additionalSubscriptionIDsToAssignRbacTo
      additionalResourceGroupResourceIDsToAssignRbacTo: polAsi.?additionalResourceGroupResourceIDsToAssignRbacTo
      enableTelemetry: enableTelemetry
    }
  }
]

// Custom Role Definitions Created on Management Group (Optional)
@batchSize(1)
module mgRoleDefinitionsWait 'modules/wait.bicep' = [
  for (item, index) in range(0, waitForConsistencyCounterBeforeCustomRoleDefinitions): if (waitForConsistencyCounterBeforeCustomRoleDefinitions > 0 && !empty(managementGroupCustomRoleDefinitions)) {
    name: '${deploymentNames.mgRoleDefinitionsWait}-${index}'
  }
]

module mgRoleDefinitions 'br/public:avm/ptn/authorization/role-definition:0.1.1' = [
  for (roleDef, index) in (managementGroupCustomRoleDefinitions ?? []): {
    scope: managementGroup(managementGroupName)
    name: take('${deploymentNames.mgRoleDefinitions}-${uniqueString(managementGroupName, roleDef.name)}', 64)
    params: {
      name: roleDef.name
      roleName: roleDef.?roleName
      description: roleDef.?description ?? ''
      assignableScopes: roleDef.?assignableScopes
      actions: roleDef.?actions
      notActions: roleDef.?notActions
      dataActions: roleDef.?dataActions
      notDataActions: roleDef.?notDataActions
      location: location
      enableTelemetry: enableTelemetry
    }
    dependsOn: [
      mgRoleDefinitionsWait
    ]
  }
]

// Role Assignments Created on Management Group (Optional)
@batchSize(1)
module mgRoleAssignmentsWait 'modules/wait.bicep' = [
  for (item, index) in range(0, waitForConsistencyCounterBeforeRoleAssignments): if (waitForConsistencyCounterBeforeRoleAssignments > 0 && !empty(formattedRoleAssignments)) {
    name: '${deploymentNames.mgRoleAssignmentsWait}-${index}'
  }
]

module mgRoleAssignments 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: take(
      '${deploymentNames.mgRoleAssignments}-${uniqueString(managementGroupName, roleAssignment.principalId, roleAssignment.roleDefinitionId)}',
      64
    )
    params: {
      managementGroupId: createOrUpdateManagementGroup ? mg.outputs.name : mgExisting.name
      principalId: roleAssignment.principalId
      roleDefinitionIdOrName: roleAssignment.roleDefinitionId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
      enableTelemetry: enableTelemetry
    }
    dependsOn: [
      mgRoleDefinitions
      mgRoleAssignmentsWait
    ]
  }
]

// Outputs
@description('The resource ID of the management group.')
output managementGroupResourceId string = createOrUpdateManagementGroup ? mg.outputs.resourceId : mgExisting.id

@description('The ID of the management group.')
output managementGroupId string = createOrUpdateManagementGroup ? mg.outputs.name : mgExisting.name

@description('The parent management group ID of the management group.')
output managementGroupParentId string = createOrUpdateManagementGroup
  ? (managementGroupParentId ?? tenant().tenantId)
  : mgExisting.properties.details.parent.id // Only doing this as think i've found a bug in Bicep/ARM, see: https://github.com/Azure/bicep/issues/15642

@description('The custom role definitions created on the management group.')
output managementGroupCustomRoleDefinitionIds array = [
  for (roleDef, index) in (managementGroupCustomRoleDefinitions ?? []): {
    resourceId: mgRoleDefinitions[index].outputs.managementGroupCustomRoleDefinitionIds.resourceId
    roleDefinitionId: mgRoleDefinitions[index].outputs.managementGroupCustomRoleDefinitionIds.roleDefinitionIdName
    displayName: mgRoleDefinitions[index].outputs.managementGroupCustomRoleDefinitionIds.displayName
  }
]

// Types

@export()
@description('A type for policy assignments.')
type policyAssignmentType = {
  @maxLength(24)
  @description('Required. Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope.')
  name: string

  @description('Optional. The display name of the policy assignment. Maximum length is 128 characters.')
  displayName: string?

  @description('Optional. The description of the policy assignment.')
  description: string?

  @description('Required. Specifies the Resource ID of the policy definition or policy set definition being assigned. Example `/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3` or `/providers/Microsoft.Management/managementGroups/<management-group-name>/providers/Microsoft.Authorization/policyDefinitions/<policy-definition/set-name`.')
  policyDefinitionId: string

  @description('Optional. Parameters for the policy assignment if needed.')
  parameters: resourceInput<'Microsoft.Authorization/policyAssignments@2022-06-01'>.properties.parameters?

  @description('Required. The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning `Modify` or `DeployIfNotExists` policy definitions.')
  identity: 'SystemAssigned' | 'UserAssigned' | 'None'

  @description('Optional. The Resource ID for the user assigned identity to assign to the policy assignment.')
  userAssignedIdentityId: string?

  @description('Optional. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
  roleDefinitionIds: string[]?

  @description('Optional. The messages that describe why a resource is non-compliant with the policy.')
  nonComplianceMessages: {
    @description('Required. A message that describes why a resource is non-compliant with the policy. This is shown in "deny" error messages and on resources non-compliant compliance results.')
    message: string

    @description('Optional. The policy definition reference ID within a policy set definition the message is intended for. This is only applicable if the policy assignment assigns a policy set definition. If this is not provided the message applies to all policies assigned by this policy assignment.')
    policyDefinitionReferenceId: string?
  }[]?

  @description('Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
  metadata: object?

  @description('Required. The policy assignment enforcement mode. Possible values are `Default` and `DoNotEnforce`. Recommended value is `Default`.')
  enforcementMode: 'Default' | 'DoNotEnforce'

  @description('Optional. The policy excluded scopes.')
  notScopes: string[]?

  @description('Optional. The location of the policy assignment. Only required when utilizing managed identity, as sets location of system assigned managed identity, if created.')
  location: string?

  @description('Optional. The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.')
  overrides: {
    @description('Required. The override kind.')
    kind: 'definitionVersion' | 'policyEffect'

    @description('Optional. The selector type.')
    selectors: policyAssignmentSelectorType[]?

    @description('Optional. The value to override the policy property.')
    value: string?
  }[]?

  @description('Optional. The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.')
  resourceSelectors: policyAssignmentSelectorType[]?

  @description('Optional. The policy definition version to use for the policy assignment. If not specified, the latest version of the policy definition will be used. For more information on policy assignment definition versions see https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version-preview.')
  definitionVersion: string?

  @description('Optional. An array of additional management group IDs to assign RBAC to for the policy assignment if it has an identity.')
  additionalManagementGroupsIDsToAssignRbacTo: string[]?

  @description('Optional. An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.')
  additionalSubscriptionIDsToAssignRbacTo: string[]?

  @description('Optional. An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.')
  additionalResourceGroupResourceIDsToAssignRbacTo: string[]?
}

type policyAssignmentSelectorType = {
  @description('Optional. The list of values to filter in.')
  in: string[]?

  @description('Optional. The list of values to filter out.')
  notIn: string[]?

  @description('Required. The selector kind.')
  kind: 'policyDefinitionReferenceId' | 'resourceLocation' | 'resourceType' | 'resourceWithoutLocation'
}

@export()
@description('A type for custom role definition.')
type roleDefinitionType = {
  @description('Required. The name of the custom role definition.')
  name: string

  @description('Optional. The description of the custom role definition.')
  description: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.description?

  @description('Optional. The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used.')
  assignableScopes: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.assignableScopes?

  @description('Optional. The display name of the custom role definition. If not specified, the name will be used.')
  roleName: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.roleName?

  @description('Optional. The permission actions of the custom role definition.')
  actions: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.permissions[*].actions?

  @description('Optional. The permission not actions of the custom role definition.')
  notActions: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.permissions[*].notActions?

  @description('Optional. The permission data actions of the custom role definition.')
  dataActions: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.permissions[*].dataActions?

  @description('Optional. The permission not data actions of the custom role definition.')
  notDataActions: resourceInput<'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'>.properties.permissions[*].notDataActions?
}
