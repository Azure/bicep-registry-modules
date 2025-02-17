targetScope = 'managementGroup'
metadata name = ' PIM Eligible Role Assignments (Management Group scope)'
metadata description = 'This module deploys a PIM Eligible Role Assignment at a Management Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'papmgl'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-testUserObjectId\'.')
@secure()
param testUserObjectId string = ''

@description('Optional. The start date and time for the role assignment. Defaults to the current date and time.')
param startDateTime string = utcNow()

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}-${namePrefix}'
  params: {
    pimRoleAssignmentType: {
      roleAssignmentType: 'Eligible'
      scheduleInfo: {
        duration: 'PT4H'
        durationType: 'AfterDuration'
        startTime: startDateTime
      }
    }
    principalId: testUserObjectId
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: 'Role Based Access Control Administrator'
    location: resourceLocation
    justification: 'AVM test'
  }
}
