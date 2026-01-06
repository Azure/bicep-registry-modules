# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/firewall-policy/CHANGELOG.md).

## 0.3.4

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.3.3

### Changes

- Allowed DNS servers to be provided and set without enabling DNS proxy. Fixing issue [6071](https://github.com/Azure/bicep-registry-modules/issues/6071).

### Breaking Changes

- None

## 0.3.2

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.3.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
