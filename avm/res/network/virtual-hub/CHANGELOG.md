# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/virtual-hub/CHANGELOG.md).

## 0.4.3

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.
- Update API versions to 2025-01-01
- Added additional resource derived types

### Breaking Changes

- None

## 0.4.2

### Changes

- Updated all resource API versions to where available to address lint warnings.

### Breaking Changes

- None

## 0.4.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.4.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
