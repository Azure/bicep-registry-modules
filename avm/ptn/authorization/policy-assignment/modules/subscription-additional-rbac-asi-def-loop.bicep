targetScope = 'managementGroup'

@sys.description('Optional. An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.')
param subscriptionIDsToAssignRbacTo array = []

@sys.description('Required. The ID Of the Azure Role Definition that is used to assign permissions to the identity. You need to provide the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
param roleDefinitionId string

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

@sys.description('Required. Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope.')
@maxLength(24)
param name string

@sys.description('Required. The managed identity principal ID associated with the policy assignment.')
param policyAssignmentIdentityId string

module additionalSubscriptionRoleAssignmentsPerSub 'subscription-additional-rbac-asi.bicep' = [
  for sub in subscriptionIDsToAssignRbacTo: {
    name: '${uniqueString(deployment().name, location, roleDefinitionId, name)}-PolicyAssignment-MG-Module-RBAC-Sub-${substring(sub, 0, 8)}'
    scope: subscription(sub)
    params: {
      name: name
      policyAssignmentIdentityId: policyAssignmentIdentityId
      roleDefinitionId: roleDefinitionId
    }
  }
]
