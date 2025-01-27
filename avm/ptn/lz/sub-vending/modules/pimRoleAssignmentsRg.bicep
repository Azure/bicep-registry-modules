metadata name = 'Pim Role Assignments (Resource Group scope)'
metadata description = 'This module deploys a Role Assignment at a Resource Group scope.'

targetScope = 'resourceGroup'

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Name of the Resource Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param resourceGroupName string = resourceGroup().name

@sys.description('Optional. Subscription ID of the subscription to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param subscriptionId string = subscription().subscriptionId

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string = ''

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0".')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

param justification string = ''

param duration string = ''

param endDateTime string = ''

param expirationType string = ''

param startDateTime string = ''

param ticketNumber string = ''

param ticketSystem string = ''

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var roleDefinitionIdVar = (builtInRoleNames[?roleDefinitionIdOrName] ?? roleDefinitionIdOrName)

resource roleAssignment 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = {
  name: guid(subscriptionId, resourceGroupName, roleDefinitionIdVar, principalId)
  properties: {
    principalId: principalId
    requestType: 'AdminAssign'
    roleDefinitionId: roleDefinitionIdVar
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    condition: !empty(condition) ? condition : null
    justification: justification
    scheduleInfo: {
      expiration: {
        duration: duration
        endDateTime: endDateTime
        type: expirationType
      }
      startDateTime: startDateTime
    }
    ticketInfo: {
      ticketNumber: ticketNumber
      ticketSystem: ticketSystem
    }
  }
}

@sys.description('The GUID of the Role Assignment.')
output name string = roleAssignment.name

@sys.description('The resource ID of the Role Assignment.')
output resourceId string = roleAssignment.id

@sys.description('The name of the resource group the role assignment was applied at.')
output resourceGroupName string = resourceGroup().name

@sys.description('The scope this Role Assignment applies to.')
output scope string = resourceGroup().id
