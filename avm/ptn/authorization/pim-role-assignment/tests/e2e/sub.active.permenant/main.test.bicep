targetScope = 'managementGroup'
metadata name = 'PIM Active permanent Role Assignments (Subscription scope)'
metadata description = 'This module deploys a PIM permanent Role Assignment at a Subscription scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimsubmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-testUserObjectId\'.')
@secure()
param testUserObjectId string = ''

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}-${namePrefix}'
  params: {
    principalId: testUserObjectId
    roleDefinitionIdOrName: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    )
    subscriptionId: subscriptionId
    requestType: 'AdminAssign'
    pimRoleAssignmentType: {
      roleAssignmentType: 'Active'
      scheduleInfo: {
        durationType: 'NoExpiration'
      }
    }
    justification: 'AVM test'
  }
}
