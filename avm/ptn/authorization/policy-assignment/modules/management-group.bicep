metadata name = 'Policy Assignments (Management Group scope)'
metadata description = 'This module deploys a Policy Assignment at a Management Group scope.'

targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope.')
@maxLength(24)
param name string

@sys.description('Optional. This message will be part of response in case of policy violation.')
param description string = ''

@sys.description('Optional. The display name of the policy assignment. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Required. Specifies the ID of the policy definition or policy set definition being assigned.')
param policyDefinitionId string

@sys.description('Optional. Parameters for the policy assignment if needed.')
param parameters object = {}

@sys.description('Optional. The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning \'Modify\' policy definitions.')
@allowed([
  'SystemAssigned'
  'UserAssigned'
  'None'
])
param identity string = 'SystemAssigned'

@sys.description('Optional. The Resource ID for the user assigned identity to assign to the policy assignment.')
param userAssignedIdentityId string = ''

@sys.description('Optional. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
param roleDefinitionIds array = []

@sys.description('Optional. An array of additional management group IDs to assign RBAC to for the policy assignment if it has an identity.')
param additionalManagementGroupsIDsToAssignRbacTo array = []

@sys.description('Optional. An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.')
param additionalSubscriptionIDsToAssignRbacTo array = []

@sys.description('Optional. An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.')
param additionalResourceGroupResourceIDsToAssignRbacTo array = []

@sys.description('Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The messages that describe why a resource is non-compliant with the policy.')
param nonComplianceMessages array = []

@sys.description('Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce.')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@sys.description('Optional. The policy excluded scopes.')
param notScopes array = []

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

@sys.description('Optional. The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.')
param overrides array = []

@sys.description('Optional. The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.')
param resourceSelectors array = []

var identityVar = identity == 'SystemAssigned'
  ? {
      type: identity
    }
  : identity == 'UserAssigned'
      ? {
          type: identity
          userAssignedIdentities: {
            '${userAssignedIdentityId}': {}
          }
        }
      : null

var finalArrayOfManagementGroupsToAssignRbacTo = identity == 'SystemAssigned'
  ? union(additionalManagementGroupsIDsToAssignRbacTo, [managementGroup().name])
  : []

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: name
  location: location
  properties: {
    displayName: !empty(displayName) ? displayName : null
    metadata: !empty(metadata) ? metadata : null
    description: !empty(description) ? description : null
    policyDefinitionId: policyDefinitionId
    parameters: parameters
    nonComplianceMessages: !empty(nonComplianceMessages) ? nonComplianceMessages : []
    enforcementMode: enforcementMode
    notScopes: !empty(notScopes) ? notScopes : []
    overrides: !empty(overrides) ? overrides : []
    resourceSelectors: !empty(resourceSelectors) ? resourceSelectors : []
  }
  identity: identityVar
}

module managementGroupRoleAssignments 'management-group-additional-rbac-asi-def-loop.bicep' = [
  for roleDefinitionId in roleDefinitionIds: if (!empty(roleDefinitionIds) && !empty(additionalManagementGroupsIDsToAssignRbacTo) && identity == 'SystemAssigned') {
    name: '${uniqueString(deployment().name, location, roleDefinitionId, name)}-PolicyAssignment-MG-Module-Additional-RBAC'
    params: {
      name: name
      policyAssignmentIdentityId: policyAssignment.identity.principalId
      roleDefinitionId: roleDefinitionId
      managementGroupsIDsToAssignRbacTo: finalArrayOfManagementGroupsToAssignRbacTo
    }
  }
]

module additionalSubscriptionRoleAssignments 'subscription-additional-rbac-asi-def-loop.bicep' = [
  for roleDefinitionId in roleDefinitionIds: if (!empty(roleDefinitionIds) && !empty(additionalSubscriptionIDsToAssignRbacTo) && identity == 'SystemAssigned') {
    name: '${uniqueString(deployment().name, location, roleDefinitionId, name)}-PolicyAssignment-MG-Module-Additional-RBAC-Subs'
    params: {
      name: name
      policyAssignmentIdentityId: policyAssignment.identity.principalId
      roleDefinitionId: roleDefinitionId
      subscriptionIDsToAssignRbacTo: additionalSubscriptionIDsToAssignRbacTo
    }
  }
]

module additionalResourceGroupRoleAssignments 'resource-group-additional-rbac-asi-def-loop.bicep' = [
  for roleDefinitionId in roleDefinitionIds: if (!empty(roleDefinitionIds) && !empty(additionalResourceGroupResourceIDsToAssignRbacTo) && identity == 'SystemAssigned') {
    name: '${uniqueString(deployment().name, location, roleDefinitionId, name)}-PolicyAssignment-MG-Module-Additional-RBAC-RGs'
    params: {
      name: name
      policyAssignmentIdentityId: policyAssignment.identity.principalId
      roleDefinitionId: roleDefinitionId
      resourceGroupResourceIDsToAssignRbacTo: additionalResourceGroupResourceIDsToAssignRbacTo
    }
  }
]

@sys.description('Policy Assignment Name.')
output name string = policyAssignment.name

@sys.description('Policy Assignment principal ID.')
output principalId string = policyAssignment.?identity.?principalId ?? ''

@sys.description('Policy Assignment resource ID.')
output resourceId string = policyAssignment.id

@sys.description('The location the resource was deployed into.')
output location string = policyAssignment.location
