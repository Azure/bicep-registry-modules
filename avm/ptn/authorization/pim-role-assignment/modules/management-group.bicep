metadata name = ' PIM Role Assignments (Management Group scope)'
metadata description = 'This module deploys a PIM Role Assignment at a Management Group scope.'

targetScope = 'managementGroup'

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@description('Required. The type of the PIM role assignment whether its active or eligible.')
param pimRoleAssignmentType pimRoleAssignmentTypeType

@sys.description('Optional. The justification for the role eligibility.')
param justification string = ''

@sys.description('Required. The type of the role assignment eligibility request.')
param requestType requestTypeType

@sys.description('Optional. The resultant role eligibility assignment id or the role eligibility assignment id being updated.')
param targetRoleEligibilityScheduleId string = ''

@sys.description('Optional. The role eligibility assignment instance id being updated.')
param targetRoleEligibilityScheduleInstanceId string = ''

@sys.description('Optional. The resultant role assignment schedule id or the role assignment schedule id being updated.')
param targetRoleAssignmentScheduleId string = ''

@sys.description('Optional. The role assignment schedule instance id being updated.')
param targetRoleAssignmentScheduleInstanceId string = ''

@sys.description('Optional. Ticket Info of the role eligibility.')
param ticketInfo ticketInfoType?

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string?

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0".')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Management Group Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ac63b705-f282-497d-ac71-919bf39d939d'
  )
}

var roleDefinitionIdVar = (builtInRoleNames[?roleDefinitionIdOrName] ?? roleDefinitionIdOrName)

resource pimEligibleRoleAssignment 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = if (pimRoleAssignmentType.roleAssignmentType == 'Eligible') {
  name: guid(deployment().name, managementGroupId, roleDefinitionIdVar, principalId)
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionIdVar
    requestType: requestType
    condition: condition
    conditionVersion: conditionVersion
    justification: justification
    targetRoleEligibilityScheduleId: targetRoleEligibilityScheduleId
    targetRoleEligibilityScheduleInstanceId: targetRoleEligibilityScheduleInstanceId
    ticketInfo: ticketInfo
    scheduleInfo: pimRoleAssignmentType.scheduleInfo.durationType == 'NoExpiration'
      ? {
          expiration: {
            type: 'NoExpiration'
          }
        }
      : pimRoleAssignmentType.scheduleInfo.durationType == 'AfterDuration'
          ? {
              expiration: {
                type: 'AfterDuration'
                duration: pimRoleAssignmentType.scheduleInfo.duration
              }
              startDateTime: pimRoleAssignmentType.scheduleInfo.startTime
            }
          : pimRoleAssignmentType.scheduleInfo.durationType == 'AfterDateTime'
              ? {
                  expiration: {
                    type: 'AfterDateTime'
                    endDateTime: pimRoleAssignmentType.scheduleInfo.endDateTime
                  }
                  startDateTime: pimRoleAssignmentType.scheduleInfo.startTime
                }
              : null
  }
}

resource pimActiveRoleAssignment 'Microsoft.Authorization/roleAssignmentScheduleRequests@2022-04-01-preview' = if (pimRoleAssignmentType.roleAssignmentType == 'Active') {
  name: guid(deployment().name, managementGroupId, roleDefinitionIdVar, principalId)
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionIdVar
    requestType: requestType
    condition: !empty(condition) ? condition : null
    conditionVersion: conditionVersion
    justification: justification
    targetRoleAssignmentScheduleId: targetRoleAssignmentScheduleId
    targetRoleAssignmentScheduleInstanceId: targetRoleAssignmentScheduleInstanceId
    ticketInfo: ticketInfo
    scheduleInfo: pimRoleAssignmentType.scheduleInfo.durationType == 'NoExpiration'
      ? {
          expiration: {
            type: 'NoExpiration'
          }
        }
      : pimRoleAssignmentType.scheduleInfo.durationType == 'AfterDuration'
          ? {
              expiration: {
                type: 'AfterDuration'
                duration: pimRoleAssignmentType.scheduleInfo.duration
              }
              startDateTime: pimRoleAssignmentType.scheduleInfo.startTime
            }
          : pimRoleAssignmentType.scheduleInfo.durationType == 'AfterDateTime'
              ? {
                  expiration: {
                    type: 'AfterDateTime'
                    endDateTime: pimRoleAssignmentType.scheduleInfo.endDateTime
                  }
                  startDateTime: pimRoleAssignmentType.scheduleInfo.startTime
                }
              : null
  }
}

