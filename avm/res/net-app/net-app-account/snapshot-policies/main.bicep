metadata name = 'Azure NetApp Files Snapshot Policy'
metadata description = 'This module deploys a Snapshot Policy for an Azure NetApp File.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. The name of the snapshot policy.')
param name string = 'snapshotPolicy'

@description('Optional. The location of the snapshot policy.')
param location string = resourceGroup().location

@description('Optional. Schedule for daily snapshots.')
param dailySchedule dailyScheduleType = {
  hour: 0
  minute: 0
  snapshotsToKeep: 0
  usedBytes: 0
}

@description('Optional. Schedule for hourly snapshots.')
param hourlySchedule hourlyScheduleType = {
  minute: 0
  snapshotsToKeep: 0
  usedBytes: 0
}

@description('Optional. Schedule for monthly snapshots.')
param monthlySchedule monthlyScheduleType = {
  daysOfMonth: ''
  hour: 0
  minute: 0
  snapshotsToKeep: 0
  usedBytes: 0
}

@description('Optional. Schedule for weekly snapshots.')
param weeklySchedule weeklyScheduleType = {
  day: ''
  hour: 0
  minute: 0
  snapshotsToKeep: 0
  usedBytes: 0
}

@description('Optional. Indicates whether the snapshot policy is enabled.')
param snapEnabled bool = false

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2024-03-01' existing = {
  name: netAppAccountName
}

resource snapshotPolicies 'Microsoft.NetApp/netAppAccounts/snapshotPolicies@2024-03-01' = {
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
type dailyScheduleType = {
  @description('Optional. The daily snapshot hour.')
  hour: int?

  @description('Optional. The daily snapshot minute.')
  minute: int?

  @description('Optional. Daily snapshot count to keep.')
  snapshotsToKeep: int?

  @description('Optional. Daily snapshot used bytes.')
  usedBytes: int?
}

@export()
type hourlyScheduleType = {
  @description('Optional. The hourly snapshot minute.')
  minute: int?

  @description('Optional. Hourly snapshot count to keep.')
  snapshotsToKeep: int?

  @description('Optional. Hourly snapshot used bytes.')
  usedBytes: int?
}

@export()
type monthlyScheduleType = {
  @description('Optional. The monthly snapshot day.')
  daysOfMonth: string?

  @description('Optional. The monthly snapshot hour.')
  hour: int?

  @description('Optional. The monthly snapshot minute.')
  minute: int?

  @description('Optional. Monthly snapshot count to keep.')
  snapshotsToKeep: int?

  @description('Optional. Monthly snapshot used bytes.')
  usedBytes: int?
}

@export()
type weeklyScheduleType = {
  @description('Optional. The weekly snapshot day.')
  day: string?

  @description('Optional. The weekly snapshot hour.')
  hour: int?

  @description('Optional. The weekly snapshot minute.')
  minute: int?

  @description('Optional. Weekly snapshot count to keep.')
  snapshotsToKeep: int?

  @description('Optional. Weekly snapshot used bytes.')
  usedBytes: int?
}
