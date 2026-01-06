metadata name = 'Azure NetApp Files Snapshot Policy'
metadata description = 'This module deploys a Snapshot Policy for an Azure NetApp File.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. The name of the snapshot policy.')
param name string = 'snapshotPolicy'

@description('Optional. The location of the snapshot policy.')
param location string = resourceGroup().location

@description('Optional. Schedule for hourly snapshots.')
param hourlySchedule hourlyScheduleType?

@description('Optional. Schedule for daily snapshots.')
param dailySchedule dailyScheduleType?

@description('Optional. Schedule for monthly snapshots.')
param monthlySchedule monthlyScheduleType?

@description('Optional. Schedule for weekly snapshots.')
param weeklySchedule weeklyScheduleType?

@description('Optional. Indicates whether the snapshot policy is enabled.')
param snapEnabled bool = false

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2025-01-01' existing = {
  name: netAppAccountName
}

resource snapshotPolicies 'Microsoft.NetApp/netAppAccounts/snapshotPolicies@2025-01-01' = {
  name: name
  parent: netAppAccount
  location: location
  properties: {
    enabled: snapEnabled
    dailySchedule: dailySchedule
    hourlySchedule: hourlySchedule
    monthlySchedule: monthlySchedule
    weeklySchedule: weeklySchedule
  }
}

@description('The resource IDs of the snapshot Policy created within volume.')
output resourceId string = snapshotPolicies.id

@description('The name of the Backup Policy.')
output name string = snapshotPolicies.name

@description('The name of the Resource Group the Snapshot was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type for a daily schedule for the snapshot policy.')
type dailyScheduleType = {
  @description('Required. The daily snapshot hour.')
  @minValue(0)
  @maxValue(23)
  hour: int

  @description('Required. The daily snapshot minute.')
  @minValue(0)
  @maxValue(59)
  minute: int

  @description('Required. Daily snapshot count to keep.')
  @minValue(1)
  @maxValue(255)
  snapshotsToKeep: int

  @description('Optional. Resource size in bytes, current storage usage for the volume in bytes.')
  usedBytes: int?
}

@export()
@description('The type for an hourly schedule for the snapshot policy.')
type hourlyScheduleType = {
  @description('Required. The hourly snapshot minute.')
  @minValue(0)
  @maxValue(59)
  minute: int

  @description('Required. Hourly snapshot count to keep.')
  @minValue(1)
  @maxValue(255)
  snapshotsToKeep: int

  @description('Optional. Resource size in bytes, current storage usage for the volume in bytes.')
  usedBytes: int?
}

@export()
@description('The type for a weekly schedule for the snapshot policy.')
type weeklyScheduleType = {
  @description('Required. The weekly snapshot day.')
  day: ('Sunday' | 'Monday' | 'Tuesday' | 'Wednesday' | 'Thursday' | 'Friday' | 'Saturday')

  @description('Required. The weekly snapshot hour.')
  @minValue(0)
  @maxValue(23)
  hour: int

  @description('Required. The weekly snapshot minute.')
  @minValue(0)
  @maxValue(59)
  minute: int

  @description('Required. Weekly snapshot count to keep.')
  @minValue(1)
  @maxValue(255)
  snapshotsToKeep: int

  @description('Optional. Resource size in bytes, current storage usage for the volume in bytes.')
  usedBytes: int?
}

@export()
@description('The type for a monthly schedule for the snapshot policy.')
type monthlyScheduleType = {
  @description('Required. Indicates which days of the month snapshot should be taken. A comma delimited string. E.g., \'10,11,12\'.')
  daysOfMonth: string

  @description('Required. The monthly snapshot hour.')
  @minValue(0)
  @maxValue(23)
  hour: int

  @description('Required. The monthly snapshot minute.')
  @minValue(0)
  @maxValue(59)
  minute: int

  @description('Required. Monthly snapshot count to keep.')
  @minValue(1)
  @maxValue(255)
  snapshotsToKeep: int

  @description('Optional. Resource size in bytes, current storage usage for the volume in bytes.')
  usedBytes: int?
}