@sys.description('The GUID of the PIM Role Assignment.')
output name string = pimRoleAssignmentType.roleAssignmentType == 'Eligible'
  ? pimEligibleRoleAssignment.name
  : pimActiveRoleAssignment.name

@sys.description('The resource ID of the PIM Role Assignment.')
output resourceId string = pimRoleAssignmentType.roleAssignmentType == 'Eligible'
  ? pimEligibleRoleAssignment.id
  : pimActiveRoleAssignment.id

@sys.description('The scope this PIM Role Assignment applies to.')
output scope string = az.resourceId('Microsoft.Management/managementGroups', managementGroupId)

// ================ //
// Definitions      //
// ================ //

@export()
@sys.description('Optional. The request type of the role assignment.')
type requestTypeType =
  | 'AdminAssign'
  | 'AdminExtend'
  | 'AdminRemove'
  | 'AdminRenew'
  | 'AdminUpdate'
  | 'SelfActivate'
  | 'SelfDeactivate'
  | 'SelfExtend'
  | 'SelfRenew'

@export()
type ticketInfoType = {
  @sys.description('Optional. The ticket number for the role eligibility assignment.')
  ticketNumber: string?

  @sys.description('Optional. The ticket system name for the role eligibility assignment.')
  ticketSystem: string?
}?

@export()
@discriminator('roleAssignmentType')
@description('Optional. The type of the PIM role assignment whether its active or eligible.')
type pimRoleAssignmentTypeType = pimActiveRoleAssignmentType | pimEligibleRoleAssignmentType

type pimActiveRoleAssignmentType = {
  @description('Required. The type of the role assignment.')
  roleAssignmentType: 'Active'

  @description('Optional. The linked role eligibility schedule id - to activate an eligibility.')
  linkedRoleEligibilityScheduleId: string?

  @description('Optional. The resultant role assignment schedule id or the role assignment schedule id being updated.')
  targetRoleAssignmentScheduleId: string?

  @description('Optional. The role assignment schedule instance id being updated.')
  targetRoleAssignmentScheduleInstanceId: string?

  @description('Required. The schedule information for the role assignment.')
  scheduleInfo: roleAssignmentScheduleType
}

type pimEligibleRoleAssignmentType = {
  @description('Required. The type of the role assignment.')
  roleAssignmentType: 'Eligible'

  @description('Optional. The resultant role eligibility schedule id or the role eligibility schedule id being updated.')
  targetRoleEligibilityScheduleId: string?

  @description('Optional. The role eligibility assignment instance id being updated.')
  targetRoleEligibilityScheduleInstanceId: string?

  @description('Required. The schedule information for the role assignment.')
  scheduleInfo: roleAssignmentScheduleType
}

@discriminator('durationType')
@description('Optional. The schedule information for the role assignment.')
type roleAssignmentScheduleType =
  | permenantRoleAssignmentScheduleType
  | timeBoundDurationRoleAssignmentScheduleType
  | timeBoundDateTimeRoleAssignmentScheduleType

type permenantRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'NoExpiration'
}

type timeBoundDurationRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'AfterDuration'

  @description('Required. The duration for the role assignment.')
  duration: string

  @description('Required. The start time for the role assignment.')
  startTime: string
}

type timeBoundDateTimeRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'AfterDateTime'

  @description('Required. The end date and time for the role assignment.')
  endDateTime: string

  @description('Required. The start date and time for the role assignment.')
  startTime: string
}
