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
type scheduleInfoType = {
  @sys.description('Optional. The expiry information for the role eligibility.')
  expiration: scheduleInfoExpirationType?

  @sys.description('Optional. Start DateTime of the role eligibility assignment.')
  startDateTime: string?
}

@export()
type scheduleInfoExpirationType = {
  @sys.description('Optional. Duration of the role eligibility assignment in TimeSpan format. Example: P365D, P2H')
  duration: string?

  @sys.description('Optional. End DateTime of the role eligibility assignment.')
  endDateTime: string?

  @sys.description('Optional. Type of the role eligibility assignment expiration.')
  type: 'AfterDateTime' | 'AfterDuration' | 'NoExpiration'?
}

@export()
type ticketInfoType = {
  @sys.description('Optional. The ticket number for the role eligibility assignment.')
  ticketNumber: string?

  @sys.description('Optional. The ticket system name for the role eligibility assignment.')
  ticketSystem: string?
}?
