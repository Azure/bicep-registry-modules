targetScope = 'managementGroup'
metadata name = 'PIM Role Assignments (Subscription scope)'
metadata description = 'This module deploys a PIM Role Assignment at a Subscription scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimsubmax'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    principalId: ''
    roleDefinitionIdOrName: 'Reader'
    requestType: 'AdminAssign'
    scheduleInfo: {
      expiration: {
        duration: 'P1H'
        type: 'AfterDuration'
      }
    }
    justification: 'Justification for role assignment'
    ticketInfo: {
      ticketNumber: '21312'
      ticketSystem: ' System2'
    }
    location: resourceLocation
    subscriptionId: subscriptionId
  }
}
