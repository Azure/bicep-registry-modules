targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope.')
@maxLength(24)
param name string

@description('Optional. An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity, only supported for Management Group Policy Assignments.')
param resourceGroupResourceIDsToAssignRbacTo array = []

@description('Required. The ID Of the Azure Role Definition that is used to assign permissions to the identity. You need to provide the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.')
param roleDefinitionId string

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Required. The managed identity principal ID associated with the policy assignment.')
param policyAssignmentIdentityId string

module additionalResourceGroupResourceIDsRoleAssignmentsPerSub 'rg-rbac-outerLoop-defs-innerLoop-rgIds.bicep' = [
  for rg in resourceGroupResourceIDsToAssignRbacTo: {
    name: '${uniqueString(deployment().name, location, roleDefinitionId, name, rg)}-PolicyAssignment-MG-Module-RBAC-RG-Sub-${substring(split(rg, '/')[2], 0, 8)}'
    scope: resourceGroup(split(rg, '/')[2], split(rg, '/')[4])
    params: {
      name: name
      policyAssignmentIdentityId: policyAssignmentIdentityId
      roleDefinitionId: roleDefinitionId
    }
  }
]
