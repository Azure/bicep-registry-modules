# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/db-for-postgre-sql/flexible-server/CHANGELOG.md).

## 0.13.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `administrators` & `firewallRules` parameters
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.13.0

### Changes

- Bugfix: Fixed issue where the incorrect database ownership was set during initial deployment of DB for Postgre SQL Flexible Server.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.12.1

### Changes

- Bugfix: Fixed issue where setting `highAvailability` to `Disabled`, the deployment would throw an error due to an incorrect module-internal logic.
- Updated diverse API versions

### Breaking Changes

- None

## 0.12.0

### Changes

- Initial version

### Breaking Changes

- None
