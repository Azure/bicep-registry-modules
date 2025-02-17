targetScope = 'managementGroup'
metadata name = 'PIM Active Role Assignments (Resource Group)'
metadata description = 'This module deploys a PIM Active Role Assignment at a Resource Group scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'paprga'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.pimroleassignments-${serviceShort}-rg'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

@description('Optional. The start date and time for the role assignment. Defaults to the current date and time.')
param startDateTime string = utcNow()

@description('Optional. The end date and time for the role assignment. Defaults to one year from the start date and time.')
param endDateTime string = dateTimeAdd(startDateTime, 'PT4H')

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-testUserObjectId\'.')
@secure()
param testUserObjectId string = ''

// General resources
// =================
module resourceGroup 'br/public:avm/res/resources/resource-group:0.2.3' = {
  scope: subscription('${subscriptionId}')
  name: '${uniqueString(deployment().name, resourceLocation)}-resourceGroup'
  params: {
    name: resourceGroupName
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    principalId: testUserObjectId
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    location: resourceLocation
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroup.outputs.name
    requestType: 'AdminAssign'
    pimRoleAssignmentType: {
      roleAssignmentType: 'Active'
      scheduleInfo: {
        durationType: 'AfterDateTime'
        endDateTime: endDateTime
        startTime: startDateTime
      }
    }
    justification: 'AVM test'
    ticketInfo: {
      ticketNumber: '32423'
      ticketSystem: 'system12'
    }
  }
}
