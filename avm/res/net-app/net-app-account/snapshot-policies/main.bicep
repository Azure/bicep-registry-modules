metadata name = 'Azure NetApp Files Snapshot Policy'
metadata description = 'This module deploys a Snapshot Policy for an Azure NetApp File.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Required. The name of the snapshot policy.')
param snapshotPolicyName string

@description('Optional. The location of the snapshot policy.')
param snapshotPolicyLocation string = resourceGroup().location

@description('Required. The daily snapshot hour.')
param dailyHour int

@description('Required. The daily snapshot minute.')
param dailyMinute int

@description('Required. Daily snapshot count to keep.')
param dailySnapshotsToKeep int

@description('Required. Daily snapshot used bytes.')
param dailyUsedBytes int

@description('Required. The hourly snapshot minute.')
param hourlyMinute int

@description('Required. Hourly snapshot count to keep.')
param hourlySnapshotsToKeep int

@description('Required. Hourly snapshot used bytes.')
param hourlyUsedBytes int

@description('Required. The monthly snapshot day.')
param daysOfMonth string

@description('Required. The monthly snapshot hour.')
param monthlyHour int

@description('Required. The monthly snapshot minute.')
param monthlyMinute int

@description('Required. Monthly snapshot count to keep.')
param monthlySnapshotsToKeep int

@description('Required. Monthly snapshot used bytes.')
param monthlyUsedBytes int

@description('Required. The weekly snapshot day.')
param weeklyDay string

@description('Required. The weekly snapshot hour.')
param weeklyHour int

@description('Required. The weekly snapshot minute.')
param weeklyMinute int

@description('Required. Weekly snapshot count to keep.')
param weeklySnapshotsToKeep int

@description('Required. Weekly snapshot used bytes.')
param weeklyUsedBytes int

@description('Optional. Indicates whether the snapshot policy is enabled.')
param snapEnabled bool = true

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2024-03-01' existing = {
  name: netAppAccountName
}

resource snapshotPolicies 'Microsoft.NetApp/netAppAccounts/snapshotPolicies@2024-03-01' = if (snapEnabled) {
  name: snapshotPolicyName
  parent: netAppAccount
  location: snapshotPolicyLocation
  properties: {
    enabled: snapEnabled
    dailySchedule: {
      hour: dailyHour
      minute: dailyMinute
      snapshotsToKeep: dailySnapshotsToKeep
      usedBytes: dailyUsedBytes
    }
    hourlySchedule: {
      minute: hourlyMinute
      snapshotsToKeep: hourlySnapshotsToKeep
      usedBytes: hourlyUsedBytes
    }
    monthlySchedule: {
      daysOfMonth: daysOfMonth
      hour: monthlyHour
      minute: monthlyMinute
      snapshotsToKeep: monthlySnapshotsToKeep
      usedBytes: monthlyUsedBytes
    }
    weeklySchedule: {
      day: weeklyDay
      hour: weeklyHour
      minute: weeklyMinute
      snapshotsToKeep: weeklySnapshotsToKeep
      usedBytes: weeklyUsedBytes
    }
  }
}

@description('The resource IDs of the snapshot Policy created within volume.')
output resourceId string = snapshotPolicies.id

@description('The name of the Backup Policy.')
output name string = snapshotPolicies.name

@description('The name of the Resource Group the Snapshot was created in.')
output resourceGroupName string = resourceGroup().name
