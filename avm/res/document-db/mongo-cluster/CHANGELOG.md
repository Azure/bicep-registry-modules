# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/document-db/mongo-cluster/CHANGELOG.md).

## 0.4.3

### Changes

- Add `publicNetworkAccess` parameter to enable or disable public network access.
- Updated API & module references to latest
- Update the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

### Breaking Changes

- None

## 0.4.2

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.4.1

### Changes

- Regenerate main.json with latest bicep version 0.36.177.2456
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.4.0

### Changes

- Initial version

### Breaking Changes

- None
