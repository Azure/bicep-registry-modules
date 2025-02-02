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
