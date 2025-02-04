targetScope = 'managementGroup'
metadata name = 'PIM Eligible Role Assignments (Subscription scope)'
metadata description = 'This module deploys a PIM Eligible Role Assignment at a Subscription scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimsubmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'userPrinicipalId\'.')
@secure()
param userPrinicipalId string = ''

@description('Optional. The start date and time for the role assignment. Defaults to the current date and time.')
param startDateTime string = utcNow()

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}-${namePrefix}'
  params: {
    principalId: userPrinicipalId
    roleDefinitionIdOrName: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    )
    subscriptionId: subscriptionId
    requestType: 'AdminAssign'
    pimRoleAssignmentType: {
      roleAssignmentType: 'Eligible'
      scheduleInfo: {
        duration: 'P3H'
        durationType: 'AfterDuration'
        startTime: startDateTime
      }
    }
    justification: 'AVM test'
  }
}
