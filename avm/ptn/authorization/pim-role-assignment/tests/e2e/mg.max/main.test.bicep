targetScope = 'managementGroup'
metadata name = 'PIM Role Assignments (Management Group scope)'
metadata description = 'This module deploys a PIM Role Assignment at a Management Group scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimmgmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'userPrinicipalId\'.')
@secure()
param userPrinicipalId string = ''

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${namePrefix}-${serviceShort}'
  params: {
    principalId: userPrinicipalId
    roleDefinitionIdOrName: 'Contributor'
    requestType: 'AdminAssign'
    location: resourceLocation
    scheduleInfo: {
      expiration: {
        type: 'AfterDateTime'
      }
      startDateTime: '2025-01-23T12:39:44Z'
    }
    justification: 'Justification for the role eligibility'
    ticketInfo: {
      ticketNumber: '123456'
      ticketSystem: 'system1'
    }
  }
}
