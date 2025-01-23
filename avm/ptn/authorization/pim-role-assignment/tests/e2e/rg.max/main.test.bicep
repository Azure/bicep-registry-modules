targetScope = 'managementGroup'
metadata name = 'PIM Role Assignments (Resource Group)'
metadata description = 'This module deploys a PIM Role Assignment at a Resource Group scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pimrgmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.pimroleassignments-${serviceShort}-rg'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

@description('Optional. The dateTime of the role assignment eligibility.')
param startTime string = utcNow()

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
    principalId: ''
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
    location: resourceLocation
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroup.outputs.name
    requestType: 'AdminAssign'
    scheduleInfo: {
      expiration: {
        type: 'AfterDateTime'
      }
      startDateTime: startTime
    }
    justification: 'Justification for role eligibility'
    ticketInfo: {
      ticketNumber: '32423'
      ticketSystem: 'system12'
    }
  }
}
