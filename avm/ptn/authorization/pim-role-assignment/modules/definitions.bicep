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
type pimRoleAssignmentTypeType = pimActiveRoleAssignmentType | pimEligibleRoleAssignmentType

type pimActiveRoleAssignmentType = {
  roleAssignmentType: 'Active'
  linkedRoleEligibilityScheduleId: string?
  targetRoleAssignmentScheduleId: string?
  targetRoleAssignmentScheduleInstanceId: string?
  scheduleInfo: roleAssignmentScheduleType
}

type pimEligibleRoleAssignmentType = {
  roleAssignmentType: 'Eligible'
  targetRoleEligibilityScheduleId: string?
  targetRoleEligibilityScheduleInstanceId: string?
  scheduleInfo: roleAssignmentScheduleType
}

@discriminator('durationType')
type roleAssignmentScheduleType =
  | permenantRoleAssignmentScheduleType
  | timeBoundDurationRoleAssignmentScheduleType
  | timeBoundDateTimeRoleAssignmentScheduleType

type permenantRoleAssignmentScheduleType = {
  durationType: 'NoExpiration'
}

type timeBoundDurationRoleAssignmentScheduleType = {
  durationType: 'AfterDuration'
  duration: string
  startTime: string
}

type timeBoundDateTimeRoleAssignmentScheduleType = {
  durationType: 'AfterDateTime'
  endDateTime: string
  startTime: string
}
