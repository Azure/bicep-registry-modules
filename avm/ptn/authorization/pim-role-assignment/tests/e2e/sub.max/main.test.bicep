targetScope = 'managementGroup'
metadata name = 'PIM Active permenant Role Assignments (Subscription scope)'
metadata description = 'This module deploys a PIM Active permenant Role Assignment at a Subscription scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimsubmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'userPrinicipalId\'.')
@secure()
param userPrinicipalId string = ''

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}-${namePrefix}'
  params: {
    principalId: userPrinicipalId
    roleDefinitionIdOrName: 'Reader'
    requestType: 'AdminAssign'
    pimRoleAssignmentType: {
      roleAssignmentType: 'Active'
      scheduleInfo: {
        durationType: 'NoExpiration'
      }
    }
    justification: 'AVM test'
    ticketInfo: {
      ticketNumber: '21312'
      ticketSystem: ' System2'
    }
    location: resourceLocation
    subscriptionId: subscriptionId
  }
}
