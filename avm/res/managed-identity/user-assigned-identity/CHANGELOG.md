# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/managed-identity/user-assigned-identity/CHANGELOG.md).

## 0.5.0

### Changes

- Added `isolationScope` optional parameter to configure regional restrictions on identity assignment. Accepts values: 'None' or 'Regional'.

### Breaking Changes

- None

## 0.4.3

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.4.2

### Changes

- Added type to `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.4.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
