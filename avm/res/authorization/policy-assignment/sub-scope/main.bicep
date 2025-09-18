metadata name = 'Policy Assignments (Subscription scope)'
metadata description = 'This module deploys a Policy Assignment at a Subscription scope. Optionally, it further assigns permissions to the policy\'s identity (if configured) to various scopes. Note, if you provide any role definition ids and or define additional scopes to assign permissions to, set permissions are deployled as a permutation of the provided parameters. In other words, each role would be provided to each scope for the assignment\'s identity.'

targetScope = 'subscription'

@sys.description('Required. Specifies the name of the policy assignment. Maximum length is 64 characters for subscription scope.')
@maxLength(64)
param name string

@sys.description('Optional. This message will be part of response in case of policy violation.')
param description string?

@sys.description('Optional. The display name of the policy assignment. Maximum length is 128 characters.')
@maxLength(128)
param displayName string?

@sys.description('Required. Specifies the ID of the policy definition or policy set definition being assigned.')
param policyDefinitionId string

@sys.description('Optional. Parameters for the policy assignment if needed.')
param parameters resourceInput<'Microsoft.Authorization/policyAssignments@2025-03-01'>.properties.parameters?

@sys.description('Optional. The IDs Of the Azure Role Definition that are used to assign permissions to the policy\'s identity. You need to provide the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
param roleDefinitionIds string[]?

@sys.description('Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object?

@sys.description('Optional. The messages that describe why a resource is non-compliant with the policy.')
param nonComplianceMessages resourceInput<'Microsoft.Authorization/policyAssignments@2025-03-01'>.properties.nonComplianceMessages?

@sys.description('Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce.')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@sys.description('Optional. The policy excluded scopes.')
param notScopes resourceInput<'Microsoft.Authorization/policyAssignments@2025-03-01'>.properties.notScopes?

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

@sys.description('Optional. The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.')
param overrides resourceInput<'Microsoft.Authorization/policyAssignments@2025-03-01'>.properties.overrides?

@sys.description('Optional. The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.')
param resourceSelectors resourceInput<'Microsoft.Authorization/policyAssignments@2025-03-01'>.properties.resourceSelectors?

@sys.description('Optional. The policy definition version to use for the policy assignment. If not specified, the latest version of the policy definition will be used. For more information on policy assignment definition versions see https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version-preview.')
param definitionVersion string?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity.')
param additionalSubscriptionIDsToAssignRbacTo string[]?

@sys.description('Optional. An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity.')
param additionalResourceGroupResourceIDsToAssignRbacTo string[]?

@sys.description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityType = {
  systemAssigned: true
}

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourceId) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(managedIdentities.?userAssignedResourceId)
        ? { '${managedIdentities!.userAssignedResourceId!}': {} }
        : null
    }
  : null

// Reference to existing managed identity if user assigned
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(managedIdentities.?userAssignedResourceId)) {
  name: last(split((managedIdentities.?userAssignedResourceId!), '/'))
  scope: resourceGroup(
    split(managedIdentities.?userAssignedResourceId!, '/')[2],
    split(managedIdentities.?userAssignedResourceId!, '/')[4]
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.authz-policyassignment_subscope.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  location: location
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2025-03-01' = {
  name: name
  location: location
  properties: {
    displayName: displayName
    metadata: metadata
    description: description
    policyDefinitionId: policyDefinitionId
    parameters: parameters
    nonComplianceMessages: nonComplianceMessages
    enforcementMode: enforcementMode
    notScopes: notScopes
    overrides: overrides
    resourceSelectors: resourceSelectors
    definitionVersion: definitionVersion
  }
  identity: identity
}

// RBAC: Subscription-Scope
// ========================
// Create all permutations of subscription scopes & role definition Ids
var expandedSubRoleAssignments = reduce(
  union(additionalSubscriptionIDsToAssignRbacTo ?? [], [subscription().subscriptionId]),
  [],
  (currSubscriptionId, nextSubscriptionId) =>
    concat(
      currSubscriptionId,
      map(roleDefinitionIds ?? [], roleDefinitionId => {
        subscriptionId: nextSubscriptionId
        roleDefinitionId: roleDefinitionId
      })
    )
)
// Deploy permutations
module additionalSubscriptionRoleAssignments 'modules/sub-scope-rbac.bicep' = [
  for assignment in (expandedSubRoleAssignments ?? []): if (!empty(managedIdentities)) {
    scope: subscription(assignment.subscriptionId)
    name: '${uniqueString(deployment().name, location, assignment.roleDefinitionId, name)}-PolicyAssignment-MG-Module-Additional-RBAC-Subs'
    params: {
      name: name
      principalId: policyAssignment.identity.?principalId ?? userAssignedIdentity.?properties.principalId
      roleDefinitionId: assignment.roleDefinitionId
    }
  }
]

// RBAC: Resource-Group-Scope
// ==========================
// Create all permutations of resource-group scopes & role definition Ids
var expandedRgRoleAssignments = reduce(
  additionalResourceGroupResourceIDsToAssignRbacTo ?? [],
  [],
  (currResourceGroupId, nextResourceGroupId) =>
    concat(
      currResourceGroupId,
      map(roleDefinitionIds ?? [], roleDefinitionId => {
        resourceGroupId: nextResourceGroupId
        roleDefinitionId: roleDefinitionId
      })
    )
)
// Deploy permutations
module additionalResourceGroupResourceIDsRoleAssignmentsPerSub 'modules/rg-scope-rbac.bicep' = [
  for assignment in expandedRgRoleAssignments: if (!empty(managedIdentities)) {
    name: '${uniqueString(deployment().name, location, assignment.roleDefinitionId, name, assignment.resourceGroupId)}-PolicyAssignment-MG-Module-RBAC-RG-Sub-${substring(split(assignment.resourceGroupId, '/')[2], 0, 8)}'
    scope: resourceGroup(split(assignment.resourceGroupId, '/')[2], split(assignment.resourceGroupId, '/')[4])
    params: {
      name: name
      principalId: policyAssignment.identity.?principalId ?? userAssignedIdentity.?properties.principalId
      roleDefinitionId: assignment.roleDefinitionId
    }
  }
]

@sys.description('Policy Assignment Name.')
output name string = policyAssignment.name

@sys.description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = policyAssignment.?identity.?principalId

@sys.description('Policy Assignment resource ID.')
output resourceId string = policyAssignment.id

@sys.description('The location the resource was deployed into.')
output location string = policyAssignment.location

// =============== //
//   Definitions   //
// =============== //

@export()
@sys.description('An AVM-aligned type for a managed identity configuration.')
type managedIdentityType = {
  @sys.description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @sys.description('Optional. The resource ID of the user-assigned identity to assign to the resource..')
  userAssignedResourceId: string?
}
