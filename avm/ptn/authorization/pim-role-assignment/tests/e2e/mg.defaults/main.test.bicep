targetScope = 'managementGroup'
metadata name = ' PIM Eligible Role Assignments (Management Group scope)'
metadata description = 'This module deploys a PIM Eligible Role Assignment at a Management Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimmgmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'userPrinicipalId\'.')
@secure()
param userPrinicipalId string = ''

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
        duration: 'P10D'
        durationType: 'AfterDuration'
        startTime: startDateTime
      }
    }
    principalId: userPrinicipalId
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: 'User Access Administrator'
    location: resourceLocation
  }
}
