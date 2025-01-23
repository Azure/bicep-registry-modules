metadata name = 'PIM Role Assignments (Resource Group scope)'
metadata description = 'This module deploys a PIM Role Assignment at a Resource Group scope.'

targetScope = 'resourceGroup'

import { requestTypeType, scheduleInfoType, scheduleInfoExpirationType, ticketInfoType } from 'definitions.bicep'

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Name of the Resource Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param resourceGroupName string = resourceGroup().name

@sys.description('Optional. Subscription ID of the subscription to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param subscriptionId string = subscription().subscriptionId

@sys.description('Optional. The justification for the role eligibility.')
param justification string = ''

@sys.description('Required. The type of the role assignment eligibility request.')
param requestType requestTypeType

@sys.description('Optional. The resultant role eligibility assignment id or the role eligibility assignment id being updated.')
param targetRoleEligibilityScheduleId string = ''

@sys.description('Optional. The role eligibility assignment instance id being updated.')
param targetRoleEligibilityScheduleInstanceId string = ''

@sys.description('Optional. Ticket Info of the role eligibility.')
param ticketInfo ticketInfoType?

@sys.description('Optional. Schedule info of the role eligibility assignment.')
param scheduleInfo scheduleInfoType

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string = ''

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0".')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
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

resource pimRoleAssignment 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = {
  name: guid(subscriptionId, resourceGroupName, roleDefinitionIdVar, principalId)
  properties: {
    roleDefinitionId: roleDefinitionIdVar
    principalId: principalId
    requestType: requestType
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    condition: !empty(condition) ? condition : null
    justification: justification
    scheduleInfo: scheduleInfo
    targetRoleEligibilityScheduleId: targetRoleEligibilityScheduleId
    targetRoleEligibilityScheduleInstanceId: targetRoleEligibilityScheduleInstanceId
    ticketInfo: ticketInfo
  }
}

@sys.description('The GUID of the PIM Role Assignment.')
output name string = pimRoleAssignment.name

@sys.description('The resource ID of the PIM Role Assignment.')
output resourceId string = pimRoleAssignment.id

@sys.description('The name of the resource group the PIM role assignment was applied at.')
output resourceGroupName string = resourceGroup().name

@sys.description('The scope this PIM Role Assignment applies to.')
output scope string = resourceGroup().id
