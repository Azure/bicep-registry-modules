# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/network-watcher/CHANGELOG.md).

## 0.5.0

### Changes

- Added types for `tags`, `connectionMonitors` & `flowLogs` parameters
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated the API Versions to latest `2024-10-01`
- Added support for
  - `connectionMonitors.autoStart`
  - `connectionMonitors.destination`
  - `connectionMonitors.monitoringIntervalInSeconds`
  - `connectionMonitors.notes`
  - `connectionMonitors.source`
  - `flowLogs.enabledFilteringCriteria`

### Breaking Changes

- Renamed `flowLogs.storageId` to AVM-aligned `flowLogs.storageResourceId`

## 0.4.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
